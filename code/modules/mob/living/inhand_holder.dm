//Generic system for picking up mobs.
//Currently works for head and hands.
/obj/item/mob_holder
	name = "bugged mob"
	desc = ""
	icon = null
	icon_state = ""
	grid_width = 64
	grid_height = 96
	sellprice = 20

	slot_flags = ITEM_SLOT_HEAD
	resistance_flags = INDESTRUCTIBLE
	smeltresult = /obj/item/fertilizer/ash

	var/mob/living/held_mob
	var/can_head = TRUE
	var/destroying = FALSE
	var/obj/item/bodypart/organ_stored

/obj/item/mob_holder/dropped(mob/user)
	. = ..()
	if(isturf(loc))
		qdel(src)

/obj/item/mob_holder/getonmobprop(tag)
	if(tag)
		switch(tag)
			if("gen")
				return list("shrink" = 0.5,"sx" = -7,"sy" = -4,"nx" = 7,"ny" = -4,"wx" = -4,"wy" = -4,"ex" = 2,"ey" = -4,"nturn" = 0,"sturn" = 0,"wturn" = 0,"eturn" = 0,"nflip" = 0,"sflip" = 0,"wflip" = 0,"eflip" = 0,"northabove" = 0,"southabove" = 1,"eastabove" = 1,"westabove" = 0)
			if("wielded")
				return null
			if("altgrip")
				return null
			if("onbelt")
				return list("shrink" = 0.5,"sx" = -2,"sy" = -5,"nx" = 4,"ny" = -5,"wx" = 0,"wy" = -5,"ex" = 2,"ey" = -5,"nturn" = 0,"sturn" = 0,"wturn" = 0,"eturn" = 0,"nflip" = 0,"sflip" = 0,"wflip" = 0,"eflip" = 0,"northabove" = 0,"southabove" = 1,"eastabove" = 1,"westabove" = 0)
			if("onback")
				return list("shrink" = 0.5,"sx" = 1,"sy" = -1,"nx" = 1,"ny" = -1,"wx" = 4,"wy" = -1,"ex" = -1,"ey" = -1,"nturn" = 0,"sturn" = 0,"wturn" = 0,"eturn" = 0,"nflip" = 8,"sflip" = 0,"wflip" = 0,"eflip" = 0,"northabove" = 1,"southabove" = 0,"eastabove" = 0,"westabove" = 0)


/obj/item/mob_holder/Initialize(mapload, mob/living/M)
	. = ..()
	deposit(M)

/obj/item/mob_holder/update_appearance(updates)
	. = ..()
	update_visuals(held_mob)

/obj/item/mob_holder/Destroy()
	destroying = TRUE
	if(organ_stored)
		organ_stored.cavity_items -= src
		organ_stored = null
	if(held_mob)
		release_sleepless(FALSE)
	return ..()

/obj/item/mob_holder/proc/deposit(mob/living/L)
	if(!istype(L))
		return FALSE
	L.setDir(SOUTH)
	update_visuals(L)
	held_mob = L
	L.forceMove(src)
	sellprice = L.sellprice
	name = L.name
	desc = L.desc

	item_weight = L.carry_weight + L.get_mob_weight()

	if(length(L.stored_enchantments))
		for(var/datum/enchantment/enchant as anything in L.stored_enchantments)
			enchant(enchant)
	return TRUE

/obj/item/mob_holder/enchant(datum/enchantment/path)
	if(..())
		LAZYADD(held_mob.stored_enchantments, path)


/obj/item/mob_holder/attackby(obj/item/I, mob/living/user, list/modifiers)
	I.attack(held_mob, user, user.zone_selected)

/obj/item/mob_holder/proc/update_visuals(mob/living/L)
	appearance = L?.appearance
	plane = ABOVE_HUD_PLANE

/obj/item/mob_holder/proc/release(del_on_release = TRUE)
	if(!held_mob)
		if(del_on_release && !destroying)
			qdel(src)
		return FALSE
	if(organ_stored)
		if(!organ_stored.get_cut(ignore_gauze = TRUE))
			if(!do_after(held_mob, 15 SECONDS, loc))
				return
			organ_stored.owner.emote("scream")
			organ_stored.take_damage(40)

	if(isliving(loc))
		var/mob/living/L = loc
		if(!organ_stored)
			to_chat(L, "<span class='warning'>[held_mob] wriggles free!</span>")
		else
			to_chat(L, span_danger("[held_mob] bursts from your [organ_stored]!"))
		L.dropItemToGround(src)

	var/atom/old_loc = loc
	held_mob?.forceMove(get_turf(held_mob))
	held_mob?.reset_perspective()
	held_mob?.setDir(SOUTH)
	if(!organ_stored)
		held_mob?.visible_message("<span class='warning'>[held_mob] uncurls!</span>")
	else
		held_mob?.visible_message(span_danger("[held_mob] bursts out of [old_loc]'s [organ_stored]!"))
	held_mob = null

	if(organ_stored)
		organ_stored.cavity_items -= src
		organ_stored = null
	if((del_on_release || !held_mob) && !destroying)
		qdel(src)
	return TRUE

/obj/item/mob_holder/proc/release_sleepless(del_on_release = TRUE)
	if(!held_mob)
		if(del_on_release && !destroying)
			qdel(src)
		return FALSE

	if(isliving(loc))
		var/mob/living/L = loc
		to_chat(L, "<span class='warning'>[held_mob] wriggles free!</span>")
		L.dropItemToGround(src)

	held_mob?.forceMove(get_turf(held_mob))
	held_mob?.reset_perspective()
	held_mob?.setDir(SOUTH)
	held_mob?.visible_message("<span class='warning'>[held_mob] uncurls!</span>")
	held_mob = null
	if((del_on_release || !held_mob) && !destroying)
		qdel(src)
	return TRUE

/obj/item/mob_holder/relaymove(mob/user)
	release()

/obj/item/mob_holder/container_resist()
	release()
