/*	..................   Wizard Shenanigans   ................... */
/obj/structure/circle_protection
	name = "circle of protection"
	icon = 'icons/roguetown/misc/96x96.dmi'
	icon_state = "circle"
	alpha = 180
	SET_BASE_PIXEL(-32, -32)
	var/wall_type = /obj/effect/forcefield/wizard
	var/depleted

/obj/structure/circle_protection/attack_hand(mob/user)
	. = ..()
	var/mob/living/carbon/human/H = user
	if(depleted)
		to_chat(user, "<span class='notice'>The salt circle has been damaged...</span>")
		return
	if(H.virginity)
		playsound(user, 'sound/magic/timestop.ogg', 100, TRUE, -1)
		new wall_type(get_step(src, EAST),user)
		new wall_type(get_step(src, WEST),user)
		new wall_type(get_step(src, NORTH),user)
		new wall_type(get_step(src, SOUTH),user)

		new wall_type(get_step(src, NORTHEAST),user)
		new wall_type(get_step(src, NORTHWEST),user)
		new wall_type(get_step(src, SOUTHEAST),user)
		new wall_type(get_step(src, SOUTHWEST),user)

		depleted = TRUE
		alpha = 90
	else
		to_chat(user, "<span class='notice'>The magick forces are beyond your control.</span>")

/obj/structure/circle_protection/attackby(obj/item/I, mob/user, list/modifiers)
	if(istype(I, /obj/item/reagent_containers/powder/salt))
		to_chat(user, "<span class='notice'>Restoring the salt lines...</span>")
		if(do_after(user, 10 SECONDS, src))
			depleted = FALSE
			alpha = 180
			qdel(I)
	else
		return ..()
