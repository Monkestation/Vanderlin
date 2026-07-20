/datum/ai_planning_subtree/tree_climb

/datum/ai_planning_subtree/tree_climb/SelectBehaviors(datum/ai_controller/controller, delta_time)
	. = ..()
	var/mob/living/carbon/human/pawn = controller.pawn
	var/atom/target = controller.blackboard[BB_BASIC_MOB_CURRENT_TARGET]
	if(!target)
		return
	var/turf/my_turf = get_turf(pawn)
	var/turf/their_turf = get_turf(target)
	// Target must be directly above us (z+1) on a transparent turf, cardinal distance 1
	if(!their_turf || my_turf.z >= their_turf.z)
		return
	if(my_turf.Distance3D(their_turf, pawn) != 1)
		return
	if(!istransparentturf(their_turf))
		return
	// There must be a branch on their turf to climb
	var/obj/structure/flora/newbranch/the_branch = locate() in their_turf
	if(!the_branch)
		return
	controller.queue_behavior(/datum/ai_behavior/human_npc_climb_tree, BB_BASIC_MOB_CURRENT_TARGET)
	return SUBTREE_RETURN_FINISH_PLANNING

/datum/ai_behavior/human_npc_climb_tree
	action_cooldown = 1 SECONDS
	behavior_flags = AI_BEHAVIOR_REQUIRE_MOVEMENT

/datum/ai_behavior/human_npc_climb_tree/perform(delta_time, datum/ai_controller/controller, target_key)
	var/mob/living/carbon/human/pawn = controller.pawn
	var/atom/target = controller.blackboard[target_key]
	if(!target)
		finish_action(controller, FALSE, target_key)
		return
	var/turf/their_turf = get_turf(target)
	var/turf/my_turf = get_turf(pawn)
	// Revalidate - target may have moved
	if(!their_turf || my_turf.z >= their_turf.z || !istransparentturf(their_turf))
		finish_action(controller, FALSE, target_key)
		return
	var/obj/structure/flora/newbranch/the_branch = locate() in their_turf
	if(!the_branch)
		finish_action(controller, FALSE, target_key)
		return
	// Find the tree from the branch (same logic as process_ai)
	var/obj/structure/flora/newtree/the_tree = locate() in get_step_multiz(the_branch, REVERSE_DIR(the_branch.dir)|DOWN)
	if(!the_tree)
		finish_action(controller, FALSE, target_key)
		return
	the_tree.attack_hand(pawn)
	finish_action(controller, TRUE, target_key)

