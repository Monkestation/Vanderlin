GLOBAL_LIST_INIT(hair_gradients, build_hair_gradients())

/proc/build_hair_gradients()
	var/list/gradients = list()
	for(var/datum/hair_gradient/path as anything in typesof(/datum/hair_gradient))
		if(IS_ABSTRACT(path))
			continue
		gradients[path] = new path()
	return gradients

/proc/hair_gradient_name_to_type_list()
	var/list/return_list = list()
	for(var/type in GLOB.hair_gradients)
		var/datum/hair_gradient/gradient = HAIR_GRADIENT(type)
		return_list[gradient.name] = type
	return return_list
