/datum/ai_planning_subtree/dragger_drag_victim

/datum/ai_planning_subtree/dragger_drag_victim/SelectBehaviors(datum/ai_controller/controller, delta_time)
	. = ..()

	var/mob/living/victim = controller.blackboard[BB_DRAGGER_VICTIM]
	if(QDELETED(victim))
		return

	var/drag_cooldown = controller.blackboard[BB_DRAGGER_DRAG_COOLDOWN]
	if(drag_cooldown > world.time)
		return

	controller.queue_behavior(/datum/ai_behavior/drag_victim)

/**
 * Behavior for dragging victims to the wilderness
 */
/datum/ai_behavior/drag_victim
	action_cooldown = 5 SECONDS
	required_distance = 1

/datum/ai_behavior/drag_victim/setup(datum/ai_controller/controller)
	. = ..()
	var/mob/living/victim = controller.blackboard[BB_DRAGGER_VICTIM]
	if(QDELETED(victim))
		return FALSE

	set_movement_target(controller, victim)

/datum/ai_behavior/drag_victim/perform(delta_time, datum/ai_controller/controller)
	. = ..()

	var/mob/living/simple_animal/hostile/dragger/dragger_pawn = controller.pawn
	if(!dragger_pawn || dragger_pawn.stat != CONSCIOUS)
		finish_action(controller, FALSE)
		return

	var/mob/living/victim = controller.blackboard[BB_DRAGGER_VICTIM]
	if(QDELETED(victim) || victim.stat == DEAD || !isliving(victim))
		finish_action(controller, FALSE)
		return

	if(!dragger_pawn.Adjacent(victim))
		finish_action(controller, FALSE)
		return

	controller.PauseAi(3 SECONDS)
	victim.Paralyze(4 SECONDS)
	victim.become_blind("dragger")
	if(!do_after(dragger_pawn, 3 SECONDS, victim))
		addtimer(CALLBACK(src, PROC_REF(unblind), victim), 1.5 SECONDS)
		finish_action(controller, FALSE)
		return

	if(iscarbon(victim))
		var/mob/living/carbon/carbon_victim = victim
		carbon_victim.blur_eyes(10)
		carbon_victim.confused += 5
		to_chat(carbon_victim, span_userdanger("The [dragger_pawn.name] grabs you and drags you into darkness!"))

		new /obj/effect/temp_visual/dir_setting/wraith_grab(get_turf(carbon_victim), dragger_pawn.dir)
		playsound(get_turf(carbon_victim), 'sound/magic/enter_blood.ogg', 50, TRUE)

		var/list/wilderness_turfs = list()
		if(!controller.blackboard[BB_DRAGGER_DUNGEONEER])
			for(var/turf/T in orange(100, dragger_pawn))
				if(istype(T, /turf/open/floor/dirt) || istype(T, /turf/open/floor/grass))
					if(!T.density && T.get_lumcount() <= 0.4)
						wilderness_turfs += T

			if(!length(wilderness_turfs))
				for(var/turf/T in orange(50, dragger_pawn))
					if(!T.density && T.get_lumcount() <= 0.3)
						wilderness_turfs += T

			if(!length(wilderness_turfs))
				for(var/turf/T in orange(15, dragger_pawn))
					if(!T.density)
						wilderness_turfs += T
		else
			var/mob/random_dungeon_mob = pick(SSmatthios_mobs.matthios_mobs)
			for(var/turf/T in orange(15, random_dungeon_mob))
				if(!T.density)
					wilderness_turfs += T

		// Do the teleport if we have a valid location
		if(length(wilderness_turfs))
			var/turf/destination = pick(wilderness_turfs)

			new /obj/effect/temp_visual/dir_setting/wraith_phase_out(get_turf(dragger_pawn), dragger_pawn.dir)
			playsound(get_turf(dragger_pawn), 'sound/magic/ethereal_exit.ogg', 50, TRUE)

			// Teleport both the dragger and victim
			dragger_pawn.forceMove(destination)
			carbon_victim.forceMove(destination)

			new /obj/effect/temp_visual/dir_setting/wraith_phase_in(get_turf(dragger_pawn), dragger_pawn.dir)
			playsound(get_turf(dragger_pawn), 'sound/magic/ethereal_enter.ogg', 50, TRUE)
			carbon_victim.apply_damage(15, BRUTE, spread_damage = TRUE)

			controller.blackboard[BB_DRAGGER_HUNTING_COOLDOWN] = world.time + 20 SECONDS

			dragger_pawn.emote("laugh")
		addtimer(CALLBACK(src, PROC_REF(unblind), carbon_victim), 1.5 SECONDS)

	controller.blackboard[BB_DRAGGER_VICTIM] = null
	controller.blackboard[BB_DRAGGER_DRAG_COOLDOWN] = world.time + 30 SECONDS
	finish_action(controller, TRUE)

/datum/ai_behavior/drag_victim/proc/unblind(mob/living/carbon/carbon)
	carbon.cure_blind("dragger")
