GLOBAL_LIST_INIT(inqsupplies, init_inqsupplies())

/proc/init_inqsupplies()
	var/list/supplies = list()
	for(var/datum/inqports/path as anything in subtypesof(/datum/inqports))
		if(IS_ABSTRACT(path))
			continue
		supplies[path] = new path()
	return supplies
