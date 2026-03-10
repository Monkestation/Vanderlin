/datum/action/cooldown/spell/undirected/hunters_grace
	name = "Hunter's Grace"
	desc = "Grant yourself and any creatures adjacent to you free movement through rough terrain."
	button_icon_state = "bush_jaunt"

	point_cost = 1
	attunements = list(
		/datum/attunement/aeromancy = 0.8,
	)

	spell_type = SPELL_MIRACLE
	antimagic_flags = MAGIC_RESISTANCE_HOLY

	invocation = "Walk unopposed."
	invocation_type = INVOCATION_WHISPER

	charge_time = 4 SECONDS
	charge_drain = 0
	charge_slowdown = 0.3
	cooldown_time = 60 SECONDS
	spell_cost = 50

/datum/action/cooldown/spell/undirected/hunters_grace/cast(atom/cast_on)
	. = ..()
	owner.visible_message(
		span_notice("[owner] mutters an incantation and a dim pulse of light radiates out from them."),
		span_notice("I mutter the incantation and a dim pulse of light radiates out from me."),
	)

	var/duration_increase = max(0, attuned_strength * 2 MINUTES)
	for(var/mob/living/L in viewers(1, owner))
		L.apply_status_effect(/datum/status_effect/buff/hunters_grace, duration_increase)

/datum/status_effect/buff/hunters_grace
	id = "hunters_grace"
	alert_type = /atom/movable/screen/alert/status_effect/buff/hunters_grace
	duration = 5 MINUTES

/datum/status_effect/buff/hunters_grace/on_apply()
	. = ..()
	ADD_TRAIT(owner, TRAIT_LONGSTRIDER, MAGIC_TRAIT)

/datum/status_effect/buff/hunters_grace/on_remove()
	. = ..()
	REMOVE_TRAIT(owner, TRAIT_LONGSTRIDER, MAGIC_TRAIT)

/atom/movable/screen/alert/status_effect/buff/hunters_grace
	name = "Hunter's Grace"
	desc = span_nicegreen("I can easily walk through rough terrain.")
	icon_state = "buff"
