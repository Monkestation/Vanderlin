/datum/world_trait
	var/name = "World Trait"
	var/desc = "World Trait Description"
	var/processes = FALSE

	var/list/tracked_items = list()

/datum/world_trait/New()
	. = ..()
	if(processes)
		START_PROCESSING(SSobj, src)

/datum/world_trait/Destroy(force)
	. = ..()
	if(processes)
		STOP_PROCESSING(SSobj, src)

/datum/world_trait/proc/add_tracked(atom/incoming)
	tracked_items |= incoming

/datum/world_trait/proc/remove_tracked(atom/removing)
	tracked_items -= removing
