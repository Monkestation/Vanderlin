/// When no target and wounds, slowly cure bleeding and damage.
/datum/ai_planning_subtree/simple_self_recovery
	var/datum/ai_behavior/behavior = /datum/ai_behavior/simple_rest_and_recuperate
	var/heal_message = "'s wounds begin to knit and mend."
	var/bleed_clot = 0.02 	// 2% of mob's max hp bleed clotted every perform
	var/brute_heal = 0.10  // 10% of mob's max hp healed every perform

/datum/ai_planning_subtree/simple_self_recovery/SelectBehaviors(datum/ai_controller/controller, delta_time)
	. = ..()
	var/mob/living/pawn = controller.pawn
	var/turf/cur_turf = get_turf(pawn)

	if(QDELETED(pawn))
		return

	//Already doing something or don't need healing
	//And not in some enviro that will tick damage
	if((pawn.doing()) || (pawn.get_bleed_rate() == 0) || (pawn.getBruteLoss() == 0) || (!cur_turf.can_traverse_safely(pawn)))
		return
	controller.queue_behavior(behavior, heal_message, bleed_clot, brute_heal)

	return SUBTREE_RETURN_FINISH_PLANNING //we are going to heal...no distractions.

/datum/ai_planning_subtree/simple_self_recovery/dragon
	heal_message = " licks their wounds."

/datum/ai_planning_subtree/simple_self_recovery/humanoid
	heal_message = " tends to their wounds."
