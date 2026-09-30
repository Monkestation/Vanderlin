/datum/preference/toggle/nsfw_flavor
	savefile_key = "nsfw_flavor"
	savefile_identifier = PREF_CHARACTER
	category = "character"
	default_value = FALSE

/datum/preference/toggle/nsfw_flavor/handle_link(datum/preferences/prefs, mob/user)
	var/current = prefs.read_preference(/datum/preference/toggle/nsfw_flavor)
	prefs.write_preference(/datum/preference/toggle/nsfw_flavor, !current)
	to_chat(user, span_notice("NSFW flavour text flag is now [!current ? "ON" : "OFF"]."))