/datum/action/cooldown/spell/status/blood_sight
	name = "Blood Sight"
	desc = "Grant a target blood sight, sensing nearby blood sources."
	button_icon_state = "transfixmaster"
	sound = 'sound/magic/psydonbleeds.ogg'

	associated_skill = /datum/attribute/skill/magic/blood
	spell_type = SPELL_BLOOD
	required_form = FORM_BLOOD

	charge_time = 2 SECONDS
	charge_slowdown = 0.3
	cooldown_time = 3 MINUTES
	spell_cost = 75
	spell_flags = SPELL_RITUOS
	status_effect = /datum/status_effect/buff/blood_sight

/datum/status_effect/buff/blood_sight
	id = "blood_sight_buff"
	alert_type = /atom/movable/screen/alert/status_effect/buff/blood_sight
	effectedstats = list(STAT_PERCEPTION = 2)
	duration = 5 MINUTES

/datum/status_effect/buff/blood_sight/on_apply()
	. = ..()
	ADD_TRAIT(owner, TRAIT_THERMAL_VISION, "blood_sight")

/datum/status_effect/buff/blood_sight/on_remove()
	. = ..()
	REMOVE_TRAIT(owner, TRAIT_THERMAL_VISION, "blood_sight")

// ##########################################################################################

/atom/movable/screen/alert/status_effect/buff/blood_sight
	name = "Blood Sight"
	desc = span_bloody("I have been granted blood sight.")
	icon_state = "bloodsight"
	alert_group = ALERT_BUFF
