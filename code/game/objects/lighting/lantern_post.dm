/obj/machinery/light/fueled/lanternpost
	name = "lantern post"
	icon = 'icons/roguetown/misc/tallstructure.dmi'
	icon_state = "streetlantern1"
	base_state = "streetlantern"
	brightness = 5
	density = FALSE
	var/obj/item/flashlight/flare/torch/torchy
	fueluse = 0 //we use the torch's fuel
	soundloop = null
	crossfire = FALSE
	plane = GAME_PLANE_UPPER
	cookonme = FALSE
	temperature_change = 10
	fog_parter_effect = null
	var/permanent

/obj/machinery/light/fueled/lanternpost/fixed
	desc = "The lamptern is permanently built into the structure of this one."
	permanent = TRUE

/obj/machinery/light/fueled/lanternpost/unfixed
	desc = "A wooden post that can have a lamptern or a noose attached to it."
	permanent = FALSE
	on = FALSE

/obj/machinery/light/fueled/lanternpost/seton(s)
	. = ..()
	if(!torchy || torchy.fuel <= 0)
		on = FALSE
		set_light_on(on)

/obj/machinery/light/fueled/lanternpost/fire_act(added, maxstacks)
	if(torchy)
		if(!on)
			if(torchy.fuel > 0)
				torchy.spark_act()
				playsound(src, 'sound/items/firelight.ogg', 100)
				on = TRUE
				update()
				update_appearance(UPDATE_ICON_STATE)
				if(soundloop)
					soundloop.start()
				return TRUE

/obj/machinery/light/fueled/lanternpost/Initialize(mapload)
	if (mapload)
		torchy = new /obj/item/flashlight/flare/torch/lantern(src)
		torchy.spark_act()
	. = ..()

/obj/machinery/light/fueled/lanternpost/Destroy()
	if(torchy)
		QDEL_NULL(torchy)
	return ..()

/obj/machinery/light/fueled/lanternpost/process()
	if(on)
		if(torchy)
			if(torchy.fuel <= 0)
				burn_out()
			if(!torchy.on)
				burn_out()
		else
			return PROCESS_KILL

/obj/machinery/light/fueled/lanternpost/attack_hand(mob/user)
	. = ..()
	if(.)
		return
	if(torchy && !permanent)
		if(!istype(user) || !Adjacent(user) || !user.put_in_active_hand(torchy))
			torchy.forceMove(loc)
		torchy = null
		on = FALSE
		update()
		update_appearance(UPDATE_ICON_STATE)
		playsound(src, 'sound/foley/torchfixturetake.ogg', 100)

/obj/machinery/light/fueled/lanternpost/burn_out()
	if(torchy?.on)
		torchy.turn_off()
	..()

/obj/machinery/light/fueled/lanternpost/attackby(obj/item/W, mob/living/user, list/modifiers)
	if(istype(W, /obj/item/flashlight/flare/torch))
		var/obj/item/flashlight/flare/torch/LR = W
		if(torchy)
			if(LR.on && !on)
				if(torchy.fuel <= 0)
					to_chat(user, "<span class='warning'>The mounted lantern is burned out.</span>")
					return
				else
					torchy.spark_act()
					user.visible_message("<span class='info'>[user] lights [src].</span>")
					playsound(src, 'sound/items/firelight.ogg', 100)
					on = TRUE
					update()
					update_appearance(UPDATE_ICON_STATE)
					return
			if(!LR.on && on)
				if(LR.fuel > 0)
					LR.spark_act()
					user.visible_message("<span class='info'>[user] lights [LR] in [src].</span>")
					user.update_inv_hands()
		else
			if(LR.on)
				LR.forceMove(src)
				torchy = LR
				on = TRUE
				update()
				update_appearance(UPDATE_ICON_STATE)
			else
				LR.forceMove(src)
				torchy = LR
				update_appearance(UPDATE_ICON_STATE)
			playsound(src, 'sound/foley/torchfixtureput.ogg', 100)
		return
	if(istype(W, /obj/item/rope)&&!istype(W, /obj/item/rope/chain))
		if(!torchy)
			user.visible_message(span_notice("[user] begins to tie a noose on [src]..."), span_notice("I begin to tie a noose on [src]..."))
			if(do_after(user, 2 SECONDS, src))
				new /obj/structure/noose/gallows(loc)
				playsound(src, 'sound/foley/noose_idle.ogg', 100)
				qdel(W)
				qdel(src)
		else
			if(torchy && !permanent)
				to_chat(user, span_warning("I must remove [torchy] from [src] before I can tie [W]."))
			else
				to_chat(user, span_warning("There's no place for a rope on this one."))
	else
		. = ..()
