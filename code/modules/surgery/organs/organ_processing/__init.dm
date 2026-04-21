GLOBAL_LIST_INIT_TYPED(organ_processes_datums, /datum/organ_process, init_subtypes(/datum/organ_process))
GLOBAL_LIST_INIT_TYPED(organ_processes_by_slot, /datum/organ_process, world.setup_organ_processes_by_slot())

/world/proc/setup_organ_processes_by_slot()
	. = list()
	for(var/thing in GLOB.organ_processes_datums)
		var/datum/organ_process/organ_process = thing
		.[organ_process.slot] = organ_process
