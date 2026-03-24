// Mobs shouldn't consider their own ambush.
// This should be it's own system. Please.

GLOBAL_VAR_INIT(ambush_chance_pct, 20) // Please don't raise this over 100 admins :')
GLOBAL_VAR_INIT(ambush_mobconsider_cooldown, 2 MINUTES) // Cooldown for each individual mob being considered for an ambush

/mob/living/proc/ambushable()
	if(!mind)
		return FALSE
	if(stat) //what?
		return FALSE
	if(status_flags & GODMODE)
		return FALSE
	if(!MOBTIMER_FINISHED(src, MT_AMBUSHLAST, 5 MINUTES))
		return FALSE
	return ambushable && !HAS_TRAIT(src, TRAIT_NOAMBUSH)

/mob/living/proc/consider_ambush(always = FALSE, ignore_cooldown = FALSE, min_dist = 1, max_dist = 7)
	var/area/AR = get_area(src)
	var/datum/threat_region/TR = SSregionthreat.get_region(AR.threat_region)
	var/danger_level = DANGER_LEVEL_MODERATE // Fallback if there's no region
	if(TR)
		danger_level = TR.get_danger_level()
	if(danger_level == DANGER_LEVEL_SAFE)
		if(TR.latent_ambush == 0)
			return
		if(TR.latent_ambush <= DANGER_SAFE_LIMIT && !always) // Signal horn can dip below 10
			return
	if(TR && ((world.time - TR.last_natural_ambush_time + 1 MINUTES) < 1 MINUTES))
		return
	var/true_ambush_chance = GLOB.ambush_chance_pct
	if(TR)
		if(danger_level == DANGER_LEVEL_LOW)
			true_ambush_chance *= 0.5
		else if(danger_level == DANGER_LEVEL_DANGEROUS)
			true_ambush_chance *= 1.5
		else if(danger_level == DANGER_LEVEL_BLEAK)
			true_ambush_chance *= 2
	if(!always && prob(100 - true_ambush_chance))
		return
	if(get_will_block_ambush(src))
		return
	if(mob_timers["ambush_check"] && !ignore_cooldown)
		if(world.time < mob_timers["ambush_check"] + GLOB.ambush_mobconsider_cooldown)
			return
	mob_timers["ambush_check"] = world.time
	var/victims = 1
	var/list/victimsa = list()
	for(var/mob/living/V in view(5, src))
		if(V != src)
			if(V.ambushable())
				victims++
				victimsa += V
			if(victims > 3)
				return
	var/list/possible_targets = get_possible_ambush_spawn(min_dist, max_dist)
	if(possible_targets.len)
		mob_timers["ambushlast"] = world.time
		for(var/mob/living/V in victimsa)
			V.mob_timers["ambushlast"] = world.time
		if(TR)
			TR.reduce_latent_ambush(1) // Remove one ambush from the ambient pool
			TR.last_natural_ambush_time = world.time
		var/list/mobs_to_spawn = list()
		var/mobs_to_spawn_single = FALSE
		var/max_spawns = 3
		var/mustype = 1
		var/spawnedtype = pickweight(AR.ambush_mobs)

		// This is the part where we scale ambush difficulty based on threat. Due to how we have a mix of
		// Ambush Config and Single Mob Ambush, I use a weird scaling system:
		// Single Mob
		// Low - 1 Mob only
		// Moderate - 1 to 2 (This is REALLY moderate)
		// Dangerous - 2 to 3
		// Dire - 3 to 4
		// Ambush Difficulty Scaling:
		// Low = -1 Mob
		// Dangerous = +1 Mob
		// Dire = + 2 Mobs
		// Previous ambush system is 2 mobs, unless there's 3 victims, in which 3 mobs
		// And Ambush Config number is fixed

		if(ispath(spawnedtype, /mob/living))
			switch(danger_level)
				if(DANGER_LEVEL_SAFE) // Induced Ambush
					max_spawns = 1
				if(DANGER_LEVEL_LOW)
					max_spawns = 1
				if(DANGER_LEVEL_MODERATE)
					max_spawns = rand(1, 2) // This is lower than before, to make moderate easier to deal with
				if(DANGER_LEVEL_DANGEROUS)
					max_spawns = rand(2, 3)
				if(DANGER_LEVEL_BLEAK)
					max_spawns = rand(3, 4)
			mobs_to_spawn_single = TRUE
		else if(istype(spawnedtype, /datum/ambush_config))
			var/datum/ambush_config/A = spawnedtype
			for(var/type_path in A.mob_types)
				var/amt = A.mob_types[type_path]
				for(var/i in 1 to amt)
					mobs_to_spawn += type_path
			if(mobs_to_spawn.len > 1)
				switch(danger_level)
					if(DANGER_LEVEL_SAFE)
						var/ri = rand(1, mobs_to_spawn.len)
						mobs_to_spawn.Cut(ri, ri + 1) // Randomly remove one mob
					if(DANGER_LEVEL_LOW)
						var/ri = rand(1, mobs_to_spawn.len)
						mobs_to_spawn.Cut(ri, ri + 1) // Randomly remove one mob
					if(DANGER_LEVEL_DANGEROUS)
						mobs_to_spawn += pick(mobs_to_spawn) // Randomly add 1
					if(DANGER_LEVEL_BLEAK)
						mobs_to_spawn += pick(mobs_to_spawn) // Randomly add 2
						mobs_to_spawn += pick(mobs_to_spawn)
			max_spawns = mobs_to_spawn.len

		for(var/i in 1 to max_spawns)
			var/spawnloc = pick(possible_targets)
			if(spawnloc)
				var/mob_type
				if(mobs_to_spawn_single)
					mob_type = spawnedtype
				else
					if(!mobs_to_spawn.len)
						continue
					mob_type = mobs_to_spawn[1]
				var/mob/spawnedmob = new mob_type(spawnloc)
				if(mobs_to_spawn.len && !mobs_to_spawn_single)
					mobs_to_spawn.Cut(1, 2)
				if(istype(spawnedmob, /mob/living/simple_animal/hostile))
					var/mob/living/simple_animal/hostile/M = spawnedmob
					M.del_on_deaggro = 44 SECONDS
					M.faction += "ambush"
				if(istype(spawnedmob, /mob/living/carbon/human))
					var/mob/living/carbon/human/H = spawnedmob
					H.del_on_deaggro = 44 SECONDS
					H.last_aggro_loss = world.time
					H.faction += "ambush"
					addtimer(CALLBACK(H, PROC_REF(setup_equip_block)), 3 SECONDS)
					mustype = 2
		if(mustype == 1)
			playsound_local(src, pick('sound/misc/jumpscare (1).ogg','sound/misc/jumpscare (2).ogg','sound/misc/jumpscare (3).ogg','sound/misc/jumpscare (4).ogg'), 100)
		else
			playsound_local(src, pick('sound/misc/jumphumans (1).ogg','sound/misc/jumphumans (2).ogg','sound/misc/jumphumans (3).ogg'), 100)
		shake_camera(src, 2, 2)

/mob/living/proc/setup_equip_block()
	for(var/obj/item/clothing/clothing in contents)
		clothing.AddElement(/datum/element/faction_restricted_equip)

// Return whether a mob is blocked from being ambushed
/mob/living/proc/get_will_block_ambush()
	if(!ambushable())
		return TRUE
	var/campfires = 0
	for(var/obj/machinery/light/RF in view(5, src))
		if(RF.on)
			campfires++
	if(campfires > 0)
		return TRUE

/mob/living/proc/get_possible_ambush_spawn(min_dist = 2, max_dist = 7)
	var/list/possible_targets = list()
	for(var/obj/structure/flora/tree/RT in orange(max_dist, src))
		if(istype(RT,/obj/structure/flora/tree/stump))
			continue
		if(isturf(RT.loc) && !get_dist(RT.loc, src) < min_dist)
			possible_targets += RT.loc.get_adjacent_ambush_turfs()
	for(var/obj/structure/flora/grass/bush/RB in orange(max_dist, src))
		if(isturf(RB.loc) && !get_dist(RB.loc, src) < min_dist)
			possible_targets += RB.loc.get_adjacent_ambush_turfs()
	for(var/obj/structure/flora/newtree/RS in orange(max_dist, src))
		if(!RS.density)
			continue
		if(isturf(RS.loc) && !get_dist(RS.loc, src) < min_dist)
			possible_targets += RS.loc.get_adjacent_ambush_turfs()

	return possible_targets

/atom/proc/get_adjacent_ambush_turfs()
	var/list/adjacent = list()
	for(var/turf/AT as anything in get_adjacent_open_turfs(src))
		if(AT.is_blocked_turf(TRUE))
			continue
		adjacent += AT

	return adjacent
