
/obj/structure/fluff/testportal
	name = "portal"
	icon_state = "shitportal"
	icon = 'icons/roguetown/misc/structure.dmi'
	density = FALSE
	anchored = TRUE
	layer = BELOW_MOB_LAYER
	resistance_flags = INDESTRUCTIBLE
	var/aportalloc = "a"

/obj/structure/fluff/testportal/Initialize()
	LAZYADD(GLOB.testportals, src)
	return ..()

/obj/structure/fluff/testportal/Destroy()
	. = ..()
	LAZYREMOVE(GLOB.testportals, src)

/obj/structure/fluff/testportal/attack_hand(mob/user)
	var/fou
	for(var/obj/structure/fluff/testportal/T in shuffle(GLOB.testportals))
		if(T.aportalloc == aportalloc)
			if(T == src)
				continue
			to_chat(user, "<b>I teleport to [T].</b>")
			playsound(src, 'sound/misc/portal_enter.ogg', 100, TRUE)
			user.forceMove(T.loc)
			fou = TRUE
			break
	if(!fou)
		to_chat(user, "<b>There is no portal connected to this. Report it as a bugs.</b>")
	. = ..()


/obj/structure/fluff/traveltile
	name = "travel"
	icon_state = "travel"
	icon = 'icons/turf/floors.dmi'
	density = FALSE
	anchored = TRUE
	layer = ABOVE_OPEN_TURF_LAYER
	resistance_flags = INDESTRUCTIBLE
	var/aportalid = "REPLACETHIS"
	var/aportalgoesto = "REPLACETHIS"
	var/aallmig
	var/required_trait = null
	var/can_gain_with_sight = FALSE
	var/can_gain_by_walking = FALSE
	var/check_other_side = FALSE
	var/list/revealed_to = list()

/obj/structure/fluff/traveltile/Initialize()
	GLOB.traveltiles += src
	hide_if_needed()
	. = ..()

/obj/structure/fluff/traveltile/Destroy()
	GLOB.traveltiles -= src
	. = ..()

/obj/structure/fluff/traveltile/proc/hide_if_needed()
	if(required_trait)
		invisibility = INVISIBILITY_OBSERVER
		var/image/I = image(icon = 'icons/turf/floors.dmi', icon_state = "travel", layer = ABOVE_OPEN_TURF_LAYER, loc = src)
		add_alt_appearance(/datum/atom_hud/alternate_appearance/basic/traveltile, required_trait, I)

/obj/structure/fluff/traveltile/proc/get_other_end_turf(return_travel = FALSE)
	if(!aportalgoesto)
		return null
	for(var/obj/structure/fluff/traveltile/travel in shuffle(GLOB.traveltiles))
		if(travel == src)
			continue
		if(travel.aportalid != aportalgoesto)
			continue
		if(return_travel)
			return travel
		return get_turf(travel)
	return null

/obj/structure/fluff/traveltile/proc/return_connected_turfs()
	if(!aportalgoesto)
		return list()

	var/list/travels = list()
	for(var/obj/structure/fluff/traveltile/travel in shuffle(GLOB.traveltiles))
		if(travel == src)
			continue
		if(travel.aportalid != aportalgoesto)
			continue
		travels |= get_turf(travel)
	return travels

/obj/structure/fluff/traveltile/attack_ghost(mob/dead/observer/user)
	if(!user.Adjacent(src))
		return
	var/turf/target_loc = get_other_end_turf()
	if(!target_loc)
		to_chat(user, "<b>It is a dead end.</b>")
		return
	user.forceMove(target_loc)

/obj/structure/fluff/traveltile/attack_hand(mob/user)
	if(!isliving(user))
		return ..()
	user_try_travel(user)

/obj/structure/fluff/traveltile/proc/can_go(atom/movable/AM)
	. = TRUE
	if(AM.pulledby)
		return FALSE
	if(AM.recent_travel)
		if(world.time < AM.recent_travel + 15 SECONDS)
			. = FALSE
	if(. && required_trait && isliving(AM))
		var/mob/living/L = AM
		if(HAS_TRAIT(L, required_trait))
			return TRUE
		else
			//to_chat(L, "<b>It is a dead end.</b>")
			return FALSE

/atom/movable
	var/recent_travel = 0

/obj/structure/fluff/traveltile/Crossed(atom/movable/AM)
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

/obj/structure/fluff/traveltile/proc/user_try_travel(mob/living/user)
	var/obj/structure/fluff/traveltile/the_tile = get_other_end_turf(TRUE)
	if(!get_turf(the_tile))
		to_chat(user, "<b>I can't find the other side.</b>")
		return
	if(!can_go(user))
		return
	var/time2go = 5 SECONDS
	if(check_other_side && the_tile.required_trait)
		for(var/mob/living/M in hearers(7, get_turf(the_tile)))
			if(!HAS_TRAIT(M, the_tile.required_trait))
				to_chat(user, span_warning("I sense something off at the end of the trail."))
				time2go = 7 SECONDS
				break
	if(!do_after(user, time2go, src, (IGNORE_HELD_ITEM)))
		return
	if(!can_go(user))
		return
	if(user.pulling)
		user.pulling.recent_travel = world.time
	user.recent_travel = world.time
	if(can_gain_with_sight)
		reveal_travel_trait_to_others(user)
	if(can_gain_by_walking && the_tile.required_trait && !HAS_TRAIT(user, the_tile.required_trait) && !HAS_TRAIT(user, TRAIT_BLIND)) // If you're blind you can't find your way
		ADD_TRAIT(user, the_tile.required_trait, TRAIT_GENERIC)
	if(required_trait && !revealed_to.Find(user))
		show_travel_tile(user)
		the_tile.show_travel_tile(user)
	user.log_message("[user.mind?.key ? user.mind?.key : user.real_name] has travelled to [loc_name(the_tile)] from", LOG_GAME, color = "#0000ff")
	movable_travel_z_level(user, get_turf(the_tile))

/obj/structure/fluff/traveltile/proc/reveal_travel_trait_to_others(mob/living/user)
	if(!required_trait)
		return
	if(!HAS_TRAIT(user, required_trait))
		return
	for(var/mob/living/carbon/human/H in view(6,src))
		if(!HAS_TRAIT(H, required_trait) && !HAS_TRAIT(H, TRAIT_BLIND))
			to_chat(H, "<b>I discover a well hidden entrance</b>")
			ADD_TRAIT(H, required_trait, TRAIT_GENERIC)

/obj/structure/fluff/traveltile/proc/show_travel_tile(mob/living/user)
	if(!alternate_appearances)
		return
	for(var/K in alternate_appearances)
		var/datum/atom_hud/alternate_appearance/AA = alternate_appearances[K]
		if(AA.appearance_key == required_trait)
			AA.add_hud_to(user)
			revealed_to += user
			break

/obj/structure/fluff/traveltile/proc/remove_travel_tile(mob/living/user)
	if(!alternate_appearances)
		return
	for(var/K in alternate_appearances)
		var/datum/atom_hud/alternate_appearance/AA = alternate_appearances[K]
		if(AA.appearance_key == required_trait)
			AA.remove_from_hud(user)
			revealed_to -= user
			break
