/datum/preference/numeric/body_size
    savefile_key = "body_size"
    savefile_identifier = PREF_CHARACTER
    category = "character"
    can_randomize = FALSE
    should_update_preview = FALSE
    minimum = 90
    maximum = 110
    step = 1

/datum/preference/numeric/body_size/create_default_value(datum/preferences/prefs)
    return 100

/datum/preference/numeric/body_size/apply_to_human(mob/living/carbon/human/H, value, datum/preferences/prefs)
    if(istype(H, /mob/living/carbon/human/dummy))
        return
    H.current_size = 1
    var/scale = value / 100
    if(scale != 1)
        H.update_transform(scale)

/datum/preference/numeric/body_size/handle_link(datum/preferences/prefs, mob/user)
    var/current = prefs.read_preference(/datum/preference/numeric/body_size)
    var/new_value = tgui_input_number(user, "Размер тела в процентах ([minimum]-[maximum])", "Размер тела", current, maximum, minimum)
    if(isnull(new_value))
        return
    prefs.write_preference(/datum/preference/numeric/body_size, clamp(round(new_value), minimum, maximum))