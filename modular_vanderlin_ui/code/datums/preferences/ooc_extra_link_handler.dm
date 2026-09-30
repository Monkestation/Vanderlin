/datum/preference/text/ooc_extra_link/handle_link(datum/preferences/prefs, mob/user)
	var/new_link = input(user, "Input an extra OOC reference link:", "OOC Extra Link", prefs.read_preference(/datum/preference/text/ooc_extra_link)) as text|null
	if(new_link == null)
		return
	prefs.write_preference(/datum/preference/text/ooc_extra_link, new_link)
	to_chat(user, span_notice("Successfully updated OOC extra link."))