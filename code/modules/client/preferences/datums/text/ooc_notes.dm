/datum/preference/text/ooc_notes
	savefile_key = "ooc_notes"
	savefile_identifier = PREF_CHARACTER
	category = "character_ooc"
	can_randomize = FALSE
	maximum_value_length = 1024
	should_update_preview = FALSE

/datum/preference/text/ooc_notes/deserialize(input, datum/preferences/prefs)
	return STRIP_HTML_SIMPLE(html_decode(input), maximum_value_length)

/datum/preference/text/ooc_notes/apply_to_human(mob/living/carbon/human/H, value, datum/preferences/prefs)
	H.ooc_notes = value

/datum/preference/text/ooc_notes/handle_link(datum/preferences/prefs, mob/user)
	to_chat(user, span_notice("["<span class='bold'>Do not put anything NSFW here. This feature is for stuff that wouldn't fit in the flavortext.</span>"]"))
	var/new_ooc_notes = input(user, "Input your OOC preferences:", "OOC notes", prefs.read_preference(/datum/preference/text/ooc_notes)) as message|null
	if(new_ooc_notes == null)
		return
	if(new_ooc_notes == "")
		prefs.write_preference(/datum/preference/text/ooc_notes, null)
		prefs.write_preference(/datum/preference/text/ooc_notes_display, null)
		prefs.update_menu_data(user)
		return
	prefs.write_preference(/datum/preference/text/ooc_notes, new_ooc_notes)

	var/ooc = prefs.read_preference(/datum/preference/text/ooc_notes)
	ooc = html_encode(ooc)
	ooc = replacetext(parsemarkdown_basic(ooc), "\n", "<BR>")
	prefs.write_preference(/datum/preference/text/ooc_notes_display, ooc)
	to_chat(user, span_notice("Successfully updated OOC notes."))
	log_game("[user] has set their OOC notes'.")
