/datum/ai_behavior/find_and_set/better_weapon
	vision_range = 7

/datum/ai_behavior/find_and_set/better_weapon/atom_allowed(atom/movable/checking, locate_path, atom/pawn)
	if(checking == pawn)
		return FALSE
	var/mob/living/carbon/living_pawn = pawn
	var/datum/ai_controller/controller = living_pawn.ai_controller
	if(!istype(checking, controller.blackboard[BB_WEAPON_TYPE]))
		return FALSE
	var/obj/item/held_item = living_pawn.get_active_held_item()
	var/obj/item/dual_wield = living_pawn.get_inactive_held_item()
	var/obj/item/weapon/candidate = checking
	if(dual_wield)
		if(dual_wield.force >= candidate.force)
			if(istype(held_item, /obj/item/weapon/shield))
				return FALSE
		else if(HAS_TRAIT(living_pawn, TRAIT_DUALWIELDER))
			return TRUE
	if(held_item && held_item.force >= candidate.force)
		return FALSE
	return TRUE

/datum/ai_behavior/find_and_set/better_weapon/search_tactic(datum/ai_controller/controller, locate_path, search_range)
	var/mob/living/carbon/living_pawn = controller.pawn
	var/obj/item/held_item = living_pawn.get_active_held_item()
	var/obj/item/dual_wield = living_pawn.get_inactive_held_item()
	var/list/weapons = list()

	for(var/obj/item/weapon/local_candidate in (view(search_range, controller.pawn) | living_pawn.get_equipped_items()))
		if(!istype(local_candidate, controller.blackboard[BB_WEAPON_TYPE]))
			continue
		if(held_item && held_item.force >= local_candidate.force)
			if((!dual_wield || dual_wield.force < local_candidate.force) && (HAS_TRAIT(living_pawn, TRAIT_DUALWIELDER) || istype(held_item, /obj/item/weapon/shield)))
				weapons += local_candidate
				living_pawn.swap_hand(living_pawn.get_inactive_hand_index())
			continue
		weapons += local_candidate
	if(weapons.len)
		return pick(weapons)
