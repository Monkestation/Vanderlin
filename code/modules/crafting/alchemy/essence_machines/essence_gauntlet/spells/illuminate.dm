/datum/action/cooldown/spell/essence/illuminate
	name = "Illuminate"
	desc = "Creates a small, temporary light source."
	button_icon_state = "light"
	//sound = 'sound/magic/staff_healing.ogg'
	cast_range = 0
	attunements = list(/datum/attunement/light)
	point_cost = 1

/datum/action/cooldown/spell/essence/illuminate/cast(atom/cast_on)
	. = ..()
	owner.visible_message(span_notice("[owner] creates a small orb of light."))
	//playsound(owner, 'sound/magic/staff_healing.ogg', 30, TRUE)

	// Create temporary light
	var/obj/effect/temp_visual/light_orb/orb = new(get_turf(owner))
	orb.set_light(3, 3, 1, l_color = "#FFFFFF")

/obj/effect/temp_visual/light_orb
	name = "light orb"
	desc = "A small, glowing orb of magical light."
	icon = 'icons/effects/effects.dmi'
	icon_state = "electricity2"
	duration = 30 SECONDS
