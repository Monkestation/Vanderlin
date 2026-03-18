
/mob/living/proc/get_dodging_score(modifier = 0)
	var/basic_speed = GET_MOB_ATTRIBUTE_VALUE(src, STAT_SPEED)
	var/encumberance = get_encumbrance()
	if(!HAS_TRAIT(src, TRAIT_DODGEEXPERT))
		encumbrance *= 1.5
	var/encumbrance_penalty = 0
	if(encumberance >= 1.0)
		encumbrance_penalty = 4
	else if(encumberance >= 0.75)
		encumbrance_penalty = 3
	else if(encumberance >= 0.5)
		encumbrance_penalty = 2
	else if(encumberance >= 0.25)
		encumbrance_penalty = 1

	var/stun_penalty = 0
	if(incapacitated())
		stun_penalty = 4
	if(cmode && (d_intent == INTENT_DODGE))
		modifier += 2
	return floor(max(0, 1 + basic_speed + modifier - encumbrance_penalty - stun_penalty - dodging_penalty))

/mob/living/proc/update_dodging_penalty(incoming = 0, duration = DODGING_PENALTY_COOLDOWN_DURATION)
	//use remove_dodging_penalty() you idiot
	if(HAS_TRAIT(src, TRAIT_DODGEEXPERT))
		duration *= 0.5

	if(!incoming || !duration)
		return
	if(dodging_penalty_timer)
		deltimer(dodging_penalty_timer)
		dodging_penalty_timer = null
	//add incoming modification
	dodging_penalty += incoming
	dodging_penalty_timer = addtimer(CALLBACK(src, PROC_REF(remove_dodging_penalty)), duration, TIMER_STOPPABLE)

/mob/living/proc/remove_dodging_penalty()
	dodging_penalty = 0
	if(dodging_penalty_timer)
		deltimer(dodging_penalty_timer)
	dodging_penalty_timer = null

/**
 * Attempt to dodge an attack
 * @param datum/intent/intenty The intent used for the attack
 * @param mob/living/user The attacker
 * @return TRUE if dodge successful, FALSE otherwise
 */
/mob/living/proc/attempt_dodge(datum/intent/intenty, mob/living/user, can_dodge_see = TRUE)
	if(!candodge)
		return FALSE
	if(intenty && !intenty.candodge)
		return FALSE
	if(loc == user.loc)
		return FALSE
	if(incapacitated())
		return FALSE

	if(pulling)
		return FALSE

	if(has_status_effect(/datum/status_effect/debuff/exposed))
		return FALSE
	if(has_status_effect(/datum/status_effect/debuff/vulnerable))
		return FALSE
	if(world.time < last_dodge + dodgetime && !istype(rmb_intent, /datum/rmb_intent/riposte))
		return FALSE

	var/list/dirry = calculate_dodge_directions(user)
	var/turf/turfy = find_dodge_turf(dirry)

	//do_dodge applies the blind modifier internally
	if(!do_dodge(user, turfy, can_dodge_see))
		return FALSE

	flash_fullscreen("blackflash2")
	user.aftermiss()
	var/attacking_item = user.get_active_held_item()
	if(!(!src.mind || !user.mind))
		log_defense(src, user, "dodged", attacking_atom = attacking_item,
					addition = "(INTENT:[uppertext(user.used_intent.name)])")
	if(client)
		record_round_statistic(STATS_DODGES)
	return TRUE

/**
 * Handles dodge attempts by the mob
 * @param mob/living/user The attacker
 * @param turf/target_turf The turf to dodge to
 * @return TRUE if dodge successful, FALSE otherwise
 */
/mob/living/proc/do_dodge(mob/living/user, turf/target_turf, can_dodge_see)
	if(dodgecd || stamina >= maximum_stamina || body_position == LYING_DOWN)
		return FALSE

	if(!is_valid_dodge_turf(target_turf))
		to_chat(src, span_boldwarning("There's nowhere to dodge to!"))
		return FALSE

	var/drained = 7
	var/dodge_speed = floor(GET_MOB_ATTRIBUTE_VALUE(src, STAT_SPEED) / 2)

	// fast attackers raise the threshold (mirror of parry system)
	// STAT_SPEED on 0-~30 range; divide by 5 for ~0-6 opposition impact
	var/attacker_opposition = floor(GET_MOB_ATTRIBUTE_VALUE(user, STAT_SPEED) / 5)

	if(istype(src, /mob/living/carbon/human))
		var/mob/living/carbon/human/H = src
		switch(H.worn_armor_class)
			if(AC_LIGHT)
				dodge_speed -= 10
				drained += 3
			if(AC_MEDIUM)
				dodge_speed = floor(dodge_speed * 0.5)
				drained += 7
				attacker_opposition += 4  // armor makes you easier to hit
			if(AC_HEAVY)
				dodge_speed = floor(dodge_speed * 0.25)
				drained += 12
				attacker_opposition += 8  // heavy armor tanks dodge chance

		var/time_since_last = world.time - last_dodge
		if(time_since_last < 2 SECONDS)
			drained += 5

		if((H.get_encumbrance() > 0.7) || H.legcuffed)
			H.Knockdown(1)
			return FALSE

		drained = max(drained, 5)

		if(stamina + drained >= maximum_stamina)
			to_chat(src, span_warning("I'm too tired to dodge!"))
			return FALSE
		if(!H.adjust_stamina(drained))
			to_chat(src, span_warning("I'm too tired to dodge!"))
			return FALSE

	var/dodge_modifier = calculate_dodge_score(user)

	if(!can_dodge_see)
		dodge_modifier -= 3

	var/dodge_score = get_dodging_score(dodge_modifier - attacker_opposition)

	var/attacker_dualwielding = user.dual_wielding_check()
	var/defender_dualwielding = dual_wielding_check()

	//mirror parry system here cause lazy
	var/effective_score = dodge_score
	if(attacker_dualwielding && !defender_dualwielding)
		effective_score = max(0, dodge_score - 2)

	if(client?.prefs.showrolls)
		var/text = "Roll to dodge... (score: [effective_score])"
		if(attacker_dualwielding)
			if(defender_dualwielding)
				text += " Dual wield cancels out."
			else
				text += " Disadvantage! (score: [effective_score])"
		to_chat(src, span_info("[text]"))

	if(user.client?.prefs.showrolls && attacker_dualwielding)
		var/attacker_feedback = "Attacking with advantage."
		if(defender_dualwielding)
			attacker_feedback += " Cancelled out!"
		to_chat(user, span_info("[attacker_feedback]"))

	var/roll_result = diceroll(effective_score, context = DICE_CONTEXT_PHYSICAL)

	if(roll_result == DICE_FAILURE || roll_result == DICE_CRIT_FAILURE)
		if(roll_result == DICE_CRIT_FAILURE)
			to_chat(src, span_warning("I completely fumbled my dodge!"))
		return FALSE

	update_dodging_penalty(DODGING_PENALTY, DODGING_PENALTY_COOLDOWN_DURATION)
	try_dodge_to(user, target_turf, dodge_speed)

	if(roll_result == DICE_CRIT_SUCCESS)
		to_chat(src, span_notice("A perfectly timed dodge!"))

	last_dodge = world.time
	return TRUE

/**
 * Check if a turf is valid for dodging into
 * @param turf/target_turf The turf to check
 * @return TRUE if valid, FALSE otherwise
 */
/mob/living/proc/is_valid_dodge_turf(turf/target_turf)
	if(!target_turf || target_turf.density)
		return FALSE

	if(isopenspace(target_turf))
		return FALSE

	for(var/atom/movable/AM in target_turf)
		if(!AM.CanPass(src, target_turf))
			return FALSE

	return TRUE

/**
 * Calculate the dodge score based on attacker and defender stats
 * @param mob/living/user The attacker
 * @return The calculated dodge score
 */
/mob/living/proc/calculate_dodge_score(mob/living/user)
	if(HAS_TRAIT(src, TRAIT_EVASIVE))
		return 99  // Effectively uncappable score, handled as special case
	if(HAS_TRAIT(src, TRAIT_UNDODGING))
		return -99 // Effectively impossible score

	var/dodge_modifier = 0

	var/mob/living/defending_mob = src
	var/mob/living/carbon/human/attacking_human
	var/obj/item/attacking_item

	if(ishuman(user))
		attacking_human = user
		attacking_item = attacking_human?.used_intent?.get_master_item()

	//longer weapons are harder to dodge
	var/obj/item/defending_item = get_active_held_item()
	if(istype(defending_item, /obj/item/weapon))
		switch(defending_item.wlength)
			if(WLENGTH_NORMAL)
				dodge_modifier -= 1
			if(WLENGTH_LONG)
				dodge_modifier -= 2
			if(WLENGTH_GREAT)
				dodge_modifier -= 3
		dodge_modifier += floor(defending_item.wdodgebonus / 10)

	// Intent bonuses
	dodge_modifier += floor(used_intent?.idodgebonus / 10)
	dodge_modifier += floor(rmb_intent?.def_bonus / 10)

	if(user.attributes?.has_diceroll_modifier(/datum/diceroll_modifier/guidance))
		dodge_modifier -= 2
	if(user.attributes?.has_diceroll_modifier(/datum/diceroll_modifier/fervor))
		dodge_modifier -= 1

	if(HAS_TRAIT(src, TRAIT_DODGEEXPERT))
		dodge_modifier += 3

	//knowing how an attack works helps dodge it
	if(attacking_item)
		if(!attacking_item.associated_skill)
			dodge_modifier += 1  //slightly easier to read
		else
			// 0-60 skill / 10 = 0-6 modifier range
			dodge_modifier += floor(GET_MOB_SKILL_VALUE_RAW(defending_mob, attacking_item.associated_skill) / 7)

	// Unarmed vs unarmed, skill matchup
	if(user.used_intent.unarmed)
		dodge_modifier += floor(GET_MOB_SKILL_VALUE_RAW(defending_mob, /datum/attribute/skill/combat/unarmed) / 7)
		dodge_modifier -= floor(GET_MOB_SKILL_VALUE_RAW(user, /datum/attribute/skill/combat/unarmed) / 7)

	return dodge_modifier

/**
 * Execute the dodge movement
 * @param mob/living/user The attacker
 * @param turf/target_turf The destination turf
 * @param dodge_speed The speed of the dodge
 */
/mob/living/proc/try_dodge_to(mob/living/user, turf/target_turf, dodge_speed)
	dodgecd = TRUE
	dodge_speed = (11 - dodge_speed)

	playsound(src, 'sound/combat/dodge.ogg', 100, FALSE)
	throw_at(target_turf, 1, dodge_speed, src, FALSE)

	var/drained = GET_MOB_ATTRIBUTE_VALUE(src, STAT_SPEED) > 15 ? 0 : 5  // Just a proxy to determine if it was an "easy" dodge
	if(drained > 0)
		src.visible_message("<span class='warning'><b>[src]</b> dodges [user]'s attack!</span>")
	else
		src.visible_message("<span class='warning'><b>[src]</b> easily dodges [user]'s attack!</span>")

	dodgecd = FALSE

/**
 * Find a valid turf to dodge to
 * @param list/dirry List of directions to try
 * @return Valid turf or null
 */
/mob/living/proc/find_dodge_turf(list/dirry)
	var/turf/turfy
	for(var/x in shuffle(dirry.Copy())) {
		turfy = get_step(src, x)
		if(is_valid_dodge_turf(turfy))
			return turfy
	}
	return null

/**
 * Calculate possible dodge directions based on relative positions
 * @param mob/living/user The attacker
 * @return List of directions to try dodging
 */
/mob/living/proc/calculate_dodge_directions(mob/living/user)
	var/list/dirry = GLOB.cardinals.Copy()
	var/dx = x - user.x
	var/dy = y - user.y

	if(abs(dx) < abs(dy))
		if(dy > 0)
			dirry -= SOUTH
		else
			dirry -= NORTH

	else
		if(dx > 0)
			dirry -= WEST
		else
			dirry -= EAST

	return dirry
