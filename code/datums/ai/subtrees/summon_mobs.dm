/datum/ai_planning_subtree/fishboss_summon_minions
	var/datum/ai_behavior/fishboss_summon_minions/summon_behavior = /datum/ai_behavior/fishboss_summon_minions

/datum/ai_planning_subtree/fishboss_summon_minions/SelectBehaviors(datum/ai_controller/controller, seconds_per_tick)
	. = ..()
	var/next_summon = controller.blackboard[BB_NEXT_SUMMON]
	// If it's time to summon again
	if(world.time >= next_summon)
		controller.queue_behavior(summon_behavior, BB_MINIONS_TO_SPAWN)
