
///////////
// EASEL //
///////////

/obj/structure/easel
	name = "easel"
	desc = ""
	icon = 'icons/paint_supplies/paint_items.dmi'
	icon_state = "easel"
	density = TRUE
	resistance_flags = FLAMMABLE
	max_integrity = 60
	var/obj/item/canvas/painting = null
	anchored = FALSE

//Adding canvases
/obj/structure/easel/item_interaction(mob/living/user, obj/item/tool, list/modifiers)
	if(!istype(tool, /obj/item/canvas))
		return NONE

	var/obj/item/canvas/C = tool
	user.dropItemToGround(C)
	painting = C
	painting.pixel_x = painting.base_pixel_x
	painting.pixel_y = painting.base_pixel_y + painting.easel_offset
	C.forceMove(get_turf(src))
	C.layer = layer+0.1
	user.visible_message("<span class='notice'>[user] puts \the [C] on \the [src].</span>","<span class='notice'>I place \the [C] on \the [src].</span>")
	return ITEM_INTERACT_SUCCESS

//Stick to the easel like glue
/obj/structure/easel/Move()
	var/turf/T = get_turf(src)
	. = ..()
	if(painting && painting.loc == T) //Only move if it's near us.
		painting.forceMove(get_turf(src))
	else
		painting = null

