/datum/ai_planning_subtree/targeted_mob_ability/ground_slam
	use_ability_behaviour = /datum/ai_behavior/targeted_mob_ability/ground_slam

/datum/ai_behavior/targeted_mob_ability/ground_slam
	var/max_target_distance = 5

/datum/ai_behavior/targeted_mob_ability/ground_slam/perform(seconds_per_tick, datum/ai_controller/controller, ability_key, target_key)
	var/mob/living/target = controller.blackboard[target_key]
	if(QDELETED(target) || get_dist(controller.pawn, target) > max_target_distance)
		finish_action(controller, succeeded = FALSE, ability_key = ability_key, target_key = target_key)
		return
	return ..()
