/datum/ai_planning_subtree/targeted_mob_ability/harpoon_pull
	use_ability_behaviour = /datum/ai_behavior/targeted_mob_ability/harpoon_pull

/datum/ai_behavior/targeted_mob_ability/harpoon_pull
	var/min_range = 2
	var/max_range = 7

/datum/ai_behavior/targeted_mob_ability/harpoon_pull/perform(seconds_per_tick, datum/ai_controller/controller, ability_key, target_key)
	var/mob/living/target = controller.blackboard[target_key]
	if(QDELETED(target))
		finish_action(controller, succeeded = FALSE, ability_key = ability_key, target_key = target_key)
		return
	var/dist = get_dist(controller.pawn, target)
	if(dist < min_range || dist > max_range)
		finish_action(controller, succeeded = FALSE, ability_key = ability_key, target_key = target_key)
		return
	return ..()
