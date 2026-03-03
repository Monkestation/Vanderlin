/datum/action/cooldown/meatvine/personal/repair_walls
	name = "Repair Walls"
	desc = "Repairs all connected meatvine walls."
	personal_resource_cost = 30
	cooldown_time = 15 SECONDS
	button_icon_state = "repair_walls"

/datum/action/cooldown/meatvine/personal/repair_walls/Activate(atom/target)
	var/mob/living/simple_animal/hostile/retaliate/meatvine/mob = owner

	if(mob.personal_resource_pool < personal_resource_cost)
		to_chat(owner, span_warning("You don't have enough energy to repair walls!"))
		return FALSE

	// Find all connected walls via flood fill
	var/list/connected_walls = list()
	var/list/checked = list()
	var/list/to_check = list()

	// Start from walls adjacent to us
	for(var/obj/structure/meatvine/heavy/wall in orange(1, mob))
		to_check += wall

	while(length(to_check))
		var/obj/structure/meatvine/heavy/current = to_check[1]
		to_check -= current

		if(current in checked)
			continue

		checked += current

		// Only add damaged walls to repair list
		if(current.get_integrity() < current.max_integrity)
			connected_walls += current

		// Add adjacent walls to search (even undamaged ones for pathfinding)
		for(var/obj/structure/meatvine/heavy/wall in orange(1, current))
			if(!(wall in checked))
				to_check += wall

	if(!length(connected_walls))
		to_chat(owner, span_warning("There are no damaged walls nearby to repair!"))
		return FALSE

	for(var/obj/structure/meatvine/heavy/wall in connected_walls)
		wall.update_integrity(wall.max_integrity)
		wall.update_appearance()

	mob.visible_message(
		span_danger("[mob] pulses with energy, repairing nearby meatvine walls!"),
		span_alertalien("You channel energy to repair all connected walls.")
	)

	StartCooldown()
	return TRUE

/datum/action/cooldown/meatvine/personal/repair_walls/get_movement_target(datum/ai_controller/controller)
	var/mob/living/simple_animal/hostile/retaliate/meatvine/mob = owner

	// Find nearest damaged wall
	var/obj/structure/meatvine/heavy/nearest_wall = null
	var/min_dist = INFINITY

	for(var/obj/structure/meatvine/heavy/wall in range(15, mob))
		if(wall.get_integrity() >= wall.max_integrity)
			continue // Not damaged

		var/dist = get_dist(mob, wall)
		if(dist < min_dist)
			min_dist = dist
			nearest_wall = wall

	return nearest_wall

/datum/action/cooldown/meatvine/personal/repair_walls/get_required_range()
	return 1 // Must be adjacent to a wall

/datum/action/cooldown/meatvine/personal/repair_walls/evaluate_ai_score(datum/ai_controller/controller)
	var/mob/living/simple_animal/hostile/retaliate/meatvine/mob = owner

	// Check if there are damaged walls nearby
	var/damaged_count = 0
	for(var/obj/structure/meatvine/heavy/wall in range(15, mob))
		if(wall.get_integrity() < wall.max_integrity)
			damaged_count++

	if(damaged_count == 0)
		return 0

	// Higher score if more walls are damaged
	return min(50 + (damaged_count * 10), 100)

/datum/action/cooldown/meatvine/personal/repair_walls/ai_use_ability(datum/ai_controller/controller)
	// Just call the regular Activate since the logic is the same
	return Activate(null)
