/datum/ai_planning_subtree/fishboss_special_ability
	var/datum/ai_behavior/fishboss_tidal_wave/tidal_behavior = /datum/ai_behavior/fishboss_tidal_wave
	var/datum/ai_behavior/fishboss_whirlpool/whirlpool_behavior = /datum/ai_behavior/fishboss_whirlpool
	var/datum/ai_behavior/fishboss_deep_call/deep_call_behavior = /datum/ai_behavior/fishboss_deep_call
	var/datum/ai_behavior/fishboss_coral_wall/coral_behavior = /datum/ai_behavior/fishboss_coral_wall

/datum/ai_planning_subtree/fishboss_special_ability/SelectBehaviors(datum/ai_controller/controller, seconds_per_tick)
	. = ..()
	var/phase = controller.blackboard[BB_RAGE_PHASE]
	var/atom/target = controller.blackboard[BB_BASIC_MOB_CURRENT_TARGET]

	if(QDELETED(target))
		return

	// Check which abilities are available based on phase and cooldowns
	var/can_tidal = (phase >= 1) && (controller.blackboard[BB_FISHBOSS_TIDAL_WAVE_COOLDOWN] < world.time)
	var/can_coral_wall = (phase >= 1) && (controller.blackboard[BB_FISHBOSS_SPECIAL_COOLDOWN] < world.time)
	var/can_whirlpool = (phase >= 2) && (controller.blackboard[BB_FISHBOSS_WHIRLPOOL_COOLDOWN] < world.time)
	var/can_deep_call = (phase >= 3) && (controller.blackboard[BB_FISHBOSS_DEEP_CALL_COOLDOWN] < world.time)

	// Randomly select an available ability with weighting toward higher level abilities
	var/list/possible_abilities = list()
	if(can_coral_wall)
		possible_abilities["coral"] = 30
	if(can_tidal)
		possible_abilities["tidal"] = 30
	if(can_whirlpool)
		possible_abilities["whirlpool"] = 40
	if(can_deep_call)
		possible_abilities["deep_call"] = 50

	if(length(possible_abilities) > 0)
		var/chosen_ability = pickweight(possible_abilities)
		switch(chosen_ability)
			if("tidal")
				controller.queue_behavior(tidal_behavior)
			if("whirlpool")
				controller.queue_behavior(whirlpool_behavior, BB_BASIC_MOB_CURRENT_TARGET)
			if("deep_call")
				controller.queue_behavior(deep_call_behavior)
			if("coral")
				controller.queue_behavior(coral_behavior)
