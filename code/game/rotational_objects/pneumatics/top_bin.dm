#define CRATE_UNLOAD_DELAY (1.5 SECONDS)

/obj/structure/pneumatic_intake
	name = "pneumatic intake"
	desc = "A floor-level intake for the geared pneumatic disposal system."
	icon_state = "up"
	icon = 'icons/roguetown/misc/pipes.dmi'
	anchored = TRUE
	density = FALSE
	plane = FLOOR_PLANE
	layer = DISPOSAL_PIPE_LAYER
	obj_flags = CAN_BE_HIT
	max_integrity = 200
	var/list/obj/structure/closet/crate/pending_crates = list()

/obj/structure/pneumatic_intake/Initialize(mapload)
	. = ..()
	START_PROCESSING(SSobj, src)

/obj/structure/pneumatic_intake/Destroy()
	STOP_PROCESSING(SSobj, src)
	return ..()

/obj/structure/pneumatic_intake/item_interaction(mob/living/user, obj/item/tool, list/modifiers)
	if(!user.transferItemToLoc(tool, src))
		return NONE
	user.visible_message(
		span_notice("[user] places [tool] into [src]."),
		span_notice("You place [tool] into [src]."),
	)
	return ITEM_INTERACT_SUCCESS

/obj/structure/pneumatic_intake/proc/get_entry_pipe()
	for(var/obj/structure/pneumatic_tube/pipe in loc)
		if(color && pipe.color != color)
			continue
		return pipe
	return null

/obj/structure/pneumatic_intake/process(seconds_per_tick)
	check_for_crates()
	try_flush()

/obj/structure/pneumatic_intake/proc/try_flush()
	if(!length(contents))
		return
	var/obj/structure/pneumatic_tube/entry_pipe = get_entry_pipe()
	if(!entry_pipe)
		return

	var/list/cargo = contents.Copy()
	var/obj/structure/pneumatic_tube_parcel/parcel = new(loc)
	parcel.load(cargo)
	entry_pipe.receive_parcel(parcel, null)

/obj/structure/pneumatic_intake/proc/check_for_crates()
	for(var/obj/structure/closet/crate/crate in loc)
		if(crate.opened || (crate in pending_crates))
			continue
		pending_crates += crate
		addtimer(CALLBACK(src, PROC_REF(unload_crate), crate), CRATE_UNLOAD_DELAY)
	for(var/obj/structure/handcart/cart in loc)
		if((cart in pending_crates) || !length(cart.stuff_shit))
			continue
		pending_crates += cart
		addtimer(CALLBACK(src, PROC_REF(unload_cart), cart), CRATE_UNLOAD_DELAY)

/obj/structure/pneumatic_intake/proc/unload_crate(obj/structure/closet/crate/crate)
	pending_crates -= crate
	if(QDELETED(crate) || QDELETED(src))
		return
	if(crate.opened || crate.loc != loc)
		return
	for(var/atom/movable/thing as anything in crate.contents)
		thing.forceMove(src)

/obj/structure/pneumatic_intake/proc/unload_cart(obj/structure/handcart/cart)
	pending_crates -= cart
	if(QDELETED(cart) || QDELETED(src))
		return
	if(cart.loc != loc)
		return
	for(var/atom/movable/thing as anything in cart.stuff_shit.Copy())
		if(isliving(thing))
			continue
		cart.remove_from_cart(thing)
		thing.forceMove(src)

#undef CRATE_UNLOAD_DELAY
