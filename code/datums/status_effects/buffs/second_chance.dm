/atom/movable/screen/alert/status_effect/buff/second_chance
	name = "Second Chance"
	desc = "Magickal resilience hardens me - I shrug off critical wounds, and pain no longer staggers me."
	icon_state = "buff"

/datum/status_effect/buff/second_chance
	id = "second_chance"
	alert_type = /atom/movable/screen/alert/status_effect/buff/second_chance
	duration = 30 SECONDS

/datum/status_effect/buff/second_chance/on_apply()
	. = ..()
	ADD_TRAIT(owner, TRAIT_CRITICAL_RESISTANCE, MAGIC_TRAIT)
	ADD_TRAIT(owner, TRAIT_NOPAINSTUN, MAGIC_TRAIT)

/datum/status_effect/buff/second_chance/on_remove()
	REMOVE_TRAIT(owner, TRAIT_CRITICAL_RESISTANCE, MAGIC_TRAIT)
	REMOVE_TRAIT(owner, TRAIT_NOPAINSTUN, MAGIC_TRAIT)
	. = ..()
