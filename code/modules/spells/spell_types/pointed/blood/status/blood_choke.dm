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
	if(HAS_TRAIT(target, TRAIT_NOBREATH))
		return FALSE
	if(target.has_status_effect(/datum/status_effect/debuff/blood_choke))
		to_chat(owner, span_bloody("[cast_on] is already choking!"))
		return FALSE

/datum/status_effect/debuff/blood_choke
	id = "blood_choke_deb"
	alert_type = /atom/movable/screen/alert/status_effect/debuff/blood_choke
	duration = 20 SECONDS
	tick_interval = 2 SECONDS
	var/damage_cooldown
	var/damage_per_tick = 10

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

// ##########################################################################################

/datum/status_effect/debuff/blood_choke/herald
	id = "blood_choke_deb"
	alert_type = /atom/movable/screen/alert/status_effect/debuff/herald_grip
	duration = 3 MINUTES
	tick_interval = 2 SECONDS
	damage_per_tick = 10

/atom/movable/screen/alert/status_effect/debuff/herald_grip
	name = "Blood Grasp"
	desc = span_bloody("I am being throttled by dark magicks, I need to free myself!")
	icon_state = "stressinsane"
	alert_group = ALERT_DEBUFF

/atom/movable/screen/alert/status_effect/debuff/herald_grip/Click(location, control, params)
	. = ..()
	to_chat(src, span_bloody("I attempt to free myself from the grip of blood magic."))
	if(do_after(mob_viewer, 3.5 SECONDS, mob_viewer))
		if(isliving(mob_viewer))
			var/mob/living/living_user = mob_viewer
			to_chat(living_user, span_bloody("I successfully escape death's grasp!"))
			living_user.remove_status_effect(/datum/status_effect/debuff/blood_choke/herald)

/datum/action/cooldown/spell/status/blood_choke/herald
	name = "Herald's Grasp"
	learnable = FALSE
	status_effect = /datum/status_effect/debuff/blood_choke/herald
	cooldown_time = 2 MINUTES
	spell_cost = 300
