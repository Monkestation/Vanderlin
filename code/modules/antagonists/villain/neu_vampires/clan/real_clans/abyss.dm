/datum/clan/abyss
	name = "Children of the Abyss"
	desc = "The Children of the Abyss are a bloodline of vampires that worship the demons of old. Because of their affinity with the unholy, they are extremely vulnerable to the Church."
	curse = "Fear of the Religion."
	blood_preference = BLOOD_PREFERENCE_LIVING
	blood_disgust = BLOOD_PREFERENCE_HOLY
	clane_covens = list(
		/datum/coven/obfuscate,
		/datum/coven/presence,
		/datum/coven/demonic,
		/datum/coven/bloodheal
	)

/datum/clan/abyss/on_gain(mob/living/carbon/human/H, is_vampire = TRUE)
	. = ..()
	H.faction |= "Abyss"
	H.AddElement(/datum/element/holy_weakness)

/datum/clan/abyss/get_downside_string()
	return "burn in sunlight, and in the presence of the Ten"

/datum/clan/caitiff/get_blood_preference_string()
	return "the blood of all living but the holy"
