/datum/component/fracture_support
	/// Fraction of FRACTURED_ADD_SLOWDOWN we cancel out (0.5 = half the slow relieved)
	var/mitigate_amount = 0.5
	/// Mob currently benefiting from this item, if any
	var/mob/living/carbon/human/current_owner
	/// Which movespeed slot we're currently occupying, so we can clean it up
	var/active_movespeed_id
	/// Convention: TRUE = cane on same side as the bad leg gets the bonus,
	/// FALSE = cane must be on the OPPOSITE side of the bad leg (more realistic)
	var/same_side_convention = TRUE

/datum/component/fracture_support/Initialize(mitigate_amount = 0.5, same_side_convention = TRUE)
	if(!isitem(parent))
		return COMPONENT_INCOMPATIBLE
	src.mitigate_amount = mitigate_amount
	src.same_side_convention = same_side_convention
	RegisterSignal(parent, COMSIG_ITEM_EQUIPPED, PROC_REF(on_equipped))
	RegisterSignals(parent, list(COMSIG_ITEM_DROPPED, COMSIG_ITEM_POST_UNEQUIP), PROC_REF(on_unequipped))

/datum/component/fracture_support/Destroy(force, silent)
	clear_mitigation()
	UnregisterSignal(parent, list(COMSIG_ITEM_POST_UNEQUIP, COMSIG_ITEM_DROPPED, COMSIG_ITEM_EQUIPPED))
	return ..()

/datum/component/fracture_support/proc/on_equipped(obj/item/source, mob/user, slot)
	SIGNAL_HANDLER
	if(!(slot & ITEM_SLOT_HANDS))
		return
	if(!isliving(user))
		return

	// Held in a hand - figure out which side, then re-evaluate mitigation
	current_owner = user
	RegisterSignal(user, COMSIG_LIVING_WOUND_GAINED, PROC_REF(recheck_mitigation), override = TRUE) // catch new fractures while held
	recheck_mitigation()

/datum/component/fracture_support/proc/on_unequipped(obj/item/source, mob/user)
	SIGNAL_HANDLER
	clear_mitigation()
	if(current_owner)
		UnregisterSignal(current_owner, COMSIG_LIVING_WOUND_GAINED)
	current_owner = null

/// Re-checks hand side + fracture state and applies/removes the offset as needed.
/datum/component/fracture_support/proc/recheck_mitigation()
	clear_mitigation() // always start clean, then re-derive

	if(!current_owner || QDELETED(current_owner))
		return
	var/obj/item/held = parent
	var/held_index = current_owner.get_held_index_of_item(held)
	if(!held_index)
		return

	var/in_right_hand = (held_index % 2 == 1)
	var/support_zone = in_right_hand ? BODY_ZONE_R_LEG : BODY_ZONE_L_LEG

	// flip which leg we're "supporting" if using the opposite-side convention
	if(!same_side_convention)
		support_zone = (support_zone == BODY_ZONE_R_LEG) ? BODY_ZONE_L_LEG : BODY_ZONE_R_LEG

	var/obj/item/bodypart/leg = current_owner.get_bodypart(support_zone)
	if(!leg)
		return

	var/has_fracture = FALSE
	for(var/datum/wound/fracture/frac in leg.wounds)
		has_fracture = TRUE
		break
	if(!has_fracture)
		return

	apply_mitigation(support_zone)

/datum/component/fracture_support/proc/apply_mitigation(zone)
	var/base_id = (zone == BODY_ZONE_R_LEG) ? MOVESPEED_ID_FRACTURE_RIGHT_LEG : MOVESPEED_ID_FRACTURE_LEFT_LEG
	active_movespeed_id = "[base_id]_cane_assist"
	current_owner.add_movespeed_modifier(active_movespeed_id, multiplicative_slowdown = -(FRACTURED_ADD_SLOWDOWN * mitigate_amount))

/datum/component/fracture_support/proc/clear_mitigation()
	if(active_movespeed_id && current_owner)
		current_owner.remove_movespeed_modifier(active_movespeed_id)
	active_movespeed_id = null
