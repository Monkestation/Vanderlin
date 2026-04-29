/mob/proc/dice_roll(dices_num = 1, hardness = 1, atom/rollviewer)
	var/wins = 0
	var/crits = 0
	var/brokes = 0
	for(var/i in 1 to dices_num)
		var/roll = rand(1, 10)
		if(roll == 10)
			crits += 1
		if(roll == 1)
			brokes += 1
		else if(roll >= hardness)
			wins += 1
	if(crits > brokes)
		if(rollviewer)
			to_chat(rollviewer, "<b>Critical <span class='nicegreen'>hit</span>!</b>")
			return DICE_CRIT_WIN
	if(crits < brokes)
		if(rollviewer)
			to_chat(rollviewer, "<b>Critical <span class='danger'>failure</span>!</b>")
			return DICE_CRIT_FAILURE
	if(crits == brokes && !wins)
		if(rollviewer)
			to_chat(rollviewer, "<span class='danger'>Failed</span>")
			return DICE_FAILURE
	if(wins)
		switch(wins)
			if(1)
				to_chat(rollviewer, "<span class='tinynotice'>Maybe</span>")
				return DICE_WIN
			if(2)
				to_chat(rollviewer, "<span class='smallnotice'>Okay</span>")
				return DICE_WIN
			if(3)
				to_chat(rollviewer, "<span class='notice'>Good</span>")
				return DICE_WIN
			if(4)
				to_chat(rollviewer, "<span class='notice'>Lucky</span>")
				return DICE_WIN
			else
				to_chat(rollviewer, "<span class='boldnotice'>Phenomenal</span>")
				return DICE_WIN

/mob/living/proc/rollfrenzy()
	if(client)
		if(clan)
			clan.frenzy_message(src)
		var/check = dice_roll(max(1, round(humanity/2)), min(frenzy_chance_boost, frenzy_hardness), src)

		// Modifier for frenzy duration
		var/length_modifier = 1

		switch(check)
			if (DICE_CRIT_FAILURE)
				enter_frenzymod()
				addtimer(CALLBACK(src, PROC_REF(exit_frenzymod)), 20 SECONDS * length_modifier)
				frenzy_hardness = 1
			if (DICE_FAILURE)
				enter_frenzymod()
				addtimer(CALLBACK(src, PROC_REF(exit_frenzymod)), 10 SECONDS * length_modifier)
				frenzy_hardness = 1
			if (DICE_CRIT_WIN)
				frenzy_hardness = max(1, frenzy_hardness - 1)
			else
				frenzy_hardness = min(10, frenzy_hardness + 1)

/mob/living/proc/enter_frenzymod()
	if (HAS_TRAIT(src, TRAIT_IN_FRENZY))
		return
	ADD_TRAIT(src, TRAIT_IN_FRENZY, MAGIC_TRAIT)
	add_client_colour(/datum/client_colour/glass_colour/red)
	GLOB.frenzy_list += src

/mob/living/proc/exit_frenzymod()
	if (!HAS_TRAIT(src, TRAIT_IN_FRENZY))
		return

	REMOVE_TRAIT(src, TRAIT_IN_FRENZY, MAGIC_TRAIT)
	remove_client_colour(/datum/client_colour/glass_colour/red)
	GLOB.frenzy_list -= src
	clear_frenzy_cache()
	last_frenzy_check = world.time

/mob/living/proc/CheckFrenzyMove()
	if(stat >= SOFT_CRIT)
		return TRUE
	if(IsSleeping())
		return TRUE
	if(IsUnconscious())
		return TRUE
	if(IsParalyzed())
		return TRUE
	if(IsKnockdown())
		return TRUE
	if(IsStun())
		return TRUE
	if(HAS_TRAIT(src, TRAIT_RESTRAINED))
		return TRUE

/mob/living/proc/handle_fear(atom/fear)
	if(!fear)
		return FALSE
	if(!clan?.handle_fear(src, fear))
		return FALSE
	step_away(src,fear,99)
	if(prob(25))
		emote("scream")
	return TRUE


/mob/living/proc/frenzystep()
	if(!isturf(loc) || CheckFrenzyMove() || !frenzy_target || !HAS_TRAIT(src, TRAIT_IN_FRENZY))
		return
	// Continue the frenzy loop
	addtimer(CALLBACK(src, PROC_REF(frenzystep)), total_multiplicative_slowdown())

	if(!isliving(frenzy_target))
		return
	var/mob/living/L = frenzy_target

	if(m_intent == MOVE_INTENT_WALK)
		toggle_move_intent(src)
	set_glide_size(DELAY_TO_GLIDE_SIZE(total_multiplicative_slowdown()))

	if(handle_fear(clan?.return_fear(src)))
		return

	if(get_dist(frenzy_target, src) > 1)
		frenzy_pathfind_to_target()
		face_atom(frenzy_target)
		return

	. = TRUE
	a_intent = INTENT_HARM
	if(last_rage_hit+5 < world.time)
		last_rage_hit = world.time
		UnarmedAttack(L)

/mob/living/carbon/frenzystep()
	if(!..())
		return
	if(prob(10))
		emote(pick("scream", "rage", "painscream"))
	if(clan && iscarbon(frenzy_target))
		var/mob/living/carbon/C = frenzy_target
		face_atom(C)
		if(C.pulledby != src)
			start_pulling(C)
		var/obj/item/grabbing/bite/B = mouth
		if(!istype(mouth, /obj/item/grabbing/bite))
			if(body_position == STANDING_UP && !HAS_TRAIT(src, TRAIT_TINY))
				select_zone(BODY_ZONE_PRECISE_NECK)
			else
				select_zone(BODY_ZONE_CHEST)
			if(mouth || !bite(C))
				return // something's there but it's not a bite. or we tried to bite but something stopped us
			B = mouth
		else
			B.bitelimb(src)
		if(C.blood_volume <= 0 || HAS_TRAIT(C, TRAIT_HUSK) || (NOBLOOD in C.dna?.species?.species_traits))
			return
		B.drinklimb(src)


/mob/living/proc/get_frenzy_targets()
	var/list/targets = list()
	if(clan)
		for(var/mob/living/L in oviewers(7, src))
			if(L.bloodpool > 50 && L.stat != DEAD)
				targets += L
				if(L == frenzy_target)
					return L
	else
		for(var/mob/living/L in oviewers(7, src))
			if(L.stat != DEAD)
				targets += L
				if(L == frenzy_target)
					return L
	if(length(targets) > 0)
		return pick(targets)
	else
		return null


/mob/living/proc/handle_automated_frenzy()
	if(isturf(loc))
		frenzy_target = get_frenzy_targets()
		if(frenzy_target)
			frenzystep() // Start the frenzy stepping process
		else
			if(!CheckFrenzyMove())
				if(isturf(loc))
					var/turf/T = get_step(loc, pick(NORTH, SOUTH, WEST, EAST))
					face_atom(T)
					Move(T)

/mob/living/proc/frenzy_pathfind_to_target()
	if(!frenzy_target)
		return

	var/turf/current_pos = get_turf(src)
	var/turf/target_pos = get_turf(frenzy_target)

	// Only regenerate path if we've moved to a different position or don't have a cached path
	if(!frenzy_cached_path || frenzy_last_pos != current_pos)
		frenzy_cached_path = get_path_to(src, target_pos, TYPE_PROC_REF(/turf, Heuristic_cardinal_3d), 33, 250, 1)
		frenzy_last_pos = current_pos

	if(length(frenzy_cached_path))
		walk(src, 0) // Stop any existing walk
		step_to(src, frenzy_cached_path[1], 0)
		frenzy_cached_path.Cut(1, 2)
	else
		// Fallback to direct pathfinding if cached path fails
		step_to(src, frenzy_target, 0)

/mob/living/proc/clear_frenzy_cache()
	frenzy_cached_path = null
	frenzy_last_pos = null
