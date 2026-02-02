GLOBAL_LIST_EMPTY(boat_landmarks)
/obj/effect/landmark/boat_transfer
	name = "boat transfer point"
	desc = "Stand here to transfer between ship and island."
	icon_state = "travel"
	icon = 'icons/turf/floors.dmi'
	invisibility = 0

	var/turf/destination = null
	var/transfer_delay = 0.5 SECONDS
	var/traveller = FALSE

/obj/effect/landmark/boat_transfer/Initialize()
	. = ..()
	if(!traveller)
		LAZYADD(GLOB.boat_landmarks, src)
	else if(length(GLOB.boat_landmarks))
		var/obj/effect/landmark/boat_transfer/transfer = GLOB.boat_landmarks[1]
		destination = get_turf(transfer)
		transfer.destination = get_turf(src)

/obj/effect/landmark/boat_transfer/Destroy()
	. = ..()
	if(!traveller)
		LAZYREMOVE(GLOB.boat_landmarks, src)
	destination = null

/obj/effect/landmark/boat_transfer/attack_ghost(mob/dead/observer/user)
	if(!user.Adjacent(src))
		return
	var/turf/target_loc = destination
	if(!target_loc)
		to_chat(user, "<b>It is a dead end.</b>")
		return
	user.forceMove(target_loc)

/obj/effect/landmark/boat_transfer/attack_hand(mob/user)
	if(!isliving(user))
		return ..()
	user_try_travel(user)

/obj/effect/landmark/boat_transfer/Crossed(atom/movable/AM)
	. = ..()
	if(!isliving(AM))
		return
	var/mob/living/living = AM
	if(living.stat != CONSCIOUS)
		return
	if(living.incapacitated(IGNORE_GRAB))
		return
	// if it's in the same chain, it will actually stop a pulled thing being pulled, bandaid solution with a timer
	addtimer(CALLBACK(src, PROC_REF(user_try_travel), living), 1)

/obj/effect/landmark/boat_transfer/proc/user_try_travel(mob/living/user)
	if(!destination)
		to_chat(user, "<b>I can't find the other side.</b>")
		return
	if(!can_go(user))
		return
	var/time2go = 5 SECONDS
	if(!do_after(user, time2go, src, (IGNORE_HELD_ITEM)))
		return
	if(!can_go(user))
		return
	if(user.pulling)
		user.pulling.recent_travel = world.time
	user.recent_travel = world.time
	user.log_message("[user.mind?.key ? user.mind?.key : user.real_name] has travelled to [loc_name(destination)] from", LOG_GAME, color = "#0000ff")
	movable_travel_z_level(user, destination)
	if(!user.client)
		user.force_island_check()

/obj/effect/landmark/boat_transfer/proc/can_go(atom/movable/AM)
	. = TRUE
	if(AM.pulledby)
		return FALSE
	if(AM.recent_travel)
		if(world.time < AM.recent_travel + 15 SECONDS)
			. = FALSE

/obj/effect/landmark/boat_transfer/ship_side
	name = "travel"

/obj/effect/landmark/boat_transfer/island_side
	name = "travel"
	traveller = TRUE
