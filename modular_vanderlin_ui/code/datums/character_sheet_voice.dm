/datum/character_sheet/var/next_voice_preview = 0

/// Plays a sample emote sound to the sheet owner using the saved voice type and pitch.
/datum/character_sheet/proc/play_voice_preview()
    if(!owner || !owner.client || !owner.client.prefs)
        return
    if(world.time < next_voice_preview)
        return
    next_voice_preview = world.time + 5
    var/datum/preferences/prefs = owner.client.prefs
    var/datum/species/preview_species = prefs.pref_species
    if(!preview_species)
        return

    var/voice_kind = prefs.read_preference(/datum/preference/choiced/voice_type)
    var/use_female = (prefs.read_preference(/datum/preference/choiced/gender) == FEMALE)
    switch(voice_kind)
        if(VOICE_TYPE_MASC, VOICE_TYPE_MASC_FOP)
            use_female = FALSE
        if(VOICE_TYPE_FEM, VOICE_TYPE_FEM_DAINTY, VOICE_TYPE_FEM_HAUGHTY, VOICE_TYPE_ANDRO)
            use_female = TRUE

    var/pack = preview_species.soundpack_m
    if(use_female && preview_species.soundpack_f)
        pack = preview_species.soundpack_f
    if(!pack)
        to_chat(owner, span_warning("Для этого голоса нет звуков."))
        return

    var/modifier = null
    if(prefs.read_preference(/datum/preference/choiced/age) == AGE_OLD)
        modifier = "old"

    var/possible_sounds
    for(var/emote_key in list("laugh", "chuckle", "giggle", "sigh", "hmm", "cough"))
        possible_sounds = pack:get_sound(emote_key, modifier)
        if(possible_sounds)
            break
    if(!possible_sounds)
        to_chat(owner, span_warning("Для этого голоса нет звуков."))
        return

    var/used_sound = possible_sounds
    if(islist(possible_sounds))
        var/list/sound_list = possible_sounds
        if(!length(sound_list))
            return
        used_sound = pick(sound_list)

    var/sound/preview_sound
    if(istype(used_sound, /sound))
        var/sound/source_sound = used_sound
        preview_sound = sound(source_sound.file)
    else
        preview_sound = sound(get_sfx(used_sound))

    var/pitch = prefs.read_preference(/datum/preference/numeric/voice_pitch) / 100
    pitch = clamp(pitch, 0.5, 2)
    if(voice_kind == VOICE_TYPE_ANDRO)
        pitch *= 0.92
    preview_sound.frequency = pitch
    preview_sound.volume = 70
    SEND_SOUND(owner, preview_sound)