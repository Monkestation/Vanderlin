/datum/action/cooldown/spell/status/blood_mark
	name = "Blood Mark"
	desc = "Mark a target with blood, weakening their physical traits. The Blood Mark will also prevent divine healing upon the target for its duration."
	button_icon_state = "dream_track"
	sound = 'sound/magic/psydonbleeds.ogg'

	associated_skill = /datum/attribute/skill/magic/blood
	spell_type = SPELL_BLOOD
	required_form = FORM_BLOOD
	required_technique = TECHNIQUE_ALTERATION
	heretical_spell = TRUE
	antimagic_flags = MAGIC_RESISTANCE_BLOOD
	check_flags = AB_CHECK_CONSCIOUS

	invocation_type = INVOCATION_WHISPER
	invocation = "Sanguis nota"

	charge_required = FALSE
	cooldown_time = 3 MINUTES
	spell_cost = 200
	spell_flags = SPELL_UNETCHABLE
	status_effect = /datum/status_effect/debuff/blood_mark
	self_cast_possible = FALSE

/datum/action/cooldown/spell/status/blood_mark/is_valid_target(atom/cast_on)
	. = ..()
	if(!ishuman(cast_on))
		return FALSE
	var/mob/living/carbon/human/target = cast_on
	if(target.mind?.has_antag_datum(/datum/antagonist/vampire) || HAS_TRAIT(target, TRAIT_BLOOD_MAGE) || HAS_TRAIT(target, TRAIT_BLOOD_SORCERER))
		to_chat(owner, span_bloody("I cannot mark another Blood Mage!"))
		return FALSE
	if(target.has_status_effect(/datum/status_effect/debuff/blood_mark))
		to_chat(owner, span_bloody("[cast_on] already bears a Blood Mark!"))
		return FALSE
	if(target.has_status_effect(/datum/status_effect/debuff/revive_bloodmagic))
		to_chat(owner, span_bloody("[cast_on] already bears a Blood Curse, marking them will be pointless!"))
		return FALSE

/datum/status_effect/debuff/blood_mark
	id = "blood_mark_deb"
	alert_type = /atom/movable/screen/alert/status_effect/debuff/blood_mark
	effectedstats = list(STAT_SPEED = -2, STAT_STRENGTH = -1, STAT_CONSTITUTION = -1, STAT_ENDURANCE = -1)
	duration = 5 MINUTES

/datum/status_effect/debuff/blood_mark/on_apply()
	. = ..()
	owner.add_stress(/datum/stress_event/blood_mark)

// ##########################################################################################

/atom/movable/screen/alert/status_effect/debuff/blood_mark
	name = "Blood Marked"
	desc = span_bloody("I have been marked by blood magic.")
	icon_state = "bleed1"
	alert_group = ALERT_DEBUFF
