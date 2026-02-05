/obj/structure/carpet
	name = "carpet"
	layer = MID_TURF_LAYER
	icon = 'icons/obj/smooth_structures/carpet_brown.dmi'
	icon_state = "carpet_brown"
	smoothing_flags = SMOOTH_BITMASK | SMOOTH_OBJ
	var/carpet_type = /obj/item/natural/carpet_fibers

/obj/structure/carpet/MouseDrop(atom/over_object, src_location, over_location, src_control, over_control, params)
	. = ..()
	var/mob/living/user = usr
	if(!istype(user) || !(user.mobility_flags & MOBILITY_PICKUP))
		return

	if(over_object == user && Adjacent(user))
		user.visible_message(span_notice("[user] starts to roll up [src]."), span_notice("You start to roll up [src]."))
		if(!do_after(user, 3 SECONDS, src))
			return

		var/turf/old_turf = get_turf(src)
		var/obj/item/natural/carpet_fibers = new carpet_type(get_turf(src))
		qdel(src)
		QUEUE_SMOOTH_NEIGHBORS(old_turf)
		user.put_in_active_hand(carpet_fibers)

/obj/structure/carpet/blue
	icon = 'icons/obj/smooth_structures/carpet_blue.dmi'
	icon_state = "carpet_blue"
	carpet_type = /obj/item/natural/carpet_fibers/blue

/obj/structure/carpet/cyan
	icon = 'icons/obj/smooth_structures/carpet_cyan.dmi'
	icon_state = "carpet_cyan"
	carpet_type = /obj/item/natural/carpet_fibers/cyan

/obj/structure/carpet/green
	icon = 'icons/obj/smooth_structures/carpet_green.dmi'
	icon_state = "carpet_green"
	carpet_type = /obj/item/natural/carpet_fibers/green

/obj/structure/carpet/purple
	icon = 'icons/obj/smooth_structures/carpet_purple.dmi'
	icon_state = "carpet_purple"
	carpet_type = /obj/item/natural/carpet_fibers/purple

/obj/structure/carpet/red
	icon = 'icons/obj/smooth_structures/carpet_red.dmi'
	icon_state = "carpet_red"
	carpet_type = /obj/item/natural/carpet_fibers/red

/obj/item/natural/bundle/carpet_roll
	name = "carpet roll"
	desc = "A roll of carpet fibers. Use it to place carpet tiles."
	icon_state = "carpetroll1"
	possible_item_intents = list(/datum/intent/use)
	force = 0
	throwforce = 0
	maxamount = 12
	color = "#8B4513"  // Brown color
	firefuel = 10 MINUTES
	resistance_flags = FLAMMABLE
	slot_flags = null
	max_integrity = 30
	w_class = WEIGHT_CLASS_SMALL
	stacktype = /obj/item/natural/carpet_fibers
	icon1step = 4
	icon2step = 8
	var/carpet_type = /obj/structure/carpet

/obj/item/natural/bundle/carpet_roll/afterattack(atom/target, mob/living/user, proximity_flag, list/modifiers)
	. = ..()
	if(!isturf(target) || !proximity_flag)
		return
	if(amount < 1)
		to_chat(user, "<span class='warning'>The carpet roll is empty!</span>")
		return

	var/turf/T = get_turf(target)
	if(!T)
		return

	// Check if there's already a carpet here thats the EXACT type
	for(var/obj/structure/carpet/C in T)
		if(C.type == carpet_type)
			to_chat(user, "<span class='warning'>There's already carpet here!</span>")
			return

	user.visible_message(span_notice("[user] starts to lay down [src]."), span_notice("You start to lay down [src]."))
	if(!do_after(user, 1 SECONDS, T))
		return

	// Place the carpet
	new carpet_type(T)
	amount--
	update_bundle()
	to_chat(user, "<span class='notice'>You unroll some carpet.</span>")

	if(amount <= 0)
		qdel(src)

/obj/item/natural/carpet_fibers
	name = "carpet"
	desc = "Singular carpet."
	icon_state = "carpet"
	color = "#8B4513"
	w_class = WEIGHT_CLASS_TINY
	bundletype = /obj/item/natural/bundle/carpet_roll
	var/carpet_type = /obj/structure/carpet

/obj/item/natural/carpet_fibers/afterattack(atom/target, mob/living/user, proximity_flag, list/modifiers)
	. = ..()
	if(!isturf(target) || !proximity_flag)
		return
	var/turf/T = get_turf(target)
	if(!T)
		return

	// Check if there's already a carpet here thats the EXACT type
	for(var/obj/structure/carpet/C in T)
		if(C.type == carpet_type)
			to_chat(user, "<span class='warning'>There's already carpet here!</span>")
			return

	user.visible_message(span_notice("[user] starts to lay down [src]."), span_notice("You start to lay down [src]."))

	if(!do_after(user, 1 SECONDS, T))
		return
	// Place the carpet
	new carpet_type(T)
	to_chat(user, "<span class='notice'>You place down some carpet.</span>")
	qdel(src)


/obj/item/natural/bundle/carpet_roll/blue
	name = "blue carpet roll"
	color = "#4169E1"
	carpet_type = /obj/structure/carpet/blue
	stacktype = /obj/item/natural/carpet_fibers/blue

/obj/item/natural/bundle/carpet_roll/cyan
	name = "cyan carpet roll"
	color = "#00FFFF"
	carpet_type = /obj/structure/carpet/cyan
	stacktype = /obj/item/natural/carpet_fibers/cyan

/obj/item/natural/bundle/carpet_roll/green
	name = "green carpet roll"
	color = "#228B22"
	carpet_type = /obj/structure/carpet/green
	stacktype = /obj/item/natural/carpet_fibers/green

/obj/item/natural/bundle/carpet_roll/purple
	name = "purple carpet roll"
	color = "#8A2BE2"
	carpet_type = /obj/structure/carpet/purple
	stacktype = /obj/item/natural/carpet_fibers/purple

/obj/item/natural/bundle/carpet_roll/red
	name = "red carpet roll"
	color = "#DC143C"
	carpet_type = /obj/structure/carpet/red
	stacktype = /obj/item/natural/carpet_fibers/red


/obj/item/natural/carpet_fibers/blue
	name = "blue carpet"
	color = "#4169E1"
	carpet_type = /obj/structure/carpet/blue
	bundletype = /obj/item/natural/bundle/carpet_roll/blue

/obj/item/natural/carpet_fibers/cyan
	name = "cyan carpet"
	color = "#00FFFF"
	carpet_type = /obj/structure/carpet/cyan
	bundletype = /obj/item/natural/bundle/carpet_roll/cyan

/obj/item/natural/carpet_fibers/green
	name = "green carpet"
	color = "#228B22"
	carpet_type = /obj/structure/carpet/green
	bundletype = /obj/item/natural/bundle/carpet_roll/green

/obj/item/natural/carpet_fibers/purple
	name = "purple carpet"
	color = "#8A2BE2"
	carpet_type = /obj/structure/carpet/purple
	bundletype = /obj/item/natural/bundle/carpet_roll/purple

/obj/item/natural/carpet_fibers/red
	name = "red carpet"
	color = "#DC143C"
	carpet_type = /obj/structure/carpet/red
	bundletype = /obj/item/natural/bundle/carpet_roll/red

// Technically carpets
/obj/structure/giantfur
	name = "giant fur"
	desc = "Pelt of some gigantic animal, made into a mat."
	icon = 'icons/roguetown/misc/96x96.dmi'
	icon_state = "fur"
	density = FALSE
	anchored = TRUE

/obj/structure/giantfur/small // the irony
	name = "fur pelt"
	desc = "Pelt of a young animal, made into a mat."
	icon_state = "fur_alt"

/obj/structure/giantfur/smaller
	name = "fur pelt"
	desc = "Pelt of some foreign creachur."
	icon_state = "fur_alt2"
