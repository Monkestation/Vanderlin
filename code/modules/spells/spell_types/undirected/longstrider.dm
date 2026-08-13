/datum/action/cooldown/spell/undirected/longstrider
	name = "Longstrider"
	desc = "Grant yourself and any creatures adjacent to you free movement through rough terrain."
	button_icon_state = "longstride"

	required_form = FORM_AIR
	required_technique = TECHNIQUE_ALTERATION

	invocation = "Walk unopposed."
	invocation_type = INVOCATION_WHISPER

	charge_time = 4 SECONDS
	charge_drain = 0
	charge_slowdown = 0.3
	cooldown_time = 60 SECONDS
	spell_cost = 50
	spell_flags = SPELL_RITUOS

/datum/action/cooldown/spell/undirected/longstrider/cast(atom/cast_on)
	. = ..()
	owner.visible_message(
		span_notice("[owner] mutters an incantation and a dim pulse of light radiates out from them."),
		span_notice("I mutter the incantation and a dim pulse of light radiates out from me."),
	)

	var/duration_increase = max(0, spell_magnitude_modifier * 2 MINUTES)
	for(var/mob/living/L in viewers(1, owner))
		L.apply_status_effect(/datum/status_effect/buff/longstrider, duration_increase)

/datum/status_effect/buff/longstrider
	id = "longstrider"
	alert_type = /atom/movable/screen/alert/status_effect/buff/longstrider
	duration = 5 MINUTES

/datum/status_effect/buff/longstrider/on_apply()
	. = ..()
	ADD_TRAIT(owner, TRAIT_LONGSTRIDER, MAGIC_TRAIT)

/datum/status_effect/buff/longstrider/on_remove()
	. = ..()
	REMOVE_TRAIT(owner, TRAIT_LONGSTRIDER, MAGIC_TRAIT)

/atom/movable/screen/alert/status_effect/buff/longstrider
	name = "Longstrider"
	desc = span_nicegreen("I can easily walk through rough terrain.")
	icon_state = "buff"
