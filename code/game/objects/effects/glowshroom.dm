//separate dm since hydro is getting bloated already

/obj/structure/kneestingers
	name = "kneestingers"
	desc = "They're said to glow with Dendor's wrath."
	anchored = TRUE
	opacity = 0
	density = FALSE
	icon = 'icons/roguetown/misc/foliage.dmi'
	icon_state = "glowshroom1" //replaced in New
	layer = ABOVE_NORMAL_TURF_LAYER
	max_integrity = 30
	blade_dulling = DULLING_CUT
	resistance_flags = FLAMMABLE

/obj/structure/kneestingers/Initialize()
	. = ..()
	var/turf/turf = get_turf(src)
	turf.path_weight += 50

/obj/structure/kneestingers/Destroy()
	var/turf/turf = get_turf(src)
	turf.path_weight -= 50
	. = ..()

/obj/structure/kneestingers/fire_act(added, maxstacks)
	visible_message(span_warning("[src] catches fire!"))
	var/turf/T = get_turf(src)
	qdel(src)
	new /obj/effect/hotspot(T)

/obj/structure/kneestingers/Crossed(AM as mob|obj)
	if(isliving(AM))
		var/mob/living/L = AM
		if(L.z == z)
			if(!HAS_TRAIT(L, TRAIT_KNEESTINGER_IMMUNITY))
				if(L.electrocute_act(30, src))
					L.emote("painscream")
					L.update_sneak_invis(TRUE)
					L.consider_ambush()
					if(L.throwing)
						L.throwing.finalize(FALSE)
	. = ..()

/obj/structure/kneestingers/attackby(obj/item/W, mob/user, list/modifiers)
	if(isliving(user) && W && user.z == z)
		if(W.flags_1 & CONDUCT_1)
			var/mob/living/L = user
			if(L.electrocute_act(30, src)) // The kneestingers will let you pass if you worship dendor, but they won't take your stupid ass hitting them.
				L.emote("painscream")
				L.consider_ambush()
				if(L.throwing)
					L.throwing.finalize(FALSE)
				return FALSE
	..()

/obj/structure/kneestingers/Initialize(mapload, obj/item/neuFarm/seed/newseed, mutate_stats)
	. = ..()

	set_light(1.5, 1.5, 1.5, l_color ="#d4fcac")

	if(icon_state == "glowshroom1" )
		icon_state = "glowshroom[rand(1,3)]"
		pixel_x = base_pixel_x + rand(-4, 4)
		pixel_y = base_pixel_y + rand(0,5)
	else
		pixel_x = base_pixel_x + rand(-2, 2)
		pixel_y = base_pixel_y + rand(0,2)

/obj/structure/kneestingers/temperature_expose(exposed_temperature, exposed_volume)
	if(exposed_temperature > 300)
		take_damage(5, BURN, 0, 0)

/obj/structure/kneestingers/acid_act(acidpwr, acid_volume)
	. = 1
	visible_message(span_danger("[src] melts away!"))
	var/obj/effect/decal/cleanable/molten_object/I = new (get_turf(src))
	I.desc = ""
	qdel(src)

// -------------- Decaying Kneestingers (for spells and such) -----------------------
/obj/structure/kneestingers/decaying
/obj/structure/kneestingers/decaying/Initialize()
	. = ..()
	addtimer(CALLBACK(src, PROC_REF(stingers_decay)), 5 MINUTES)
	icon_state = "glowshroom_A[rand(1,3)]"

/obj/structure/kneestingers/decaying/proc/stingers_decay()
	playsound(src,"plantcross", 100, FALSE)
	icon_state = "[icon_state]_dying"
	sleep(5)
	qdel(src)


