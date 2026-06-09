/datum/ai_planning_subtree/minotaur_targeting
/datum/ai_planning_subtree/minotaur_targeting/SelectBehaviors(datum/ai_controller/controller, seconds_per_tick)
	. = ..()
	var/mob/living/simple_animal/hostile/retaliate/minotaur/boss = controller.pawn

	if(!controller.blackboard[BB_BASIC_MOB_CURRENT_TARGET])
		controller.queue_behavior(/datum/ai_behavior/find_aggro_targets, BB_BASIC_MOB_CURRENT_TARGET, BB_TARGETTING_DATUM)
		return

	var/atom/target = controller.blackboard[BB_BASIC_MOB_CURRENT_TARGET]
	if(!QDELETED(target))
		var/current_rage = controller.blackboard[BB_MINOTAUR_RAGE_METER]
		var/rage_increase = seconds_per_tick * 2

		// More rage at lower health
		if(istype(boss))
			var/health_percent = boss.health / boss.maxHealth
			if(health_percent < 0.3)
				rage_increase *= 3 // Triple rage gain at low health
			else if(health_percent < 0.6)
				rage_increase *= 2 // Double rage gain at medium health

		controller.set_blackboard_key(BB_MINOTAUR_RAGE_METER, min(100, current_rage + rage_increase))
		if(istype(boss))
			if(boss.health < boss.maxHealth * 0.3 && controller.blackboard[BB_MINOTAUR_PHASE] < 3)
				controller.set_blackboard_key(BB_MINOTAUR_PHASE, 3)
				boss.visible_message("<span class='danger'>[boss] lets out an earthshaking roar as blood seeps from its wounds!</span>")
				boss.playsound_local(get_turf(boss), 'sound/misc/explode/explosionfar (1).ogg', 50, TRUE)
				new /obj/effect/temp_visual/minotaur_rage(get_turf(boss))
				controller.set_blackboard_key(BB_MINOTAUR_ENRAGE_BONUS, 15)
			else if(boss.health < boss.maxHealth * 0.6 && controller.blackboard[BB_MINOTAUR_PHASE] < 2)
				controller.set_blackboard_key(BB_MINOTAUR_PHASE, 2)
				boss.visible_message("<span class='warning'>[boss] stomps the ground in anger, its eyes burning with hatred!</span>")
				new /obj/effect/temp_visual/minotaur_rage(get_turf(boss))
				controller.set_blackboard_key(BB_MINOTAUR_ENRAGE_BONUS, 5)
