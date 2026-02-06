/datum/ai_planning_subtree/find_weapon
	var/vision_range = 9

/datum/ai_planning_subtree/find_weapon/SelectBehaviors(datum/ai_controller/controller, seconds_per_tick)
	. = ..()
	var/atom/target = controller.blackboard[BB_MOB_EQUIP_TARGET]
	if(!QDELETED(target))
		// Busy with something
		return

	var/mob/living/living_pawn = controller.pawn
	var/obj/item/held_item = living_pawn.get_active_held_item()

	var/need_item = (held_item == null)
	if(HAS_TRAIT(living_pawn, TRAIT_DUALWIELDER) || istype(held_item, /obj/item/weapon/shield))
		need_item |= (living_pawn.get_inactive_held_item() == null)
	if(!need_item && prob(95))
		return


	controller.queue_behavior(/datum/ai_behavior/find_and_set/better_weapon, BB_MOB_EQUIP_TARGET, null, vision_range)
