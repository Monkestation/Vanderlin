#define MULTI_CONSTRUCT_NONE 0
#define MULTI_CONSTRUCT_LINE 1  // Line perpendicular to facing direction
#define MULTI_CONSTRUCT_CROSS 2  // Cross pattern
#define MULTI_CONSTRUCT_SQUARE 3  // Square pattern

/datum/action/cooldown/meatvine
	name = "Putrid Ability"
	desc = "Spread the putrid"
	button_icon = 'icons/obj/cellular/putrid_abilities.dmi'
	background_icon = 'icons/obj/cellular/putrid_abilities.dmi'
	base_background_icon_state = "button_bg"
	active_background_icon_state = "button_bg1"
	button_icon_state = "spread"
	panel = "Putrid"
	check_flags = AB_CHECK_CONSCIOUS|AB_CHECK_PHASED
	click_to_activate = TRUE
	unset_after_click = TRUE
	cooldown_time = 3 SECONDS

	var/knockback = FALSE
	var/resource_cost = 10
	var/spread_type = /obj/structure/meatvine/floor
	var/spread_range = 7
	var/multi_construct_count = 1  // How many to build at once
	var/multi_construct_pattern = MULTI_CONSTRUCT_NONE  // Pattern for multi-construction
	var/show_preview = FALSE  // Whether to show image preview
	var/image/preview_image  // The preview image
	var/list/preview_images = list()  // For multi-construction previews
	var/should_replace = FALSE

/datum/action/cooldown/meatvine/Grant(mob/granted_to)
	. = ..()
	if(!istype(src, /datum/action/cooldown/meatvine/personal))
		RegisterSignal(owner, COMSIG_MEATVINE_RESOURCE_CHANGE, PROC_REF(update_status_on_signal))

/datum/action/cooldown/meatvine/IsAvailable()
	. = ..()
	if(!.)
		return FALSE

	var/mob/living/simple_animal/hostile/retaliate/meatvine/consumed = owner
	if(!istype(consumed))
		return FALSE

	if(!consumed.master)
		return FALSE

	var/total_cost = resource_cost * multi_construct_count
	if(consumed.master.consumed_resource_pool < total_cost)
		return FALSE

	return TRUE

/datum/action/cooldown/meatvine/set_click_ability(mob/on_who)
	. = ..()
	if(!.)
		return

	if(show_preview)
		create_preview()
		RegisterSignal(owner, COMSIG_USER_MOUSE_ENTERED, PROC_REF(on_mouse_moved))
		RegisterSignal(owner, COMSIG_ATOM_MOUSE_ENTERED, PROC_REF(on_mouse_moved_pre))

/datum/action/cooldown/meatvine/unset_click_ability(mob/on_who, refund_cooldown = TRUE)
	if(show_preview)
		clear_preview()
		UnregisterSignal(owner, COMSIG_USER_MOUSE_ENTERED)
		UnregisterSignal(owner, COMSIG_ATOM_MOUSE_ENTERED)

	return ..()

/datum/action/cooldown/meatvine/proc/create_preview()
	if(!show_preview || !spread_type)
		return

	clear_preview()

	var/atom/result = spread_type
	preview_image = image(initial(result.icon), null, initial(result.icon_state), ABOVE_LIGHTING_PLANE)
	preview_image.dir = initial(result.dir)
	preview_image.color = "#00FFFF"
	preview_image.alpha = 150
	preview_image.plane = ABOVE_LIGHTING_PLANE
	preview_image.layer = FLOAT_LAYER
	preview_image.mouse_opacity = MOUSE_OPACITY_TRANSPARENT

	if(ismob(owner))
		var/mob/M = owner
		if(M.client)
			M.client.images += preview_image

/datum/action/cooldown/meatvine/proc/clear_preview()
	if(preview_image)
		if(ismob(owner))
			var/mob/M = owner
			if(M.client)
				M.client.images -= preview_image
		preview_image = null

	for(var/image/I in preview_images)
		if(ismob(owner))
			var/mob/M = owner
			if(M.client)
				M.client.images -= I
	preview_images.Cut()

/datum/action/cooldown/meatvine/proc/on_mouse_moved_pre(datum/source, atom/atom, params)
	on_mouse_moved(source, get_turf(atom), params)

/datum/action/cooldown/meatvine/proc/on_mouse_moved(datum/source, turf/turf, params)
	if(!show_preview || !preview_image)
		return

	if(!turf)
		return

	// Check if within range
	if(get_dist(owner, turf) > spread_range)
		preview_image.alpha = 50  // Dim if out of range
	else
		preview_image.alpha = 150

	// Update preview location
	preview_image.loc = turf

	// Update multi-construction previews
	update_multi_previews(turf)

/datum/action/cooldown/meatvine/proc/update_multi_previews(turf/center)
	// Clear existing multi previews
	for(var/image/I in preview_images)
		if(ismob(owner))
			var/mob/M = owner
			if(M.client)
				M.client.images -= I
	preview_images.Cut()

	if(multi_construct_pattern == MULTI_CONSTRUCT_NONE)
		return

	var/list/build_turfs = get_build_turfs(center)
	build_turfs -= center  // Don't duplicate center preview

	var/atom/result = spread_type
	for(var/turf/build_turf in build_turfs)
		var/image/I = image(initial(result.icon), build_turf, initial(result.icon_state), ABOVE_LIGHTING_PLANE)
		I.dir = initial(result.dir)
		I.color = "#00FFFF"
		I.alpha = get_dist(owner, build_turf) > spread_range ? 50 : 150
		I.plane = ABOVE_LIGHTING_PLANE
		I.layer = FLOAT_LAYER
		I.mouse_opacity = MOUSE_OPACITY_TRANSPARENT
		preview_images += I

		if(ismob(owner))
			var/mob/M = owner
			if(M.client)
				M.client.images += I

/datum/action/cooldown/meatvine/Activate(atom/target)
	var/mob/living/simple_animal/hostile/retaliate/meatvine/consumed = owner
	if(!istype(consumed) || !consumed.master)
		return FALSE

	var/turf/T = get_turf(target)
	if(!T)
		return FALSE

	// Check range
	if(get_dist(owner, T) > spread_range)
		to_chat(owner, "<span class='warning'>Too far away!</span>")
		return FALSE

	// Get all turfs to build on based on pattern
	var/list/build_turfs = get_build_turfs(T)
	if(!build_turfs.len)
		to_chat(owner, "<span class='warning'>Cannot spread there!</span>")
		return FALSE

	// Calculate total cost
	var/total_cost = resource_cost * length(build_turfs)

	// Try to spend resources
	if(!consumed.master.try_spend_resources(total_cost))
		to_chat(owner, "<span class='warning'>Not enough resources! ([consumed.master.consumed_resource_pool]/[total_cost])</span>")
		return FALSE

	// Spawn the meatvine pieces
	var/spawned_count = 0
	for(var/turf/build_turf in build_turfs)
		if(do_spread(build_turf, consumed.master))
			spawned_count++

	if(spawned_count > 0)
		to_chat(owner, "<span class='notice'>Spread complete ([spawned_count] piece\s). Resources: [consumed.master.consumed_resource_pool]/[consumed.master.consumed_resource_max]</span>")
	else
		to_chat(owner, "<span class='warning'>Failed to spread!</span>")
		// Refund resources if nothing was built
		consumed.master.consumed_resource_pool += total_cost
	. = ..()
	return TRUE

/datum/action/cooldown/meatvine/proc/get_build_turfs(turf/center)
	var/list/turfs = list()

	if(multi_construct_pattern == MULTI_CONSTRUCT_NONE)
		if(can_spread_to_turf(center))
			turfs += center
		return turfs

	// Get owner's direction for perpendicular calculations
	var/owner_dir = get_dir(owner, center)

	switch(multi_construct_pattern)
		if(MULTI_CONSTRUCT_LINE)
			// Build perpendicular to facing direction
			var/list/perpendicular_dirs = get_perpendicular_dirs(owner_dir)

			// Center piece
			if(can_spread_to_turf(center))
				turfs += center

			// Side pieces
			var/pieces_per_side = (multi_construct_count - 1) / 2
			for(var/dir in perpendicular_dirs)
				var/turf/side_turf = center
				for(var/i = 1 to pieces_per_side)
					side_turf = get_step(side_turf, dir)
					if(side_turf && can_spread_to_turf(side_turf))
						turfs += side_turf

		if(MULTI_CONSTRUCT_CROSS)
			// Build in all cardinal directions from center
			if(can_spread_to_turf(center))
				turfs += center

			var/pieces_per_arm = (multi_construct_count - 1) / 4
			for(var/dir in GLOB.cardinals)
				var/turf/arm_turf = center
				for(var/i = 1 to pieces_per_arm)
					arm_turf = get_step(arm_turf, dir)
					if(arm_turf && can_spread_to_turf(arm_turf))
						turfs += arm_turf

		if(MULTI_CONSTRUCT_SQUARE)
			// Build in a square pattern
			var/radius = round(sqrt(multi_construct_count) / 2)
			for(var/x = -radius to radius)
				for(var/y = -radius to radius)
					var/turf/square_turf = locate(center.x + x, center.y + y, center.z)
					if(square_turf && can_spread_to_turf(square_turf))
						turfs += square_turf

	return turfs

/datum/action/cooldown/meatvine/proc/get_perpendicular_dirs(facing_dir)
	switch(facing_dir)
		if(NORTH, SOUTH)
			return list(EAST, WEST)
		if(EAST, WEST)
			return list(NORTH, SOUTH)
		if(NORTHEAST, SOUTHWEST)
			return list(NORTHWEST, SOUTHEAST)
		if(NORTHWEST, SOUTHEAST)
			return list(NORTHEAST, SOUTHWEST)
	return list(NORTH, SOUTH)  // Default

/datum/action/cooldown/meatvine/proc/can_spread_to_turf(turf/T)
	if(!isfloorturf(T))
		return FALSE
	if(T.is_blocked_turf())
		return FALSE
	for(var/obj/structure/meatvine/vine in T)
		if(istype(vine, /obj/structure/meatvine/floor))
			continue
		return FALSE
	return TRUE

/datum/action/cooldown/meatvine/proc/do_spread(turf/T, obj/effect/meatvine_controller/controller)
	if(should_replace)
		for(var/obj/structure/meatvine/vine in T)
			qdel(vine)
	controller.spawn_spacevine_piece(T, spread_type)
	if(knockback)
		for(var/mob/living/bumper in T)
			if("meat" in bumper.faction)
				continue

			if(prob(bumper.get_skill_level(/datum/skill/misc/athletics, TRUE) * 15))
				return

			// Calculate knockback direction (away from structure)
			var/throw_dir = get_dir(T, bumper)
			var/turf/throw_target = get_edge_target_turf(bumper, throw_dir)

			bumper.visible_message(
				"<span class='danger'>[bumper] is violently repelled!</span>",
				"<span class='userdanger'>You are violently thrown back!</span>"
			)

			bumper.throw_at(throw_target, 3, 2)
	return TRUE

/datum/action/cooldown/meatvine/spread_floor
	name = "Spread Floor"
	desc = "Spread meatvine floor to target location. Cost: 10 resources."
	button_icon_state = "spread"
	resource_cost = 10
	spread_type = /obj/structure/meatvine/floor
	show_preview = TRUE
	should_replace = TRUE

/datum/action/cooldown/meatvine/spread_wall
	name = "Spread Wall"
	desc = "Spread meatvine wall to target location. Cost: 25 resources."
	button_icon_state = "wall"
	resource_cost = 25
	spread_type = /obj/structure/meatvine/heavy
	spread_range = 5
	show_preview = TRUE
	should_replace = TRUE

/datum/action/cooldown/meatvine/spread_wall/can_spread_to_turf(turf/T)
	var/has_adjacent = FALSE
	for(var/direction in GLOB.cardinals)
		var/turf/check = get_step(T, direction)
		if(locate(/obj/structure/meatvine) in check)
			has_adjacent = TRUE
			break
	if(locate(/obj/structure/meatvine) in T)
		has_adjacent = TRUE

	return has_adjacent

/datum/action/cooldown/meatvine/spread_wall_multi
	name = "Spread Wall Line (x3)"
	desc = "Spread 3 meatvine walls in a line perpendicular to your facing direction. Cost: 75 resources."
	button_icon_state = "wall"
	resource_cost = 25
	spread_type = /obj/structure/meatvine/heavy
	spread_range = 5
	multi_construct_count = 3
	multi_construct_pattern = MULTI_CONSTRUCT_LINE
	show_preview = TRUE
	should_replace = TRUE

/datum/action/cooldown/meatvine/spread_wall_multi/can_spread_to_turf(turf/T)
	if(!isfloorturf(T))
		return FALSE
	if(T.is_blocked_turf())
		return FALSE

	var/has_adjacent = FALSE
	for(var/direction in GLOB.cardinals)
		var/turf/check = get_step(T, direction)
		if(locate(/obj/structure/meatvine) in check)
			has_adjacent = TRUE
			break
	if(locate(/obj/structure/meatvine) in T)
		has_adjacent = TRUE

	return has_adjacent

/datum/action/cooldown/meatvine/spread_lair
	name = "Spread Lair"
	desc = "Spread meatvine lair to target location. Spawns hostile creatures. Cost: 200 resources."
	button_icon_state = "lair"
	resource_cost = 200
	spread_type = /obj/structure/meatvine/lair
	spread_range = 5
	cooldown_time = 4 MINUTES
	show_preview = TRUE

/datum/action/cooldown/meatvine/spread_lair/IsAvailable()
	. = ..()
	if(!.)
		return FALSE

	var/mob/living/simple_animal/hostile/retaliate/meatvine/consumed = owner
	if(!consumed.master)
		return FALSE

	// Check if we can spawn more lairs
	if(!consumed.master.can_spawn_lair())
		return FALSE

	return TRUE

/datum/action/cooldown/meatvine/spread_lair/can_spread_to_turf(turf/T)
	if(!..())
		return FALSE

	if(!locate(/obj/structure/meatvine/floor) in T)
		return FALSE

	var/mob/living/simple_animal/hostile/retaliate/meatvine/consumed = owner
	if(!consumed.master)
		return FALSE

	// Use controller's lair placement checks
	return consumed.master.can_spawn_lair_at(T)

/datum/action/cooldown/meatvine/spread_spike
	name = "Build Tentacle Spike"
	desc = "Build a tentacle spike on meatvine floor. Can stack up to 5 spikes on one tile. Cost: 50 resources."
	button_icon_state = "tentacle_spikes"
	resource_cost = 50
	spread_type = /obj/structure/meatvine/tentacle_spike
	spread_range = 5
	cooldown_time = 30 SECONDS
	show_preview = TRUE

/datum/action/cooldown/meatvine/spread_spike/can_spread_to_turf(turf/T)
	if(!isfloorturf(T))
		return FALSE

	// Must have a meatvine floor
	var/obj/structure/meatvine/floor/floor_vine = locate(/obj/structure/meatvine/floor) in T
	if(!floor_vine)
		return FALSE

	// Check if there's already a spike here
	var/obj/structure/meatvine/tentacle_spike/existing_spike = locate(/obj/structure/meatvine/tentacle_spike) in T
	if(existing_spike)
		// If spike exists, check if we can add to it
		if(!existing_spike.can_add_spike())
			return FALSE

	return TRUE

/datum/action/cooldown/meatvine/spread_spike/do_spread(turf/T, obj/effect/meatvine_controller/controller)
	// Check if there's already a spike
	var/obj/structure/meatvine/tentacle_spike/existing_spike = locate(/obj/structure/meatvine/tentacle_spike) in T

	if(existing_spike)
		// Add to existing spike
		if(existing_spike.add_spike())
			to_chat(owner, "<span class='notice'>Added spike to existing cluster. ([existing_spike.spike_count]/[existing_spike.max_spikes])</span>")
			return TRUE
		else
			to_chat(owner, "<span class='warning'>Maximum spikes reached!</span>")
			return FALSE

	// Create new spike
	var/obj/structure/meatvine/tentacle_spike/new_spike = new spread_type(T)
	new_spike.master = controller
	controller.vines += new_spike
	return TRUE

/datum/action/cooldown/meatvine/spread_healing_well
	name = "Build Healing Well"
	desc = "Build a healing well on meatvine floor. Provides regenerative aura to nearby creatures. Only one per area. Cost: 200 resources."
	button_icon_state = "heal_pool"
	resource_cost = 200
	spread_type = /obj/structure/meatvine/healing_well
	spread_range = 5
	cooldown_time = 3 MINUTES
	show_preview = TRUE

/datum/action/cooldown/meatvine/spread_healing_well/can_spread_to_turf(turf/T)
	if(!isfloorturf(T))
		return FALSE

	// Must have a meatvine floor
	var/obj/structure/meatvine/floor/floor_vine = locate(/obj/structure/meatvine/floor) in T
	if(!floor_vine)
		return FALSE

	// Check if there's already a healing well here
	if(locate(/obj/structure/meatvine/healing_well) in T)
		return FALSE

	// Check if there's a healing well nearby (non-stacking)
	for(var/obj/structure/meatvine/healing_well/existing_well in range(7, T))
		return FALSE

	return TRUE

/datum/action/cooldown/meatvine/spread_healing_well/Activate(atom/target)
	var/turf/T = get_turf(target)
	if(!T)
		return FALSE

	// Additional check for nearby wells
	for(var/obj/structure/meatvine/healing_well/existing_well in range(7, T))
		to_chat(owner, "<span class='warning'>Too close to another healing well!</span>")
		return FALSE

	return ..()

/datum/action/cooldown/meatvine/spread_healing_well/do_spread(turf/T, obj/effect/meatvine_controller/controller)
	// Create new healing well
	var/obj/structure/meatvine/healing_well/new_well = new spread_type(T)
	new_well.master = controller
	controller.vines += new_well
	return TRUE

/datum/action/cooldown/meatvine/spread_wormhole
	name = "Build Intestinal Passage"
	desc = "Build an intestinal wormhole on meatvine floor. Connect multiple to create a travel network. Cost: 150 resources."
	button_icon_state = "intestine_wormhole"
	resource_cost = 150
	spread_type = /obj/structure/meatvine/intestine_wormhole
	spread_range = 5
	cooldown_time = 1 MINUTES
	show_preview = TRUE
	var/wormhole_network_id = "default" // Can set this to create separate networks

/datum/action/cooldown/meatvine/spread_wormhole/can_spread_to_turf(turf/T)
	if(!isfloorturf(T))
		return FALSE

	// Must have a meatvine floor
	var/obj/structure/meatvine/floor/floor_vine = locate(/obj/structure/meatvine/floor) in T
	if(!floor_vine)
		return FALSE

	// Check if there's already a wormhole here
	if(locate(/obj/structure/meatvine/intestine_wormhole) in T)
		return FALSE

	return TRUE

/datum/action/cooldown/meatvine/spread_wormhole/do_spread(turf/T, obj/effect/meatvine_controller/controller)
	var/obj/structure/meatvine/intestine_wormhole/new_wormhole = new spread_type(T)
	new_wormhole.master = controller
	new_wormhole.wormhole_id = wormhole_network_id
	controller.vines += new_wormhole

	// Count existing wormholes in network
	var/network_count = 0
	for(var/obj/structure/meatvine/intestine_wormhole/wormhole in controller.vines)
		if(wormhole.wormhole_id == wormhole_network_id)
			network_count++

	to_chat(owner, "<span class='notice'>Intestinal passage created. Network size: [network_count]</span>")
	return TRUE

/datum/action/cooldown/meatvine/spread_tracking_beacon
	name = "Erect Probing Mass"
	desc = "Erects a probing mass on meatvine floor. Marks any creature that enters its range for tracking. Cost: 150 resources."
	button_icon_state = "tracking_beacon"
	resource_cost = 150
	spread_type = /obj/structure/meatvine/tracking_beacon
	spread_range = 5
	cooldown_time = 2 MINUTES
	show_preview = TRUE

/datum/action/cooldown/meatvine/spread_tracking_beacon/can_spread_to_turf(turf/T)
	if(!isfloorturf(T))
		return FALSE
	var/obj/structure/meatvine/floor/floor_vine = locate(/obj/structure/meatvine/floor) in T
	if(!floor_vine)
		return FALSE
	if(locate(/obj/structure/meatvine/tracking_beacon) in T)
		return FALSE
	for(var/obj/structure/meatvine/tracking_beacon/existing_beacon in range(5, T))
		return FALSE

	return TRUE

/datum/action/cooldown/meatvine/spread_tracking_beacon/Activate(atom/target)
	var/turf/T = get_turf(target)
	if(!T)
		return FALSE

	for(var/obj/structure/meatvine/tracking_beacon/existing_beacon in range(5, T))
		to_chat(owner, "<span class='warning'>Too close to another tracking beacon!</span>")
		return FALSE

	return ..()

/datum/action/cooldown/meatvine/spread_spike_multi
	name = "Spread Spike Line (x3)"
	desc = "Spread 3 tentacle spikes in a line perpendicular to your facing direction. Can stack up to 5 spikes per tile. Cost: 150 resources."
	button_icon_state = "tentacle_spikes_multi"
	resource_cost = 50
	spread_type = /obj/structure/meatvine/tentacle_spike
	spread_range = 5
	cooldown_time = 45 SECONDS
	multi_construct_count = 3
	multi_construct_pattern = MULTI_CONSTRUCT_LINE
	show_preview = TRUE
	should_replace = FALSE
	var/use_consumed_resources = TRUE

/datum/action/cooldown/meatvine/spread_spike_multi/can_spread_to_turf(turf/T)
	if(!isfloorturf(T))
		return FALSE

	// Must have a meatvine floor
	var/obj/structure/meatvine/floor/floor_vine = locate(/obj/structure/meatvine/floor) in T
	if(!floor_vine)
		return FALSE

	// Check if there's already a spike here
	var/obj/structure/meatvine/tentacle_spike/existing_spike = locate(/obj/structure/meatvine/tentacle_spike) in T
	if(existing_spike)
		// If spike exists, check if we can add to it
		if(!existing_spike.can_add_spike())
			return FALSE

	return TRUE

/datum/action/cooldown/meatvine/spread_spike_multi/do_spread(turf/T, obj/effect/meatvine_controller/controller)
	var/obj/structure/meatvine/tentacle_spike/existing_spike = locate(/obj/structure/meatvine/tentacle_spike) in T

	if(existing_spike)
		if(existing_spike.add_spike())
			return TRUE
		else
			to_chat(owner, span_warning("Maximum spikes reached at [get_area_name(T)]!"))
			return FALSE

	var/obj/structure/meatvine/tentacle_spike/new_spike = new spread_type(T)
	new_spike.master = controller
	controller.vines += new_spike

	return TRUE

/datum/action/cooldown/meatvine/spread_spike_multi/Activate(atom/target)
	var/mob/living/simple_animal/hostile/retaliate/meatvine/user = owner
	if(!istype(user))
		return FALSE

	if(!user.master)
		to_chat(user, span_warning("You have no master controller!"))
		return FALSE

	var/obj/effect/meatvine_controller/controller = user.master

	var/turf/target_turf = get_turf(target)
	if(!target_turf)
		return FALSE

	// Check range
	if(get_dist(user, target_turf) > spread_range)
		to_chat(user, span_warning("Target is too far away!"))
		return FALSE

	var/list/construct_turfs = get_build_turfs(target_turf)

	if(!length(construct_turfs))
		to_chat(user, span_warning("No valid placement locations!"))
		return FALSE

	var/total_cost = resource_cost * length(construct_turfs)

	if(use_consumed_resources)
		if(controller.consumed_resource_pool < total_cost)
			to_chat(user, span_warning("Not enough resources! Need [total_cost], have [controller.consumed_resource_pool]."))
			return FALSE

	var/successful_placements = 0

	for(var/turf/T as anything in construct_turfs)
		if(use_consumed_resources)
			if(controller.consumed_resource_pool < resource_cost)
				to_chat(user, span_warning("Ran out of resources after placing [successful_placements] spikes!"))
				break

		if(do_spread(T, controller))
			if(use_consumed_resources)
				controller.consumed_resource_pool -= resource_cost
			successful_placements++

	if(successful_placements > 0)
		. = ..()
		return TRUE
	else
		to_chat(user, span_warning("Failed to place any spikes!"))
		return FALSE

#undef MULTI_CONSTRUCT_NONE
#undef MULTI_CONSTRUCT_LINE
#undef MULTI_CONSTRUCT_CROSS
#undef MULTI_CONSTRUCT_SQUARE
