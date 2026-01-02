/datum/action/cooldown/spell/essence/phase_step
	name = "Phase Step"
	desc = "Allows brief passage through solid objects."
	button_icon_state = "phase_step"
	cast_range = 0
	point_cost = 6
	attunements = list(/datum/attunement/aeromancy)
	has_visual_effects = FALSE

/datum/action/cooldown/spell/essence/phase_step/cast(atom/cast_on)
	. = ..()
	owner.visible_message(span_notice("[owner] becomes translucent momentarily."))
	var/mob/living/L = owner
	L.apply_status_effect(/datum/status_effect/buff/phase_walking, 5 SECONDS)
	new /obj/effect/temp_visual/snake/swarm(null, L)

/datum/status_effect/buff/phase_walking
	id = "phase_walking"
	alert_type = /atom/movable/screen/alert/status_effect/phase_walking
	duration = 5 SECONDS

/datum/status_effect/buff/phase_walking/on_apply()
	. = ..()
	owner.pass_flags |= PASSMOB | PASSBLOB | PASSTABLE | PASSGLASS
	owner.alpha = 128
	to_chat(owner, span_notice("You become translucent and can pass through objects."))

/datum/status_effect/buff/phase_walking/on_remove()
	. = ..()
	owner.pass_flags &= ~(PASSMOB | PASSBLOB | PASSTABLE | PASSGLASS)
	owner.alpha = 255
	to_chat(owner, span_notice("You return to solid form."))

/atom/movable/screen/alert/status_effect/phase_walking
	name = "Phase Walking"
	desc = "You can pass through solid objects."
	icon_state = "buff"
