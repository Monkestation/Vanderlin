/datum/component/slippery
	var/force_drop_items = FALSE
	var/knockdown_time = 0
	var/paralyze_time = 0
	var/lube_flags
	var/datum/callback/callback
	var/slip_probability = 0

/datum/component/slippery/Initialize(_knockdown, _lube_flags = NONE, datum/callback/_callback, _paralyze, _force_drop = FALSE, _slip_probability = 100)
	knockdown_time = max(_knockdown, 0)
	paralyze_time = max(_paralyze, 0)
	force_drop_items = _force_drop
	lube_flags = _lube_flags
	callback = _callback
	slip_probability = _slip_probability
	RegisterSignals(parent, list(COMSIG_MOVABLE_CROSSED, COMSIG_ATOM_ENTERED), PROC_REF(Slip))
	RegisterSignal(parent, COMSIG_ITEM_WEARERCROSSED, PROC_REF(Slip_on_wearer))

/datum/component/slippery/UnregisterFromParent()
	UnregisterSignal(parent, list(COMSIG_MOVABLE_CROSSED, COMSIG_ATOM_ENTERED, COMSIG_ITEM_WEARERCROSSED))
	return ..()

/datum/component/slippery/proc/Slip(datum/source, atom/movable/AM)
	var/mob/victim = AM
	if(!prob(slip_probability))
		return
	if(istype(victim) && !(victim.movement_type & (MOVETYPES_NOT_TOUCHING_GROUND)) && victim.slip(knockdown_time, parent, lube_flags, paralyze_time, force_drop_items) && callback)
		callback.Invoke(victim)

/datum/component/slippery/proc/Slip_on_wearer(datum/source, atom/movable/AM, mob/living/crossed)
	if(crossed.body_position != LYING_DOWN && !crossed.buckle_lying)
		Slip(source, AM)
