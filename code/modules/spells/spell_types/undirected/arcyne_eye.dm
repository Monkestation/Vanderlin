/datum/action/cooldown/spell/undirected/arcyne_eye
	name = "Arcyne Eye"
	desc = "Tap into the arcyne to see what is unseen."
	button_icon_state = "transfix"
	sound = 'sound/vo/smokedrag.ogg'

	charge_required = FALSE
	cooldown_time = 15 SECONDS
	spell_cost = 0

	required_form = FORM_ARCANE

/datum/action/cooldown/spell/undirected/arcyne_eye/cast(atom/cast_on)
	. = ..()
	if(isliving(owner))
		var/mob/living/L = owner
		var/datum/status_effect/status = /datum/status_effect/buff/arcyne_eye
		if(L.has_status_effect(status))
			L.remove_status_effect(status)
		else
			var/duration_increase = spell_magnitude_modifier * 1.5 MINUTES
			L.apply_status_effect(status, initial(status.duration) + duration_increase)

/datum/status_effect/buff/arcyne_eye
	duration = 1 MINUTES
	alert_type = null

/datum/status_effect/buff/arcyne_eye/on_apply()
	. = ..()
	ADD_TRAIT(owner, TRAIT_SEE_LEYLINES, type)
	owner.see_invisible = SEE_INVISIBLE_LEYLINES
	owner.hud_used?.plane_masters_update()

/datum/status_effect/buff/arcyne_eye/on_remove()
	. = ..()
	REMOVE_TRAIT(owner, TRAIT_SEE_LEYLINES, type)
	owner.see_invisible = SEE_INVISIBLE_LIVING
	owner.hud_used?.plane_masters_update()
