/datum/ai_planning_subtree/minotaur_enrage
/datum/ai_planning_subtree/minotaur_enrage/SelectBehaviors(datum/ai_controller/controller, delta_time)
	. = ..()
	var/mob/living/simple_animal/hostile/retaliate/minotaur/boss = controller.pawn
	if(!istype(boss))
		return

	var/enrage_bonus = controller.blackboard[BB_MINOTAUR_ENRAGE_BONUS]
	var/current_rage = controller.blackboard[BB_MINOTAUR_RAGE_METER]
	var/current_phase = controller.blackboard[BB_MINOTAUR_PHASE]

	// Adjust damage and speed based on rage
	var/rage_factor = current_rage / 100
	var/phase_bonus = (current_phase - 1) * 5

	var/total_bonus = enrage_bonus + phase_bonus + (rage_factor * 10)

	if(istype(boss))
		boss.melee_damage_lower = initial(boss.melee_damage_lower) + total_bonus
		boss.melee_damage_upper = initial(boss.melee_damage_upper) + total_bonus

		// Apply speed bonus (lower number = faster)
		controller.movement_delay = max(4, initial(controller.movement_delay) - (total_bonus * 0.02))

		if(current_rage > 80)
			if(prob(15) && current_phase >= 2)
				new /obj/effect/temp_visual/minotaur_rage(get_turf(boss))
				playsound(boss, 'sound/misc/explode/explosionfar (1).ogg', 25, TRUE)
		else if(current_rage > 50)
			if(prob(8) && current_phase >= 2)
				new /obj/effect/temp_visual/minotaur_rage(get_turf(boss))

		if(current_phase == 3 && prob(5))
			boss.adjustHealth(-boss.maxHealth * 0.01) // Heal 1% max health
			new /obj/effect/temp_visual/heal(get_turf(boss), "#FF0000")

			if(current_rage > 90 && prob(15))
				boss.visible_message("<span class='danger'>The air around [boss] ripples with heat!</span>")
				for(var/turf/T in range(1, boss))
					if(prob(70))
						new /obj/effect/temp_visual/minotaur_fury_zone(T)
