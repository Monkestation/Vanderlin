/mob/living/Login()
	login_fade()
	..()
	//Mind updates
	sync_mind()
	mind.show_memory(src, FALSE)

	update_a_intents()
	update_damage_hud()
	update_health_hud()
//	update_tod_hud()
	update_spd()

//	if (client && (stat == DEAD))
//		client.ghostize()

	var/turf/T = get_turf(src)
	if (isturf(T))
		update_z(T.z)

	if(!funeral_login())
		log_game("[key_name(src)] on login: had an issue with funeral-checking logic.")

/mob/living/proc/login_fade()
	set waitfor = FALSE
	if(!client)
		return
	var/atom/movable/screen/F = new /atom/movable/screen/fullscreen/fade()
	client.screen += F
	sleep(40)
	if(!client)
		return
	client.screen -= F
	do_time_change()

// Handles players on login about death-related procs and notifications. Essentially a failsafe for client logouts/transfers. Called on /mob/living/Login().
/mob/living/proc/funeral_login()
	if(QDELETED(src) || QDELETED(mind))
		return FALSE
	if(!client)
		return FALSE

	if(isliving(src))
		var/mob/living/L = src
		if(L.stat >= DEAD)
			client.verbs |= /client/proc/descend
		else if(L.stat < DEAD && !L.mind.has_antag_datum(/datum/antagonist/zombie))
			client.verbs -= /client/proc/descend
	else if(isroguespirit(src))
		var/mob/living/carbon/spirit/S = src
		if(S.paid)
			to_chat(src, span_rose("My toll to travel with the Carriageman has been paid for."))
	else if(isliving(mind?.current))
		var/mob/living/L = mind.current
		if(L?.stat >= DEAD)
			client.verbs |= /client/proc/descend
			if(ishuman(L))
				var/mob/living/carbon/human/D = L
				if(D.funeral)
					to_chat(src, span_rose("My soul has found peace buried in consecrated ground."))

	return TRUE
