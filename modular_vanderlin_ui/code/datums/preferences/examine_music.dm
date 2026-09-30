/datum/preference/choiced/examine_music
	savefile_key = "examine_music"
	savefile_identifier = PREF_CHARACTER
	category = "character"

/datum/preference/choiced/examine_music/init_possible_values(datum/preferences/prefs)
	return list("None", "Briar", "Music Box", "Dreamer", "Horror")

/datum/preference/choiced/examine_music/create_default_value(datum/preferences/prefs)
	return "None"

/datum/preference/choiced/examine_music/apply_to_human(mob/living/carbon/human/H, value, datum/preferences/prefs)
	switch(value)
		if("Briar")
			H.examine_music_track = 'sound/music/briar.ogg'
		if("Music Box")
			H.examine_music_track = 'sound/music/musicbox_windup.ogg'
		if("Dreamer")
			H.examine_music_track = 'sound/music/dreamer_is_still_asleep.ogg'
		if("Horror")
			H.examine_music_track = 'sound/music/horror.ogg'
		else
			H.examine_music_track = null

/datum/preference/choiced/examine_music/handle_link(datum/preferences/prefs, mob/user)
	var/choice = browser_input_list(user, "Choose your examine music", "Character Sound", list("None", "Briar", "Music Box", "Dreamer", "Horror"))
	if(choice)
		prefs.write_preference(/datum/preference/choiced/examine_music, choice)