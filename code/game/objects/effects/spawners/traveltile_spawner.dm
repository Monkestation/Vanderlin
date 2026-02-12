/**

* Marker for spawning travel tiles in randomized locations,
* on map load it will pick one marker for each travel_type and spawn travel tiles there,
* then delete itself and others of its type.

** must be assigned a travel_tile and horizontal value.

**/
/obj/effect/spawner/traveltile_spawner
	icon = 'icons/turf/floors.dmi'
	icon_state = MAP_SWITCH("none", "travel")

	invisibility = INVISIBILITY_ABSTRACT
	resistance_flags = INDESTRUCTIBLE | LAVA_PROOF | FIRE_PROOF | UNACIDABLE | ACID_PROOF
	anchored = TRUE

	/// radius of the line in which we spawn, I.E: 1 would be a tile in one direction and another tile in the other direction, totaling 3 tiles.
	var/range = 1

	/// which traveltile do we spawn?
	var/travel_tile

	/// if this spawner is horizontal, set to TRUE. Set to FALSE if vertical, otherwise it will delete itself.
	var/horizontal

/obj/effect/spawner/traveltile_spawner/Initialize(mapload, ...)
	if(flags_1 & INITIALIZED_1)
		stack_trace("Warning: [src]([type]) initialized multiple times!")

	GLOB.traveltile_spawners += src
	return INITIALIZE_HINT_NORMAL
	/*
	we don't call parent here because the removal of this spawner effect from the map
	is handled by /datum/controller/subsystem/random_travel_tiles/Initialize() .
	technically this also means it doesn't have to be a spawner type but I do this
	to organize all spawners together for mappers.
	*/

/obj/effect/spawner/traveltile_spawner/Destroy(force)
	GLOB.traveltile_spawners -= src
	. = ..()

/obj/effect/spawner/traveltile_spawner/proc/spawn_tiles()
	if(isnull(horizontal) || isnull(travel_tile)) // kill all mappers.
		stack_trace("NULL HORIZONTAL OR TRAVEL TILE VALUE AT [loc] FOR A TRAVEL TILE SPAWNER [type], YELL AT MAPPERS")
		qdel(src)
		return
	var/turf/current_turf = loc
	new travel_tile(current_turf)
	if(horizontal)
		for(var/i = 0, i < range, i++)
			current_turf = get_step(current_turf, EAST)
			new travel_tile(current_turf)
		current_turf = loc
		for(var/i = 0, i < range, i++)
			current_turf = get_step(current_turf, WEST)
			new travel_tile(current_turf)
	else
		for(var/i = 0, i < range, i++)
			current_turf = get_step(current_turf, NORTH)
			new travel_tile(current_turf)
		current_turf = loc
		for(var/i = 0, i < range, i++)
			current_turf = get_step(current_turf, SOUTH)
			new travel_tile(current_turf)
	qdel(src)

/obj/effect/spawner/traveltile_spawner/horizontal
	horizontal = TRUE

/obj/effect/spawner/traveltile_spawner/vertical
	horizontal = FALSE

/obj/effect/spawner/traveltile_spawner/horizontal/bandit
	travel_tile = /obj/structure/fluff/traveltile/bandit

/obj/effect/spawner/traveltile_spawner/vertical/bandit
	travel_tile = /obj/structure/fluff/traveltile/bandit

/obj/effect/spawner/traveltile_spawner/horizontal/vampire
	travel_tile = /obj/structure/fluff/traveltile/vampire

/obj/effect/spawner/traveltile_spawner/vertical/vampire
	travel_tile = /obj/structure/fluff/traveltile/vampire

/obj/effect/spawner/traveltile_spawner/horizontal/inhumen
	travel_tile = /obj/structure/fluff/traveltile/to_inhumen_tribe

/obj/effect/spawner/traveltile_spawner/vertical/inhumen
	travel_tile = /obj/structure/fluff/traveltile/to_inhumen_tribe

/obj/effect/spawner/traveltile_spawner/horizontal/jarosite
	travel_tile = /obj/structure/fluff/traveltile/to_acid_caves

/obj/effect/spawner/traveltile_spawner/vertical/jarosite
	travel_tile = /obj/structure/fluff/traveltile/to_acid_caves

/*	..................   Traveltiles   ................... */ // these are the ones on centcom, where the actual lair is, to reduce varedits onmap
/obj/structure/fluff/traveltile/exit_bandit		// must NOT be a traveltile/bandit child, because that one has a check for banditcamp trait. People should always be able to leave the camp.
	aportalid = "banditin"
	aportalgoesto = "banditexit"

/obj/structure/fluff/traveltile/bandit
	aportalid = "banditexit"
	aportalgoesto = "banditin"
	required_trait = TRAIT_BANDITCAMP
	can_gain_with_sight = TRUE
	can_gain_by_walking = TRUE
	check_other_side = TRUE

/obj/structure/fluff/traveltile/exit_vampire	// must NOT be a traveltile/vampire child, because that one has a check for banditcamp trait. People should always be able to leave the camp.
	aportalid = "vampin"
	aportalgoesto = "vampexit"

/obj/structure/fluff/traveltile/vampire
	aportalid = "vampexit"
	aportalgoesto = "vampin"
	required_trait = TRAIT_VAMPMANSION
	can_gain_with_sight = TRUE
	can_gain_by_walking = TRUE
	check_other_side = TRUE

/obj/structure/fluff/traveltile/exit_inhumen
	aportalid = "inhumenin"
	aportalgoesto = "inhumenexit"

/obj/structure/fluff/traveltile/to_inhumen_tribe
	name = "to the Deep Bog"
	aportalid = "inhumenexit"
	aportalgoesto = "inhumenin"
	required_trait = TRAIT_INHUMENCAMP
	can_gain_with_sight = FALSE
	can_gain_by_walking = FALSE
	check_other_side = TRUE

/obj/structure/fluff/traveltile/to_acid_caves
	name = "to the Acid Caves"
	aportalid = "acid_out"
	aportalgoesto = "acid_in"
	check_other_side = TRUE

/obj/structure/fluff/traveltile/from_acid_caves
	aportalid = "acid_in"
	aportalgoesto = "acid_out"
	check_other_side = TRUE
