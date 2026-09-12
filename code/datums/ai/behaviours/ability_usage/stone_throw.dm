/datum/ai_planning_subtree/targeted_mob_ability/stone_throw
	use_ability_behaviour = /datum/ai_behavior/targeted_mob_ability/stone_throw

/datum/ai_behavior/targeted_mob_ability/stone_throw
	/// Don't bother lobbing rocks at something standing next to us
	var/min_range = 3
	var/max_range = 9

/datum/ai_behavior/targeted_mob_ability/stone_throw/perform(seconds_per_tick, datum/ai_controller/controller, ability_key, target_key)
	var/mob/living/target = controller.blackboard[target_key]
	if(QDELETED(target))
		finish_action(controller, succeeded = FALSE, ability_key = ability_key, target_key = target_key)
		return

	var/dist = get_dist(controller.pawn, target)
	if(dist < min_range || dist > max_range)
		finish_action(controller, succeeded = FALSE, ability_key = ability_key, target_key = target_key)
		return

	if(!can_see(controller.pawn, target, dist+1))
		finish_action(controller, succeeded = FALSE, ability_key = ability_key, target_key = target_key)
		return

	return ..()
