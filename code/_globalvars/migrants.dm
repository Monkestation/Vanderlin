GLOBAL_LIST_INIT(migrant_waves, build_migrant_waves())

/proc/build_migrant_waves()
	. = list()
	for(var/datum/migrant_wave/wave_type as anything in typesof(/datum/migrant_wave))
		if(IS_ABSTRACT(wave_type))
			continue
		.[wave_type] = new wave_type()
	return .

GLOBAL_LIST_INIT(migrant_roles, build_migrant_roles())

/proc/build_migrant_roles()
	. = list()
	for(var/datum/migrant_role/role_type as anything in typesof(/datum/migrant_role))
		if(IS_ABSTRACT(role_type))
			continue
		.[role_type] = new role_type()
	return .
