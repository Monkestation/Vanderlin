/datum/element/walking_stick

/datum/element/walking_stick/Attach(datum/target)
	. = ..()
	if(!isitem(target))
		return ELEMENT_INCOMPATIBLE

	RegisterSignal(target, list(COMSIG_ITEM_EQUIPPED, COMSIG_ITEM_DROPPED), PROC_REF(equippedChanged))

/datum/element/walking_stick/Detach(datum/source, ...)
	. = ..()
	UnregisterSignal(source, list(COMSIG_ITEM_EQUIPPED, COMSIG_ITEM_DROPPED))
	if(isatom(source))
		var/atom/atom_source = source
		if(isliving(atom_source.loc))
			var/mob/living/living_mob = atom_source.loc
			REMOVE_TRAIT(living_mob, TRAIT_NO_LEG_AID, REF(src))
			living_mob.update_limbless_locomotion()

/datum/element/walking_stick/proc/equippedChanged(datum/source, mob/living/user, slot)
	if(!istype(user))
		return
	// COMSIG_ITEM_DROPPED sends "item_slot" as the slot
	if(isnum(slot) && (slot & ITEM_SLOT_HANDS))
		ADD_TRAIT(user, TRAIT_NO_LEG_AID, REF(src))
	else
		REMOVE_TRAIT(user, TRAIT_NO_LEG_AID, REF(src))
	user.update_limbless_locomotion()
