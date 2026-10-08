/datum/preference/numeric/voice_pitch
    savefile_key = "voice_pitch"
    savefile_identifier = PREF_CHARACTER
    category = "character"
    can_randomize = FALSE
    should_update_preview = FALSE
    minimum = 80
    maximum = 120
    step = 1

/datum/preference/numeric/voice_pitch/create_default_value(datum/preferences/prefs)
    return 100

/datum/preference/numeric/voice_pitch/apply_to_human(mob/living/carbon/human/H, value, datum/preferences/prefs)
    H.voice_pitch = value / 100

/datum/preference/numeric/voice_pitch/handle_link(datum/preferences/prefs, mob/user)
    var/current = prefs.read_preference(/datum/preference/numeric/voice_pitch)
    var/new_value = tgui_input_number(user, "Высота голоса в процентах ([minimum]-[maximum])", "Высота голоса", current, maximum, minimum)
    if(isnull(new_value))
        return
    prefs.write_preference(/datum/preference/numeric/voice_pitch, clamp(round(new_value), minimum, maximum))