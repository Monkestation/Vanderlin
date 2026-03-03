//////////////Church stuff

/obj/item/handheld_bell
	name = "church bell"
	desc = "A small bell that can draw a crowd if needed."
	icon = 'icons/roguetown/items/misc.dmi'
	icon_state = "churchbell"
	throw_speed = 2
	throw_range = 5
	throwforce = 5
	damtype = BRUTE
	slot_flags = ITEM_SLOT_HIP
	force = 5
	hitsound = 'sound/items/bsmith1.ogg'
	COOLDOWN_DECLARE(bell_ring)

/obj/item/handheld_bell/attack_self(mob/user, list/modifiers)
	. = ..()
	if(!COOLDOWN_FINISHED(src, bell_ring))
		return
	playsound(src, 'sound/misc/handbell.ogg', 50, 1)

	user.visible_message("<span class='notice'>[user] rings [src].</span>", span_notice("You ring [src]."))
	for(var/mob/M in view(10, src.loc))
		if(M != user && M.client)
			to_chat(M, "<span class='notice'>You hear a small bell ringing.</span>")

	COOLDOWN_START(src, bell_ring, 4 SECONDS)

/obj/item/handheld_bell/proc/sound_bell(mob/living/user)
	user.visible_message("<span class='warning'>[user] rings the bell!</span>")
	playsound(src, 'sound/misc/handbell.ogg', 100, TRUE)
	var/turf/origin_turf = get_turf(src)

	for(var/mob/living/player in GLOB.player_list)
		if(player.stat == DEAD)
			continue
		if(isbrain(player))
			continue

		var/distance = get_dist(player, origin_turf)
		if(distance <= 7)
			continue
		var/dirtext = " to the "
		var/direction = get_dir(player, origin_turf)
		switch(direction)
			if(NORTH)
				dirtext += "north"
			if(SOUTH)
				dirtext += "south"
			if(EAST)
				dirtext += "east"
			if(WEST)
				dirtext += "west"
			if(NORTHWEST)
				dirtext += "northwest"
			if(NORTHEAST)
				dirtext += "northeast"
			if(SOUTHWEST)
				dirtext += "southwest"
			if(SOUTHEAST)
				dirtext += "southeast"
			else //Where ARE you.
				dirtext = ", although I cannot make out a direction"
		var/disttext
		switch(distance)
			if(0 to 20)
				disttext = " very close"
			if(20 to 40)
				disttext = " close"
			if(40 to 80)
				disttext = ""
			if(80 to 160)
				disttext = " far"
			else
				disttext = " very far"

		//sound played for other players
		player.playsound_local(get_turf(player), 'sound/misc/handbell.ogg', 35, FALSE, pressure_affected = FALSE)
		to_chat(player, "<span class='warning'>I hear the bell ring somewhere[disttext][dirtext]!</span>")

/obj/item/handheld_bell/getonmobprop(tag)
	. = ..()
	if(tag)
		switch(tag)
			if("gen")
				return list("shrink" = 0.4,"sx" = -1,"sy" = 0,"nx" = 11,"ny" = 1,"wx" = 0,"wy" = 1,"ex" = 4,"ey" = 0,"northabove" = 0,"southabove" = 1,"eastabove" = 1,"westabove" = 0,"nturn" = 15,"sturn" = 0,"wturn" = 0,"eturn" = 39,"nflip" = 8,"sflip" = 0,"wflip" = 0,"eflip" = 8)
			if("onbelt")
				return list("shrink" = 0.3,"sx" = -2,"sy" = -5,"nx" = 4,"ny" = -5,"wx" = 0,"wy" = -5,"ex" = 2,"ey" = -5,"nturn" = 0,"sturn" = 0,"wturn" = 0,"eturn" = 0,"nflip" = 0,"sflip" = 0,"wflip" = 0,"eflip" = 0,"northabove" = 0,"southabove" = 1,"eastabove" = 1,"westabove" = 0)

//////////Stationary Church bell

/obj/structure/bell_barrier
	name = "invisible barrier"
	desc = "An invisible barrier that prevents movement."
	icon = null
	icon_state = ""
	density = TRUE
	opacity = FALSE
	anchored = TRUE
	invisibility = INVISIBILITY_MAXIMUM

/obj/structure/stationary_bell
	name = "church bell"
	desc = "A large cast bronze bell that rings out for all to hear."
	icon = 'icons/roguetown/misc/96x96.dmi'
	icon_state = "churchbell"
	anchored = TRUE
	density = TRUE
	layer = ABOVE_MOB_LAYER
	plane = GAME_PLANE_UPPER
	COOLDOWN_DECLARE(bell_ring)

/*
	/obj/structure/stationary_bell/Initialize()
		. = ..()
		create_barriers()

	// Function to create barriers around the bell
	/obj/structure/stationary_bell/proc/create_barriers()
		for(var/direction in GLOB.cardinals)
			var/turf/adjacent_turf = get_step(src, direction)
			if((adjacent_turf) || istype(adjacent_turf, /obj/structure/bell_barrier))
				continue
			new /obj/structure/bell_barrier(adjacent_turf)
*/

/obj/structure/stationary_bell/attackby(obj/item/used_item, mob/user, list/modifiers)
	if(istype(used_item, /obj/item/weapon/mace/church))
		if(!COOLDOWN_FINISHED(src, bell_ring))
			return
		for(var/mob/M in GLOB.player_list) // @everyone
			if(M.client && M.can_hear()) // Disregard NPC's with no mind and sleeping/unconscious people
				to_chat(M, "<span class='notice'>[src] rings, echoing solemnly far and wide across the realm.</span>")
				M.playsound_local(M, 'sound/misc/bell.ogg', 50, 1)
		visible_message("<span class='notice'>[user] uses the [used_item] to ring the [src].</span>")
		COOLDOWN_START(src, bell_ring, 5 SECONDS)
	else
		return ..()

//////////Jingle Bells

/obj/item/jingle_bells
	name = "jingling bells"
	desc = "A set of small bells that jingle when shaken."
	icon = 'icons/roguetown/items/misc.dmi'
	icon_state =  "jingle_bells"
	throwforce = 5
	dropshrink = 0.5
	pickup_sound = SFX_JINGLE_BELLS
	drop_sound = SFX_JINGLE_BELLS

/obj/item/jingle_bells/Initialize()
	. = ..()
	AddComponent(/datum/component/item_equipped_movement_rustle, custom_sounds = list(SFX_JINGLE_BELLS))
