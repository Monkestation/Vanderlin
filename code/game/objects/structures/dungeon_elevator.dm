#define DUNGEON_ELEVATOR_LINK_ID "dungeon-link"
#define DUNGEON_ELEVATOR_SIZE 2

/// stop_id -> landmark marking the dungeon-side end of the link
GLOBAL_LIST_EMPTY(dungeon_elevator_below_landmarks)

/obj/effect/landmark/dungeon_elevator_below
	name = "dungeon elevator link (below)"
	/// Matches the stop_id on the elevator that should use this landmark.
	var/stop_id = DUNGEON_ELEVATOR_LINK_ID

/obj/effect/landmark/dungeon_elevator_below/Initialize(mapload)
	. = ..()
	GLOB.dungeon_elevator_below_landmarks[stop_id] = src

/obj/effect/landmark/dungeon_elevator_below/Destroy()
	if(GLOB.dungeon_elevator_below_landmarks[stop_id] == src)
		GLOB.dungeon_elevator_below_landmarks -= stop_id
	return ..()

/obj/effect/dungeon_elevator_floor
	name = "elevator platform"
	desc = "A heavy elevator platform."
	icon_state = ""
	anchored = TRUE
	density = FALSE
	// Wherever the lift currently sits it is a solid floor for that level
	// (nothing falls through or climbs out of it) and it seals the shaft from
	// below. Falling into it from above is still allowed, so things land on it.
	// When the lift leaves, the level it left is an open shaft again.
	obj_flags = BLOCK_Z_OUT_DOWN | BLOCK_Z_OUT_UP | BLOCK_Z_IN_UP
	/// Tile offset from the lift's origin.
	var/offset_x = 0
	var/offset_y = 0

/obj/structure/dungeon_elevator
	name = "dungeon elevator"
	desc = "A rickety lift platform. It looks like it can only take so much weight going up."
	icon = 'icons/delver/desert_elevator.dmi'
	icon_state = "elevator"
	anchored = TRUE
	density = FALSE
	layer = LOW_OBJ_LAYER
	bound_width = 64
	bound_height = 64
	resistance_flags = INDESTRUCTIBLE | LAVA_PROOF | FIRE_PROOF | UNACIDABLE | ACID_PROOF | FREEZE_PROOF


	/// Matches the stop_id of the below landmark.
	var/stop_id = DUNGEON_ELEVATOR_LINK_ID
	/// Total carry weight above which the lift refuses to rise.
	var/max_up_weight = 500 KILOGRAMS
	/// Most levels the lift will descend looking for solid floor.
	var/max_depth = 20
	/// Time to travel a single level, in deciseconds.
	var/level_travel_time = 2 SECONDS
	/// Time between trips: how long it waits at home before descending, and at the
	/// bottom before rising.
	var/cycle_delay = 60 SECONDS
	/// How often an overweight lift re-checks its load while stuck on the way up.
	var/retry_delay = 5 SECONDS

	/// TRUE while the lift is parked at the bottom.
	var/at_bottom = FALSE
	/// DOWN or UP while a trip is in progress, null while parked.
	var/heading
	/// Origins of the levels visited below home, in order. The last entry is where we are.
	var/list/level_stack
	var/turf/home_origin
	var/list/floor_parts
	/// The single pending timer (either a wait at a stop or the next level step).
	var/timer_id

/obj/structure/dungeon_elevator/Initialize(mapload)
	. = ..()
	return INITIALIZE_HINT_LATELOAD

/obj/structure/dungeon_elevator/LateInitialize()
	home_origin = get_turf(src)
	level_stack = list()

	#ifndef NO_DUNGEON
	var/obj/effect/landmark/dungeon_elevator_below/marker = GLOB.dungeon_elevator_below_landmarks[stop_id]
	if(!marker)
		log_mapping("[src] at [AREACOORD(src)] has no below landmark with stop_id '[stop_id]'!")
		return
	var/turf/below_origin = get_turf(marker)

	// Build the 2x2 platform at home.
	floor_parts = list()
	for(var/dx in 0 to (DUNGEON_ELEVATOR_SIZE - 1))
		for(var/dy in 0 to (DUNGEON_ELEVATOR_SIZE - 1))
			var/turf/T = locate(home_origin.x + dx, home_origin.y + dy, home_origin.z)
			if(!T)
				continue
			var/obj/effect/dungeon_elevator_floor/part = new(T)
			part.offset_x = dx
			part.offset_y = dy
			floor_parts += part

	link_region(below_origin, home_origin, 2, 2)

	queue_cycle()
	#endif

/obj/structure/dungeon_elevator/Destroy()
	if(timer_id)
		deltimer(timer_id)
		timer_id = null
	for(var/obj/effect/dungeon_elevator_floor/part as anything in floor_parts)
		qdel(part)
	floor_parts = null
	level_stack = null
	home_origin = null
	return ..()

/// True if the 2x2 footprint at this origin has solid floor (any tile that isn't open space).
/obj/structure/dungeon_elevator/proc/is_solid_footprint(turf/origin)
	for(var/dx in 0 to (DUNGEON_ELEVATOR_SIZE - 1))
		for(var/dy in 0 to (DUNGEON_ELEVATOR_SIZE - 1))
			var/turf/T = locate(origin.x + dx, origin.y + dy, origin.z)
			if(T && !istype(T, /turf/open/openspace))
				return TRUE
	return FALSE

/// Everything currently riding the lift (excludes the platform and anchored things).
/obj/structure/dungeon_elevator/proc/get_riders()
	var/list/riders = list()
	var/turf/origin = get_turf(src)
	if(!origin)
		return riders
	for(var/dx in 0 to (DUNGEON_ELEVATOR_SIZE - 1))
		for(var/dy in 0 to (DUNGEON_ELEVATOR_SIZE - 1))
			var/turf/T = locate(origin.x + dx, origin.y + dy, origin.z)
			if(!T)
				continue
			for(var/atom/movable/AM as anything in T)
				if(AM == src || AM.anchored)
					continue
				if(isobserver(AM) || istype(AM, /mob/camera))
					continue
				riders += AM
	return riders

/// Total carry weight of everything on the lift.
/obj/structure/dungeon_elevator/proc/get_load_weight()
	var/total = 0
	for(var/atom/movable/AM as anything in get_riders())
		if(isitem(AM))
			total += AM:get_carry_weight()
		if(isliving(AM))
			total += AM:carry_weight
	return total

/// Relocates the platform and everything riding it to dest.
/obj/structure/dungeon_elevator/proc/move_to(turf/dest)
	var/turf/origin = get_turf(src)
	if(!dest || !origin)
		return FALSE

	// Work out destinations before anything moves.
	var/list/riders = get_riders()
	var/list/rider_dests = list()
	for(var/atom/movable/AM as anything in riders)
		rider_dests[AM] = locate(dest.x + (AM.x - origin.x), dest.y + (AM.y - origin.y), dest.z)

	// Platform first so riders always land on a floor.
	forceMove(dest)
	for(var/obj/effect/dungeon_elevator_floor/part as anything in floor_parts)
		var/turf/part_turf = locate(dest.x + part.offset_x, dest.y + part.offset_y, dest.z)
		if(part_turf)
			part.forceMove(part_turf)

	for(var/atom/movable/AM as anything in riders)
		var/turf/rider_turf = rider_dests[AM]
		if(rider_turf)
			AM.forceMove(rider_turf)
	return TRUE

/// Schedules the next trip from wherever the lift is parked.
/obj/structure/dungeon_elevator/proc/queue_cycle()
	if(timer_id || heading)
		return
	timer_id = addtimer(CALLBACK(src, PROC_REF(cycle_step)), cycle_delay, TIMER_STOPPABLE)

/// A wait at a stop is over: start heading the other way.
/obj/structure/dungeon_elevator/proc/cycle_step()
	timer_id = null
	heading = at_bottom ? UP : DOWN
	at_bottom = FALSE
	visible_message(span_notice("The elevator rumbles into motion."))
	queue_step(level_travel_time)

/obj/structure/dungeon_elevator/proc/queue_step(delay)
	timer_id = addtimer(CALLBACK(src, PROC_REF(take_step)), delay, TIMER_STOPPABLE)

/// Moves exactly one level in the current heading.
/obj/structure/dungeon_elevator/proc/take_step()
	timer_id = null
	if(heading == DOWN)
		step_down()
	else
		step_up()

/obj/structure/dungeon_elevator/proc/step_down()
	var/turf/next = GET_TURF_BELOW(get_turf(src))
	if(!next)
		if(!length(level_stack))
			visible_message(span_warning("The elevator clanks, finding no floor to land on."))
			heading = null
			queue_cycle()
		else
			land()
		return
	move_to(next)
	level_stack += next
	if(is_solid_footprint(next) || length(level_stack) >= max_depth)
		land()
	else
		queue_step(level_travel_time)

/obj/structure/dungeon_elevator/proc/step_up()
	if(get_load_weight() > max_up_weight)
		visible_message(span_warning("The elevator groans under the weight and refuses to rise!"))
		queue_step(retry_delay)
		return
	// Leave the level we're on and return to the one before it.
	level_stack.Cut(length(level_stack))
	var/turf/dest = length(level_stack) ? level_stack[length(level_stack)] : home_origin
	move_to(dest)
	if(length(level_stack))
		queue_step(level_travel_time)
	else
		arrive_home()

/obj/structure/dungeon_elevator/proc/land()
	heading = null
	at_bottom = TRUE
	visible_message(span_notice("The elevator creaks to a stop at the bottom."))
	queue_cycle()

/obj/structure/dungeon_elevator/proc/arrive_home()
	heading = null
	at_bottom = FALSE
	visible_message(span_notice("The elevator creaks to a stop."))
	queue_cycle()

#undef DUNGEON_ELEVATOR_SIZE
#undef DUNGEON_ELEVATOR_LINK_ID
