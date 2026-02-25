/datum/clan_leader/daewalker
	lord_spells = list()
	lord_verbs = list()
	lord_traits = list(TRAIT_HEAVYARMOR, TRAIT_NOSTAMINA)
	lord_title = "Daewalker"

/datum/clan/daewalker
	name = "The Daewalker"
	desc = "todo"
	curse = "todo"
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
	)
	leader = /datum/clan_leader/daewalker
	selectable_by_vampires = FALSE
	allows_non_vampires = FALSE

/datum/clan/daewalker/get_blood_preference_string()
	return "the blood of bloodsuckers"

/datum/clan/daewalker/initialize_hierarchy()
	. = ..()
	hierarchy_root?.can_assign_positions = FALSE

/datum/clan/daewalker/apply_vampire_look(mob/living/carbon/human/H)
	return

/datum/clan/daewalker/apply_clan_components(mob/living/carbon/human/H)
	return

/datum/clan/daewalker/setup_vampire_abilities(mob/living/carbon/human/H)
	return

