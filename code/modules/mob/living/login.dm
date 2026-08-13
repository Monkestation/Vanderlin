/mob/living/Login()
	. = ..()

	if(!client)
		return FALSE

	START_PROCESSING(SSclient_mobs, src)

	//Mind updates
	sync_mind()
	mind.show_memory(src, FALSE)

	update_a_intents()
	update_damage_hud()
	update_health_hud()
	update_spd()

	var/turf/T = get_turf(src)
	if (isturf(T))
		update_z(null)
		update_z(T.z)

	if(!funeral_login())
		log_game("[key_name(src)] on login: had an issue with funeral-checking logic.")

// Handles players on login about death-related procs and notifications. Essentially a failsafe for client logouts/transfers. Called on /mob/living/Login().
/mob/living/proc/funeral_login()
	if(QDELETED(src) || QDELETED(mind))
		return FALSE

	if(!client)
		return FALSE

	if(stat >= DEAD)
		if(ishuman(src))
			var/mob/living/carbon/human/human_mob = src
			if(human_mob.funeral)
				to_chat(src, span_rose("My soul has found peace buried in consecrated ground."))

	return TRUE
