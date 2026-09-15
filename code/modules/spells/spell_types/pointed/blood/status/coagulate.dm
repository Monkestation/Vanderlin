/datum/action/cooldown/spell/status/coagulate
	name = "Coagulate"
	desc = "Temporarily slows the movement of blood in a target to stop bleeding."
	button_icon_state = "coagulate"
	sound = 'sound/magic/PSY.ogg'

	associated_skill = /datum/attribute/skill/magic/blood
	spell_type = SPELL_BLOOD
	required_form = FORM_BLOOD
	required_technique = TECHNIQUE_ALTERATION
	heretical_spell = TRUE
	antimagic_flags = MAGIC_RESISTANCE_BLOOD
	check_flags = AB_CHECK_CONSCIOUS

	invocation_type = INVOCATION_SHOUT
	invocation = "Sanguis glacio!"

	charge_required = FALSE
	cooldown_time = 90 SECONDS
	spell_cost = 150
	spell_flags = SPELL_UNETCHABLE
	status_effect = /datum/status_effect/buff/coagulate

/datum/status_effect/buff/coagulate
	id = "coagulate_buff"
	alert_type = /atom/movable/screen/alert/status_effect/buff/coagulate
	duration = 60 SECONDS

/datum/status_effect/buff/coagulate/on_apply()
	. = ..()
	ADD_TRAIT(owner, TRAIT_SUSPENDED_BLEED, "coagulate")
	ADD_TRAIT(owner, TRAIT_BLOODLOSS_IMMUNE, "coagulate")

/datum/status_effect/buff/coagulate/on_remove()
	. = ..()
	REMOVE_TRAIT(owner, TRAIT_SUSPENDED_BLEED, "coagulate")
	REMOVE_TRAIT(owner, TRAIT_BLOODLOSS_IMMUNE, "coagulate")

// ##########################################################################################

/atom/movable/screen/alert/status_effect/buff/coagulate
	name = "Coagulation"
	desc = span_bloody("My blood is being kept in my body with magic!")
	icon_state = "coagulate"
	alert_group = ALERT_BUFF
