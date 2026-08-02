/datum/player_details
	var/ckey
	var/list/player_actions = list()
	var/list/logging = list()
	var/list/post_login_callbacks = list()
	var/list/post_logout_callbacks = list()
	var/list/played_names = list() //List of names this key played under this round
	var/byond_version = "Unknown"
	var/byond_build
	var/datum/achievement_data/achievements
	var/rerolls = 0

/datum/player_details/New(key)
	src.ckey = ckey(key)
	achievements = new(key)
	rerolls = CONFIG_GET(number/special_rerolls)

/datum/player_details/Destroy(force)
	if(!force)
		stack_trace("Something is trying to delete player details for [ckey]")
		return QDEL_HINT_LETMELIVE
	return ..()

/// Returns the full version string (i.e 515.1642) of the BYOND version and build.
/datum/player_details/proc/full_byond_version()
	if(!byond_version)
		return "Unknown"
	return "[byond_version].[byond_build || "xxx"]"

/proc/log_played_names(ckey, ...)
	if(!ckey)
		return
	if(args.len < 2)
		return
	var/list/names = args.Copy(2)
	var/datum/player_details/P = GLOB.player_details[ckey]
	if(P)
		for(var/name in names)
			if(name)
				P.played_names |= name
