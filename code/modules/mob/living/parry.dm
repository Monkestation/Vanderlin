
/**
 * Attempt to parry an attack
 * @param datum/intent/intenty The intent used for the attack
 * @param mob/living/user The attacker
 * @param prob2defend Base probability of defense
 * @return TRUE if parry successful, FALSE otherwise
 */
/mob/living/proc/attempt_parry(datum/intent/intenty, mob/living/user, prob2defend)
	if(HAS_TRAIT(src, TRAIT_CHUNKYFINGERS) || (pulledby == user && pulledby.grab_state >= GRAB_AGGRESSIVE) || (pulling == user && grab_state >= GRAB_AGGRESSIVE) ||  (world.time < last_parry + setparrytime && !istype(rmb_intent, /datum/rmb_intent/riposte)) || has_status_effect(/datum/status_effect/debuff/feinted) || has_status_effect(/datum/status_effect/debuff/riposted) || (intenty && !intenty.canparry))
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
	prob2defend += parry_data["defense_bonus"]

	// Calculate skill modifiers
	var/skill_data = calculate_parry_skills(user, intenty, used_weapon, weapon_parry)
	var/defender_skill = skill_data["defender_skill"]
	var/attacker_skill = skill_data["attacker_skill"]
	prob2defend += skill_data["skill_modifier"]

	// Apply trait and position modifiers
	if(HAS_TRAIT(src, TRAIT_GUIDANCE))
		prob2defend += 10
	if(HAS_TRAIT(user, TRAIT_GUIDANCE))
		prob2defend -= 10

	if(body_position == LYING_DOWN)
		prob2defend *= 0.8

	// Clamp and roll
	prob2defend = clamp(prob2defend, 5, 95)
	if(src.client?.prefs.showrolls)
		to_chat(src, "<span class='info'>Roll to parry... [prob2defend]%</span>")

	// Check if parry is successful
	if(!prob(prob2defend))
		to_chat(src, "<span class='warning'>The enemy defeated my parry!</span>")
		return FALSE


	// Calculate additional drain for heavy weapons
	if(intenty.masteritem && intenty.masteritem.wbalance < 0 && user.STASTR > src.STASTR)
		drained = drained + (intenty.masteritem.wbalance * ((user.STASTR - src.STASTR) * -5))

	drained = max(drained, 5)

	// Execute the parry based on type
	if(weapon_parry)
		if(do_parry(used_weapon, drained, user))
			// Process skill experience and weapon damage
			process_parry_aftermath(user, used_weapon, defender_skill, attacker_skill, intenty)
			return TRUE

		return FALSE
	else
		if(do_unarmed_parry(drained, user))
			// Handle unarmed experience gain
			if((body_position != LYING_DOWN) && attacker_skill && (defender_skill < attacker_skill - SKILL_LEVEL_NOVICE))
				adjust_experience(/datum/skill/combat/unarmed, max(round(STAINT/2), 0), FALSE)

			flash_fullscreen("blackflash2")
			return TRUE

		return FALSE

/**
 * Calculate defense values for parrying
 * @param obj/item/mainhand The item in main hand
 * @param obj/item/offhand The item in off hand
 * @return List with used_weapon, weapon_parry, and defense_bonus
 */
/mob/living/proc/calculate_parry_values(obj/item/mainhand, obj/item/offhand)
	var/offhand_defense = 0
	var/mainhand_defense = 0
	var/highest_defense = 0
	var/obj/item/used_weapon = mainhand
	var/force_shield = FALSE
	var/weapon_parry = FALSE

	if(mainhand && mainhand.can_parry)
		mainhand_defense += (mind ? (get_skill_level(mainhand.associated_skill) * 20) : 20)
		mainhand_defense += (mainhand.wdefense * 10)

	if(offhand && offhand.can_parry)
		offhand_defense += (mind ? (get_skill_level(offhand.associated_skill) * 20) : 20)
		offhand_defense += (offhand.wdefense * 10)
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

	var/unarmed_defense = mind ? (get_skill_level(/datum/skill/combat/unarmed) * 20) : 20
	if(highest_defense <= unarmed_defense)
		weapon_parry = FALSE
	else
		weapon_parry = TRUE

	return list(
		"used_weapon" = used_weapon,
		"weapon_parry" = weapon_parry,
		"defense_bonus" = weapon_parry ? highest_defense : (get_skill_level(/datum/skill/combat/unarmed) * 20)
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
	var/skill_modifier = 0

	if(weapon_parry)
		defender_skill = get_skill_level(used_weapon.associated_skill)
	else
		defender_skill = get_skill_level(/datum/skill/combat/unarmed)

	if(user.mind)
		if(intenty.masteritem)
			attacker_skill = user.get_skill_level(intenty.masteritem.associated_skill)
			skill_modifier -= (attacker_skill * 20)

			if(intenty.masteritem.wbalance > 0 && user.STASPD > src.STASPD)
				skill_modifier -= (intenty.masteritem.wbalance * ((user.STASPD - src.STASPD) * 10))
		else
			attacker_skill = user.get_skill_level(/datum/skill/combat/unarmed)
			skill_modifier -= (attacker_skill * 20)



	return list(
		"defender_skill" = defender_skill,
		"attacker_skill" = attacker_skill,
		"skill_modifier" = skill_modifier
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
			H.adjust_experience(/datum/skill/combat/shields, max(round(H.STAINT * boon), 0), FALSE)
		else
			H.adjust_experience(used_weapon.associated_skill, max(round(H.STAINT/2), 0), FALSE)

	// Attacker skill gain
	var/obj/item/AB = intenty.masteritem
	if((U.body_position != LYING_DOWN) && defender_skill && (attacker_skill < defender_skill - SKILL_LEVEL_NOVICE))
		if(AB)
			U.adjust_experience(AB.associated_skill, max(round(U.STAINT/2), 0), FALSE)
		else
			U.adjust_experience(/datum/skill/combat/unarmed, max(round(U.STAINT/2), 0), FALSE)

	var/obj/effect/temp_visual/dir_setting/block/blk = new(get_turf(src), get_dir(H, U))
	blk.icon_state = "p[U.used_intent.animname]"

	if(prob(66) && AB)
		if((used_weapon.flags_1 & CONDUCT_1) && (AB.flags_1 & CONDUCT_1))
			flash_fullscreen("whiteflash")
			user.flash_fullscreen("whiteflash")
			var/datum/effect_system/spark_spread/S = new()
			S.set_up(n = 1, loca = get_turf(src))
			S.start()
		else
			flash_fullscreen("blackflash2")

	else
		flash_fullscreen("blackflash2")

	var/dam2take = round((get_complex_damage(AB, user, used_weapon.blade_dulling)/2), 1)
	if(dam2take)
		used_weapon.take_damage(max(dam2take, 1), BRUTE, used_weapon.damage_type)

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

		if(!H.adjust_stamina(parrydrain))
			to_chat(src, "<span class='warning'>I'm too tired to parry!</span>")
			return FALSE
		if(W)
			playsound(get_turf(src), pick(W.parrysound), 100, FALSE)

		if(istype(rmb_intent, /datum/rmb_intent/riposte))
			src.visible_message("<span class='boldwarning'><b>[src]</b> ripostes [user] with [W]!</span>")
		else if(istype(W, /obj/item/weapon/shield))
			src.visible_message("<span class='boldwarning'><b>[src]</b> blocks [user] with [W]!</span>")

			// Check shield integrity
			var/shieldur = round(((W.obj_integrity / W.max_integrity) * 100), 1)
			if(shieldur <= 30)
				src.visible_message("<span class='boldwarning'><b>\The [W] is about to break!</b></span>")
		else
			src.visible_message("<span class='boldwarning'><b>[src]</b> parries [user] with [W]!</span>")
	else
		// Non-human parry (simpler)
		if(W)
			playsound(get_turf(src), pick(W.parrysound), 100, FALSE)

	if(!(!src.mind || !user.mind))
		log_defense(src, user, "parried", defending_item, attacking_item, "INTENT:[uppertext(user.used_intent.name)]")

	if(src.client)
		GLOB.vanderlin_round_stats[STATS_PARRIES]++

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
		playsound(get_turf(src), pick(parry_sound), 100, FALSE)
		src.visible_message("<span class='warning'><b>[src]</b> parries [user] with their hands!</span>")
	else
		// Non-human parry (simpler)
		playsound(get_turf(src), pick(parry_sound), 100, FALSE)

	if(!(!src.mind || !user.mind))
		log_defense(src, user, user.get_active_held_item() ? "parried" : "unarmed parried",
				   "hands", attacking_item, "INTENT:[uppertext(user.used_intent.name)]")

	if(src.client)
		GLOB.vanderlin_round_stats[STATS_PARRIES]++

	return TRUE
