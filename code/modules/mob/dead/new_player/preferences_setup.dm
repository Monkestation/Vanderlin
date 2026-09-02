/// Randomizes our character preferences according to enabled bitflags.
// Reflect changes in [mob/living/carbon/human/proc/randomize_human_appearance]
/datum/preferences/proc/randomise_appearance_prefs(randomise_flags = ALL, include_donator = FALSE)
	if(randomise_flags & RANDOMIZE_SPECIES)
		var/list/species_list = list()
		for(var/species_id in GLOB.roundstart_species)
			var/species_type = GLOB.species_list[species_id]

			var/datum/species/species = new species_type()
			if(!species.preference_accessible(src))
				continue

			species_list += species.type

		var/rando_race = pick(species_list)
		pref_species = new rando_race()

	if(NOEYESPRITES in pref_species.species_traits)
		randomise_flags &= ~RANDOMIZE_EYE_COLOR

	if(randomise_flags & RANDOMIZE_GENDER)
		write_preference(/datum/preference/choiced/gender, pref_species.sexes ? pick(MALE, FEMALE) : PLURAL)

	// pronouns and voice should match gender, not randomized
	var/list/allowed_voices
	switch(read_preference(/datum/preference/choiced/gender))
		if(MALE)
			write_preference(/datum/preference/choiced/pronouns, HE_HIM)
			allowed_voices = pref_species.allowed_voicetypes_m
			write_preference(/datum/preference/choiced/voice_type, VOICE_TYPE_MASC)
		if(FEMALE)
			write_preference(/datum/preference/choiced/pronouns, SHE_HER)
			allowed_voices = pref_species.allowed_voicetypes_f
			write_preference(/datum/preference/choiced/voice_type, VOICE_TYPE_FEM)
		if(PLURAL)
			write_preference(/datum/preference/choiced/pronouns, THEY_THEM)
			allowed_voices = VOICE_TYPES_LIST
			write_preference(/datum/preference/choiced/voice_type, VOICE_TYPE_ANDRO)
		else
			write_preference(/datum/preference/choiced/pronouns, IT_ITS)
			allowed_voices = VOICE_TYPES_LIST
			write_preference(/datum/preference/choiced/voice_type, VOICE_TYPE_ANDRO)

	if(!allowed_voices || !length(allowed_voices))
		allowed_voices = VOICE_TYPE_ANDRO

	if(!(read_preference(/datum/preference/choiced/voice_type) in allowed_voices))
		write_preference(/datum/preference/choiced/voice_type, pick(allowed_voices))

	var/list/allowed_pronouns = pref_species.allowed_pronouns
	if(!allowed_pronouns || !length(allowed_pronouns))
		allowed_pronouns = PRONOUNS_LIST

	if (!(read_preference(/datum/preference/choiced/pronouns) in allowed_pronouns))
		write_preference(/datum/preference/choiced/pronouns, pick(allowed_pronouns))

	if(randomise_flags & RANDOMIZE_AGE)
		write_preference(/datum/preference/choiced/age, pick(pref_species.possible_ages))

	if(randomise_flags & RANDOMIZE_NAME)
		write_preference(/datum/preference/text/real_name, pref_species.random_name(read_preference(/datum/preference/choiced/gender), TRUE))

	if(randomise_flags & RANDOMIZE_UNDERWEAR)
		write_preference(/datum/preference/choiced/underwear, pref_species.random_underwear(read_preference(/datum/preference/choiced/gender)))

	if(randomise_flags & (RANDOMIZE_HAIRSTYLE | RANDOMIZE_HAIR_COLOR))
		var/datum/customizer_entry/hair/entry = get_customizer_entry_of_type(/datum/customizer_entry/hair/head)
		if(entry)
			var/datum/customizer_choice/customizer_choice = CUSTOMIZER_CHOICE(entry.customizer_choice_type)
			var/color = (randomise_flags & RANDOMIZE_HAIR_COLOR)
			var/accessory = (randomise_flags & RANDOMIZE_HAIRSTYLE)
			customizer_choice.randomize_entry(entry, src, color, accessory)

	if(randomise_flags & (RANDOMIZE_FACIAL_HAIRSTYLE | RANDOMIZE_FACIAL_HAIR_COLOR))
		var/datum/customizer_entry/hair/entry = get_customizer_entry_of_type(/datum/customizer_entry/hair/facial)
		if(entry)
			var/datum/customizer_choice/customizer_choice = CUSTOMIZER_CHOICE(entry.customizer_choice_type)
			var/color = (randomise_flags & RANDOMIZE_FACIAL_HAIR_COLOR)
			var/accessory = (randomise_flags & RANDOMIZE_FACIAL_HAIRSTYLE)
			customizer_choice.randomize_entry(entry, src, color, accessory)

	if(randomise_flags & RANDOMIZE_SKIN_TONE)
		var/list/skin_list = pref_species.get_skin_list()
		write_preference(/datum/preference/choiced/skin_tone, pick_assoc(skin_list))

	//if(randomise_flags & RANDOMIZE_FEATURES)
		//features = random_features()

/// Randomizes our character preferences according to enabled randomise preferences.
/datum/preferences/proc/apply_character_randomization_prefs(antag_override = FALSE)
	if(!randomise[RANDOM_BODY] && !(antag_override && randomise[RANDOM_BODY_ANTAG]))
		return // Prefs say "no, thank you"
	if(randomise[RANDOM_SPECIES])
		random_species()
	if(randomise[RANDOM_GENDER] || antag_override && randomise[RANDOM_GENDER_ANTAG])
		write_preference(/datum/preference/choiced/gender, pref_species.sexes ? pick(MALE, FEMALE) : PLURAL)
	if(randomise[RANDOM_AGE] || randomise[RANDOM_AGE_ANTAG] && antag_override)
		write_preference(/datum/preference/choiced/age, pick(pref_species.possible_ages))
	if(randomise[RANDOM_VOICETYPE] || antag_override && randomise[RANDOM_VOICETYPE_ANTAG])
		write_preference(/datum/preference/choiced/voice_type, pick(VOICE_TYPES_LIST))
	if(randomise[RANDOM_PRONOUNS] || antag_override && randomise[RANDOM_PRONOUNS_ANTAG])
		var/list/allowed_pronouns = pref_species.allowed_pronouns
		if(!allowed_pronouns || !length(allowed_pronouns))
			allowed_pronouns = PRONOUNS_LIST
		if(length(allowed_pronouns) == 1)
			write_preference(/datum/preference/choiced/pronouns, allowed_pronouns[1])
		else
			write_preference(/datum/preference/choiced/pronouns, pick(allowed_pronouns))

	if(randomise[RANDOM_NAME] || antag_override && randomise[RANDOM_NAME_ANTAG])
		write_preference(/datum/preference/text/real_name, pref_species.random_name(read_preference(/datum/preference/choiced/gender), TRUE))

	if(randomise[RANDOM_UNDERWEAR_COLOR])
		write_preference(/datum/preference/color/underwear_color, random_short_color())
	if(randomise[RANDOM_UNDERSHIRT])
		write_preference(/datum/preference/choiced/undershirt, random_undershirt(read_preference(/datum/preference/choiced/gender)))
	if(randomise[RANDOM_UNDERWEAR])
		write_preference(/datum/preference/choiced/underwear, pref_species.random_underwear(read_preference(/datum/preference/choiced/gender)))
	if(randomise[RANDOM_SKIN_TONE])
		var/list/skins = pref_species.get_skin_list()
		write_preference(/datum/preference/choiced/skin_tone, pick_assoc(skins))
	features = random_features()

	if(pref_species.default_features["ears"])
		features["ears"] = pref_species.default_features["ears"]
	write_preference(/datum/preference/choiced/accessory, "Nothing")

/datum/preferences/proc/random_species()
	var/rando_race = GLOB.species_list[pick(GLOB.roundstart_species)]
	pref_species = new rando_race()
	if(randomise[RANDOM_NAME])
		write_preference(/datum/preference/text/real_name, pref_species.random_name(read_preference(/datum/preference/choiced/gender), TRUE))

/datum/preferences/proc/update_preview_icon()
	set waitfor = 0
	if(!parent)
		return
	// Determine what job is marked as 'High' priority, and dress them up as such.
	var/datum/job/previewJob
	var/highest_pref = 0
	for(var/job in job_preferences)
		if(job_preferences[job] > highest_pref)
			previewJob = SSjob.GetJob(job)
			highest_pref = job_preferences[job]

	// Set up the dummy for its photoshoot
	var/mob/living/carbon/human/dummy/mannequin = generate_or_wait_for_human_dummy(DUMMY_HUMAN_SLOT_PREFERENCES)

	apply_prefs_to(mannequin, TRUE)

	if(previewJob)
		mannequin.job = previewJob.title
		mannequin.dress_up_as_job(previewJob, TRUE)

	parent.show_character_previews(new /mutable_appearance(mannequin))
	unset_busy_human_dummy(DUMMY_HUMAN_SLOT_PREFERENCES)
