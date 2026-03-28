/obj/item/mould
	name = "mould"
	desc = "You shouldn't be seeing this one."

	icon = 'icons/roguetown/weapons/crucible.dmi'
	icon_state = "flat-mold"
	item_weight = 500 GRAMS
	var/filling_icon_state = ""

	var/atom/output_atom
	var/required_metal_amount
	var/fufilled_metal = 0
	var/datum/material/filling_metal

	var/cooling = FALSE
	var/cooling_progress = 0
	var/cooling_multiplier = 1

	/// Average quality weighted by molten metal reagent amount
	var/average_quality = 0
	/// Average skill level of pourers weighted by molten metal reagent amount
	var/average_skill = 0

/obj/item/mould/Initialize()
	. = ..()
	main_material = pick(typesof(/datum/material/clay))
	set_material_information()
	update_appearance(UPDATE_OVERLAYS)

/obj/item/mould/set_material_information()
	. = ..()
	name = "[initial(main_material.name)] [initial(name)]"

/obj/item/mould/examine(mob/user)
	. = ..()
	if(cooling)
		. += "[src] is hardening."
		return

	if(fufilled_metal)
		var/reagent_color = initial(filling_metal.color)
		. += "[src] has [UNIT_FORM_STRING(fufilled_metal)] of <font color=[reagent_color]> Molten [initial(filling_metal.name)]</font> out of [UNIT_FORM_STRING(required_metal_amount)].</font>"
		if(average_quality > 0)
			. += "The metal quality appears to be [average_quality]."
	else
		. += "[src] requires [UNIT_FORM_STRING(required_metal_amount)] of Molten Metal to form.</font>"

/obj/item/mould/attackby(obj/item/attacking_item, mob/living/user, list/modifiers)
	. = ..()
	if(!istype(attacking_item, /obj/item/storage/crucible))
		return
	if(cooling)
		return

	var/obj/item/storage/crucible/crucible = attacking_item
	var/datum/reagent/molten_metal/metal = crucible.reagents.get_reagent(/datum/reagent/molten_metal)
	if(!metal)
		return

	if(!filling_metal)
		var/list/names = list()
		for(var/datum/material/material as anything in metal.data)
			if(!ispath(material))
				continue
			if(crucible.reagents.chem_temp < initial(material.melting_point))
				continue
			names |= initial(material.name)

		var/choice = input(user, "What metal to pour?", crucible) in names
		if(!choice)
			return
		for(var/datum/material/material as anything in metal.data)
			if(!ispath(material))
				continue
			if(choice != initial(material.name))
				continue
			filling_metal = material
			break
		if(!filling_metal)
			return
	else
		if(!(filling_metal in metal.data))
			return

	if(cooling)
		return
	var/metal_amount = metal.data[filling_metal]
	if(metal_amount > required_metal_amount - fufilled_metal)
		metal_amount = required_metal_amount - fufilled_metal

	var/pour_quality = metal.get_recipe_quality()
	var/user_skill_level = GET_MOB_SKILL_VALUE_OLD(user, /datum/attribute/skill/craft/smelting)
	var/new_metal_ratio = metal_amount / (fufilled_metal + metal_amount)
	average_quality = LERP(average_quality, pour_quality, new_metal_ratio)
	average_skill = LERP(average_skill, user_skill_level, new_metal_ratio)

	metal.data[filling_metal] -= metal_amount
	if(!metal.data[filling_metal])
		metal.data -= filling_metal
	crucible.reagents.remove_reagent(/datum/reagent/molten_metal, metal_amount)
	if(!QDELETED(metal))
		metal.find_largest_metal()

	var/boon = user.get_learning_boon(/datum/attribute/skill/craft/blacksmithing)
	var/amt2raise = GET_MOB_ATTRIBUTE_VALUE(user, STAT_INTELLIGENCE) * 2 // Smelting is already a timesink, this is justified to accelerate levelling
	amt2raise *= (metal_amount / required_metal_amount)
	if(amt2raise > 0)
		user.adjust_experience(/datum/attribute/skill/craft/blacksmithing, amt2raise * boon, FALSE)

	fufilled_metal += metal_amount
	if(fufilled_metal >= required_metal_amount)
		start_cooling()

/obj/item/mould/update_overlays()
	. = ..()
	if(!fufilled_metal)
		return
	. += mutable_appearance(
		icon,
		filling_icon_state,
		color = initial(filling_metal.color),
		alpha = (255 * (fufilled_metal / required_metal_amount)),
		appearance_flags = RESET_COLOR | KEEP_APART,
	)
	var/mutable_appearance/MA = emissive_appearance(icon, filling_icon_state)
	if(cooling)
		MA.alpha = 255 * round((1 - (cooling_progress / 100)),0.1)
	else
		MA.alpha = 255 * (fufilled_metal / required_metal_amount)
	. += MA

/obj/item/mould/proc/start_cooling()
	cooling = TRUE
	START_PROCESSING(SSobj, src)

/obj/item/mould/process()
	cooling_progress += 7.5 * cooling_multiplier
	update_appearance(UPDATE_OVERLAYS)
	if(cooling_progress >= 100)
		STOP_PROCESSING(SSobj, src)
		create_item()

/obj/item/mould/proc/on_reagent_change(datum/reagents/holder, ...)
	SIGNAL_HANDLER
	update_appearance(UPDATE_OVERLAYS)

/obj/item/mould/proc/create_item()
	if(output_atom)
		var/obj/item/new_item = new output_atom(get_turf(src))

		var/datum/quality_calculator/metallurgy/metal_calc = new(
			mat_qual = average_quality, // Use the stored weighted average quality
			skill_qual = average_skill
		)
		metal_calc.apply_quality_to_item(new_item, TRUE)
		qdel(metal_calc)

	reset_state()

/obj/item/mould/proc/reset_state()
	// Reset all variables
	fufilled_metal = 0
	filling_metal = null
	cooling = FALSE
	cooling_progress = 0
	average_quality = 0
	average_skill = 0
	update_appearance(UPDATE_OVERLAYS)

/obj/item/mould/ingot
	name = "ingot mould"
	desc = "A clay mould for making metal ingots."

	icon_state = "ingot-mold"
	filling_icon_state = "ingot-mold-color"

	required_metal_amount = 100

	grid_width = 64
	grid_height = 32
	item_weight = 650 GRAMS

/obj/item/mould/ingot/create_item()
	output_atom = initial(filling_metal.ingot_type)
	if(output_atom == /obj/item/ingot/blacksteel)
		record_round_statistic(STATS_BLACKSTEEL_SMELTED)

	. = ..()

/obj/item/mould/ingot/reset_state()
	. = ..()
	output_atom = null

/obj/item/mould/ingot/advanced
	name = "advanced ingot mould"
	desc = "An ingot mould that utilizes water for faster cooling."
	cooling_multiplier = 2
