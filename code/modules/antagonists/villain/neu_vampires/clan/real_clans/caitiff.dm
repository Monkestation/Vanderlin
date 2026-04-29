/datum/clan/caitiff
	name = "Caitiff"
	desc = "The clanless, an outcast from vampire society. Fortunately for you the curse of kain is not strong enough for you to combust in daylight."
	blood_preference = null
	blood_disgust = null
	clan_covens = list(
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
		TRAIT_NOAMBUSH,
	)
	has_hierarchy = FALSE
	silent_join = TRUE


/datum/clan/caitiff/apply_clan_components(mob/living/carbon/human/H)
	H.AddComponent(/datum/component/vampire_disguise)

/datum/clan/caitiff/get_blood_preference_string()
	return "anything you can sink your teeth in"

/datum/clan/caitiff/setup_vampire_abilities(mob/living/carbon/human/H)
	return
