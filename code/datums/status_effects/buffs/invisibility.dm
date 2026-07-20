/*
 * Handles traditional invisibility given from spells or potions.
 * We don't use mob.invisibility here on purpose,
 * because it risks being overridden by other systems.
 */

/datum/status_effect/invisibility
	id = "invisibility"
	status_type = STATUS_EFFECT_REFRESH
	tick_interval = STATUS_EFFECT_NO_TICK
	duration = 30 SECONDS
	on_remove_on_mob_delete = TRUE
	alert_type = /atom/movable/screen/alert/status_effect/invisible

/datum/status_effect/invisibility/on_apply()
	. = ..()
	ADD_TRAIT(owner, TRAIT_IMPERCEPTIBLE, id)

	// don't show a message to other people if we're sneaking
	var/viewing_message = owner.rogue_sneaking ? null : span_warning("[owner] fades into nothing!")
	owner.visible_message( \
		viewing_message, \
		span_notice("My form fades away.") \
	)
	animate(owner, alpha = 0, time = 1 SECONDS, easing = EASE_IN)

/datum/status_effect/invisibility/on_remove()
	if(QDELETED(owner))
		return

	. = ..()
	REMOVE_TRAIT(owner, TRAIT_IMPERCEPTIBLE, id)

	owner.update_sneak_invis()
	if(owner.rogue_sneaking)
		to_chat(owner, span_notice("I blend into the shadows as my form reveals itself. I remain hidden."))
	else
		owner.visible_message( \
			span_warning("[owner] appears from nothing!"), \
			span_warning("I become visible again.") \
		)

/* ------------------- */

/atom/movable/screen/alert/status_effect/invisible
	name = "Invisible"
	desc = span_info("My form bends the light around me, \
		making me imperceptible to all but the most astute observers.")
	icon_state = "buff" //pick an empty one on purpose, cause we're invisible
