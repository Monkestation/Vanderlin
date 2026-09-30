
/obj/item/rotation_contraption
	name = ""
	desc = ""

	w_class = WEIGHT_CLASS_SMALL
	grid_height = 32
	grid_width = 32
	item_weight = 30 GRAMS

	var/obj/structure/placed_type
	var/in_stack = 1
	var/base_delay = 1 SECONDS
	var/can_stack = TRUE
	var/place_behavior
	var/resize_factor
	var/chosen_color

/obj/item/rotation_contraption/get_carry_weight(atom/carrier)
	. = item_weight * in_stack

/obj/item/rotation_contraption/Initialize()
	. = ..()
	if(placed_type)
		set_type(placed_type)
	if(can_stack)
		for(var/obj/item/rotation_contraption/contraption in loc)
			if(QDELETED(contraption) || contraption == src)
				continue
			if(!istype(contraption, src.type))
				continue
			if(placed_type != contraption.placed_type || chosen_color != contraption.chosen_color)
				continue

			in_stack += contraption.in_stack
			qdel(contraption)
	update_appearance(UPDATE_NAME)

/obj/item/rotation_contraption/afterpickup(mob/user)
	. = ..()
	var/matrix/resize = matrix()
	resize.Scale(0.5, 0.5)
	resize.Turn(45)
	transform = resize
	if(resize_factor)
		transform = transform.Scale(resize_factor, resize_factor)

/obj/item/rotation_contraption/afterdrop(mob/user)
	. = ..()
	var/matrix/resize = matrix()
	resize.Scale(0.5, 0.5)
	resize.Turn(45)
	transform = resize
	if(resize_factor)
		transform = transform.Scale(resize_factor, resize_factor)

/obj/item/rotation_contraption/proc/set_type(obj/structure/parent_type)
	icon = initial(parent_type.icon)
	icon_state = initial(parent_type.icon_state)
	var/matrix/resize = matrix()
	resize.Scale(0.5, 0.5)
	resize.Turn(45)
	transform = resize
	if(resize_factor)
		transform = transform.Scale(resize_factor, resize_factor)
	name = initial(parent_type.name) + " item"
	desc = initial(parent_type.desc)
	placed_type = parent_type

/obj/item/rotation_contraption/attack_self_secondary(mob/user, list/modifiers)
	. = ..()
	if(ispath(placed_type, /obj/structure/pneumatic_tube))
		select_pneumatic_color(user)
		return SECONDARY_ATTACK_CANCEL_ATTACK_CHAIN

/obj/item/rotation_contraption/proc/select_pneumatic_color(mob/user)
	var/static/list/pneumatic_color_options = list(
		"No Color (Uncolored)" = null,
		"Red" = "#810202",
		"Blue" = "#041e50",
		"Green" = "#006100",
		"Yellow" = "#866c03",
		"Purple" = "#450366",
		"Orange" = "#925612",
		"White" = "#ffffff",
		"Uncolored" = null,
	)

	var/choice = tgui_input_list(user, "Select Pneumatic Component Color", "Pneumatic Color", pneumatic_color_options)
	if(!choice || !user.can_perform_action(src))
		return

	chosen_color = pneumatic_color_options[choice]
	color = chosen_color
	to_chat(user, span_notice("Set [src] color setting to [choice]."))
	update_appearance(UPDATE_NAME)
	var/matrix/resize = matrix()
	resize.Scale(0.5, 0.5)
	resize.Turn(45)
	transform = resize
	if(resize_factor)
		transform = transform.Scale(resize_factor, resize_factor)

/obj/item/rotation_contraption/interact_with_atom(atom/interacting_with, mob/living/user, list/modifiers)
	if(isitem(interacting_with))
		if(istype(interacting_with, /obj/item/rotation_contraption))
			if(!can_stack)
				return

		var/obj/item/rotation_contraption/rotator = interacting_with
		if(placed_type != rotator.placed_type || chosen_color != rotator.chosen_color)
			return

		in_stack += rotator.in_stack
		balloon_alert(user, "stacked!")
		update_appearance(UPDATE_NAME)
		qdel(rotator)

		return ..()

	var/turf/T = get_turf(interacting_with)
	var/turf/wall_turf

	//click a wall, structure goes on your own tile, facing it
	if(place_behavior == PLACE_ON_WALL)
		if(!isclosedturf(interacting_with))
			balloon_alert(user, "must target a wall!")
			return ITEM_INTERACT_BLOCKING
		wall_turf = interacting_with
		T = get_turf(user)
		if(!T || T == wall_turf)
			return ITEM_INTERACT_BLOCKING

	// Pneumatic tube placement & stacking rules
	if(ispath(placed_type, /obj/structure/pneumatic_tube))
		for(var/obj/structure/pneumatic_tube/existing_pipe in T)
			if(!existing_pipe.color || !chosen_color)
				return ITEM_INTERACT_BLOCKING
			if(existing_pipe.color == chosen_color)
				return ITEM_INTERACT_BLOCKING

	// Intake & Gearbox placement onto pneumatic tubes
	if(place_behavior == PLACE_ON_PNEUMATIC_TUBE)
		var/obj/structure/pneumatic_tube/target_tube = null
		for(var/obj/structure/pneumatic_tube/pipe in T)
			if((!pipe.color && !chosen_color) || (pipe.color == chosen_color))
				target_tube = pipe
				break
		if(!target_tube)
			balloon_alert(user, "requires matching pneumatic tube!")
			return ITEM_INTERACT_BLOCKING

		for(var/obj/structure/existing_struct in T)
			if(istype(existing_struct, placed_type))
				return ITEM_INTERACT_BLOCKING

	for(var/obj/structure/structure in T)
		if(ispath(placed_type, /obj/structure/redstone))
			if(istype(structure, /obj/structure/redstone))
				return ITEM_INTERACT_BLOCKING
			continue
		if(structure.rotation_structure && !ispath(placed_type, /obj/structure/water_pipe) && !ispath(placed_type, /obj/structure/pneumatic_tube) && place_behavior != PLACE_ON_PNEUMATIC_TUBE && place_behavior != PLACE_ON_WALL)
			return ITEM_INTERACT_BLOCKING

		if(structure.accepts_water_input && !ispath(placed_type, /obj/structure/rotation_piece))
			if(place_behavior != PLACE_ON_PIPE)
				return ITEM_INTERACT_BLOCKING
			if((place_behavior == PLACE_ON_PIPE) && !istype(structure, /obj/structure/water_pipe))
				return ITEM_INTERACT_BLOCKING

		if(istype(structure, placed_type) && !ispath(placed_type, /obj/structure/pneumatic_tube))
			return ITEM_INTERACT_BLOCKING

	if(place_behavior == PLACE_ON_PIPE)
		if(!(locate(/obj/structure/water_pipe) in T))
			return ITEM_INTERACT_BLOCKING

	visible_message("[user] starts placing down [src].", "You start to place [src].")
	var/delay = max(base_delay - GET_MOB_SKILL_VALUE_OLD(user, /datum/attribute/skill/craft/engineering), 0)
	if(!do_after(user, delay, T))
		return ITEM_INTERACT_BLOCKING

	var/obj/structure/structure = new placed_type(T)
	if(chosen_color)
		structure.color = chosen_color

	if(istype(structure, /obj/structure/pneumatic_tube))
		var/obj/structure/pneumatic_tube/pipe = structure
		pipe.scan_connections()
	else if(istype(structure, /obj/structure/pneumatic_gearbox))
		var/obj/structure/pneumatic_gearbox/gearbox = structure
		gearbox.relink()

	if(place_behavior == PLACE_ON_WALL)
		structure.setDir(get_dir(T, wall_turf))
	else if(place_behavior == PLACE_TOWARDS_USER)
		if(get_turf(user) == T)
			structure.setDir(REVERSE_DIR(user.dir))
		else
			structure.setDir(get_cardinal_dir(T, user))
	else
		if(get_turf(user) == T)
			structure.setDir(user.dir)
		else
			structure.setDir(get_cardinal_dir(user, T))

	in_stack--
	if(in_stack <= 0)
		qdel(src)
	else
		update_appearance(UPDATE_NAME)

	return ITEM_INTERACT_SUCCESS

/obj/item/rotation_contraption/update_name()
	. = ..()
	if(in_stack > 1)
		name = "pile of [initial(placed_type.name)]s x [in_stack]"
	else
		name = initial(placed_type.name) + " item"

/obj/item/rotation_contraption/cog
	placed_type = /obj/structure/rotation_piece/cog
	item_weight = 55 GRAMS

/obj/item/rotation_contraption/shaft
	placed_type = /obj/structure/rotation_piece

/obj/item/rotation_contraption/large_cog
	placed_type = /obj/structure/rotation_piece/cog/large
	resize_factor = 1.5
	item_weight = 90 GRAMS

/obj/item/rotation_contraption/horizontal
	placed_type = /obj/structure/gearbox
	item_weight = 300 GRAMS

/obj/item/rotation_contraption/vertical
	placed_type = /obj/structure/vertical_gearbox
	item_weight = 300 GRAMS

/obj/item/rotation_contraption/waterwheel
	placed_type = /obj/structure/waterwheel

	grid_height = 96
	grid_width = 96

	resize_factor = 1.5
	item_weight = 4 KILOGRAMS

/obj/item/rotation_contraption/minecart_rail
	placed_type = /obj/structure/minecart_rail

	grid_height = 64
	grid_width = 32

/obj/item/rotation_contraption/minecart_rail/railbreak
	placed_type = /obj/structure/minecart_rail/railbreak

	grid_height = 64
	grid_width = 32
	item_weight = 130 GRAMS

/obj/item/rotation_contraption/water_pipe
	placed_type = /obj/structure/water_pipe
	item_weight = 140 GRAMS

/obj/item/rotation_contraption/pump
	placed_type = /obj/structure/water_pump
	can_stack = FALSE

	grid_height = 96
	grid_width = 96

	place_behavior = PLACE_TOWARDS_USER
	item_weight = 2.4 KILOGRAMS

/obj/item/rotation_contraption/boiler
	placed_type = /obj/structure/boiler
	can_stack = FALSE

	grid_height = 96
	grid_width = 96

	place_behavior = PLACE_TOWARDS_USER
	item_weight = 6.3 KILOGRAMS

/obj/item/rotation_contraption/steam_recharger
	placed_type = /obj/structure/steam_recharger
	can_stack = FALSE

	grid_height = 96
	grid_width = 96

	place_behavior = PLACE_TOWARDS_USER
	item_weight = 7.4 KILOGRAMS

/obj/item/rotation_contraption/water_vent
	placed_type = /obj/structure/water_vent

	grid_height = 64
	grid_width = 64

	place_behavior = PLACE_TOWARDS_USER
	item_weight = 200 GRAMS

/obj/item/rotation_contraption/water_vent/get_mechanics_examine(mob/user)
	. = ..()
	. += span_info("Sprays the contents of the attached pipe in the direction the vent is facing.")

/obj/item/rotation_contraption/sprinkler
	placed_type = /obj/structure/sprinkler
	grid_height = 64

	place_behavior = PLACE_ON_PIPE
	item_weight = 750 GRAMS

/obj/item/rotation_contraption/sprinkler/get_mechanics_examine(mob/user)
	. = ..()
	. += span_info("Sprays the contents of the attached pipe around it.")

/obj/item/rotation_contraption/pressurizer
	placed_type = /obj/structure/pressurizer
	grid_height = 64

	place_behavior = PLACE_ON_PIPE
	item_weight = 300 GRAMS

/obj/item/rotation_contraption/pressurizer/get_mechanics_examine(mob/user)
	. = ..()
	. += span_info("Increases the pressure of a pipe allowing you to move fluids farther.")

/obj/item/rotation_contraption/drain
	placed_type = /obj/structure/fluid_drain
	grid_height = 32

	place_behavior = PLACE_ON_PIPE
	item_weight = 125 GRAMS

/obj/item/rotation_contraption/drain/get_mechanics_examine(mob/user)
	. = ..()
	. += span_info("Drains suck up liquids on the floor, needs to be placed on a pipe.")

/obj/item/rotation_contraption/roller
	placed_type = /obj/structure/roller
	grid_height = 32
	grid_width = 32

/obj/item/rotation_contraption/roller/get_mechanics_examine(mob/user)
	. = ..()
	. += span_info("Rollers move loose items and mobs in their facing direction while powered.")

/obj/item/rotation_contraption/pneumatic_tube
	name = "pneumatic tube item"
	desc = "An underfloor pneumatic tube segment."
	placed_type = /obj/structure/pneumatic_tube
	item_weight = 100 GRAMS

/obj/item/rotation_contraption/pneumatic_tube/get_mechanics_examine(mob/user)
	. = ..()
	. += span_info("Pneumatic tubes use rotational force to move batches of items and insert them into containers, or shooting them out with force.")
	. += span_info("Use Right-click to change its color before placing!")

/obj/item/rotation_contraption/pneumatic_intake
	name = "pneumatic intake item"
	desc = "A floor-level intake for pneumatic tubes. Must be placed over a pneumatic tube of matching color."
	placed_type = /obj/structure/pneumatic_intake
	place_behavior = PLACE_ON_PNEUMATIC_TUBE
	can_stack = FALSE
	grid_height = 64
	grid_width = 64
	item_weight = 1.8 KILOGRAMS

/obj/item/rotation_contraption/pneumatic_intake/get_mechanics_examine(mob/user)
	. = ..()
	. += span_info("Pneumatic intakes sit ontop of tubes and suck items out of closed chests.")

/obj/item/rotation_contraption/pneumatic_gearbox
	name = "pneumatic gearbox item"
	desc = "Converts mechanical rotation to drive pneumatic networks."
	placed_type = /obj/structure/pneumatic_gearbox
	place_behavior = PLACE_ON_PNEUMATIC_TUBE
	grid_height = 64
	grid_width = 64
	item_weight = 2.2 KILOGRAMS

/obj/item/rotation_contraption/pneumatic_gearbox/get_mechanics_examine(mob/user)
	. = ..()
	. += span_info("Pneumatic gearboxes sit ontop of a tube and provide the suction needed to move items.")

/obj/item/rotation_contraption/drill
	name = "large drill item"
	desc = "A large drill that when deployed can drill things infront of it."
	placed_type = /obj/structure/drill
	can_stack = FALSE
	grid_height = 64
	grid_width = 64
	item_weight = 14.5 KILOGRAMS

/obj/item/rotation_contraption/drill/get_mechanics_examine(mob/user)
	. = ..()
	. += span_info("Large Drills will mine the turf its pointing towards while powered by rotational force.")
	. += span_info("A Puller Module Pneumatic tube can pull items from its storage.")

/obj/item/rotation_contraption/clutch
	name = "clutch item"
	desc = "A mechanical clutch."
	placed_type = /obj/structure/clutch
	grid_height = 64
	grid_width = 64
	item_weight = 200 GRAMS

/obj/item/rotation_contraption/clutch/get_mechanics_examine(mob/user)
	. = ..()
	. += span_info("When given redstone power alterates between breaking and running, useful for expensive contraptions you want to turn on sometimes.")

/obj/item/rotation_contraption/redstone_dust
	name = ""
	desc = "A pile of redstone dust."
	placed_type = /obj/structure/redstone/dust
	grid_height = 32
	grid_width = 32
	item_weight = 1 GRAMS
	base_delay = 0.01 SECONDS
	color = "#4A3B3B"

/obj/item/rotation_contraption/redstone_dust/get_mechanics_examine(mob/user)
	. = ..()
	. += span_info("When given redstone power carries it along.")

/obj/item/rotation_contraption/redstone_repeater
	desc = "A redstone circuit that fires after a delay."
	placed_type = /obj/structure/redstone/repeater
	grid_height = 64
	grid_width = 32
	item_weight = 100 GRAMS

/obj/item/rotation_contraption/redstone_repeater/get_mechanics_examine(mob/user)
	. = ..()
	. += span_info("When given redstone power after a delay sends it forward.")

/obj/item/rotation_contraption/redstone_comparator
	desc = "Compares or subtracts signals."
	placed_type = /obj/structure/redstone/comparator
	grid_height = 32
	grid_width = 32
	item_weight = 100 GRAMS

/obj/item/rotation_contraption/redstone_comparator/get_mechanics_examine(mob/user)
	. = ..()
	. += span_info("When given redstone power compares or subtracts signals.")
	. += span_info("Can be interacted with to change its mode.")

/obj/item/rotation_contraption/redstone_observer
	desc = "Compares or subtracts signals."
	placed_type = /obj/structure/redstone/observer
	grid_height = 32
	grid_width = 32
	item_weight = 100 GRAMS

/obj/item/rotation_contraption/redstone_observer/get_mechanics_examine(mob/user)
	. = ..()
	. += span_info("Watches the tile in front of it for changes, then sends a redstone signal")
	. += span_info("Also watches storage containers for changes.")
	. += span_info("Can be given a pneumatic filter to filter for specific things entering storage containers on that turf.")

/obj/item/rotation_contraption/redstone_torch
	name = "redstone torch item"
	desc = "Burns with an inverted signal."
	placed_type = /obj/structure/redstone/torch
	place_behavior = PLACE_ON_WALL
	grid_height = 32
	grid_width = 32
	item_weight = 15 GRAMS
	color = "#FF2200"

/obj/item/rotation_contraption/redstone_torch/get_mechanics_examine(mob/user)
	. = ..()
	. += span_info("Burns with an inverted redstone signal, if the mounted wall its on is powered turns off.")
	. += span_info("Click a wall to mount it, facing that wall.")

