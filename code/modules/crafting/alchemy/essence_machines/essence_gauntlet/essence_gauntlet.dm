/obj/item/clothing/gloves/essence_gauntlet
	name = "essence gauntlet"
	desc = "A gauntlet that can store alchemical essences and channel them into alchemical spells. Advanced combinations can unlock powerful effects."
	icon_state = "essence_gauntlet"
	var/list/obj/item/essence_vial/stored_vials = list()
	var/max_vials = 4

/obj/item/clothing/gloves/essence_gauntlet/equipped(mob/user, slot)
	. = ..()
	if(slot & ITEM_SLOT_GLOVES)
		refresh_combos(user)

/obj/item/clothing/gloves/essence_gauntlet/dropped(mob/user)
	. = ..()
	clear_combos(user)


/obj/item/clothing/gloves/essence_gauntlet/attack_hand_secondary(mob/user, list/modifiers)
	. = ..()
	if(. == SECONDARY_ATTACK_CANCEL_ATTACK_CHAIN)
		return
	. = SECONDARY_ATTACK_CANCEL_ATTACK_CHAIN

	if(!length(stored_vials))
		to_chat(user, span_warning("[src] has no vials to remove."))
		return

	var/list/radial_options = list()
	var/list/vial_map = list()

	for(var/i in 1 to length(stored_vials))
		var/obj/item/essence_vial/vial = stored_vials[i]
		var/label = vial_label(vial, user, i)
		var/datum/radial_menu_choice/choice = new()
		choice.name = label
		choice.image = vial_radial_image(vial)
		radial_options[label] = choice
		vial_map[label] = vial

	var/picked = show_radial_menu(
		user,
		src,
		radial_options,
		custom_check = CALLBACK(src, PROC_REF(is_worn_by), user),
		radial_slice_icon = "radial_thaum"
	)

	if(!picked || !vial_map[picked])
		return

	var/obj/item/essence_vial/chosen = vial_map[picked]
	stored_vials -= chosen
	chosen.forceMove(get_turf(user))
	user.put_in_hands(chosen)
	to_chat(user, span_notice("You remove [chosen] from [src]."))
	on_vials_changed(user)

/obj/item/clothing/gloves/essence_gauntlet/proc/is_worn_by(mob/user)
	return user && loc == user

/obj/item/clothing/gloves/essence_gauntlet/proc/vial_label(obj/item/essence_vial/vial, mob/user, index)
	if(!vial.contained_essence || vial.essence_amount <= 0)
		return "Empty Vial [index]"
	return "Vial [index] \u2014 [vial.essence_amount] ligulae"

/obj/item/clothing/gloves/essence_gauntlet/proc/vial_radial_image(obj/item/essence_vial/vial)
	var/image/img = image(icon = 'icons/roguetown/misc/alchemy.dmi', icon_state = "essence")
	if(vial.contained_essence && vial.essence_amount > 0)
		img.color = vial.contained_essence.color
	return img


/obj/item/clothing/gloves/essence_gauntlet/proc/on_vials_changed(mob/user)
	if(!ishuman(user) || user.get_item_by_slot(ITEM_SLOT_GLOVES) != src)
		return
	clear_combos(user)
	refresh_combos(user)

/obj/item/clothing/gloves/essence_gauntlet/proc/refresh_combos(mob/user)
	if(!isliving(user))
		return
	var/list/available = get_available_essence_types()
	for(var/datum/essence_combo/combo in GLOB.essence_combos)
		if(combo.can_activate(available, user))
			combo.apply(src, user)

/obj/item/clothing/gloves/essence_gauntlet/proc/clear_combos(mob/user)
	if(!isliving(user) || !user.mind)
		return
	var/mob/living/L = user
	// Passive combos clean themselves up via remove()
	var/list/available = get_available_essence_types()
	for(var/datum/essence_combo/combo in GLOB.essence_combos)
		if(!istype(combo, /datum/essence_combo/spell) && combo.can_activate(available, user))
			combo.remove(src, user)
	// All spell combos swept in one pass
	L.remove_spells(source = src)

/obj/item/clothing/gloves/essence_gauntlet/attackby(obj/item/I, mob/user, list/modifiers)
	if(!istype(I, /obj/item/essence_vial))
		return ..()

	var/obj/item/essence_vial/vial = I

	if(!vial.contained_essence || vial.essence_amount <= 0)
		to_chat(user, span_warning("[vial] is empty!"))
		return

	if(length(stored_vials) >= max_vials)
		to_chat(user, span_warning("[src] is full!"))
		return

	if(!user.transferItemToLoc(vial, src))
		return

	stored_vials += vial
	to_chat(user, span_notice("You slot [vial] into [src]."))
	on_vials_changed(user)

/// Returns TRUE if the gauntlet can cover the cost. Pass null attunements to draw from any essence.
/obj/item/clothing/gloves/essence_gauntlet/proc/can_consume_essence(amount, list/essences = null)
	var/available = 0
	for(var/obj/item/essence_vial/vial in stored_vials)
		if(!vial.contained_essence || vial.essence_amount <= 0)
			continue
		if(essences && !(vial.contained_essence.type in essences))
			continue
		available += vial.essence_amount
	return available >= amount

/// Consumes essence, splitting cost evenly across matching attunements when multiple are required.
/// Returns TRUE on success.
/obj/item/clothing/gloves/essence_gauntlet/proc/consume_essence(amount, list/attunements = null)
	if(!can_consume_essence(amount, attunements))
		return FALSE

	// Build a list of eligible vials grouped by attunement type
	var/list/vials_by_attunement = list()
	for(var/obj/item/essence_vial/vial in stored_vials)
		if(!vial.contained_essence || vial.essence_amount <= 0)
			continue
		var/att = vial.contained_essence.attunement
		if(attunements && !(att in attunements))
			continue
		if(!vials_by_attunement[att])
			vials_by_attunement[att] = list()
		vials_by_attunement[att] += vial

	// Split cost as evenly as possible across attunement groups
	var/list/att_types = vials_by_attunement
	var/num_groups = length(att_types)
	var/remaining = amount

	if(num_groups > 1)
		// First pass: try to take an even share from each group
		var/share = CEILING(amount / num_groups, 1)
		for(var/att in att_types)
			if(remaining <= 0)
				break
			var/to_draw = min(share, remaining)
			var/drawn_from_group = 0
			for(var/obj/item/essence_vial/vial in att_types[att])
				if(to_draw <= 0)
					break
				var/drawn = min(vial.essence_amount, to_draw)
				vial.essence_amount -= drawn
				to_draw -= drawn
				drawn_from_group += drawn
				if(vial.essence_amount <= 0)
					vial.contained_essence = null
				vial.update_appearance(UPDATE_OVERLAYS)
			remaining -= drawn_from_group

	if(remaining > 0)
		for(var/att in att_types)
			if(remaining <= 0)
				break
			for(var/obj/item/essence_vial/vial in att_types[att])
				if(remaining <= 0)
					break
				if(!vial.contained_essence || vial.essence_amount <= 0)
					continue
				var/drawn = min(vial.essence_amount, remaining)
				vial.essence_amount -= drawn
				remaining -= drawn
				if(vial.essence_amount <= 0)
					vial.contained_essence = null
				vial.update_appearance(UPDATE_OVERLAYS)

	return TRUE

/obj/item/clothing/gloves/essence_gauntlet/proc/not_enough_essence(mob/user)
	to_chat(user, span_warning("[src] lacks sufficient essence!"))

/obj/item/clothing/gloves/essence_gauntlet/proc/get_available_essence_types()
	var/list/available_types = list()
	for(var/obj/item/essence_vial/vial in stored_vials)
		if(vial.contained_essence && vial.essence_amount > 0)
			available_types[vial.contained_essence.type] = TRUE
	return available_types

/obj/item/clothing/gloves/essence_gauntlet/proc/essence_failure_feedback(mob/user)
	to_chat(user, span_warning("[src] lacks sufficient essence to cast that spell!"))
	return TRUE

/obj/item/clothing/gloves/essence_gauntlet/proc/get_gauntlet_user()
	return loc

/obj/item/clothing/gloves/essence_gauntlet/examine(mob/user)
	. = ..()
	. += span_notice("Vials: [length(stored_vials)]/[max_vials]")

	if(!length(stored_vials))
		. += span_notice("No vials inserted.")
		return
	for(var/obj/item/essence_vial/vial in stored_vials)
		if(vial.contained_essence && vial.essence_amount > 0)
			. += span_notice("- [vial.essence_amount] ligulae of [HAS_TRAIT(user, TRAIT_LEGENDARY_ALCHEMIST) ? "[vial.contained_essence.name]" : "essence smelling of [vial.contained_essence.smells_like]l"].")
		else
			. += span_notice("- Empty")

	. += span_notice("Right-click to remove a vial.")
