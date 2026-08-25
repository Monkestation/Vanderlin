/datum/ai_planning_subtree/fiend_abilities

/datum/ai_planning_subtree/fiend_abilities/SelectBehaviors(datum/ai_controller/controller, seconds_per_tick)
	. = ..()

	var/atom/target = controller.blackboard[BB_BASIC_MOB_CURRENT_TARGET]
	var/mob/living/simple_animal/mob = controller.pawn
	if(QDELETED(target))
		return
	var/health = mob.health / mob.maxHealth

	// Check flame ability cooldown
	var/flame_cd = controller.blackboard[BB_FIEND_FLAME_CD]
	if(world.time >= flame_cd && health < 0.7)
		controller.queue_behavior(/datum/ai_behavior/fiend_meteor_attack, BB_BASIC_MOB_CURRENT_TARGET)

	// Check summon ability cooldown
	var/summon_cd = controller.blackboard[BB_FIEND_SUMMON_CD]
	var/minion_count = controller.blackboard[BB_MINION_COUNT]
	var/max_minions = controller.blackboard[BB_MAX_MINIONS]

	if(world.time >= summon_cd && (minion_count < max_minions) && health < 0.4)
		controller.queue_behavior(/datum/ai_behavior/fiend_summon_reinforcements)

/datum/ai_behavior/fiend_meteor_attack

/datum/ai_behavior/fiend_meteor_attack/perform(seconds_per_tick, datum/ai_controller/controller, target_key)
	. = ..()

	var/mob/living/simple_animal/fiend = controller.pawn
	var/atom/target = controller.blackboard[target_key]

	if(QDELETED(target) || !isturf(target.loc) || fiend.stat == DEAD)
		finish_action(controller, FALSE)
		return

	fiend.visible_message(span_danger("<b>[fiend]</b> throws fire at [target]!"))
	create_meteors(fiend, target)
	controller.set_blackboard_key(BB_FIEND_FLAME_CD, world.time + 25 SECONDS)
	finish_action(controller, TRUE)

/datum/ai_behavior/fiend_meteor_attack/proc/create_meteors(mob/living/caster, atom/target)
	if(!target)
		return

	target.visible_message(span_boldwarning("Fire rains from the sky!"))
	var/turf/targetturf = get_turf(target)

	for(var/turf/turf as anything in RANGE_TURFS(4, targetturf))
		if(prob(20))
			new /obj/effect/temp_visual/target(turf)

/datum/ai_behavior/fiend_summon_reinforcements

/datum/ai_behavior/fiend_summon_reinforcements/perform(seconds_per_tick, datum/ai_controller/controller)
	. = ..()

	var/mob/living/simple_animal/fiend = controller.pawn
	if(fiend.stat == DEAD)
		finish_action(controller, FALSE)
		return

	var/minion_count = controller.blackboard[BB_MINION_COUNT]
	var/max_minions = controller.blackboard[BB_MAX_MINIONS]
	var/can_summon = max_minions - minion_count

	if(can_summon <= 0)
		finish_action(controller, FALSE)
		return

	fiend.visible_message(span_notice("[fiend] summons reinforcements from the infernal abyss."))

	var/list/spawnLists = list(
		/mob/living/simple_animal/hostile/retaliate/infernal/imp,
		/mob/living/simple_animal/hostile/retaliate/infernal/imp,
		/mob/living/simple_animal/hostile/retaliate/infernal/hellhound,
		/mob/living/simple_animal/hostile/retaliate/infernal/hellhound
	)

	var/reinforcement_count = min(3, can_summon)
	var/datum/component/minion_tracker/tracker = fiend.GetComponent(/datum/component/minion_tracker)

	while(reinforcement_count > 0)
		var/list/turflist = list()
		for(var/turf/t in RANGE_TURFS(1, fiend))
			turflist += t

		var/turf/picked = pick(turflist)
		var/spawnType = pick_n_take(spawnLists)
		var/mob/living/minion = new spawnType(picked)

		// Register the minion with the tracker
		if(tracker)
			tracker.register_minion(minion)

		// Update minion count
		controller.set_blackboard_key(BB_MINION_COUNT, minion_count + 1)
		minion_count++
		reinforcement_count--

	controller.set_blackboard_key(BB_FIEND_SUMMON_CD, world.time + 25 SECONDS)
	finish_action(controller, TRUE)
