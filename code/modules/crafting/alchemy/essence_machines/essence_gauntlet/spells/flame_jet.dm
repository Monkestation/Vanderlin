/datum/action/cooldown/spell/essence/flame_jet
	name = "Flame Jet"
	desc = "Creates a controlled jet of flame for precise heating or light welding."
	button_icon_state = "flame_jet"
	cast_range = 2
	point_cost = 6
	attunements = list(/datum/attunement/fire, /datum/attunement/aeromancy)

/datum/action/cooldown/spell/essence/flame_jet/cast(atom/cast_on)
	. = ..()
	var/turf/target_turf = get_turf(cast_on)
	if(!target_turf)
		return FALSE
	owner.visible_message(span_notice("[owner] creates a precise jet of flame."))

	var/obj/effect/temp_visual/flame_jet/jet = new(target_turf)
	jet.set_light(5, 5, 2, l_color = "#f8c92e")

/obj/effect/temp_visual/flame_jet
	name = "flame jet"
	desc = "A concentrated jet of magical flame."
	icon = 'icons/effects/fire.dmi'
	icon_state = "fire"
	duration = 15 SECONDS

/obj/effect/temp_visual/flame_jet/Initialize()
	. = ..()
	propagate_temp_change(40, 12, 0.8, 2) // High heat, high weight, low falloff, very short cast_range (focused)

/obj/effect/temp_visual/flame_jet/Destroy()
	remove_temp_effect()
	return ..()

/obj/effect/temp_visual/flame_jet/Crossed(atom/movable/AM, oldLoc)
	..()
	if(isliving(AM))
		var/mob/living/L = AM
		L.fire_act(1, 20)
