/datum/action/cooldown/spell/undirected/secondsight
	name = "Second Sight"
	desc = "Unveil your third eye, and let your gaze pierce through walls."
	button_icon_state = "nondetection"
	sound = 'sound/magic/secondsight.ogg'

	charge_required = FALSE
	cooldown_time = 90 SECONDS
	spell_cost = 0
	associated_skill = /datum/skill/misc/stealing // Nothing really fits here, might as well slap it onto a skill that's legendary.

/datum/action/cooldown/spell/undirected/secondsight/cast(atom/cast_on)
	. = ..()
	if(isliving(owner))
		var/mob/living/L = owner
		var/datum/status_effect/status = /datum/status_effect/buff/secondsight
		if(L.has_status_effect(status))
			L.remove_status_effect(status)
		else
			var/duration_increase = attuned_strength * 1.0 MINUTES // god damnit this shit won't compile or some shit without these. Fuck it.
			L.apply_status_effect(status, initial(status.duration) + duration_increase)

/datum/status_effect/buff/secondsight
	duration = 1 MINUTES
	alert_type = null

/datum/status_effect/buff/secondsight/on_apply()
	. = ..()
	ADD_TRAIT(owner, TRAIT_THERMAL_VISION, type)
	owner.hud_used?.plane_masters_update()

/datum/status_effect/buff/secondsight/on_remove()
	. = ..()
	REMOVE_TRAIT(owner, TRAIT_THERMAL_VISION, type)
	owner.see_invisible = SEE_INVISIBLE_LIVING
	owner.hud_used?.plane_masters_update()
