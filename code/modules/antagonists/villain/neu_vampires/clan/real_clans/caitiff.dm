/datum/clan/caitiff
	name = "Caitiff"
	desc = "The clanless, an outcast from vampire society. Fortunately for you the curse of kain is not strong enough for you to combust in daylight."
	blood_preference = BLOOD_PREFERENCE_ALL
	clan_covens = list(
		/datum/coven/auspex,
		/datum/coven/obfuscate,
		/datum/coven/bloodheal
    )
	force_VL_if_clan_is_empty = FALSE
	selectable_by_vampires = FALSE

/datum/clan/caitiff/apply_clan_components(mob/living/carbon/human/H)
	H.AddComponent(/datum/component/vampire_disguise)
