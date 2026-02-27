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

	if(isroguespirit(src))
		var/mob/living/carbon/spirit/spirit_mob = src
		if(spirit_mob)
			to_chat(src, span_rose("My toll to travel with the Carriageman has been paid for."))

	if(stat >= DEAD)
		if(ishuman(src))
			var/mob/living/carbon/human/human_mob = src
			if(human_mob.funeral)
				to_chat(src, span_rose("My soul has found peace buried in consecrated ground."))

	return TRUE
