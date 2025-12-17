/obj/structure/meatvine
	name = "meat clump"
	desc = "What is that?!"
	icon = 'icons/obj/cellular/meat.dmi'
	icon_state = "tile_1"
	anchored = TRUE
	density = FALSE
	layer = LOW_OBJ_LAYER
	pass_flags = PASSTABLE | PASSGRILLE

	var/obj/effect/meatvine_controller/master = null
	var/feromone_weight = 1
	var/list/lair_generators = list(/mob/living, /obj/item/reagent_containers/food/snacks, /obj/item/alch/herb, /obj/item/natural)
	max_integrity = 20
	resistance_flags = CAN_BE_HIT

	var/borders = TRUE
	var/list/borders_overlays = list()
	var/static/list/beams = list()
	var/is_full = FALSE

	// Optimization vars
	var/last_wrap_check = 0
	var/wrap_check_cooldown = 30 SECONDS

/obj/structure/meatvine/Initialize(mapload)
	. = ..()

	// Delayed processing to avoid init lag
	addtimer(CALLBACK(src, PROC_REF(delayed_init)), 1 SECONDS)

	var/datum/reagents/R = new/datum/reagents(400)
	reagents = R
	R.my_atom = src

	update_borders()

	if(master)
		SSmeatvines.register_vine(src)

/obj/structure/meatvine/proc/delayed_init()
	wrap_items_on_turf()
	setup_signals()

/obj/structure/meatvine/proc/setup_signals()
	var/turf/T = get_turf(src)
	RegisterSignal(T, COMSIG_ATOM_ENTERED, PROC_REF(on_entered))

/obj/structure/meatvine/proc/wrap_items_on_turf()
	var/turf/T = get_turf(src)

	checking_items:
		for(var/obj/item/Item in T.contents)
			for(var/generator_type in lair_generators)
				if(istype(Item, generator_type))
					continue checking_items
			Item.try_wrap_up("meat", "meatthings")

	for(var/obj/structure/closet/Closet in T.contents)
		Closet.try_wrap_up("meat", "meatthings")

/obj/structure/meatvine/Destroy()
	if(master)
		master.vines -= src
		master = null

	SSmeatvines.unregister_vine(src)
	update_borders()

	var/turf/old_turf = get_turf(src)
	. = ..()
	for(var/dir in GLOB.cardinals)
		var/turf/neighbor_turf = get_step(old_turf, dir)
		var/obj/structure/meatvine/neighbor = locate(/obj/structure/meatvine) in neighbor_turf
		if(neighbor)
			SSmeatvines.check_vine_neighbors(neighbor)

/obj/structure/meatvine/proc/is_edge_vine()
	var/turf/T = get_turf(src)

	for(var/direction in GLOB.cardinals)
		var/turf/step = get_step(T, direction)

		if(!step)
			continue

		// Closed turf = edge (can spread when it opens)
		if(!isopenturf(step))
			SSmeatvines.track_turf(step)
			return TRUE

		// No vine = edge (can spread)
		var/obj/structure/meatvine/struct = locate(/obj/structure/meatvine) in step
		if(!struct || QDELING(struct))
			return TRUE

	return FALSE

/obj/structure/meatvine/proc/on_entered(datum/source, atom/movable/arrived, atom/old_loc, list/atom/old_locs)
	SIGNAL_HANDLER

	// Handle meatvine creatures
	if(istype(arrived, /mob/living/simple_animal/hostile/retaliate/meatvine))
		var/mob/living/simple_animal/hostile/retaliate/meatvine/L = arrived
		var/datum/component/bounded/B = L.GetComponent(/datum/component/bounded)
		if(B)
			qdel(B)
		if(arrived in beams)
			var/datum/beam/current_beam = beams[arrived]
			beams -= arrived
			qdel(current_beam)
		return

	// Wrap items/mobs on cooldown
	if(world.time < last_wrap_check + wrap_check_cooldown)
		return

	last_wrap_check = world.time

	if(isliving(arrived))
		var/mob/living/M = arrived
		if(M.stat == DEAD && !istype(M, /mob/living/simple_animal/hostile/retaliate/meatvine))
			if(prob(5))
				M.try_wrap_up("meat", "meatthings")
				check_for_lair_spawn()
	else if(isitem(arrived))
		var/is_generator = FALSE
		for(var/generator_type in lair_generators)
			if(istype(arrived, generator_type))
				is_generator = TRUE
				break

		if(!is_generator && prob(5))
			arrived.try_wrap_up("meat", "meatthings")

/obj/structure/meatvine/Uncrossed(atom/movable/AM)
	. = ..()
	if(istype(AM, /mob/living/simple_animal/hostile/retaliate/meatvine))
		var/mob/living/simple_animal/hostile/retaliate/meatvine/L = AM
		if(!L.tether_distance)
			return

		var/turf/new_loc = get_turf(L)
		if(!locate(/obj/structure/meatvine, new_loc))
			L.AddComponent(/datum/component/bounded, src, 0, L.tether_distance)

			var/datum/beam/current_beam = new(src, AM, time = INFINITY, icon_state = "meat", beam_type = /obj/effect/ebeam/meat)
			INVOKE_ASYNC(current_beam, TYPE_PROC_REF(/datum/beam, Start))
			if(AM in beams)
				var/datum/beam/old_beam = beams[AM]
				qdel(old_beam)
			beams |= AM
			beams[AM] = current_beam

/obj/structure/meatvine/proc/can_buckle(mob/living/M)
	if(M.buckled || length(buckled_mobs))
		return FALSE
	return M.stat != DEAD

/obj/structure/meatvine/buckle_mob(mob/living/M, force = FALSE, check_loc = TRUE)
	. = ..()
	if(!can_buckle(M))
		return

	if(.)
		to_chat(M, "<span class='danger'>The vines [pick("wind", "tangle", "tighten")] around you!</span>")

	if(prob(5))
		M.try_wrap_up("meat", "meatthings")

/obj/structure/meatvine/proc/check_for_lair_spawn()
	if(!master)
		return

	var/turf/T = get_turf(src)
	if(!isfloorturf(T))
		return

	if(prob(1) && master.can_spawn_lair_at(T))
		master.spawn_spacevine_piece(T, /obj/structure/meatvine/lair)
		qdel(src)

/obj/structure/meatvine/proc/grow()
	if(!master || master.isdying)
		return

	var/turf/T = get_turf(src)
	if(!isfloorturf(T))
		rot()
		return

	// Check for lair spawn
	if(prob(10) && master.can_spawn_lair_at(T))
		master.spawn_spacevine_piece(T, /obj/structure/meatvine/lair)
		qdel(src)
		return

	// Process items/mobs on turf
	for(var/generator_type in lair_generators)
		var/atom/thing = locate(generator_type) in T
		if(!thing)
			continue

		if(isliving(thing))
			var/mob/living/Mob = thing

			if(Mob.stat != DEAD || istype(Mob, /mob/living/simple_animal/hostile/retaliate/meatvine))
				continue

			Mob.try_wrap_up("meat", "meatthings")
		else
			qdel(thing)

		if(master.can_spawn_lair_at(T))
			master?.spawn_spacevine_piece(T, /obj/structure/meatvine/lair)
			qdel(src)
			return

/obj/structure/meatvine/proc/spread(spread_chance = 50)
	if(!master || master.isdying)
		return

	var/turf/T = get_turf(src)
	if(!isfloorturf(T))
		rot()
		return

	if(master.organic_matter >= master.organic_matter_per_spread)
		spread_chance = 100

	if(!prob(spread_chance))
		return

	var/direction = pick(GLOB.cardinals)
	var/turf/step = get_step(src, direction)

	var/using_organic_matter = FALSE
	if(master.organic_matter >= master.organic_matter_per_spread)
		using_organic_matter = TRUE
		master.organic_matter -= master.organic_matter_per_spread

	if(isopenturf(step))
		var/turf/open/floor/F = step

		// Handle openspace
		while(isopenspace(F))
			F = GET_TURF_BELOW(F)

		// Handle stairs
		var/stairs = TRUE
		while(stairs && locate(/obj/structure/stairs, F))
			if(isopenspace(GET_TURF_ABOVE(F)))
				F = GET_TURF_ABOVE(F)
				F = get_step(F, direction)
			else
				stairs = FALSE

		if(!isfloorturf(F))
			return

		var/obj/structure/meatvine/existing = locate(/obj/structure/meatvine) in F

		// Restore rotted vine
		if(existing && !existing.master)
			existing.restore_vine(master)
			if(using_organic_matter && prob(75))
				attempt_bonus_spread(T, direction)
			return

		// Spawn new vine
		if(!existing || !existing.is_full)
			if(!can_enter_turf(F))
				mark_obstacles(F)
				return

			master.spawn_spacevine_piece(F)

			// Update neighbors
			for(var/dir in GLOB.cardinals)
				var/turf/neighbor_turf = get_step(F, dir)
				var/obj/structure/meatvine/neighbor = locate(/obj/structure/meatvine) in neighbor_turf
				if(neighbor)
					SSmeatvines.check_vine_neighbors(neighbor)

			if(using_organic_matter && prob(75))
				attempt_bonus_spread(T, direction)
	else
		// Closed turf - create border
		var/obstructed_dir = get_dir(T, step)
		for(var/obj/structure/meatvineborder/Vine in T)
			if(Vine.dir == obstructed_dir)
				return
		var/obj/structure/meatvineborder/Vine = new /obj/structure/meatvineborder(T)
		Vine.dir = obstructed_dir

		SSmeatvines.track_turf(step)

/obj/structure/meatvine/proc/mark_obstacles(turf/F)
	for(var/obj/structure/S in F)
		if(S.density && !istype(S, /obj/structure/meatvine))
			if(istype(S, /obj/structure/flora/newtree))
				S.take_damage(50)
				continue
			if(istype(S, /obj/structure/table/wood/treestump))
				qdel(S)
				continue
			master.mark_obstacle_for_destruction(S)

	for(var/obj/machinery/M in F)
		if(M.density)
			master.mark_obstacle_for_destruction(M)

/obj/structure/meatvine/proc/attempt_bonus_spread(turf/origin, avoided_direction)
	if(!master)
		return

	var/list/other_dirs = GLOB.cardinals.Copy()
	other_dirs -= avoided_direction
	if(!length(other_dirs))
		return

	var/bonus_dir = pick(other_dirs)
	var/turf/bonus_step = get_step(origin, bonus_dir)
	if(!isopenturf(bonus_step))
		return

	var/turf/open/floor/BF = bonus_step
	while(isopenspace(BF))
		BF = GET_TURF_BELOW(BF)

	if(!isfloorturf(BF))
		return

	var/obj/structure/meatvine/existing = locate(/obj/structure/meatvine) in BF
	if(existing && !existing.master)
		existing.restore_vine(master)
		return

	if(!existing && can_enter_turf(BF))
		master.spawn_spacevine_piece(BF)

/obj/structure/meatvine/proc/can_enter_turf(turf/output_turf)
	if(output_turf.is_blocked_turf())
		return FALSE
	if(istype(output_turf, /turf/open/water) || istype(output_turf, /turf/open/lava))
		return FALSE
	if(locate(/obj/structure/hotspring, output_turf))
		return FALSE
	return TRUE

/obj/structure/meatvine/proc/rot()
	color = "#55ffff"
	master = null

	var/turf/T = get_turf(src)
	for(var/obj/structure/meatvineborder/Vine in T)
		Vine.color = "#55ffff"

	SSmeatvines.unregister_vine(src)

/obj/structure/meatvine/proc/restore_vine(obj/effect/meatvine_controller/new_master)
	if(!new_master)
		return FALSE

	color = initial(color)
	master = new_master
	new_master.vines += src

	var/turf/T = get_turf(src)
	for(var/obj/structure/meatvineborder/Vine in T)
		Vine.color = initial(Vine.color)

	update_borders()
	SSmeatvines.register_vine(src)

	return TRUE

/obj/structure/meatvine/update_overlays()
	. = ..()
	var/turf/T = get_turf(src)

	if(!borders)
		return

	for(var/direction in GLOB.alldirs)
		var/turf/step = get_step(T, direction)
		var/obj/structure/meatvine/Vine = locate(/obj/structure/meatvine) in step

		if(Vine)
			continue

		var/image/Overlay = image(icon = 'icons/obj/cellular/meat.dmi', icon_state = "tile_edge", dir = direction)
		Overlay.pixel_x = X_OFFSET(32, direction)
		Overlay.pixel_y = Y_OFFSET(32, direction)

		borders_overlays += Overlay
		. += Overlay

/obj/structure/meatvine/proc/update_borders()
	update_appearance()

	var/turf/T = get_turf(src)
	for(var/direction in GLOB.alldirs)
		var/turf/step = get_step(T, direction)
		var/obj/structure/meatvine/Vine = locate(/obj/structure/meatvine) in step

		if(!Vine)
			continue

		addtimer(CALLBACK(Vine, TYPE_PROC_REF(/atom, update_appearance)), 5)

/obj/structure/meatvine/proc/puff_gas(big = FALSE)
	if(!prob(50))
		return

	var/turf/T = get_turf(src)
	T.pollute_turf(/datum/pollutant/rot, 100)
	reagents.clear_reagents()

/obj/structure/meatvine/proc/transfer_feromones(amount)
	var/spread_chance = 5
	if(master && master.organic_matter >= master.organic_matter_per_spread)
		spread_chance = 15

	if(prob(spread_chance))
		spread()
		check_for_lair_spawn()

	feromone_weight += 10
	if(amount <= 1)
		return

	var/turf/T = get_turf(src)
	for(var/direction in GLOB.cardinals)
		var/turf/step = get_step(T, direction)
		var/obj/structure/meatvine/Vine = locate(/obj/structure/meatvine) in step
		if(!Vine)
			continue
		Vine.transfer_feromones(amount - 1)

/obj/effect/ebeam/meat
	name = "meat"
	icon_state = "meat"
