
/obj/structure/sign/property_sign
	name = "Property Sign"
	desc = "A sign for property management."
	icon = 'icons/roguetown/misc/structure.dmi'
	icon_state = "questnoti"

	var/obj/effect/landmark/house_spot/linked_property

/obj/structure/sign/property_sign/proc/setup_property_link(obj/effect/landmark/house_spot/property)
	linked_property = property

/obj/structure/sign/property_sign/proc/check_other_players(mob/user)
	if(!linked_property)
		return FALSE

	var/turf/start_turf = get_turf(linked_property)
	if(!start_turf)
		return FALSE

	var/minx = start_turf.x
	var/miny = start_turf.y
	var/minz = start_turf.z
	var/maxx = minx + linked_property.template_x - 1
	var/maxy = miny + linked_property.template_y - 1
	var/maxz = minz + linked_property.template_z - 1

	for(var/turf/T in block(locate(minx, miny, minz), locate(maxx, maxy, maxz)))
		for(var/mob/M in T.contents)
			if(M == user)
				continue
			if(M.client)
				return TRUE
	return FALSE

/obj/structure/sign/property_sign/claim
	var/claimed = FALSE

/obj/structure/sign/property_sign/claim/attack_hand(mob/user)
	. = ..()
	if(!user.client || !linked_property)
		return

	// If already claimed by this user, allow saving
	if(linked_property?.owner_ckey == user.ckey)
		save_property_design(user)
		return

	// Check if already claimed
	if(SShousing.temporary_claims[linked_property.property_id])
		to_chat(user, span_warning("This property is already claimed!"))
		return

	// Check job restriction
	if(!linked_property.check_job_requirement(user))
		to_chat(user, span_warning("Only the following can claim this property: [linked_property.get_required_jobs_string()]"))
		return

	// Check if user already owns a property with this save_id
	if(SShousing.player_owns_save_id(user.ckey, linked_property.save_id))
		to_chat(user, span_warning("You already have a property of this type!"))
		return

	if(check_other_players(user))
		to_chat(user, span_warning("Cannot claim while others are present!"))
		return

	// Show slot selection interface
	show_slot_selection(user)

/obj/structure/sign/property_sign/claim/proc/show_slot_selection(mob/user)
	if(!user || !user.client || !linked_property)
		return

	var/list/available_slots = SShousing.get_player_property_slots(user.ckey, linked_property.save_id)
	var/list/options = list()

	// Add existing slots
	for(var/slot in available_slots)
		options["Load Design [slot]"] = slot

	//create new option
	var/next_slot = 1
	if(length(available_slots) > 0)
		next_slot = available_slots[length(available_slots)] + 1
	options["Create New Design ([next_slot])"] = next_slot

	options["Cancel"] = null

	var/choice = input(user, "Select a property design slot:", "Property Claim") as null|anything in options
	if(!choice || options[choice] == null)
		return

	var/selected_slot = options[choice]

	if(check_other_players(user))
		to_chat(user, span_warning("Someone entered the area!"))
		return

	if(SShousing.claim_temporary(linked_property, user, selected_slot))
		claimed = TRUE
		name = "Claimed Property (Slot [selected_slot])"
		desc = "Click to save your current design to slot [selected_slot]."
		to_chat(user, span_notice("Property claimed with design slot [selected_slot]! Click again to save changes."))
	else
		to_chat(user, span_warning("Failed to claim property!"))

/obj/structure/sign/property_sign/claim/proc/save_property_design(mob/user)
	if(!linked_property || linked_property.owner_ckey != user.ckey)
		return

	var/slot = linked_property.owner_property_slot
	if(!slot)
		to_chat(user, span_warning("No slot assigned to this property!"))
		return

	var/confirm = tgui_alert(user, "Save the current state to design slot [slot]?", "Save Property", list("Yes", "No"))
	if(confirm != "Yes")
		return

	if(SShousing.save_property(linked_property, user.ckey, slot))
		to_chat(user, span_notice("Property saved successfully to slot [slot]!"))
	else
		to_chat(user, span_warning("Failed to save property!"))
