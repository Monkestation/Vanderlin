
/obj/item/gun/ballistic/revolver/grenadelauncher/crossbow
	name = "crossbow"
	desc = "A mechanical ranged weapon of simple design, affixed with a stirrup and fired via trigger."
	icon = 'icons/roguetown/weapons/32/bows.dmi'
	icon_state = "crossbow0"
	item_state = "crossbow"
	possible_item_intents = list(/datum/intent/shoot/crossbow, /datum/intent/arc/crossbow, INTENT_GENERIC)
	mag_type = /obj/item/ammo_box/magazine/internal/shot/xbow
	slot_flags = ITEM_SLOT_BACK
	w_class = WEIGHT_CLASS_BULKY
	randomspread = 1
	spread = 0
	can_parry = TRUE
	var/chargingspeed = 40
	var/reloadtime = 40
	var/movingreload = FALSE
	var/hasloadedsprite = FALSE

	force = 10
	var/cocked = FALSE
	cartridge_wording = "bolt"
	load_sound = 'sound/foley/nockarrow.ogg'
	fire_sound = 'sound/combat/Ranged/crossbow-small-shot-02.ogg'

/obj/item/gun/ballistic/revolver/grenadelauncher/crossbow/slurbow
	name = "slurbow"
	desc = "A lighter weight crossbow with a distinct barrel shroud holding the bolt in place. Light enough to arm by hand. <br>They're popular among highwaymen and the patrolling lamplighters of Grenzelhoft."
	icon = 'icons/roguetown/weapons/32/bows.dmi'
	icon_state = "slurbow0"
	item_state = "slurbow"
	possible_item_intents = list(/datum/intent/shoot/crossbow/slurbow, /datum/intent/arc/crossbow/slurbow, INTENT_GENERIC)
	damfactor = 0.6
	reloadtime = 20
	hasloadedsprite = TRUE
	movingreload = TRUE
	slot_flags = ITEM_SLOT_BACK | ITEM_SLOT_HIP

/obj/item/gun/ballistic/revolver/grenadelauncher/crossbow/getonmobprop(tag)
	. = ..()
	if(tag)
		switch(tag)
			if("gen")
				return list("shrink" = 0.5,"sx" = -4,"sy" = -6,"nx" = 9,"ny" = -6,"wx" = -6,"wy" = -4,"ex" = 4,"ey" = -6,"northabove" = 0,"southabove" = 1,"eastabove" = 1,"westabove" = 0,"nturn" = 0,"sturn" = 90,"wturn" = 93,"eturn" = -12,"nflip" = 0,"sflip" = 1,"wflip" = 0,"eflip" = 0)
			if("onbelt")
				return list("shrink" = 0.3,"sx" = -2,"sy" = -5,"nx" = 4,"ny" = -5,"wx" = 0,"wy" = -5,"ex" = 2,"ey" = -5,"nturn" = 0,"sturn" = 0,"wturn" = 0,"eturn" = 0,"nflip" = 0,"sflip" = 0,"wflip" = 0,"eflip" = 0,"northabove" = 0,"southabove" = 1,"eastabove" = 1,"westabove" = 0)


/datum/intent/shoot/crossbow
	chargedrain = 0 //no drain to aim a crossbow
	var/basetime = 40

/datum/intent/shoot/crossbow/slurbow
	chargedrain = 0 //no drain to aim a crossbow
	basetime = 20

/datum/intent/shoot/crossbow/get_chargetime()
	if(mastermob && chargetime)
		var/mob/living/mob = mastermob.resolve()
		var/newtime = chargetime
		//skill block
		newtime = newtime + basetime
		newtime = newtime - (mob.get_skill_level(/datum/skill/combat/crossbows, TRUE) * 4.25) // minus 4.25 per skill point
		newtime = newtime - ((mob.STAPER)) // minus 1 per perception
		if(newtime > 1)
			return newtime
		else
			return 1
	return chargetime

/datum/intent/arc/crossbow
	chargetime = 1
	var/basetime = 40
	chargedrain = 0 //no drain to aim a crossbow

/datum/intent/arc/crossbow/slurbow
	chargetime = 1
	basetime = 20
	chargedrain = 0

/datum/intent/arc/crossbow/get_chargetime()
	if(mastermob && chargetime)
		var/mob/living/mob = mastermob.resolve()
		var/newtime = chargetime
		//skill block
		newtime = newtime + basetime
		newtime = newtime - (mob.get_skill_level(/datum/skill/combat/crossbows, TRUE) * 20)
		//per block
		newtime = newtime + 20
		newtime = newtime - ((mob.STAPER)*1.5)
		if(newtime > 0)
			return newtime
		else
			return 10
	return chargetime

/datum/intent/shoot/musket
	chargedrain = 0 //no drain to aim a gun
	charging_slowdown = 4
	warnoffset = 20
	chargetime = 10

/datum/intent/shoot/musket/arc
	name = "arc"
	icon_state = "inarc"
	chargedrain = 1
	charging_slowdown = 3
	warnoffset = 20

/datum/intent/shoot/musket/arc/arc_check()
	return TRUE

/datum/intent/shoot/musket/get_chargetime()
	var/mob/living/master = get_master_mob()
	if(master && chargetime)
		var/newtime = chargetime
		//skill block
		newtime = newtime + 18
		newtime = newtime - (master.get_skill_level(/datum/skill/combat/firearms, TRUE) * 3.5)
		//per block
		newtime = newtime + 20
		newtime = newtime - (master.STAPER)
		if(newtime > 0)
			return newtime
		else
			return 0.1
	return chargetime

/datum/intent/shoot/musket/pistol/get_chargetime()
	var/mob/living/master = get_master_mob()
	if(master && chargetime)
		var/newtime = chargetime
		//skill block
		newtime = newtime + 18
		newtime = newtime - (master.get_skill_level(/datum/skill/combat/firearms, TRUE) * 3.5)
		//per block
		newtime = newtime + 20
		newtime = newtime - (master.STAPER)
		if(newtime > 0)
			return newtime
		else
			return 1
	return chargetime

/datum/intent/arc/crossbow
	chargetime = 1
	chargedrain = 0 //no drain to aim a crossbow

/datum/intent/arc/crossbow/get_chargetime()
	var/mob/living/master = get_master_mob()
	if(master && chargetime)
		var/newtime = chargetime
		//skill block
		newtime = newtime + 18
		newtime = newtime - (master.get_skill_level(/datum/skill/combat/crossbows, TRUE) * 3)
		//per block
		newtime = newtime + 20
		newtime = newtime - (master.STAPER)
		if(newtime > 0)
			return newtime
		else
			return 1
	return chargetime

/obj/item/gun/ballistic/revolver/grenadelauncher/crossbow/shoot_with_empty_chamber()
	if(cocked)
		playsound(src, 'sound/combat/Ranged/crossbow-small-shot-02.ogg', 100, FALSE)
		cocked = FALSE
		update_appearance(UPDATE_ICON_STATE)

/obj/item/gun/ballistic/revolver/grenadelauncher/crossbow/attack_self(mob/living/user, list/modifiers)
	if(chambered)
		return ..()

	if(!cocked)
		to_chat(user, span_info("I step on the stirrup and use all my might..."))
		if(!movingreload)
			if(do_after(user, reloadtime - user.STASTR, target = user))
				playsound(user, 'sound/combat/Ranged/crossbow_medium_reload-01.ogg', 100, FALSE)
				cocked = TRUE
		else
			if(do_after(user, reloadtime - user.STASTR, user, timed_action_flags = (IGNORE_USER_LOC_CHANGE|IGNORE_TARGET_LOC_CHANGE|IGNORE_HELD_ITEM|IGNORE_USER_DIR_CHANGE)))
				playsound(user, 'sound/combat/Ranged/crossbow_medium_reload-01.ogg', 100, FALSE)
				cocked = TRUE
	else
		to_chat(user, span_warning("I carefully de-cock the crossbow."))
		cocked = FALSE

	update_appearance(UPDATE_ICON_STATE)

/obj/item/gun/ballistic/revolver/grenadelauncher/crossbow/attackby(obj/item/A, mob/user, list/modifiers)
	if(istype(A, /obj/item/ammo_box) || istype(A, /obj/item/ammo_casing))
		if(cocked)
			return ..()
		to_chat(user, span_warning("I need to cock the bow first."))


/obj/item/gun/ballistic/revolver/grenadelauncher/crossbow/process_fire(atom/target, mob/living/user, message = TRUE, list/modifiers, zone_override, bonus_spread = 0)
	if(user.client)
		if(user.client.chargedprog >= 100)
			spread = 0
		else
			spread = 150 - (150 * (user.client.chargedprog / 100))
	else
		spread = 0
	for(var/obj/item/ammo_casing/CB in get_ammo_list(FALSE, TRUE))
		var/obj/projectile/BB = CB.BB
		if(user.client)
			if(user.client.chargedprog >= 100)
				BB.accuracy += 15 //better accuracy for fully aiming
		if(user.STAPER > 8)
			BB.accuracy += (user.STAPER - 8) * 4 //each point of perception above 8 increases standard accuracy by 4.
			BB.bonus_accuracy += (user.STAPER - 8) //Also, increases bonus accuracy by 1, which cannot fall off due to distance.
			if(user.STAPER > 10)
				BB.damage = BB.damage * (user.STAPER / 10)
		BB.damage *= damfactor // Apply damfactor multiplier regardless of PER.
		BB.bonus_accuracy += (user.get_skill_level(/datum/skill/combat/crossbows, TRUE) * 3) //+3 accuracy per level in crossbows
	cocked = FALSE
	. = ..()
	if(.)
		if(istype(user) && user.mind)
			var/modifier = 1.25/(spread+1)
			var/boon = user.get_learning_boon(/datum/skill/combat/crossbows)
			var/amt2raise = user.STAINT/2
			user.adjust_experience(/datum/skill/combat/crossbows, amt2raise * boon * modifier, FALSE)

/obj/item/gun/ballistic/revolver/grenadelauncher/crossbow/update_icon_state()
	. = ..()
	if(cocked)
		icon_state = "crossbow1"
	else
		icon_state = "crossbow0"

/obj/item/gun/ballistic/revolver/grenadelauncher/crossbow/update_overlays()
	. = ..()
	if(!chambered)
		return
	var/obj/item/I = chambered
	I.pixel_x = I.base_pixel_x
	I.pixel_y = I.base_pixel_y
	. += mutable_appearance(I.icon, I.icon_state)

/obj/item/ammo_box/magazine/internal/shot/xbow
	ammo_type = /obj/item/ammo_casing/caseless/bolt
	caliber = "regbolt"
	max_ammo = 1
	start_empty = TRUE
