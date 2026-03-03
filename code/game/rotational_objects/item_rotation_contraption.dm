
/obj/item/rotation_contraption
	name = ""
	desc = ""

	w_class =  WEIGHT_CLASS_SMALL
	grid_height = 32
	grid_width = 32

	var/obj/structure/placed_type
	var/in_stack = 1
	var/can_stack = TRUE
	var/place_behavior
	var/resize_factor

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

/obj/item/rotation_contraption/attack_atom(atom/attacked_atom, mob/living/user)
	var/turf/T = get_turf(attacked_atom)
	. = TRUE
	for(var/obj/structure/structure in T.contents)
		if(structure.rotation_structure && !ispath(placed_type, /obj/structure/water_pipe))
			return

		if(structure.accepts_water_input && !ispath(placed_type, /obj/structure/rotation_piece))
			if(place_behavior != PLACE_ON_PIPE)
				return
			if((place_behavior == PLACE_ON_PIPE) && !istype(structure, /obj/structure/water_pipe))
				return

		if(istype(structure, placed_type))
			return

	if(place_behavior == PLACE_ON_PIPE)
		var/obj/structure/water_pipe/pipe = locate(/obj/structure/water_pipe) in T.contents
		if(!pipe)
			return
	visible_message("[user] starts placing down [src].", "You start to place [src].")
	if(!do_after(user, 1.2 SECONDS - user.get_skill_level(/datum/skill/craft/engineering, TRUE), T))
		return
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

/obj/item/rotation_contraption/update_name()
	. = ..()
	if(in_stack > 1)
		name = "pile of [initial(placed_type.name)]s x [in_stack]"
	else
		name = initial(placed_type.name) + " item"

/obj/item/rotation_contraption/attackby(obj/item/I, mob/living/user, list/modifiers)
	. = ..()
	if(!can_stack)
		return
	if(!istype(I, src.type))
		return
	if(placed_type != I:placed_type)
		return

	I:in_stack += in_stack
	visible_message("[user] collects [src].")
	qdel(src)
	I.update_appearance(UPDATE_NAME)

/obj/item/rotation_contraption/cog
	placed_type = /obj/structure/rotation_piece/cog

/obj/item/rotation_contraption/shaft
	placed_type = /obj/structure/rotation_piece

/obj/item/rotation_contraption/large_cog
	placed_type = /obj/structure/rotation_piece/cog/large
	resize_factor = 1.5

/obj/item/rotation_contraption/horizontal
	placed_type = /obj/structure/gearbox

/obj/item/rotation_contraption/vertical
	placed_type = /obj/structure/vertical_gearbox

/obj/item/rotation_contraption/waterwheel
	placed_type = /obj/structure/waterwheel

	grid_height = 96
	grid_width = 96

	resize_factor = 1.5

/obj/item/rotation_contraption/minecart_rail
	placed_type = /obj/structure/minecart_rail

	grid_height = 64
	grid_width = 32

/obj/item/rotation_contraption/minecart_rail/railbreak
	placed_type = /obj/structure/minecart_rail/railbreak

	grid_height = 64
	grid_width = 32

/obj/item/rotation_contraption/water_pipe
	placed_type = /obj/structure/water_pipe

/obj/item/rotation_contraption/pump
	placed_type = /obj/structure/water_pump
	can_stack = FALSE

	grid_height = 96
	grid_width = 96

	place_behavior = PLACE_TOWARDS_USER

/obj/item/rotation_contraption/boiler
	placed_type = /obj/structure/boiler
	can_stack = FALSE

	grid_height = 96
	grid_width = 96

	place_behavior = PLACE_TOWARDS_USER

/obj/item/rotation_contraption/steam_recharger
	placed_type = /obj/structure/steam_recharger
	can_stack = FALSE

	grid_height = 96
	grid_width = 96

	place_behavior = PLACE_TOWARDS_USER

/obj/item/rotation_contraption/water_vent
	placed_type = /obj/structure/water_vent

	grid_height = 64
	grid_width = 64

	place_behavior = PLACE_TOWARDS_USER

/obj/item/rotation_contraption/sprinkler
	placed_type = /obj/structure/sprinkler
	grid_height = 64

	place_behavior = PLACE_ON_PIPE

/obj/item/rotation_contraption/pressurizer
	placed_type = /obj/structure/pressurizer
	grid_height = 64

	place_behavior = PLACE_ON_PIPE

/obj/item/rotation_contraption/drain
	placed_type = /obj/structure/fluid_drain
	grid_height = 32

	place_behavior = PLACE_ON_PIPE
