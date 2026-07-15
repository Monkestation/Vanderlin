/obj/item/mould
	name = "mould"
	desc = "You shouldn't be seeing this one."

	icon = 'icons/roguetown/weapons/crucible.dmi'
	item_weight = 500 GRAMS
	var/fill_icon_state = ""

	var/atom/output_atom
	var/required_metal_amount
	var/fufilled_metal = 0
	var/datum/material/filling_metal

	var/cooling = FALSE
	var/cooling_progress = 0
	var/cooling_amount = 3.75

	/// Average quality weighted by molten metal reagent amount
	var/average_quality = 0
	/// Average skill level of pourers weighted by molten metal reagent amount
	var/average_skill = 0

/obj/item/mould/Initialize(mapload)
	. = ..()
	if(mapload)
		main_material = pick(typesof(/datum/material/clay))
		set_material_information()

/obj/item/mould/set_material_information()
	. = ..()
	name = LOWER_TEXT("[initial(main_material.name)] [initial(name)]")

/obj/item/mould/examine(mob/user)
	. = ..()
	if(cooling)
		. += "[src] is hardening and is [PERCENT(cooling_progress / 100)]% completed."
		return
	return custom_examine(.)

/obj/item/mould/proc/custom_examine(list/examine_list)
	if(fufilled_metal)
		var/reagent_color = initial(filling_metal.color)
		examine_list += "[src] has [UNIT_FORM_STRING(fufilled_metal)] of <font color=[reagent_color]> Molten [initial(filling_metal.name)]</font> out of [UNIT_FORM_STRING(required_metal_amount)].</font>"
		if(average_quality > 0)
			examine_list += "The metal quality appears to be [average_quality]."
	else
		examine_list += "[src] requires [UNIT_FORM_STRING(required_metal_amount)] of Molten Metal to form.</font>"
	return examine_list

/obj/item/mould/item_interaction(mob/living/user, obj/item/tool, list/modifiers)
	if(user.cmode)
		return NONE

	if(istype(tool, /obj/item/weapon/tongs))
		var/obj/item/weapon/tongs/tongs = tool
		tool = tongs.held_item

	if(!istype(tool, /obj/item/storage/crucible))
		return NONE

	if(try_filling(user, tool))
		user.changeNext_move(CLICK_CD_FAST)
		return ITEM_INTERACT_SUCCESS

	return ITEM_INTERACT_BLOCKING

/obj/item/mould/proc/try_filling(mob/living/user, obj/item/storage/crucible)
	var/datum/reagent/molten_metal/metal = crucible.reagents.get_reagent(/datum/reagent/molten_metal)
	if(!metal || cooling)
		return FALSE

	if(!filling_metal)
		var/list/names = list()
		for(var/datum/material/material as anything in metal.data)
			if(!ispath(material))
				continue
			if(crucible.reagents.chem_temp < initial(material.melting_point))
				continue
			names |= initial(material.name)

		var/choice
		if(length(names) == 1)
			choice = names[1]
		else
			choice = browser_input_list(user, "What metal to pour?", items = names)
			if(!choice)
				return FALSE

		for(var/datum/material/material as anything in metal.data)
			if(!ispath(material))
				continue
			if(choice != initial(material.name))
				continue
			filling_metal = material
			break

	if(!filling_metal || !(filling_metal in metal.data))
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

	var/amt2raise = max(GET_MOB_ATTRIBUTE_VALUE(user, STAT_INTELLIGENCE), 1)
	amt2raise *= (metal_amount / required_metal_amount)
	amt2raise *= user.get_learning_boon(/datum/attribute/skill/craft/smelting)
	user.mind.add_sleep_experience(/datum/attribute/skill/craft/smelting, amt2raise)
	SEND_SIGNAL(user, COMSIG_ITEM_SMELTED)

	to_chat(user, span_notice("I pour [UNIT_FORM_STRING(metal_amount)] of [filling_metal.name] into [src]."))
	fufilled_metal += metal_amount
	update_appearance(UPDATE_OVERLAYS)
	check_start_conditions()

/obj/item/mould/proc/check_start_conditions()
	if(fufilled_metal >= required_metal_amount)
		start_cooling()
		return TRUE
	return FALSE

/obj/item/mould/update_icon_state()
	. = ..()
	if(!base_icon_state)
		return

	icon_state = "[base_icon_state]_mould"
	fill_icon_state = "[base_icon_state]_filling"

	return TRUE

/obj/item/mould/update_overlays()
	. = ..()
	if(!fufilled_metal)
		return
	. += mutable_appearance(
		icon,
		fill_icon_state,
		color = initial(filling_metal.color),
		alpha = (255 * (fufilled_metal / required_metal_amount)),
		appearance_flags = RESET_COLOR | KEEP_APART,
	)
	var/mutable_appearance/MA = emissive_appearance(icon, fill_icon_state)
	if(cooling)
		MA.alpha = 255 * round((1 - (cooling_progress / 100)),0.1)
	else
		MA.alpha = 255 * (fufilled_metal / required_metal_amount)
	. += MA

/obj/item/mould/proc/start_cooling()
	visible_message(span_info("[src] begins to cool."), vision_distance = COMBAT_MESSAGE_RANGE)
	cooling = TRUE
	START_PROCESSING(SSobj, src)

/obj/item/mould/process(delta_time)
	cooling_progress += cooling_amount * delta_time
	update_appearance(UPDATE_OVERLAYS)
	if(cooling_progress >= 100)
		STOP_PROCESSING(SSobj, src)
		create_item()

/obj/item/mould/proc/create_item()
	reset_state()

/obj/item/mould/attack_self(mob/user, list/modifiers)
	. = TRUE
	if(cooling)
		return
	reset_state()
	to_chat(user, span_notice("I reset the state of [src]."))

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

	icon_state = "ingot_mould"
	fill_icon_state = "ingot_filling"

	required_metal_amount = 100

	grid_width = 64
	grid_height = 32
	item_weight = 650 GRAMS

/obj/item/mould/ingot/create_item()
	output_atom = initial(filling_metal.solid_form)
	if(output_atom == /obj/item/ingot/blacksteel)
		record_round_statistic(STATS_BLACKSTEEL_SMELTED)

	if(output_atom)
		var/obj/item/new_item = new output_atom(get_turf(src))

		var/datum/quality_calculator/metallurgy/metal_calc = new(
			mat_qual = average_quality, // Use the stored weighted average quality
			skill_qual = average_skill
		)
		metal_calc.apply_quality_to_item(new_item, TRUE)
		qdel(metal_calc)

	return ..()

/obj/item/mould/ingot/reset_state()
	. = ..()
	output_atom = null

/obj/item/mould/ingot/advanced
	name = "advanced ingot mould"
	desc = "An ingot mould that utilizes water for faster cooling."
	cooling_amount = 7.5

// --------- CUSTOMIZABLE -----------
/obj/item/mould/customizable
	name = "custom casting mould"
	desc = "A blank mould that is ready to have its shape set by steady hands."
	icon_state = "base_large_mould"
	fill_icon_state = "base_large_filling"
	smeltresult = /obj/item/mould/customizable // melt it down to reset it
	var/datum/anvil_recipe/moulded_recipe
	cooling_amount = 1

	// We are bascially going to fake the anvil recipe
	var/list/metals_needed = list()
	var/list/additional_items = list()

/obj/item/mould/customizable/custom_examine(list/examine_list)
	if(!moulded_recipe)
		examine_list += span_info("Use an item with an anvil recipe to set the shape of the mould.")
	else
		var/list/metal_examine = list()
		for(var/datum/material/material as anything in metals_needed)
			metal_examine += "[metals_needed[material]] [material.name]"
		if(length(metal_examine))
			examine_list += span_info("Needs [metal_examine.Join(", ")]")

		var/list/item_examine = list()
		for(var/atom/thing as anything in additional_items)
			item_examine += "[thing.name]"
		if(length(item_examine))
			examine_list += span_info("Needs [item_examine.Join(", ")]")
	return examine_list

/obj/item/mould/customizable/interact_with_atom(atom/interacting_with, mob/living/user, list/modifiers)
	if(user.cmode)
		return

	if(!moulded_recipe)
		set_recipe(interacting_with, user)
	else
		if(istype(interacting_with, /obj/item/weapon/tongs))
			var/obj/item/weapon/tongs/tongs = interacting_with
			if(tongs.held_item)
				interacting_with = tongs.held_item

		if(istype(interacting_with, /obj/item/storage/crucible))
			try_filling(interacting_with, user)
		else
			try_adding(interacting_with, user)
	return ITEM_INTERACT_SUCCESS

/obj/item/mould/customizable/proc/set_recipe(obj/item/attacking_item, mob/living/user)
	if(moulded_recipe)
		return

	var/item_type = attacking_item.type
	var/datum/anvil_recipe/found_recipe = GLOB.anvil_recipes_atom[item_type]
	if(!found_recipe)
		return

	var/confirmation = tgui_alert(user, "Do you want to set the mould cast to [found_recipe.name]?", "[name]", DEFAULT_INPUT_CHOICES)
	if(!confirmation || confirmation != CHOICE_YES)
		return
	if(moulded_recipe)
		return

	moulded_recipe = new found_recipe()
	if(ispath(item_type, /obj/item/weapon/pick))
		base_icon_state = "pick"
	else if(ispath(item_type, /obj/item/weapon/polearm))
		base_icon_state = "polearm"
	else if(ispath(item_type, /obj/item/weapon/sword))
		base_icon_state = "sword"
	else if(ispath(item_type, /obj/item/weapon/axe))
		base_icon_state = "axe"
	else if(ispath(item_type, /obj/item/weapon/mace))
		base_icon_state = "mace"
	else if(ispath(item_type,  /obj/item/weapon/knife))
		base_icon_state = "knife"
	else if(ispath(item_type, /obj/item/clothing/armor))
		base_icon_state = "plate"
	else
		base_icon_state = "plate"

	name = LOWER_TEXT("[moulded_recipe.name] mould")
	desc = "Hollowed out and ready to accept liquid metal for casting."
	update_appearance(UPDATE_ICON_STATE)
	find_recipe_requirements()

/obj/item/mould/customizable/proc/find_recipe_requirements()
	metals_needed = list()
	additional_items = list()
	if(!moulded_recipe)
		return
	var/obj/item/item_of_interest = moulded_recipe.required_material
	var/datum/material/material = initial(item_of_interest.melting_material)
	var/melty = initial(item_of_interest.melt_amount)
	if(!material)
		var/obj/item/ingot = initial(item_of_interest.smeltresult)
		material = initial(ingot.melting_material)
		melty = 100
	if(material && !ispath(material, /datum/material/coke))
		metals_needed[material] += melty
	else
		additional_items += item_of_interest

	for(var/obj/item/item_path as anything in moulded_recipe.additional_items)
		material = initial(item_path.melting_material)
		melty = initial(item_path.melt_amount)
		if(!material)
			var/obj/item/ingot = initial(item_path.smeltresult)
			material = initial(ingot.melting_material)
			melty = 100
		if(material && !ispath(material, /datum/material/coke))
			metals_needed[material] += melty
		else
			additional_items += item_path

	var/biggest_metal
	var/highest = 0
	for(var/path in metals_needed)
		var/metal_amount = metals_needed[path]
		if(metal_amount > highest)
			biggest_metal = path
			highest = metal_amount
		required_metal_amount += metal_amount

	filling_metal = biggest_metal

/obj/item/mould/customizable/try_filling(obj/item/storage/crucible/crucible, mob/living/user)
	if(cooling)
		return
	var/datum/reagent/molten_metal/metal = crucible.reagents.get_reagent(/datum/reagent/molten_metal)
	if(!metal)
		return

	for(var/datum/material/material as anything in metal.data)
		if(!ispath(material))
			continue
		if(crucible.reagents.chem_temp < initial(material.melting_point))
			continue
		if(!(material in metals_needed))
			continue

		var/metal_amount = min(metal.data[material], metals_needed[material])

		metal.data[material] -= metal_amount
		if(!metal.data[material])
			metal.data -= material
		crucible.reagents.remove_reagent(/datum/reagent/molten_metal, metal_amount)
		if(!QDELETED(metal))
			metal.find_largest_metal()

		metals_needed[material] -= metal_amount
		if(!metals_needed[material])
			metals_needed -= material

		to_chat(user, span_notice("I pour [UNIT_FORM_STRING(metal_amount)] of [material.name] into [src]."))
		fufilled_metal += metal_amount

	update_appearance(UPDATE_OVERLAYS)
	check_start_conditions(user)

/obj/item/mould/customizable/proc/try_adding(atom/interacting_with, mob/living/user)
	if(cooling)
		return

	if(interacting_with.type in additional_items)
		additional_items -= interacting_with.type
		to_chat(user, span_notice("I add [interacting_with] to [src]."))
		qdel(interacting_with)

	check_start_conditions(user)

/obj/item/mould/customizable/reset_state()
	. = ..()
	find_recipe_requirements()

/obj/item/mould/customizable/check_start_conditions(mob/living/user)
	if(!length(metals_needed) && !length(additional_items))
		start_cooling()
		if(user)
			var/recipe_skill = moulded_recipe.appro_skill
			var/amt2raise = max(GET_MOB_ATTRIBUTE_VALUE(user, STAT_INTELLIGENCE), 1) * 1.5
			amt2raise *= user.get_learning_boon(recipe_skill)
			if(HAS_TRAIT(user, TRAIT_MALUMFIRE) || GET_MOB_SKILL_VALUE_OLD(user, recipe_skill) < 3)// Sanity, no expert blacksmith has lower skill than 3, for if admins manually add the trait or blacksmith vampire thralls
				user.mind.add_sleep_experience(recipe_skill, amt2raise, FALSE)
		return TRUE

	return FALSE

/obj/item/mould/customizable/create_item()
	moulded_recipe.accumulated_quality = 1
	moulded_recipe.num_of_materials = 1
	moulded_recipe.numberofhits = 1
	moulded_recipe.accumulated_quality = MINIMUM_ANVIL_MINIGAME_SCORE
	moulded_recipe.material_quality = SMELTERY_QUALITY_NORMAL
	moulded_recipe.skill_quality = 3.5
	moulded_recipe.handle_creation(get_turf(src))
	return ..()
