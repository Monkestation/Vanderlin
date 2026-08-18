GLOBAL_LIST_EMPTY(guilds) // keyed by guild id (a type path or string, see below)

/proc/get_or_create_guild(datum/guild/guild_type)
	if(!guild_type)
		return null
	. = GLOB.guilds[guild_type]
	if(!.)
		. = new guild_type

GLOBAL_LIST_EMPTY(current_noble_factions)
