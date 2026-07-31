GLOBAL_LIST_INIT_TYPED(organ_processes_datums, /datum/organ_process, init_subtypes(/datum/organ_process, allow_abstract = FALSE))
GLOBAL_LIST_INIT_TYPED(organ_processes_by_slot, /datum/organ_process, setup_organ_processes_by_slot())

/proc/setup_organ_processes_by_slot()
	. = list()
	for(var/datum/organ_process/organ_process as anything in GLOB.organ_processes_datums)
		.[organ_process.slot] = organ_process
