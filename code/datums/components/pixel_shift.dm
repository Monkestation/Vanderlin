#define SHIFTING_PARENT 1
#define SHIFTING_ITEMS 2

/datum/component/pixel_shift
	dupe_mode = COMPONENT_DUPE_UNIQUE
	//what type of shifting parent is doing, or if they aren't shifting at all
	var/shifting = FALSE
	//the maximum amount we/an item can move
	var/maximum_pixel_shift = 16
	//If we are shifted
	var/is_shifted = FALSE
	//Amount of shifting necessary to make the parent passthroughable
	var/passthrough_threshold = 8

/datum/component/pixel_shift/Initialize(...)
	. = ..()
	if(!isliving(parent))
		return COMPONENT_INCOMPATIBLE

/datum/component/pixel_shift/RegisterWithParent()
	RegisterSignal(parent, COMSIG_KB_LIVING_ITEM_PIXEL_SHIFT_DOWN, PROC_REF(item_pixel_shift_down))
	RegisterSignal(parent, COMSIG_KB_LIVING_ITEM_PIXEL_SHIFT_UP, PROC_REF(item_pixel_shift_up))
	RegisterSignal(parent, COMSIG_KB_LIVING_PIXEL_SHIFT_DOWN, PROC_REF(pixel_shift_down))
	RegisterSignal(parent, COMSIG_KB_LIVING_PIXEL_SHIFT_UP, PROC_REF(pixel_shift_up))
	RegisterSignal(parent, COMSIG_MOB_CLIENT_PRE_MOVE, PROC_REF(pre_move_check))

/datum/component/pixel_shift/UnregisterFromParent()
	UnregisterSignal(parent, list(
		COMSIG_KB_LIVING_ITEM_PIXEL_SHIFT_DOWN,
		COMSIG_KB_LIVING_ITEM_PIXEL_SHIFT_UP,
		COMSIG_KB_LIVING_PIXEL_SHIFT_DOWN,
		COMSIG_KB_LIVING_PIXEL_SHIFT_UP,
		COMSIG_MOB_CLIENT_PRE_MOVE,
	))

//locks our movement when holding our keybinds
/datum/component/pixel_shift/proc/pre_move_check(mob/source, list/move_args)
	SIGNAL_HANDLER
	if(shifting)
		pixel_shift(source, move_args[MOVE_ARG_DIRECTION])
		return COMSIG_MOB_CLIENT_BLOCK_PRE_MOVE

//Procs for shifting items

/datum/component/pixel_shift/proc/item_pixel_shift_down()
	SIGNAL_HANDLER
	shifting = SHIFTING_ITEMS
	return TRUE

/datum/component/pixel_shift/proc/item_pixel_shift_up()
	SIGNAL_HANDLER
	shifting = FALSE

//Procs for shifting mobs

/datum/component/pixel_shift/proc/pixel_shift_down()
	SIGNAL_HANDLER
	shifting = SHIFTING_PARENT
	return TRUE

/datum/component/pixel_shift/proc/pixel_shift_up()
	SIGNAL_HANDLER
	shifting = FALSE

/// In-turf pixel movement which can allow things to pass through if the threshold is met.
/datum/component/pixel_shift/proc/pixel_shift(mob/source, direct)
	var/mob/living/owner = parent
	switch(shifting)
		if(SHIFTING_ITEMS)
			var/atom/pulled_atom = source.pulling
			if(!isitem(pulled_atom))
				return
			var/obj/item/pulled_item = pulled_atom
			switch(direct)
				if(NORTH)
					if(pulled_item.pixel_y <= maximum_pixel_shift)
						pulled_item.pixel_y++
				if(EAST)
					if(pulled_item.pixel_x <= maximum_pixel_shift)
						pulled_item.pixel_x++
				if(SOUTH)
					if(pulled_item.pixel_y >= -maximum_pixel_shift)
						pulled_item.pixel_y--
				if(WEST)
					if(pulled_item.pixel_x >= -maximum_pixel_shift)
						pulled_item.pixel_x--
		if(SHIFTING_PARENT)
			switch(direct)
				if(NORTH)
					if(owner.pixelshift_y <= maximum_pixel_shift)
						owner.pixelshift_y++
						owner.pixelshifted = TRUE
				if(EAST)
					if(owner.pixelshift_x <= maximum_pixel_shift)
						owner.pixelshift_x++
						owner.pixelshifted = TRUE
				if(SOUTH)
					if(owner.pixelshift_y >= -maximum_pixel_shift)
						owner.pixelshift_y--
						owner.pixelshifted = TRUE
				if(WEST)
					if(owner.pixelshift_x >= -maximum_pixel_shift)
						owner.pixelshift_x--
						owner.pixelshifted = TRUE
			owner.set_mob_offsets("pixel_shift", _x = owner.pixelshift_x, _y = owner.pixelshift_y)

#undef SHIFTING_PARENT
#undef SHIFTING_ITEMS
