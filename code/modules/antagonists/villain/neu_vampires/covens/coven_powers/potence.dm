/datum/coven/potence
	name = "Potence"
	desc = "Boosts melee and unarmed damage."
	icon_state = "potence"
	power_type = /datum/coven_power/potence
	clan_restricted = TRUE

/datum/coven_power/potence
	name = "Potence power name"
	desc = "Potence power description"

	check_flags = COVEN_CHECK_CAPABLE
	toggled = TRUE
	duration_length = 2 TURNS
	grouped_powers = list(
		/datum/coven_power/potence/one,
		/datum/coven_power/potence/two,
		/datum/coven_power/potence/three,
		/datum/coven_power/potence/four,
		/datum/coven_power/potence/five
	)
	duration_length = 3 SECONDS
	cooldown_length = 3 SECONDS
	violates_masquerade = TRUE
	refresh_violations = TRUE

	vitae_cost = 20
	var/punch_bonus = 8
	var/kick_bonus = 8
	var/weapon_buff = 1
	var/buff = /datum/status_effect/buff/potence

/datum/coven_power/potence/activate()
	. = ..()
	owner.dna.species.punch_damage += punch_bonus
	owner.dna.species.kick_damage += kick_bonus
	owner.potence_weapon_buff = weapon_buff
	owner.apply_status_effect(buff, -1)
	if(level >= 4)
		ADD_TRAIT(owner, TRAIT_BLOODLOSS_IMMUNE, "[type]")
		if(level >= 5)
			ADD_TRAIT(owner, TRAIT_NODEATH, "[type]") // good, but not as busted as it sounds


/datum/coven_power/potence/deactivate()
	owner.dna.species.punch_damage -= punch_bonus
	owner.dna.species.kick_damage -= kick_bonus
	owner.potence_weapon_buff = 0
	owner.remove_overlay(POTENCE_LAYER) // we dont even have anything here but...alright. sure.
	owner.remove_status_effect(buff, -1)
	REMOVE_TRAIT(owner, TRAIT_BLOODLOSS_IMMUNE, "[type]")
	REMOVE_TRAIT(owner, TRAIT_NODEATH, "[type]")
	. = ..()


//POTENCE 1
/datum/coven_power/potence/one
	name = "Potence 1"
	desc = "Enhance your muscles. Never hit softly."
	level = 1

	vitae_cost = 20
	punch_bonus = 8
	kick_bonus = 8
	weapon_buff = 1
	violates_masquerade = FALSE
	buff = /datum/status_effect/buff/potence

//POTENCE 2
/datum/coven_power/potence/two
	name = "Potence 2"
	desc = "Become powerful beyond your muscles. Wreck people and things."
	level = 2

	vitae_cost = 35
	punch_bonus = 12
	kick_bonus = 12
	weapon_buff = 2
	buff = /datum/status_effect/buff/potence/two

//POTENCE 3
/datum/coven_power/potence/three
	name = "Potence 3"
	desc = "Become a force of destruction. Lift and break the unliftable and the unbreakable."
	level = 3

	vitae_cost = 55
	punch_bonus = 18
	kick_bonus = 18
	weapon_buff = 3
	buff = /datum/status_effect/buff/potence/three

//POTENCE 4
/datum/coven_power/potence/four
	name = "Potence 4"
	desc = "Become an unyielding machine for as long as your Vitae lasts."
	level = 4

	vitae_cost = 75
	punch_bonus = 26
	kick_bonus = 26
	weapon_buff = 4
	buff = /datum/status_effect/buff/potence/four


//POTENCE 5
/datum/coven_power/potence/five
	name = "Potence 5"
	desc = "The people could worship you as a god if you showed them this."
	level = 5

	vitae_cost = 120
	punch_bonus = 36
	kick_bonus = 36
	weapon_buff = 5
	buff = /datum/status_effect/buff/potence/five

/datum/status_effect/buff/potence
	id = "potence"
	alert_type = /atom/movable/screen/alert/status_effect/buff/potence
	effectedstats = list(STAT_STRENGTH = 1, STAT_ENDURANCE = 1)
	duration = 3 SECONDS
	status_type = STATUS_EFFECT_REPLACE

/datum/status_effect/buff/potence/two
	effectedstats = list(STAT_STRENGTH = 2, STAT_ENDURANCE = 2)

/datum/status_effect/buff/potence/three
	effectedstats = list(STAT_STRENGTH = 3, STAT_ENDURANCE = 3)

/datum/status_effect/buff/potence/four
	effectedstats = list(STAT_STRENGTH = 4, STAT_ENDURANCE = 4)

/datum/status_effect/buff/potence/five
	effectedstats = list(STAT_STRENGTH = 5, STAT_ENDURANCE = 5)

/atom/movable/screen/alert/status_effect/buff/potence
	name = "Potence"
	desc = ""
	icon_state = "adrrush"
