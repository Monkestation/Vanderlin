#define HUMAN_NPC_BASE_JUKE_CHANCE              15
#define HUMAN_NPC_JUKE_MIN_SPD                  10
#define HUMAN_NPC_JUKE_PER_OVERSPD              5
#define HUMAN_NPC_WEAKPOINT_SCAN_CHANCE         20
#define HUMAN_NPC_WEAKPOINT_CACHE_DURATION      (6 SECONDS)
#define HUMAN_NPC_WEAPON_SPECIAL_CHANCE         35
#define HUMAN_NPC_INTENT_SWITCH_CHANCE          25  // chance per attack to start a new intent sequence
#define HUMAN_NPC_RMB_ATTEMPT_CHANCE			25


//Note alot of this is just adapted from old code so its probably not the best

/datum/ai_planning_subtree/basic_melee_attack_subtree/human_npc
	melee_attack_behavior = /datum/ai_behavior/basic_melee_attack/human_npc
	end_planning = TRUE

/datum/ai_behavior/basic_melee_attack/human_npc
	action_cooldown = 0.2 SECONDS
	behavior_flags = AI_BEHAVIOR_REQUIRE_MOVEMENT | AI_BEHAVIOR_REQUIRE_REACH | AI_BEHAVIOR_CAN_PLAN_DURING_EXECUTION

/datum/ai_behavior/basic_melee_attack/human_npc/setup(datum/ai_controller/controller, target_key, targetting_datum_key, hiding_location_key)
	. = ..()
	if(!.)
		return FALSE
	var/mob/living/carbon/human/pawn = controller.pawn
	var/atom/target = controller.blackboard[target_key]

	var/obj/item/held_item = pawn.get_active_held_item()
	if((!isweapon(held_item)))
		pawn.swap_hand()
		for(var/slot in list(ITEM_SLOT_BACK, ITEM_SLOT_HIP, ITEM_SLOT_BELT_L, ITEM_SLOT_BACK_L, ITEM_SLOT_BACK_R, ITEM_SLOT_BELT_R))
			if(!pawn.get_item_by_slot(slot))
				if(pawn.equip_to_slot_if_possible(held_item, slot, disable_warning = TRUE))
					break

	var/list/possible_intents = list()
	for(var/datum/intent/intent as anything in pawn.possible_a_intents)
		if(istype(intent, /datum/intent/unarmed/help) || istype(intent, /datum/intent/unarmed/shove) || istype(intent, /datum/intent/unarmed/grab))
			continue
		possible_intents |= intent
	if(length(possible_intents))
		pawn.a_intent = pick(possible_intents)
		pawn.used_intent = pawn.a_intent

	if(prob(HUMAN_NPC_WEAKPOINT_SCAN_CHANCE) && isliving(target))
		_scan_for_weakpoint(controller, pawn, target)

/datum/ai_behavior/basic_melee_attack/human_npc/perform(delta_time, datum/ai_controller/controller, target_key, targetting_datum_key, hiding_location_key)
	controller.behavior_cooldowns[src] = world.time + get_cooldown(controller) //we don't wanna call parent tbh
	var/mob/living/carbon/human/pawn = controller.pawn
	var/atom/target = controller.blackboard[target_key]
	var/datum/targetting_datum/td = controller.blackboard[targetting_datum_key]

	var/obj/item/weapon/held_weapon = pawn.get_active_held_item()
	if(!held_weapon)
		for(var/obj/item/weapon/candidate in range(1, pawn))
			if(!isturf(candidate.loc))
				continue
			pawn.put_in_active_hand(candidate)
			break

	if(!td.can_attack(pawn, target))
		finish_action(controller, FALSE, target_key)
		return
	if(ismob(target) && target:stat == DEAD)
		finish_action(controller, FALSE, target_key)
		return

	SEND_SIGNAL(pawn, COMSIG_MOB_TRY_BARK)
	var/hiding_target = td.find_hidden_mobs(pawn, target)
	controller.set_blackboard_key(hiding_location_key, hiding_target)

	pawn.face_atom(target)
	_choose_attack_zone(controller, pawn, target)

	if(!pawn.CanReach(target))
		finish_action(controller, FALSE, target_key)
		return

	if(_try_weapon_special(controller))
		return

	_update_combat_intent(controller, pawn, target)
	var/list/modifiers = list()
	var/old_cmode = pawn.cmode
	if(prob(HUMAN_NPC_RMB_ATTEMPT_CHANCE))
		pawn.cmode = TRUE
		if(pawn.stamina < pawn.maximum_stamina * 0.7 && istype(pawn.rmb_intent, /datum/rmb_intent/feint))
			modifiers = list(RIGHT_CLICK = TRUE)

	if(hiding_target)
		controller.ai_interact(hiding_target, TRUE, TRUE, modifiers)
	else
		controller.ai_interact(target, TRUE, TRUE, modifiers)

	pawn.cmode = old_cmode
	if(pawn.next_click < world.time)
		pawn.next_click = world.time + (pawn.used_intent?.clickcd * ( 1 + rand(0.2, 0.4)))
		SEND_SIGNAL(pawn, COMSIG_MOB_BREAK_SNEAK)

	if(prob(HUMAN_NPC_WEAKPOINT_SCAN_CHANCE) && isliving(target))
		_scan_for_weakpoint(controller, pawn, target)

	_try_backstep(pawn, target)

/datum/ai_behavior/basic_melee_attack/human_npc/finish_action(datum/ai_controller/controller, succeeded, target_key, targetting_datum_key, hiding_location_key)
	. = ..()
	var/mob/living/carbon/human/pawn = controller.pawn
	pawn.cmode = FALSE
	SEND_SIGNAL(pawn, COMSIG_COMBAT_TARGET_SET, FALSE)

/datum/ai_behavior/basic_melee_attack/human_npc/proc/_update_combat_intent(datum/ai_controller/controller, mob/living/carbon/human/pawn, mob/living/target)
	var/attacks_left = controller.blackboard[BB_HUMAN_NPC_CURRENT_INTENT_ATTACKS_LEFT]

	if(attacks_left > 0)
		controller.set_blackboard_key(BB_HUMAN_NPC_CURRENT_INTENT_ATTACKS_LEFT, attacks_left - 1)
		return

	if(!prob(HUMAN_NPC_INTENT_SWITCH_CHANCE))
		return

	var/skill_level = SKILL_LEVEL_NONE
	var/obj/item/held = pawn.get_active_held_item()
	if(held?.associated_skill)
		skill_level = GET_MOB_SKILL_VALUE_OLD(pawn, held.associated_skill)

	var/list/weighted = list(
		/datum/rmb_intent/strong = 45,
		/datum/rmb_intent/swift  = 40,
		/datum/rmb_intent/feint  = 15,
	)

	if(pawn.stamina > pawn.maximum_stamina * 0.6)
		weighted[/datum/rmb_intent/strong] = 0  // force swift when tired
	else if(pawn.stamina > pawn.maximum_stamina * 0.4)
		weighted[/datum/rmb_intent/strong] -= 20
		weighted[/datum/rmb_intent/swift] += 20

	// Skilled fighters use strong more
	if(skill_level >= SKILL_LEVEL_JOURNEYMAN)
		weighted[/datum/rmb_intent/strong] += 15

	// Feint more against defenders
	if(isliving(target))
		var/mob/living/carbon/human/htarget = target
		if(istype(htarget?.rmb_intent, /datum/rmb_intent/riposte) || istype(htarget?.rmb_intent, /datum/rmb_intent/guard))
			weighted[/datum/rmb_intent/feint] += 25

	var/chosen_type = pickweight(weighted)
	var/datum/rmb_intent/chosen = locate(chosen_type) in pawn.possible_rmb_intents
	if(chosen)
		pawn.rmb_intent = chosen

	controller.set_blackboard_key(BB_HUMAN_NPC_CURRENT_INTENT_ATTACKS_LEFT, rand(3, 6))


/datum/ai_behavior/basic_melee_attack/human_npc/proc/_choose_attack_zone(datum/ai_controller/controller, mob/living/carbon/human/pawn, mob/living/target)
	var/list/wp = controller.blackboard[BB_HUMAN_NPC_WEAKPOINT]
	if(wp && world.time < wp[2] && wp[3] == target)
		var/aimheight = _zone_to_aimheight(wp[1])
		if(aimheight)
			pawn.aimheight_change(aimheight)
		return

	var/counter = controller.blackboard[BB_HUMAN_NPC_ATTACK_ZONE_COUNTER]
	if(counter < 4)
		controller.set_blackboard_key(BB_HUMAN_NPC_ATTACK_ZONE_COUNTER, counter + 1)
		return

	controller.set_blackboard_key(BB_HUMAN_NPC_ATTACK_ZONE_COUNTER, 0)
	controller.clear_blackboard_key(BB_HUMAN_NPC_WEAKPOINT)

	// Parity with npc_choose_attack_zone aimheight picks
	if(pawn.mind?.has_antag_datum(/datum/antagonist/zombie))
		pawn.aimheight_change(pawn.deadite_get_aimheight(target))
		return
	if(!(pawn.mobility_flags & MOBILITY_STAND))
		pawn.aimheight_change(rand(1, 4))
		return
	if(HAS_TRAIT(target, TRAIT_BLOODLOSS_IMMUNE))
		pawn.aimheight_change(rand(12, 19))
		return
	pawn.aimheight_change(pick(rand(5, 8), rand(9, 11), rand(12, 19)))

/datum/ai_behavior/basic_melee_attack/human_npc/proc/_try_weapon_special(datum/ai_controller/controller)
	var/mob/living/carbon/human/pawn = controller.pawn

	if(pawn.has_status_effect(/datum/status_effect/debuff/specialcd))
		return FALSE

	var/obj/item/weapon/held_weapon = pawn.get_active_held_item()
	if(!istype(held_weapon) || !held_weapon.weapon_special)
		return FALSE

	if(!prob(HUMAN_NPC_WEAPON_SPECIAL_CHANCE))
		return FALSE

	// Check we can actually afford the stamina cost before attempting
	var/datum/special_intent/special = held_weapon.weapon_special
	if(special.stamina_cost)
		var/cost = (special.stamina_cost < 1) ? (pawn.maximum_stamina * special.stamina_cost) : special.stamina_cost
		if(!pawn.check_stamina(cost))
			return FALSE

	var/datum/rmb_intent/strong/strong_intent = locate(/datum/rmb_intent/strong) in pawn.possible_rmb_intents
	if(!strong_intent)
		return FALSE

	var/prev_intent = pawn.rmb_intent.type
	pawn.swap_rmb_intent(strong_intent)
	var/atom/target = controller.blackboard[BB_BASIC_MOB_CURRENT_TARGET]
	var/success = pawn.rmb_intent.special_attack(pawn, target)
	pawn.swap_rmb_intent(prev_intent)
	return success

/// Scan target bodyparts for wounded (brute/burn > 20) or unarmored zones.
/// Caches as list(zone, expiry_time, target_ref).
/datum/ai_behavior/basic_melee_attack/human_npc/proc/_scan_for_weakpoint(datum/ai_controller/controller, mob/living/carbon/human/pawn, mob/living/target)
	if(!istype(target, /mob/living/carbon/human))
		return
	var/mob/living/carbon/human/htarget = target

	// Resolve weapon skill and blade class from active intent
	var/skill_type = null
	var/bclass = null
	var/intent_reach = 1
	if(pawn.used_intent)
		bclass = pawn.used_intent.blade_class
		intent_reach = pawn.used_intent.reach || 1
		// Walk held items to find associated_skill
		for(var/obj/item/held in pawn.get_active_held_items())
			if(held?.associated_skill)
				skill_type = held.associated_skill
				break

	var/skill_level = skill_type ? GET_MOB_SKILL_VALUE_OLD(pawn, skill_type) : SKILL_LEVEL_NONE
	var/armor_rating = bclass ? bclass_to_armor_rating(bclass) : "blunt"

	var/list/wounded  = list()
	var/list/exposed  = list()
	var/list/soft     = list() // armored but below meaningful resistance for our damage type

	for(var/obj/item/bodypart/part in htarget.bodyparts)
		if(!part)
			continue

		//requires trained eye AND good perception
		if(skill_level >= SKILL_LEVEL_JOURNEYMAN && GET_MOB_ATTRIBUTE_VALUE(pawn, STAT_PERCEPTION) >= 10)
			if(part.brute_dam > 20 || part.burn_dam > 20)
				wounded += part.body_zone

		var/obj/item/worn = htarget.get_item_by_slot(part.body_zone)
		if(!worn?.armor)
			exposed += part.body_zone
			continue

		// Basic+ fighters read armor and seek soft coverage for their damage type
		if(skill_level >= SKILL_LEVEL_NOVICE)
			var/rating = worn.armor.getRating(armor_rating)
			if(rating < 25)
				soft += part.body_zone
		// Unskilled fighters just notice bare skin
		else if(!worn)
			exposed += part.body_zone

	// Priority: wounded > bare exposed > soft armor coverage > armored fallback (experts only)
	var/chosen = null
	if(length(wounded))
		chosen = pick(wounded)
	else if(length(exposed))
		chosen = pick(exposed)
	else if(length(soft))
		chosen = pick(soft)
	else if(skill_level >= SKILL_LEVEL_EXPERT)
		// Expert fallback: just pick whatever zone has the lowest resistance for our damage type
		var/lowest_rating = INFINITY
		var/lowest_zone = null
		for(var/obj/item/bodypart/part in htarget.bodyparts)
			if(!part)
				continue
			var/obj/item/worn = htarget.get_item_by_slot(part.body_zone)
			if(!worn?.armor)
				continue
			var/rating = worn.armor.getRating(armor_rating)
			if(rating < lowest_rating)
				lowest_rating = rating
				lowest_zone = part.body_zone
		chosen = lowest_zone

	if(!chosen)
		return

	// Skill scales how long the targeting solution stays valid
	//longer weapons can maintain solutions longer
	// since the fighter isn't scrambling to stay close
	var/cache_duration = HUMAN_NPC_WEAKPOINT_CACHE_DURATION
	switch(skill_level)
		if(SKILL_LEVEL_NONE)
			cache_duration *= 0.1
		if(SKILL_LEVEL_NOVICE)
			cache_duration *= 0.5
		if(SKILL_LEVEL_APPRENTICE)
			cache_duration *= 0.75
		if(SKILL_LEVEL_JOURNEYMAN)
			cache_duration *= 1.0
		if(SKILL_LEVEL_EXPERT)
			cache_duration *= 1.5
		if(SKILL_LEVEL_MASTER)
			cache_duration *= 2.0
		if(SKILL_LEVEL_LEGENDARY)
			cache_duration *= 3.0

	// Reach bonus: each point of reach beyond 1 adds 10% duration
	// rationale: you're not fighting in a scramble, you have space to think
	cache_duration *= (1 + ((intent_reach - 1) * 0.1))

	controller.set_blackboard_key(BB_HUMAN_NPC_WEAKPOINT, list(
		chosen,
		world.time + cache_duration,
		target,
	))

/// Zone string -> aimheight int.
/datum/ai_behavior/basic_melee_attack/human_npc/proc/_zone_to_aimheight(zone)
	switch(zone)
		if(BODY_ZONE_HEAD)
			return rand(12, 19)
		if(BODY_ZONE_CHEST)
			return rand(9, 11)
		if(BODY_ZONE_R_ARM, BODY_ZONE_L_ARM)
			return rand(5, 8)
		if(BODY_ZONE_L_LEG, BODY_ZONE_R_LEG)
			return rand(1, 4)
	return null

/datum/ai_behavior/basic_melee_attack/human_npc/proc/_try_backstep(mob/living/carbon/human/pawn, atom/target)
	if(pawn.mind?.has_antag_datum(/datum/antagonist/zombie))
		return FALSE
	if(pawn.body_position == LYING_DOWN)
		return FALSE
	if(pawn.ai_controller.blackboard[BB_HUMAN_NPC_HARASS_MODE])
		return FALSE
	if(!target || !isturf(pawn.loc) || !isturf(target.loc))
		return FALSE

	if(world.time < pawn.ai_controller.blackboard[BB_HUMAN_NPC_JUKE_COOLDOWN])
		return FALSE

	var/juke_chance = HUMAN_NPC_BASE_JUKE_CHANCE
	if(GET_MOB_ATTRIBUTE_VALUE(pawn, STAT_SPEED) > HUMAN_NPC_JUKE_MIN_SPD)
		juke_chance += (GET_MOB_ATTRIBUTE_VALUE(pawn, STAT_SPEED) - HUMAN_NPC_JUKE_MIN_SPD) * HUMAN_NPC_JUKE_PER_OVERSPD

	if(!prob(juke_chance))
		return FALSE

	pawn.tempfixeye = TRUE
	pawn.atom_flags |= NO_DIR_CHANGE_ON_MOVE
	var/was_fixedeye = pawn.fixedeye
	if(!was_fixedeye)
		pawn.fixedeye = TRUE

	var/list/candidates = pawn.get_dodge_destinations(target, null)
	if(!length(candidates))
		pawn.tempfixeye = FALSE
		if(!was_fixedeye)
			pawn.fixedeye = FALSE
		return FALSE

	var/turf/juke_turf = pick(candidates)
	pawn.Move(juke_turf, get_dir(pawn, juke_turf), pawn.cached_multiplicative_slowdown)
	pawn.atom_flags &= ~NO_DIR_CHANGE_ON_MOVE
	pawn.face_atom(target)

	pawn.ai_controller.set_blackboard_key(BB_HUMAN_NPC_JUKE_COOLDOWN, world.time + 1.5 SECONDS)
	pawn.tempfixeye = FALSE
	if(!was_fixedeye)
		pawn.fixedeye = FALSE
	return TRUE

/mob/living/proc/get_dodge_destinations(mob/living/attacker, atom/origin = src)
	var/dodge_dir = get_dir(attacker, origin)
	if(!dodge_dir)
		return null
	var/list/dirry = list(turn(dodge_dir, -90), dodge_dir, turn(dodge_dir, 90))
	var/list/turf/dodge_candidates = list()
	for(var/dir_to_check in dirry)
		var/turf/dodge_candidate = get_step(origin, dir_to_check)
		if(!dodge_candidate)
			continue
		if(dodge_candidate.density)
			continue
		var/has_impassable_atom = FALSE
		for(var/atom/movable/AM in dodge_candidate)
			if(!AM.CanPass(src, dodge_candidate))
				has_impassable_atom = TRUE
				break
		if(has_impassable_atom)
			continue
		dodge_candidates += dodge_candidate
	return dodge_candidates

/mob/living/carbon/human/proc/deadite_get_aimheight(victim)
	if(!(mobility_flags & MOBILITY_STAND))
		return rand(1, 2) // Bite their ankles!
	return pick(rand(11, 13), rand(14, 17), rand(5, 8)) // Chest, neck, and mouth; face and ears; arms and hands.

///I couldn't find anything that does this
/proc/bclass_to_armor_rating(bclass)
	switch(bclass)
		if(BCLASS_BLUNT, BCLASS_SMASH, BCLASS_PUNCH, BCLASS_LASHING)
			return "blunt"
		if(BCLASS_CUT, BCLASS_CHOP)
			return "slash"
		if(BCLASS_STAB, BCLASS_DRILL, BCLASS_PICK, BCLASS_TWIST, BCLASS_BITE)
			return "stab"
		if(BCLASS_PIERCE, BCLASS_SHOT)
			return "piercing"
		if(BCLASS_BURN)
			return "fire"
	return "blunt" // safest fallback - everything has some blunt resistance defined

#undef HUMAN_NPC_BASE_JUKE_CHANCE
#undef HUMAN_NPC_JUKE_MIN_SPD
#undef HUMAN_NPC_JUKE_PER_OVERSPD
#undef HUMAN_NPC_WEAKPOINT_SCAN_CHANCE
#undef HUMAN_NPC_WEAKPOINT_CACHE_DURATION
#undef HUMAN_NPC_WEAPON_SPECIAL_CHANCE
#undef HUMAN_NPC_INTENT_SWITCH_CHANCE
#undef HUMAN_NPC_RMB_ATTEMPT_CHANCE
