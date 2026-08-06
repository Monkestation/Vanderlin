
/obj/item/rotation_contraption
	name = ""
	desc = ""

	w_class =  WEIGHT_CLASS_SMALL
	grid_height = 32
	grid_width = 32
	item_weight = 30 GRAMS

	var/obj/structure/placed_type
	var/in_stack = 1
	var/can_stack = TRUE
	var/place_behavior
	var/resize_factor

/obj/item/rotation_contraption/get_carry_weight(atom/carrier)
	. = item_weight * in_stack

/obj/item/rotation_contraption/Initialize()
	. = ..()
	if(placed_type)
		set_type(placed_type)
	if(can_stack)
		for(var/obj/item/rotation_contraption/contraption in loc)
			if(QDELETED(contraption))
				continue
			if(contraption == src)
				continue
			if(!istype(contraption, src.type))
				continue
			if(placed_type != contraption.placed_type)
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

/obj/item/rotation_contraption/interact_with_atom(atom/interacting_with, mob/living/user, list/modifiers)
	if(istype(interacting_with, /obj/item/rotation_contraption))
		if(!can_stack)
			return

		var/obj/item/rotation_contraption/rotator = interacting_with
		if(placed_type != rotator.placed_type)
			return

		in_stack += rotator.in_stack
		balloon_alert(user, "stacked!")
		update_appearance(UPDATE_NAME)
		qdel(rotator)

		return ITEM_INTERACT_SUCCESS

	var/turf/T = get_turf(interacting_with)

	for(var/obj/structure/structure in T)
		if(structure.rotation_structure && !ispath(placed_type, /obj/structure/water_pipe))
			return ITEM_INTERACT_BLOCKING

		if(structure.accepts_water_input && !ispath(placed_type, /obj/structure/rotation_piece))
			if(place_behavior != PLACE_ON_PIPE)
				return ITEM_INTERACT_BLOCKING
			if((place_behavior == PLACE_ON_PIPE) && !istype(structure, /obj/structure/water_pipe))
				return ITEM_INTERACT_BLOCKING

		if(istype(structure, placed_type))
			return ITEM_INTERACT_BLOCKING

	if(place_behavior == PLACE_ON_PIPE)
		if(!(locate(/obj/structure/water_pipe) in T))
			return ITEM_INTERACT_BLOCKING

	visible_message("[user] starts placing down [src].", "You start to place [src].")
	if(!do_after(user, 1.2 SECONDS - GET_MOB_SKILL_VALUE_OLD(user, /datum/attribute/skill/craft/engineering), T))
		return ITEM_INTERACT_BLOCKING

	var/obj/structure/structure = new placed_type(T)
	if(place_behavior == PLACE_TOWARDS_USER)
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
