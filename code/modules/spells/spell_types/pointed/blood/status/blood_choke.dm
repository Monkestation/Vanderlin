/datum/action/cooldown/spell/status/blood_choke
	name = "Choke with Blood"
	desc = "Make a target choke upon their own blood. The perfect counter to pesky mages."
	button_icon_state = "bloodheal"
	sound = 'sound/magic/psydonbleeds.ogg'

	associated_skill = /datum/attribute/skill/magic/blood
	spell_type = SPELL_BLOOD
	required_form = FORM_BLOOD
	required_technique = TECHNIQUE_DESTRUCTION
	heretical_spell = TRUE
	antimagic_flags = MAGIC_RESISTANCE_BLOOD

	invocation_type = INVOCATION_SHOUT
	invocation = "Caedis strangulo!!"

	charge_required = FALSE
	cooldown_time = 2 MINUTES
	spell_cost = 200
	spell_flags = SPELL_UNETCHABLE
	status_effect = /datum/status_effect/debuff/blood_choke
	self_cast_possible = FALSE

/datum/action/cooldown/spell/status/blood_choke/is_valid_target(atom/cast_on)
	. = ..()
	if(!ishuman(cast_on))
		return FALSE
	var/mob/living/carbon/human/target = cast_on
	if(target.has_status_effect(/datum/status_effect/debuff/blood_choke))
		to_chat(owner, span_bloody("[cast_on] is already choking!"))
		return FALSE

/datum/status_effect/debuff/blood_choke
	id = "blood_choke_deb"
	alert_type = /atom/movable/screen/alert/status_effect/debuff/blood_choke
	duration = 20 SECONDS
	tick_interval = 2 SECONDS
	var/damage_cooldown
	var/damage_per_tick = 5

/datum/status_effect/debuff/blood_choke/on_apply()
	. = ..()
	to_chat(owner, span_bloody("My throat is filling with blood! I can't breathe!"))

/datum/status_effect/debuff/blood_choke/on_remove()
	. = ..()
	to_chat(owner, span_bloody("My throat clears, I can breathe once more!"))

/datum/status_effect/debuff/blood_choke/tick(seconds_between_ticks)
	owner.emote("choke")
	owner.adjustOxyLoss(damage_per_tick)
	owner.visible_message(span_danger("[owner] chokes upon their own blood!"), \
		span_bloody("I am choking on my own blood!"), span_hear("I hear a sickening sound of pugilism!"), COMBAT_MESSAGE_RANGE)

// ##########################################################################################

/atom/movable/screen/alert/status_effect/debuff/blood_choke
	name = "Choking Blood"
	desc = span_bloody("My throat fills with blood! I cannot breathe!")
	icon_state = "stressinsane"
	alert_group = ALERT_DEBUFF
