/datum/coven/celerity
	name = "Celerity"
	desc = "Boosts your speed."
	icon_state = "celerity"
	power_type = /datum/coven_power/celerity

/obj/effect/celerity
	name = "Afterimage"
	desc = "..."
	anchored = TRUE

/obj/effect/celerity/Initialize()
	. = ..()
	spawn(0.5 SECONDS)
		qdel(src)


/datum/coven_power/celerity
	name = "Celerity power name"
	desc = "Celerity power description"
	violates_masquerade = TRUE
	refresh_violations = TRUE
	duration_length = 3 SECONDS
	cooldown_length = 3 SECONDS

	toggled = TRUE
	check_flags = COVEN_CHECK_LYING | COVEN_CHECK_IMMOBILE
	var/buff = /datum/status_effect/buff/celerity
	grouped_powers = list(
		/datum/coven_power/celerity/one,
		/datum/coven_power/celerity/two,
		/datum/coven_power/celerity/three,
		/datum/coven_power/celerity/four,
		/datum/coven_power/celerity/five
	)

/datum/coven_power/celerity/activate()
	. = ..()
	owner.celerity_visual = TRUE
	owner.add_movespeed_modifier(MOVESPEED_ID_CELERITY, multiplicative_slowdown = -0.2 * level)
	owner.apply_status_effect(buff, -1)
	if(level > 1)
		owner.LoadComponent(/datum/component/after_image)

/datum/coven_power/celerity/deactivate()
	. = ..()
	if(level > 1)
		qdel(owner.GetComponent(/datum/component/after_image))
	owner.celerity_visual = FALSE
	owner.remove_movespeed_modifier(MOVESPEED_ID_CELERITY)
	owner.remove_status_effect(buff, -1)

/datum/coven_power/celerity/one
	name = "Celerity 1"
	desc = "Enhances your speed to make everything a little bit easier."
	level = 1
	buff = /datum/status_effect/buff/celerity
	vitae_cost = 15
	violates_masquerade = FALSE

/datum/coven_power/celerity/two
	name = "Celerity 2"
	desc = "Significantly improves your speed and reaction time."
	level = 2
	buff = /datum/status_effect/buff/celerity/two
	vitae_cost = 30

/datum/coven_power/celerity/three
	name = "Celerity 3"
	desc = "Move faster. React in less time. Your body is under perfect control."
	level = 3
	buff = /datum/status_effect/buff/celerity/three
	vitae_cost = 40

/datum/coven_power/celerity/four
	name = "Celerity 4"
	desc = "Breach the limits of what is humanly possible. Move like a lightning bolt."
	level = 4
	buff = /datum/status_effect/buff/celerity/four
	vitae_cost = 50

/datum/coven_power/celerity/five
	name = "Celerity 5"
	desc = "You are like light. Blaze your way through the world."
	level = 5
	buff = /datum/status_effect/buff/celerity/five
	vitae_cost = 60


/datum/status_effect/buff/celerity
	id = "celerity"
	alert_type = /atom/movable/screen/alert/status_effect/buff/celerity
	effectedstats = list(STATKEY_SPD = 1, STATKEY_PER = 1)
	duration = 3 SECONDS
	status_type = STATUS_EFFECT_REPLACE

/datum/status_effect/buff/celerity/two
	effectedstats = list(STATKEY_SPD = 2, STATKEY_PER = 2)

/datum/status_effect/buff/celerity/three
	effectedstats = list(STATKEY_SPD = 3, STATKEY_PER = 3)

/datum/status_effect/buff/celerity/four
	effectedstats = list(STATKEY_SPD = 4, STATKEY_PER = 4)

/datum/status_effect/buff/celerity/five
	effectedstats = list(STATKEY_SPD = 5, STATKEY_PER = 5)

/datum/status_effect/buff/celerity/nextmove_modifier()
	return 0.60

/atom/movable/screen/alert/status_effect/buff/celerity
	name = "Celerity"
	desc = ""
	icon_state = "adrrush"
