/datum/ai_planning_subtree/generic_resist/SelectBehaviors(datum/ai_controller/controller, seconds_per_tick)
	var/mob/living/living_pawn = controller.pawn

	if(controller.blackboard[BB_RESISTING])
		controller.queue_behavior(/datum/ai_behavior/resist) //KEEP TRYING TO RESIST
		return SUBTREE_RETURN_FINISH_PLANNING //JUST KEEP DOING IT PLEASE
	if(SHOULD_RESIST(living_pawn) && SPT_PROB(75, seconds_per_tick))
		controller.queue_behavior(/datum/ai_behavior/resist) //BRO IM ON FUCKING FIRE BRO
		return SUBTREE_RETURN_FINISH_PLANNING //IM NOT DOING ANYTHING ELSE BUT EXTINGUISH MYSELF, GOOD GOD HAVE MERCY.
