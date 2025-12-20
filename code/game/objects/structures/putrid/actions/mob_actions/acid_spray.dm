/datum/action/cooldown/meatvine/personal/acid_spray
	name = "Acid Spray"
	desc = "Sprays acid in a line along the ground, covering tiles and damaging limbs. Extinguishes fires and burning allies."
	button_icon_state = "acid_spray"
	cooldown_time = 15 SECONDS
	personal_resource_cost = 15

/datum/action/cooldown/meatvine/personal/acid_spray/Activate(atom/target)
	var/mob/living/simple_animal/hostile/retaliate/meatvine/consumed = owner
	if(!istype(consumed))
		return FALSE

	var/turf/start_turf = get_turf(consumed)
	var/turf/target_turf = get_turf(target)

	if(!start_turf || !target_turf)
		return FALSE

	var/spray_range = 5
	var/list/turfs_to_spray = get_line(start_turf, target_turf)

	for(var/turf/open/T in turfs_to_spray)
		if(get_dist(start_turf, T) > spray_range)
			break
		new /obj/effect/decal/cleanable/meatvine_acid(T)

		if(T.active_hotspot)
			qdel(T.active_hotspot)

		for(var/atom/A in T)
			if(istype(A, /mob/living/simple_animal/hostile/retaliate/meatvine))
				var/mob/living/M = A
				M.ExtinguishMob()
				continue

			if(isliving(A) && !istype(A, /mob/living/simple_animal/hostile/retaliate/meatvine))
				var/mob/living/carbon/C = A
				if(istype(C))
					var/damage = 10
					C.apply_damage(damage, BRUTE, BODY_ZONE_L_LEG)
					C.apply_damage(damage, BRUTE, BODY_ZONE_R_LEG)

			if(istype(A, /obj/structure))
				var/obj/structure/S = A
				S.take_damage(15, BRUTE, "blunt")

	return ..()

/datum/action/cooldown/meatvine/personal/acid_spray/evaluate_ai_score(datum/ai_controller/controller)
	if(!IsAvailable())
		return 0

	var/mob/living/simple_animal/hostile/retaliate/meatvine/consumed = owner
	if(!istype(consumed))
		return 0

	var/score = 0
	var/spray_range = 5

	for(var/mob/living/simple_animal/hostile/retaliate/meatvine/ally in range(spray_range, consumed))
		if(ally.on_fire)
			score += 50

	var/mob/living/target = controller.blackboard[BB_BASIC_MOB_CURRENT_TARGET]
	if(target && get_dist(consumed, target) <= spray_range)
		if(can_hit_target_with_spray(consumed, target))
			score += 30

			var/turf/target_turf = get_turf(target)
			for(var/obj/structure/S in target_turf)
				score += 15
				break

	for(var/turf/open/T in range(spray_range, consumed))
		if(T.active_hotspot)
			score += 20
			break

	return score

/datum/action/cooldown/meatvine/personal/acid_spray/ai_use_ability(datum/ai_controller/controller)
	var/mob/living/simple_animal/hostile/retaliate/meatvine/consumed = owner
	if(!istype(consumed))
		return FALSE

	// Priority 1: Extinguish burning allies
	for(var/mob/living/simple_animal/hostile/retaliate/meatvine/ally in range(5, consumed))
		if(ally.on_fire)
			return Activate(get_turf(ally))

	// Priority 2: Spray at current target
	if(consumed.target)
		return Activate(get_turf(consumed.target))

	// Priority 3: Extinguish fires
	for(var/turf/open/T in range(5, consumed))
		if(T.active_hotspot)
			return Activate(T)

	return FALSE

/datum/action/cooldown/meatvine/personal/acid_spray/get_movement_target(datum/ai_controller/controller)
	var/mob/living/simple_animal/hostile/retaliate/meatvine/consumed = owner
	if(!istype(consumed))
		return null

	// Move toward burning allies
	for(var/mob/living/simple_animal/hostile/retaliate/meatvine/ally in range(7, consumed))
		if(ally.on_fire && get_dist(consumed, ally) > 5)
			return ally

	// Move toward target if too far
	if(consumed.target && get_dist(consumed, consumed.target) > 5)
		return consumed.target

	return null

/datum/action/cooldown/meatvine/personal/acid_spray/get_required_range()
	return 5

/datum/action/cooldown/meatvine/personal/acid_spray/proc/can_hit_target_with_spray(mob/living/shooter, mob/living/target)
	var/turf/start = get_turf(shooter)
	var/turf/end = get_turf(target)
	if(!start || !end)
		return FALSE

	var/list/line = get_line(start, end)
	return (end in line)

/obj/effect/decal/cleanable/meatvine_acid
	name = "acid pool"
	desc = "A pool of corrosive acid on the ground."
	icon = 'icons/effects/effects.dmi'
	icon_state = "acid2"
	layer = TURF_LAYER
	var/damage_per_tick = 2
	var/lifetime = 60 SECONDS

/obj/effect/decal/cleanable/meatvine_acid/Initialize()
	. = ..()
	START_PROCESSING(SSobj, src)
	QDEL_IN(src, lifetime)

/obj/effect/decal/cleanable/meatvine_acid/Destroy()
	STOP_PROCESSING(SSobj, src)
	return ..()

/obj/effect/decal/cleanable/meatvine_acid/Crossed(atom/movable/O)
	. = ..()
	var/mob/living/M = O
	if(!istype(M) || istype(M, /mob/living/simple_animal/hostile/retaliate/meatvine))
		return
	M.apply_damage(damage_per_tick, BURN, BODY_ZONE_L_LEG)
	M.apply_damage(damage_per_tick, BURN, BODY_ZONE_R_LEG)

/obj/effect/decal/cleanable/meatvine_acid/process()
	for(var/mob/living/M in loc)
		if(istype(M, /mob/living/simple_animal/hostile/retaliate/meatvine))
			continue
		M.apply_damage(damage_per_tick, BURN, BODY_ZONE_L_LEG)
		M.apply_damage(damage_per_tick, BURN, BODY_ZONE_R_LEG)
