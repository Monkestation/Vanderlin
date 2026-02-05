/obj/structure/steam_recharger
	name = "steam injector"
	desc = "Fills objects with steam. Can also recharge automatons."
	icon = 'icons/obj/structures/rotation_devices/steam_recharger.dmi'
	icon_state = "rechargetable"
	accepts_water_input = TRUE
	var/obj/item/placed_atom
	var/mob/living/carbon/human/placed_mob
	var/doing = FALSE

/obj/structure/steam_recharger/Initialize()
	. = ..()
	START_PROCESSING(SSobj, src)

/obj/structure/steam_recharger/Destroy()
	if(placed_mob)
		placed_mob.forceMove(get_turf(src))
		placed_mob = null
	return ..()

/obj/structure/steam_recharger/examine(mob/user)
	. = ..()
	if(placed_atom)
		. += span_notice("Contains an object:")
		. += placed_atom.examine(user)
	else if(placed_mob)
		. += span_notice("Contains:")
		. += placed_mob.examine(user)
	else
		. += span_notice("Empty. Place an item or an automaton here to recharge.")

/obj/structure/steam_recharger/valid_water_connection(direction, obj/structure/water_pipe/pipe)
	if(!input)
		input = pipe
		return TRUE
	return FALSE

/obj/structure/steam_recharger/process()
	if(placed_atom)
		process_item_charging()
	else if(placed_mob)
		process_mob_charging()

/obj/structure/steam_recharger/proc/process_item_charging()
	if(!input)
		return
	if(!ispath(input.carrying_reagent, /datum/reagent/steam))
		return
	if(placed_atom.obj_broken)
		visible_message(span_notice("[placed_atom] is broken."))
		remove_placed()
		return

	var/taking_pressure = min(100, input.water_pressure)
	var/obj/structure/water_pipe/picked_provider = pick(input.providers)
	picked_provider?.taking_from?.use_water_pressure(taking_pressure)

	if(!SEND_SIGNAL(placed_atom, COMSIG_ATOM_STEAM_INCREASE, taking_pressure))
		visible_message(span_notice("[placed_atom] is fully charged."))
		remove_placed()

/obj/structure/steam_recharger/proc/process_mob_charging()
	if(!input)
		return
	if(!ispath(input.carrying_reagent, /datum/reagent/steam))
		return

	if(!ishuman(placed_mob))
		visible_message(span_warning("[src] ejects its occupant - incompatible lifeform!"))
		remove_placed_mob()
		return

	var/mob/living/carbon/human/H = placed_mob
	if(!istype(H.dna?.species, /datum/species/automaton))
		visible_message(span_warning("[src] ejects [H] - incompatible lifeform!"))
		remove_placed_mob()
		return

	if(H.stat == DEAD)
		visible_message(span_notice("[H] is non-functional."))
		return

	var/taking_pressure = min(100, input.water_pressure)
	var/obj/structure/water_pipe/picked_provider = pick(input.providers)
	picked_provider?.taking_from?.use_water_pressure(taking_pressure)

	if(!SEND_SIGNAL(H, COMSIG_ATOM_STEAM_INCREASE, taking_pressure))
		visible_message(span_notice("[H] is fully charged."))

/obj/structure/steam_recharger/return_rotation_chat()
	if(!input || !ispath(input.carrying_reagent, /datum/reagent/steam))
		return "NO STEAM INPUT"

	var/status = "Input Pressure: [input ? input.water_pressure : "0"]"
	if(placed_atom)
		status += " | Charging: ITEM"
	else if(placed_mob)
		status += " | Charging: AUTOMATON"
	else
		status += " | Status: EMPTY"

	return status

/obj/structure/steam_recharger/proc/remove_placed(mob/user)
	placed_atom?.forceMove(get_turf(src))
	if(user && placed_atom)
		user.put_in_hands(placed_atom)
	placed_atom = null
	update_appearance(UPDATE_OVERLAYS)

/obj/structure/steam_recharger/proc/remove_placed_mob(mob/user)
	if(!placed_mob)
		return

	placed_mob.forceMove(get_turf(src))

	if(placed_mob.buckled == src)
		placed_mob.buckled = null

	if(user)
		to_chat(user, span_notice("You help [placed_mob] out of [src]."))

	placed_mob = null
	update_appearance(UPDATE_OVERLAYS)

/obj/structure/steam_recharger/proc/add_placed(mob/user, obj/item/placer)
	if(placed_atom || placed_mob)
		return FALSE

	placed_atom = placer
	placer.forceMove(src)
	update_appearance(UPDATE_OVERLAYS)
	user.visible_message(span_notice("[user] places [placer] on [src]."), span_notice("You place [placer] on [src]."))
	return TRUE

/obj/structure/steam_recharger/proc/add_placed_mob(mob/user, mob/living/carbon/human/automaton)
	if(placed_atom || placed_mob)
		to_chat(user, span_warning("[src] is already occupied!"))
		return FALSE

	if(!ishuman(automaton))
		to_chat(user, span_warning("[automaton] cannot use [src]!"))
		return FALSE

	if(!istype(automaton.dna?.species, /datum/species/automaton))
		to_chat(user, span_warning("[automaton] is not an automaton!"))
		return FALSE

	placed_mob = automaton
	automaton.forceMove(src)
	automaton.buckled = src

	update_appearance(UPDATE_OVERLAYS)

	if(user == automaton)
		user.visible_message(
			span_notice("[user] climbs onto [src]."),
			span_notice("You climb onto [src] for recharging.")
		)
	else
		user.visible_message(
			span_notice("[user] places [automaton] on [src]."),
			span_notice("You place [automaton] on [src].")
		)

	return TRUE

/obj/structure/steam_recharger/update_overlays()
	. = ..()
	if(placed_atom)
		var/mutable_appearance/MA = mutable_appearance()
		MA.appearance = placed_atom.appearance
		. += MA
	else if(placed_mob)
		var/mutable_appearance/MA = mutable_appearance()
		MA.appearance = placed_mob.appearance
		MA.pixel_y = 4
		. += MA

/obj/structure/steam_recharger/attack_hand(mob/user)
	. = ..()

	// Handle removing item
	if(placed_atom)
		user.visible_message(
			span_danger("[user] starts to lift [placed_atom] from [src]!"),
			span_notice("You start to remove [placed_atom] from [src]!")
		)
		if(!do_after(user, 1.6 SECONDS, src))
			return
		remove_placed(user)
		return

	// Handle removing mob
	if(placed_mob)
		if(user == placed_mob)
			user.visible_message(
				span_notice("[user] starts to climb out of [src]."),
				span_notice("You start to climb out of [src].")
			)
		else
			user.visible_message(
				span_danger("[user] starts to pull [placed_mob] from [src]!"),
				span_notice("You start to remove [placed_mob] from [src]!")
			)

		if(!do_after(user, 1.6 SECONDS, src))
			return
		remove_placed_mob(user)
		return

/obj/structure/steam_recharger/attackby(obj/item/I, mob/living/user, list/modifiers)
	if(placed_atom || placed_mob)
		return ..()

	. = TRUE
	user.visible_message(
		span_danger("[user] starts to place [I] onto [src]!"),
		span_notice("You start to place [I] onto [src]!")
	)
	if(!do_after(user, 1.6 SECONDS, src))
		return
	add_placed(user, I)

/obj/structure/steam_recharger/MouseDrop_T(mob/living/carbon/human/automaton, mob/living/user)
	. = ..()

	if(!ishuman(automaton))
		return

	if(!istype(automaton.dna?.species, /datum/species/automaton))
		to_chat(user, span_warning("[automaton] is not an automaton!"))
		return

	if(placed_atom || placed_mob)
		to_chat(user, span_warning("[src] is already occupied!"))
		return

	if(!user.Adjacent(src) || !user.Adjacent(automaton))
		return

	if(automaton == user)
		user.visible_message(
			span_notice("[user] starts to climb onto [src]."),
			span_notice("You start to climb onto [src].")
		)
	else
		user.visible_message(
			span_notice("[user] starts to place [automaton] on [src]."),
			span_notice("You start to place [automaton] on [src].")
		)

	if(!do_after(user, 2 SECONDS, src))
		return

	add_placed_mob(user, automaton)

/obj/structure/steam_recharger/relaymove(mob/living/user, direction)
	if(user != placed_mob)
		return
	if(doing)
		return
	user.visible_message(
		span_notice("[user] starts to climb out of [src]."),
		span_notice("You start to climb out of [src].")
	)
	doing = TRUE
	if(!do_after(user, 1.6 SECONDS, src))
		doing = FALSE
		return
	doing = FALSE

	remove_placed_mob(user)
