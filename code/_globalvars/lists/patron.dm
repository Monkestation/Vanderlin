GLOBAL_LIST_INIT(faith_list, init_faith_list())

/proc/init_faith_list()
	var/list/faiths = list()
	for(var/datum/faith/faith as anything in subtypesof(/datum/faith))
		if(IS_ABSTRACT(faith))
			continue

		faiths[faith] = new faith()

	return faiths

GLOBAL_LIST_EMPTY(patrons_by_name)
GLOBAL_LIST_EMPTY(patrons_by_faith)
GLOBAL_LIST_INIT(patron_list, init_patron_lists())

/proc/init_patron_lists()
	var/list/faiths = list()
	for(var/datum/patron/patron as anything in subtypesof(/datum/patron))
		if(IS_ABSTRACT(patron))
			continue

		faiths[patron] = new patron()

		LAZYADDASSOCLIST(GLOB.patrons_by_name, patron::name, patron)
		LAZYADDASSOCLIST(GLOB.patrons_by_faith, patron::associated_faith, patron)

	return faiths

GLOBAL_LIST_INIT(curse_names, init_curse_names())

/proc/init_curse_names()
	var/list/curses = list()
	for(var/datum/curse/curse_type as anything in subtypesof(/datum/curse))
		if(IS_ABSTRACT(curse_type))
			continue

		LAZYADDASSOC(curses, curse_type::name, new curse_type)
	return curses
