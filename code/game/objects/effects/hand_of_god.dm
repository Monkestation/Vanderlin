#define DISPLACEMENT_AMOUNT 300
#define ANIMATION_W 115
#define ANIMATION_Z 5

/obj/effect/god_hand
	name = "Hand of God"
	icon = 'icons/misc/god_hand.dmi'
	icon_state = "astrata"
	layer = GOD_HAND_LAYER
	plane = GAME_PLANE_UPPER
	pixel_z = DISPLACEMENT_AMOUNT

	var/atom/movable/thing_to_take

/obj/effect/god_hand/photorealistic
	icon_state = "photorealistic"

/obj/effect/god_hand/Initialize(mapload, atom/movable/thing_to_take)
	. = ..()
	icon_w = ANIMATION_W
	icon_z = ANIMATION_Z

	pixel_z = DISPLACEMENT_AMOUNT

	src.thing_to_take = thing_to_take
	RegisterSignal(thing_to_take, COMSIG_QDELETING, PROC_REF(on_source_deletion))
	RegisterSignal(thing_to_take, COMSIG_MOVABLE_MOVED, PROC_REF(on_source_move))
	lower_hand()

/obj/effect/god_hand/Destroy(force)
	. = ..()
	thing_to_take = null
	UnregisterSignal(thing_to_take, COMSIG_QDELETING)
	UnregisterSignal(thing_to_take, COMSIG_MOVABLE_MOVED)

/obj/effect/god_hand/proc/on_source_deletion(atom/movable/source)
	quickly_go_back()

/obj/effect/god_hand/proc/quickly_go_back()
	thing_to_take = null
	animate(src, time = 0.4 SECONDS, pixel_z = DISPLACEMENT_AMOUNT, easing = CUBIC_EASING, flags = ANIMATION_RELATIVE|ANIMATION_PARALLEL)
	QDEL_IN(src, 0.4 SECONDS)

/obj/effect/god_hand/proc/on_source_move(atom/movable/source)
	forceMove(get_turf(thing_to_take))

/obj/effect/god_hand/proc/lower_hand()
	animate(src, time = 4 SECONDS, pixel_z = -DISPLACEMENT_AMOUNT, easing = CUBIC_EASING, flags = ANIMATION_RELATIVE|ANIMATION_PARALLEL)
	addtimer(CALLBACK(src, PROC_REF(raise_thing_with_hand)), 5 SECONDS)

/obj/effect/god_hand/proc/raise_thing_with_hand()
	thing_to_take.plane = src.plane
	thing_to_take.layer = src.layer - 0.0001
	animate(src, time = 0.3 SECONDS, pixel_w = thing_to_take.pixel_w + thing_to_take.pixel_x, pixel_z = thing_to_take.pixel_z + thing_to_take.pixel_y, flags = ANIMATION_PARALLEL|ANIMATION_RELATIVE)

	if(isliving(thing_to_take))
		var/mob/living/mob_to_take = thing_to_take
		mob_to_take.emote("choke", forced = TRUE)
		mob_to_take.Immobilize(10 SECONDS)
		addtimer(CALLBACK(mob_to_take, TYPE_PROC_REF(/mob/living, emote), "scream", null, null, FALSE, TRUE), 1.5 SECONDS)

	animate(thing_to_take, time = 2 SECONDS, pixel_z = DISPLACEMENT_AMOUNT, easing = CUBIC_EASING, flags = ANIMATION_RELATIVE|ANIMATION_PARALLEL)
	animate(src, time = 2 SECONDS, pixel_z = DISPLACEMENT_AMOUNT, easing = CUBIC_EASING, flags = ANIMATION_RELATIVE|ANIMATION_PARALLEL)
	QDEL_IN(thing_to_take, 2.5 SECONDS)

/atom/movable/proc/be_taken_with_hand_of_god(typepath)
	var/type_to_use = typepath || /obj/effect/god_hand
	new type_to_use (get_turf(src), src)

#undef ANIMATION_Z
#undef ANIMATION_W
#undef DISPLACEMENT_AMOUNT
