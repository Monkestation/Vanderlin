/datum/action/cooldown/spell/essence/daylight
	name = "Daylight"
	desc = "Creates a bright light that mimics natural sunlight."
	button_icon_state = "daylight"
	cast_range = 0
	point_cost = 4
	attunements = list(/datum/attunement/light)

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
