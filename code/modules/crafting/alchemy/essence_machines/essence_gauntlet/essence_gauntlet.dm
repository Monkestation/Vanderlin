/obj/item/clothing/gloves/essence_gauntlet
	name = "essence gauntlet"
	desc = "A gauntlet that can store alchemical essences and channel them into alchemical spells. Advanced combinations can unlock powerful effects."
	icon_state = "essence_gauntlet"
	var/list/obj/item/essence_vial/stored_vials = list()
	var/max_vials = 4

/obj/item/clothing/gloves/essence_gauntlet/equipped(mob/user, slot)
	. = ..()
	if(slot & ITEM_SLOT_GLOVES)
		grant_essence_spells(user)

/obj/item/clothing/gloves/essence_gauntlet/dropped(mob/user)
	. = ..()
	remove_essence_spells(user)

/obj/item/clothing/gloves/essence_gauntlet/attack_hand_secondary(mob/user, list/modifiers)
	. = ..()
	if(. == SECONDARY_ATTACK_CANCEL_ATTACK_CHAIN)
		return
	. = SECONDARY_ATTACK_CANCEL_ATTACK_CHAIN

	if(!length(stored_vials))
		to_chat(user, span_warning("[src] has no vials to remove!"))
		return

	// Create radial menu for vial selection
	var/list/radial_options = list()
	var/list/vial_mapping = list()
	for(var/i in 1 to length(stored_vials))
		var/obj/item/essence_vial/vial = stored_vials[i]
		var/vial_desc = "Vial [i]"
		var/display_name = "Vial [i]"
		if(vial.contained_essence && vial.essence_amount > 0)
			if(HAS_TRAIT(user, TRAIT_LEGENDARY_ALCHEMIST))
				vial_desc += " - [vial.contained_essence.name] ([vial.essence_amount] units)"
				display_name = "[vial.contained_essence.name]"
			else
				vial_desc += " - essence smelling of [vial.contained_essence.smells_like] ([vial.essence_amount] units)"
				display_name = "Essence smelling of [vial.contained_essence.smells_like]"
		else
			vial_desc += " - empty"
			display_name = "Empty vial"

		var/datum/radial_menu_choice/choice = new()
		var/image/image = image(icon = 'icons/roguetown/misc/alchemy.dmi', icon_state = "essence")
		if(vial.contained_essence && vial.essence_amount > 0)
			image.color = vial.contained_essence.color
		choice.image = image
		choice.name = display_name
		if(vial.contained_essence && vial.essence_amount > 0)
			if(HAS_TRAIT(user, TRAIT_LEGENDARY_ALCHEMIST))
				choice.info = "Remove vial containing [vial.contained_essence.name] ([vial.essence_amount] units)"
			else
				choice.info = "Remove vial containing essence smelling of [vial.contained_essence.smells_like] ([vial.essence_amount] units)"
		else
			choice.info = "Remove empty vial"
		radial_options[vial_desc] = choice
		vial_mapping[vial_desc] = vial

	var/choice = show_radial_menu(user, src, radial_options, custom_check = CALLBACK(src, PROC_REF(check_gauntlet_validity), user), radial_slice_icon = "radial_thaum")
	if(!choice || !vial_mapping[choice])
		return
	var/obj/item/essence_vial/chosen_vial = vial_mapping[choice]
	stored_vials -= chosen_vial
	chosen_vial.forceMove(get_turf(user))
	user.put_in_hands(chosen_vial)
	to_chat(user, span_notice("You remove [chosen_vial] from [src]."))
	// Update spells if currently equipped
	if(ishuman(user) && user.get_item_by_slot(ITEM_SLOT_GLOVES) == src)
		remove_essence_spells(user)
		grant_essence_spells(user)

/obj/item/clothing/gloves/essence_gauntlet/proc/check_gauntlet_validity(mob/user)
	return user && src.loc == user

/obj/item/clothing/gloves/essence_gauntlet/attackby(obj/item/I, mob/user, list/modifiers)
	if(istype(I, /obj/item/essence_vial))
		var/obj/item/essence_vial/vial = I
		if(!vial.contained_essence || vial.essence_amount <= 0)
			to_chat(user, span_warning("[vial] is empty!"))
			return

		if(length(stored_vials) >= max_vials)
			to_chat(user, span_warning("[src] cannot hold any more essence vials!"))
			return

		if(!user.transferItemToLoc(vial, src))
			return

		stored_vials += vial
		to_chat(user, span_notice("You insert [vial] into [src]."))

		// Update spells if currently equipped
		if(ishuman(user) && user.get_item_by_slot(ITEM_SLOT_GLOVES) == src)
			remove_essence_spells(user)
			grant_essence_spells(user)
		return

	return ..()

/obj/item/clothing/gloves/essence_gauntlet/proc/can_consume_essence(required_amount, list/required_attunements)
	var/total_available = 0

	if(!required_attunements || !length(required_attunements))
		for(var/obj/item/essence_vial/vial in stored_vials)
			if(vial.contained_essence && vial.essence_amount > 0)
				total_available += vial.essence_amount
		return total_available >= required_amount

	for(var/attunement_path in required_attunements)
		var/essence_type = extract_essence_type(attunement_path)
		for(var/obj/item/essence_vial/vial in stored_vials)
			if(vial.contained_essence && vial.contained_essence.type == essence_type)
				total_available += vial.essence_amount

	return total_available >= required_amount

/obj/item/clothing/gloves/essence_gauntlet/proc/consume_essence(amount, list/required_attunements)
	var/remaining_to_consume = amount

	if(!required_attunements || !length(required_attunements))
		for(var/obj/item/essence_vial/vial in stored_vials)
			if(remaining_to_consume <= 0)
				break
			if(vial.contained_essence && vial.essence_amount > 0)
				var/to_consume = min(vial.essence_amount, remaining_to_consume)
				vial.essence_amount -= to_consume
				remaining_to_consume -= to_consume
				if(vial.essence_amount <= 0)
					vial.contained_essence = null
				vial.update_appearance(UPDATE_OVERLAYS)
		return remaining_to_consume <= 0

	for(var/attunement_path in required_attunements)
		if(remaining_to_consume <= 0)
			break
		var/essence_type = extract_essence_type(attunement_path)
		for(var/obj/item/essence_vial/vial in stored_vials)
			if(remaining_to_consume <= 0)
				break
			if(vial.contained_essence && vial.contained_essence.type == essence_type && vial.essence_amount > 0)
				var/to_consume = min(vial.essence_amount, remaining_to_consume)
				vial.essence_amount -= to_consume
				remaining_to_consume -= to_consume
				if(vial.essence_amount <= 0)
					vial.contained_essence = null
				vial.update_appearance(UPDATE_OVERLAYS)

	return remaining_to_consume <= 0

/obj/item/clothing/gloves/essence_gauntlet/proc/extract_essence_type(attunement_path)
	switch(attunement_path)
		if(/datum/attunement/aeromancy)
			return /datum/thaumaturgical_essence/air
		if(/datum/attunement/blood)
			return /datum/thaumaturgical_essence/water
		if(/datum/attunement/fire)
			return /datum/thaumaturgical_essence/fire
		if(/datum/attunement/earth)
			return /datum/thaumaturgical_essence/earth
		if(/datum/attunement/ice)
			return /datum/thaumaturgical_essence/frost
		if(/datum/attunement/light)
			return /datum/thaumaturgical_essence/light
		if(/datum/attunement/life)
			return /datum/thaumaturgical_essence/life
		if(/datum/attunement/polymorph)
			return /datum/thaumaturgical_essence/chaos
	return null

/obj/item/clothing/gloves/essence_gauntlet/proc/get_available_essence_types()
	var/list/available_types = list()
	for(var/obj/item/essence_vial/vial in stored_vials)
		if(vial.contained_essence && vial.essence_amount > 0)
			available_types[vial.contained_essence.type] = TRUE
	return available_types

/obj/item/clothing/gloves/essence_gauntlet/proc/grant_essence_spells(mob/user)
	if(!isliving(user))
		return

	var/list/available_essences = get_available_essence_types()

	for(var/datum/essence_combo/combo in GLOB.essence_combos)
		if(combo.can_activate(available_essences, user))
			combo.apply_effects(src, user)

/obj/item/clothing/gloves/essence_gauntlet/proc/remove_essence_spells(mob/user)
	if(!isliving(user) || !user.mind)
		return

	var/list/available_essences = get_available_essence_types()

	for(var/datum/essence_combo/combo in GLOB.essence_combos)
		if(combo.can_activate(available_essences, user))
			combo.remove_effects(src, user)

	var/mob/living/living_user = user
	living_user.remove_spells(source = src)

/obj/item/clothing/gloves/essence_gauntlet/proc/essence_failure_feedback(mob/user)
	to_chat(user, span_warning("[src] lacks sufficient essence to cast that spell!"))
	return TRUE

/obj/item/clothing/gloves/essence_gauntlet/proc/get_gauntlet_user()
	return loc

/obj/item/clothing/gloves/essence_gauntlet/examine(mob/user)
	. = ..()
	. += span_notice("Essence Vials ([length(stored_vials)]/[max_vials]):")

	if(!length(stored_vials))
		. += span_notice("- No vials inserted")
		. += span_notice("Right-click to remove vials when available")
		return

	// Show stored vials
	for(var/i in 1 to length(stored_vials))
		var/obj/item/essence_vial/vial = stored_vials[i]
		if(vial.contained_essence && vial.essence_amount > 0)
			if(HAS_TRAIT(user, TRAIT_LEGENDARY_ALCHEMIST))
				. += span_notice("- [vial.essence_amount] units of [vial.contained_essence.name]")
			else
				. += span_notice("- [vial.essence_amount] units of essence smelling of [vial.contained_essence.smells_like]")
		else
			. += span_notice("- Empty vial")

	. += span_notice("Right-click to remove vials")

	// Show available combos
	var/list/available_essences = get_available_essence_types()
	var/combo_count = 0
	var/non_spell_combos = list()

	for(var/datum/essence_combo/combo in GLOB.essence_combos)
		if(combo.can_activate(available_essences, user))
			combo_count++
			if(!istype(combo, /datum/essence_combo/spell))
				non_spell_combos += combo.name

	if(combo_count > 0)
		. += span_notice("\nActive Effects:")
		if(length(non_spell_combos))
			for(var/combo_name in non_spell_combos)
				. += span_notice("- [combo_name]")

		var/spell_combos = combo_count - length(non_spell_combos)
		if(spell_combos > 0)
			. += span_notice("- [spell_combos] spell effect[spell_combos > 1 ? "s" : ""] available")
	else
		. += span_notice("\nNo essence effects active")
