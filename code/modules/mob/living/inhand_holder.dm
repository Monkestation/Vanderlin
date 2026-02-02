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

/obj/item/mob_holder/dropped(mob/user)
	. = ..()
	if(isturf(loc))
		qdel(src)

/obj/item/mob_holder/Initialize(mapload, mob/living/M)
	. = ..()
	deposit(M)

/obj/item/mob_holder/update_appearance(updates)
	. = ..()
	update_visuals(held_mob)

/obj/item/mob_holder/Destroy()
	destroying = TRUE
	if(held_mob)
		release(FALSE)
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
