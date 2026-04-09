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

	item_weight = L.carry_weight + L.get_mob_weight()
	SEND_SIGNAL(held_mob, COMSIG_MOB_HOLDER_DEPOSIT, src)
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
	var/mob/living/L = loc
	if(is_embedded)
		if(!istype(L))
			try_fix_broken_embedding()
		else if(iscarbon(L))
			var/mob/living/carbon/C = L
			C.remove_embedded_object(src)
		else
			L.simple_remove_embedded_object(src)
	if(istype(L) && !is_embedded)
		if(!silent)
			to_chat(L, "<span class='warning'>[held_mob] wriggles free!</span>")
		L.dropItemToGround(src)
	held_mob?.forceMove(get_turf(held_mob))
	held_mob?.reset_perspective()
	held_mob?.setDir(SOUTH)
	if(!silent)
		held_mob?.visible_message("<span class='warning'>[held_mob] uncurls!</span>")
	if(held_mob)
		SEND_SIGNAL(held_mob, COMSIG_MOB_HOLDER_RELEASE, src)
	held_mob = null
	if((del_on_release || !held_mob) && !destroying)
		qdel(src)
	return TRUE

/obj/item/mob_holder/relaymove(mob/user)
	release()

/obj/item/mob_holder/container_resist()
	release()

/obj/item/mob_holder/embedded(mob/living/embedded_target, obj/item/bodypart/bodypart)
	. = ..()
	// we're forced to override the forceMove from the bodyparts because they're not actually stored on the map anywhere! That's bad for clients!
	forceMove(embedded_target)
	if(held_mob)
		SEND_SIGNAL(held_mob, COMSIG_MOB_HOLDER_EMBEDDED, src, embedded_target, bodypart)

/// a catch case for if somehow, someone has managed to fuck this up and we can't tell how
/obj/item/mob_holder/proc/try_fix_broken_embedding()
	if(!is_embedded) // why did you even call this
		return TRUE
	var/fixed = FALSE
	var/list/mobs = LAZYCOPY(GLOB.mob_living_list)
	var/mob/living/L
	while(length(mobs) && !fixed)
		L = mobs[1]
		if(iscarbon(L))
			var/mob/living/carbon/C = L
			fixed = C.remove_embedded_object(src)
		else
			fixed = L.simple_remove_embedded_object(src)
		mobs -= L
	if(fixed)
		message_admins("[held_mob] in mob holder did not properly get unembedded from [L]. The issue was resolved, but coders should be notified.")
		log_game("ERROR: [held_mob] in mob holder was somehow unembedded from [L] without calling the proper procs. This is expensive to fix during runtime and should be fixed.")
		return TRUE
	message_admins("[held_mob] in mob holder did not properly get unembedded from someone's body. The body they were in wasn't found. Message coders.")
	log_game("ERROR: [held_mob] in mob holder was unembedded from someone's body without calling the proper procs. The body wasn't found.")
	is_embedded = FALSE
	return FALSE
