
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

/obj/machinery/light/fueled/forge/attackby(obj/item/W, mob/living/user, list/modifiers)
	if(istype(W, /obj/item/weapon/tongs) && on)
		var/obj/item/weapon/tongs/T = W
		if(T.held_item)
			var/tyme = world.time
			T.hott = tyme
			T.proxy_heat(150, 1500)
			addtimer(CALLBACK(T, TYPE_PROC_REF(/obj/item/weapon/tongs, make_unhot), tyme), 100)
			T.update_appearance(UPDATE_ICON_STATE)
			user.visible_message("<span class='info'>[user] heats the bar.</span>")
			if(istype(W, /obj/item/weapon/tongs/stone))
				W.take_damage(1, BRUTE, "blunt")
			return TRUE
	if(istype(W, /obj/item/storage/crucible) && on)
		user.visible_message("<span class='info'>[user] places the [W] onto [src].</span>")
		W.forceMove(get_turf(src))
	return ..()
