/datum/ai_planning_subtree/dragger_hunting
	var/hunting_cooldown = 15 SECONDS

/datum/ai_planning_subtree/dragger_hunting/SelectBehaviors(datum/ai_controller/controller, delta_time)
	. = ..()

	var/hunt_cooldown = controller.blackboard[BB_DRAGGER_HUNTING_COOLDOWN]
	if(hunt_cooldown > world.time)
		return

	controller.queue_behavior(/datum/ai_behavior/find_hunt_target)

	var/mob/living/victim = controller.blackboard[BB_DRAGGER_VICTIM]
	if(QDELETED(victim))
		return

	controller.queue_behavior(/datum/ai_behavior/find_darkness)

	var/turf/darkness_target = controller.blackboard[BB_DRAGGER_DARKNESS_TARGET]
	if(!QDELETED(darkness_target))
		controller.queue_behavior(/datum/ai_behavior/teleport_to_darkness)

/datum/ai_behavior/find_hunt_target
	action_cooldown = 5 SECONDS
	behavior_flags = AI_BEHAVIOR_CAN_PLAN_DURING_EXECUTION

/datum/ai_behavior/find_hunt_target/perform(delta_time, datum/ai_controller/controller)
	. = ..()

	var/mob/living/simple_animal/hostile/dragger/dragger_pawn = controller.pawn
	if(!dragger_pawn || dragger_pawn.stat != CONSCIOUS)
		finish_action(controller, FALSE)
		return

	var/list/potential_victims = list()
	for(var/mob/living/carbon/human/H in GLOB.player_list)
		if(SSmapping.level_has_any_trait(H.z, list(ZTRAIT_IGNORE_WEATHER_TRAIT)))
			continue
		if(H.stat == CONSCIOUS && !H.is_blind())
			potential_victims += H

	if(!length(potential_victims))
		controller.blackboard[BB_DRAGGER_HUNTING_COOLDOWN] = world.time + 30 SECONDS
		finish_action(controller, FALSE)
		return

	var/mob/living/carbon/human/chosen_victim = pick(potential_victims)
	controller.blackboard[BB_DRAGGER_VICTIM] = chosen_victim
	finish_action(controller, TRUE)

/datum/ai_behavior/find_darkness
	action_cooldown = 2 SECONDS

/datum/ai_behavior/find_darkness/perform(delta_time, datum/ai_controller/controller)
	. = ..()

	var/mob/living/simple_animal/hostile/dragger/dragger_pawn = controller.pawn
	if(!dragger_pawn || dragger_pawn.stat != CONSCIOUS)
		finish_action(controller, FALSE)
		return

	var/mob/living/victim = controller.blackboard[BB_DRAGGER_VICTIM]
	if(QDELETED(victim))
		finish_action(controller, FALSE)
		return

	var/darkness_threshold = controller.blackboard[BB_DARKNESS_THRESHOLD]
	var/list/dark_turfs = list()

	for(var/turf/T in view(7, victim))
		if(T.get_lumcount() <= darkness_threshold / 10 && !T.density)
			// Check if the turf is not visible to the victim (around a corner)
			dark_turfs += T

	if(!length(dark_turfs))
		for(var/turf/T in view(5, victim))
			if(T.get_lumcount() <= (darkness_threshold + 1) / 10 && !T.density)
				dark_turfs += T

	// Still no dark areas
	if(!length(dark_turfs))
		controller.blackboard[BB_DRAGGER_HUNTING_COOLDOWN] = world.time + 10 SECONDS
		finish_action(controller, FALSE)
		return

	var/turf/chosen_turf = pick(dark_turfs)
	controller.blackboard[BB_DRAGGER_DARKNESS_TARGET] = chosen_turf
	finish_action(controller, TRUE)

/datum/ai_behavior/teleport_to_darkness
	action_cooldown = 3 SECONDS

/datum/ai_behavior/teleport_to_darkness/perform(delta_time, datum/ai_controller/controller)
	. = ..()

	var/mob/living/simple_animal/hostile/dragger/dragger_pawn = controller.pawn
	if(!dragger_pawn || dragger_pawn.stat != CONSCIOUS)
		finish_action(controller, FALSE)
		return

	var/turf/darkness_target = controller.blackboard[BB_DRAGGER_DARKNESS_TARGET]
	if(QDELETED(darkness_target))
		finish_action(controller, FALSE)
		return

	var/teleport_cooldown = controller.blackboard[BB_DRAGGER_TELEPORT_COOLDOWN]
	if(teleport_cooldown > world.time)
		finish_action(controller, FALSE)
		return

	new /obj/effect/temp_visual/dir_setting/wraith_phase_out(get_turf(dragger_pawn), dragger_pawn.dir)
	playsound(dragger_pawn, 'sound/magic/ethereal_exit.ogg', 50, TRUE)

	dragger_pawn.forceMove(darkness_target)

	new /obj/effect/temp_visual/dir_setting/wraith_phase_in(get_turf(dragger_pawn), dragger_pawn.dir)
	playsound(dragger_pawn, 'sound/magic/ethereal_enter.ogg', 50, TRUE)

	controller.blackboard[BB_DRAGGER_TELEPORT_COOLDOWN] = world.time + 10 SECONDS
	finish_action(controller, TRUE)
