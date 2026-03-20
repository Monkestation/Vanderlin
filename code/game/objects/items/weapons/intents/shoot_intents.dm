/datum/intent/shoot //shooting crossbows or other guns, no parrydrain
	name = "shoot"
	icon_state = "inshoot"
	tranged = TRUE
	warnie = "aimwarn"
	chargetime = 0.1
	no_early_release = FALSE
	item_damage_type = "stab"
	noaa = TRUE
	charging_slowdown = 2
	warnoffset = 20

/datum/intent/shoot/neant
	chargetime = 2 SECONDS
	no_early_release = TRUE

/datum/intent/shoot/prewarning()
	var/mob/master_mob = get_master_mob()
	var/obj/item/master_item = get_master_item()
	if(master_item && master_mob)
		master_mob.visible_message("<span class='warning'>[master_mob] aims [master_item]!</span>")

/datum/intent/shoot/airgun
	chargedrain = 0 //no drain to aim

/datum/intent/shoot/airgun/get_chargetime()
	var/mob/living/master = get_master_mob()
	if(master && chargetime)
		var/newtime = chargetime
		//skill block
		newtime = newtime + 18
		newtime = newtime - (GET_MOB_SKILL_VALUE_OLD(master, /datum/attribute/skill/craft/engineering) * 3)
		//per block
		newtime = newtime + 20
		newtime = newtime - (GET_MOB_ATTRIBUTE_VALUE(master, STAT_PERCEPTION))
		if(newtime > 0)
			return newtime
		else
			return 0.1
	return chargetime

/datum/intent/shoot/blowgun
	chargetime = 1
	chargedrain = 1
	charging_slowdown = 1
	item_damage_type = "piercing"

/datum/intent/shoot/blowgun/can_charge()
	var/mob/living/master = get_master_mob()
	if(master)
		if(master.usable_hands < 1)
			return FALSE
	return TRUE

/datum/intent/shoot/blowgun/prewarning()
	var/mob/master = get_master_mob()
	if(master)
		master.visible_message("<span class='warning'>[master] takes a deep breath!</span>")

/datum/intent/shoot/blowgun/get_chargetime()
	var/mob/living/master = get_master_mob()
	if(master && chargetime)
		var/newtime = 0
		newtime = newtime + 3 SECONDS
		newtime = newtime - (GET_MOB_SKILL_VALUE_OLD(master, /datum/attribute/skill/combat/bows) * (5))- (GET_MOB_ATTRIBUTE_VALUE(master, STAT_ENDURANCE) * 0.5)
		if(newtime > 0)
			return newtime
		else
			return 0.1
	return chargetime

/datum/intent/shoot/puffer
	chargedrain = 0 //no drain to aim a gun
	charging_slowdown = 1
	warnoffset = 20
	chargetime = 1

/datum/intent/shoot/puffer/arc
	name = "arc"
	icon_state = "inarc"
	charging_slowdown = 2
	warnoffset = 20

/datum/intent/shoot/puffer/arc/arc_check()
	return TRUE

/datum/intent/shoot/musket
	chargedrain = 0 //no drain to aim a gun
	charging_slowdown = 4
	warnoffset = 20
	chargetime = 10

/datum/intent/shoot/musket/arc
	name = "arc"
	icon_state = "inarc"
	charging_slowdown = 3
	warnoffset = 20

/datum/intent/shoot/musket/arc/arc_check()
	return TRUE

/datum/intent/shoot/musket/get_chargetime()
	var/mob/living/master = get_master_mob()
	if(master && chargetime)
		var/newtime = chargetime
		//skill block
		newtime = newtime + 28
		newtime = newtime - (GET_MOB_SKILL_VALUE_OLD(master, /datum/attribute/skill/combat/firearms) * 7.5)
		//per block
		newtime = newtime + 20
		newtime = newtime - (GET_MOB_ATTRIBUTE_VALUE(master, STAT_PERCEPTION))
		if(newtime > 0)
			return newtime
		else
			return 0.1
	return chargetime

/datum/intent/shoot/puffer/get_chargetime()
	var/mob/living/master = get_master_mob()
	if(master && chargetime)
		var/newtime = chargetime
		//skill block
		newtime = newtime + 28
		newtime = newtime - (GET_MOB_SKILL_VALUE_OLD(master, /datum/attribute/skill/combat/firearms) * 7)
		//per block
		newtime = newtime + 10
		newtime = newtime - (GET_MOB_ATTRIBUTE_VALUE(master, STAT_PERCEPTION))
		if(newtime > 0)
			return newtime
		else
			return 0.1
	return chargetime

/datum/intent/shoot/crossbow
	chargedrain = 0 //no drain to aim a crossbow
	var/basetime = 40

/datum/intent/shoot/crossbow/slurbow
	basetime = 20

/datum/intent/shoot/crossbow/get_chargetime()
	if(mastermob && chargetime)
		var/mob/living/mob = mastermob.resolve()
		var/newtime = chargetime
		//skill block
		newtime = newtime + basetime
		newtime = newtime - (GET_MOB_SKILL_VALUE_OLD(mob, /datum/attribute/skill/combat/crossbows) * 4.25) // minus 4.25 per skill point
		newtime = newtime - ((GET_MOB_ATTRIBUTE_VALUE(mob, STAT_PERCEPTION))) // minus 1 per perception
		if(newtime > 1)
			return newtime
		else
			return 1
	return chargetime

/datum/intent/shoot/bow
	chargetime = 0.5
	chargedrain = 1
	charging_slowdown = 1

/datum/intent/shoot/bow/long
	chargetime = 1
	chargedrain = 1.25
	charging_slowdown = 3

/datum/intent/shoot/bow/short
	chargetime = 0.5
	chargedrain = 1
	charging_slowdown = 0.5

/datum/intent/shoot/bow/can_charge()
	var/mob/living/master = get_master_mob()
	if(master)
		if(master.usable_hands < 2)
			return FALSE
		if(master.get_inactive_held_item())
			return FALSE
	return TRUE

/datum/intent/shoot/bow/prewarning()
	var/mob/master_mob = get_master_mob()
	var/obj/item/master_item = get_master_item()
	if(master_mob && master_item)
		master_mob.visible_message("<span class='warning'>[master_mob] draws [master_item]!</span>")
		playsound(master_mob, pick('sound/combat/Ranged/bow-draw-01.ogg'), 100, FALSE)

/datum/intent/shoot/bow/long/prewarning()
	var/mob/master_mob = get_master_mob()
	var/obj/item/master_item = get_master_item()
	if(master_mob && master_item)
		master_mob.visible_message("<span class='warning'>[master_mob] draws [master_item]!</span>")
		playsound(master_mob, pick('sound/combat/Ranged/bow-draw-04.ogg'), 100, FALSE)

/datum/intent/shoot/bow/get_chargetime()
	var/mob/living/master = get_master_mob()
	if(master && chargetime)
		var/newtime = 0
		//skill block
		newtime = newtime + 10
		newtime = newtime - (GET_MOB_SKILL_VALUE_OLD(master, /datum/attribute/skill/combat/bows) * (10/6))
		//str block //rtd replace 10 with drawdiff on bows that are hard and scale str more (10/20 = 0.5)
		newtime = newtime + 10
		newtime = newtime - (GET_MOB_ATTRIBUTE_VALUE(master, STAT_STRENGTH) * (10/20))
		//per block
		newtime = newtime + 20
		newtime = newtime - (GET_MOB_ATTRIBUTE_VALUE(master, STAT_PERCEPTION) * 1) //20/20 is 1
		if(newtime > 0)
			return newtime
		else
			return 0.1
	return chargetime

/datum/intent/shoot/neant/prewarning()
	var/mob/master_mob = get_master_mob()
	var/obj/item/master_item = get_master_item()
	if(master_item && master_mob)
		master_mob.visible_message("<span class='warning'>[master_mob] aims [master_item]!</span>")

/datum/intent/shoot/bow/turbulenta
	chargetime = 1
	chargedrain = 1.5
	charging_slowdown = 2.5

/datum/intent/arc
	name = "arc"
	icon_state = "inarc"
	tranged = 1
	warnie = "aimwarn"
	item_damage_type = "blunt"
	chargetime = 0
	no_early_release = FALSE
	noaa = TRUE
	charging_slowdown = 3
	warnoffset = 20

/datum/intent/proc/arc_check()
	return FALSE

/datum/intent/arc/arc_check()
	return TRUE

/datum/intent/arc/prewarning()
	var/mob/master_mob = get_master_mob()
	var/obj/item/master_item = get_master_item()
	if(master_item && master_mob)
		master_mob.visible_message("<span class='warning'>[master_mob] aims [master_item]!</span>")

/datum/intent/arc/airgun
	chargetime = 1
	chargedrain = 0 //no drain to aim

/datum/intent/arc/airgun/get_chargetime()
	var/mob/living/master = get_master_mob()
	if(master && chargetime)
		var/newtime = chargetime
		//skill block
		newtime = newtime + 18
		newtime = newtime - (GET_MOB_SKILL_VALUE_OLD(master, /datum/attribute/skill/craft/engineering) * 3)
		//per block
		newtime = newtime + 20
		newtime = newtime - (GET_MOB_ATTRIBUTE_VALUE(master, STAT_PERCEPTION))
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
		newtime = newtime + 1.8 SECONDS
		newtime = newtime - (GET_MOB_SKILL_VALUE_OLD(master, /datum/attribute/skill/combat/crossbows) * 3)
		//per block
		newtime = newtime + 2.0 SECONDS
		newtime = newtime - (GET_MOB_ATTRIBUTE_VALUE(master, STAT_PERCEPTION))
		if(newtime > 0)
			return newtime
		else
			return 1
	return chargetime

/datum/intent/arc/bow
	chargetime = 0.5
	chargedrain = 1
	charging_slowdown = 1

/datum/intent/arc/bow/long
	chargetime = 1
	chargedrain = 1.25
	charging_slowdown = 2.5

/datum/intent/arc/bow/short
	chargetime = 0.5
	chargedrain = 1
	charging_slowdown = 0.5

/datum/intent/arc/bow/turbulenta
	chargetime = 1
	chargedrain = 1.5
	charging_slowdown = 2.5

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

/datum/intent/arc/bow/long/prewarning()
	var/mob/master_mob = get_master_mob()
	var/obj/item/master_item = get_master_item()
	if(master_mob && master_item)
		master_mob.visible_message("<span class='warning'>[master_mob] draws [master_item]!</span>")
		playsound(master_mob, pick('sound/combat/Ranged/bow-draw-04.ogg'), 100, FALSE)

/datum/intent/arc/bow/get_chargetime()
	var/mob/living/master = get_master_mob()
	if(master && chargetime)
		var/newtime = 0
		//skill block
		newtime = newtime + 10
		newtime = newtime - (GET_MOB_SKILL_VALUE_OLD(master, /datum/attribute/skill/combat/bows) * (10/6))
		//str block //rtd replace 10 with drawdiff on bows that are hard and scale str more (10/20 = 0.5)
		newtime = newtime + 10
		newtime = newtime - (GET_MOB_ATTRIBUTE_VALUE(master, STAT_STRENGTH) * (10/20))
		//per block
		newtime = newtime + 20
		newtime = newtime - (GET_MOB_ATTRIBUTE_VALUE(master, STAT_PERCEPTION) * 1) //20/20 is 1
		if(newtime > 0)
			return newtime
		else
			return 1
	return chargetime

/datum/intent/arc/blowgun
	chargetime = 1 SECONDS
	chargedrain = 1
	charging_slowdown = 1

/datum/intent/arc/blowgun/can_charge()
	var/mob/living/master = get_master_mob()
	if(master)
		if(master.usable_hands < 1)
			return FALSE
	return TRUE

/datum/intent/arc/blowgun/prewarning()
	var/mob/master = get_master_mob()
	if(master)
		master.visible_message("<span class='warning'>[master] takes a deep breath!</span>")

/datum/intent/arc/blowgun/get_chargetime()
	var/mob/living/master = get_master_mob()
	if(master && chargetime)
		var/newtime = 0
		//skill block
		newtime = newtime + 10
		newtime = newtime - (GET_MOB_SKILL_VALUE_OLD(master, /datum/attribute/skill/combat/bows) * (10/6))
		//end block //rtd replace 10 with drawdiff on bows that are hard and scale end more (10/20 = 0.5)
		newtime = newtime + 10
		newtime = newtime - (GET_MOB_ATTRIBUTE_VALUE(master, STAT_ENDURANCE) * (10/20))
		//per block
		newtime = newtime + 20
		newtime = newtime - (GET_MOB_ATTRIBUTE_VALUE(master, STAT_PERCEPTION) * 1) //20/20 is 1
		if(newtime > 0)
			return newtime
		else
			return 1
	return chargetime
