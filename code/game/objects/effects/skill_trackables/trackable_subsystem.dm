SUBSYSTEM_DEF(trackables)
	name = "Trackable Effect Manager"
	flags = SS_NO_FIRE

	var/list/trackables_to_trait = list()


/datum/controller/subsystem/trackables/Initialize(start_timeofday)
	RegisterSignal(SSdcs, COMSIG_ADD_TRAIT, PROC_REF(check_add_trait))
	RegisterSignal(SSdcs, COMSIG_REMOVE_TRAIT, PROC_REF(check_remove_trait))
	return ..()


/datum/controller/subsystem/trackables/proc/check_add_trait(datum/source, mob/living/target, trait)
	if(!istype(target) || !(trait in trackables_to_trait) || !target.client)
		return

	for(var/obj/effect/skill_tracker/tracker as anything in trackables_to_trait[trait])
		tracker.add_knower(target, 5)
		if(!(tracker.always_revealed_trait in tracker.mobs_with_trait))
			tracker.mobs_with_trait |= tracker.always_revealed_trait
			tracker.mobs_with_trait[tracker.always_revealed_trait] = list()
		tracker.mobs_with_trait[tracker.always_revealed_trait] |= WEAKREF(target)

/datum/controller/subsystem/trackables/proc/check_remove_trait(datum/source, mob/living/target, trait)
	if(!istype(target) || !(trait in trackables_to_trait) || !target.client)
		return

	for(var/obj/effect/skill_tracker/tracker as anything in trackables_to_trait[trait])
		tracker.remove_knower(target, 5)
		tracker.mobs_with_trait[tracker.always_revealed_trait] -= WEAKREF(target)

/datum/controller/subsystem/trackables/proc/add_new_trackable(obj/effect/skill_tracker/tracker)
	if(!tracker.always_revealed_trait)
		return

	if(!(tracker.always_revealed_trait in trackables_to_trait))
		trackables_to_trait |= tracker.always_revealed_trait
		trackables_to_trait[tracker.always_revealed_trait] = list()

	trackables_to_trait[tracker.always_revealed_trait] |= tracker

/datum/controller/subsystem/trackables/proc/remove_trackable(obj/effect/skill_tracker/tracker)
	if(!tracker.always_revealed_trait)
		return

	if(!(tracker.always_revealed_trait in trackables_to_trait))
		trackables_to_trait |= tracker.always_revealed_trait
		trackables_to_trait[tracker.always_revealed_trait] = list()

	trackables_to_trait[tracker.always_revealed_trait] -= tracker
