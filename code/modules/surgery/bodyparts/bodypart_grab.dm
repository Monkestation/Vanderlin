
/obj/item/bodypart/grabbedintents(mob/living/user, atom/grabbed, precise)
	return list(/datum/intent/grab/move, /datum/intent/grab/twist, /datum/intent/grab/smash)

/obj/item/bodypart/l_arm/grabbedintents(mob/living/user, atom/grabbed, precise)
	var/used_limb = precise
	if(user == grabbed)
		return list(/datum/intent/grab/move, /datum/intent/grab/twist, /datum/intent/grab/smash)
	if(used_limb == BODY_ZONE_PRECISE_L_HAND)
		return list(/datum/intent/grab/move, /datum/intent/grab/twist, /datum/intent/grab/smash, /datum/intent/grab/disarm)
	else
		return list(/datum/intent/grab/move, /datum/intent/grab/twist, /datum/intent/grab/smash, /datum/intent/grab/armdrag)

/obj/item/bodypart/r_arm/grabbedintents(mob/living/user, atom/grabbed, precise)
	var/used_limb = precise
	if(user == grabbed)
		return list(/datum/intent/grab/move, /datum/intent/grab/twist, /datum/intent/grab/smash)
	if(used_limb == BODY_ZONE_PRECISE_R_HAND)
		return list(/datum/intent/grab/move, /datum/intent/grab/twist, /datum/intent/grab/smash, /datum/intent/grab/disarm)
	else
		return list(/datum/intent/grab/move, /datum/intent/grab/twist, /datum/intent/grab/smash, /datum/intent/grab/armdrag)

/obj/item/bodypart/chest/grabbedintents(mob/living/user, atom/grabbed, precise)
	if(precise == BODY_ZONE_PRECISE_GROIN)
		if(user == grabbed)
			return list(/datum/intent/grab/move, /datum/intent/grab/twist)
		else
			return list(/datum/intent/grab/move, /datum/intent/grab/twist, /datum/intent/grab/shove)
	if(user == grabbed)
		return list(/datum/intent/grab/move)
	else
		return list(/datum/intent/grab/move, /datum/intent/grab/shove)
