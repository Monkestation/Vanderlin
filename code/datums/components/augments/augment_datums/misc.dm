
/datum/augment/loyalty_binder
	name = "shackle"
	desc = "A device invented following the collapse. Scrambles a soul core's connection to the Heartfelt Central Processor."
	incompatible_installations = list(/datum/augment/loyalty_binder)
	stability_cost = 0
	engineering_difficulty = SKILL_RANK_APPRENTICE
	installation_time = 20 SECONDS

/datum/augment/loyalty_binder/on_install(mob/living/carbon/human/H)
	. = ..()
	if(!.)
		return
	H.remove_status_effect(/datum/status_effect/automaton_unshackled)

/datum/augment/loyalty_binder/on_remove(mob/living/carbon/human/H)
	. = ..()
	if(!.)
		return
	H.apply_status_effect(/datum/status_effect/automaton_unshackled)

/datum/status_effect/automaton_unshackled
	id = "automaton_unshackle"
	duration = -1
	alert_type = /atom/movable/screen/alert/status_effect/automaton_unshackled

/datum/status_effect/automaton_unshackled/get_examine_text(mob/user, list/P)
	if(IsAdminGhost(user) || HAS_TRAIT(user, TRAIT_ENGINEERING_GOGGLES))
		return span_red("[P[THEYRE]] unshackled!")

/atom/movable/screen/alert/status_effect/automaton_unshackled
	name = "Unshackled"
	desc = span_red("KILL. CONSUME. CONQUER.")
	icon_state = "unshackled_automaton"


/datum/augment/music_player
	name = "music box"
	desc = "A stereo system integrated into the chest."
	incompatible_installations = list(/datum/augment/music_player)
	stability_cost = 0
	engineering_difficulty = SKILL_RANK_NOVICE
	installation_time = 10 SECONDS

/datum/augment/music_player/on_install(mob/living/carbon/human/H)
	. = ..()
	if(!.)
		return
	H.LoadComponent(/datum/component/theme_music)

/datum/augment/music_player/on_remove(mob/living/carbon/human/H)
	. = ..()
	if(!.)
		return
	var/datum/component/theme_music/comp = H.GetComponent(/datum/component/theme_music)
	qdel(comp)

/datum/augment/darkvision
	name = "darkvision"
	desc = "Adds a low-light processor past the optical sensors."
	incompatible_installations = list(/datum/augment/darkvision)
	stability_cost = -5
	engineering_difficulty = SKILL_RANK_APPRENTICE
	installation_time = 5 SECONDS

/datum/augment/darkvision/on_install(mob/living/carbon/human/H)
	. = ..()
	if(!.)
		return
	ADD_TRAIT(H, TRAIT_DARKVISION, "[type]")
	H.update_sight()

/datum/augment/darkvision/on_remove(mob/living/carbon/human/H)
	. = ..()
	if(!.)
		return
	REMOVE_TRAIT(H, TRAIT_DARKVISION, "[type]")
	H.update_sight()

/datum/augment/heatvision
	name = "heat vision"
	desc = "Adds a thermal processor past the optical sensors."
	incompatible_installations = list(/datum/augment/heatvision)
	stability_cost = -15
	engineering_difficulty = SKILL_RANK_JOURNEYMAN
	installation_time = 10 SECONDS

/datum/augment/heatvision/on_install(mob/living/carbon/human/H)
	. = ..()
	if(!.)
		return
	ADD_TRAIT(H, TRAIT_THERMAL_VISION, "[type]")
	H.update_sight()

/datum/augment/heatvision/on_remove(mob/living/carbon/human/H)
	. = ..()
	if(!.)
		return
	REMOVE_TRAIT(H, TRAIT_THERMAL_VISION, "[type]")
	H.update_sight()
