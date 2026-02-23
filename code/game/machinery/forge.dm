
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
		var/time = world.time
		tongs.hott = time
		tongs.proxy_heat(150, 1500)
		addtimer(CALLBACK(tongs, TYPE_PROC_REF(/obj/item/weapon/tongs, make_unhot), 5 SECONDS), 100)
		tongs.update_appearance(UPDATE_ICON_STATE)
		user.visible_message("<span class='info'>[user] heats the bar.</span>")
		return ITEM_INTERACT_SUCCESS

	if(istype(tool, /obj/item/storage/crucible))
		if(!user.temporarilyRemoveItemFromInventory(tool))
			return ITEM_INTERACT_BLOCKING
		user.visible_message("<span class='info'>[user] places the [tool] onto [src].</span>")
		tool.forceMove(get_turf(src))
		return ITEM_INTERACT_SUCCESS
