/datum/preference/text/headshot_link
	savefile_key = "headshot_link"
	savefile_identifier = PREF_CHARACTER
	category = "character_ooc"
	can_randomize = FALSE
	maximum_value_length = 512
	should_update_preview = FALSE

/datum/preference/text/headshot_link/is_valid(value, datum/preferences/prefs)
	// Empty string is always valid (no headshot set).
	if (!length(value))
		return TRUE
	return ..() && is_valid_headshot_link(null, value, TRUE)

/datum/preference/text/headshot_link/apply_to_human(mob/living/carbon/human/H, value, datum/preferences/prefs)
	H.headshot_link = value

/datum/preference/text/headshot_link/handle_link(datum/preferences/prefs, mob/user)
	if(!prefs.donator)
		to_chat(user, "This is a donator exclusive feature, your headshot link will be applied but others will only be able to view it if you are a Patreon supporter or Twitch subscriber.")

	to_chat(user, span_notice("Please use an image of the head and shoulder area to maintain immersion level. Lastly, ["<span class='bold'>do not use a real life photo or ANYTHING AI generated.</span>"]"))
	to_chat(user, span_notice("If the photo doesn't show up properly in-game, ensure that it's a direct image link that opens properly in a browser."))
	to_chat(user, span_notice("Keep in mind that the photo will be downsized to 325x325 pixels, so the more square the photo, the better it will look."))
	var/new_headshot_link = input(user, "Input the headshot link (https, hosts: gyazo, lensdump, imgbox, catbox):", "Headshot", prefs.read_preference(/datum/preference/text/headshot_link)) as text|null
	if(!new_headshot_link)
		return
	var/is_valid_link = is_valid_headshot_link(user, new_headshot_link, FALSE)
	if(!is_valid_link)
		to_chat(user, span_notice("Failed to update headshot"))
		return
	prefs.write_preference(/datum/preference/text/headshot_link, new_headshot_link)
	to_chat(user, span_notice("Successfully updated headshot picture"))
	log_game("[user] has set their Headshot image to '[prefs.read_preference(/datum/preference/text/headshot_link)]'.")
