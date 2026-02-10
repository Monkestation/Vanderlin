/obj/machinery/anvil
	icon = 'icons/roguetown/misc/forge.dmi'
	name = "anvil"
	icon_state = "anvil"
	var/hott = 0
	var/obj/item/ingot/hingot
	max_integrity = 2000
	density = TRUE
	damage_deflection = 25
	climbable = TRUE
	var/previous_material_quality = 0
	var/cool_time = 30 SECONDS
	var/smithing = FALSE // Is a minigame currently active?
	var/obj/item/working_material // Reference to the material being worked
	var/always_perfect = FALSE // Debug/admin flag

/obj/machinery/anvil/crafted
	icon_state = "caveanvil"

/obj/machinery/anvil/examine(mob/user)
	. = ..()
	if(hingot)
		. += hingot.examine()
		if(hott)
			. += "<span class='warning'>[hingot] is too hot to touch.</span>"

/obj/machinery/anvil/attack_hand_secondary(mob/user, list/modifiers)
	if(hingot)
		return hingot.attack_hand_secondary(user, modifiers)
	. = ..()

/obj/machinery/anvil/attackby(obj/item/W, mob/living/user, list/modifiers)
	if(istype(W, /obj/item/weapon/tongs))
		var/obj/item/weapon/tongs/T = W
		if(smithing)
			to_chat(user, "<span class='warning'>[src] is currently being worked on!</span>")
			return
		if(hingot)
			if(T.held_item && istype(T.held_item, /obj/item/ingot))
				if(hingot.currecipe && hingot.currecipe.needed_item && istype(T.held_item, hingot.currecipe.needed_item))
					hingot.currecipe.item_added(user)
					qdel(T.held_item)
					T.held_item = null
					T.update_appearance(UPDATE_ICON_STATE)
					update_appearance(UPDATE_OVERLAYS)
				return
			else
				hingot.forceMove(T)
				T.held_item = hingot
				hingot = null
				T.update_appearance(UPDATE_ICON_STATE)
				update_appearance(UPDATE_OVERLAYS)
				return
		else
			if(T.held_item && istype(T.held_item, /obj/item/ingot))
				T.held_item.forceMove(src)
				hingot = T.held_item
				T.held_item = null
				hott = T.hott
				if(hott)
					START_PROCESSING(SSmachines, src)
				T.update_appearance(UPDATE_ICON_STATE)
				update_appearance(UPDATE_OVERLAYS)
				return

	if(istype(W, /obj/item/ingot))
		if(!hingot)
			W.forceMove(src)
			hingot = W
			hott = 0
			update_appearance(UPDATE_OVERLAYS)
			return

	if(istype(W, /obj/item/weapon/hammer))
		var/obj/item/weapon/hammer/hammer = W
		user.changeNext_move(CLICK_CD_MELEE)
		if(!hingot)
			return
		if(!hott)
			to_chat(user, "<span class='warning'>The bar has gone too cold to continue working on it.</span>")
			return
		if(smithing)
			to_chat(user, "<span class='warning'>Already working on this!</span>")
			return
		if(!hingot.currecipe)
			if(!choose_recipe(user))
				return
		if(has_world_trait(/datum/world_trait/delver))
			if(!has_recipe_unlocked(user.key, hingot.currecipe.type))
				return

		// Start the minigame instead of direct hammering
		start_minigame(user, hammer)
		return

	if(hingot && hingot.currecipe && hingot.currecipe.needed_item && istype(W, hingot.currecipe.needed_item))
		hingot.currecipe.item_added(user)
		if(istype(W, /obj/item/ingot))
			var/obj/item/ingot/I = W
			hingot.currecipe.material_quality += I.recipe_quality
			previous_material_quality = I.recipe_quality
		else
			hingot.currecipe.material_quality += previous_material_quality
		hingot.currecipe.num_of_materials += 1
		qdel(W)
		return

	if(W.anvilrepair)
		user.visible_message("<span class='info'>[user] places \a [W] on the anvil.</span>")
		W.forceMove(src.loc)
		return
	..()

/obj/machinery/anvil/proc/start_minigame(mob/living/user, obj/item/weapon/hammer/hammer)
	if(!hingot || !hingot.currecipe)
		return

	smithing = TRUE
	working_material = hingot

	var/difficulty_modifier = hingot.currecipe.craftdiff

	var/datum/anvil_challenge/challenge = new(src, hingot.currecipe, user, difficulty_modifier)
	if(!challenge)
		smithing = FALSE
		working_material = null
		return


/obj/machinery/anvil/proc/process_minigame_result(quality_score, mob/living/user, total_fail)
	if(!hingot || !hingot.currecipe)
		return

	var/datum/anvil_recipe/recipe = hingot.currecipe
	var/breakthrough = quality_score >= 80
	if(total_fail)
		quality_score = 0
	var/success = recipe.advance(user, breakthrough, quality_score)

	if(!success)
		shake_camera(user, 1, 1)
		playsound(src, 'sound/items/bsmithfail.ogg', 100, FALSE)

	if(success)
		var/skill_boost = 0
		if(quality_score >= 80)
			skill_boost = quality_score * 2
			recipe.numberofbreakthroughs++
		else if(quality_score >= 60)
			skill_boost = quality_score * 1.5
		else if(quality_score >= 40)
			skill_boost = quality_score
		else if(quality_score >= 20)
			skill_boost = quality_score * 0.5

		recipe.skill_quality += skill_boost

	if(recipe.progress >= 100 && !length(recipe.additional_items) && !recipe.needed_item)
		complete_recipe(user, quality_score)

	working_material = null

/obj/machinery/anvil/proc/complete_recipe(mob/living/user, quality_score)
	if(!hingot || !hingot.currecipe)
		return

	var/datum/anvil_recipe/recipe = hingot.currecipe
	var/obj/item/I = new recipe.created_item(loc)

	I.OnCrafted(user.dir, user)

	var/skill_level = 0
	if(user)
		skill_level = user.get_skill_level(recipe.appro_skill)

	recipe.handle_creation(I, quality_score, skill_level)
	SEND_SIGNAL(user, COMSIG_ITEM_FORGED)

	record_featured_stat(FEATURED_STATS_SMITHS, user)
	record_featured_object_stat(FEATURED_STATS_FORGED_ITEMS, I.name)

	for(var/i in 1 to recipe.createditem_extra)
		var/obj/item/extra = new recipe.created_item(loc)
		extra.OnCrafted(user.dir, user)
		recipe.handle_creation(extra, quality_score, skill_level)

	user?.visible_message(span_info("[user] finishes crafting [I]!"))

	qdel(hingot)
	hingot = null
	update_appearance(UPDATE_OVERLAYS)

/obj/machinery/anvil/proc/choose_recipe(mob/living/user)
	if(!hingot || !hott)
		return

	var/list/valid_types = list()
	for(var/datum/anvil_recipe/R as anything in GLOB.anvil_recipes)
		if(IS_ABSTRACT(R))
			continue

		if(has_world_trait(/datum/world_trait/delver))
			if(!has_recipe_unlocked(user.key, R))
				continue

		if(istype(hingot, R.req_bar))
			if(!valid_types.Find(R.i_type))
				valid_types += R.i_type

	if(!length(valid_types))
		return

	var/i_type_choice
	if(length(valid_types) == 1)
		i_type_choice = valid_types[1]
	else
		i_type_choice = browser_input_list(user, "Choose a category", "Anvil", valid_types)
	if(!i_type_choice)
		return

	var/list/appro_recipe = list()
	for(var/datum/anvil_recipe/R as anything in GLOB.anvil_recipes)
		if(IS_ABSTRACT(R))
			continue
		if(R.i_type == i_type_choice && istype(hingot, R::req_bar))
			appro_recipe += R

	for(var/datum/anvil_recipe/R as anything in appro_recipe)
		if(!R::req_bar)
			appro_recipe -= R
		if(!istype(hingot, R::req_bar))
			appro_recipe -= R

	if(length(appro_recipe))
		var/datum/chosen_recipe
		chosen_recipe = browser_input_list(user, "Choose what to start working on:", "Anvil", sortNames(appro_recipe.Copy()))
		if(!hingot.currecipe && chosen_recipe)
			hingot.currecipe = new chosen_recipe.type(hingot)
			hingot.currecipe.material_quality += hingot.recipe_quality
			previous_material_quality = hingot.recipe_quality
			return TRUE

	return FALSE

/obj/machinery/anvil/attack_hand(mob/user, list/modifiers)
	if(smithing)
		to_chat(user, "<span class='warning'>[src] is currently being worked on!</span>")
		return
	if(hingot)
		if(hott)
			to_chat(user, "<span class='warning'>It's too hot to handle with your hands.</span>")
			return
		else
			var/obj/item/I = hingot
			hingot = null
			I.loc = user.loc
			user.put_in_active_hand(I)
			update_appearance(UPDATE_OVERLAYS)

/obj/machinery/anvil/process()
	if(hott)
		if(world.time > hott + cool_time)
			hott = 0
			STOP_PROCESSING(SSmachines, src)
	else
		STOP_PROCESSING(SSmachines, src)
	update_appearance(UPDATE_OVERLAYS)

/obj/machinery/anvil/update_overlays()
	. = ..()
	if(!hingot)
		return
	var/obj/item/I = hingot
	I.pixel_x = I.base_pixel_x
	I.pixel_y = I.base_pixel_y
	var/mutable_appearance/M = new /mutable_appearance(I)
	if(hott)
		M.filters += filter(type="color", color = list(3,0,0,1, 0,2.7,0,0.4, 0,0,1,0, 0,0,0,1))
	M.transform *= 0.5
	M.pixel_y = 5
	M.pixel_x = 3
	. += M
