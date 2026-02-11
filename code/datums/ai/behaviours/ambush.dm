/datum/ai_behavior/gator_ambush
	behavior_flags = AI_BEHAVIOR_REQUIRE_MOVEMENT | AI_BEHAVIOR_MOVE_AND_PERFORM
	var/ambush_damage_bonus = 10 // Extra damage for ambush attacks

/datum/ai_behavior/gator_ambush/setup(datum/ai_controller/controller, target_key)
	. = ..()
	var/atom/target = controller.blackboard[target_key]
	if(QDELETED(target))
		return FALSE
	set_movement_target(controller, target)
	return TRUE

/datum/ai_behavior/gator_ambush/perform(delta_time, datum/ai_controller/controller, target_key)
	. = ..()
	var/mob/living/simple_animal/hostile/retaliate/gator/gator_pawn = controller.pawn
	var/atom/target = controller.blackboard[target_key]

	if(!istype(gator_pawn) || QDELETED(target))
		finish_action(controller, FALSE)
		return

	if(get_dist(gator_pawn, target) <= 1)
		gator_pawn.visible_message("<span class='danger'>[gator_pawn] lunges out of the water at [target]!</span>")

		if(isliving(target))
			var/mob/living/L = target
			var/damage = rand(gator_pawn.melee_damage_lower, gator_pawn.melee_damage_upper) + ambush_damage_bonus
			L.apply_damage(damage, BRUTE, "chest")
			playsound(gator_pawn, pick(gator_pawn.attack_sound), 50, TRUE)

		controller.set_blackboard_key(BB_GATOR_AMBUSH_COOLDOWN, world.time + 30 SECONDS)
		controller.set_blackboard_key(BB_GATOR_IN_WATER, FALSE)
		finish_action(controller, TRUE)
		return
