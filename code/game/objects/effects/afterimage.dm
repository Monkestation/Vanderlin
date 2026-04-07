
/obj/effect/afterimage
	icon = null
	icon_state = null
	anchored = 1
	mouse_opacity = MOUSE_OPACITY_TRANSPARENT
	var/image_color

/obj/effect/afterimage/red
	image_color = "red"

/obj/effect/afterimage/black
	image_color = "black"

/obj/effect/afterimage/richter_tackle/New()
	..()
	transform = matrix()
	pixel_x = 0
	pixel_y = 0

/obj/effect/afterimage/New(turf/loc, atom/model, fadout = 5, initial_alpha = 255, lay = CULT_OVERLAY_LAYER, pla = ABOVE_LIGHTING_PLANE)
	..()
	if(model)
		appearance = model.appearance
		invisibility = 0
		alpha = initial_alpha
		dir = model.dir
		if (image_color)
			color = image_color
		layer = lay
		plane = pla
	animate(src, alpha = 0, time = fadout)
	spawn(fadout)
		qdel(src)
