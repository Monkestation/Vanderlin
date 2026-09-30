/datum/preference/text/nudeshot_link
	savefile_key = "nudeshot_link"
	savefile_identifier = PREF_CHARACTER
	category = "character_ooc"
	can_randomize = FALSE
	maximum_value_length = 512
	should_update_preview = FALSE

/datum/preference/text/nudeshot_link/is_valid(value, datum/preferences/prefs)
	if(!length(value))
		return TRUE
	return ..() && is_valid_headshot_link(null, value, TRUE)

/datum/preference/text/nudeshot_link/apply_to_human(mob/living/carbon/human/H, value, datum/preferences/prefs)
	H.nudeshot_link = value

/datum/preference/text/nudeshot_link/handle_link(datum/preferences/prefs, mob/user)
	to_chat(user, span_notice("This link is for private, consenting ERP context only - use responsibly."))
	var/new_link = input(user, "Input the nudeshot link (https, hosts: gyazo, lensdump, imgbox, catbox):", "Nudeshot", prefs.read_preference(/datum/preference/text/nudeshot_link)) as text|null
	if(!new_link)
		return
	if(length(new_link) && !is_valid_headshot_link(user, new_link, FALSE))
		to_chat(user, span_notice("Failed to update nudeshot"))
		return
	prefs.write_preference(/datum/preference/text/nudeshot_link, new_link)
	to_chat(user, span_notice("Successfully updated nudeshot picture"))