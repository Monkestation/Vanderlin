/obj/structure/life_candle
	name = "life candle"
	desc = ""
	icon = 'icons/obj/candle.dmi'
	icon_state = "candle1"
	light_color = LIGHT_COLOR_FIRE

	var/icon_state_active = "candle1_lit"
	var/icon_state_inactive = "candle1"

	anchored = TRUE

	resistance_flags = INDESTRUCTIBLE | LAVA_PROOF | FIRE_PROOF | UNACIDABLE | ACID_PROOF

	var/lit_luminosity = 2
	var/list/datum/mind/linked_minds = list()

	// If the body is destroyed, what do we spawn for them
	var/mob_type = /mob/living/carbon/human

	// If the respawned person is given a specific outfit
	var/datum/outfit/outfit
	// How long until we respawn them after their death.
	var/respawn_time = 50
	var/respawn_sound = 'sound/blank.ogg'

/obj/structure/life_candle/Initialize(mapload, ...)
	. = ..()
	AddElement(/datum/element/movetype_handler)

/obj/structure/life_candle/attack_hand(mob/user)
	. = ..()
	if(.)
		return
	if(!user.mind)
		return
	if(user.mind in linked_minds)
		user.visible_message("<span class='notice'>[user] reaches out and pinches the flame of [src].</span>", "<span class='warning'>I sever the connection between myself and [src].</span>")
		linked_minds -= user.mind
		if(!LAZYLEN(linked_minds))
			REMOVE_TRAIT(src, TRAIT_MOVE_FLOATING, LIFECANDLE_TRAIT)
	else
		user.visible_message("<span class='notice'>[user] touches [src]. It seems to respond to [user.p_their()] presence!</span>", "<span class='warning'>I create a connection between you and [src].</span>")
		linked_minds |= user.mind
		if(!LAZYLEN(linked_minds))
			ADD_TRAIT(src, TRAIT_MOVE_FLOATING, LIFECANDLE_TRAIT)

	if(LAZYLEN(linked_minds))
		START_PROCESSING(SSobj, src)
		set_light(lit_luminosity)
	else
		STOP_PROCESSING(SSobj, src)
		set_light(0)

/obj/structure/life_candle/update_icon_state()
	. = ..()
	if(LAZYLEN(linked_minds))
		icon_state = icon_state_active
	else
		icon_state = icon_state_inactive

/obj/structure/life_candle/examine(mob/user)
	. = ..()
	if(LAZYLEN(linked_minds))
		. += "[src] is active, and linked to [LAZYLEN(linked_minds)] souls."
	else
		. += "It is static, still, unmoving."

/obj/structure/life_candle/process()
	if(!LAZYLEN(linked_minds))
		STOP_PROCESSING(SSobj, src)
		return

	for(var/datum/mind/mind as anything in linked_minds)
		if(!mind.current || (mind.current && mind.current.stat == DEAD))
			addtimer(CALLBACK(src, PROC_REF(respawn), mind), respawn_time, TIMER_UNIQUE)

/obj/structure/life_candle/proc/respawn(datum/mind/mind)
	var/turf/T = get_turf(src)
	var/mob/living/body
	if(mind.current)
		if(mind.current.stat != DEAD)
			return
		else
			body = mind.current
	if(!body)
		body = new mob_type(T)
		var/mob/ghostie = mind.get_ghost(TRUE)
		if(ghostie.client && ghostie.client.prefs)
			ghostie.client.prefs.apply_prefs_to(body)
		mind.transfer_to(body)
	else
		body.forceMove(T)
		body.revive(ADMIN_HEAL_ALL, force_grab_ghost = TRUE)
	mind.grab_ghost(TRUE)
	body.flash_act()

	if(ishuman(body) && istype(outfit))
		outfit.equip(body)
	playsound(T, respawn_sound, 50, TRUE)
