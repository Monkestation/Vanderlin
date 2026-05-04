/datum/action/cooldown/spell/essence/arcane_focus
	name = "Arcane Focus"
	desc = "Creates a crystal focus that enhances magical abilities."
	button_icon_state = "rune2"
	cast_range = 0
	point_cost = 8
	attunements = list(/datum/attunement/light, /datum/attunement/earth)
	essences = list(/datum/thaumaturgical_essence/magic, /datum/thaumaturgical_essence/crystal)

/datum/action/cooldown/spell/essence/arcane_focus/cast(atom/cast_on)
	. = ..()
	owner.visible_message(span_notice("[owner] creates an arcane focusing crystal."))
	var/mob/living/L = owner
	L.apply_status_effect(/datum/status_effect/buff/arcane_focus, 600 SECONDS)

/atom/movable/screen/alert/status_effect/arcane_focus
	name = "Arcane Focus"
	desc = "Your magical abilities are enhanced."
	icon_state = "buff"

/datum/status_effect/buff/arcane_focus
	id = "arcane_focus"
	alert_type = /atom/movable/screen/alert/status_effect/arcane_focus
	duration = 600 SECONDS

/datum/status_effect/buff/arcane_focus/on_apply()
	. = ..()
	if(isliving(owner))
		var/mob/living/L = owner
		for(var/datum/action/cooldown/spell/spell in L.actions)
			spell.charge_required = FALSE
		to_chat(owner, span_notice("Your magical focus intensifies!"))

/datum/status_effect/buff/arcane_focus/on_remove()
	. = ..()
	if(isliving(owner))
		var/mob/living/L = owner
		for(var/datum/action/cooldown/spell/spell in L.actions)
			spell.charge_required = initial(spell.charge_required)
		to_chat(owner, span_notice("Your magical focus returns to normal!"))
