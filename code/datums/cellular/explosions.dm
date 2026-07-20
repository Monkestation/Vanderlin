/*
	Cellular automaton explosions!

	Often in life, you can't have what you wish for. This is one massive, huge,
	gigantic, gaping exception. With this, you get EVERYTHING you wish for.

	This thing is AWESOME. It's made with super simple rules, and it still produces
	highly complex explosions because it's simply emergent behavior from the rules.
	If that didn't amaze you (it should), this also means the code is SUPER short,
	and because cellular automata is handled by a subsystem, this doesn't cause
	lagspikes at all.

	Enough nerd enthusiasm about this. Here's how it actually works:

		1. You start the explosion off with a given power

		2. The explosion begins to propagate outwards in all 8 directions

		3. Each time the explosion propagates, it loses power_falloff power

		4. Each time the explosion propagates, atoms in the tile the explosion is in
		may reduce the power of the explosion by their explosive resistance

	That's it. There are some special rules, though, namely:

		* If the explosion occurred in a wall, the wave is strengthened
		with power *= reflection_multiplier and reflected back in the
		direction it came from

		* If two explosions meet, they will either merge into an amplified
		or weakened explosion
*/

/datum/automata_cell/explosion
	// Explosions only spread outwards and don't need to know their neighbors to propagate properly
	neighbor_type = NEIGHBORS_NONE

	// Power of the explosion at this cell
	var/power = 0
	// How much will the power drop off when the explosion propagates?
	var/power_falloff = 20
	// Falloff shape is used to determines whether or not the falloff will change during the explosion traveling.
	var/falloff_shape = EXPLOSION_FALLOFF_SHAPE_LINEAR
	// How much power does the explosion gain (or lose) by bouncing off walls?
	var/reflection_power_multiplier = 0.4

	//Diagonal cells have a small delay when branching off from a non-diagonal cell. This helps the explosion look circular
	var/delay = 0

	// Which direction is the explosion traveling?
	// Note that this will be null for the epicenter
	var/direction = null

	// Whether or not the explosion should merge with other explosions
	var/should_merge = TRUE

	// For explosion tracking and logging
	var/explosion_source

	// Workaround to account for the fact that this is subsystemized
	// See on_turf_entered
	var/list/atom/exploded_atoms = list()

	var/obj/effect/particle_effect/shockwave/shockwave = null

// If we're on a fake z teleport, teleport over
/datum/automata_cell/explosion/birth()
	shockwave = new(in_turf)

	var/obj/structure/fluff/traveltile/V = locate() in in_turf
	var/obj/structure/stairs/stairs = locate() in in_turf

	var/turf/new_turf
	if(!V && !stairs)
		return

	if(V)
		new_turf = V.get_other_end_turf()
	if(stairs)
		new_turf = stairs.get_target_loc(stairs.dir)
	if(!new_turf)
		return

	transfer_turf(new_turf)

/datum/automata_cell/explosion/death()
	if(shockwave)
		qdel(shockwave)

// Compare directions. If the other explosion is traveling in the same direction,
// the explosion is amplified. If not, it's weakened
/datum/automata_cell/explosion/merge(datum/automata_cell/explosion/E)
	// Non-merging explosions take priority
	if(!should_merge)
		return TRUE

	// The strongest of the two explosions should survive the merge
	// This prevents a weaker explosion merging with a strong one,
	// the strong one removing all the weaker one's power and just killing the explosion
	var/is_stronger = (power >= E.power)
	var/datum/automata_cell/explosion/survivor = is_stronger ? src : E
	var/datum/automata_cell/explosion/dying = is_stronger ? E : src

	// Two epicenters merging, or a new epicenter merging with a traveling wave
	if((!survivor.direction && !dying.direction) || (survivor.direction && !dying.direction))
		survivor.power += dying.power

	// A traveling wave hitting the epicenter weakens it
	if(!survivor.direction && dying.direction)
		survivor.power -= dying.power

	// Two traveling waves meeting each other
	// Note that we don't care about waves traveling perpendicularly to us
	// I.e. they do nothing

	// Two waves traveling the same direction amplifies the explosion
	if(survivor.direction == dying.direction)
		survivor.power += dying.power

	// Two waves travling towards each other weakens the explosion
	if(survivor.direction == REVERSE_DIR(dying.direction))
		survivor.power -= dying.power

	return is_stronger

// Get a list of all directions the explosion should propagate to before dying
/datum/automata_cell/explosion/proc/get_propagation_dirs(reflected)
	var/list/propagation_dirs = list()

	// If the cell is the epicenter, propagate in all directions
	if(isnull(direction))
		return GLOB.alldirs

	var/dir = reflected ? REVERSE_DIR(direction) : direction

	if(dir in GLOB.cardinals)
		propagation_dirs += list(dir, turn(dir, 45), turn(dir, -45))
	else
		propagation_dirs += dir

	return propagation_dirs

// If you need to set vars on the new cell other than the basic ones
/datum/automata_cell/explosion/proc/setup_new_cell(datum/automata_cell/explosion/E)
	if(E.shockwave)
		E.shockwave.alpha = max(60, E.power * 6)
	return

/datum/automata_cell/explosion/proc/power_to_ranges(power_val)
	// Convert cellular automaton power to traditional explosion ranges

	var/devastation_range = 0
	var/heavy_impact_range = 0
	var/light_impact_range = 0
	var/flame_range = 0

	if(power_val >= 80)
		// Devastation level explosion
		devastation_range = round(power_val / 80, 1)
		heavy_impact_range = round(power_val / 40, 1)
		light_impact_range = round(power_val / 20, 1)
		flame_range = round(power_val / 15, 1)
	else if(power_val >= 40)
		// Heavy level explosion
		heavy_impact_range = round(power_val / 40, 1)
		light_impact_range = round(power_val / 20, 1)
		flame_range = round(power_val / 15, 1)
	else if(power_val >= 20)
		// Light level explosion
		light_impact_range = round(power_val / 20, 1)
		flame_range = round(power_val / 15, 1)
	else if(power_val >= 10)
		// Flame only
		flame_range = round(power_val / 10, 1)

	return list(
		"devastation" = devastation_range,
		"heavy" = heavy_impact_range,
		"light" = light_impact_range,
		"flame" = flame_range
	)

/datum/automata_cell/explosion/update_state(list/turf/neighbors)
	if(delay > 0)
		delay--
		return

	// The resistance here will affect the damage taken and the falloff in the propagated explosion
	var/resistance = max(0, in_turf.get_explosion_resistance(direction))
	for(var/atom/A in in_turf)
		resistance += max(0, A.get_explosion_resistance())

	// Convert power to traditional explosion severity for damage calculation
	var/explosion_severity
	if(power >= 80)
		explosion_severity = EXPLODE_DEVASTATE
	else if(power >= 40)
		explosion_severity = EXPLODE_HEAVY
	else if(power >= 20)
		explosion_severity = EXPLODE_LIGHT
	else
		explosion_severity = EXPLODE_NONE

	if(explosion_severity > EXPLODE_NONE)
		var/atom/target = null
		var/list/ranges = power_to_ranges(power)

		INVOKE_ASYNC(in_turf, TYPE_PROC_REF(/atom, ex_act), explosion_severity, target, in_turf, ranges["devastation"], ranges["heavy"], ranges["light"], ranges["flame"])

		for(var/atom/A in in_turf)
			if(A in exploded_atoms)
				continue
			if(A.gc_destroyed)
				continue
			INVOKE_ASYNC(A, TYPE_PROC_REF(/atom, ex_act), explosion_severity, target, in_turf, ranges["devastation"], ranges["heavy"], ranges["light"], ranges["flame"])
			exploded_atoms += A

	var/throw_dir = get_dir(in_turf, direction ? get_step(in_turf, direction) : pick(GLOB.alldirs))
	for(var/obj/item/I in in_turf)
		if(!I.anchored && power >= 20)
			var/throw_range = rand(round(power/20), round(power/10))
			var/turf/throw_at = get_ranged_target_turf(I, throw_dir, throw_range)
			INVOKE_ASYNC(I, TYPE_PROC_REF(/atom/movable, throw_at), throw_at, throw_range, 4)

	var/reflected = FALSE

	// Epicenter is inside a wall if direction is null.
	// Prevent it from slurping the entire explosion
	if(!isnull(direction))
		// Bounce off the wall in the opposite direction, don't keep phasing through it
		// Notice that since we do this after the ex_act()s,
		// explosions will not bounce if they destroy a wall!
		if(power < resistance)
			reflected = TRUE
			power *= reflection_power_multiplier
		else
			power -= resistance

	if(power <= 0)
		qdel(src)
		return

	// Propagate the explosion
	var/list/to_spread = get_propagation_dirs(reflected)
	for(var/dir in to_spread)
		// Diagonals are longer, that should be reflected in the power falloff
		var/dir_falloff = 1
		if(dir in GLOB.diagonals)
			dir_falloff = 1.414

		if(isnull(direction))
			dir_falloff = 0

		var/new_power = power - (power_falloff * dir_falloff)

		// Explosion is too weak to continue
		if(new_power <= 0)
			continue

		var/new_falloff = power_falloff
		// Handle our falloff function.
		switch(falloff_shape)
			if(EXPLOSION_FALLOFF_SHAPE_EXPONENTIAL)
				new_falloff += new_falloff * dir_falloff
			if(EXPLOSION_FALLOFF_SHAPE_EXPONENTIAL_HALF)
				new_falloff += (new_falloff*0.5) * dir_falloff

		var/datum/automata_cell/explosion/E = propagate(dir)
		if(E)
			E.power = new_power
			E.power_falloff = new_falloff
			E.falloff_shape = falloff_shape

			// Set the direction the explosion is traveling in
			E.direction = dir
			//Diagonal cells have a small delay when branching off the center. This helps the explosion look circular
			if(!direction && (dir in GLOB.diagonals))
				E.delay = 1

			setup_new_cell(E)

	// We've done our duty, now die pls
	qdel(src)

/*
The issue is that between the cell being birthed and the cell processing,
someone could potentially move through the cell unharmed.

To prevent that, we track all atoms that enter the explosion cell's turf
and blow them up immediately once they do.

When the cell processes, we simply don't blow up atoms that were tracked
as having entered the turf.
*/

/datum/automata_cell/explosion/proc/on_turf_entered(atom/movable/A)
	// Once is enough
	if(A in exploded_atoms)
		return

	exploded_atoms += A

	// Note that we don't want to make it a directed ex_act because
	// it could toss them back and make them get hit by the explosion again
	if(A.gc_destroyed)
		return

	// Convert power to severity for immediate damage
	var/explosion_severity
	if(power >= 80)
		explosion_severity = EXPLODE_DEVASTATE
	else if(power >= 40)
		explosion_severity = EXPLODE_HEAVY
	else if(power >= 20)
		explosion_severity = EXPLODE_LIGHT
	else
		explosion_severity = EXPLODE_NONE

	if(explosion_severity > EXPLODE_NONE)
		var/list/ranges = power_to_ranges(power)
		INVOKE_ASYNC(A, TYPE_PROC_REF(/atom, ex_act), explosion_severity, null, explosion_source, ranges["devastation"], ranges["heavy"], ranges["light"], ranges["flame"])

	log_explosion(A, src)


// Spawns a cellular automaton of an explosion
/proc/cell_explosion(turf/epicenter, power, falloff, falloff_shape = EXPLOSION_FALLOFF_SHAPE_LINEAR, direction, explosion_source, initial_call = TRUE)
	if(!istype(epicenter))
		epicenter = get_turf(epicenter)

	if(!epicenter)
		return

	if(!explosion_source)
		explosion_source = "Unknown explosion"

	falloff = max(falloff, power/100)

	if(initial_call) //stuff that is supposed to happen just once, calls explosion on lower and higher level
		var/above = GET_TURF_ABOVE(epicenter)
		if(istype(above, /turf/open/openspace))
			cell_explosion(above, power * 0.8, falloff, falloff_shape, direction, explosion_source, initial_call = FALSE)
		if(istype(epicenter,/turf/open/openspace))
			var/below = GET_TURF_BELOW(epicenter)
			cell_explosion(below, power * 0.8, falloff, falloff_shape, direction, explosion_source, initial_call = FALSE)

		message_admins("Explosion with Power: [power], Falloff: [falloff], Shape: [falloff_shape] from [explosion_source] in [epicenter.loc.name] ([epicenter.x],[epicenter.y],[epicenter.z]).")

		playsound(epicenter, pick('sound/misc/explode/explosionfar (1).ogg','sound/misc/explode/explosionfar (2).ogg','sound/misc/explode/explosionfar (3).ogg'), 100, 1, round(power^2,1))

		if(power >= 300) //Make BIG BOOMS
			playsound(epicenter, "bigboom", 80, 1, max(round(power,1),7))
		else
			playsound(epicenter, "explosion", 90, 1, max(round(power,1),7))
		if(power > EXPLOSION_MAX_POWER)
			log_explosion("[explosion_source] exploded with force of [power]. Overriding to capacity of [EXPLOSION_MAX_POWER].")
			power = EXPLOSION_MAX_POWER

	var/datum/automata_cell/explosion/E = new /datum/automata_cell/explosion(epicenter)

	// something went wrong :(
	if(QDELETED(E))
		return

	E.power = power
	E.power_falloff = falloff
	E.falloff_shape = falloff_shape
	E.direction = direction
	E.explosion_source = explosion_source

	return E

/proc/log_explosion(atom/A, datum/automata_cell/explosion/E)
	if(isliving(A))
		var/mob/living/M = A
		var/turf/T = get_turf(A)

		if(QDELETED(M) || QDELETED(T))
			return

		var/explosion_source = E.explosion_source

		log_attack("[key_name(M)] was harmed by explosion from [explosion_source] in [T.loc.name] at ([T.x],[T.y],[T.z])")

/obj/effect/particle_effect/shockwave
	name = "shockwave"
	icon = 'icons/effects/effects.dmi'
	icon_state = "smoke"
	anchored = TRUE
	mouse_opacity = MOUSE_OPACITY_TRANSPARENT
	layer = FLY_LAYER
