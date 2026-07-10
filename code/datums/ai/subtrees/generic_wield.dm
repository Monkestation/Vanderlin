/datum/ai_planning_subtree/generic_wield/SelectBehaviors(datum/ai_controller/controller, seconds_per_tick)
	var/mob/living/living_pawn = controller.pawn
	var/obj/item/active = living_pawn.get_active_held_item()
	var/obj/item/inactive = living_pawn.get_inactive_held_item()
	if(active && inactive)
		return
	var/obj/item/unwielded_twohander = null
	if(active?.GetComponent(/datum/component/two_handed) && !HAS_TRAIT(active, TRAIT_WIELDED))
		unwielded_twohander = active
	else if(inactive?.GetComponent(/datum/component/two_handed) && !HAS_TRAIT(inactive, TRAIT_WIELDED))
		unwielded_twohander = inactive
	if(unwielded_twohander)
		controller.queue_behavior(/datum/ai_behavior/wield_weapon)
		return SUBTREE_RETURN_FINISH_PLANNING

/datum/ai_behavior/wield_weapon/perform(seconds_per_tick, datum/ai_controller/controller)
	var/mob/living/living_pawn = controller.pawn
	var/obj/item/active = living_pawn.get_active_held_item()
	var/obj/item/inactive = living_pawn.get_inactive_held_item()
	var/obj/item/to_wield = null
	if(active?.GetComponent(/datum/component/two_handed)&& !HAS_TRAIT(active, TRAIT_WIELDED))
		to_wield = active
	else if(inactive?.GetComponent(/datum/component/two_handed) && !HAS_TRAIT(inactive, TRAIT_WIELDED))
		to_wield = inactive
	if(to_wield)
		var/datum/component/two_handed/twohanded = to_wield.GetComponent(/datum/component/two_handed)
		twohanded.wield(living_pawn)
	finish_action(controller, TRUE)
