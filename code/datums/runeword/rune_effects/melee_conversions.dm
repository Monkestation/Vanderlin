/datum/rune_effect/melee_orbital
	name = "Orbital Conversion"
	var/list/effect_values = list()

/datum/rune_effect/melee_orbital/apply_effects_from_list(list/effects)
	if(length(effects))
		effect_values = effects.Copy()

/datum/rune_effect/melee_orbital/get_description()
	if(length(effect_values) >= 2)
		return "Converts melee attacks into orbitals ([effect_values[1]] orbits, [effect_values[2]] damage)"
	else if(length(effect_values) >= 1)
		return "Converts melee attacks into orbitals ([effect_values[1]] orbits)"
	return "Converts melee attacks into orbitals"

/datum/rune_effect/melee_orbital/get_combined_description(list/effects)
	var/total_orbits = 0
	var/total_damage = 0
	for(var/datum/rune_effect/melee_orbital/effect in effects)
		if(length(effect.effect_values) >= 1)
			total_orbits += effect.effect_values[1]
		if(length(effect.effect_values) >= 2)
			total_damage += effect.effect_values[2]

	if(total_damage > 0)
		return "Converts melee attacks into orbitals ([total_orbits] orbits, [total_damage] damage)"
	return "Converts melee attacks into orbitals ([total_orbits] orbits)"

/datum/rune_effect/melee_orbital/apply_stat_effect(datum/component/modifications/source, obj/item/item)
	. = ..()
	RegisterSignal(item, COMSIG_ITEM_ATTACK, PROC_REF(convert_to_orbital))

/datum/rune_effect/melee_orbital/proc/convert_to_orbital(obj/item/source, atom/target, mob/living/user)
	if(!user || !target)
		return

	var/orbit_count = length(effect_values) >= 1 ? effect_values[1] : 1
	var/orbital_damage = length(effect_values) >= 2 ? effect_values[2] : source.force

	// Create orbital projectiles
	for(var/i in 1 to orbit_count)
		var/obj/projectile/orbital/orb_proj = new(get_turf(user))
		orb_proj.damage = orbital_damage
		orb_proj.firer = user
		orb_proj.orbit_index = i
		orb_proj.total_orbits = orbit_count
		orb_proj.base_item = source
		orb_proj.originator = user
		orb_proj.name = "[source.name] orbital"
		orb_proj.icon = source.icon
		orb_proj.icon_state = source.icon_state

		// Calculate orbital parameters
		var/base_angle = (360 / orbit_count) * (i - 1)
		var/orbit_radius = 24 + (i * 4) // Smaller radius for better collision detection
		orb_proj.base_orbit_angle = base_angle
		orb_proj.orbit_radius = orbit_radius

		// Start orbiting
		orb_proj.start_orbiting(user)

	return COMPONENT_CANCEL_ATTACK_CHAIN

/obj/projectile/orbital
	name = "orbital projectile"
	damage_type = BRUTE
	speed = 0.2
	var/obj/item/base_item
	var/mob/living/carbon/originator
	var/orbit_index = 1
	var/total_orbits = 1
	var/orbit_time = 0
	var/max_orbit_time = 200 // How long to orbit before disappearing (in deciseconds)
	var/base_orbit_angle = 0
	var/orbit_radius = 32
	var/orbit_speed = 3 // Degrees per process cycle
	var/atom/orbit_center
	var/current_angle = 0
	var/list/already_hit = list() // Track what we've already damaged

/obj/projectile/orbital/Initialize(mapload, ...)
	. = ..()
	// Set up the projectile timer
	addtimer(CALLBACK(src, PROC_REF(expire_orbital)), max_orbit_time)

/obj/projectile/orbital/proc/start_orbiting(atom/center)
	if(!center)
		qdel(src)
		return

	orbit_center = center
	current_angle = base_orbit_angle

	// Position the projectile initially
	update_orbital_position()

	// Start the orbital movement
	START_PROCESSING(SSprojectiles, src)

/obj/projectile/orbital/proc/update_orbital_position()
	if(!orbit_center || QDELETED(orbit_center))
		qdel(src)
		return

	var/center_x = orbit_center.x
	var/center_y = orbit_center.y

	// Calculate new position based on angle and radius
	var/offset_x = cos(current_angle) * (orbit_radius / 32) // Convert pixels to tiles
	var/offset_y = sin(current_angle) * (orbit_radius / 32)

	var/new_x = center_x + offset_x
	var/new_y = center_y + offset_y

	// Move to new position
	var/turf/new_turf = locate(round(new_x), round(new_y), orbit_center.z)
	if(new_turf)
		forceMove(new_turf)

		// Set pixel offsets for smooth movement
		pixel_x = ((new_x - round(new_x)) * 32)
		pixel_y = ((new_y - round(new_y)) * 32)

/obj/projectile/orbital/process()
	if(!orbit_center || QDELETED(orbit_center))
		qdel(src)
		return PROCESS_KILL

	// Update angle
	current_angle += orbit_speed
	if(current_angle >= 360)
		current_angle -= 360

	// Update position
	update_orbital_position()

	// Check for collisions with nearby atoms
	check_orbital_collisions()

	// Increment orbit time
	orbit_time += 1

/obj/projectile/orbital/proc/check_orbital_collisions()
	if(!loc)
		return

	// Only check the current turf for more precise collision detection
	for(var/atom/movable/target in loc)
		// Skip if we've already hit this target recently
		if(target in already_hit)
			continue

		// Skip the firer and other orbital projectiles
		if(target == firer || istype(target, /obj/projectile/orbital))
			continue

		// Skip if not a valid target
		if(!can_hit_target(target))
			continue

		// Use pixel-perfect collision detection
		if(get_pixel_distance(src, target) <= 16) // Within 16 pixels (half a tile)
			hit_orbital_target(target)

/obj/projectile/orbital/can_hit_target(atom/target, direct_target, ignore_loc)
	// Only hit living mobs that aren't the firer
	if(!isliving(target))
		return FALSE

	if(target == firer || target == originator)
		return FALSE

	var/mob/living/living_target = target
	if(living_target.stat == DEAD)
		return FALSE

	return TRUE

/obj/projectile/orbital/proc/hit_orbital_target(atom/target)
	// Add to hit list to prevent repeated hits
	already_hit[target] = world.time

	// Clean up old entries in already_hit list
	for(var/atom/old_target in already_hit)
		if(world.time - already_hit[old_target] > 0.5 SECONDS)
			already_hit -= old_target

	// Apply damage
	var/mob/living/living_target = target
	if(isliving(living_target))
		Impact(target)
		qdel(src)

/obj/projectile/orbital/proc/expire_orbital()
	qdel(src)

/obj/projectile/orbital/Destroy()
	STOP_PROCESSING(SSprojectiles, src)
	already_hit = null
	orbit_center = null
	return ..()


/**
 * Finds the distance between two atoms, in pixels \
 * centered = FALSE counts from turf edge to edge \
 * centered = TRUE counts from turf center to turf center \
 * of course mathematically this is just adding world.icon_size on again
**/
/proc/get_pixel_distance(atom/start, atom/end, centered = TRUE)
	if(!istype(start) || !istype(end))
		return 0
	. = bounds_dist(start, end) + sqrt((((start.pixel_x + end.pixel_x) ** 2) + ((start.pixel_y + end.pixel_y) ** 2)))
	if(centered)
		. += 32
