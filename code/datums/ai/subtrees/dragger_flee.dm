/datum/ai_planning_subtree/flee_target/dragger
	flee_behaviour = /datum/ai_behavior/run_away_from_target/dragger

/datum/ai_behavior/run_away_from_target/dragger/perform(delta_time, datum/ai_controller/controller, target_key, hiding_location_key)
	. = ..()

	var/mob/living/simple_animal/hostile/dragger/dragger_pawn = controller.pawn
	if(!dragger_pawn || dragger_pawn.stat != CONSCIOUS)
		finish_action(controller, FALSE)
		return

	if(dragger_pawn.health < dragger_pawn.maxHealth * 0.3)
		var/list/possible_turfs = list()
		for(var/turf/T in orange(10, dragger_pawn))
			if(!T.density && T.get_lumcount() <= 0.4)
				possible_turfs += T

		if(length(possible_turfs))
			var/turf/escape_turf = pick(possible_turfs)
			new /obj/effect/temp_visual/dir_setting/wraith_phase_out(get_turf(dragger_pawn), dragger_pawn.dir)
			playsound(dragger_pawn, 'sound/magic/ethereal_exit.ogg', 50, TRUE)
			dragger_pawn.forceMove(escape_turf)
			new /obj/effect/temp_visual/dir_setting/wraith_phase_in(get_turf(dragger_pawn), dragger_pawn.dir)
			playsound(dragger_pawn, 'sound/magic/ethereal_enter.ogg', 50, TRUE)
			controller.blackboard[BB_DRAGGER_HUNTING_COOLDOWN] = world.time + 30 SECONDS
