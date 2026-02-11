/datum/clan/abyss
	name = "Children of the Abyss"
	desc = "The Children of the Abyss are a bloodline of vampires that worship the demons of old. Because of their affinity with the unholy, they are extremely vulnerable to the Church."
	curse = "Fear of the Religion."
	clan_covens = list(
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
