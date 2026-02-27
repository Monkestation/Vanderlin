/datum/clan/caitiff
	name = "Caitiff"
	desc = "The clanless, an outcast from vampire society. Fortunately for you the curse of kain is not strong enough for you to combust in daylight."
	blood_preference = null
	blood_disgust = BLOOD_PREFERENCE_KIN
	clan_covens = list(
		/datum/coven/auspex,
		/datum/coven/obfuscate,
		/datum/coven/bloodheal
    )
	force_VL_if_clan_is_empty = FALSE
	selectable_by_vampires = FALSE
	//lmaoooooo
	clane_traits = list(
		TRAIT_STRONGBITE,
		TRAIT_BLOODDRINKER,
		TRAIT_STEELHEARTED,
		TRAIT_VAMP_DREAMS,
		TRAIT_DARKVISION,
		TRAIT_NOBREATH,
	)

/datum/clan/caitiff/apply_clan_components(mob/living/carbon/human/H)
	H.AddComponent(/datum/component/vampire_disguise)

/datum/clan/caitiff/get_blood_preference_string()
	return "any blood that is not kindred"
