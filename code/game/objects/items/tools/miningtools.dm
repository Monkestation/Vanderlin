/obj/item/weapon/pick
	force = 16
	possible_item_intents = list(/datum/intent/pick)
	name = "pick"
	desc = ""
	icon_state = "pick"
	icon = 'icons/roguetown/weapons/tools.dmi'
	mob_overlay_icon = 'icons/roguetown/onmob/onmob.dmi'
	experimental_onhip = FALSE
	experimental_onback = FALSE
	sharpness = IS_BLUNT
	wlength = 10
	slot_flags = ITEM_SLOT_HIP
	toolspeed = 2
	associated_skill = /datum/skill/labor/mining
	melting_material = /datum/material/iron
	melt_amount = 75
	var/pickmult = 1 // Multiplier of how much extra picking force we do to rocks.
	sellprice = VALUE_IRON_ITEM + M_MISC

/obj/item/weapon/pick/getonmobprop(tag)
	. = ..()
	if(tag)
		switch(tag)
			if("gen")
				return list("shrink" = 0.7,"sx" = -10,"sy" = 0,"nx" = 11,"ny" = 0,"wx" = -8,"wy" = 1,"ex" = 4,"ey" = 0,"northabove" = 0,"southabove" = 1,"eastabove" = 1,"westabove" = 0,"nturn" = 0,"sturn" = 0,"wturn" = 0,"eturn" = 0,"nflip" = 0,"sflip" = 8,"wflip" = 8,"eflip" = 0)
			if("onbelt")
				return list("shrink" = 0.3,"sx" = -2,"sy" = -5,"nx" = 4,"ny" = -5,"wx" = 0,"wy" = -5,"ex" = 2,"ey" = -5,"nturn" = 0,"sturn" = 0,"wturn" = 0,"eturn" = 0,"nflip" = 0,"sflip" = 0,"wflip" = 0,"eflip" = 0,"northabove" = 0,"southabove" = 1,"eastabove" = 1,"westabove" = 0)

/obj/item/weapon/pick/copper
	force = 13
	possible_item_intents = list(/datum/intent/pick)
	name = "copper pick"
	desc = ""
	icon_state = "cpick"
	icon = 'icons/roguetown/weapons/tools.dmi'
	sharpness = IS_BLUNT
	wlength = 10
	slot_flags = ITEM_SLOT_HIP
	toolspeed = 3
	pickmult = 0.8 // Worse pick
	associated_skill = /datum/skill/combat/axesmaces
	melting_material = /datum/material/copper
	melt_amount = 75
	sellprice = VALUE_DIRT_CHEAP + M_MISC

/obj/item/weapon/pick/steel
	name = "steel pick"
	desc = "With a reinforced handle and sturdy shaft, this is a superior tool for delving in the darkness."
	force = 19
	icon_state = "steelpick"
	possible_item_intents = list(/datum/intent/pick)
	gripped_intents = list(/datum/intent/pick)
	max_integrity = 600
	melting_material = /datum/material/steel
	melt_amount = 75
	pickmult = 1.2
	sellprice = VALUE_STEEL_ITEM + M_MISC

/obj/item/weapon/pick/stone
	name = "stone pick"
	desc = "Stone versus sharp stone, who wins?"
	force = 10
	icon_state = "stonepick"
	possible_item_intents = list(/datum/intent/pick)
	gripped_intents = list(/datum/intent/pick)
	max_integrity = 250
	anvilrepair = null
	melting_material = null
	pickmult = 0.7 // Worse pick

/obj/item/weapon/pick/drill
	name = "clockwork drill"
	desc = "A wonderfully complex work of engineering capable of shredding walls in seconds as opposed to hours."
	force_wielded = 30
	icon_state = "drill"
	lefthand_file = 'icons/mob/inhands/weapons/hammers_lefthand.dmi'
	righthand_file = 'icons/mob/inhands/weapons/hammers_righthand.dmi'
	item_state = "drill"
	possible_item_intents = list(/datum/intent/mace/smash)
	gripped_intents = list(/datum/intent/drill)
	experimental_inhand = FALSE
	experimental_onback = FALSE
	slot_flags = ITEM_SLOT_BACK
	gripspriteonmob = TRUE
	melting_material = /datum/material/steel
	melt_amount = 150
	pickmult = 1.5

/obj/item/weapon/pick/drill/Initialize()
	. = ..()
	START_PROCESSING(SSobj, src)
	AddComponent(/datum/component/steam_storage, 300, 0)
	RegisterSignal(src, COMSIG_TWOHANDED_WIELD, PROC_REF(pre_wield_check))

/obj/item/weapon/pick/drill/Destroy()
	STOP_PROCESSING(SSobj, src)
	return ..()

/obj/item/weapon/pick/drill/afterattack(atom/target, mob/living/user, proximity_flag, click_parameters)
	. = ..()
	SEND_SIGNAL(src, COMSIG_ATOM_STEAM_USE, 5)

/obj/item/weapon/pick/drill/proc/pre_wield_check(datum/source, mob/living/carbon/user)
	if(!SEND_SIGNAL(src, COMSIG_ATOM_STEAM_USE, 1))
		to_chat(user, span_warning("[src] doesn't have enough power to be wielded!"))
		return COMPONENT_TWOHANDED_BLOCK_WIELD

/obj/item/weapon/pick/drill/process()
	if(HAS_TRAIT(src, TRAIT_WIELDED))
		if(!SEND_SIGNAL(src, COMSIG_ATOM_STEAM_USE, 1))
			var/datum/component/two_handed/twohanded = GetComponent(/datum/component/two_handed)
			if(ismob(loc))
				twohanded.unwield(loc)
