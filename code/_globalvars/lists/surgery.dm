/// List of all surgery datums
GLOBAL_LIST_INIT(surgeries_list, init_surgeries())

/proc/init_surgeries()
	var/list/surgeries = list()

	for(var/datum/surgery/path as anything in subtypesof(/datum/surgery))
		if(IS_ABSTRACT(path))
			continue
		surgeries += new path()

	sortList(surgeries, GLOBAL_PROC_REF(cmp_typepaths_asc))

	return surgeries
