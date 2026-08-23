
/datum/status_effect/swingdelay
	id = "swingdelay"
	alert_type = /atom/movable/screen/alert/status_effect/swingdelay
	duration = 1 SECONDS
	mob_overlay_icon_state = "eff_swingdelay"
	mob_overlay_icon = 'icons/mob/mob_effects.dmi'

/datum/status_effect/swingdelay/on_apply()
	. = ..()
	owner.swing_state = TRUE

/atom/movable/screen/alert/status_effect/swingdelay
	name = "Swinging!"
	desc = "I am swinging my weapon! Why did I have the time to read this?!"
	icon = 'icons/mob/screen_alert_combat.dmi'
	icon_state = "swingdelay"

/datum/status_effect/swingdelay/penalty
	alert_type = /atom/movable/screen/alert/status_effect/swingdelay/penalty
	mob_overlay_icon_state = "eff_swingdelay_penalty"

/atom/movable/screen/alert/status_effect/swingdelay/penalty
	name = "Swinging with a penalty!"
	desc = "I am swinging my weapon! My guard is weaker! Pay attention to the screen, not here, you loon!"
	icon_state = "swingdelay_penalty"

/datum/status_effect/swingdelay/disrupt
	id = "swingdelay_disrupt"
	alert_type = /atom/movable/screen/alert/status_effect/swingdelay/disrupt
	mob_overlay_icon_state = "eff_swingdelay_cancel"
	var/is_disrupted = FALSE

/datum/status_effect/swingdelay/disrupt/on_creation(mob/living/new_owner, newdur, apply_slow = FALSE)
	if(apply_slow)
		var/spd_mod = 10 - GET_MOB_ATTRIBUTE_VALUE(new_owner, STAT_SPEED)
		effectedstats = list(STAT_SPEED = spd_mod)
	. = ..()

/datum/status_effect/swingdelay/disrupt/proc/attacked()
	owner.swing_state = FALSE
	is_disrupted = TRUE
	playsound(owner, 'sound/combat/swingdelay_disrupted.ogg', 100, TRUE)
	if(mob_visual)
		mob_visual.icon_state = "eff_swingdelay_disrupted"

/datum/status_effect/swingdelay/disrupt/proc/is_disrupted()
	return is_disrupted

/atom/movable/screen/alert/status_effect/swingdelay/disrupt
	name = "Swinging fiercely!"
	desc = "THEY WILL JAB ME AND INTERRUPT THE ATTACK YOU GOBLINBRAINED WRETCH! LOOK AT THE ENEMY!!!"
	icon_state = "swingdelay_disrupt"

/datum/status_effect/swingdelay/penalty/committed
	id = "swingdelay_committed"

/datum/status_effect/swingdelay/penalty/committed/on_creation(mob/living/new_owner, newdur, apply_slow = FALSE)
	if(apply_slow)
		var/spd_mod = 10 - GET_MOB_ATTRIBUTE_VALUE(new_owner, STAT_SPEED)
		effectedstats = list(STAT_SPEED = spd_mod)
	. = ..()
