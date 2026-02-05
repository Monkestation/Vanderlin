/obj/item/storage/sack
	name = "sack"
	desc = "A simple canvas sack."
	icon_state = "cbag"
	item_state = "bag"
	icon = 'icons/roguetown/items/misc.dmi'
	mob_overlay_icon = 'icons/roguetown/clothing/onmob/head_items.dmi'
	slot_flags = ITEM_SLOT_HEAD
	w_class = WEIGHT_CLASS_NORMAL
	resistance_flags = NONE
	flags_inv = HIDEEARS|HIDEFACE|HIDEHAIR|HIDEFACIALHAIR
	max_integrity = 300
	lefthand_file = 'icons/mob/inhands/weapons/rogue_lefthand.dmi'
	righthand_file = 'icons/mob/inhands/weapons/rogue_righthand.dmi'
	experimental_inhand = FALSE
	experimental_onhip = FALSE
	experimental_onback = FALSE
	component_type = /datum/component/storage/concrete/grid/sack

/obj/item/storage/sack/examine(mob/user)
	. = ..()
	if(length(contents))
		. += span_notice("[length(contents)] thing[length(contents) > 1 ? "s" : ""] in [src].")

/obj/item/storage/sack/equipped(mob/living/carbon/human/user, slot)
	. = ..()
	if(slot & ITEM_SLOT_HEAD)
		user.become_blind("blindfold_[REF(src)]")
	if(HAS_TRAIT(user, TRAIT_ROTMAN))
		to_chat(user, span_info("The [src] slips through dead fingers..."))
		user.dropItemToGround(src, TRUE)

/obj/item/storage/sack/dropped(mob/living/carbon/human/user)
	..()
	user.cure_blind("blindfold_[REF(src)]")

/obj/item/storage/sack/mob_can_equip(mob/living/M, mob/living/equipper, slot, disable_warning, bypass_equip_delay_self)
	if(!..())
		return FALSE
	var/datum/component/storage/STR = GetComponent(/datum/component/storage)
	var/list/things = STR.contents()
	if(length(things))
		return FALSE
	else
		return TRUE

/obj/item/storage/sack/attack_hand_secondary(mob/user, list/modifiers)
	if(user.get_active_held_item())
		return ..()
	var/datum/component/storage/STR = GetComponent(/datum/component/storage)
	var/list/things = STR.contents()
	if(!length(things))
		return ..()
	var/obj/item/I = pick(things)
	STR.remove_from_storage(I, get_turf(user))
	user.put_in_hands(I)
	user.changeNext_move(CLICK_CD_MELEE)
	return SECONDARY_ATTACK_CANCEL_ATTACK_CHAIN

/obj/item/storage/sack/update_icon_state()
	. = ..()
	var/datum/component/storage/STR = GetComponent(/datum/component/storage)
	var/list/things = STR.contents()
	if(length(things))
		icon_state = "fbag"
		w_class = WEIGHT_CLASS_BULKY
	else
		icon_state = "cbag"
		w_class = WEIGHT_CLASS_NORMAL

/obj/item/storage/sack/getonmobprop(tag)
	. = ..()
	if(tag)
		switch(tag)
			if("gen")
				return list("shrink" = 0.5,
"sx" = -4,
"sy" = -7,
"nx" = 6,
"ny" = -6,
"wx" = -2,
"wy" = -7,
"ex" = -1,
"ey" = -7,
"northabove" = 0,
"southabove" = 1,
"eastabove" = 1,
"westabove" = 0,
"nturn" = 0,
"sturn" = 0,
"wturn" = 0,
"eturn" = 0,
"nflip" = 8,
"sflip" = 0,
"wflip" = 0,
"eflip" = 8)
			if("onbelt")
				return list("shrink" = 0.3,"sx" = -2,"sy" = -5,"nx" = 4,"ny" = -5,"wx" = 0,"wy" = -5,"ex" = 2,"ey" = -5,"nturn" = 0,"sturn" = 0,"wturn" = 0,"eturn" = 0,"nflip" = 0,"sflip" = 0,"wflip" = 0,"eflip" = 0,"northabove" = 0,"southabove" = 1,"eastabove" = 1,"westabove" = 0)

/obj/item/storage/meatbag
	name = "game satchel"
	desc = "A cloth and leather satchel for storing the fruit of one's hunt."
	icon_state = "gamesatchel"
	icon = 'icons/roguetown/clothing/storage.dmi'
	slot_flags = ITEM_SLOT_BACK_L|ITEM_SLOT_BACK_R|ITEM_SLOT_HIP
	w_class = WEIGHT_CLASS_NORMAL
	resistance_flags = NONE
	max_integrity = 300
	component_type = /datum/component/storage/concrete/grid/sack/meat

/obj/item/storage/meatbag/attack_hand_secondary(mob/user, list/modifiers)
	. = ..()
	if(.)
		return
	user.changeNext_move(CLICK_CD_MELEE)
	var/datum/component/storage/STR = GetComponent(/datum/component/storage)
	var/list/things = STR.contents()
	if(length(things))
		var/obj/item/I = pick(things)
		STR.remove_from_storage(I, get_turf(user))
		user.put_in_hands(I)

/obj/item/storage/meatbag/getonmobprop(tag)
	. = ..()
	if(tag)
		switch(tag)
			if("gen")
				return list("shrink" = 0.4,
"sx" = -4,
"sy" = -7,
"nx" = 6,
"ny" = -6,
"wx" = -2,
"wy" = -7,
"ex" = -1,
"ey" = -7,
"northabove" = 0,
"southabove" = 1,
"eastabove" = 1,
"westabove" = 0,
"nturn" = 0,
"sturn" = 0,
"wturn" = 0,
"eturn" = 0,
"nflip" = 0,
"sflip" = 0,
"wflip" = 0,
"eflip" = 8)

/obj/item/storage/handbasket
	name = "handbasket"
	desc = "Fibers interwoven to make a cheap, handheld storage item."
	icon_state = "handbasket"
	icon = 'icons/roguetown/items/misc.dmi'
	slot_flags = ITEM_SLOT_HIP
	w_class = WEIGHT_CLASS_NORMAL
	resistance_flags = NONE
	max_integrity = 300
	component_type = /datum/component/storage/concrete/grid/handbasket

/obj/item/storage/handbasket/update_overlays()
	. = ..()
	var/list/stuff = contents
	if(!length(stuff))
		return
	// Assoc list of type to count
	var/list/type_list = list()
	for(var/obj/item as anything in stuff)
		if(!type_list[item.type])
			type_list[item.type] = 0
		type_list[item.type]++
	for(var/type as anything in type_list)
		if(type_list[type] < 5)
			continue
		if(ispath(type, /obj/item/reagent_containers/food/snacks/bread))
			. += mutable_appearance(icon, "handbasket_bread")
			return
		if(ispath(type, /obj/item/alch/herb))
			. += mutable_appearance(icon, "handbasket_herb")
			return
		if(ispath(type, /obj/item/reagent_containers/food/snacks/produce/fruit))
			. += mutable_appearance(icon, "handbasket_fruit")
			return
		if(ispath(type, /obj/item/reagent_containers/food/snacks/egg))
			. += mutable_appearance(icon, "handbasket_egg")
			return
	. += mutable_appearance(icon, "handbasket_generic")

/obj/item/storage/handbasket/attack_hand_secondary(mob/user, list/modifiers)
	if(user.get_active_held_item())
		return ..()
	var/datum/component/storage/STR = GetComponent(/datum/component/storage)
	var/list/things = STR.contents()
	if(!length(things))
		return ..()
	var/obj/item/I = pick(things)
	STR.remove_from_storage(I, get_turf(user))
	user.put_in_hands(I)
	user.changeNext_move(CLICK_CD_MELEE)
	return SECONDARY_ATTACK_CANCEL_ATTACK_CHAIN

/obj/item/storage/handbasket/getonmobprop(tag)
	. = ..()
	if(tag)
		switch(tag)
			if("gen")
				return list("shrink" = 0.5,
"sx" = -4,
"sy" = -7,
"nx" = 6,
"ny" = -6,
"wx" = -2,
"wy" = -7,
"ex" = -1,
"ey" = -7,
"northabove" = 0,
"southabove" = 1,
"eastabove" = 1,
"westabove" = 0,
"nturn" = 0,
"sturn" = 0,
"wturn" = 0,
"eturn" = 0,
"nflip" = 8,
"sflip" = 0,
"wflip" = 0,
"eflip" = 8)
			if("onbelt")
				return list("shrink" = 0.3,"sx" = -2,"sy" = -5,"nx" = 4,"ny" = -5,"wx" = 0,"wy" = -5,"ex" = 2,"ey" = -5,"nturn" = 0,"sturn" = 0,"wturn" = 0,"eturn" = 0,"nflip" = 0,"sflip" = 0,"wflip" = 0,"eflip" = 0,"northabove" = 0,"southabove" = 1,"eastabove" = 1,"westabove" = 0)



