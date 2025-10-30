/datum/ai_behavior/fishboss_whirlpool
	action_cooldown = 0.5 SECONDS

/datum/ai_behavior/fishboss_whirlpool/perform(delta_time, datum/ai_controller/controller, target_key)
	. = ..()
	var/mob/living/simple_animal/hostile/boss/fishboss/boss = controller.pawn
	var/atom/target = controller.blackboard[target_key]

	if(!istype(boss) || QDELETED(target))
		finish_action(controller, FALSE)
		return

	var/turf/T = get_turf(target)
	if(!T)
		finish_action(controller, FALSE)
		return

	boss.visible_message("<span class='warning'>[boss] creates a swirling vortex of water!</span>")
	playsound(T, 'sound/misc/explode/explosion.ogg', 100, TRUE) // Replace with appropriate sound

	// Set cooldown
	controller.set_blackboard_key(BB_FISHBOSS_WHIRLPOOL_COOLDOWN, world.time + 45 SECONDS)

	// Create whirlpool object
	var/obj/effect/whirlpool/W = new(T)
	W.creator = boss
	W.duration = 10 SECONDS

	finish_action(controller, TRUE)

// Whirlpool effect
/obj/effect/whirlpool
	name = "swirling vortex"
	desc = "A powerful whirlpool pulling everything toward its center."
	icon = 'icons/obj/whirlpool.dmi'  //! Replace with appropriate icon (coder sprite used)
	icon_state = "whirlpool"  //! Replace with appropriate icon_state (coder sprite used)
	SET_BASE_PIXEL(-96, -96)
	anchored = TRUE
	layer = ABOVE_MOB_LAYER
	var/mob/creator
	var/duration = 10 SECONDS
	var/pull_range = 3
	var/damage_per_tick = 3

/obj/effect/whirlpool/Initialize()
	. = ..()
	var/matrix/resize = matrix()
	resize.Scale(0.5, 0.5)
	transform = resize
	START_PROCESSING(SSfaster_obj, src)
	QDEL_IN(src, duration)

/obj/effect/whirlpool/Destroy()
	STOP_PROCESSING(SSfaster_obj, src)
	return ..()

/obj/effect/whirlpool/process()
	for(var/mob/living/L in range(pull_range, src))
		if(creator && creator.faction_check_mob(L))
			continue

		var/dist = get_dist(src, L)
		if(dist <= 0)
			continue

		// Pull strength decreases with distance
		var/pull_strength = max(0, (pull_range - dist + 1) / 2)

		// Try to move the mob closer
		if(pull_strength > 0 && prob(pull_strength * 20))
			step_towards(L, src)

			// Apply damage if very close
			if(dist <= 1)
				L.apply_damage(damage_per_tick, BRUTE)
				to_chat(L, "<span class='danger'>The whirlpool's currents slice into you!</span>")

			// Slow down movement
			L.add_movespeed_modifier("whirlpool", 1.5)
			addtimer(CALLBACK(L, TYPE_PROC_REF(/mob/living, remove_movespeed_modifier), "whirlpool"), 1 SECONDS)
