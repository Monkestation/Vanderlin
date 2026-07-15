/datum/preference/choiced/voice_type
	savefile_key = "voice_type"
	savefile_identifier = PREF_CHARACTER
	category = "character"

/datum/preference/choiced/voice_type/init_possible_values(datum/preferences/prefs)
	return VOICE_TYPES_LIST

/datum/preference/choiced/voice_type/create_default_value(datum/preferences/prefs)
	return VOICE_TYPE_MASC

/datum/preference/choiced/voice_type/apply_to_human(mob/living/carbon/human/H, value, datum/preferences/prefs)
	H.voice_type = value

/datum/preference/choiced/voice_type/handle_link(datum/preferences/prefs, mob/user)
	var/list/allowed_voices
	if(prefs.read_preference(/datum/preference/choiced/gender) == MALE)
		allowed_voices = prefs.pref_species.allowed_voicetypes_m
	else if(prefs.read_preference(/datum/preference/choiced/gender) == FEMALE)
		allowed_voices = prefs.pref_species.allowed_voicetypes_f
	else
		allowed_voices = VOICE_TYPES_LIST
	if(!allowed_voices || !length(allowed_voices))
		allowed_voices = VOICE_TYPES_LIST
	if(length(allowed_voices) == 1)
		prefs.write_preference(/datum/preference/choiced/voice_type, allowed_voices[1])
		to_chat(user, span_warning("This species can only use the [prefs.read_preference(/datum/preference/choiced/voice_type)] voice type."))
		return

	var/voicetype_input = browser_input_list(user, "CHOOSE YOUR HERO'S VOICE TYPE", "DISCARD SOCIETY'S EXPECTATIONS", allowed_voices)
	if(voicetype_input)
		prefs.write_preference(/datum/preference/choiced/voice_type, voicetype_input)
		if(voicetype_input == VOICE_TYPE_ANDRO)
			to_chat(user, span_warning("This will use the feminine voicepack pitched down a bit to achieve a more androgynous sound."))
		to_chat(user, span_warning("Your character will now vocalize with a [LOWER_TEXT(prefs.read_preference(/datum/preference/choiced/voice_type))] affect."))
