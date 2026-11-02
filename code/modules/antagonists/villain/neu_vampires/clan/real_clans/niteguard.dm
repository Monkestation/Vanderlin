/datum/clan_leader/nitewarden
	lord_spells = list(
		/datum/action/cooldown/spell/undirected/shapeshift/bat,
		/datum/action/cooldown/spell/undirected/shapeshift/mist,
	)
	lord_verbs = list(
		/mob/living/carbon/human/proc/punish_spawn
	)
	lord_traits = list(TRAIT_HEAVYARMOR, TRAIT_MEDIUMARMOR, TRAIT_NOSTAMINA, TRAIT_LUNAR_ORDER, TRAIT_DREAM_CAVE)
	lord_title = "Nitewarden"

/datum/clan/niteguard
	name = "Niteguard"
	desc = "Silver still stalks the darkness."
	clan_covens = list(
		/datum/coven/bloodheal,
		/datum/coven/obfuscate,
		/datum/coven/quietus,
	)
	blood_preference = BLOOD_PREFERENCE_KIN
	blood_disgust = BLOOD_PREFERENCE_HOLY | BLOOD_PREFERENCE_EUPHORIC
	clane_traits = list(
		TRAIT_STRONGBITE,
		TRAIT_BLOODDRINKER,
		TRAIT_NOHUNGER,
		TRAIT_NOBREATH,
		TRAIT_NOPAIN,
		TRAIT_STEELHEARTED,
		TRAIT_SLEEPIMMUNE,
		TRAIT_VAMP_DREAMS,
		TRAIT_DARKVISION,
		TRAIT_LIMBATTACHMENT,
		TRAIT_NOENERGY,
		TRAIT_ZJUMP,
		TRAIT_IMMUNE_TO_FRENZY,
		TRAIT_COVEN_RESISTANT,
		TRAIT_SILVER_IMMUNE,
		TRAIT_DIVINE_SERVANT
	)
	leader_title = "Nitewarden"
	leader = /datum/clan_leader/nitewarden
	selectable_by_vampires = FALSE
	allows_non_vampires = FALSE

/datum/clan/niteguard/get_downside_string()
	return "serve The Moon eternally."

/datum/clan/niteguard/get_blood_preference_string()
	return "the blood of bloodsuckers"

/datum/clan/niteguard/on_gain(mob/living/carbon/human/H, is_vampire)
	. = ..()
	//canceling it out
	H.mob_biotypes &= ~MOB_UNDEAD

/datum/clan/niteguard/initialize_hierarchy()
	// Create the root leadership position
	hierarchy_root = new /datum/clan_hierarchy_node("Nitewarden", "Noc's Chosen", 0)
	hierarchy_root.position_color = "#silver"
	hierarchy_root.max_subordinates = 0
	hierarchy_root.can_assign_positions = TRUE
	all_positions += hierarchy_root

/datum/clan/niteguard/apply_vampire_look(mob/living/carbon/human/H)
	return

/datum/clan/niteguard/apply_clan_components(mob/living/carbon/human/H)
	var/datum/antagonist/vampire/vampirism = H.mind?.has_antag_datum(/datum/antagonist/vampire)
	if(vampirism)
		vampirism.isgoodguy = TRUE
		vampirism.roundend_category = "Nitewardens"
		vampirism.antagpanel_category = "Nitewarden"
	return

/datum/clan/niteguard/setup_vampire_abilities(mob/living/carbon/human/H)
	add_verb(H, /mob/living/carbon/human/proc/vampire_telepathy)
	add_verb(H, /mob/living/carbon/human/proc/sire_spawn)

	H.cmode_music = 'sound/music/cmode/church/CombatNoc.ogg'

	H.attributes?.add_sheet(/datum/attribute_holder/sheet/job/clan)
	H.update_age_stats(H.age, TRUE)
	var/datum/action/cooldown/spell/undirected/transfix/transfix = new(H.mind)
	transfix.Grant(H)
	return
