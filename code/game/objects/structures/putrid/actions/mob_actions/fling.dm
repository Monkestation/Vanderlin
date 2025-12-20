
/datum/action/cooldown/meatvine/personal/fling
	name = "Fling"
	desc = "Fling a target 3 tiles backwards with a short stun. Deals 22 armor-piercing damage if they hit an obstacle. Requires direct sprite click."
	button_icon_state = "fling"
	cooldown_time = 7 SECONDS
	personal_resource_cost = 0
	var/fling_distance = 3
	var/fling_speed = 2
	var/collision_damage = 22
	var/stun_duration = 1.5 SECONDS

/datum/action/cooldown/meatvine/personal/fling/IsAvailable()
	. = ..()
	if(!.)
		return FALSE

	var/mob/living/simple_animal/hostile/retaliate/meatvine/user = owner
	if(!istype(user))
		return FALSE

	// Can't fling while lying down or immobilized
	if(user.body_position == LYING_DOWN || HAS_TRAIT(user, TRAIT_IMMOBILIZED))
		return FALSE

	return TRUE

/datum/action/cooldown/meatvine/personal/fling/Activate(atom/target)
	var/mob/living/simple_animal/hostile/retaliate/meatvine/user = owner
	if(!istype(user))
		return FALSE

	// Must target a living creature
	if(!isliving(target))
		to_chat(user, span_warning("You must target a living creature!"))
		return FALSE

	var/mob/living/victim = target

	// Check if adjacent
	if(!user.Adjacent(victim))
		to_chat(user, span_warning("Target must be adjacent!"))
		return FALSE

	// Check if target can be flung (not too heavy, not anchored, etc)
	if(victim.anchored)
		to_chat(user, span_warning("[victim] is anchored and cannot be flung!"))
		return FALSE

	// Face the target
	user.face_atom(victim)

	// Execute the fling
	perform_fling(victim)

	. = ..()
	return TRUE

/datum/action/cooldown/meatvine/personal/fling/proc/perform_fling(mob/living/victim)
	var/mob/living/simple_animal/hostile/retaliate/meatvine/user = owner

	// Calculate throw direction (away from user)
	var/throw_dir = get_dir(user, victim)
	var/turf/target_turf = get_ranged_target_turf(victim, throw_dir, fling_distance)

	// Visual and audio feedback
	user.visible_message(
		span_danger("[user] violently flings [victim] backwards!"),
		span_boldnotice("You fling [victim] away!")
	)

	victim.balloon_alert(victim, "flung!")
	playsound(user, 'sound/items/weapons/thudswoosh.ogg', 50, TRUE)

	victim.Knockdown(stun_duration)
	var/turf/start_turf = get_turf(victim)

	victim.throw_at(
		target_turf,
		fling_distance,
		fling_speed,
		user,
		spin = TRUE,
		callback = CALLBACK(src, PROC_REF(check_collision), victim, start_turf)
	)

/datum/action/cooldown/meatvine/personal/fling/proc/check_collision(mob/living/victim, turf/start_turf)
	if(!victim || QDELETED(victim))
		return

	var/turf/end_turf = get_turf(victim)
	var/distance_traveled = get_dist(start_turf, end_turf)
	if(distance_traveled < fling_distance)
		victim.visible_message(
			span_danger("[victim] slams into an obstacle!"),
			span_userdanger("You slam into something!")
		)

		victim.apply_damage(collision_damage, BRUTE, def_zone = null, blocked = FALSE, forced = TRUE)

		playsound(victim, 'sound/misc/meteorimpact.ogg', 40, TRUE)
		victim.add_splatter_floor()

		victim.Paralyze(0.5 SECONDS)

		var/hit_wall = FALSE
		for(var/turf/closed/wall in range(0, victim))
			hit_wall = TRUE
			break

		if(!hit_wall)
			for(var/obj/structure/S in end_turf)
				if(S.density)
					hit_wall = TRUE
					S.take_damage(10, BRUTE, "blunt", 1)
					break

		if(hit_wall)
			victim.visible_message(
				span_danger("[victim] crashes into a wall with tremendous force!"),
				span_userdanger("You crash into a wall!")
			)

/datum/action/cooldown/meatvine/personal/fling/evaluate_ai_score(datum/ai_controller/controller)
	var/mob/living/simple_animal/hostile/retaliate/meatvine/user = owner
	if(!istype(user))
		return 0

	var/mob/living/target = controller.blackboard[BB_BASIC_MOB_CURRENT_TARGET]
	if(!target)
		return 0

	// Only use if adjacent
	if(!user.Adjacent(target))
		return 0

	// High priority if there's a wall behind the target
	var/throw_dir = get_dir(user, target)
	var/turf/behind_target = get_step(target, throw_dir)

	if(istype(behind_target, /turf/closed))
		return 85 // Very high priority - guaranteed wall collision

	// Check for obstacles in throw path
	var/obstacles_in_path = 0
	var/turf/check_turf = target.loc
	for(var/i in 1 to fling_distance)
		check_turf = get_step(check_turf, throw_dir)
		if(!check_turf)
			break

		if(istype(check_turf, /turf/closed))
			obstacles_in_path++
			break

		for(var/obj/structure/S in check_turf)
			if(S.density)
				obstacles_in_path++
				break

	if(obstacles_in_path > 0)
		return 70 // High priority - likely collision

	// Medium priority for positioning/crowd control
	return 40

/datum/action/cooldown/meatvine/personal/fling/ai_use_ability(datum/ai_controller/controller)
	var/mob/living/target = controller.blackboard[BB_BASIC_MOB_CURRENT_TARGET]
	if(!target)
		return FALSE

	return Activate(target)
