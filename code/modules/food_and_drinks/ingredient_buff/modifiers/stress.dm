/datum/ingredient_buff_modifier/herb_spice
	granted_buff_type = /datum/ingredient_buff/herb_spice

/datum/ingredient_buff/herb_spice
	status_effect_type = /datum/status_effect/buff/ingredient/herb_spice
	random_choice = 0
	base_duration = 5 MINUTES

/datum/ingredient_buff/herb_spice/examine_string()
	return span_notice("Provides a positive mood boost when used as a topping.")

/datum/status_effect/buff/ingredient/herb_spice
	id = "Topping Effect: Herb & Spice Mood Boost"

/datum/status_effect/buff/ingredient/herb_spice/on_apply()
	. = ..()
	owner.add_stress(/datum/stress_event/herb_and_spice)

/datum/status_effect/buff/ingredient/herb_spice/refresh(mob/living/new_owner, duration_override, list/scaled_stats, _quality, multiplier)
	. = ..()
	owner.add_stress(/datum/stress_event/herb_and_spice)

/datum/stress_event/herb_and_spice
	stress_change = -1
	desc = span_green("I ate well spiced food!")
	timer = 5 MINUTES
