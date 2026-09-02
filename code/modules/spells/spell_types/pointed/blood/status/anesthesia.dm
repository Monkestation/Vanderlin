/datum/action/cooldown/spell/status/anesthesia
	name = "Anesthesia"
	desc = "Fools the senses to alleviate pain temporarily."
	button_icon_state = "convergence"
	sound = 'sound/magic/psydonrespite.ogg'

	associated_skill = /datum/attribute/skill/magic/blood
	spell_type = SPELL_BLOOD
	required_form = FORM_BLOOD
	required_technique = TECHNIQUE_ILLUSION
	heretical_spell = TRUE
	antimagic_flags = MAGIC_RESISTANCE_BLOOD
	check_flags = AB_CHECK_CONSCIOUS

	invocation_type = INVOCATION_WHISPER
	invocation = "Sanguis torpidus"

	charge_required = FALSE
	cooldown_time = 1 MINUTES
	spell_cost = 150
	spell_flags = SPELL_UNETCHABLE
	status_effect = /datum/status_effect/buff/anesthesia

/datum/status_effect/buff/anesthesia
	id = "anesthesia_buff"
	alert_type = /atom/movable/screen/alert/status_effect/buff/anesthesia
	duration = 30 SECONDS

/datum/status_effect/buff/anesthesia/on_apply()
	. = ..()
	ADD_TRAIT(owner, TRAIT_NOPAIN, "anesthesia")
	ADD_TRAIT(owner, TRAIT_NOPAINSTUN, "anesthesia")

/datum/status_effect/buff/anesthesia/on_remove()
	. = ..()
	REMOVE_TRAIT(owner, TRAIT_NOPAIN, "anesthesia")
	REMOVE_TRAIT(owner, TRAIT_NOPAINSTUN, "anesthesia")

// ##########################################################################################

/atom/movable/screen/alert/status_effect/buff/anesthesia
	name = "Anesthesia"
	desc = span_bloody("The pain... it's gone!")
	icon_state = "stressvgood"
	alert_group = ALERT_BUFF
