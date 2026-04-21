/datum/action/cooldown/spell/undirected/conjure_item/light
	name = "Conjure Light"
	desc = "Summons a condensed orb of light."
	button_icon_state = "light"
	sound = 'sound/magic/whiteflame.ogg'

	point_cost = 1

	cooldown_time = 30 SECONDS
	spell_cost = 50

	invocation = "Let there be light."
	invocation_type = INVOCATION_WHISPER
	spell_flags = SPELL_RITUOS
	delete_old = TRUE
	item_type = /obj/item/flashlight/flare/light
	item_duration = null

	attunements = list(
		/datum/attunement/light = 0.3,
	)

/datum/action/cooldown/spell/undirected/conjure_item/light/make_item()
	var/obj/item = ..()
	item.add_overlay(mutable_appearance('icons/obj/projectiles.dmi', "gumball"))
	return item

/obj/item/flashlight/flare/light
	name = "condensed light"
	desc = "An orb of condensed light."
	w_class = WEIGHT_CLASS_NORMAL
	light_outer_range = 10
	light_color = LIGHT_COLOR_WHITE
	force = 10
	icon = 'icons/roguetown/rav/obj/cult.dmi'
	icon_state = "sphere0"
	item_state = "sphere0"
	lefthand_file = 'icons/mob/inhands/items_lefthand.dmi'
	righthand_file = 'icons/mob/inhands/items_righthand.dmi'
	light_color = "#ffffff"
	on_damage = 10
	flags_1 = null
	possible_item_intents = list(/datum/intent/use)
	slot_flags = ITEM_SLOT_HIP
	max_integrity = 200
	fuel = 10 MINUTES
	light_depth = 0
	light_height = 0

/obj/item/flashlight/flare/light/getonmobprop(tag)
	. = ..()
	if(tag)
		switch(tag)
			if("gen")
				return list("shrink" = 0.7,"sx" = -9,"sy" = 3,"nx" = 12,"ny" = 4,"wx" = -6,"wy" = 5,"ex" = 3,"ey" = 6,"northabove" = 0,"southabove" = 1,"eastabove" = 1,"westabove" = 0,"nturn" = 2,"sturn" = 2,"wturn" = -2,"eturn" = -2,"nflip" = 0,"sflip" = 8,"wflip" = 8,"eflip" = 0)
			if("onbelt")
				return list("shrink" = 0.3,"sx" = -2,"sy" = -5,"nx" = 4,"ny" = -5,"wx" = 0,"wy" = -5,"ex" = 2,"ey" = -5,"nturn" = 0,"sturn" = 0,"wturn" = 0,"eturn" = 0,"nflip" = 0,"sflip" = 0,"wflip" = 0,"eflip" = 0,"northabove" = 0,"southabove" = 1,"eastabove" = 1,"westabove" = 0)

/obj/item/flashlight/flare/light/update_brightness(mob/user = null)
	..()
	item_state = "[initial(item_state)]"

/obj/item/flashlight/flare/light/process()
	item_state = "[initial(item_state)]"
	on = TRUE
	update_brightness()
	open_flame(heat)
	if(!fuel || !on)
		//turn_off()
		STOP_PROCESSING(SSobj, src)
		if(!fuel)
			item_state = "[initial(item_state)]"
		return
	if(!istype(loc,/obj/machinery/light/fueled/torchholder))
		if(!ismob(loc))
			if(prob(23))
				//turn_off()
				STOP_PROCESSING(SSobj, src)
				return

/obj/item/flashlight/flare/light/turn_off()
	playsound(src, 'sound/items/firesnuff.ogg', 100)
	STOP_PROCESSING(SSobj, src)
	..()
	if(ismob(loc))
		var/mob/M = loc
		M.update_inv_hands()
		M.update_inv_belt()
	damtype = BRUTE
	qdel(src)

/obj/item/flashlight/flare/light/fire_act(added, maxstacks)
	if(fuel)
		if(!on)
			playsound(src, 'sound/items/firelight.ogg', 100)
			on = TRUE
			damtype = BURN
			update_brightness()
			force = on_damage
			if(ismob(loc))
				var/mob/M = loc
				M.update_inv_hands()
			START_PROCESSING(SSobj, src)
			return TRUE
	..()

/obj/item/flashlight/flare/light/afterattack(atom/movable/A, mob/user, proximity, list/modifiers)
	. = ..()
	if(!proximity)
		return
	if(on)
		if(prob(50) || (user.used_intent.type == /datum/intent/use))
			if(ismob(A))
				A.spark_act()
			else
				A.fire_act(3,3)

/obj/item/flashlight/flare/light/spark_act()
	fire_act()

/obj/item/flashlight/flare/light/get_temperature()
	if(on)
		return 150+T0C
	return ..()

/obj/item/flashlight/flare/light/update_brightness(mob/user = null)
	..()
	if(on)
		item_state = "[initial(item_state)]"
	else
		item_state = "[initial(item_state)]"
