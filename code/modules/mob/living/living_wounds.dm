/mob/living
	/// Simple wound instances with no associated bodyparts
	var/list/datum/wound/simple_wounds
	/// Simple embedded objects with no associated bodyparts
	var/list/obj/item/simple_embedded_objects

/// Returns every embedded object we have, simple or not
/mob/living/proc/get_embedded_objects()
	var/list/all_embedded_objects = list()
	if(length(simple_embedded_objects))
		all_embedded_objects += simple_embedded_objects
	return all_embedded_objects

/// Checks if we have any embedded objects whatsoever
/mob/living/proc/has_embedded_objects()
	return length(get_embedded_objects())

/// Checks if we have an embedded object of a specific type
/mob/living/proc/has_embedded_object(path, specific = FALSE)
	if(!path)
		return
	for(var/obj/item/embedder as anything in get_embedded_objects())
		if((specific && embedder.type != path) || !istype(embedder, path))
			continue
		return embedder

/// Checks if an object is embedded in us
/mob/living/proc/is_object_embedded(obj/item/embedder)
	if(!embedder)
		return FALSE
	return (embedder in get_embedded_objects())

/// Returns every wound we have, simple or not
/mob/living/proc/get_wounds()
	var/list/all_wounds = list()
	if(length(simple_wounds))
		all_wounds += simple_wounds
	return all_wounds

/// Gets all sewable wounds in a mob
/mob/living/proc/get_sewable_wounds()
	var/list/woundies = list()
	for(var/datum/wound/wound as anything in get_wounds())
		if(!wound.can_sew)
			continue
		woundies += wound
	return woundies

/// Loops through our list of wounds and returns the first wound that is of the type specified by the path
/mob/living/proc/has_wound(path, specific = FALSE)
	if(!path)
		return
	for(var/datum/wound/wound as anything in get_wounds())
		if((specific && wound.type != path) || !istype(wound, path))
			continue
		return wound

/// Loops through our list of wounds healing them until we run out of healing or all wounds are healed
/mob/living/proc/heal_wounds(heal_amount)
	var/healed_any = FALSE
	for(var/datum/wound/wound as anything in get_wounds())
		if(heal_amount <= 0)
			continue
		var/amount_healed = wound.heal_wound(heal_amount)
		if(amount_healed)
			heal_amount -= amount_healed
			healed_any = TRUE
	return healed_any

/// Simple version for adding a wound - DO NOT CALL THIS ON CARBON MOBS!
/mob/living/proc/simple_add_wound(datum/wound/wound, silent = FALSE, crit_message = FALSE)
	if(!wound || (status_flags & GODMODE) || !HAS_TRAIT(src, TRAIT_SIMPLE_WOUNDS))
		return FALSE
	if(ispath(wound, /datum/wound))
		var/datum/wound/primordial_wound = GLOB.primordial_wounds[wound]
		if(!primordial_wound.can_apply_to_mob(src))
			return
		wound = new wound()
	else if(!istype(wound))
		return
	else if(!wound.can_apply_to_mob(src))
		qdel(wound)
		return
	if(!wound.apply_to_mob(src, silent, crit_message))
		qdel(wound)
		return
	SEND_SIGNAL(src, COMSIG_LIVING_WOUND_GAINED, wound)
	return wound

/// Simple version for removing a wound - DO NOT CALL THIS ON CARBON MOBS!
/mob/living/proc/simple_remove_wound(datum/wound/wound)
	if(!wound || !HAS_TRAIT(src, TRAIT_SIMPLE_WOUNDS))
		return FALSE
	if(ispath(wound))
		wound = has_wound(wound)
	if(!istype(wound))
		return FALSE
	. = wound.remove_from_mob()
	if(.)
		qdel(wound)

/// Simple version of crit rolling, attempts to do a critical hit on a mob that uses simple wounds - DO NOT CALL THIS ON CARBON MOBS, THEY HAVE BODYPARTS!
/mob/living/proc/simple_woundcritroll(bclass, dam, mob/living/user, zone_precise, silent = FALSE, crit_message = FALSE)
	if(!bclass || !dam || (status_flags & GODMODE) || !HAS_TRAIT(src, TRAIT_SIMPLE_WOUNDS))
		return

	var/do_crit = TRUE
	if(user)
		if(user.stat_roll(STATKEY_LCK,2,10))
			dam += 10
		if(istype(user.rmb_intent, /datum/rmb_intent/weak))
			do_crit = FALSE

	var/added_wound
	switch(bclass) //do stuff but only when we are a blade that adds wounds
		if(BCLASS_SMASH, BCLASS_BLUNT, BCLASS_PUNCH)
			switch(dam)
				if(20 to INFINITY)
					added_wound = /datum/wound/bruise/large
				if(10 to 20)
					added_wound = /datum/wound/bruise
				if(1 to 10)
					added_wound = /datum/wound/bruise/small

		if(BCLASS_CUT, BCLASS_CHOP)
			switch(dam)
				if(20 to INFINITY)
					added_wound = /datum/wound/slash/large
				if(10 to 20)
					added_wound = /datum/wound/slash
				if(1 to 10)
					added_wound = /datum/wound/slash/small

		if(BCLASS_STAB, BCLASS_PICK, BCLASS_SHOT, BCLASS_PIERCE)
			switch(dam)
				if(20 to INFINITY)
					added_wound = /datum/wound/puncture/large
				if(10 to 20)
					added_wound = /datum/wound/puncture
				if(1 to 10)
					added_wound = /datum/wound/puncture/small

		if(BCLASS_LASHING)
			switch(dam)
				if(20 to INFINITY)
					added_wound = /datum/wound/lashing/large
				if(10 to 20)
					added_wound = /datum/wound/lashing
				if(1 to 10)
					added_wound = /datum/wound/lashing/small

		if(BCLASS_BITE)
			switch(dam)
				if(20 to INFINITY)
					added_wound = /datum/wound/bite/large
				if(10 to 20)
					added_wound = /datum/wound/bite
				if(1 to 10)
					added_wound = /datum/wound/bite/small

	if(added_wound)
		added_wound = simple_add_wound(added_wound, silent, crit_message)

	if(do_crit)
		var/crit_attempt = simple_try_crit(bclass, dam, user, zone_precise, silent, crit_message)
		if(crit_attempt)
			return crit_attempt

	return added_wound

/// Tries to do a critical hit on a mob that uses simple wounds - DO NOT CALL THIS ON CARBON MOBS, THEY HAVE BODYPARTS!
/mob/living/proc/simple_try_crit(bclass, dam, mob/living/user, zone_precise, silent = FALSE, crit_message = FALSE)
	if(!bclass || !dam || (status_flags & GODMODE) || !HAS_TRAIT(src, TRAIT_SIMPLE_WOUNDS))
		return FALSE
	var/used
	if(user)
		if(user.stat_roll(STATKEY_LCK,2,10))
			dam += 10

	var/list/crit_classes
	if(bclass in GLOB.fracture_bclasses)
		LAZYADD(crit_classes, "fracture")
	if(bclass in GLOB.artery_bclasses)
		LAZYADD(crit_classes, "artery")

	if(!LAZYLEN(crit_classes))
		return FALSE

	var/list/attempted_wounds
	switch(pick(crit_classes))
		if("fracture")
			if(user && istype(user.rmb_intent, /datum/rmb_intent/strong))
				dam += 10
			used = round((health / maxHealth) * 20 + (dam / 3), 1)
			if(prob(used))
				var/fracture_type = /datum/wound/fracture/chest
				if(check_zone(zone_precise) == BODY_ZONE_HEAD)
					fracture_type = /datum/wound/fracture/head
				LAZYADD(attempted_wounds, fracture_type)
		if("artery")
			if(user)
				if((bclass in GLOB.artery_strong_bclasses) && istype(user.rmb_intent, /datum/rmb_intent/strong))
					dam += 30
				else if(istype(user.rmb_intent, /datum/rmb_intent/aimed))
					dam += 30
			used = round(max(dam / 3, 1), 1)
			if(prob(used))
				LAZYADD(attempted_wounds, /datum/wound/artery/chest)

	if(!LAZYLEN(attempted_wounds))
		return FALSE

	for(var/wound_type in shuffle(attempted_wounds))
		var/datum/wound/applied = simple_add_wound(wound_type, silent, crit_message)
		if(applied)
			if(user?.client)
				record_round_statistic(STATS_CRITS_MADE)
			return applied
	return FALSE

/// Simple version for adding an embedded object - DO NOT CALL THIS ON CARBON MOBS!
/mob/living/proc/simple_add_embedded_object(obj/item/embedder, silent = FALSE, crit_message = FALSE)
	if(!embedder || !embedder.can_embed() || (status_flags & GODMODE) || !HAS_TRAIT(src, TRAIT_SIMPLE_WOUNDS) || HAS_TRAIT(src, TRAIT_PIERCEIMMUNE))
		return FALSE
	LAZYADD(simple_embedded_objects, embedder)
	embedder.is_embedded = TRUE
	embedder.forceMove(src)
	embedder.add_mob_blood(src)
	embedder.embedded(src)
	if(!silent)
		emote("embed")
	if(crit_message)
		next_attack_msg += " <span class='userdanger'>[embedder] is stuck in [src]!</span>"
	return TRUE

/// Simple version for removing an embedded object - DO NOT CALL THIS ON CARBON MOBS!
/mob/living/proc/simple_remove_embedded_object(obj/item/embedder)
	if(!embedder || !HAS_TRAIT(src, TRAIT_SIMPLE_WOUNDS))
		return FALSE
	if(ispath(embedder))
		embedder = has_embedded_object(embedder)
	if(!istype(embedder) || !is_object_embedded(embedder))
		return FALSE
	LAZYREMOVE(simple_embedded_objects, embedder)
	embedder.is_embedded = FALSE
	embedder.unembedded(src)
	if(!QDELETED(embedder))
		var/drop_location = drop_location()
		if(drop_location)
			embedder.forceMove(drop_location)
		else
			qdel(embedder)
	return TRUE
