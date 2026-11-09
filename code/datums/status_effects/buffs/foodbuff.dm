/datum/status_effect/buff/foodbuff
	id = "food_buff"
	var/tier = 1
	duration = 15 MINUTES
	tick_interval = STATUS_EFFECT_NO_TICK
	effectedstats = list(STAT_CONSTITUTION = 1, STAT_ENDURANCE = 1)
	alert_type = /atom/movable/screen/alert/status_effect/buff/foodbuff/tier1

/datum/status_effect/buff/foodbuff/on_apply()
	for(var/datum/status_effect/buff/foodbuff/existing in owner.status_effects)
		if(existing == src)
			continue
		if(existing.tier > tier)
			return FALSE
		qdel(existing)

	. = ..()
	if(!.)
		return FALSE

	if(iscarbon(owner))
		var/mob/living/carbon/C = owner
		C.add_stress(/datum/stress_event/goodfood)
	return TRUE

/datum/status_effect/buff/foodbuff/tier1
	id = "food_buff_1"

/atom/movable/screen/alert/status_effect/buff/foodbuff/tier1
	name = "Decent Meal"
	desc = span_nicegreen("That was a decent meal!")
	icon_state = "foodbuff_tier1"

/datum/status_effect/buff/foodbuff/tier2
	id = "food_buff_2"
	tier = 2
	effectedstats = list(STAT_CONSTITUTION = 2, STAT_ENDURANCE = 2)
	alert_type = /atom/movable/screen/alert/status_effect/buff/foodbuff/tier2

/atom/movable/screen/alert/status_effect/buff/foodbuff/tier2
	name = "Great Meal"
	desc = span_nicegreen("That was a great meal!")
	icon_state = "foodbuff_tier2"

/datum/status_effect/buff/foodbuff/tier3
	id = "food_buff_3"
	tier = 3
	effectedstats = list(STAT_CONSTITUTION = 3, STAT_ENDURANCE = 3)
	alert_type = /atom/movable/screen/alert/status_effect/buff/foodbuff/tier3

/atom/movable/screen/alert/status_effect/buff/foodbuff/tier3
	name = "Exquisite Feast"
	desc = span_nicegreen("That was an incredible feast!")
	icon_state = "foodbuff_tier3"
