GLOBAL_LIST_INIT(emote_list, init_emote_list())

/proc/init_emote_list()
	var/list/emotes = list()
	for(var/datum/emote/emote as anything in subtypesof(/datum/emote))
		if(IS_ABSTRACT(emote))
			continue

		emote = new emote()

		LAZYADDASSOCLIST(emotes, emote.key, emote)
		LAZYADDASSOCLIST(emotes, emote.key_third_person, emote)

	return emotes
