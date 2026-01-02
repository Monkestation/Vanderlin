
/obj/item/breach_charge
	name = "breaching charge"
	desc = "A sack of foul-smelling explosive powder designed to rip through walls."
	icon_state = "breach_charge"
	icon = 'icons/roguetown/items/misc.dmi'
	w_class = WEIGHT_CLASS_NORMAL
	grid_height = 64
	grid_width = 32
	var/detonation_time = 0 // When the charge should explode.
	var/deployed = FALSE // Is the charge placed?
	var/ignited = FALSE // Is the fuse lit?
	var/deploy_time = 5 SECONDS // Time to place the charge.
	var/defuse_time = 2 SECONDS // Time to defuse the charge.
	var/fuse_duration = 10 SECONDS // How soon after igniting does the bomb explode.
	var/aim_dir // The direction our explosion will take place.
	var/mob/detonator

/obj/item/breach_charge/afterattack(atom/movable/bomb_target, mob/user, flag)
	. = ..()

	if(!flag)
		return

	// Only works on destructable wall turfs.
	if((!iswallturf(bomb_target)  && !ismineralturf(bomb_target)) || isindestructiblewall(bomb_target))
		to_chat(user, span_warning("I can only use this on destructible walls!"))
		return

	user.visible_message(span_warning("[user] begins deploying [src]..."), \
		span_warning("I begin deploying [src]..."))

	if(do_after(user, deploy_time, target = src))
		user.visible_message(span_warning("[user] deploys [src]."), \
			span_warning("I deploy [src]."))

		user.dropItemToGround(src)
		deployed = TRUE
		icon_state = "[initial(icon_state)]_deployed"
		aim_dir = get_dir(user, bomb_target)

		// Offset sprite position towards target.
		switch(aim_dir)
			if (NORTH)
				pixel_x = base_pixel_x
				pixel_y = base_pixel_y + 8
			if (NORTHEAST)
				pixel_x = base_pixel_x + 8
				pixel_y = base_pixel_y + 8
			if (EAST)
				pixel_x = base_pixel_x + 8
				pixel_y = base_pixel_y
			if (SOUTHEAST)
				pixel_x = base_pixel_x + 8
				pixel_y = base_pixel_y - 8
			if (SOUTH)
				pixel_x = base_pixel_x + 0
				pixel_y = base_pixel_y - 8
			if (SOUTHWEST)
				pixel_x = base_pixel_x - 8
				pixel_y = base_pixel_y - 8
			if (WEST)
				pixel_x = base_pixel_x - 8
				pixel_y = base_pixel_y
			if (NORTHWEST)
				pixel_x = base_pixel_x - 8
				pixel_y = base_pixel_y + 8
		detonator = user

/obj/item/breach_charge/spark_act()
	fire_act()

/obj/item/breach_charge/fire_act(added, maxstacks)
	if(deployed && !ignited)
		visible_message(span_warning("[src] ignites!"))
		playsound(src.loc, 'sound/items/fuse.ogg', 100)
		ignited = TRUE
		detonation_time = world.time + fuse_duration
		icon_state = "[initial(icon_state)]_ignited"
		START_PROCESSING(SSobj, src)
		return TRUE
	..()

/obj/item/breach_charge/attack_hand(mob/user)
	if(deployed)
		if(ignited)
			user.visible_message(span_notice("[user] begins defusing [src]..."), \
				span_notice("I begin defusing [src]..."))
		else
			user.visible_message(span_notice("[user] begins picking up [src]..."), \
				span_notice("I begin picking up [src]..."))

		if(do_after(user, defuse_time, target = src))
			user.visible_message(span_notice("[user] picks up [src]."), \
				span_notice("I pick up [src]."))

			STOP_PROCESSING(SSobj, src)
			ignited = FALSE
			deployed = FALSE
			icon_state = initial(icon_state)
			..()
	else
		..()

/obj/item/breach_charge/process()
	if(!ignited)
		..()

	if(world.time > detonation_time)
		visible_message(span_danger("[src] detonates!"))

		var/turf/target_turf = get_step(get_turf(src), aim_dir) // The turf we are exploding.

		// If there is a destructable wall there, destroy it.
		if(iswallturf(target_turf) && !isindestructiblewall(target_turf) && !ismineralturf(target_turf))
			target_turf.ScrapeAway()

		if(ismineralturf(target_turf))
			var/turf/closed/mineral/mineral = target_turf

			var/explode_chance = 350 //we go down by 33 each time

			var/list/turfs = list()
			var/list/next_pass = list()
			for(var/turf/closed/mineral/turf in range(1, target_turf))
				turfs |= turf

			mineral.gets_drilled(detonator)

			for(var/turf/closed/mineral/mineral_turf in turfs)
				turfs -= mineral_turf
				if(prob(explode_chance))
					for(var/turf/closed/mineral/turf in range(1, mineral_turf))
						next_pass |= turf
					mineral_turf.gets_drilled(detonator)
				explode_chance -= 20

				if(!length(turfs))
					turfs = next_pass




		// Explosion is mainly for visual effect as it is ineffective at small radius, high intensity damage.
		var/exp_devi = 0
		var/exp_heavy = 1
		var/exp_light = 1
		var/exp_flash = 3
		var/explode_sound = 'sound/misc/explode/bomb.ogg'
		explosion(target_turf, exp_devi, exp_heavy, exp_light, exp_flash, soundin = explode_sound)

		playsound(target_turf, 'sound/combat/hits/onstone/stonedeath.ogg', 100, FALSE)

		qdel(src)

	..()
