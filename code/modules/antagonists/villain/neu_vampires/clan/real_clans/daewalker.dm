/datum/clan_leader/daewalker
	lord_spells = list()
	lord_verbs = list()
	lord_traits = list(TRAIT_HEAVYARMOR, TRAIT_NOSTAMINA)
	lord_title = "Daewalker"

/datum/clan/daewalker
	name = "Astrata's Will"
	desc = "Walk the dae so they may remember to fear it."
	clan_covens = list(
		/datum/coven/bloodheal,
		/datum/coven/celerity,
		/datum/coven/potence,
	)
	intro_music = 'sound/music/daewalkerintro.ogg'
	blood_preference = BLOOD_PREFERENCE_KIN
	blood_disgust = BLOOD_PREFERENCE_HOLY | BLOOD_PREFERENCE_EUPHORIC
	clane_traits = list(
		TRAIT_STRONGBITE,
		TRAIT_BLOODDRINKER,
		TRAIT_NOHUNGER,
		TRAIT_NOBREATH,
		TRAIT_NOPAIN,
		TRAIT_STEELHEARTED,
		TRAIT_NOSLEEP,
		TRAIT_VAMP_DREAMS,
		TRAIT_DARKVISION,
		TRAIT_LIMBATTACHMENT,
		TRAIT_NOENERGY,
		TRAIT_ZJUMP,
		TRAIT_IMMUNE_TO_FRENZY,
		TRAIT_COVEN_RESISTANT
	)
	leader_title = "Daewalker"
	leader = /datum/clan_leader/daewalker
	selectable_by_vampires = FALSE
	allows_non_vampires = FALSE

/datum/clan/daewalker/get_downside_string()
	return "serve Astrata eternally."

/datum/clan/daewalker/get_blood_preference_string()
	return "the blood of bloodsuckers"

/datum/clan/daewalker/on_gain(mob/living/carbon/human/H, is_vampire)
	. = ..()
	//canceling it out
	H.mob_biotypes &= ~MOB_UNDEAD

/datum/clan/daewalker/initialize_hierarchy()
	// Create the root leadership position
	hierarchy_root = new /datum/clan_hierarchy_node("Daewalker", "Astrata's Chosen", 0)
	hierarchy_root.position_color = "#gold"
	hierarchy_root.max_subordinates = 0
	all_positions += hierarchy_root

/datum/clan/daewalker/apply_vampire_look(mob/living/carbon/human/H)
	return

/datum/clan/daewalker/apply_clan_components(mob/living/carbon/human/H)
	return

/datum/clan/daewalker/setup_vampire_abilities(mob/living/carbon/human/H)
	return

