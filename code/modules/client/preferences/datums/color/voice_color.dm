/datum/preference/color/voice_color
	savefile_key = "voice_color"
	savefile_identifier = PREF_CHARACTER
	category = "appearance"

/datum/preference/color/voice_color/create_default_value(datum/preferences/prefs)
	return "a0a0a0"

/datum/preference/color/voice_color/deserialize(input, datum/preferences/prefs)
	return sanitize_hexcolor(input, include_crunch = FALSE)

/datum/preference/color/voice_color/apply_to_human(mob/living/carbon/human/H, value, datum/preferences/prefs)
	H.voice_color = value

/datum/preference/color/voice_color/handle_link(datum/preferences/prefs, mob/user)
	var/new_voice = input(user, "SELECT YOUR HERO'S VOICE COLOR", "THE THROAT","#"+prefs.read_preference(/datum/preference/color/voice_color)) as color|null
	if(new_voice)
		if(color_hex2num(new_voice) < 230)
			to_chat(user, "<font color='red'>This voice color is too dark for mortals.</font>")
			return
		prefs.write_preference(/datum/preference/color/voice_color, sanitize_hexcolor(new_voice, include_crunch = FALSE))
