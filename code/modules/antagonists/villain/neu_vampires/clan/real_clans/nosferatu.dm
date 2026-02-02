/datum/sprite_accessory/ears/nosferatu

/datum/sprite_accessory/hair/adjust_appearance_list(list/appearance_list, obj/item/organ/organ, obj/item/bodypart/bodypart, mob/living/carbon/owner)
	generic_gender_feature_adjust(appearance_list, organ, bodypart, owner, OFFSET_FACE)


/datum/clan_leader/nosferatu
	lord_spells = list(
		/datum/action/cooldown/spell/enslave_mortal,
		/datum/action/cooldown/spell/undirected/mansion_portal,
		/datum/action/cooldown/spell/undirected/shapeshift/rat_vampire
	)
	lord_verbs = list(
		/mob/living/carbon/human/proc/demand_submission,
		/mob/living/carbon/human/proc/punish_spawn
	)
	lord_traits = list(TRAIT_HEAVYARMOR, TRAIT_NOSTAMINA)
	lord_title = "Nosferatu"


/datum/clan/nosferatu
	name = "Nosferatu"
	desc = "The Nosferatu wear their curse on the outside. Their bodies horribly twisted and deformed through the Embrace, they lurk on the fringes of most cities, acting as spies and brokers of information. Using animals and their own supernatural capacity to hide, nothing escapes the eyes of the so-called Sewer Rats."
	curse = "Masquerade-violating appearance."
	alt_sprite = "nosferatu"
	leader = /datum/clan_leader/nosferatu
	clane_covens = list(
		/datum/coven/potence,
		/datum/coven/obfuscate,
		/datum/coven/bloodheal
	)
	blood_preference = BLOOD_PREFERENCE_RATS | BLOOD_PREFERENCE_DEAD | BLOOD_PREFERENCE_KIN
	clane_traits = list(
		TRAIT_STRONGBITE,
		TRAIT_KEENEARS,
		TRAIT_NOENERGY,
		TRAIT_NOHUNGER,
		TRAIT_NOBREATH,
		TRAIT_NOPAIN,
		TRAIT_TOXIMMUNE,
		TRAIT_STEELHEARTED,
		TRAIT_NOSLEEP,
		TRAIT_VAMPMANSION,
		TRAIT_VAMP_DREAMS,
		TRAIT_NOAMBUSH,
		TRAIT_DARKVISION,
		TRAIT_LIMBATTACHMENT,
	)

/datum/clan/nosferatu/get_downside_string()
	return "have a hideous face, and suffer in the sun"

/datum/clan/nosferatu/get_blood_preference_string()
	return "kindred blood, the blood of the dead, blood of vermin"

/datum/clan/nosferatu/on_gain(mob/living/carbon/human/H, is_vampire = TRUE)
	. = ..()

	if(is_vampire)
		var/obj/item/organ/eyes/night_vision/NV = new()
		NV.Insert(H, TRUE, FALSE)
		H.ventcrawler = VENTCRAWLER_ALWAYS //I don't think this does anything because we have no vents

/datum/clan/nosferatu/apply_clan_components(mob/living/carbon/human/H)
	H.AddComponent(/datum/component/sunlight_vulnerability, damage = 2, drain = 2)
	H.AddComponent(/datum/component/vampire_disguise)
	H.AddComponent(/datum/component/hideous_face, CALLBACK(src, TYPE_PROC_REF(/datum/clan/nosferatu, face_seen)))

/datum/clan/nosferatu/proc/face_seen(mob/living/carbon/human/nosferatu)
	nosferatu.AdjustMasquerade(-1)
