/datum/ai_planning_subtree/defend_bonepile

/datum/ai_planning_subtree/defend_bonepile/SelectBehaviors(datum/ai_controller/controller, seconds_per_tick)
	. = ..()
	var/obj/structure/bonepile/source = controller.blackboard[BB_LEYLINE_SOURCE]

	if(QDELETED(source))
		return

	var/mob/living/simple_animal/hostile/haunt/lycan = controller.pawn

	// If we're too far from our leyline and don't have a target, head back to it
	if(get_dist(lycan, source) > 7 && !controller.blackboard[BB_BASIC_MOB_CURRENT_TARGET])
		controller.set_movement_target(source)
