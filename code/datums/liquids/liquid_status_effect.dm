/datum/status_effect/water_affected
	id = "wateraffected"
	alert_type = null
	duration = -1

/datum/status_effect/water_affected/on_apply()
	. = ..()

/datum/status_effect/water_affected/tick(seconds_between_ticks)
	var/turf/owner_turf = get_turf(owner)
	if(QDELETED(owner_turf) || QDELETED(owner_turf.liquids) || owner_turf.liquids.liquid_group.group_overlay_state == LIQUID_STATE_PUDDLE)
		qdel(src)
		return
	//Make the reagents touch the person

	var/fraction = SUBMERGEMENT_PERCENT(owner, owner_turf.liquids)
	owner_turf.liquids.liquid_group.expose_members_turf(owner_turf.liquids)
	owner_turf.liquids.liquid_group.transfer_to_atom(owner_turf.liquids, ((SUBMERGEMENT_REAGENTS_TOUCH_AMOUNT * fraction / 20)), owner)

	return ..()
