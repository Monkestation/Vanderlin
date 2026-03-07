/datum/ai_planning_subtree/generic_break_restraints/SelectBehaviors(datum/ai_controller/controller, seconds_per_tick)
	var/mob/living/carbon/living_pawn = controller.pawn
	if(!isliving(living_pawn))
		return

	if(!living_pawn.handcuffed && !living_pawn.legcuffed)
		return

	if(SPT_PROB(50, seconds_per_tick))
		controller.queue_behavior(/datum/ai_behavior/break_restraints)
		return SUBTREE_RETURN_FINISH_PLANNING

/datum/ai_behavior/break_restraints
	behavior_flags = AI_BEHAVIOR_CAN_PLAN_DURING_EXECUTION
	action_cooldown = 45 SECONDS

/datum/ai_behavior/break_restraints/perform(seconds_per_tick, datum/ai_controller/controller)
	. = ..()
	var/mob/living/carbon/living_pawn = controller.pawn
	if(!living_pawn.handcuffed && !living_pawn.legcuffed)
		finish_action(controller, FALSE)
		return

	if(living_pawn.handcuffed)
		living_pawn.cuff_resist(living_pawn.handcuffed, instant = TRUE)
	else if(living_pawn.legcuffed)
		living_pawn.cuff_resist(living_pawn.legcuffed, instant = TRUE)

	finish_action(controller, TRUE)
