GLOBAL_LIST_INIT(migrant_waves, build_migrant_waves())

/proc/build_migrant_waves()
	. = list()
	for(var/datum/migrant_wave/type as anything in typesof(/datum/migrant_wave))
		if(IS_ABSTRACT(type))
			continue
		.[type] = new type()
	return .

GLOBAL_LIST_INIT(migrant_roles, build_migrant_roles())

/proc/build_migrant_roles()
	. = list()
	for(var/datum/migrant_role/type as anything in typesof(/datum/migrant_role))
		if(IS_ABSTRACT(type))
			continue
		.[type] = new type()
	return .
