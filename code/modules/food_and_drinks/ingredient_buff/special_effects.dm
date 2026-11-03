/datum/ingredient_buff/ore_sight
	status_effect_type = /datum/status_effect/buff/ingredient/ore_sight
	random_choice = 5

/datum/ingredient_buff/ore_sight/examine_string()
	return span_notice("Allows you to see ores within rock when cooked with.")

/datum/status_effect/buff/ingredient/ore_sight
	id = "Ingredient Buff: Ore Sight"

/datum/status_effect/buff/ingredient/ore_sight/on_apply()
	. = ..()
	var/mob/living/carbon/C = owner
	C?.set_oresight(TRUE)

/datum/status_effect/buff/ingredient/ore_sight/on_remove()
	. = ..()
	var/mob/living/carbon/C = owner
	C?.set_oresight(FALSE)
