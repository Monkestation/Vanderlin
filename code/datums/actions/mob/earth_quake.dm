/datum/action/cooldown/mob_cooldown/earth_quake
	name = "Earth Quake"
	button_icon = 'icons/effects/effects.dmi'
	button_icon_state = "explosion"
	desc = "Quake the earth beneath you, throwing others away."
	cooldown_time = 30 SECONDS
	check_flags = null

/datum/action/cooldown/mob_cooldown/earth_quake/Activate(atom/target)
	. = ..()
	var/turf/origin = get_turf(owner)
	var/range = 3
	var/delay = 0.3
	if(!origin)
		return
	var/list/all_turfs = RANGE_TURFS(range, origin)
	for(var/sound_range = 0 to range)
		playsound(origin,'sound/misc/bamf.ogg', 100, TRUE, 10)
		for(var/turf/stomp_turf in all_turfs)
			if(get_dist(origin, stomp_turf) > sound_range)
				continue
			new /obj/effect/temp_visual/small_smoke/halfsecond(stomp_turf)
			for(var/mob/living/hit_mob in stomp_turf)
				if(hit_mob == owner || hit_mob.throwing)
					continue
				to_chat(hit_mob, span_userdanger("[owner]'s earth quake shockwave sends you flying!"))
				var/turf/thrownat = get_ranged_target_turf_direct(owner, hit_mob, owner.throw_range, rand(-10, 10))
				hit_mob.throw_at(thrownat, 8, 2, null, TRUE, force = MOVE_FORCE_OVERPOWERING)
				hit_mob.apply_damage(20, BRUTE)
				shake_camera(hit_mob, 2, 1)
			all_turfs -= stomp_turf
		sleep(delay)
		if(QDELETED(owner) || owner.stat == DEAD)
			return
