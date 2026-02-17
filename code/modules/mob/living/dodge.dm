
/**
 * Attempt to dodge an attack
 * @param datum/intent/intenty The intent used for the attack
 * @param mob/living/user The attacker
 * @return TRUE if dodge successful, FALSE otherwise
 */
/mob/living/proc/attempt_dodge(datum/intent/intenty, mob/living/user, can_dodge_see = TRUE)
	// Early return conditions specifically for dodging
	if((pulledby && pulledby.grab_state >= GRAB_AGGRESSIVE) || pulling || (world.time < last_dodge + dodgetime && !istype(rmb_intent, /datum/rmb_intent/riposte)) ||  has_status_effect(/datum/status_effect/debuff/riposted) || src.loc == user.loc || (intenty && !intenty.candodge) || !candodge)
		return FALSE

	// Calculate dodge directions based on relative positions
	var/list/dirry = calculate_dodge_directions(user)

	// Find a valid dodge turf
	var/turf/turfy = find_dodge_turf(dirry)

	if(do_dodge(user, turfy, can_dodge_see))
		flash_fullscreen("blackflash2")
		user.aftermiss()
		var/attacking_item = user.get_active_held_item()
		if(!(!src.mind || !user.mind))
			log_defense(src, user, "dodged", attacking_atom = attacking_item,
					   addition = "(INTENT:[uppertext(user.used_intent.name)])")

		if(src.client)
			record_round_statistic(STATS_DODGES)
		return TRUE
	return FALSE

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
	var/dodge_speed = floor(STASPD / 2)
	var/dodge_score = calculate_dodge_score(user)

	//------------Duel Wielding------------
	var/attacker_dualwielding = user.dual_wielding_check()

	if(istype(src, /mob/living/carbon/human))
		var/mob/living/carbon/human/H = src
		switch(H.worn_armor_class)
			if(AC_LIGHT)
				dodge_speed -= 10
				drained += 3
			if(AC_MEDIUM)
				dodge_score *= 0.5
				dodge_speed = floor(dodge_speed * 0.5)
				drained += 7
			if(AC_HEAVY)
				dodge_score *= 0.2
				dodge_speed = floor(dodge_speed * 0.25)
				drained += 12

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

	if(!can_dodge_see)
		dodge_score -= 40

	dodge_score = clamp(dodge_score, 0, 95)
	var/dodgeroll = rand(1, 100)
	var/second_dodgeroll = rand(1, 100)

	if(client?.prefs.showrolls)
		to_chat(src, span_info("Roll under [dodge_score] to dodge... [dodgeroll]"))

	if(dodgeroll > dodge_score)
		return FALSE

	if(attacker_dualwielding)
		if(client?.prefs.showrolls)
			to_chat(src, span_info("Twice! Roll under [dodge_score] to dodge... [second_dodgeroll]"))
		if(second_dodgeroll > dodge_score)
			return FALSE

	try_dodge_to(user, target_turf, dodge_speed)

	// Log the dodge
	var/obj/item/defending_item = get_active_held_item()
	var/obj/item/attacking_item = user.get_active_held_item()

	if(!(!mind || !user.mind)) // don't need to log if at least one of the mobs is without an initialized mind
		log_defense(src, user, "dodged", defending_item, attacking_item, "INTENT:[uppertext(user.used_intent.name)]")

	if(client)
		record_round_statistic(STATS_DODGES)

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
	var/dodge_score = defprob
	if(HAS_TRAIT(src, TRAIT_EVASIVE))
		return 200
	if(HAS_TRAIT(src, TRAIT_UNDODGING))
		return 0

	var/obj/item/defending_item = get_active_held_item()
	var/obj/item/attacking_item

	var/mob/living/carbon/human/defending_human
	var/mob/living/carbon/human/attacking_human

	if(ishuman(src))
		defending_human = src
	if(ishuman(user))
		attacking_human = user
		attacking_item = attacking_human.used_intent.get_master_item()

	dodge_score += (STASPD * 15)
	dodge_score *= encumbrance_to_dodge()

	if(user)
		dodge_score -= user.STASPD * 9

	if(attacking_item)
		if(attacking_human?.mind)
			dodge_score -= (attacking_human.get_skill_level(attacking_item.associated_skill, TRUE) * 10)

		if(attacking_item.wbalance > 0)
			dodge_score -= ((user.STASPD - STASPD) * 5)

	if(istype(defending_item, /obj/item/weapon))
		switch(defending_item.wlength)
			if(WLENGTH_NORMAL)
				dodge_score -= 5
			if(WLENGTH_LONG)
				dodge_score -= 10
			if(WLENGTH_GREAT)
				dodge_score -= 15

		dodge_score += defending_item.wdodgebonus

	dodge_score += used_intent?.idodgebonus
	dodge_score += rmb_intent?.def_bonus

	if(HAS_TRAIT(src, TRAIT_GUIDANCE))
		dodge_score += 10
	if(HAS_TRAIT(user, TRAIT_GUIDANCE))
		dodge_score -= 10

	if(defending_human?.mind && attacking_item)
		if(!attacking_item.associated_skill)
			dodge_score += 10  // Improvised weapon penalty
		else
			dodge_score += (defending_human.get_skill_level(attacking_item.associated_skill, TRUE) * 10)

	if(defending_human?.mind && attacking_human?.mind && attacking_human.used_intent.unarmed)
		dodge_score -= (attacking_human.get_skill_level(/datum/skill/combat/unarmed, TRUE) * 10)
		dodge_score += (defending_human.get_skill_level(/datum/skill/combat/unarmed, TRUE) * 10)

	return dodge_score

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

	var/drained = STASPD > 15 ? 0 : 5  // Just a proxy to determine if it was an "easy" dodge
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
