/*
/mob/living/proc/update_parrying_penalty(incoming = PARRYING_PENALTY, duration = PARRYING_PENALTY_COOLDOWN_DURATION)
	if(!incoming || !duration)
		return
	if(parrying_penalty_timer)
		deltimer(parrying_penalty_timer)
		parrying_penalty_timer = null
	parrying_penalty += incoming  // Stacks additively
	parrying_penalty_timer = addtimer(CALLBACK(src, PROC_REF(remove_parrying_penalty)), duration, TIMER_STOPPABLE)

/mob/living/proc/remove_parrying_penalty()
	parrying_penalty = 0
	if(parrying_penalty_timer)
		deltimer(parrying_penalty_timer)
	parrying_penalty_timer = null
*/

/mob/living/proc/get_parrying_score(skill_used = /datum/attribute/skill/combat/unarmed, modifier = 0)
	var/stun_penalty = 0
	if(incapacitated())
		stun_penalty = 4
	if(cmode && (d_intent == INTENT_PARRY))
		modifier += 2
	return floor(max(0, 1 + GET_MOB_SKILL_VALUE(src, skill_used)/2 + modifier - stun_penalty))

/**
 * Attempt to parry an attack
 * @param datum/intent/intenty The intent used for the attack
 * @param mob/living/user The attacker
 * @param prob2defend Base probability of defense
 * @return TRUE if parry successful, FALSE otherwise
 */
/mob/living/proc/attempt_parry(datum/intent/intenty, mob/living/user, prob2defend)
	if(HAS_TRAIT(src, TRAIT_CHUNKYFINGERS))
		return FALSE
	if(intenty && !intenty.canparry)
		return FALSE
	if(incapacitated())
		return FALSE
	if(has_status_effect(/datum/status_effect/debuff/exposed))
		return FALSE
	if(has_status_effect(/datum/status_effect/debuff/vulnerable))
		return FALSE
	if(world.time < last_parry + setparrytime && !istype(rmb_intent, /datum/rmb_intent/riposte))
		return FALSE
	last_parry = world.time

	var/drained = user.defdrain
	var/weapon_parry = FALSE
	var/obj/item/mainhand = get_active_held_item()
	var/obj/item/offhand = get_inactive_held_item()
	var/obj/item/used_weapon = mainhand

	var/parry_data = calculate_parry_values(mainhand, offhand)
	used_weapon = parry_data["used_weapon"]
	weapon_parry = parry_data["weapon_parry"]

	var/skill_data = calculate_parry_skills(user, intenty, used_weapon, weapon_parry)
	var/defender_skill = skill_data["defender_skill"]
	var/attacker_skill = skill_data["attacker_skill"]

	var/skill_type = weapon_parry ? used_weapon.associated_skill : /datum/attribute/skill/combat/unarmed

	var/parry_modifier = parry_data["weapon_defense_flat"] * 2
	parry_modifier += floor(rmb_intent?.def_bonus / 10)

	if(user.attributes?.has_diceroll_modifier(/datum/diceroll_modifier/guidance))
		parry_modifier -= 2

	if(user.attributes?.has_diceroll_modifier(/datum/diceroll_modifier/fervor))
		parry_modifier -= 1

	// Situational penalties
	if(body_position == LYING_DOWN)
		parry_modifier -= 2

	var/attacker_opposition = floor(attacker_skill / 2)

	// Speed penalty for fast weapons still applies
	if(user.mind)
		var/obj/item/master = intenty.get_master_item()
		if(master?.wbalance > 0 && GET_MOB_ATTRIBUTE_VALUE(user, STAT_SPEED) > GET_MOB_ATTRIBUTE_VALUE(src, STAT_SPEED))
			var/speed_delta = GET_MOB_ATTRIBUTE_VALUE(user, STAT_SPEED) - GET_MOB_ATTRIBUTE_VALUE(src, STAT_SPEED)
			parry_modifier -= speed_delta * 2

	var/parry_score = get_parrying_score(skill_type, parry_modifier - attacker_opposition)

	var/attacker_dualwielding = user.dual_wielding_check()
	var/defender_dualwielding = dual_wielding_check()

	// Show roll info to defender
	if(client?.prefs.showrolls)
		var/text = "Roll to parry... (score: [parry_score])"
		if(attacker_dualwielding)
			if(defender_dualwielding)
				text += " Dual wield cancels out."
			else
				text += " Disadvantage! (score: [max(0, parry_score - 2)])"
		to_chat(src, span_info("[text]"))

	//disadvantage from attacker dual wielding lowers score by 2 if unmatched
	var/effective_score = parry_score
	if(attacker_dualwielding && !defender_dualwielding)
		effective_score = max(0, parry_score - 2)

	var/roll_result = diceroll(effective_score, context = DICE_CONTEXT_PHYSICAL)

	// Show attacker feedback
	if(user.client?.prefs.showrolls && attacker_dualwielding)
		var/attacker_feedback = "Attacking with advantage."
		if(defender_dualwielding)
			attacker_feedback += " Cancelled out!"
		to_chat(user, span_info("[attacker_feedback]"))

	if(roll_result == DICE_FAILURE || roll_result == DICE_CRIT_FAILURE)
		if(roll_result == DICE_CRIT_FAILURE)
			to_chat(src, span_warning("I completely fumbled my parry!"))
		else
			to_chat(src, span_warning("The enemy defeated my parry!"))
		return FALSE

	/*update_parrying_penalty()*/

	//heavy weapon strength differential still applies
	var/obj/item/master = intenty.get_master_item()
	if(master?.wbalance < 0 && GET_MOB_ATTRIBUTE_VALUE(user, STAT_STRENGTH) > GET_MOB_ATTRIBUTE_VALUE(src, STAT_STRENGTH))
		drained = drained + (master.wbalance * ((GET_MOB_ATTRIBUTE_VALUE(user, STAT_STRENGTH) - GET_MOB_ATTRIBUTE_VALUE(src, STAT_STRENGTH)) * -5))
	drained = max(drained, 5)

	//reduce drain on exceptional parry
	if(roll_result == DICE_CRIT_SUCCESS)
		drained = floor(drained * 0.5)
		to_chat(src, span_notice("A perfect parry!"))

	if(weapon_parry)
		if(do_parry(used_weapon, drained, user))
			process_parry_aftermath(user, used_weapon, defender_skill, attacker_skill, intenty)
			return TRUE
		return FALSE
	else
		if(do_unarmed_parry(drained, user))
			if((body_position != LYING_DOWN) && attacker_skill && (defender_skill < attacker_skill - SKILL_LEVEL_NOVICE))
				adjust_experience(/datum/attribute/skill/combat/unarmed, max(round(GET_MOB_ATTRIBUTE_VALUE(src, STAT_INTELLIGENCE)/2), 0), FALSE)
			flash_fullscreen("blackflash2")
			return TRUE
		return FALSE

/mob/living/proc/get_shield_block_chance()
	var/obj/item/weapon/shield = get_active_held_item()
	if(!istype(shield))
		shield = get_inactive_held_item()
	if(!istype(shield))
		return 0

	var/shield_skill = max(1, GET_MOB_SKILL_VALUE_OLD(src, /datum/attribute/skill/combat/shields))

	return shield.wdefense * shield_skill * 2
/**
 * Calculate defense values for parrying
 * @param obj/item/mainhand The item in main hand
 * @param obj/item/offhand The item in off hand
 * @return List with used_weapon, weapon_parry, and weapon_defense_flat
 */
/mob/living/proc/calculate_parry_values(obj/item/mainhand, obj/item/offhand)
	var/offhand_defense = 0
	var/mainhand_defense = 0
	var/highest_defense = 0
	var/obj/item/used_weapon = mainhand
	var/force_shield = FALSE
	var/weapon_parry = FALSE

	if(mainhand && mainhand.can_parry)
		mainhand_defense += nulltozero(GET_MOB_SKILL_VALUE(src, mainhand.associated_skill))
		if(istype(mainhand, /obj/item/weapon/shield))
			force_shield = TRUE
			used_weapon = mainhand

	if(offhand && offhand.can_parry)
		offhand_defense += nulltozero(GET_MOB_SKILL_VALUE(src, offhand.associated_skill))
		if(istype(offhand, /obj/item/weapon/shield))
			force_shield = TRUE

	if(!force_shield)
		if(mainhand_defense >= offhand_defense)
			highest_defense += mainhand_defense
		else
			used_weapon = offhand
			highest_defense += offhand_defense
	else
		used_weapon = offhand
		highest_defense += offhand_defense

	if(!used_weapon)
		weapon_parry = FALSE
	else
		weapon_parry = TRUE

	return list(
		"used_weapon" = used_weapon,
		"weapon_parry" = weapon_parry,
		"weapon_defense_flat" = weapon_parry ? used_weapon.wdefense : 0
	)

/**
 * Calculate skill modifiers for parrying
 * @param mob/living/user The attacker
 * @param datum/intent/intenty The intent used for the attack
 * @param obj/item/used_weapon The weapon used for parrying
 * @param weapon_parry Whether using a weapon to parry
 * @return List with defender_skill, attacker_skill, and skill_modifier
 */
/mob/living/proc/calculate_parry_skills(mob/living/user, datum/intent/intenty, obj/item/used_weapon, weapon_parry)
	var/defender_skill = 0
	var/attacker_skill = 0

	if(weapon_parry)
		defender_skill = GET_MOB_SKILL_VALUE(src, used_weapon.associated_skill)
	else
		defender_skill = GET_MOB_SKILL_VALUE(src, /datum/attribute/skill/combat/unarmed)

	if(user.mind)
		var/obj/item/master = intenty.get_master_item()
		if(master)
			attacker_skill = GET_MOB_SKILL_VALUE(user, master.associated_skill)
		else
			attacker_skill = GET_MOB_SKILL_VALUE(user, /datum/attribute/skill/combat/unarmed)

	return list(
		"defender_skill" = defender_skill,
		"attacker_skill" = attacker_skill
	)

/**
 * Process aftermath of a successful parry
 * @param mob/living/user The attacker
 * @param obj/item/used_weapon The weapon used for parrying
 * @param defender_skill Defender's skill level
 * @param attacker_skill Attacker's skill level
 * @param datum/intent/intenty The intent used for the attack
 */
/mob/living/proc/process_parry_aftermath(mob/living/user, obj/item/used_weapon, defender_skill, attacker_skill, datum/intent/intenty)
	// Skip if not human
	if(!ishuman(src))
		return

	var/mob/living/carbon/human/H = src
	var/mob/living/carbon/human/U = user

	// Defender skill gain
	if((body_position != LYING_DOWN) && attacker_skill && (defender_skill < attacker_skill - SKILL_LEVEL_NOVICE))
		if(used_weapon == get_inactive_held_item() && istype(used_weapon, /obj/item/weapon/shield))
			var/boon = H.get_learning_boon(/obj/item/weapon/shield)
			H.adjust_experience(/datum/attribute/skill/combat/shields, max(round(GET_MOB_ATTRIBUTE_VALUE(H, STAT_INTELLIGENCE) * boon), 0), FALSE)
		else
			H.adjust_experience(used_weapon.associated_skill, max(round(GET_MOB_ATTRIBUTE_VALUE(H, STAT_INTELLIGENCE)/2), 0), FALSE)

	// Attacker skill gain
	var/obj/item/AB = intenty.get_master_item()
	if((U.body_position != LYING_DOWN) && defender_skill && (attacker_skill < defender_skill - SKILL_LEVEL_NOVICE))
		if(AB)
			U.adjust_experience(AB.associated_skill, max(round(GET_MOB_ATTRIBUTE_VALUE(U, STAT_INTELLIGENCE)/2), 0), FALSE)
		else
			U.adjust_experience(/datum/attribute/skill/combat/unarmed, max(round(GET_MOB_ATTRIBUTE_VALUE(U, STAT_INTELLIGENCE)/2), 0), FALSE)

	var/obj/effect/temp_visual/dir_setting/block/blk = new(get_turf(src), get_dir(H, U))
	blk.icon_state = "p[U.used_intent.animname]"

	if(prob(66) && AB)
		if((used_weapon.flags_1 & CONDUCT_1) && (AB.flags_1 & CONDUCT_1))
			flash_fullscreen("whiteflash")
			user.flash_fullscreen("whiteflash")
			var/datum/effect_system/spark_spread/S = new()
			S.set_up(1, FALSE, src)
			S.start()
		else
			flash_fullscreen("blackflash2")

	else
		flash_fullscreen("blackflash2")

	var/dam2take = round((get_complex_damage(AB, user, FALSE)/2), 1)
	if(dam2take)
		var/intdam = used_weapon.max_blade_int ? INTEG_PARRY_DECAY : INTEG_PARRY_DECAY_NOSHARP
		used_weapon.take_damage(intdam, BRUTE, used_weapon.damage_type)
		used_weapon.remove_bintegrity(SHARPNESS_ONHIT_DECAY, user)

/**
 * Handle parrying attacks with a weapon
 * @param obj/item/W The weapon used to parry
 * @param parrydrain The stamina cost of parrying
 * @param mob/living/user The attacker being parried
 * @return TRUE if parry successful, FALSE otherwise
 */
/mob/proc/do_parry(obj/item/W, parrydrain as num, mob/living/user)
	var/defending_item = W
	var/attacking_item = user.get_active_held_item()

	if(ishuman(src))
		var/mob/living/carbon/human/H = src

		if(H.stamina + parrydrain >= H.maximum_stamina)
			to_chat(src, span_warning("I'm too tired to parry!"))
			return FALSE
		if(!H.adjust_stamina(parrydrain))
			to_chat(src, span_warning("I'm too tired to parry!"))
			return FALSE
		if(W)
			playsound(src, pick(W.parrysound), 100, FALSE)

		if(istype(rmb_intent, /datum/rmb_intent/riposte))
			src.visible_message("<span class='boldwarning'><b>[src]</b> ripostes [user] with [W]!</span>")
		else if(istype(W, /obj/item/weapon/shield))
			src.visible_message("<span class='boldwarning'><b>[src]</b> blocks [user] with [W]!</span>")
		else
			src.visible_message("<span class='boldwarning'><b>[src]</b> parries [user] with [W]!</span>")

			// Check shield integrity
			var/shieldur = round(((W.get_integrity() / W.max_integrity) * 100), 1)
			if(shieldur <= 30)
				src.visible_message("<span class='boldwarning'><b>\The [W] is about to break!</b></span>")

	else
		// Non-human parry (simpler)
		if(W)
			playsound(src, pick(W.parrysound), 100, FALSE)

	if(!(!src.mind || !user.mind))
		log_defense(src, user, "parried", defending_item, attacking_item, "INTENT:[uppertext(user.used_intent.name)]")

	if(src.client)
		record_round_statistic(STATS_PARRIES)

	return TRUE

/**
 * Handle parrying attacks without a weapon
 * @param parrydrain The stamina cost of parrying
 * @param mob/living/user The attacker being parried
 * @return TRUE if parry successful, FALSE otherwise
 */
/mob/proc/do_unarmed_parry(parrydrain as num, mob/living/user)
	var/attacking_item = user.get_active_held_item()

	if(ishuman(src))
		var/mob/living/carbon/human/H = src
		if(!H.adjust_stamina(parrydrain))
			to_chat(src, "<span class='boldwarning'>I'm too tired to parry!</span>")
			return FALSE
		playsound(src, pick(parry_sound), 100, FALSE)
		src.visible_message("<span class='warning'><b>[src]</b> parries [user] with their hands!</span>")
	else
		// Non-human parry (simpler)
		playsound(src, pick(parry_sound), 100, FALSE)

	if(!(!src.mind || !user.mind))
		log_defense(src, user, user.get_active_held_item() ? "parried" : "unarmed parried",
				   "hands", attacking_item, "INTENT:[uppertext(user.used_intent.name)]")

	if(src.client)
		record_round_statistic(STATS_PARRIES)

	return TRUE
