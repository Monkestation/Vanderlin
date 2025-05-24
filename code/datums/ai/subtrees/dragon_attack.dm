#define DRAGON_ATTACK_SUNDERING_LIGHTNING 1
#define DRAGON_ATTACK_SLAM 2
#define DRAGON_ATTACK_SUMMON_OBELISK 3
#define DRAGON_ATTACK_LAVA_SWOOP 4
#define DRAGON_ATTACK_LIGHTNING_BREATH 5

#define DRAGON_ATTACK_VOID_PULL 6
#define DRAGON_ATTACK_SHADOW_CLONE 7
#define DRAGON_ATTACK_WING_GUST 8
#define DRAGON_ATTACK_VOID_EXPLOSION 9
#define DRAGON_ATTACK_PHASE_SHIFT 10


/datum/ai_planning_subtree/dragon_attack_subtree
	var/datum/ai_behavior/dragon_attack/attack_behavior = /datum/ai_behavior/dragon_attack

/datum/ai_planning_subtree/dragon_attack_subtree/SelectBehaviors(datum/ai_controller/controller, delta_time)
	. = ..()

	if(world.time < controller.blackboard[BB_DRAGON_SPECIAL_COOLDOWN])
		return
	// Don't attack if swooping
	if(controller.blackboard[BB_DRAGON_SWOOPING])
		return

	var/atom/target = controller.blackboard[BB_BASIC_MOB_CURRENT_TARGET]
	if(QDELETED(target))
		return

	var/health_percentage = controller.blackboard[BB_DRAGON_HEALTH_PERCENTAGE]
	var/enraged = controller.blackboard[BB_DRAGON_ENRAGED]
	var/recovery_time = controller.blackboard[BB_DRAGON_RECOVERY_TIME]

	if(world.time < recovery_time)
		return

	// Choose attack type based on health and conditions
	var/attack_type = choose_attack(controller, health_percentage, enraged)
	controller.blackboard[BB_DRAGON_ATTACK_TYPE] = attack_type

	controller.queue_behavior(attack_behavior, BB_BASIC_MOB_CURRENT_TARGET, BB_DRAGON_ATTACK_TYPE)

	return SUBTREE_RETURN_FINISH_PLANNING

/datum/ai_planning_subtree/dragon_attack_subtree/proc/choose_attack(datum/ai_controller/controller, health_percentage, enraged)
	var/mob/living/simple_animal/hostile/retaliate/voiddragon/dragon = controller.pawn
	var/atom/target = controller.blackboard[BB_BASIC_MOB_CURRENT_TARGET]
	var/list/possible_attacks = list()
	var/list/priority_attacks = list()

	// Get distance to target for range-based decision making
	var/distance_to_target = get_dist(dragon, target)

	// Track if target is in melee range
	var/target_in_melee = distance_to_target <= 1

	// Always available attacks (if not on cooldown)
	if(world.time >= controller.blackboard[BB_DRAGON_LIGHTNING_COOLDOWN])
		possible_attacks += DRAGON_ATTACK_SUNDERING_LIGHTNING

	if(world.time >= controller.blackboard[BB_DRAGON_CL_COOLDOWN])
		possible_attacks += DRAGON_ATTACK_LIGHTNING_BREATH

	possible_attacks += DRAGON_ATTACK_SLAM

	// Phase 1 attacks (75% health and below)
	if(health_percentage <= 0.75)
		if(world.time >= controller.blackboard[BB_DRAGON_SUMMON_COOLDOWN])
			possible_attacks += DRAGON_ATTACK_SUMMON_OBELISK

		possible_attacks += DRAGON_ATTACK_LAVA_SWOOP
		// Prioritize swoop when target is far away
		if(distance_to_target > 5)
			priority_attacks += DRAGON_ATTACK_LAVA_SWOOP

	// Phase 2 attacks (50% health and below)
	if(health_percentage <= 0.9 && world.time >= controller.blackboard[BB_DRAGON_WING_COOLDOWN])
		possible_attacks += DRAGON_ATTACK_WING_GUST
		// Prioritize wing gust when surrounded or target is in melee range
		if(target_in_melee)
			priority_attacks += DRAGON_ATTACK_WING_GUST

	if(health_percentage <= 0.6 && world.time >= controller.blackboard[BB_DRAGON_VOID_COOLDOWN])
		possible_attacks += DRAGON_ATTACK_VOID_PULL
		// Prioritize void pull when target is at medium range
		if(distance_to_target >= 3)
			priority_attacks += DRAGON_ATTACK_VOID_PULL

	// Phase 3 attacks (50% health and below)
	if(health_percentage <= 0.5 && world.time >= controller.blackboard[BB_DRAGON_CLONE_COOLDOWN])
		possible_attacks += DRAGON_ATTACK_SHADOW_CLONE
		// Prioritize shadow clone when health is low for distraction
		if(health_percentage <= 0.35)
			priority_attacks += DRAGON_ATTACK_SHADOW_CLONE

	// Phase 4 attacks (30% health and below)
	if(health_percentage <= 0.3 && world.time >= controller.blackboard[BB_DRAGON_EXPLOSION_COOLDOWN])
		possible_attacks += DRAGON_ATTACK_VOID_EXPLOSION
		// Always prioritize void explosion when available at low health
		priority_attacks += DRAGON_ATTACK_VOID_EXPLOSION

	// Final phase attack (25% health and below)
	if(health_percentage <= 0.25 && world.time >= controller.blackboard[BB_DRAGON_PHASE_COOLDOWN])
		possible_attacks += DRAGON_ATTACK_PHASE_SHIFT
		// Always prioritize phase shift when available
		priority_attacks += DRAGON_ATTACK_PHASE_SHIFT

	// If no attacks are available, default to slam
	if(!length(possible_attacks))
		return DRAGON_ATTACK_SLAM

	// Enrage mode handling - more aggressive decision making
	if(enraged)
		// Add high-damage attacks to priority when enraged
		if(DRAGON_ATTACK_LIGHTNING_BREATH in possible_attacks)
			priority_attacks += DRAGON_ATTACK_LIGHTNING_BREATH
		if(DRAGON_ATTACK_VOID_EXPLOSION in possible_attacks)
			priority_attacks += DRAGON_ATTACK_VOID_EXPLOSION
		if(DRAGON_ATTACK_PHASE_SHIFT in possible_attacks)
			priority_attacks += DRAGON_ATTACK_PHASE_SHIFT

		// When enraged, if low health, prioritize defensive abilities
		if(health_percentage <= 0.3)
			if((DRAGON_ATTACK_WING_GUST in possible_attacks) && target_in_melee)
				priority_attacks += DRAGON_ATTACK_WING_GUST
			if(DRAGON_ATTACK_SHADOW_CLONE in possible_attacks)
				priority_attacks += DRAGON_ATTACK_SHADOW_CLONE

		// When enraged, if at range, prioritize gap closers
		if(distance_to_target > 3)
			if(DRAGON_ATTACK_LAVA_SWOOP in possible_attacks)
				priority_attacks += DRAGON_ATTACK_LAVA_SWOOP
			if(DRAGON_ATTACK_VOID_PULL in possible_attacks)
				priority_attacks += DRAGON_ATTACK_VOID_PULL

	// Make the final attack selection
	var/attack_choice

	// If we have priority attacks available, use those with high probability
	if(length(priority_attacks))
		if(prob(75)) // 75% chance to use a priority attack when available
			attack_choice = pick(priority_attacks)
		else // 25% chance to use any possible attack for variety
			attack_choice = pick(possible_attacks)
	else
		attack_choice = pick(possible_attacks)

	return attack_choice

/datum/ai_behavior/dragon_attack
	action_cooldown = 2 SECONDS
	behavior_flags = AI_BEHAVIOR_REQUIRE_MOVEMENT | AI_BEHAVIOR_MOVE_AND_PERFORM

/datum/ai_behavior/dragon_attack/setup(datum/ai_controller/controller, target_key, attack_type_key)
	. = ..()
	var/atom/target = controller.blackboard[target_key]
	if(QDELETED(target))
		return FALSE

	set_movement_target(controller, target)

/datum/ai_behavior/dragon_attack/perform(delta_time, datum/ai_controller/controller, target_key, attack_type_key)
	. = ..()
	var/mob/living/simple_animal/hostile/retaliate/voiddragon/dragon = controller.pawn
	var/atom/target = controller.blackboard[target_key]
	var/attack_type = controller.blackboard[attack_type_key]

	if(QDELETED(target))
		finish_action(controller, FALSE)
		return

	// Perform the chosen attack
	switch(attack_type)
		if(DRAGON_ATTACK_SUNDERING_LIGHTNING)
			dragon.create_lightning(target)
			controller.set_blackboard_key(BB_DRAGON_LIGHTNING_COOLDOWN, world.time + 25 SECONDS)

		if(DRAGON_ATTACK_SLAM)
			dragon.dragon_slam(dragon, 2, 10, 8)
			controller.set_blackboard_key(BB_DRAGON_SLAM_COOLDOWN, world.time + 15 SECONDS)

		if(DRAGON_ATTACK_SUMMON_OBELISK)
			dragon.summon_obelisk()
			controller.set_blackboard_key(BB_DRAGON_SUMMON_COOLDOWN, world.time + 200 SECONDS)

		if(DRAGON_ATTACK_LAVA_SWOOP)
			dragon.lava_swoop()

		if(DRAGON_ATTACK_LIGHTNING_BREATH)
			dragon.visible_message(span_colossus("[dragon] opens his maw, and lightning crackles beyond it's teeth."))
			dragon.chain_lightning(target, dragon)
			controller.set_blackboard_key(BB_DRAGON_CL_COOLDOWN, world.time + 50 SECONDS)

		// New attacks
		if(DRAGON_ATTACK_VOID_PULL)
			dragon.visible_message(span_colossus("[dragon] spreads its wings and creates a swirling vortex of void energy!"))
			dragon.void_pull(target)
			controller.set_blackboard_key(BB_DRAGON_VOID_COOLDOWN, world.time + 45 SECONDS)

		if(DRAGON_ATTACK_SHADOW_CLONE)
			dragon.visible_message(span_colossus("[dragon] melts into the shadows and creates shadowy duplicates!"))
			dragon.create_shadow_clones()
			controller.set_blackboard_key(BB_DRAGON_CLONE_COOLDOWN, world.time + 60 SECONDS)

		if(DRAGON_ATTACK_WING_GUST)
			dragon.visible_message(span_colossus("[dragon] beats its massive wings, creating a powerful gust!"))
			dragon.wing_gust()
			controller.set_blackboard_key(BB_DRAGON_WING_COOLDOWN, world.time + 20 SECONDS)

		if(DRAGON_ATTACK_VOID_EXPLOSION)
			dragon.visible_message(span_colossus("[dragon] channels void energy into an unstable sphere!"))
			dragon.void_explosion(target)
			controller.set_blackboard_key(BB_DRAGON_EXPLOSION_COOLDOWN, world.time + 70 SECONDS)

		if(DRAGON_ATTACK_PHASE_SHIFT)
			dragon.visible_message(span_colossus("[dragon]'s form shimmers as it phases between realities!"))
			dragon.phase_shift()
			controller.set_blackboard_key(BB_DRAGON_PHASE_COOLDOWN, world.time + 90 SECONDS)

	controller.set_blackboard_key(BB_DRAGON_SPECIAL_COOLDOWN, world.time + 5 SECONDS)
	finish_action(controller, TRUE)
