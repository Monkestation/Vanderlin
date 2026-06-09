/// Use the currently held item, or unarmed, on an object in the world
/datum/ai_behavior/use_on_object
	required_distance = 1
	behavior_flags = AI_BEHAVIOR_REQUIRE_MOVEMENT | AI_BEHAVIOR_REQUIRE_REACH

/datum/ai_behavior/use_on_object/perform(seconds_per_tick, datum/ai_controller/controller)
	. = ..()
	var/mob/living/pawn = controller.pawn
	var/obj/item/held_item =  pawn.get_active_held_item()
	var/atom/target = controller.current_movement_target
	if(!target || !pawn.CanReach(target))
		finish_action(controller, FALSE)
		return

	if(held_item)
		held_item.melee_attack_chain(pawn, target)
	else
		pawn.UnarmedAttack(target, TRUE)
	finish_action(controller, TRUE)
