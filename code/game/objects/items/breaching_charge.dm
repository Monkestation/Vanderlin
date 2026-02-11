
/obj/item/breach_charge // TODO: make an actual explosive instead of an item.
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
	var/fuse_timer
	var/aim_dir // The direction our explosion will take place.
	var/mob/detonator
	var/exp_devi = 0
	var/exp_heavy = 1
	var/exp_light = 1
	var/exp_flash = 5
	var/explode_sound = 'sound/misc/explode/bomb.ogg'

/obj/item/breach_charge/afterattack(atom/movable/bomb_target, mob/user, flag, list/modifiers)
	. = ..()

	if(!flag)
		return

	// Only works on destructable wall turfs.
	if((!iswallturf(bomb_target)  && !ismineralturf(bomb_target)) || isindestructiblewall(bomb_target))
		to_chat(user, span_warning("I can only use this on destructible walls!"))
		return

	user.visible_message(span_warning("[user] begins deploying [src]..."), \
		span_warning("I begin deploying [src]..."))

	if(do_after(user, deploy_time, target = bomb_target))
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
		playsound(src, 'sound/items/fuse.ogg', 100)
		ignited = TRUE
		icon_state = "[initial(icon_state)]_ignited"
		fuse_timer = addtimer(CALLBACK(src, PROC_REF(detonate)), fuse_duration, TIMER_STOPPABLE)
		return TRUE
	..()

/obj/item/breach_charge/attack_hand(mob/user)
	if(deployed)
		if(ignited)
			user.visible_message(span_notice("[user] begins defusing [src]..."), \
				span_notice("I begin defusing [src]..."))
			if(do_after(user, defuse_time, target = src))
				defuse(user)
				return
		else
			user.visible_message(span_notice("[user] begins picking up [src]..."), \
				span_notice("I begin picking up [src]..."))

		if(do_after(user, defuse_time, target = src))
			user.visible_message(span_notice("[user] picks up [src]."), \
				span_notice("I pick up [src]."))

			deployed = FALSE
			icon_state = initial(icon_state)
			..()
	else
		..()

/obj/item/breach_charge/proc/defuse(mob/defuser)
	playsound(src, 'sound/items/firesnuff.ogg', 100, FALSE)
	ignited = FALSE
	deltimer(fuse_timer)
	fuse_timer = null
	icon_state = "[initial(icon_state)]_deployed"
	defuser.visible_message(span_notice("[defuser] defuses [src]..."), \
				span_notice("I successfully defuse [src]..."))

/obj/item/breach_charge/proc/detonate(detonator)
	var/turf/target_turf = get_step(get_turf(src), aim_dir) // The turf we are exploding.
	fuse_timer = null // too late bro
	if(isindestructiblewall(target_turf))
		defuse()
		return
	visible_message(span_danger("[src] detonates!"))
	if(iswallturf(target_turf) && !ismineralturf(target_turf))
		target_turf.ScrapeAway()
	explosion(target_turf, exp_devi, exp_heavy, exp_light, soundin = explode_sound)
	playsound(src, 'sound/combat/hits/onstone/stonedeath.ogg', 100, FALSE)
	qdel(src)
	target_turf.pollute_turf(/datum/pollutant/smoke/thicc, 100) // allways smoke AFTER explosions , or the explosion will Qdel the smoke
	if(ismineralturf(target_turf))
		var/turf/closed/mineral/original_mineral = target_turf
		var/explode_chance = 250
		var/list/turfs = list(original_mineral)
		var/list/next_pass = list()
		var/list/cardinal_dirs = list(NORTH, SOUTH, EAST, WEST)
		while(length(turfs) && explode_chance > 0)
			if(prob(explode_chance)) // choosing the next stones (if any)
				explode_chance -= 30
				for(var/turf/closed/mineral/current_rock in turfs)
					for(var/one_dir in cardinal_dirs)
						var/turf/closed/mineral/mineralio = get_step(current_rock, one_dir)
						if(mineralio && ismineralturf(mineralio))
							next_pass |= mineralio
			for(var/turf/closed/mineral/mineral_wave in turfs) // now we kill all the stones
				mineral_wave.gets_drilled(detonator)
				mineral_wave.pollute_turf(/datum/pollutant/smoke/thicc, 70)
			playsound(target_turf, 'sound/combat/hits/onstone/stonedeath.ogg', 100, FALSE)
			if(length(next_pass))
				turfs += next_pass
				next_pass.Cut()
			sleep(1)
