
/obj/machinery/light/fueled/forge
	icon = 'icons/roguetown/misc/forge.dmi'
	name = "forge"
	icon_state = "forge0"
	base_state = "forge"
	density = TRUE
	anchored = TRUE
	on = FALSE
	climbable = TRUE
	climb_time = 0

/obj/machinery/light/fueled/forge/item_interaction(mob/living/user, obj/item/tool, list/modifiers)
	if(!on || user.cmode)
		return NONE

	if(istype(tool, /obj/item/weapon/tongs))
		var/obj/item/weapon/tongs/tongs = tool
		if(!tongs.held_item)
			return ITEM_INTERACT_BLOCKING
		tongs.heat_held_item(source = "tongs", duration = 30 SECONDS, incoming = 150, max_heat = 1500)
		user.visible_message(span_info("[user] heats [tongs.held_item] with [tongs]."))
		return ITEM_INTERACT_SUCCESS

	if(istype(tool, /obj/item/storage/crucible))
		if(!user.temporarilyRemoveItemFromInventory(tool))
			return ITEM_INTERACT_BLOCKING
		user.visible_message("<span class='info'>[user] places [tool] onto [src].</span>")
		user.transferItemToLoc(tool, get_turf(src), silent = TRUE)
		return ITEM_INTERACT_SUCCESS
