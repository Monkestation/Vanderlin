/obj/effect/fun_balloon
	name = "fun balloon"
	desc = ""
	icon = 'icons/obj/balloons.dmi'
	icon_state = "syndballoon"
	anchored = TRUE
	var/popped = FALSE

/obj/effect/fun_balloon/Initialize()
	. = ..()
	START_PROCESSING(SSobj, src)

/obj/effect/fun_balloon/Destroy()
	SSobj.processing -= src
	. = ..()

/obj/effect/fun_balloon/process()
	if(!popped && check() && !QDELETED(src))
		popped = TRUE
		effect()
		pop()

/obj/effect/fun_balloon/proc/check()
	return FALSE

/obj/effect/fun_balloon/proc/effect()
	return

/obj/effect/fun_balloon/proc/pop()
	visible_message("<span class='notice'>[src] pops!</span>")
	playsound(src, 'sound/blank.ogg', 50, TRUE, -1)
	qdel(src)

//ATTACK GHOST IGNORING PARENT RETURN VALUE
/obj/effect/fun_balloon/attack_ghost(mob/user)
	if(!user.client || !user.client.holder || popped)
		return
	var/confirmation = alert("Pop [src]?","Fun Balloon","Yes","No")
	if(confirmation == "Yes" && !popped)
		popped = TRUE
		effect()
		pop()

/obj/effect/fun_balloon/sentience
	name = "sentience fun balloon"
	desc = ""
	var/effect_range = 3
	var/group_name = "a bunch of giant spiders"

/obj/effect/fun_balloon/sentience/effect()
	var/list/bodies = list()
	for(var/mob/living/M in range(effect_range, get_turf(src)))
		bodies += M

	var/question = "Would you like to be [group_name]?"
	var/list/candidates = pollCandidatesForMobs(question, ROLE_ASPIRANT, null, FALSE, 100, bodies)
	while(LAZYLEN(candidates) && LAZYLEN(bodies))
		var/mob/dead/observer/C = pick_n_take(candidates)
		var/mob/living/body = pick_n_take(bodies)

		to_chat(body, "<span class='warning'>My mob has been taken over by a ghost!</span>")
		message_admins("[key_name_admin(C)] has taken control of ([key_name_admin(body)])")
		body.ghostize(0)
		body.key = C.key
		new /obj/effect/temp_visual/gravpush(get_turf(body))

/obj/effect/fun_balloon/scatter
	name = "scatter fun balloon"
	desc = ""
	var/effect_range = 5

/obj/effect/fun_balloon/scatter/effect()
	for(var/mob/living/M in range(effect_range, get_turf(src)))
		var/turf/T = find_safe_turf()
		new /obj/effect/temp_visual/gravpush(get_turf(M))
		M.forceMove(T)
		to_chat(M, "<span class='notice'>Pop!</span>")
