/atom/movable/proc/try_wrap_up(texture_name = "cardboard", details_name = null)
	var/obj/structure/mob_wrap/P = new /obj/structure/mob_wrap(get_turf(loc))
	P.icon_state = "deliverycrate5"

	P.add_texture(texture_name, details_name)

	forceMove(P)

	return P

/mob/living/try_wrap_up(texture_name = "cardboard", details_name = null)
	var/obj/structure/mob_wrap/P = new /obj/structure/mob_wrap(get_turf(loc))
	P.icon_state = "deliverycrate5"

	P.add_texture(texture_name, details_name)

	if(client)
		client.perspective = EYE_PERSPECTIVE
		client.eye = P

	forceMove(P)

	return P

/obj/structure/mob_wrap
	desc = "A big wrapped cocoon made of meat."
	name = "meat cocoon"
	icon = 'icons/obj/wrap.dmi'
	icon_state = "deliverycrate5"
	density = FALSE
	var/mutable_appearance/texture_overlay
	var/mutable_appearance/details
	mouse_drag_pointer = MOUSE_ACTIVE_POINTER

	max_integrity = 5
	damage_deflection = 0
	resistance_flags = CAN_BE_HIT

/obj/structure/mob_wrap/Destroy()
	dump()
	. = ..()

/obj/structure/mob_wrap/proc/dump()
	for(var/atom/movable/AM in contents)
		if(istype(AM, /obj/structure/closet))
			var/obj/structure/closet/O = AM
			O.welded = 0
		AM.forceMove(get_turf(src))

/obj/structure/mob_wrap/proc/add_texture(new_texture, new_details = null)
	cut_overlay(texture_overlay)

	if(new_texture)
		texture_overlay = mutable_appearance(icon = icon, icon_state = new_texture)
		texture_overlay.blend_mode = BLEND_MULTIPLY
		texture_overlay.filters += alpha_mask_filter(icon = icon(icon, icon_state))
	add_overlay(texture_overlay)


	cut_overlay(details)

	if(new_details)
		details = mutable_appearance(icon = icon, icon_state = new_details)

	add_overlay(details)
