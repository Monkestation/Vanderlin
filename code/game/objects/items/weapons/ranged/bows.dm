/*----\
| Bow |
\----*/

/obj/item/gun/ballistic/revolver/grenadelauncher/bow
	name = "bow"
	desc = "The bow is your life; to hold it high and pull the string is to know the path of destiny."
	icon = 'icons/roguetown/weapons/32/bows.dmi'
	icon_state = "bow"
	experimental_onhip = TRUE
	experimental_onback = TRUE
	var/base_icon = "bow"
	possible_item_intents = list(/datum/intent/shoot/bow, /datum/intent/arc/bow,INTENT_GENERIC)
	mag_type = /obj/item/ammo_box/magazine/internal/shot/bow
	fire_sound = 'sound/combat/Ranged/flatbow-shot-01.ogg'
	slot_flags = ITEM_SLOT_BACK|ITEM_SLOT_HIP
	w_class = WEIGHT_CLASS_BULKY
	randomspread = 0
	spread = 0
	can_parry = TRUE
	force = 15
	verbage = "nock"
	cartridge_wording = "arrow"
	load_sound = 'sound/foley/nockarrow.ogg'
	metalizer_result = /obj/item/restraints/legcuffs/beartrap/armed

/obj/item/gun/ballistic/revolver/grenadelauncher/bow/getonmobprop(tag)
	if(tag)
		switch(tag)
			if("gen")
				return list("shrink" = 0.7,"sx" = -3,"sy" = -2,"nx" = 5,"ny" = -1,"wx" = -3,"wy" = 0,"ex" = 0,"ey" = -2,"northabove" = 0,"southabove" = 1,"eastabove" = 1,"westabove" = 0,"nturn" = 9,"sturn" = -100,"wturn" = -102,"eturn" = 10,"nflip" = 1,"sflip" = 8,"wflip" = 8,"eflip" = 1)
			if("onbelt")
				return list("shrink" = 0.6,"sx" = -2,"sy" = -5,"nx" = 4,"ny" = -5,"wx" = 0,"wy" = -5,"ex" = 2,"ey" = -5,"nturn" = 0,"sturn" = 0,"wturn" = 0,"eturn" = 0,"nflip" = 0,"sflip" = 0,"wflip" = 0,"eflip" = 0,"northabove" = 0,"southabove" = 1,"eastabove" = 1,"westabove" = 0)
			if("onback")
				return list("shrink" = 0.6,"sx" = 1,"sy" = -1,"nx" = 1,"ny" = -1,"wx" = 3,"wy" = -1,"ex" = 0,"ey" = -1,"nturn" = 0,"sturn" = 0,"wturn" = 0,"eturn" = 0,"nflip" = 8,"sflip" = 0,"wflip" = 0,"eflip" = 0,"northabove" = 1,"southabove" = 0,"eastabove" = 0,"westabove" = 0)

/obj/item/gun/ballistic/revolver/grenadelauncher/bow/shoot_with_empty_chamber()
	return

/obj/item/gun/ballistic/revolver/grenadelauncher/bow/equipped(mob/user, slot, initial)
	. = ..()
	if(chambered && !(slot & ITEM_SLOT_HANDS))
		chambered = null
		for(var/obj/item/ammo_casing/CB in get_ammo_list(TRUE, TRUE))
			CB.forceMove(drop_location())
		update_appearance(UPDATE_ICON_STATE)

/obj/item/gun/ballistic/revolver/grenadelauncher/bow/dropped(mob/user)
	. = ..()
	if(loc != user && chambered)
		chambered = null
		for(var/obj/item/ammo_casing/CB in get_ammo_list(TRUE, TRUE))
			CB.forceMove(drop_location())
		update_appearance(UPDATE_ICON_STATE)

//Bows are subtype of grenadelauncher and use BOLT_TYPE_NO_BOLT code
/obj/item/gun/ballistic/revolver/grenadelauncher/bow/attack_self(mob/living/user, list/modifiers)
	chambered = null
	var/num_unloaded = 0
	for(var/obj/item/ammo_casing/CB in get_ammo_list(TRUE, TRUE))
		user.put_in_hands(CB)
		num_unloaded++
	if(num_unloaded)
		to_chat(user, "<span class='notice'>I remove [(num_unloaded == 1) ? "the [cartridge_wording]" : "[num_unloaded] [cartridge_wording]\s "] from [src].</span>")
		playsound(user, eject_sound, eject_sound_volume, eject_sound_vary)
		update_appearance(UPDATE_ICON_STATE)

/obj/item/gun/ballistic/revolver/grenadelauncher/bow/process_fire(atom/target, mob/living/user, message = TRUE, list/modifiers, zone_override, bonus_spread = 0)
	if(user.usable_hands < 2)
		return FALSE
	if(user.get_inactive_held_item())
		return FALSE
	if(user.client)
		if(user.client.chargedprog >= 100)
			spread = 0
		else
			spread = 150 - (150 * (user.client.chargedprog / 100))
	else
		spread = 0
	for(var/obj/item/ammo_casing/CB in get_ammo_list(FALSE, TRUE))
		var/obj/projectile/BB = CB.BB
		if(user.client.chargedprog < 100)
			BB.damage = BB.damage - (BB.damage * (user.client.chargedprog / 100))
			BB.embedchance = 5
		else
			BB.damage = BB.damage
			BB.embedchance = 100
			BB.accuracy += 15 //fully aiming bow makes your accuracy better.

		if(user.STAPER > 8)
			BB.accuracy += (user.STAPER - 8) * 4 //each point of perception above 8 increases standard accuracy by 4.
			BB.bonus_accuracy += (user.STAPER - 8) //Also, increases bonus accuracy by 1, which cannot fall off due to distance.
			if(user.STAPER > 10) // Every point over 10 PER adds 10% damage
				BB.damage = BB.damage * (user.STAPER / 10)
		BB.damage *= damfactor // Apply bow's inherent damage multiplier regardless of PER
		BB.bonus_accuracy += (user.get_skill_level(/datum/skill/combat/bows, TRUE) * 5) //+5 accuracy per level in bows. Bonus accuracy will not drop-off.
	. = ..()
	if(.)
		if(istype(user) && user.mind)
			var/modifier = 1.25/(spread+1)
			var/boon = user.get_learning_boon(/datum/skill/combat/bows)
			var/amt2raise = user.STAINT/2
			user.adjust_experience(/datum/skill/combat/bows, amt2raise * boon * modifier, FALSE)

/obj/item/gun/ballistic/revolver/grenadelauncher/bow/update_icon_state()
	. = ..()
	if(chambered)
		icon_state = "[base_icon]_ready"
	else
		icon_state = "[base_icon]"

/obj/item/ammo_box/magazine/internal/shot/bow
	ammo_type = /obj/item/ammo_casing/caseless/arrow
	caliber = "arrow"
	max_ammo = 1
	start_empty = TRUE

/datum/intent/shoot/bow
	chargetime = 0.5
	chargedrain = 1
	charging_slowdown = 1

/datum/intent/shoot/bow/can_charge()
	var/mob/living/master = get_master_mob()
	if(master)
		if(master.usable_hands < 2)
			return FALSE
		if(master.get_inactive_held_item())
			return FALSE
	return TRUE

/datum/intent/shoot/bow/prewarning()
	var/mob/master = get_master_mob()
	if(master)
		master.visible_message("<span class='warning'>[master] draws [get_master_item()]!</span>")
		playsound(master, pick('sound/combat/Ranged/bow-draw-01.ogg'), 100, FALSE)

/datum/intent/shoot/bow/get_chargetime()
	var/mob/living/master = get_master_mob()
	if(master && chargetime)
		var/newtime = 0
		//skill block
		newtime = newtime + 10
		newtime = newtime - (master.get_skill_level(/datum/skill/combat/bows, TRUE) * (10/6))
		//str block //rtd replace 10 with drawdiff on bows that are hard and scale str more (10/20 = 0.5)
		newtime = newtime + 10
		newtime = newtime - (master.STASTR * (10/20))
		//per block
		newtime = newtime + 20
		newtime = newtime - (master.STAPER * 1) //20/20 is 1
		if(newtime > 0)
			return newtime
		else
			return 0.1
	return chargetime

/datum/intent/arc/bow
	chargetime = 0.5
	chargedrain = 1
	charging_slowdown = 1

/datum/intent/arc/bow/can_charge()
	var/mob/living/master = get_master_mob()
	if(master)
		if(master.usable_hands < 2)
			return FALSE
		if(master.get_inactive_held_item())
			return FALSE
	return TRUE

/datum/intent/arc/bow/prewarning()
	var/mob/master_mob = get_master_mob()
	var/obj/item/master_item = get_master_item()
	if(master_item && master_mob)
		master_mob.visible_message("<span class='warning'>[master_mob] draws [master_item]!</span>")
		playsound(master_mob, pick('sound/combat/Ranged/bow-draw-01.ogg'), 100, FALSE)

/datum/intent/arc/bow/get_chargetime()
	var/mob/living/master = get_master_mob()
	if(master && chargetime)
		var/newtime = 0
		//skill block
		newtime = newtime + 10
		newtime = newtime - (master.get_skill_level(/datum/skill/combat/bows, TRUE) * (10/6))
		//str block //rtd replace 10 with drawdiff on bows that are hard and scale str more (10/20 = 0.5)
		newtime = newtime + 10
		newtime = newtime - (master.STASTR * (10/20))
		//per block
		newtime = newtime + 20
		newtime = newtime - (master.STAPER * 1) //20/20 is 1
		if(newtime > 0)
			return newtime
		else
			return 1
	return chargetime



/*--------\
| Longbow |
\--------*/

/obj/item/gun/ballistic/revolver/grenadelauncher/bow/long
	name = "longbow"
	desc = "The bow is the instrument of good; the arrow is the intention. Therefore, aim with the heart."
	icon_state = "longbow"
	item_state = "longbow"
	base_icon = "longbow"
	possible_item_intents = list(/datum/intent/shoot/bow/long, /datum/intent/arc/bow/long,INTENT_GENERIC)
	fire_sound = 'sound/combat/Ranged/flatbow-shot-03.ogg'
	slot_flags = ITEM_SLOT_BACK
	force = 12
	damfactor = 1.2

/datum/intent/shoot/bow/long/prewarning()
	var/mob/master_mob = get_master_mob()
	var/obj/item/master_item = get_master_item()
	if(master_mob && master_item)
		master_mob.visible_message("<span class='warning'>[master_mob] draws [master_item]!</span>")
		playsound(master_mob, pick('sound/combat/Ranged/bow-draw-04.ogg'), 100, FALSE)

/datum/intent/arc/bow/long/prewarning()
	var/mob/master_mob = get_master_mob()
	var/obj/item/master_item = get_master_item()
	if(master_mob && master_item)
		master_mob.visible_message("<span class='warning'>[master_mob] draws [master_item]!</span>")
		playsound(master_mob, pick('sound/combat/Ranged/bow-draw-04.ogg'), 100, FALSE)

/datum/intent/shoot/bow/long
	chargetime = 1.5
	chargedrain = 1.5
	charging_slowdown = 3

/datum/intent/arc/bow/long
	chargetime = 1.5
	chargedrain = 1.5
	charging_slowdown = 3



/*------------\
| Short Bow |
\------------*/

/obj/item/gun/ballistic/revolver/grenadelauncher/bow/short
	name = "short bow"
	desc = "As the eagle was killed by the arrow winged with his own feather, so the hand of the world is wounded by its own skill."
	icon_state = "recurve" // sprite should be changed eventually
	base_icon = "recurve"
	possible_item_intents = list(/datum/intent/shoot/bow/short, /datum/intent/arc/bow/short,INTENT_GENERIC)
	randomspread = 1
	spread = 1
	force = 9
	damfactor = 0.9

/datum/intent/shoot/bow/short
	chargetime = 0.75
	chargedrain = 1.5
	charging_slowdown = 2.5

/datum/intent/arc/bow/short
	chargetime = 0.75
	chargedrain = 1.5
	charging_slowdown = 2.5
