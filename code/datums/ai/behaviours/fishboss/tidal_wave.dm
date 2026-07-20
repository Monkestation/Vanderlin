// Creates a damaging wave that travels outward from the boss
/datum/ai_behavior/fishboss_tidal_wave
	action_cooldown = 0.5 SECONDS

/datum/ai_behavior/fishboss_tidal_wave/perform(delta_time, datum/ai_controller/controller)
	. = ..()
	var/mob/living/simple_animal/hostile/boss/fishboss/boss = controller.pawn
	if(!istype(boss))
		finish_action(controller, FALSE)
		return

	boss.visible_message("<span class='warning'>[boss] swells and releases a massive tidal wave!</span>")
	// Replace with appropriate sound

	// Set cooldown
	controller.set_blackboard_key(BB_FISHBOSS_TIDAL_WAVE_COOLDOWN, world.time + 30 SECONDS)

	// Damage wave effect
	for(var/i = 1 to 3)
		INVOKE_ASYNC(src, PROC_REF(create_wave), boss, i)

	finish_action(controller, TRUE)

/datum/ai_behavior/fishboss_tidal_wave/proc/create_wave(mob/living/simple_animal/hostile/boss/fishboss/boss, wave_level)
	sleep(wave_level * 5)
	for(var/turf/T in view(wave_level, boss))
		if(prob(70))
			new /obj/effect/temp_visual/liquid_splash(T)
			for(var/mob/living/L in T)
				if(!boss.faction_check_atom(L))
					L.apply_damage(15 + (5 * wave_level), BRUTE)
					to_chat(L, "<span class='danger'>You're hit by [boss]'s tidal wave!</span>")
					L.Knockdown(2 SECONDS)
