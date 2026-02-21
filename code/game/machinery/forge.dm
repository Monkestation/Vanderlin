
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

/obj/machinery/light/fueled/forge/attackby(obj/item/attacking_item, mob/living/user, list/modifiers)
	if(!on)
		return ..()
	// TODO: REWRITE TONGS INTERACTIONS USING interact_with_atom()
	if(istype(attacking_item, /obj/item/weapon/tongs))
		var/obj/item/weapon/tongs/tongs = attacking_item
		if(tongs.held_item)
			tongs.heat_held_item(source = "tongs", duration = 30 SECONDS, incoming = 150, max_heat = 1500)
			user.visible_message(span_info("[user] heats [tongs.held_item] with [tongs]."))
			if(istype(attacking_item, /obj/item/weapon/tongs/stone))
				attacking_item.take_damage(1, BRUTE, BLUNT)
			return TRUE
	if(istype(attacking_item, /obj/item/storage/crucible))
		user.visible_message("<span class='info'>[user] places [attacking_item] onto [src].</span>")
		user.transferItemToLoc(attacking_item, get_turf(src), silent = TRUE)
		return TRUE
	return ..()
