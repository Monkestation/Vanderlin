GLOBAL_LIST_EMPTY(custom_fermentation_recipes)

/obj/structure/fermentation_keg
	name = "fermentation keg"
	desc = "A simple keg that is meant for making fermented goods and drinks."

	icon = 'icons/obj/brewing.dmi'
	icon_state = "barrel_tapless_open" // open icon state

	density = TRUE
	anchored = FALSE

	sellprice = 15 // so you can sell the keg directly

	/// The sound of fermentation
	var/datum/looping_sound/boiling/soundloop
	var/closed_icon_state = "barrel_tapless"
	var/ready_icon_state = "barrel_tapless_ready"
	var/tapped_icon_state = "barrel_tapped_ready"

	//After brewing we can sell or bottle, this is for the latter
	var/ready_to_bottle = FALSE
	var/brewing = FALSE

	///our currently added crops
	var/list/recipe_crop_stocks
	///our currently selected recipe
	var/datum/brewing_recipe/selected_recipe

	/// When the recipe starts aging
	var/age_start_time = 0

	/// Allows for direct transfer of recipe reagent out of keg.
	var/tapped = FALSE

	var/selecting_recipe = FALSE

	var/heated = FALSE
	///machines heat in kelvin
	var/heat = 300
	///When the recipe starts
	var/start_time
	///our brew progress time
	var/heated_progress_time
	///when our heat can decay
	var/heat_decay = 0
	///How many times have we done this recipe
	var/recipe_completions = 0
	///Brewing end timer
	var/brew_timer
	///our last user
	var/mob/last_user

/obj/structure/fermentation_keg/Initialize()
	. = ..()
	create_reagents(900, NO_REACT | AMOUNT_VISIBLE | REFILLABLE | DRAINABLE) //on agv it should be 120u for water then rest can be other needed chemicals
	recipe_crop_stocks = list()

	soundloop = new(src, brewing)

	if(heated)
		START_PROCESSING(SSobj, src)

/obj/structure/fermentation_keg/Destroy()
	if(soundloop)
		QDEL_NULL(soundloop)
	if(selected_recipe)
		QDEL_NULL(selected_recipe)
	recipe_crop_stocks.Cut()
	last_user = null
	return ..()

/obj/structure/fermentation_keg/update_overlays()
	. = ..()
	if(!reagents?.total_volume)
		return

	if(icon_state != initial(icon_state))
		return
	var/used_alpha = mix_alpha_from_reagents(reagents.reagent_list)
	. += mutable_appearance(
		icon,
		"filling",
		color = mix_color_from_reagents(reagents.reagent_list),
		alpha = used_alpha,
	)
	var/datum/reagent/master = reagents.get_master_reagent()
	if(master?.glows)
		. += emissive_appearance(icon, "filling", alpha = used_alpha)

/obj/structure/fermentation_keg/attack_hand_secondary(mob/user, list/modifiers)
	. = ..()
	if(. == SECONDARY_ATTACK_CANCEL_ATTACK_CHAIN)
		return
	. = SECONDARY_ATTACK_CANCEL_ATTACK_CHAIN
	if(brewing)
		to_chat(user, "You begin interrupting the brewing process.")
		if(!do_after(user, 5 SECONDS, src))
			return
		end_brew(FALSE)
		return
	if(!brewing)
		if(selected_recipe)
			if(ready_to_bottle)
				to_chat(user, span_danger("You begin canceling the recipe, making you lose track of the product!"))
				if(!do_after(user, 5 SECONDS, src))
					return
			to_chat(user, "You cancel the recipe.")
			reset_keg()
		else
			shopping_run(user)

/obj/structure/fermentation_keg/MiddleClick(mob/user, list/modifiers)
	. = ..()
	if(!Adjacent(user))
		return
	if(!brewing)
		var/response = alert(user, "What do you wish to empty?", "[src]", "Reagents only", "Everything")
		if(!response)
			return
		if(!Adjacent(user))
			return
		user.visible_message("[user] starts emptying out [src].", "You start emptying out [src].")
		if(!do_after(user, 5 SECONDS, src))
			return
		if(response == "Reagents only")
			clear_keg_reagents()
		else
			clear_keg()

/obj/structure/fermentation_keg/AltClick(mob/user, list/modifiers)
	. = ..()
	if(!user.Adjacent(src))
		return

	if(!brewing && ready_to_bottle)
		if(try_tapping(user))
			return

/obj/structure/fermentation_keg/attack_hand(mob/user)
	if((user.used_intent == /datum/intent/grab) || user.cmode)
		return ..()
	if(!selected_recipe)
		to_chat(user, span_warning("No recipe has been set yet!"))
		return ..()

	if(try_n_brew(user))
		start_brew()
		to_chat(user, span_info("[src] begins [selected_recipe.start_verb] [selected_recipe.name]."))
	..()

/obj/structure/fermentation_keg/attackby(obj/item/I, mob/user, list/modifiers)
	if(istype(I, /obj/item/reagent_containers))
		if(brewing)
			return
		if(user.used_intent.type == /datum/intent/fill)
			if(try_filling(user, I))
				return

	if(heated)
		if(istype(I, /obj/item/ore/coal) || istype(I, /obj/item/grown/log/tree))
			refuel(I, user)
			return

	if(ready_to_bottle && (selected_recipe.brewed_item || (selected_recipe.brewed_amount && !tapped)))
		if(selected_recipe.after_finish_attackby(user, I, src))
			create_items(user, I)
			return

	var/list/produce_list = list()
	var/list/storage_list = list()

	if(I.type in selected_recipe?.needed_items)
		produce_list |= I

	if(I.type in selected_recipe?.needed_crops)
		produce_list |= I

	if(istype(I, /obj/item/storage))
		produce_list |= I.contents
		storage_list |= I.contents

	var/dumps = FALSE
	for(var/obj/item/reagent_containers/food/snacks/G in produce_list)
		if(G.type in selected_recipe?.needed_crops)
			// Store quality data properly - following cooking system pattern
			var/current_amount = 0
			var/current_quality = 0
			var/current_freshness = 0

			// Check if we already have data for this crop type
			if(recipe_crop_stocks[G.type])
				if(islist(recipe_crop_stocks[G.type]))
					var/list/existing_data = recipe_crop_stocks[G.type]
					current_amount = existing_data["amount"] || 0
					current_quality = existing_data["quality"] || 0
					current_freshness = existing_data["freshness"] || 0
				else
					current_amount = recipe_crop_stocks[G.type]

			// Get quality and freshness from the crop (matching cooking system)
			var/crop_quality = max(G.recipe_quality, 1) // Default quality
			var/crop_freshness = max(0, (G.warming + G.rotprocess)) // Default freshness

			// Calculate weighted average quality and freshness
			var/new_amount = current_amount + 1
			var/new_quality = ((current_quality * current_amount) + crop_quality) / new_amount
			var/new_freshness = ((current_freshness * current_amount) + crop_freshness) / new_amount

			// Store the data as a list
			recipe_crop_stocks[G.type] = list(
				"amount" = new_amount,
				"quality" = new_quality,
				"freshness" = new_freshness
			)

			if(G in storage_list)
				dumps = TRUE
				SEND_SIGNAL(G.loc, COMSIG_TRY_STORAGE_TAKE, G, get_turf(src), TRUE)
			qdel(G)

	for(var/obj/item/item in produce_list)
		if(item.type in selected_recipe?.needed_items)
			// Store quality data for items too
			var/current_amount = 0
			var/current_quality = 0
			var/current_freshness = 0

			if(recipe_crop_stocks[item.type])
				if(islist(recipe_crop_stocks[item.type]))
					var/list/existing_data = recipe_crop_stocks[item.type]
					current_amount = existing_data["amount"] || 0
					current_quality = existing_data["quality"] || 0
					current_freshness = existing_data["freshness"] || 0
				else
					current_amount = recipe_crop_stocks[item.type]

			var/item_quality = item.recipe_quality // Default quality
			var/item_freshness = 0 // Default freshness


			var/new_amount = current_amount + 1
			var/new_quality = ((current_quality * current_amount) + item_quality) / new_amount
			var/new_freshness = ((current_freshness * current_amount) + item_freshness) / new_amount

			recipe_crop_stocks[item.type] = list(
				"amount" = new_amount,
				"quality" = new_quality,
				"freshness" = new_freshness
			)

			if(item in storage_list)
				dumps = TRUE
				SEND_SIGNAL(item.loc, COMSIG_TRY_STORAGE_TAKE, item, get_turf(src), TRUE)
			qdel(item)

	if(dumps)
		user.visible_message("[user] dumps some things into [src].", "You dump some things into [src].")

	// Handle reagent containers being added to the keg
	var/selected_recipe_reagent
	var/keg_reagent_amount
	if(selected_recipe)
		selected_recipe_reagent = selected_recipe.reagent_to_brew
		keg_reagent_amount = reagents.get_reagent_amount(selected_recipe_reagent)

	. = ..()
	update_appearance(UPDATE_OVERLAYS)

	// They added the recipe reagent backk into the barrel, reset aging time
	if(selected_recipe_reagent && age_start_time && (reagents.get_reagent_amount(selected_recipe_reagent) > keg_reagent_amount))
		age_start_time = world.time

/obj/structure/fermentation_keg/examine(mob/user)
	. =..()
	if(heated)
		. += "Internal Temperature of around [heat - 271.3]C.\n"

	if(ready_to_bottle)
		var/name_to_use = selected_recipe.secondary_name ? selected_recipe.secondary_name : selected_recipe.name
		var/output = ""
		//How many are brewed
		if(recipe_completions)
			if(selected_recipe.brewed_amount)
				output = " x[selected_recipe.brewed_amount * recipe_completions]"
			else if(selected_recipe.brewed_item && selected_recipe.brewed_item_count)
				output = " x[selected_recipe.brewed_item_count * recipe_completions]"

		. += span_boldnotice("[name_to_use][output]")
		if(age_start_time)
			. += "Aged for [round(((world.time - age_start_time) * 0.1) / 60, 0.1)] Minutes.\n"
		if(!tapped)
			. += span_blue("Alt-Click on the Barrel to Tap it.")
		if(selected_recipe.helpful_hints)
			. += "[selected_recipe.helpful_hints]\n"
	else if(selected_recipe)
		var/name_to_use = selected_recipe.secondary_name ? selected_recipe.secondary_name : selected_recipe.name
		var/output = ""
		//How many are brewed
		if(selected_recipe.brewed_amount)
			output = " x[selected_recipe.brewed_amount * (recipe_completions+1)]"
		else if(selected_recipe.brewed_item && selected_recipe.brewed_item_count)
			output = " x[selected_recipe.brewed_item_count * (recipe_completions+1)]"

		var/message = "Currently making: [name_to_use][output]. [span_notice("Right-click to cancel.")]\n"
		//time
		if(selected_recipe.brew_time)
			if(brewing)
				message += span_info("Currently [selected_recipe.start_verb].\n")
			else
				var/multiplier = 1
				if(heated && !selected_recipe.heat_required)
					multiplier = 0.5
				if((selected_recipe.brew_time * multiplier) >= 1 MINUTES)
					message += "Once set, will take [(selected_recipe.brew_time / 600) * multiplier] Minutes.\n"
				else
					message += "Once set, will take [(selected_recipe.brew_time / 10) & multiplier] Seconds.\n"

		//How many are brewed
		if(selected_recipe.brewed_amount)
			message += "Produces [UNIT_FORM_STRING(FLOOR((selected_recipe.brewed_amount * selected_recipe.per_brew_amount), 1))] for each cycle.\n"

		if(selected_recipe.brewed_item && selected_recipe.brewed_item_count)
			message += "Produces [selected_recipe.brewed_item_count] [name_to_use] for each cycle.\n"

		if(selected_recipe.helpful_hints)
			message += "[selected_recipe.helpful_hints]\n"
		/*
		if(istype(selected_recipe, /datum/brewing_recipe/custom_recipe))
			var/datum/brewing_recipe/custom_recipe/recipe = selected_recipe
			message += "Recipe Created By:[recipe.made_by]"
		. += message
		*/
		. += message
	else
		. += span_blue("Right-Click on the Barrel to select a recipe.")
	. += span_blue("MMB-Click on [src] to dump its contents.")

/obj/structure/fermentation_keg/proc/shopping_run(mob/user)
	if(brewing)
		return
	if(selecting_recipe)
		return
	selecting_recipe = TRUE
	addtimer(VARSET_CALLBACK(src, selecting_recipe, FALSE), 5 SECONDS)

	var/list/options = list()
	for(var/datum/brewing_recipe/path as anything in subtypesof(/datum/brewing_recipe))
		if(IS_ABSTRACT(path))
			continue
		var/datum/reagent/prereq = initial(path.pre_reqs)
		if(!heated && initial(path.heat_required))
			continue
		if(!prereq || (reagents.has_reagent(prereq)))
			options[initial(path.name)] = path

	for(var/datum/brewing_recipe/recipe as anything in GLOB.custom_fermentation_recipes)
		var/datum/reagent/prereq = initial(recipe.pre_reqs)
		if(!heated && initial(recipe.heat_required))
			continue
		if(!prereq || (reagents.has_reagent(prereq)))
			options[initial(recipe.name)] = recipe

	if(options.len == 0)
		return

	var/choice = input(user,"What brew do you want to make?", name) as null|anything in options

	if(!choice)
		return
	if(!Adjacent(user))
		return

	var/choice_to_spawn = options[choice]

	/*
	if(istype(choice_to_spawn, /datum/brewing_recipe/custom_recipe))
		selected_recipe = choice_to_spawn
	else
		selected_recipe = new choice_to_spawn
	*/
	selected_recipe = new choice_to_spawn
	to_chat(user, span_notice("You set the recipe to [selected_recipe.name]."))
	recipe_completions = 0
	selecting_recipe = FALSE

	//Second stage brewing gives no refunds! - This is intented design to help make it so folks dont quit halfway through and still get a rebate
	ready_to_bottle = FALSE
	sellprice = initial(sellprice)
	icon_state = initial(icon_state)
	update_appearance(UPDATE_OVERLAYS)
	return TRUE

//Remove only chemicals
/obj/structure/fermentation_keg/proc/clear_keg_reagents()
	//consume consume consume consume
	reagents?.clear_reagents()
	update_appearance(UPDATE_OVERLAYS)

//Remove and reset
/obj/structure/fermentation_keg/proc/clear_keg()
	if(brewing)
		return FALSE

	if(!force && ready_to_bottle)
		return FALSE

	clear_keg_reagents()
	recipe_crop_stocks.Cut()

	reset_keg()

	return TRUE

/// Resets variables on keg
/obj/structure/fermentation_keg/proc/reset_keg()
	brewing = FALSE
	tapped = FALSE
	ready_to_bottle = FALSE
	icon_state = initial(icon_state)
	update_appearance(UPDATE_OVERLAYS)

	age_start_time = 0
	start_time = 0
	recipe_completions = 0

	sellprice = initial(sellprice)

	selected_recipe = null

/obj/structure/fermentation_keg/proc/start_brew(mob/user)
	brewing = TRUE
	ready_to_bottle = FALSE
	tapped = FALSE

	// Store the user who started brewing for quality calculation
	if(user)
		last_user = user

	for(var/obj/item/reagent_containers/food/item as anything in selected_recipe.needed_crops)
		if(!(item in recipe_crop_stocks))
			return
		var/needed_amount = selected_recipe.needed_crops[item]

		if(islist(recipe_crop_stocks[item]))
			var/list/crop_data = recipe_crop_stocks[item]
			var/current_amount = crop_data["amount"] || 0
			crop_data["amount"] = current_amount - needed_amount
		else
			var/current_amount = recipe_crop_stocks[item] || 0
			recipe_crop_stocks[item] = current_amount - needed_amount

	for(var/obj/item/item as anything in selected_recipe.needed_items)
		if(!(item in recipe_crop_stocks))
			return
		var/needed_amount = selected_recipe.needed_items[item]

		if(islist(recipe_crop_stocks[item]))
			var/list/item_data = recipe_crop_stocks[item]
			var/current_amount = item_data["amount"] || 0
			item_data["amount"] = current_amount - needed_amount
		else
			var/current_amount = recipe_crop_stocks[item] || 0
			recipe_crop_stocks[item] = current_amount - needed_amount

	for(var/datum/reagent/required_chem as anything in selected_recipe.needed_reagents)
		reagents.remove_reagent(required_chem, selected_recipe.needed_reagents[required_chem])

	soundloop.start()
	brew_timer = addtimer(CALLBACK(src, PROC_REF(end_brew)), selected_recipe.brew_time, TIMER_STOPPABLE)
	if(closed_icon_state)
		icon_state = closed_icon_state
	start_time = world.time
	update_appearance(UPDATE_OVERLAYS)

/obj/structure/fermentation_keg/proc/end_brew(success = TRUE)
	deltimer(brew_timer)
	if(!brewing)
		return
	brewing = FALSE
	if(success)
		sellprice += selected_recipe.sell_value

		// Calculate quality before adding the reagent
		var/calculated_quality = selected_recipe.calculate_brewing_quality(usr || last_user, src)

		// Add the reagent to the keg
		var/list/quality_data = list("quality" = calculated_quality)
		reagents.add_reagent(selected_recipe.reagent_to_brew, selected_recipe.brewed_amount * selected_recipe.per_brew_amount, quality_data)

		recipe_completions++
		if(try_n_brew())
			start_brew(last_user) // Use the stored user
			return
	soundloop.stop()
	start_time = 0
	heated_progress_time = 0
	if(length(selected_recipe.age_times))
		age_start_time = world.time
	if(recipe_completions)
		ready_to_bottle = TRUE
		if(ready_icon_state)
			icon_state = ready_icon_state
	else
		icon_state = initial(icon_state)
	update_appearance(UPDATE_OVERLAYS)

/obj/structure/fermentation_keg/proc/try_n_brew(mob/user)
	if(!selected_recipe)
		if(user)
			to_chat(user, span_notice("You need to set a booze to brew!"))
		return FALSE

	if(brewing)
		if(user)
			to_chat(user, span_notice("This keg is already brewing a mix!"))
		return FALSE

	var/ready = TRUE
	//Crops
	for(var/obj/item/reagent_containers/food/needed_crop as anything in selected_recipe.needed_crops)
		var/needed_amount = selected_recipe.needed_crops[needed_crop]
		var/available_amount = 0

		if(recipe_crop_stocks[needed_crop])
			if(islist(recipe_crop_stocks[needed_crop]))
				var/list/crop_data = recipe_crop_stocks[needed_crop]
				available_amount = crop_data["amount"] || 0
			else
				available_amount = recipe_crop_stocks[needed_crop]

		if(available_amount < needed_amount)
			if(user)
				var/difference = needed_amount - available_amount
				to_chat(user, span_notice("This keg lacks [difference] [initial(needed_crop.name)][difference != 1 ? "s" : ""]!"))
			ready = FALSE

	for(var/obj/item/needed_item as anything in selected_recipe.needed_items)
		var/needed_amount = selected_recipe.needed_items[needed_item]
		var/available_amount = 0

		if(recipe_crop_stocks[needed_item])
			if(islist(recipe_crop_stocks[needed_item]))
				var/list/item_data = recipe_crop_stocks[needed_item]
				available_amount = item_data["amount"] || 0
			else
				available_amount = recipe_crop_stocks[needed_item]

		if(available_amount < needed_amount)
			if(user)
				var/difference = needed_amount - available_amount
				to_chat(user, span_notice("This keg lacks [difference] [initial(needed_item.name)][difference != 1 ? "s" : ""]!"))
			ready = FALSE

	for(var/datum/reagent/required_chem as anything in selected_recipe.needed_reagents)
		if(selected_recipe.needed_reagents[required_chem] > reagents.get_reagent_amount(required_chem))
			if(user)
				to_chat(user, span_notice("The keg lacks [initial(required_chem.name)]!"))
			ready = FALSE

	return ready

/obj/structure/fermentation_keg/proc/refuel(obj/item/item, mob/user)
	user.visible_message("[user] starts refueling [src].", "You start refueling [src].")
	if(!do_after(user, 1.5 SECONDS, src))
		return
	var/burn_time = 4 MINUTES
	var/burn_temp = 300
	if(istype(item, /obj/item/ore/coal))
		burn_time *= 1.5
		burn_temp *= 1.5

	heat_decay = world.time + burn_time
	heat = min(1000, burn_temp + heat)
	qdel(item)

/obj/structure/fermentation_keg/proc/create_items(user, I)
	if(!ready_to_bottle || recipe_completions < 1)
		return

	selected_recipe.create_items(user, I, src, recipe_completions)
	var/datum/reagent/brewed_reagent = selected_recipe.reagent_to_brew
	if(brewed_reagent)
		reagents.remove_reagent(brewed_reagent, selected_recipe.per_brew_amount * selected_recipe.brewed_amount * recipe_completions)
	reset_keg()

// Only kegs that are ready to bottle can be tapped. Tapped barrels cannot brew and will need to be reset.
/obj/structure/fermentation_keg/proc/try_tapping(mob/user)
	if(tapped)
		return
	visible_message("[user] starts tapping [src].", "You start tapping [src].")
	if(!do_after(user, 4 SECONDS, src))
		return
	tapped = TRUE
	if(tapped_icon_state)
		icon_state = tapped_icon_state
	sellprice = initial(sellprice)

/// Transfer specific recipe reagent to the container.
/obj/structure/fermentation_keg/proc/try_filling(mob/user, obj/item/reagent_containers/container)
	if(!tapped || !selected_recipe)
		return FALSE

	var/datum/reagent/brewed_reagent = selected_recipe.reagent_to_brew
	if(!brewed_reagent)
		return FALSE

	. = TRUE // to prevent attackby reagent transfer behavior

	var/name_to_use = selected_recipe.secondary_name ? selected_recipe.secondary_name : selected_recipe.name
	if(!reagents.get_reagent(brewed_reagent))
		to_chat(user, span_info("[src] is fully emptied of [lowertext(name_to_use)]."))
		return

	visible_message("[user] starts extracting [lowertext(name_to_use)] into [container].", "You start extracting [lowertext(name_to_use)] into [container].")
	if(!do_after(user, 5 SECONDS, src))
		return

	var/datum/reagent/new_brewed_reagent = brewed_reagent
	if(length(selected_recipe.age_times))
		var/time = world.time - age_start_time
		var/oldest_brew_age = 0
		for(var/path in selected_recipe.age_times)
			if(time > selected_recipe.age_times[path] && selected_recipe.age_times[path] >= oldest_brew_age)
				new_brewed_reagent = path
				oldest_brew_age = selected_recipe.age_times[path]

	var/transfer_amount = min(container.reagents.maximum_volume - container.reagents.total_volume, reagents.get_reagent_amount(brewed_reagent))
	reagents.remove_reagent(brewed_reagent, transfer_amount)
	container.reagents.add_reagent(new_brewed_reagent, transfer_amount)
	if(!reagents.get_reagent(brewed_reagent))
		to_chat(user, span_info("[src] is fully emptied of [lowertext(name_to_use)]."))

/// Handles keg to keg transfers from src receiving mousedrop. If origin_keg is tapped and has a recipe set, it transfers its recipe reagent into src.
/obj/structure/fermentation_keg/MouseDrop_T(atom/over, mob/living/user)
	if(!istype(over, /obj/structure/fermentation_keg))
		return
	if(!Adjacent(over))
		return
	if(!Adjacent(user))
		return
	var/obj/structure/fermentation_keg/origin_keg = over
	if(origin_keg.brewing || brewing)
		return

	if(origin_keg.tapped && origin_keg.selected_recipe.reagent_to_brew)
		var/datum/reagent/brewed_reagent = origin_keg.selected_recipe.reagent_to_brew
		var/name_to_use = origin_keg.selected_recipe.secondary_name ? origin_keg.selected_recipe.secondary_name : origin_keg.selected_recipe.name

		if(!origin_keg.reagents.get_reagent(brewed_reagent))
			to_chat(user, span_info("[origin_keg] is fully emptied of [lowertext(name_to_use)]."))
			return
		user.visible_message("[user] starts to extract [lowertext(name_to_use)] into [src]." , "You start to extract [lowertext(name_to_use)] in [src].")
		if(!do_after(user, 5 SECONDS, origin_keg))
			return

		var/datum/reagent/new_brewed_reagent = brewed_reagent
		if(length(origin_keg.selected_recipe.age_times))
			var/time = world.time - origin_keg.age_start_time
			var/oldest_brew_age = 0
			for(var/path in origin_keg.selected_recipe.age_times)
				if(time > origin_keg.selected_recipe.age_times[path] && origin_keg.selected_recipe.age_times[path] >= oldest_brew_age)
					brewed_reagent = path
					oldest_brew_age = origin_keg.selected_recipe.age_times[path]

		var/transfer_amount = min(reagents.maximum_volume - reagents.total_volume, origin_keg.reagents.get_reagent_amount(brewed_reagent))
		origin_keg.reagents.remove_reagent(brewed_reagent, transfer_amount)
		reagents.add_reagent(new_brewed_reagent, transfer_amount)
		if(!origin_keg.reagents.get_reagent(brewed_reagent))
			to_chat(user, span_info("[src] is fully emptied of [lowertext(name_to_use)]."))
	else
		user.visible_message("[user] starts to pour [origin_keg] into [src]." , "You start to pour [origin_keg] in [src].")
		if(!do_after(user, 5 SECONDS, origin_keg, extra_checks = CALLBACK(src, TYPE_PROC_REF(/atom/movable, Adjacent), origin_keg)))
			return
		origin_keg.reagents.trans_to(src, origin_keg.reagents.total_volume)

	origin_keg.update_appearance(UPDATE_OVERLAYS)
	update_appearance(UPDATE_OVERLAYS)

/obj/structure/fermentation_keg/process()
	if(accepts_water_input && input && selected_recipe && !brewing && !ready_to_bottle)
		var/datum/reagent/incoming_reagent = input.carrying_reagent
		if((incoming_reagent in selected_recipe.needed_reagents))
			var/datum/reagent/reagent = reagents.get_reagent(incoming_reagent)
			var/reagents_needed = selected_recipe.needed_reagents[incoming_reagent]
			reagents_needed -= reagent?.volume

			var/transfer_amount = min(input.water_pressure, reagents_needed)
			reagents.add_reagent(incoming_reagent, transfer_amount)

	if(brewing && selected_recipe.heat_required)
		var/end_time = world.time + (selected_recipe.brew_time - heated_progress_time)
		if(world.time > end_time)
			end_brew(FALSE)
		if((heat > selected_recipe.heat_required))
			heated_progress_time += world.time - start_time
		start_time = world.time

	if(heat_decay < world.time)
		heat = max(300, heat-5)

/obj/structure/fermentation_keg/distiller
	name = "copper distiller"

	icon = 'icons/obj/distillery.dmi'
	icon_state = "distillery"
	tapped_icon_state = null
	closed_icon_state = null
	ready_icon_state = null

	anchored = TRUE
	heated = TRUE

	accepts_water_input = TRUE

/obj/structure/fermentation_keg/distiller/valid_water_connection(direction, obj/structure/water_pipe/pipe)
	if(direction == SOUTH)
		input = pipe
		return TRUE
	return FALSE

/obj/structure/fermentation_keg/distiller/setup_water()
	var/turf/north_turf = get_step(src, NORTH)
	input = locate(/obj/structure/water_pipe) in north_turf

/obj/structure/fermentation_keg/distiller/return_rotation_chat()
	if(!input)
		return "NO INPUT"

	return "Pressure: [input.water_pressure]\n\
			Fluid: [input.carrying_reagent ? initial(input.carrying_reagent.name) : "Nothing"]"

/obj/structure/fermentation_keg/random/water
	name = "water barrel"

/obj/structure/fermentation_keg/random/water/Initialize()
	. = ..()
	reagents.add_reagent(/datum/reagent/water, rand(99,900))
	update_appearance(UPDATE_OVERLAYS)

/obj/structure/fermentation_keg/random/beer/Initialize()
	. = ..()
	reagents.add_reagent(/datum/reagent/consumable/ethanol/beer, rand(99,900))
	update_appearance(UPDATE_OVERLAYS)

/obj/structure/fermentation_keg/water
	name = "water barrel"

/obj/structure/fermentation_keg/water/Initialize()
	. = ..()
	reagents.add_reagent(/datum/reagent/water,900)
	update_appearance(UPDATE_OVERLAYS)

/obj/structure/fermentation_keg/beer/Initialize()
	. = ..()
	reagents.add_reagent(/datum/reagent/consumable/ethanol/beer,900)
	update_appearance(UPDATE_OVERLAYS)

/obj/structure/fermentation_keg/hagwoodbitter/Initialize()
	. = ..()
	reagents.add_reagent(/datum/reagent/consumable/ethanol/hagwoodbitter,900)
	update_appearance(UPDATE_OVERLAYS)

/obj/structure/fermentation_keg/whitewine
	desc = "A barrel that contains a Grenzelhoftian luxury. A sweeter tasting wine that often serves to highlight and enhance savoury notes. The rarer the vintage, the harder the find. The names of the ingredients often grow more ostentatious the closer you get to the capital."

/obj/structure/fermentation_keg/whitewine/Initialize()
	. = ..()
	reagents.add_reagent(/datum/reagent/consumable/ethanol/whitewine,900)

/obj/structure/fermentation_keg/redwine
	desc = "A barrel that contains a Grenzelhoftian luxury. It was originally served as part of Psydonic communion, eventually becoming wildly enjoyed within Grenzelhoft to the point of being oft paired with EVERY meal."

/obj/structure/fermentation_keg/redwine/Initialize()
	. = ..()
	reagents.add_reagent(/datum/reagent/consumable/ethanol/redwine,900)
