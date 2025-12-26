GLOBAL_LIST_INIT(humor_instances, init_humor_instances())

/proc/init_humor_instances()
	var/list/humors = list()
	for(var/humor in subtypesof(/datum/humor))
		if(is_abstract(humor))
			continue
		humors[humor] = new humor()

	return humors
