/datum/action/cooldown/meatvine/personal/burrow_through
	name = "Burrow Through"
	desc = "Burrow underground through walls, emerging on the other side and spreading meatvine floor in your path."
	button_icon_state = "burrow"
	cooldown_time = 45 SECONDS
	personal_resource_cost = 30
	/// Time to burrow into the ground
	var/burrow_time = 2 SECONDS
	/// Time spent underground moving
	var/underground_time = 3 SECONDS
	/// Currently burrowing
	var/is_burrowing = FALSE
	/// Maximum wall depth we can burrow through
	var/max_burrow_depth = 5

/datum/action/cooldown/meatvine/personal/burrow_through/Activate(atom/target)
	. = ..()
	if(!.)
		return FALSE

	if(!target)
		return FALSE

	if(is_burrowing)
		owner.balloon_alert(owner, "already burrowing")
		return FALSE

	var/turf/target_turf = get_turf(target)
	if(!target_turf)
		return FALSE

	// Check if target is a wall
	if(!is_blocked_turf(target_turf))
		owner.balloon_alert(owner, "must target a wall")
		return FALSE

	if(get_dist(owner, target_turf) > 4)
		owner.balloon_alert(owner, "too far from wall")
		return FALSE

	var/mob/living/simple_animal/hostile/retaliate/meatvine/consumed = owner

	var/wall_dir = get_dir(owner, target_turf)

	var/list/wall_turfs = list()
	var/turf/current_turf = target_turf
	var/turf/exit_turf = null

	// Traverse through walls up to max depth
	for(var/i in 1 to max_burrow_depth)
		if(!current_turf)
			break

		if(is_blocked_turf(current_turf))
			wall_turfs += current_turf
			current_turf = get_step(current_turf, wall_dir)
		else
			// Found a non-wall turf, this is our exit
			exit_turf = current_turf
			break

	if(!exit_turf)
		owner.balloon_alert(owner, "walls too thick")
		return FALSE

	// Check if exit turf is valid
	if(!exit_turf.Enter(owner))
		owner.balloon_alert(owner, "cannot emerge there")
		return FALSE

	is_burrowing = TRUE
	var/turf/start_turf = get_turf(owner)

	owner.visible_message(span_danger("[owner] begins burrowing into the ground!"))
	//playsound(owner, 'sound/effects/break_stone.ogg', 75, TRUE)

	animate(owner, alpha = 150, time = burrow_time)
	ADD_TRAIT(owner, TRAIT_IMMOBILIZED, "burrow")
	sleep(burrow_time)

	if(QDELETED(owner))
		is_burrowing = FALSE
		return FALSE

	if(consumed.master)
		consumed.master.spawn_spacevine_piece(start_turf, /obj/structure/meatvine/intestine_wormhole)

	owner.visible_message(span_danger("[owner] burrows underground!"))
	playsound(owner, 'sound/misc/bamf.ogg', 50, TRUE)

	// Make invisible and intangible while underground
	owner.alpha = 0
	owner.density = FALSE

	sleep(underground_time)
	REMOVE_TRAIT(owner, TRAIT_IMMOBILIZED, "burrow")

	if(QDELETED(owner))
		is_burrowing = FALSE
		return FALSE

	if(consumed.master)
		consumed.master.spawn_spacevine_piece(exit_turf, /obj/structure/meatvine/floor)

	// Move to exit location
	owner.forceMove(exit_turf)

	if(consumed.master)
		consumed.master.spawn_spacevine_piece(exit_turf, /obj/structure/meatvine/intestine_wormhole)

	owner.visible_message(span_danger("[owner] bursts out from underground!"))
	//playsound(owner, 'sound/effects/break_stone.ogg', 75, TRUE)

	owner.alpha = 255
	owner.density = TRUE
	animate(owner, alpha = 255, time = 0.5 SECONDS)

	is_burrowing = FALSE

	return TRUE

/datum/action/cooldown/meatvine/personal/burrow_through/evaluate_ai_score(datum/ai_controller/controller)
	if(is_burrowing)
		return 0

	var/mob/living/simple_animal/hostile/retaliate/meatvine/consumed = owner
	var/atom/target = controller.blackboard[BB_BASIC_MOB_CURRENT_TARGET]

	if(!target)
		return 0

	// Look for walls between us and our target
	var/turf/our_turf = get_turf(consumed)
	var/turf/target_turf = get_turf(target)

	if(!our_turf || !target_turf)
		return 0

	// Check if there's a wall adjacent to us in the direction of our target
	var/dir_to_target = get_dir(consumed, target)
	var/turf/adjacent_turf = get_step(consumed, dir_to_target)

	if(!adjacent_turf)
		return 0

	if(is_blocked_turf(adjacent_turf))
		// Check if we can actually burrow through
		var/turf/check_turf = adjacent_turf
		// Count wall depth
		for(var/i in 1 to max_burrow_depth)
			if(!check_turf)
				break

			if(is_blocked_turf(check_turf))
				check_turf = get_step(check_turf, dir_to_target)
			else
				// Found exit, this is valid
				if(check_turf.Enter(consumed))
					return 28
				break

	return 0

/datum/action/cooldown/meatvine/personal/burrow_through/ai_use_ability(datum/ai_controller/controller)
	var/mob/living/simple_animal/hostile/retaliate/meatvine/consumed = owner
	var/atom/target = controller.blackboard[BB_BASIC_MOB_CURRENT_TARGET]

	if(!target)
		return FALSE

	// Find the wall to burrow through
	var/dir_to_target = get_dir(consumed, target)
	var/turf/wall_turf = get_step(consumed, dir_to_target)

	if(!wall_turf)
		return FALSE

	return Activate(wall_turf)

/datum/action/cooldown/meatvine/personal/burrow_through/get_movement_target(datum/ai_controller/controller)
	// No movement needed, we teleport through the wall
	return null
