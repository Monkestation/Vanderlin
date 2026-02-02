
/datum/clan_leader/thronleer
	lord_spells = list(
		/datum/action/cooldown/spell/enslave_mortal,
		/datum/action/cooldown/spell/undirected/mansion_portal,
		/datum/action/cooldown/spell/undirected/shapeshift/mist
	)
	lord_verbs = list(
		/mob/living/carbon/human/proc/demand_submission,
		/mob/living/carbon/human/proc/punish_spawn
	)
	lord_traits = list(TRAIT_HEAVYARMOR, TRAIT_NOSTAMINA)
	lord_title = "Elder"

/datum/clan/thronleer
	name = "House Thronleer"
	desc = "TBA"
	curse = "Weakness of the soul."
	blood_preference = BLOOD_PREFERENCE_FANCY
	clane_covens = list(
		/datum/coven/obfuscate,
		/datum/coven/presence,
		/datum/coven/bloodheal
	)
	leader = /datum/clan_leader/thronleer

/datum/clan/thronleer/get_blood_preference_string()
	return "prepared blood"

/datum/clan/thronleer/get_downside_string()
	return "weak in fights"

/datum/clan/thronleer/apply_clan_components(mob/living/carbon/human/H)
	H.AddComponent(/datum/component/vampire_disguise)
