/obj/item/mould
	name = "mould"
	desc = "You shouldn't be seeing this one."

	icon = 'icons/roguetown/weapons/crucible.dmi'
	icon_state = "flat-mold"
	var/filling_icon_state = ""

	var/atom/output_atom
	var/required_metal
	var/fufilled_metal = 0
	var/datum/material/required_material
	var/datum/material/filling_metal

	var/cooling = FALSE
	var/cooling_progress = 0
	var/cooling_bonus = 1

	// Quality tracking variables
	var/total_quality_points = 0  // Sum of (amount * quality) for weighted average
	var/average_quality = 0       // Current weighted average quality

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
		. += "[src] has [UNIT_FORM_STRING(fufilled_metal)] of <font color=[reagent_color]> Molten [initial(filling_metal.name)]</font> out of [UNIT_FORM_STRING(required_metal)].</font>"
		if(average_quality > 0)
			. += "The metal quality appears to be [average_quality]."
	else
		. += "[src] requires [UNIT_FORM_STRING(required_metal)] of Molten Metal to form.</font>"

/obj/item/mould/attackby(obj/item/I, mob/living/user, list/modifiers)
	. = ..()
	if(!istype(I, /obj/item/storage/crucible))
		return

	var/obj/item/storage/crucible/crucible = I
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

	var/metal_amount = metal.data[filling_metal]
	if(metal_amount > required_metal - fufilled_metal)
		metal_amount = required_metal - fufilled_metal

	var/pour_quality = metal.recipe_quality

	// Update weighted average quality
	if(fufilled_metal > 0)
		// Calculate new weighted average: (old_total + new_contribution) / new_total_amount
		total_quality_points += metal_amount * pour_quality
		average_quality = total_quality_points / (fufilled_metal + metal_amount)
	else
		// First pour - set initial quality
		total_quality_points = metal_amount * pour_quality
		average_quality = pour_quality

	metal.data[filling_metal] -= metal_amount
	if(!metal.data[filling_metal])
		metal.data -= filling_metal
	crucible.reagents.remove_reagent(/datum/reagent/molten_metal, metal_amount)
	if(!QDELETED(metal))
		metal.find_largest_metal()

	fufilled_metal += metal_amount
	update_appearance(UPDATE_OVERLAYS)
	crucible.update_appearance(UPDATE_OVERLAYS)
	if(fufilled_metal >= required_metal)
		start_cooling()

/obj/item/mould/update_overlays()
	. = ..()
	if(!fufilled_metal)
		return
	. += mutable_appearance(
		icon,
		filling_icon_state,
		color = initial(filling_metal.color),
		alpha = (255 * (fufilled_metal / required_metal)),
		appearance_flags = RESET_COLOR | KEEP_APART,
	)
	var/mutable_appearance/MA = emissive_appearance(icon, filling_icon_state)
	if(cooling)
		MA.alpha = 255 * round((1 - (cooling_progress / 100)),0.1)
	else
		MA.alpha = 255 * (fufilled_metal / required_metal)
	. += MA

/obj/item/mould/proc/start_cooling()
	cooling = TRUE
	START_PROCESSING(SSobj, src)

/obj/item/mould/process()
	cooling_progress += 7.5 * cooling_bonus
	update_appearance(UPDATE_OVERLAYS)
	if(cooling_progress >= 100)
		STOP_PROCESSING(SSobj, src)
		create_item()

/obj/item/mould/proc/create_item()
	if(output_atom)
		var/obj/item/new_item = new output_atom(get_turf(src))

		if(average_quality > 0)
			var/datum/quality_calculator/metallurgy/metal_calc = new(
				base_qual = 0,
				mat_qual = average_quality, // Use the stored weighted average quality
				skill_qual = 1, // Could add blacksmithing skill here but I'd need to track from start of the process
				perf_qual = 0,
				diff_mod = 0,
				components = 1
			)
			metal_calc.apply_quality_to_item(new_item, TRUE)
			qdel(metal_calc)

	// Reset all variables
	fufilled_metal = 0
	filling_metal = null
	cooling = FALSE
	cooling_progress = 0
	total_quality_points = 0
	average_quality = 0
	update_appearance(UPDATE_OVERLAYS)


/obj/item/mould/ingot
	name = "ingot mould"
	desc = "A clay mould for making metal ingots."

	icon_state = "ingot-mold"
	filling_icon_state = "ingot-mold-color"

	required_metal = 100

	grid_width = 64
	grid_height = 32

/obj/item/mould/ingot/create_item()
	var/atom/to_create
	to_create = initial(filling_metal.ingot_type)
	if(filling_metal.ingot_type == /obj/item/ingot/blacksteel)
		record_round_statistic(STATS_BLACKSTEEL_SMELTED)

	var/obj/item/new_item = new to_create(get_turf(src))

	if(average_quality > 0)
		var/datum/quality_calculator/metallurgy/metal_calc = new(
			base_qual = 0,
			mat_qual = average_quality,
			skill_qual = 1,
			perf_qual = 0,
			diff_mod = 0,
			components = 1
		)
		metal_calc.apply_quality_to_item(new_item, TRUE)
		qdel(metal_calc)

	// Reset all variables
	fufilled_metal = 0
	filling_metal = null
	cooling = FALSE
	cooling_progress = 0
	total_quality_points = 0
	average_quality = 0
	update_appearance(UPDATE_OVERLAYS)

/obj/item/mould/ingot/advanced
	name = "advanced ingot mould"
	desc = "An ingot mould that utilizes water for faster cooling."
	cooling_bonus = 2
