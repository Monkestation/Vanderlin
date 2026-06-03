
/mob/living/carbon/proc/item_heal(mob/user, brute_heal, burn_heal, heal_message_brute, heal_message_burn, required_bodytype, obj/item/item_source)
	var/obj/item/bodypart/affecting = src.get_bodypart(check_zone(user.zone_selected))
	if (!affecting || !(affecting.status == required_bodytype))
		to_chat(user, span_warning("[affecting] is already in good condition!"))
		return FALSE

	var/brute_damaged = affecting.brute_dam > 0
	var/burn_damaged = affecting.burn_dam > 0

	var/nothing_to_heal = (brute_heal <= 0 || !brute_damaged) && (burn_heal <= 0 || !burn_damaged) && !length(affecting.wounds)
	if (nothing_to_heal)
		to_chat(user, span_notice("[affecting] is already in good condition!"))
		return FALSE

	var/message
	if ((brute_damaged && brute_heal > 0) && (burn_damaged && burn_heal > 0))
		message = "[heal_message_brute] and [heal_message_burn] on"
	else if (brute_damaged && brute_heal > 0)
		message = "[heal_message_brute] on"
	else if(burn_damaged && burn_heal > 0)
		message = "[heal_message_burn] on"
	else
		message = "damaged metal"
	if(affecting.heal_damage(brute_heal, burn_heal, required_bodytype))
		update_damage_overlays()
	if(length(affecting.wounds))
		if(user == src)
			affecting.heal_wounds(2, item_source)
		else
			affecting.heal_wounds(10, item_source)
	user.visible_message(span_notice("[user] fixes some of the [message] [src]'s [affecting.name]."), \
		span_notice("You fix some of the [message] [src == user ? "your" : "[src]'s"] [affecting.name]."), \
		vision_distance = COMBAT_MESSAGE_RANGE)
	return TRUE
