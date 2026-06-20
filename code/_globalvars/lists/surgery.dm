/// List of all surgery datums
GLOBAL_LIST_INIT(surgeries_list, init_surgeries())

/proc/init_surgeries()
	var/list/surgeries = list()
	for(var/datum/surgery/path as anything in subtypesof(/datum/surgery))
		if(IS_ABSTRACT(path))
			continue
		surgeries += new path()
	sortTim(surgeries, GLOBAL_PROC_REF(cmp_typepaths_asc))
	return surgeries

/// List of all surgery step datums
GLOBAL_LIST_INIT(surgery_steps, init_surgery_steps())

/proc/init_surgery_steps()
	var/list/steps = list()
	for(var/datum/surgery_step/path as anything in subtypesof(/datum/surgery_step))
		if(IS_ABSTRACT(path))
			continue
		steps += new path()
	sortTim(steps, GLOBAL_PROC_REF(cmp_typepaths_asc))
	return steps
