/datum/action/cooldown/spell/essence/daylight
	name = "Daylight"
	desc = "Creates a bright light that mimics natural sunlight."
	button_icon_state = "conjure_dragonhide"
	cast_range = 0
	essences = list(/datum/thaumaturgical_essence/light)

/datum/action/cooldown/spell/essence/daylight/cast(atom/cast_on)
	. = ..()
	owner.visible_message(span_notice("[owner] creates a brilliant daylight orb."))
	var/obj/effect/temp_visual/daylight_orb/orb = new(get_turf(cast_on))
	orb.set_light(5, 5, 2, l_color = "#FFFFAA")

/obj/effect/temp_visual/daylight_orb
	name = "daylight orb"
	desc = "A brilliant orb of magical daylight."
	icon = 'icons/effects/effects.dmi'
	icon_state = "impact_laser"
	duration = 1 HOURS

/datum/action/cooldown/spell/essence/daylight/spell
	name =  "Daylight Orb"
	charge_required = TRUE
	charge_time = 5 SECONDS
	spell_cost = 40
	spell_type = SPELL_MANA

	required_form = FORM_FIRE
	required_technique = TECHNIQUE_CREATION
