/datum/wave_defense_coordinator
	/// Ordered list of waypoints (turfs or areas) to attack in sequence
	var/list/atom/wave_points = list()
	/// Current index in wave_points
	var/current_point_index = 1
	/// Mobs registered to this wave
	var/list/datum/ai_controller/participants = list()
	/// How long to occupy a point before advancing (deciseconds)
	var/occupy_duration = 3 MINUTES
	/// Timer/world.time tracking when we started occupying current point
	var/occupy_started_at = 0
	/// State: WAVE_ADVANCING, WAVE_OCCUPYING, WAVE_COMPLETE, WAVE_FAILED
	var/wave_state = WAVE_ADVANCING
	/// Callback(s) fired on success/failure
	var/datum/callback/on_complete
	var/datum/callback/on_failed

/datum/wave_defense_coordinator/New(set_id, list/mob/living/wave_mobs, occupy_duration = 10 SECONDS, datum/callback/on_complete, datum/callback/on_failed)
	src.occupy_duration = occupy_duration
	src.on_complete = on_complete
	src.on_failed = on_failed
	wave_points = get_wave_defense_points(set_id)

	for(var/mob/living/wave_mob as anything in wave_mobs)
		if(!wave_mob.ai_controller)
			stack_trace("wave_defense_coordinator: [wave_mob] has no ai_controller, skipping.")
			continue
		register_participant(wave_mob.ai_controller)
		wave_mob.ai_controller.change_ai_movement_type(/datum/ai_movement/hybrid_pathing/wave_defense)
		wave_mob.ai_controller.max_target_distance = 100
		wave_mob.ai_controller.blackboard[BB_TARGETTING_DATUM] = new /datum/targetting_datum/basic/allow_structures

/datum/wave_defense_coordinator/Destroy(force)
	for(var/datum/ai_controller/controller as anything in participants.Copy())
		unregister_participant(controller)
	on_complete = null
	on_failed = null
	return ..()

/datum/wave_defense_coordinator/proc/get_current_point()
	return wave_points[current_point_index]

/datum/wave_defense_coordinator/proc/register_participant(datum/ai_controller/controller)
	participants |= controller
	controller.set_blackboard_key(BB_WAVE_COORDINATOR, src)
	controller.add_subtree_at(/datum/ai_planning_subtree/wave_defense, 1)

	RegisterSignal(controller.pawn, COMSIG_LIVING_DEATH, PROC_REF(on_participant_removed))
	RegisterSignal(controller.pawn, COMSIG_QDELETING, PROC_REF(on_participant_removed))

/datum/wave_defense_coordinator/proc/unregister_participant(datum/ai_controller/controller)
	if(!(controller in participants))
		return
	participants -= controller

	if(controller.pawn)
		UnregisterSignal(controller.pawn, list(COMSIG_LIVING_DEATH, COMSIG_QDELETING))

	controller.clear_blackboard_key(BB_WAVE_COORDINATOR)
	controller.remove_subtree(/datum/ai_planning_subtree/wave_defense)

	if(wave_state == WAVE_COMPLETE || wave_state == WAVE_FAILED)
		return

	if(!length(participants))
		fail_wave()

/datum/wave_defense_coordinator/proc/on_participant_removed(mob/living/source)
	SIGNAL_HANDLER
	var/datum/ai_controller/controller = source.ai_controller
	if(!controller)
		// pawn already unhooked from controller (e.g. mid-qdel), find by pawn ref instead
		for(var/datum/ai_controller/participant as anything in participants)
			if(participant.pawn == source)
				controller = participant
				break
	if(controller)
		unregister_participant(controller)

/datum/wave_defense_coordinator/proc/fail_wave()
	if(wave_state == WAVE_COMPLETE || wave_state == WAVE_FAILED)
		return
	wave_state = WAVE_FAILED
	on_failed?.Invoke(src)

/datum/wave_defense_coordinator/proc/advance_point()
	if(current_point_index >= length(wave_points))
		wave_state = WAVE_COMPLETE
		on_complete?.Invoke(src)
		return FALSE
	current_point_index++
	wave_state = WAVE_ADVANCING
	return TRUE

/datum/wave_defense_coordinator/proc/check_occupy_progress()
	if(wave_state != WAVE_OCCUPYING)
		return
	if(world.time >= occupy_started_at + occupy_duration)
		advance_point()

/datum/wave_defense_coordinator/proc/begin_occupying()
	wave_state = WAVE_OCCUPYING
	occupy_started_at = world.time
	addtimer(CALLBACK(src, PROC_REF(occupy_timeout_check)), occupy_duration + 1 SECONDS)

/datum/wave_defense_coordinator/proc/occupy_timeout_check()
	if(wave_state == WAVE_OCCUPYING && world.time >= occupy_started_at + occupy_duration)
		advance_point()
