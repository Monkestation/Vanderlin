/datum/status_effect/debuff/lightningstruck
	id = "lightningstruck"
	alert_type = /atom/movable/screen/alert/status_effect/debuff/lightningstruck
	duration = 6 SECONDS
	effectedstats = list(STATKEY_STR = -2, STATKEY_SPD = -2, STATKEY_PER = -3, STATKEY_INT = -2)

/atom/movable/screen/alert/status_effect/debuff/lightningstruck
	name = "Lightning Struck"
	desc = "Shocked, slowed, and disoriented. I can't swing my blade or think properly."
	icon_state = "debuff"
	color = "#ffff00"

/datum/status_effect/debuff/lightningstruck/on_apply()
	. = ..()
	var/mob/living/target = owner
	target.add_movespeed_modifier(MOVESPEED_ID_LIGHTNINGSTRUCK, update=TRUE, priority=100, multiplicative_slowdown=4, movetypes=GROUND)
	target.adjust_stamina(-25)

/datum/status_effect/debuff/lightningstruck/on_remove()
	. = ..()
	var/mob/living/target = owner
	target.remove_movespeed_modifier(MOVESPEED_ID_LIGHTNINGSTRUCK, TRUE)

/datum/status_effect/debuff/lightningstruck/minor
	duration = 3 SECONDS
	effectedstats = list("speed" = -1)

/datum/status_effect/debuff/lightningstruck/minor/on_apply()
	. = ..()
	var/mob/living/target = owner
	target.add_movespeed_modifier(MOVESPEED_ID_LIGHTNINGSTRUCK, update=TRUE, priority=100, multiplicative_slowdown=1, movetypes=GROUND)

/mob/living/proc/lightning_shock(source)
	electrocute_act(1, source, 1, SHOCK_NOSTUN)
	if(!mob_timers[MT_LIGHTNING_ADAPTATION] || world.time > mob_timers[MT_LIGHTNING_ADAPTATION] + LIGHTNING_ADAPTATION_COOLDOWN)
		Immobilize(0.5 SECONDS)
		apply_status_effect(/datum/status_effect/debuff/lightningstruck)
		balloon_alert_to_viewers("<font color='#ffcc00'>shocked! (6s)</font>")
		mob_timers[MT_LIGHTNING_ADAPTATION] = world.time
		return TRUE
	var/remaining = round((mob_timers[MT_LIGHTNING_ADAPTATION] + LIGHTNING_ADAPTATION_COOLDOWN - world.time) / 10)
	balloon_alert_to_viewers("<font color='#ffcc00'>shock adapted ([remaining]s)</font>")
	return FALSE
