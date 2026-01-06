/datum/action/cooldown/meatvine/personal/slow_ground
	name = "Slow Ground"
	desc = "Covers the ground in a sticky substance that slows movement."
	button_icon_state = "slow_ground"
	cooldown_time = 20 SECONDS
	personal_resource_cost = 12

/datum/action/cooldown/meatvine/personal/slow_ground/Activate(atom/target)
	var/mob/living/simple_animal/hostile/retaliate/meatvine/consumed = owner
	if(!istype(consumed))
		return FALSE

	var/turf/start_turf = get_turf(consumed)
	var/turf/target_turf = get_turf(target)

	if(!start_turf || !target_turf)
		return FALSE

	var/spray_range = 5
	var/list/turfs_to_spray = get_line(start_turf, target_turf)

	for(var/turf/T in turfs_to_spray)
		if(get_dist(start_turf, T) > spray_range)
			break

		new /obj/effect/decal/cleanable/meatvine_slow(T)

	return ..()

/datum/action/cooldown/meatvine/personal/slow_ground/evaluate_ai_score(datum/ai_controller/controller)
	if(!IsAvailable())
		return 0

	var/mob/living/simple_animal/hostile/retaliate/meatvine/consumed = owner
	if(!istype(consumed))
		return 0

	var/mob/living/target = consumed.target
	if(!target)
		return 0

	var/distance = get_dist(consumed, target)

	// Don't use if target is too close or too far
	if(distance < 2 || distance > 5)
		return 0

	var/score = 0

	var/turf/target_turf = get_turf(target)
	if(!target_turf)
		return 0

	if(can_hit_target_with_spray(consumed, target))
		score += 25

		// Bonus if target is fast (check if they have speed modifiers)
		if(distance > 3)
			score += 15 // They're maintaining distance, slow them down

		// Check if there's already slow ground near target
		var/has_slow = FALSE
		for(var/obj/effect/decal/cleanable/meatvine_slow/S in range(2, target))
			has_slow = TRUE
			break

		if(!has_slow)
			score += 20 // No slow already present
		else
			score -= 30 // Already slowed, don't waste resources

	return score

/datum/action/cooldown/meatvine/personal/slow_ground/ai_use_ability(datum/ai_controller/controller)
	var/mob/living/simple_animal/hostile/retaliate/meatvine/consumed = owner
	if(!istype(consumed))
		return FALSE

	if(!consumed.target)
		return FALSE

	var/turf/target_turf = get_turf(consumed.target)
	if(!target_turf)
		return FALSE

	var/turf/spray_target = target_turf

	return Activate(spray_target)

/datum/action/cooldown/meatvine/personal/slow_ground/get_movement_target(datum/ai_controller/controller)
	var/mob/living/simple_animal/hostile/retaliate/meatvine/consumed = owner
	if(!istype(consumed))
		return null
	var/mob/living/target = controller.blackboard[BB_BASIC_MOB_CURRENT_TARGET]
	if(target && get_dist(consumed, target) > 5)
		return target

	return null

/datum/action/cooldown/meatvine/personal/slow_ground/get_required_range()
	return 5

/datum/action/cooldown/meatvine/personal/slow_ground/proc/can_hit_target_with_spray(mob/living/shooter, mob/living/target)
	var/turf/start = get_turf(shooter)
	var/turf/end = get_turf(target)
	if(!start || !end)
		return FALSE

	var/list/line = get_line(start, end)
	return (end in line)

/obj/effect/decal/cleanable/meatvine_slow
	name = "sticky residue"
	desc = "A sticky substance that slows movement."
	icon = 'icons/effects/effects.dmi'
	icon_state = "acid_strong"
	layer = TURF_LAYER
	var/slowdown_amount = 2
	var/lifetime = 60 SECONDS

/obj/effect/decal/cleanable/meatvine_slow/Initialize()
	. = ..()
	QDEL_IN(src, lifetime)

/obj/effect/decal/cleanable/meatvine_slow/Crossed(atom/movable/AM)
	. = ..()
	if(isliving(AM))
		var/mob/living/M = AM
		if(istype(M, /mob/living/simple_animal/hostile/retaliate/meatvine))
			return
		M.add_movespeed_modifier("meatvine_slow", 2)

/obj/effect/decal/cleanable/meatvine_slow/Uncrossed(atom/movable/AM)
	. = ..()
	if(isliving(AM))
		var/mob/living/M = AM
		M.remove_movespeed_modifier("meatvine_slow")
