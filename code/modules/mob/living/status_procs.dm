//Here are the procs used to modify status effects of a mob.
//The effects include: stun, knockdown, unconscious, sleeping, resting, jitteriness, dizziness,
// eye damage, eye_blind, eye_blurry, druggy, TRAIT_BLIND trait, and TRAIT_NEARSIGHT trait.

//KNOCKDOWN
/mob/living/proc/KnockToFloor(silent = TRUE, ignore_canknockdown = FALSE, knockdown_amt = 1)
	return

//Force mob to rest, does NOT do stamina damage.
//It's really not recommended to use this proc to give feedback, hence why silent is defaulting to true.
/mob/living/carbon/KnockToFloor(knockdown_amt = 1, ignore_canknockdown = FALSE, silent = TRUE)
	if(!silent && (body_position != LYING_DOWN))
		to_chat(src, span_warning("I am knocked to the floor!"))
	Knockdown(knockdown_amt, ignore_canknockdown)

/mob/living/proc/CombatKnockdown(stamina_damage, knockdown_amount, paralyze_amount, disarm = FALSE, ignore_canknockdown = FALSE)
	if(!stamina_damage)
		return
	return Paralyze((paralyze_amount ? paralyze_amount : stamina_damage))

/mob/living/carbon/CombatKnockdown(stamina_damage, knockdown_amount, paralyze_amount, disarm = FALSE, ignore_canknockdown = FALSE)
	if(!stamina_damage && !knockdown_amount && !paralyze_amount)
		return
	if(!ignore_canknockdown && !(status_flags & CANKNOCKDOWN))
		return FALSE
	if(isnull(knockdown_amount))
		knockdown_amount = stamina_damage
	KnockToFloor(max(1, knockdown_amount), ignore_canknockdown)
	adjust_stamina(stamina_damage)
	if(disarm)
		drop_all_held_items()
	if(paralyze_amount)
		Paralyze(paralyze_amount)

///Set the slowdown of a mob
/mob/living/Slowdown(amount)
	var/oldslow = slowdown
	if(amount > 0)
		if(!(status_flags & CANSLOWDOWN) || HAS_TRAIT(src, TRAIT_IGNORESLOWDOWN))
			amount = 0
	slowdown = max(slowdown,amount,0)
	if(oldslow <= 0 && slowdown > 0)
		add_movespeed_modifier(MOVESPEED_ID_LIVING_SLOWDOWN_STATUS, update=TRUE, priority=100, multiplicative_slowdown=2, movetypes=GROUND)
	if(slowdown <= 0)
		remove_movespeed_modifier(MOVESPEED_ID_LIVING_SLOWDOWN_STATUS)


////////////////////////////// STUN ////////////////////////////////////

/mob/living/proc/IsStun() //If we're stunned
	return has_status_effect(STATUS_EFFECT_STUN)

/mob/living/proc/AmountStun() //How many deciseconds remain in our stun
	var/datum/status_effect/incapacitating/stun/S = IsStun()
	if(S)
		return S.duration
	return 0

/mob/living/proc/Stun(amount, ignore_canstun = FALSE) //Can't go below remaining duration
	if(SEND_SIGNAL(src, COMSIG_LIVING_STATUS_STUN, amount, ignore_canstun) & COMPONENT_NO_STUN)
		return
	if(((status_flags & CANSTUN) && !HAS_TRAIT(src, TRAIT_STUNIMMUNE)) || ignore_canstun)
		if(absorb_stun(amount, ignore_canstun))
			return
		var/datum/status_effect/incapacitating/stun/S = IsStun()
		if(S)
			S.duration = max(amount, S.duration)
		else if(amount > 0)
			S = apply_status_effect(STATUS_EFFECT_STUN, amount)
		return S

/mob/living/proc/SetStun(amount, ignore_canstun = FALSE) //Sets remaining duration
	if(SEND_SIGNAL(src, COMSIG_LIVING_STATUS_STUN, amount, ignore_canstun) & COMPONENT_NO_STUN)
		return
	if(((status_flags & CANSTUN) && !HAS_TRAIT(src, TRAIT_STUNIMMUNE)) || ignore_canstun)
		var/datum/status_effect/incapacitating/stun/S = IsStun()
		if(amount <= 0)
			if(S)
				qdel(S)
		else
			if(absorb_stun(amount, ignore_canstun))
				return
			if(S)
				S.duration = amount
			else
				S = apply_status_effect(STATUS_EFFECT_STUN, amount)
		return S

/mob/living/proc/AdjustStun(amount, ignore_canstun = FALSE) //Adds to remaining duration
	if(SEND_SIGNAL(src, COMSIG_LIVING_STATUS_STUN, amount, ignore_canstun) & COMPONENT_NO_STUN)
		return
	if(((status_flags & CANSTUN) && !HAS_TRAIT(src, TRAIT_STUNIMMUNE)) || ignore_canstun)
		if(absorb_stun(amount, ignore_canstun))
			return
		var/datum/status_effect/incapacitating/stun/S = IsStun()
		if(S)
			S.duration += amount
		else if(amount > 0)
			S = apply_status_effect(STATUS_EFFECT_STUN, amount)
		return S

///////////////////////////////// KNOCKDOWN /////////////////////////////////////

/mob/living/proc/IsKnockdown() //If we're knocked down
	return has_status_effect(STATUS_EFFECT_KNOCKDOWN)

/mob/living/proc/AmountKnockdown() //How many deciseconds remain in our knockdown
	var/datum/status_effect/incapacitating/knockdown/K = IsKnockdown()
	if(K)
		return K.duration
	return 0

/mob/living/proc/Knockdown(amount, ignore_canstun = FALSE) //Can't go below remaining duration
	if(SEND_SIGNAL(src, COMSIG_LIVING_STATUS_KNOCKDOWN, amount, ignore_canstun) & COMPONENT_NO_STUN)
		return
	if(((status_flags & CANKNOCKDOWN) && !HAS_TRAIT(src, TRAIT_STUNIMMUNE)) || ignore_canstun)
		if(absorb_stun(amount, ignore_canstun))
			return
		var/datum/status_effect/incapacitating/knockdown/K = IsKnockdown()
		if(K)
			K.duration = max(amount, K.duration)
		else if(amount > 0)
			K = apply_status_effect(STATUS_EFFECT_KNOCKDOWN, amount)
		return K

/mob/living/proc/SetKnockdown(amount, ignore_canstun = FALSE) //Sets remaining duration
	if(SEND_SIGNAL(src, COMSIG_LIVING_STATUS_KNOCKDOWN, amount, ignore_canstun) & COMPONENT_NO_STUN)
		return
	if(((status_flags & CANKNOCKDOWN) && !HAS_TRAIT(src, TRAIT_STUNIMMUNE)) || ignore_canstun)
		var/datum/status_effect/incapacitating/knockdown/K = IsKnockdown()
		if(amount <= 0)
			if(K)
				qdel(K)
		else
			if(absorb_stun(amount, ignore_canstun))
				return
			if(K)
				K.duration = amount
			else
				K = apply_status_effect(STATUS_EFFECT_KNOCKDOWN, amount)
		return K

/mob/living/proc/AdjustKnockdown(amount, ignore_canstun = FALSE) //Adds to remaining duration
	if(SEND_SIGNAL(src, COMSIG_LIVING_STATUS_KNOCKDOWN, amount, ignore_canstun) & COMPONENT_NO_STUN)
		return
	if(((status_flags & CANKNOCKDOWN) && !HAS_TRAIT(src, TRAIT_STUNIMMUNE)) || ignore_canstun)
		if(absorb_stun(amount, ignore_canstun))
			return
		var/datum/status_effect/incapacitating/knockdown/K = IsKnockdown()
		if(K)
			K.duration += amount
		else if(amount > 0)
			K = apply_status_effect(STATUS_EFFECT_KNOCKDOWN, amount)
		return K

///////////////////////////////// IMMOBILIZED ////////////////////////////////////
/mob/living/proc/IsImmobilized() //If we're immobilized
	return has_status_effect(STATUS_EFFECT_IMMOBILIZED)

/mob/living/proc/AmountImmobilized() //How many deciseconds remain in our Immobilized status effect
	var/datum/status_effect/incapacitating/immobilized/I = IsImmobilized()
	if(I)
		return I.duration
	return 0

/mob/living/proc/Immobilize(amount, ignore_canstun = FALSE) //Can't go below remaining duration
	if(SEND_SIGNAL(src, COMSIG_LIVING_STATUS_IMMOBILIZE, amount, ignore_canstun) & COMPONENT_NO_STUN)
		return
	if(((status_flags & CANSTUN) && !HAS_TRAIT(src, TRAIT_STUNIMMUNE)) || ignore_canstun)
		if(absorb_stun(amount, ignore_canstun))
			return
		var/datum/status_effect/incapacitating/immobilized/I = IsImmobilized()
		if(I)
			I.duration = max(amount, I.duration)
		else if(amount > 0)
			I = apply_status_effect(STATUS_EFFECT_IMMOBILIZED, amount)
		return I

/mob/living/proc/SetImmobilized(amount, ignore_canstun = FALSE) //Sets remaining duration
	if(SEND_SIGNAL(src, COMSIG_LIVING_STATUS_IMMOBILIZE, amount, ignore_canstun) & COMPONENT_NO_STUN)
		return
	if(((status_flags & CANSTUN) && !HAS_TRAIT(src, TRAIT_STUNIMMUNE)) || ignore_canstun)
		var/datum/status_effect/incapacitating/immobilized/I = IsImmobilized()
		if(amount <= 0)
			if(I)
				qdel(I)
		else
			if(absorb_stun(amount, ignore_canstun))
				return
			if(I)
				I.duration = amount
			else
				I = apply_status_effect(STATUS_EFFECT_IMMOBILIZED, amount)
		return I

/mob/living/proc/AdjustImmobilized(amount, ignore_canstun = FALSE) //Adds to remaining duration
	if(SEND_SIGNAL(src, COMSIG_LIVING_STATUS_IMMOBILIZE, amount, ignore_canstun) & COMPONENT_NO_STUN)
		return
	if(((status_flags & CANSTUN) && !HAS_TRAIT(src, TRAIT_STUNIMMUNE)) || ignore_canstun)
		if(absorb_stun(amount, ignore_canstun))
			return
		var/datum/status_effect/incapacitating/immobilized/I = IsImmobilized()
		if(I)
			I.duration += amount
		else if(amount > 0)
			I = apply_status_effect(STATUS_EFFECT_IMMOBILIZED, amount)
		return I

///////////////////////////////// PARALYZED //////////////////////////////////
/mob/living/proc/IsParalyzed() //If we're immobilized
	return has_status_effect(STATUS_EFFECT_PARALYZED)

/mob/living/proc/AmountParalyzed() //How many deciseconds remain in our Paralyzed status effect
	var/datum/status_effect/incapacitating/paralyzed/P = IsParalyzed(FALSE)
	if(P)
		return P.duration
	return 0

/mob/living/proc/Paralyze(amount, ignore_canstun = FALSE) //Can't go below remaining duration
	if(SEND_SIGNAL(src, COMSIG_LIVING_STATUS_PARALYZE, amount, ignore_canstun) & COMPONENT_NO_STUN)
		return
	if(((status_flags & CANKNOCKDOWN) && !HAS_TRAIT(src, TRAIT_STUNIMMUNE)) || ignore_canstun)
		if(absorb_stun(amount, ignore_canstun))
			return
		var/datum/status_effect/incapacitating/paralyzed/P = IsParalyzed(FALSE)
		if(P)
			P.duration = max(amount, P.duration)
		else if(amount > 0)
			P = apply_status_effect(STATUS_EFFECT_PARALYZED, amount)
		return P

/mob/living/proc/SetParalyzed(amount, ignore_canstun = FALSE) //Sets remaining duration
	if(SEND_SIGNAL(src, COMSIG_LIVING_STATUS_PARALYZE, amount, ignore_canstun) & COMPONENT_NO_STUN)
		return
	if(((status_flags & CANKNOCKDOWN) && !HAS_TRAIT(src, TRAIT_STUNIMMUNE)) || ignore_canstun)
		var/datum/status_effect/incapacitating/paralyzed/P = IsParalyzed(FALSE)
		if(amount <= 0)
			if(P)
				qdel(P)
		else
			if(absorb_stun(amount, ignore_canstun))
				return
			if(P)
				P.duration = amount
			else
				P = apply_status_effect(STATUS_EFFECT_PARALYZED, amount)
		return P

/mob/living/proc/AdjustParalyzed(amount, ignore_canstun = FALSE) //Adds to remaining duration
	if(SEND_SIGNAL(src, COMSIG_LIVING_STATUS_PARALYZE, amount, ignore_canstun) & COMPONENT_NO_STUN)
		return
	if(((status_flags & CANKNOCKDOWN) && !HAS_TRAIT(src, TRAIT_STUNIMMUNE)) || ignore_canstun)
		if(absorb_stun(amount, ignore_canstun))
			return
		var/datum/status_effect/incapacitating/paralyzed/P = IsParalyzed(FALSE)
		if(P)
			P.duration += amount
		else if(amount > 0)
			P = apply_status_effect(STATUS_EFFECT_PARALYZED, amount)
		return P


///////////////////////////////// OFF-BALANCED //////////////////////////////////
/mob/living/proc/IsOffBalanced() //If we're off balance
	return has_status_effect(STATUS_EFFECT_OFFBALANCED)

/mob/living/proc/AmountOffBalanced() //How many deciseconds remain in our knockdown
	var/datum/status_effect/incapacitating/off_balanced/O = IsOffBalanced()
	if(O)
		return O.duration
	return 0

/mob/living/proc/OffBalance(amount) //Can't go below remaining duration
	if(SEND_SIGNAL(src, COMSIG_LIVING_STATUS_OFFBALANCED, amount))
		return
	var/datum/status_effect/incapacitating/off_balanced/O = IsOffBalanced()
	if(O)
		O.duration = max(amount, O.duration)
	else if(amount > 0)
		O = apply_status_effect(STATUS_EFFECT_OFFBALANCED, amount)
	return O



///////////////Blanket
/mob/living/proc/AllImmobility(amount)
	Paralyze(amount)
	Knockdown(amount)
	Stun(amount)
	Immobilize(amount)

/mob/living/proc/SetAllImmobility(amount)
	SetParalyzed(amount)
	SetKnockdown(amount)
	SetStun(amount)
	SetImmobilized(amount)

/mob/living/proc/AdjustAllImmobility(amount)
	AdjustParalyzed(amount)
	AdjustKnockdown(amount)
	AdjustStun(amount)
	AdjustImmobilized(amount)

//////////////////UNCONSCIOUS
/mob/living/proc/IsUnconscious() //If we're unconscious
	return has_status_effect(STATUS_EFFECT_UNCONSCIOUS)

/mob/living/proc/AmountUnconscious() //How many deciseconds remain in our unconsciousness
	var/datum/status_effect/incapacitating/unconscious/U = IsUnconscious()
	if(U)
		return U.duration
	return 0

/mob/living/proc/Unconscious(amount, ignore_canstun = FALSE) //Can't go below remaining duration
	if(SEND_SIGNAL(src, COMSIG_LIVING_STATUS_UNCONSCIOUS, amount, ignore_canstun) & COMPONENT_NO_STUN)
		return
	if(((status_flags & CANUNCONSCIOUS) && !HAS_TRAIT(src, TRAIT_STUNIMMUNE))  || ignore_canstun)
		var/datum/status_effect/incapacitating/unconscious/U = IsUnconscious()
		if(U)
			U.duration = max(amount, U.duration)
		else if(amount > 0)
			U = apply_status_effect(STATUS_EFFECT_UNCONSCIOUS, amount)
		return U

/mob/living/proc/SetUnconscious(amount, ignore_canstun = FALSE) //Sets remaining duration
	if(SEND_SIGNAL(src, COMSIG_LIVING_STATUS_UNCONSCIOUS, amount, ignore_canstun) & COMPONENT_NO_STUN)
		return
	if(((status_flags & CANUNCONSCIOUS) && !HAS_TRAIT(src, TRAIT_STUNIMMUNE)) || ignore_canstun)
		var/datum/status_effect/incapacitating/unconscious/U = IsUnconscious()
		if(amount <= 0)
			if(U)
				qdel(U)
		else if(U)
			U.duration = amount
		else
			U = apply_status_effect(STATUS_EFFECT_UNCONSCIOUS, amount)
		return U

/mob/living/proc/AdjustUnconscious(amount, ignore_canstun = FALSE) //Adds to remaining duration
	if(SEND_SIGNAL(src, COMSIG_LIVING_STATUS_UNCONSCIOUS, amount, ignore_canstun) & COMPONENT_NO_STUN)
		return
	if(((status_flags & CANUNCONSCIOUS) && !HAS_TRAIT(src, TRAIT_STUNIMMUNE)) || ignore_canstun)
		var/datum/status_effect/incapacitating/unconscious/U = IsUnconscious()
		if(U)
			U.duration += amount
		else if(amount > 0)
			U = apply_status_effect(STATUS_EFFECT_UNCONSCIOUS, amount)
		return U

/////////////////////////////////// SLEEPING ////////////////////////////////////

/mob/proc/IsSleeping()
	return FALSE

/mob/living/IsSleeping() //If we're asleep
	return has_status_effect(STATUS_EFFECT_SLEEPING)

/mob/living/proc/AmountSleeping() //How many deciseconds remain in our sleep
	var/datum/status_effect/incapacitating/sleeping/S = IsSleeping()
	if(S)
		return S.duration
	return 0

/mob/living/proc/Sleeping(amount, ignore_canstun = FALSE) //Can't go below remaining duration
	if(SEND_SIGNAL(src, COMSIG_LIVING_STATUS_SLEEP, amount, ignore_canstun) & COMPONENT_NO_STUN)
		return
	if((!HAS_TRAIT(src, TRAIT_SLEEPIMMUNE)) || ignore_canstun)
		var/datum/status_effect/incapacitating/sleeping/S = IsSleeping()
		if(S)
			S.duration = max(amount, S.duration)
		else if(amount > 0)
			S = apply_status_effect(STATUS_EFFECT_SLEEPING, amount)
		return S

/mob/living/proc/SetSleeping(amount, ignore_canstun = FALSE) //Sets remaining duration
	if(SEND_SIGNAL(src, COMSIG_LIVING_STATUS_SLEEP, amount, ignore_canstun) & COMPONENT_NO_STUN)
		return
	if((!HAS_TRAIT(src, TRAIT_SLEEPIMMUNE)) || ignore_canstun)
		var/datum/status_effect/incapacitating/sleeping/S = IsSleeping()
		if(amount <= 0)
			if(S)
				qdel(S)
		else if(S)
			S.duration = amount
		else
			S = apply_status_effect(STATUS_EFFECT_SLEEPING, amount)
		return S

/mob/living/proc/AdjustSleeping(amount, ignore_canstun = FALSE) //Adds to remaining duration
	if(SEND_SIGNAL(src, COMSIG_LIVING_STATUS_SLEEP, amount, ignore_canstun) & COMPONENT_NO_STUN)
		return
	if((!HAS_TRAIT(src, TRAIT_SLEEPIMMUNE)) || ignore_canstun)
		var/datum/status_effect/incapacitating/sleeping/S = IsSleeping()
		if(S)
			S.duration += amount
		else if(amount > 0)
			S = apply_status_effect(STATUS_EFFECT_SLEEPING, amount)
		return S

/mob/living/proc/IsConcussion()
	return has_status_effect(STATUS_EFFECT_CONCUSSION)

/mob/living/proc/AmountConcussion()
	var/datum/status_effect/incapacitating/concussion/I = IsConcussion()
	if(I)
		return I.duration
	return 0

/mob/living/proc/Concussion(amount, updating = TRUE, ignore_canstun = FALSE) //Can't go below remaining duration
	if(SEND_SIGNAL(src, COMSIG_LIVING_STATUS_CONCUSSION, amount, updating, ignore_canstun) & COMPONENT_NO_STUN)
		return
	if(!ignore_canstun && (!(status_flags & CANSTUN) || HAS_TRAIT(src, TRAIT_STUNIMMUNE)))
		return
	if(absorb_stun(amount, ignore_canstun))
		return
	var/datum/status_effect/incapacitating/concussion/I = IsConcussion()
	if(I)
		I.duration = max(CEILING(amount, 4 SECONDS), I.duration)
	else if(amount > 0)
		I = apply_status_effect(STATUS_EFFECT_CONCUSSION, CEILING(amount, 4), updating)
	return I

/mob/living/proc/SetConcussion(amount, updating = TRUE, ignore_canstun = FALSE) //Sets remaining duration
	if(SEND_SIGNAL(src, COMSIG_LIVING_STATUS_CONCUSSION, amount, updating, ignore_canstun) & COMPONENT_NO_STUN)
		return
	if(!ignore_canstun && (!(status_flags & CANSTUN) || HAS_TRAIT(src, TRAIT_STUNIMMUNE)))
		return
	var/datum/status_effect/incapacitating/concussion/I = IsConcussion()
	if(amount <= 0)
		if(I)
			qdel(I)
	else
		if(absorb_stun(amount, ignore_canstun))
			return
		if(I)
			I.duration = amount
		else
			I = apply_status_effect(STATUS_EFFECT_CONCUSSION, CEILING(amount, 4 SECONDS), updating)
	return I

/mob/living/proc/AdjustConcussion(amount, updating = TRUE, ignore_canstun = FALSE) //Adds to remaining duration
	if(SEND_SIGNAL(src, COMSIG_LIVING_STATUS_CONCUSSION, amount, updating, ignore_canstun) & COMPONENT_NO_STUN)
		return
	if(!ignore_canstun && (!(status_flags & CANSTUN) || HAS_TRAIT(src, TRAIT_STUNIMMUNE)))
		return
	if(absorb_stun(amount, ignore_canstun))
		return
	var/datum/status_effect/incapacitating/concussion/I = IsConcussion()
	if(I)
		I.duration += amount
	else if(amount > 0)
		I = apply_status_effect(STATUS_EFFECT_CONCUSSION, CEILING(amount, 4 SECONDS), updating)
	return I

//STUMBLE
/mob/living/proc/IsStumble() //If we're stumbling
	return has_status_effect(STATUS_EFFECT_STUMBLE)

/mob/living/proc/AmountStumble() //How many deciseconds remain in our Dazed status effect
	var/datum/status_effect/incapacitating/stumble/I = IsStumble()
	if(I)
		return I.duration
	return 0

/mob/living/proc/Stumble(amount, updating = TRUE, ignore_canstun = FALSE) //Can't go below remaining duration
	if(SEND_SIGNAL(src, COMSIG_LIVING_STATUS_STUMBLE, amount, updating, ignore_canstun) & COMPONENT_NO_STUN)
		return
	if(!ignore_canstun && (!(status_flags & CANKNOCKDOWN) || HAS_TRAIT(src, TRAIT_STUNIMMUNE)))
		return
	if(absorb_stun(amount, ignore_canstun))
		return
	var/datum/status_effect/incapacitating/stumble/I = IsStumble()
	if(I)
		I.duration = max(amount, I.duration)
	else if(amount > 0)
		I = apply_status_effect(STATUS_EFFECT_STUMBLE, amount, updating)
	return I

/mob/living/proc/SetStumble(amount, updating = TRUE, ignore_canstun = FALSE) //Sets remaining duration
	if(SEND_SIGNAL(src, COMSIG_LIVING_STATUS_STUMBLE, amount, updating, ignore_canstun) & COMPONENT_NO_STUN)
		return
	if(!ignore_canstun && (!(status_flags & CANKNOCKDOWN) || HAS_TRAIT(src, TRAIT_STUNIMMUNE)))
		return
	var/datum/status_effect/incapacitating/stumble/I = IsStumble()
	if(amount <= 0)
		if(I)
			qdel(I)
	else
		if(absorb_stun(amount, ignore_canstun))
			return
		if(I)
			I.duration = amount
		else
			I = apply_status_effect(STATUS_EFFECT_STUMBLE, amount, updating)
	return I

/mob/living/proc/AdjustStumble(amount, updating = TRUE, ignore_canstun = FALSE) //Adds to remaining duration
	if(SEND_SIGNAL(src, COMSIG_LIVING_STATUS_STUMBLE, amount, updating, ignore_canstun) & COMPONENT_NO_STUN)
		return
	if(!ignore_canstun && (!(status_flags & CANKNOCKDOWN) || HAS_TRAIT(src, TRAIT_STUNIMMUNE)))
		return
	if(absorb_stun(amount, ignore_canstun))
		return
	var/datum/status_effect/incapacitating/stumble/I = IsStumble()
	if(I)
		I.duration += amount
	else if(amount > 0)
		I = apply_status_effect(STATUS_EFFECT_STUMBLE, amount, updating)
	return I

///////////////////////////////// FROZEN /////////////////////////////////////

/mob/living/proc/IsFrozen()
	return has_status_effect(/datum/status_effect/freon)

///////////////////////////////////// STUN ABSORPTION /////////////////////////////////////

/mob/living/proc/add_stun_absorption(key, duration, priority, message, self_message, examine_message)
//adds a stun absorption with a key, a duration in deciseconds, its priority, and the messages it makes when you're stun/examined, if any
	if(!islist(stun_absorption))
		stun_absorption = list()
	if(stun_absorption[key])
		stun_absorption[key]["end_time"] = duration
		stun_absorption[key]["priority"] = priority
		stun_absorption[key]["stuns_absorbed"] = 0
	else
		stun_absorption[key] = list("end_time" = duration, "priority" = priority, "stuns_absorbed" = 0, \
		"visible_message" = message, "self_message" = self_message, "examine_message" = examine_message)

/mob/living/proc/absorb_stun(amount, ignoring_flag_presence)
	if(amount < 0 || stat || ignoring_flag_presence || !islist(stun_absorption))
		return FALSE
	if(!amount)
		amount = 0
	var/priority_absorb_key
	var/highest_priority
	for(var/i in stun_absorption)
		if(stun_absorption[i]["end_time"] > world.time && (!priority_absorb_key || stun_absorption[i]["priority"] > highest_priority))
			priority_absorb_key = stun_absorption[i]
			highest_priority = priority_absorb_key["priority"]
	if(priority_absorb_key)
		if(amount) //don't spam up the chat for continuous stuns
			if(priority_absorb_key["visible_message"] || priority_absorb_key["self_message"])
				if(priority_absorb_key["visible_message"] && priority_absorb_key["self_message"])
					visible_message("<span class='warning'>[src][priority_absorb_key["visible_message"]]</span>", "<span class='boldwarning'>[priority_absorb_key["self_message"]]</span>")
				else if(priority_absorb_key["visible_message"])
					visible_message("<span class='warning'>[src][priority_absorb_key["visible_message"]]</span>")
				else if(priority_absorb_key["self_message"])
					to_chat(src, "<span class='boldwarning'>[priority_absorb_key["self_message"]]</span>")
			priority_absorb_key["stuns_absorbed"] += amount
		return TRUE

/////////////////////////////////// TRAIT PROCS ////////////////////////////////////

/mob/living/proc/cure_husk(source)
	REMOVE_TRAIT(src, TRAIT_HUSK, source)
	if(!HAS_TRAIT(src, TRAIT_HUSK))
		REMOVE_TRAIT(src, TRAIT_DISFIGURED, "husk")
		update_body()
		return TRUE

/mob/living/proc/become_husk(source)
	if(!HAS_TRAIT(src, TRAIT_HUSK))
		ADD_TRAIT(src, TRAIT_HUSK, source)
		ADD_TRAIT(src, TRAIT_DISFIGURED, "husk")
		update_body()
	else
		ADD_TRAIT(src, TRAIT_HUSK, source)

/mob/living/proc/cure_fakedeath(source)
	REMOVE_TRAIT(src, TRAIT_FAKEDEATH, source)
	REMOVE_TRAIT(src, TRAIT_DEATHCOMA, source)
	if(stat != DEAD)
		tod = null

/mob/living/proc/fakedeath(source, silent = FALSE)
	if(stat == DEAD)
		return
	if(!silent)
		emote("deathgasp")
	ADD_TRAIT(src, TRAIT_FAKEDEATH, source)
	ADD_TRAIT(src, TRAIT_DEATHCOMA, source)
	tod = station_time_timestamp()

/mob/living/proc/unignore_slowdown(source)
	REMOVE_TRAIT(src, TRAIT_IGNORESLOWDOWN, source)
	update_movespeed(FALSE)

/mob/living/proc/ignore_slowdown(source)
	ADD_TRAIT(src, TRAIT_IGNORESLOWDOWN, source)
	update_movespeed(FALSE)

/**
 * Adjusts a timed status effect on the mob,taking into account any existing timed status effects.
 * This can be any status effect that takes into account "duration" with their initialize arguments.
 *
 * Positive durations will add deciseconds to the duration of existing status effects
 * or apply a new status effect of that duration to the mob.
 *
 * Negative durations will remove deciseconds from the duration of an existing version of the status effect,
 * removing the status effect entirely if the duration becomes less than zero (less than the current world time).
 *
 * duration - the duration, in deciseconds, to add or remove from the effect
 * effect - the type of status effect being adjusted on the mob
 * max_duration - optional - if set, positive durations will only be added UP TO the passed max duration
 */
/mob/living/proc/adjust_timed_status_effect(duration, effect, max_duration)
	if(!isnum(duration))
		CRASH("adjust_timed_status_effect: called with an invalid duration. (Got: [duration])")

	if(!ispath(effect, /datum/status_effect))
		CRASH("adjust_timed_status_effect: called with an invalid effect type. (Got: [effect])")

	// If we have a max duration set, we need to check our duration does not exceed it
	if(isnum(max_duration))
		if(max_duration <= 0)
			CRASH("adjust_timed_status_effect: Called with an invalid max_duration. (Got: [max_duration])")

		if(duration >= max_duration)
			duration = max_duration

	var/datum/status_effect/existing = has_status_effect(effect)
	if(existing)
		if(isnum(max_duration) && duration > 0)
			// Check the duration remaining on the existing status effect
			// If it's greater than / equal to our passed max duration, we don't need to do anything
			var/remaining_duration = existing.duration
			if(remaining_duration >= max_duration)
				return

			// Otherwise, add duration up to the max (max_duration - remaining_duration),
			// or just add duration if it doesn't exceed our max at all
			existing.duration += min(max_duration - remaining_duration, duration)

		else
			existing.duration += duration

		// If the duration was decreased and is now less 0 seconds,
		// qdel it / clean up the status effect immediately
		// (rather than waiting for the process tick to handle it)
		if(existing.duration <= world.time)
			qdel(existing)

	else if(duration > 0)
		apply_status_effect(effect, duration)

/**
 * Sets a timed status effect of some kind on a mob to a specific value.
 * If only_if_higher is TRUE, it will only set the value up to the passed duration,
 * so any pre-existing status effects of the same type won't be reduced down
 *
 * duration - the duration, in deciseconds, of the effect. 0 or lower will either remove the current effect or do nothing if none are present
 * effect - the type of status effect given to the mob
 * only_if_higher - if TRUE, we will only set the effect to the new duration if the new duration is longer than any existing duration
 */
/mob/living/proc/set_timed_status_effect(duration, effect, only_if_higher = FALSE)
	if(!isnum(duration))
		CRASH("set_timed_status_effect: called with an invalid duration. (Got: [duration])")

	if(!ispath(effect, /datum/status_effect))
		CRASH("set_timed_status_effect: called with an invalid effect type. (Got: [effect])")

	var/datum/status_effect/existing = has_status_effect(effect)
	if(existing)
		// set_timed_status_effect to 0 technically acts as a way to clear effects,
		// though remove_status_effect would achieve the same goal more explicitly.
		if(duration <= 0)
			qdel(existing)
			return

		if(only_if_higher)
			// If the existing status effect has a higher remaining duration
			// than what we aim to set it to, don't downgrade it - do nothing (return)
			var/remaining_duration = existing.duration
			if(remaining_duration >= duration)
				return

		// Set the duration accordingly
		existing.duration = duration

	else if(duration > 0)
		apply_status_effect(effect, duration)

/**
 * Gets how many deciseconds are remaining in
 * the duration of the passed status effect on this mob.
 *
 * If the mob is unaffected by the passed effect, returns 0.
 */
/mob/living/proc/get_timed_status_effect_duration(effect)
	if(!ispath(effect, /datum/status_effect))
		CRASH("get_timed_status_effect_duration: called with an invalid effect type. (Got: [effect])")

	var/datum/status_effect/existing = has_status_effect(effect)
	if(!existing)
		return 0
	// Infinite duration status effects technically are not "timed status effects"
	// by name or nature, but support is included just in case.
	if(existing.duration == -1)
		return INFINITY

	return existing.duration
