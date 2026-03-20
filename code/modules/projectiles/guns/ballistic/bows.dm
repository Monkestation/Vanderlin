
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

/obj/item/gun/ballistic/bow
	name = "bow"
	desc = "The bow is your life; to hold it high and pull the string is to know the path of destiny."
	icon = 'icons/roguetown/weapons/32/bows.dmi'
	icon_state = "bow"
	base_icon_state = "bow"
	experimental_onhip = TRUE
	experimental_onback = TRUE
	possible_item_intents = list(/datum/intent/shoot/bow, /datum/intent/arc/bow, INTENT_GENERIC)
	force = 15
	metalizer_result = /obj/item/restraints/legcuffs/beartrap/armed
	slot_flags = ITEM_SLOT_BACK|ITEM_SLOT_HIP
	w_class = WEIGHT_CLASS_BULKY
	can_parry = TRUE
	associated_skill = /datum/attribute/skill/combat/bows

	accepted_magazine_type = /obj/item/ammo_box/magazine/internal/bow
	bolt_type = BOLT_TYPE_NO_BOLT
	internal_magazine = TRUE
	trigger_guard = TRIGGER_GUARD_ALLOW_ALL
	must_hold_to_load = TRUE
	fire_sound = 'sound/combat/Ranged/flatbow-shot-01.ogg'
	load_sound = 'sound/foley/nockarrow.ogg'
	verbage = "nock"
	cartridge_wording = "arrow"

/obj/item/gun/ballistic/bow/long
	name = "longbow"
	desc = "The bow is the instrument of good; the arrow is the intention. Therefore, aim with the heart."
	icon_state = "longbow"
	base_icon_state = "longbow"
	item_state = "longbow"
	possible_item_intents = list(/datum/intent/shoot/bow/long, /datum/intent/arc/bow/long, INTENT_GENERIC)
	force = 12 // ????
	slot_flags = ITEM_SLOT_BACK

	fire_sound = 'sound/combat/Ranged/flatbow-shot-03.ogg'
	projectile_damage_multiplier = 1.2

/obj/item/gun/ballistic/bow/short
	name = "short bow"
	desc = "As the eagle was killed by the arrow winged with his own feather, so the hand of the world is wounded by its own skill."
	icon_state = "recurve"
	base_icon_state = "recurve"
	possible_item_intents = list(/datum/intent/shoot/bow/short, /datum/intent/arc/bow/short, INTENT_GENERIC)
	force = 9

	projectile_damage_multiplier = 0.9

/obj/item/gun/ballistic/bow/getonmobprop(tag)
	if(tag)
		switch(tag)
			if("gen")
				return list("shrink" = 0.7,"sx" = -3,"sy" = -2,"nx" = 5,"ny" = -1,"wx" = -3,"wy" = 0,"ex" = 0,"ey" = -2,"northabove" = 0,"southabove" = 1,"eastabove" = 1,"westabove" = 0,"nturn" = 9,"sturn" = -100,"wturn" = -102,"eturn" = 10,"nflip" = 1,"sflip" = 8,"wflip" = 8,"eflip" = 1)
			if("onbelt")
				return list("shrink" = 0.6,"sx" = -2,"sy" = -5,"nx" = 4,"ny" = -5,"wx" = 0,"wy" = -5,"ex" = 2,"ey" = -5,"nturn" = 0,"sturn" = 0,"wturn" = 0,"eturn" = 0,"nflip" = 0,"sflip" = 0,"wflip" = 0,"eflip" = 0,"northabove" = 0,"southabove" = 1,"eastabove" = 1,"westabove" = 0)
			if("onback")
				return list("shrink" = 0.6,"sx" = 1,"sy" = -1,"nx" = 1,"ny" = -1,"wx" = 3,"wy" = -1,"ex" = 0,"ey" = -1,"nturn" = 0,"sturn" = 0,"wturn" = 0,"eturn" = 0,"nflip" = 8,"sflip" = 0,"wflip" = 0,"eflip" = 0,"northabove" = 1,"southabove" = 0,"eastabove" = 0,"westabove" = 0)

/obj/item/gun/ballistic/bow/update_icon_state()
	. = ..()
	icon_state = "[base_icon_state][chambered ? "_ready" : ""]"

/obj/item/gun/ballistic/bow/attack_self(mob/user)
	. = ..()
	if(!chambered)
		balloon_alert(user, "no arrow nocked!")
		return

	user.put_in_hands(chambered)
	chambered = magazine.get_round()
	update_appearance()

/obj/item/gun/ballistic/bow/equipped(mob/user, slot, initial)
	. = ..()
	if(slot != ITEM_SLOT_HANDS && chambered)
		balloon_alert(user, "the arrow falls out!")
		drop_arrow()

/obj/item/gun/ballistic/bow/dropped(mob/user, silent)
	. = ..()
	addtimer(CALLBACK(src, PROC_REF(drop_arrow_if_not_held)), 0.1 SECONDS)

/obj/item/gun/ballistic/bow/proc/drop_arrow_if_not_held()
	if(ismob(loc) || !chambered)
		return

	drop_arrow()

/obj/item/gun/ballistic/bow/proc/drop_arrow()
	chambered.forceMove(drop_location())
	chambered = magazine.get_round()
	update_appearance()

/obj/item/gun/ballistic/bow/chamber_round(spin_cylinder, replace_new_round)
	if(chambered || !magazine)
		return
	chambered = magazine.get_round()
	RegisterSignal(chambered, COMSIG_MOVABLE_MOVED, PROC_REF(clear_chambered))
	update_appearance()

/obj/item/gun/ballistic/bow/can_shoot(mob/living/user)
	. = ..()
	if(!.)
		return

	if(!user)
		return TRUE

	if(user.usable_hands < 2)
		return FALSE

	if(user.get_inactive_held_item())
		return FALSE

/obj/item/gun/ballistic/bow/get_spread(mob/living/user)
	if(!user?.client)
		return 20

	if(user.client.chargedprog >= 100)
		return 0

	return (150 - (150 * (user.client.chargedprog / 100)))

/obj/item/gun/ballistic/bow/modify_projectile(mob/living/user, atom/target, obj/projectile/modified)
	. = ..()

	if(user.client)
		if(user.client.chargedprog < 100)
			modified.damage *= (user.client.chargedprog / 100)
		else
			modified.embedchance = 100
			modified.accuracy += 15 //fully aiming bow makes your accuracy better.

	var/perception = GET_MOB_ATTRIBUTE_VALUE(user, STAT_PERCEPTION)
	if(perception > 8)
		modified.accuracy += (perception - 8) * 4 //each point of perception above 8 increases standard accuracy by 4.
		modified.bonus_accuracy += (perception - 8) //Also, increases bonus accuracy by 1, which cannot fall off due to distance.
		if(perception > 10) // Every point over 10 PER adds 10% damage
			modified.damage *= (perception / 10)

	modified.bonus_accuracy += (GET_MOB_SKILL_VALUE_OLD(user, /datum/attribute/skill/combat/bows) * 5) //+5 accuracy per level in bows. Bonus accuracy will not drop-off.

/obj/item/gun/ballistic/bow/process_fire(atom/target, mob/living/user, message, list/modifiers, zone_override, bonus_spread)
	. = ..()
	if(!.)
		return

	var/modifier = 1.25 / (spread + 1)
	var/boon = user.get_learning_boon(/datum/attribute/skill/combat/bows)
	var/amt2raise = GET_MOB_ATTRIBUTE_VALUE(user, STAT_INTELLIGENCE) / 2
	user.adjust_experience(/datum/attribute/skill/combat/bows, amt2raise * boon * modifier, FALSE)

/obj/item/gun/ballistic/bow/postfire_empty_checks(last_shot_succeeded)
	if(!chambered && !get_ammo())
		update_appearance()

/obj/item/gun/ballistic/bow/shoot_with_empty_chamber(mob/living/user)
	return //no clicking sounds please
