/datum/customizer
	abstract_type = /datum/customizer
	/// User facing name of the customizer.
	var/name = "Customizer"
	/// List of all /datum/customizer_choice's that this customizer can pick from.
	var/list/customizer_choices
	/// The default choice from among `customizer_choices`.
	var/default_choice
	/// Whether this choice allows the user to choose to be missing this customization.
	var/allows_disabling = FALSE
	/// Whether this choice defaults to being missing.
	var/default_disabled = FALSE

/datum/customizer/New()
	. = ..()
	if(!length(customizer_choices))
		CRASH("Customizer [type] lacks choices")
	if(!default_choice)
		default_choice = customizer_choices[1]

//this exists because npcs don't have perfs so load based on carbon dna
/datum/customizer/proc/return_species(datum/preferences/prefs)
	if(istype(prefs))
		return prefs.pref_species
	else
		var/mob/living/carbon/carbon = prefs
		return carbon?.dna?.species

/datum/customizer/proc/make_default_customizer_entry(datum/preferences/prefs, changed_entry = TRUE)
	return get_customizer_entry(prefs, default_choice, changed_entry)

/datum/customizer/proc/create_customizer_entry(datum/preferences/prefs, customizer_choice_type, changed_entry = TRUE)
	return get_customizer_entry(prefs, customizer_choice_type, changed_entry)

/datum/customizer/proc/get_customizer_entry(datum/preferences/prefs, customizer_choice_type, changed_entry = TRUE)
	var/datum/customizer_choice/chosen_custom = CUSTOMIZER_CHOICE(customizer_choice_type)
	var/datum/customizer_entry/created_entry = chosen_custom.make_default_customizer_entry(prefs, type, changed_entry)
	if(!changed_entry)
		created_entry.disabled = default_disabled
	return created_entry

/datum/customizer/proc/validate_entry(datum/preferences/prefs, datum/customizer_entry/entry)
	if(entry.disabled && !allows_disabling)
		entry.disabled = FALSE
	var/datum/customizer_choice/choice = CUSTOMIZER_CHOICE(entry.customizer_choice_type)
	choice.validate_entry(prefs, entry)

/datum/customizer/proc/is_allowed(mob/living/carbon/human/human)
	return TRUE

/datum/customizer/organ
	abstract_type = /datum/customizer/organ
	name = "Organ"

/datum/customizer/bodypart_feature
	abstract_type = /datum/customizer/bodypart_feature
	name = "Bodypart Feature"
