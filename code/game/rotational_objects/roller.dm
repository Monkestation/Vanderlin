//Make a component to do things like gravity/flying checks
///Manages the loop caused by being on a conveyor belt
///Prevents movement while you're floating, etc
///Takes the direction to move, delay between steps, and time before starting to move as arguments
/datum/component/convey
	var/living_parent = FALSE
	var/speed

/datum/component/convey/Initialize(direction, speed, start_delay)
	if(!ismovable(parent))
		return COMPONENT_INCOMPATIBLE

	living_parent = isliving(parent)
	src.speed = speed
	if(!start_delay)
		start_delay = speed
	var/atom/movable/moving_parent = parent
	var/datum/move_loop/loop = SSmove_manager.move(moving_parent, direction, delay = start_delay, subsystem = SSconveyors, flags=MOVEMENT_LOOP_IGNORE_PRIORITY)
	RegisterSignal(loop, COMSIG_MOVELOOP_PREPROCESS_CHECK, PROC_REF(should_move))
	RegisterSignal(loop, COMSIG_PARENT_QDELETING, PROC_REF(loop_ended))

/datum/component/convey/proc/should_move(datum/move_loop/source)
	SIGNAL_HANDLER
	source.delay = speed //We use the default delay
	if(living_parent)
		var/mob/living/moving_mob = parent
		if((moving_mob.movement_type & FLYING) && !moving_mob.stat)
			return MOVELOOP_SKIP_STEP
	var/atom/movable/moving_parent = parent
	if(moving_parent.anchored)
		return MOVELOOP_SKIP_STEP

/datum/component/convey/proc/loop_ended(datum/source)
	SIGNAL_HANDLER
	if(QDELETED(src))
		return
	qdel(src)

/obj/structure/roller
	name = "roller"
	desc = "A rotating roller that moves items in one direction. Can be powered by rotation from the sides."
	icon = 'icons/obj/roller.dmi'
	icon_state = "roller"
	density = FALSE
	anchored = TRUE
	layer = BELOW_OPEN_DOOR_LAYER
	rotation_structure = TRUE
	stress_use = 0
	initialize_dirs = CONN_DIR_LEFT | CONN_DIR_RIGHT | CONN_DIR_FORWARD | CONN_DIR_FLIP

	var/operating = FALSE
	var/movedir

	var/list/connected_rollers = list()

/obj/structure/roller/Initialize(mapload)
	. = ..()
	movedir = dir

	var/static/list/loc_connections = list(
		COMSIG_ATOM_ENTERED = PROC_REF(on_entered),
		COMSIG_ATOM_EXIT = PROC_REF(roller_exit),
	)
	AddElement(/datum/element/connect_loc, loc_connections)

	return INITIALIZE_HINT_LATELOAD

/obj/structure/roller/LateInitialize()
	. = ..()
	set_connection_dir()
	find_rotation_network()
	build_roller_chain()

/obj/structure/roller/Destroy()
	for(var/obj/structure/roller/connected in connected_rollers)
		connected.connected_rollers -= src
	connected_rollers = list()

	return ..()

/obj/structure/roller/examine(mob/user)
	. = ..()
	. += span_notice("It moves items [dir2text(movedir)].")
	. += span_notice("Rotation can be connected from the [get_rotation_sides_text()] sides.")
	if(rotation_network)
		. += span_notice("RPM: [rotations_per_minute]")
		. += span_notice("Rollers don't consume stress from the network.")
	. += span_notice("Use a <b>wrench</b> to rotate it.")
	. += span_notice("Use a <b>crowbar</b> to deconstruct it.")

/obj/structure/roller/proc/get_rotation_sides_text()
	var/list/sides = list()
	switch(dir)
		if(NORTH, SOUTH)
			sides = list("east", "west")
		if(EAST, WEST)
			sides = list("north", "south")
	return english_list(sides)

/obj/structure/roller/can_connect(obj/structure/connector)
	. = ..()
	if(!.)
		return FALSE

	var/connect_dir = get_dir(src, connector)

	// If connecting from front/back, only allow other aligned rollers
	if(connect_dir == movedir || connect_dir == REVERSE_DIR(movedir))
		if(!istype(connector, /obj/structure/roller))
			return FALSE
		var/obj/structure/roller/other_roller = connector
		if(other_roller.movedir != movedir && other_roller.movedir != REVERSE_DIR(movedir))
			return FALSE

	return TRUE

/obj/structure/roller/setDir(newdir)
	. = ..()
	movedir = newdir
	update_appearance()

/obj/structure/roller/rotation_break()
	set_rotations_per_minute(0)

/obj/structure/roller/set_stress_use(new_stress, check_network)
	return TRUE

/obj/structure/roller/set_rotations_per_minute(rpm)
	if(rotations_per_minute == rpm)
		return FALSE

	rotations_per_minute = rpm

	if(rpm > 0)
		operating = TRUE
	else
		operating = FALSE
		for(var/atom/movable/movable in loc)
			stop_conveying(movable)

	update_appearance()
	propagate_rotation()
	return TRUE

/obj/structure/roller/proc/propagate_rotation()
	for(var/obj/structure/roller/connected in connected_rollers)
		if(connected.rotations_per_minute != rotations_per_minute)
			connected.set_rotations_per_minute(rotations_per_minute)

/obj/structure/roller/proc/build_roller_chain()
	var/turf/forward_turf = get_step(src, movedir)
	var/obj/structure/roller/forward_roller = locate(/obj/structure/roller) in forward_turf

	if(forward_roller && (forward_roller.movedir == movedir || forward_roller.movedir == REVERSE_DIR(movedir)))
		connected_rollers |= forward_roller
		forward_roller.connected_rollers |= src

/obj/structure/roller/proc/get_move_delay()
	// Higher RPM = faster movement (shorter delay)
	// At 16 RPM: 1 second, at 32 RPM: 0.5 seconds, at 64 RPM: 0.25 seconds
	return max(1, (10 / (rotations_per_minute / 16))) // Returns deciseconds

/obj/structure/roller/proc/on_entered(datum/source, atom/movable/entering_atom)
	SIGNAL_HANDLER

	if(!operating || !rotations_per_minute)
		return

	if(!ismovable(entering_atom))
		return

	var/static/list/unconveyables = typecacheof(list(/obj/effect, /mob/dead))
	if(is_type_in_typecache(entering_atom, unconveyables))
		return

	if(entering_atom.anchored || entering_atom == src)
		return

	start_conveying(entering_atom)

/obj/structure/roller/proc/start_conveying(atom/movable/moving)
	if(QDELETED(moving))
		return

	var/datum/move_loop/move/existing_loop = SSmove_manager.processing_on(moving, SSconveyors)
	if(existing_loop)
		existing_loop.direction = movedir
		existing_loop.delay = get_move_delay()
		return

	moving.AddComponent(/datum/component/convey, movedir, get_move_delay())

/obj/structure/roller/proc/stop_conveying(atom/movable/thing)
	if(!ismovable(thing))
		return
	SSmove_manager.stop_looping(thing, SSconveyors)

/obj/structure/roller/proc/roller_exit(datum/source, atom/movable/exiting_atom, turf/exit_turf)
	SIGNAL_HANDLER

	if(!ismovable(exiting_atom))
		return

	var/obj/structure/roller/next_roller = locate(/obj/structure/roller) in exit_turf

	// Stop conveying if no operating roller in exit direction
	if(!next_roller || !next_roller.operating)
		stop_conveying(exiting_atom)

/obj/structure/roller/wrench_act(mob/living/user, obj/item/tool)
	tool.play_tool_sound(src, 50)
	setDir(turn(dir, 90))
	to_chat(user, span_notice("You rotate [src]."))

	connected_rollers = list()
	build_roller_chain()
	return TRUE

/obj/structure/roller/update_appearance()
	. = ..()
	if(operating && rotations_per_minute > 0)
		update_animation_effect()

/obj/structure/roller/update_animation_effect()
	if(!rotation_network || rotation_network.overstressed || !rotations_per_minute)
		animate(src, icon_state = "roller", time = 1)
		return

	var/frame_time = 1 / ((rotations_per_minute / 60) * 4)

	animate(src, icon_state = "roller1", time = frame_time, loop = -1)
	animate(icon_state = "roller2", time = frame_time)
	animate(icon_state = "roller3", time = frame_time)
	animate(icon_state = "roller4", time = frame_time)

/obj/structure/roller_sorter
	name = "roller sorter"
	desc = "A specialized roller that can sort items based on type."
	icon = 'icons/obj/roller.dmi'
	icon_state = "roller_sorter"
	density = FALSE
	anchored = TRUE
	layer = BELOW_OPEN_DOOR_LAYER

	var/obj/structure/roller/parent_roller
	var/list/sorting_list = list()
	var/sort_direction = NORTH

	COOLDOWN_DECLARE(use_cooldown)

/obj/structure/roller_sorter/Initialize(mapload)
	. = ..()

	var/static/list/loc_connections = list(
		COMSIG_ATOM_ENTERED = PROC_REF(on_entered),
	)
	AddElement(/datum/element/connect_loc, loc_connections)

/obj/structure/roller_sorter/examine(mob/user)
	. = ..()
	. += span_notice("Sorts items to the [dir2text(sort_direction)] when they match the filter.")
	. += span_notice("Currently sorting [length(sorting_list)] item types.")
	. += span_notice("Click with empty hand to change sort direction.")
	. += span_notice("Alt-Click to clear sorting list.")

/obj/structure/roller_sorter/attack_hand(mob/living/user, list/modifiers)
	var/list/directions = list("North", "East", "South", "West")
	var/user_choice = browser_input_list(user, "Choose which direction to sort to!", "Direction choice", directions)
	if(!user_choice)
		return ..()

	sort_direction = text2dir(user_choice)
	visible_message("[src] clicks, updating its sorting direction!")

/obj/structure/roller_sorter/AltClick(mob/user, list/modifiers)
	. = ..()
	visible_message("[src] beeps, resetting its sorting list!")
	sorting_list = list()

/obj/structure/roller_sorter/proc/on_entered(datum/source, atom/movable/entering_atom)
	SIGNAL_HANDLER

	if(!ismovable(entering_atom))
		return

	if(entering_atom.anchored)
		return

	if(!is_type_in_list(entering_atom, sorting_list))
		return

	if(COOLDOWN_FINISHED(src, use_cooldown))
		COOLDOWN_START(src, use_cooldown, 1 SECONDS)
		entering_atom.Move(get_step(src, sort_direction))

/obj/structure/roller/wrench_act(mob/living/user, obj/item/tool)
	tool.play_tool_sound(src, 50)
	setDir(turn(dir, 90))
	to_chat(user, span_notice("You rotate [src]."))

	// Rebuild connections (parent's setDir handles rotation network)
	connected_rollers = list()
	build_roller_chain()
	return TRUE

/obj/structure/roller/attackby(obj/item/attacking_item, mob/user, params)
	if(istype(attacking_item, /obj/item/roller_sorter_lister))
		var/obj/structure/roller_sorter/new_sorter = new(get_turf(src))
		new_sorter.parent_roller = src
		to_chat(user, span_notice("You attach a sorter to [src]."))
		return

	return ..()

/obj/structure/roller/update_appearance()
	. = ..()
	if(operating && rotations_per_minute > 0)
		update_animation_effect()

/obj/structure/roller/update_animation_effect()
	if(!rotation_network || rotation_network.overstressed || !rotations_per_minute)
		animate(src, icon_state = "roller", time = 1)
		return

	// Animate based on RPM
	var/frame_stage = 1 / ((rotations_per_minute / 60) * 4)

	animate(src, icon_state = "roller1", time = frame_stage, loop = -1)
	animate(icon_state = "roller2", time = frame_stage)
	animate(icon_state = "roller3", time = frame_stage)
	animate(icon_state = "roller4", time = frame_stage)


/obj/item/roller_sorter_lister
	name = "roller sorter attachment"
	desc = "An attachment that can be placed on rollers to sort items."
	icon = 'icons/obj/roller.dmi'
	icon_state = "sorter_construct"
	w_class = WEIGHT_CLASS_SMALL

	var/list/current_sort = list()
	var/max_items = 5

/obj/item/roller_sorter_lister/examine(mob/user)
	. = ..()
	. += span_notice("Can sort up to <b>[max_items]</b> item types.")
	. += span_notice("Attack items to add them to the sorting list.")
	. += span_notice("Alt-Click to reset the sorting list.")

/obj/item/roller_sorter_lister/afterattack(atom/target, mob/user, proximity_flag, list/modifiers)
	if(target == src || !proximity_flag)
		return ..()

	if(!ismovable(target))
		return ..()

	if(is_type_in_list(target, current_sort))
		to_chat(user, span_warning("[target] is already in the sorting list!"))
		return

	if(length(current_sort) >= max_items)
		to_chat(user, span_warning("The sorting list is full!"))
		return

	current_sort += target.type
	to_chat(user, span_notice("[target] has been added to the sorting list."))

/obj/item/roller_sorter_lister/AltClick(mob/user, list/modifiers)
	. = ..()
	visible_message("The sorting list has been reset!")
	current_sort = list()
