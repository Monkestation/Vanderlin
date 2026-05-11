/obj/machinery/essence/enchantment_altar
	name = "enchanting table"
	desc = "An obsidian focus for binding alchemical essences into an item."
	icon = 'icons/roguetown/misc/altar.dmi'
	icon_state = "altar"
	network_priority = 4
	accepts_output = FALSE

	var/obj/item/placed_item = null
	var/datum/enchantment/selected_recipe = null
	var/enchanting = FALSE
	var/enchantment_time = 20 SECONDS

/obj/machinery/essence/enchantment_altar/Initialize()
	. = ..()
	storage.max_total = 500
	storage.max_types = 15
	START_PROCESSING(SSobj, src)

/obj/machinery/essence/enchantment_altar/Destroy()
	STOP_PROCESSING(SSobj, src)
	if(placed_item)
		placed_item.forceMove(get_turf(src))
	if(selected_recipe)
		qdel(selected_recipe)
	return ..()

/obj/machinery/essence/enchantment_altar/build_allowed_types()
	if(!selected_recipe || enchanting)
		return list()
	var/list/result = list()
	for(var/etype in selected_recipe.essence_recipe)
		var/deficit = selected_recipe.essence_recipe[etype] - storage.get(etype)
		if(deficit > 0)
			result[etype] = deficit
	return result

/obj/machinery/essence/enchantment_altar/push_to_linked(datum/essence_storage/from_storage)
	push_surplus_to_linked(from_storage)

/obj/machinery/essence/enchantment_altar/process()
	if(enchanting || !selected_recipe || recipe_complete())
		return
	pull_from_linked(storage)

/obj/machinery/essence/enchantment_altar/proc/recipe_complete()
	if(!selected_recipe)
		return FALSE
	for(var/etype in selected_recipe.essence_recipe)
		if(storage.get(etype) < selected_recipe.essence_recipe[etype])
			return FALSE
	return TRUE

/obj/machinery/essence/enchantment_altar/attack_hand(mob/living/user)
	if(enchanting)
		to_chat(user, span_warning("[src] is currently enchanting."))
		return
	show_main_menu(user)

/obj/machinery/essence/enchantment_altar/proc/show_main_menu(mob/user)
	var/list/opts = list()
	if(placed_item)
		if(selected_recipe && recipe_complete())
			opts["Begin Enchantment"] = "enchant"
		else if(selected_recipe)
			opts["Check Recipe Progress"] = "progress"
		else
			opts["Select Recipe"] = "recipe"
		opts["Remove Item"] = "remove"
	else
		opts["(Place an item on the altar first)"] = "info"
	if(selected_recipe)
		opts["Clear Recipe"] = "clear"
		opts["Recipe Details"] = "details"
	opts["Browse All Recipes"] = "browse"
	opts["Cancel"] = "cancel"

	var/choice = input(user, "Altar Menu", "[src.name]") in opts
	if(!choice || choice == "cancel") return
	switch(opts[choice])
		if("enchant") begin_enchantment(user)
		if("progress") show_recipe_progress(user)
		if("recipe") show_recipe_selection(user, FALSE)
		if("remove") remove_placed_item(user)
		if("clear") clear_recipe(user)
		if("details") show_recipe_details(user, selected_recipe)
		if("browse") show_recipe_selection(user, TRUE)
		if("info") to_chat(user, span_notice("Place an item to begin."))

/obj/machinery/essence/enchantment_altar/proc/item_matches_recipe(datum/enchantment/recipe, obj/item/item)
	if(!recipe || !item)
		return FALSE
	return SSenchantment.can_enchant(item, recipe.type)

/obj/machinery/essence/enchantment_altar/proc/show_recipe_selection(mob/user, browse_only)
	var/list/opts = list()

	for(var/epath in SSenchantment.enchantment_types)
		var/datum/enchantment/e = SSenchantment.enchantment_types[epath]
		var/compatible = placed_item ? SSenchantment.can_enchant(placed_item, epath) : null

		if(!browse_only && placed_item && !compatible)
			continue

		var/tag = ""
		if(browse_only && placed_item)
			tag = compatible ? " ✓" : " ✗"

		var/key = "[e.enchantment_name][tag] - [get_recipe_summary(e)]"
		opts[key] = epath

	if(!opts.len)
		to_chat(user, span_warning("No enchantment recipes available\
			[(!browse_only && placed_item) ? " for [placed_item]" : ""]."))
		return

	var/choice = browser_input_list(user,
		browse_only ? "Browse Recipes" : "Select Recipe for [placed_item]",
		"Enchantment Recipes", opts)

	if(!choice) return

	var/epath = opts[choice]
	if(browse_only)
		show_recipe_details(user, SSenchantment.enchantment_types[epath])
	else
		select_recipe(epath, user)

/obj/machinery/essence/enchantment_altar/proc/select_recipe(epath, mob/user)
	if(placed_item && !SSenchantment.can_enchant(placed_item, epath))
		var/datum/enchantment/e = SSenchantment.enchantment_types[epath]
		to_chat(user, span_warning("'[e.enchantment_name]' is not compatible with [placed_item]."))
		return

	if(selected_recipe) qdel(selected_recipe)
	selected_recipe = new epath
	if(network) network.invalidate_cache()
	push_surplus_to_linked(storage)
	to_chat(user, span_info("Recipe '[selected_recipe.enchantment_name]' selected."))
	show_recipe_details(user, SSenchantment.enchantment_types[epath])
	update_appearance(UPDATE_OVERLAYS)

/obj/machinery/essence/enchantment_altar/proc/clear_recipe(mob/user)
	if(!selected_recipe) return
	qdel(selected_recipe)
	selected_recipe = null
	if(network) network.invalidate_cache()
	push_surplus_to_linked(storage)
	to_chat(user, span_info("Recipe cleared."))
	update_appearance(UPDATE_OVERLAYS)

/obj/machinery/essence/enchantment_altar/proc/show_recipe_progress(mob/user)
	if(!selected_recipe) return
	to_chat(user, span_info("Progress for '[selected_recipe.enchantment_name]':"))
	for(var/datum/thaumaturgical_essence/etype as anything in selected_recipe.essence_recipe)
		var/needed = selected_recipe.essence_recipe[etype]
		var/have = storage.get(etype)
		var/color = (have >= needed) ? "green" : "red"
		to_chat(user, span_info(" <font color='[color]'>[initial(etype.name)]: [have]/[needed]</font>"))
	if(recipe_complete())
		to_chat(user, span_info("<font color='green'>Ready to enchant!</font>"))

/obj/machinery/essence/enchantment_altar/proc/show_recipe_details(mob/user, datum/enchantment/recipe)
	if(!recipe) return
	to_chat(user, span_info("=== [recipe.enchantment_name] ==="))
	if(recipe.examine_text)
		to_chat(user, span_info("[recipe.examine_text]"))

	if(recipe.required_type)
		if(islist(recipe.required_type))
			var/list/names = list()
			for(var/atom/req as anything in recipe.required_type)
				names += initial(req.name)
			to_chat(user, span_notice("Requires: [jointext(names, " or ")]"))
		else
			var/atom/atom = recipe.required_type
			to_chat(user, span_notice("Requires: [initial(atom.name)]"))

	to_chat(user, span_info("Required essences:"))
	for(var/datum/thaumaturgical_essence/etype as anything in recipe.essence_recipe)
		to_chat(user, span_info(" [initial(etype.name)]: [recipe.essence_recipe[etype]] units"))

/obj/machinery/essence/enchantment_altar/proc/begin_enchantment(mob/living/user)
	if(!placed_item || !selected_recipe || !recipe_complete()) return

	if(!SSenchantment.can_enchant(placed_item, selected_recipe.type))
		to_chat(user, span_warning("[placed_item] is not compatible with \
			'[selected_recipe.enchantment_name]'. Remove it and place the correct item type."))
		return

	for(var/etype in selected_recipe.essence_recipe)
		storage.remove(etype, selected_recipe.essence_recipe[etype])
	enchanting = TRUE
	update_appearance(UPDATE_OVERLAYS)
	to_chat(user, span_info("You begin enchanting [placed_item]…"))
	spawn_sparkles(5)
	addtimer(CALLBACK(src, PROC_REF(complete_enchantment), selected_recipe.type, user), enchantment_time)

/obj/machinery/essence/enchantment_altar/proc/complete_enchantment(epath, mob/living/user)
	if(!placed_item)
		enchanting = FALSE
		update_appearance(UPDATE_OVERLAYS)
		return

	var/datum/enchantment/singleton = SSenchantment.enchantment_types[epath]
	var/enchant_name = singleton ? singleton.enchantment_name : "Unknown"

	var/datum/enchantment/enchant = placed_item.enchant(epath)
	if(enchant)
		enchant.apply_user_modifications(user)
		to_chat(user, span_info("[placed_item] has been enchanted with [enchant_name]!"))
		add_abstract_elastic_data(ELASCAT_ENCHANTING, "[enchant.enchantment_name]", 1)
	else
		to_chat(user, span_warning("Enchantment failed!"))

	spawn_sparkles(8)
	if(selected_recipe) qdel(selected_recipe)
	selected_recipe = null
	if(user && placed_item.loc == src) user.put_in_hands(placed_item)
	else placed_item.forceMove(get_turf(src))
	placed_item = null
	enchanting = FALSE
	update_appearance(UPDATE_OVERLAYS)

/obj/machinery/essence/enchantment_altar/proc/remove_placed_item(mob/user)
	if(!placed_item) return
	if(enchanting)
		to_chat(user, span_warning("Cannot remove item while enchanting."))
		return
	user ? user.put_in_hands(placed_item) : placed_item.forceMove(get_turf(src))
	to_chat(user, span_info("You remove [placed_item] from [src]."))
	placed_item = null
	clear_recipe(user)
	update_appearance(UPDATE_OVERLAYS)

/obj/machinery/essence/enchantment_altar/proc/get_recipe_summary(datum/enchantment/recipe)
	var/list/parts = list()
	for(var/datum/thaumaturgical_essence/etype as anything in recipe.essence_recipe)
		parts += "[recipe.essence_recipe[etype]] [initial(etype.name)]"
	return jointext(parts, ", ")

/obj/machinery/essence/enchantment_altar/proc/spawn_sparkles(count)
	var/turf/T = get_turf(src)
	if(!T) return
	for(var/i = 1 to count)
		var/obj/effect/temp_visual/sparkle/S = new(T)
		S.pixel_x = S.base_pixel_x + rand(-24, 24)
		S.pixel_y = S.base_pixel_y + rand(-12, 32)

/obj/machinery/essence/enchantment_altar/attackby(obj/item/I, mob/user, list/modifiers)
	if(istype(I, /obj/item/essence_vial))
		return ..()
	if(istype(I, /obj/item/essence_connector))
		return ..()
	if(!placed_item && !enchanting)
		if(user.transferItemToLoc(I, src))
			placed_item = I
			to_chat(user, span_info("You place [I] on [src]."))
			update_appearance(UPDATE_OVERLAYS)
		return
	return ..()

/obj/machinery/essence/enchantment_altar/get_mechanics_examine(mob/user)
	. = ..()
	if(placed_item)
		. += span_notice("Item: [placed_item]")
	if(selected_recipe)
		. += span_notice("Enchantment: [selected_recipe.enchantment_name]")
		for(var/datum/thaumaturgical_essence/etype as anything in selected_recipe.essence_recipe)
			var/needed = selected_recipe.essence_recipe[etype]
			var/have = storage.get(etype)
			var/color = (have >= needed) ? "green" : "red"
			. += span_notice(" <font color='[color]'>[initial(etype.name)]: [have]/[needed]</font>")
		if(recipe_complete())
			. += span_info("<font color='green'>Ready to enchant!</font>")
	if(enchanting)
		. += span_warning("Enchanting in progress…")

/obj/machinery/essence/enchantment_altar/update_overlays()
	. = ..()
	if(placed_item)
		var/mutable_appearance/item_ma = mutable_appearance(placed_item.icon, placed_item.icon_state)
		item_ma.pixel_y = 8
		var/matrix/m = matrix()
		m.Scale(0.5, 0.5)
		item_ma.transform = m
		item_ma.alpha = 122
		item_ma.color = COLOR_CYAN
		. += item_ma
	if(storage.total() > 0)
		var/mutable_appearance/glow = mutable_appearance(icon, "altar_glow")
		glow.color = get_dominant_color()
		. += glow
	if(selected_recipe)
		. += mutable_appearance(icon, "recipe_selected")
	if(enchanting)
		. += mutable_appearance(icon, "enchanting")
	. += mutable_appearance(icon, "crystal")

/obj/machinery/essence/enchantment_altar/proc/get_dominant_color()
	var/highest = 0
	var/color = "#FFFFFF"
	for(var/datum/thaumaturgical_essence/etype as anything in storage.contents)
		var/amt = storage.get(etype)
		if(amt > highest)
			highest = amt
			color = initial(etype.color)
	return color
