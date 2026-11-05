/obj/item/tablecloth
	name = "tablecloth"
	desc = "A decorative table cloth."
	icon = 'icons/roguetown/misc/structure.dmi'
	density = FALSE
	anchored = FALSE
	abstract_type = /obj/item/tablecloth

/obj/item/tablecloth/item_interaction(mob/living/user, obj/item/tool, list/modifiers)
	var/obj/structure/table/table = locate(/obj/structure/table) in get_turf(src)
	if(table)
		table.item_interaction(user, tool, modifiers)
		return NONE
	. = ..()

/obj/item/tablecloth/attack_hand(mob/living/user, obj/item/tool, list/modifiers)
	var/obj/structure/table/table = locate(/obj/structure/table) in get_turf(src)
	if(table)
		table.remove_tablecloth()
	. = ..()

/obj/item/tablecloth/examine(mob/user)
	. = ..()
	if(istype(src.loc, /obj/structure/table))
		. += span_info("The tablecloth is draped over a table, you can remove it by interacting with it using your hand.")

/obj/item/tablecloth/Initialize(TRUE)
	. = ..()
	var/obj/structure/table/table = locate(/obj/structure/table) in get_turf(src)
	if(table)
		forceMove(table)
		table.vis_contents += cloth
		cloth.vis_flags |= (VIS_INHERIT_PLANE|VIS_INHERIT_LAYER)

/obj/item/tablecloth/moon
	name = "moon tablecloth"
	desc = "A decorative table cloth depicting the moon."
	icon_state = "tablecloth_moon"

/obj/item/tablecloth/sun
	name = "sun tablecloth"
	desc = "A decorative table cloth depicting the sun."
	icon_state = "tablecloth_sun"
