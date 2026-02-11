/*-----------\
|  Thresher  |
\-----------*/

/obj/item/weapon/thresher
	name = "thresher"
	desc = "Crushes grain, or skulls."
	icon_state = "thresher"
	force = DAMAGE_WEAK_FLAIL - 7
	force_wielded = DAMAGE_WEAK_FLAIL - 3
	wdefense = AVERAGE_PARRY
	wlength = WLENGTH_LONG
	possible_item_intents = list(MACE_STRIKE)
	gripped_intents = list(FLAIL_THRESH, MACE_STRIKE)
	max_integrity = INTEGRITY_POOR
	minstr = 6

	icon = 'icons/roguetown/weapons/tools.dmi'
	mob_overlay_icon = 'icons/roguetown/onmob/onmob.dmi'
	lefthand_file = 'icons/roguetown/onmob/lefthand.dmi'
	righthand_file = 'icons/roguetown/onmob/righthand.dmi'
	experimental_inhand = FALSE
	experimental_onback = FALSE
	experimental_onhip = FALSE
	gripspriteonmob = TRUE
	slot_flags = ITEM_SLOT_BACK
	sharpness = IS_BLUNT
	w_class = WEIGHT_CLASS_BULKY
	gripsprite = TRUE
	drop_sound = 'sound/foley/dropsound/wooden_drop.ogg'
	smeltresult = /obj/item/fertilizer/ash
	associated_skill = /datum/skill/combat/whipsflails

/obj/item/weapon/thresher/military
	name = "military flail"
	desc = "Crushes skulls, or grain."
	icon_state = "military"
	force = DAMAGE_WEAK_FLAIL - 5
	force_wielded = DAMAGE_NORMAL_FLAIL + 2
	possible_item_intents = list(MACE_STRIKE)
	gripped_intents = list(FLAIL_LNGSTRIKE, FLAIL_LNGSMASH, FLAIL_THRESH,)

	minstr = 7
	melting_material = /datum/material/iron
	melt_amount = 75

/datum/intent/flailthresh
	name = "thresh"
	icon_state = "inthresh"
	chargetime = 0
	noaa = TRUE
	candodge = FALSE
	misscost = 0
	no_attack = TRUE

/obj/item/weapon/thresher/getonmobprop(tag)
	. = ..()
	if(tag)
		switch(tag)
			if("gen")
				return list("shrink" = 0.7,
"sx" = -9,
"sy" = 1,
"nx" = 10,
"ny" = 0,
"wx" = -7,
"wy" = -0,
"ex" = 6,
"ey" = 3,
"northabove" = 0,
"southabove" = 1,
"eastabove" = 1,
"westabove" = 0,
"nturn" = -15,
"sturn" = 12,
"wturn" = 0,
"eturn" = 354,
"nflip" = 0,
"sflip" = 8,
"wflip" = 8,
"eflip" = 0)
			if("wielded")
				return list("shrink" = 0.7,
"sx" = 4,
"sy" = -7,
"nx" = -6,
"ny" = -6,
"wx" = 1,
"wy" = -8,
"ex" = 4,
"ey" = -8,
"northabove" = 0,
"southabove" = 1,
"eastabove" = 1,
"westabove" = 1,
"nturn" = -10, //-40
"sturn" = 0, // 40
"wturn" = 10, // 60
"eturn" = 0, // 25
"nflip" = 8,
"sflip" = 0,
"wflip" = 0,
"eflip" = 0)
			if("onbelt")
				return list("shrink" = 0.4,"sx" = -2,"sy" = -5,"nx" = 4,"ny" = -5,"wx" = 0,"wy" = -5,"ex" = 2,"ey" = -5,"nturn" = 0,"sturn" = 0,"wturn" = 0,"eturn" = 0,"nflip" = 0,"sflip" = 0,"wflip" = 0,"eflip" = 0,"northabove" = 0,"southabove" = 1,"eastabove" = 1,"westabove" = 0)

/obj/item/weapon/thresher/afterattack(obj/target, mob/user, proximity, list/modifiers)
	if(user.used_intent.type == /datum/intent/flailthresh)
		if(!proximity)
			return
		if(isturf(target.loc))
			var/turf/T = target.loc
			var/found = FALSE
			for(var/obj/item/natural/chaff/C in T)
				found = TRUE
				C.thresh()
			if(found)
				playsound(src,"plantcross", 90, FALSE)
				playsound(src,"smashlimb", 35, FALSE)
				apply_farming_fatigue(user, 10)
				user.visible_message(span_notice("[user] threshes the stalks!"), \
									span_notice("I thresh the stalks."))
		return
	..()

/*---------\
|  Sickle  |
\---------*/

/obj/item/weapon/sickle
	name = "sickle"
	desc = "Rusted blade, worn handle, symbol of toil."
	icon_state = "sickle1"
	icon = 'icons/roguetown/weapons/tools.dmi'
	mob_overlay_icon = 'icons/roguetown/onmob/onmob.dmi'
	force = DAMAGE_KNIFE
	possible_item_intents = list(DAGGER_CUT)
	wdefense = BAD_PARRY

	experimental_onhip = FALSE
	experimental_onback = FALSE
	sharpness = IS_SHARP
	max_integrity = INTEGRITY_POOR
	wlength = 10
	slot_flags = ITEM_SLOT_HIP
	thrown_bclass = BCLASS_CUT
	drop_sound = 'sound/foley/dropsound/blade_drop.ogg'
	max_blade_int = 50
	melting_material = /datum/material/iron
	melt_amount = 50
	associated_skill = /datum/skill/combat/knives
	grid_height = 64
	grid_width = 64

/obj/item/weapon/sickle/Initialize(mapload)
	. = ..()
	if(icon_state == "sickle1")
		icon_state = "sickle[rand(1,3)]"

/obj/item/weapon/sickle/getonmobprop(tag)
	. = ..()
	if(tag)
		switch(tag)
			if("gen")
				return list("shrink" = 0.6,"sx" = -8,"sy" = 1,"nx" = 12,"ny" = 1,"wx" = -7,"wy" = 1,"ex" = 4,"ey" = 0,"northabove" = 0,"southabove" = 1,"eastabove" = 1,"westabove" = 0,"nturn" = 0,"sturn" = 0,"wturn" = 0,"eturn" = 0,"nflip" = 0,"sflip" = 8,"wflip" = 8,"eflip" = 0)
			if("onbelt")
				return list("shrink" = 0.3,"sx" = -2,"sy" = -5,"nx" = 4,"ny" = -5,"wx" = 0,"wy" = -5,"ex" = 2,"ey" = -5,"nturn" = 0,"sturn" = 0,"wturn" = 0,"eturn" = 0,"nflip" = 0,"sflip" = 0,"wflip" = 0,"eflip" = 0,"northabove" = 0,"southabove" = 1,"eastabove" = 1,"westabove" = 0)



/*------\
|  Hoe  |
\------*/

/obj/item/weapon/hoe
	name = "hoe"
	desc = ""
	icon_state = "hoe"
	icon = 'icons/roguetown/weapons/tools.dmi'
	mob_overlay_icon = 'icons/roguetown/onmob/onmob.dmi'
	lefthand_file = 'icons/roguetown/onmob/lefthand.dmi'
	righthand_file = 'icons/roguetown/onmob/righthand.dmi'
	force = DAMAGE_STAFF - 5
	force_wielded = DAMAGE_STAFF_WIELD - 8
	wdefense = MEDIOCRE_PARRY
	wlength = WLENGTH_LONG
	possible_item_intents = list(POLEARM_BASH)
	gripped_intents = list(TILL_INTENT, PICK_INTENT, POLEARM_BASH)
	experimental_inhand = FALSE
	experimental_onback = FALSE
	experimental_onhip = FALSE
	gripspriteonmob = TRUE

	w_class = WEIGHT_CLASS_BULKY
	slot_flags = ITEM_SLOT_BACK
	minstr = 5
	sharpness = IS_BLUNT
	drop_sound = 'sound/foley/dropsound/wooden_drop.ogg'
	melting_material = /datum/material/iron
	melt_amount = 75
	associated_skill = /datum/skill/combat/polearms

	wlength = 66
	var/time_multiplier = 1
	max_integrity = INTEGRITY_POOR

/obj/item/weapon/hoe/Initialize()
	. = ..()
	AddElement(/datum/element/walking_stick)

/obj/item/weapon/hoe/getonmobprop(tag)
	. = ..()
	if(tag)
		switch(tag)
			if("gen")
				return list("shrink" = 0.7,
"sx" = -11,
"sy" = 1,
"nx" = 12,
"ny" = 0,
"wx" = -7,
"wy" = -0,
"ex" = 6,
"ey" = 3,
"northabove" = 0,
"southabove" = 1,
"eastabove" = 1,
"westabove" = 0,
"nturn" = -15,
"sturn" = 12,
"wturn" = 0,
"eturn" = 354,
"nflip" = 0,
"sflip" = 8,
"wflip" = 8,
"eflip" = 0)
			if("wielded")
				return list("shrink" = 0.8,
"sx" = 5,
"sy" = -6,
"nx" = -7,
"ny" = -6,
"wx" = 2,
"wy" = -6,
"ex" = 5,
"ey" = -4,
"northabove" = 0,
"southabove" = 1,
"eastabove" = 1,
"westabove" = 1,
"nturn" = -40,
"sturn" = 40,
"wturn" = 60,
"eturn" = 25,
"nflip" = 8,
"sflip" = 0,
"wflip" = 0,
"eflip" = 0)
			if("onbelt")
				return list("shrink" = 0.6,"sx" = -2,"sy" = -5,"nx" = 4,"ny" = -5,"wx" = 0,"wy" = -5,"ex" = 2,"ey" = -5,"nturn" = 0,"sturn" = 0,"wturn" = 0,"eturn" = 0,"nflip" = 0,"sflip" = 0,"wflip" = 0,"eflip" = 0,"northabove" = 0,"southabove" = 1,"eastabove" = 1,"westabove" = 0)

/obj/item/weapon/hoe/attack_atom(atom/attacked_atom, mob/living/user)
	if(!isturf(attacked_atom))
		return ..()

	var/turf/T = attacked_atom
	if(user.used_intent.type == /datum/intent/till)
		. = TRUE
		var/obj/structure/irrigation_channel/located = locate(/obj/structure/irrigation_channel) in T
		if(located)
			to_chat(user, span_notice("[located] is in the way!"))
			return
		user.changeNext_move(CLICK_CD_MELEE)
		if(istype(T, /turf/open/floor/grass))
			playsound(T,'sound/items/dig_shovel.ogg', 100, TRUE)
			if(do_after(user, 3 SECONDS * time_multiplier, src))
				apply_farming_fatigue(user, 10)
				T.ChangeTurf(/turf/open/floor/dirt, flags = CHANGETURF_INHERIT_AIR)
				playsound(T,'sound/items/dig_shovel.ogg', 100, TRUE)
			return
		if(istype(T, /turf/open/floor/dirt))
			playsound(T,'sound/items/dig_shovel.ogg', 100, TRUE)
			if(do_after(user, 2 SECONDS * time_multiplier, src))
				playsound(T,'sound/items/dig_shovel.ogg', 100, TRUE)
				var/obj/structure/soil/soil = get_soil_on_turf(T)
				if(soil)
					soil.user_till_soil(user)
				else
					apply_farming_fatigue(user, 8)
					new /obj/structure/soil(T)
			return
	return ..()

/datum/intent/till
	name = "hoe"
	icon_state = "inhoe"
	chargetime = 0
	noaa = TRUE
	candodge = FALSE
	misscost = 0

/obj/item/weapon/hoe/stone
	name = "stone hoe"
	desc = "A makeshift hoe made out of stone."
	icon_state = "stonehoe"
	force = DAMAGE_STAFF - 7
	force_wielded = DAMAGE_STAFF_WIELD - 10
	smeltresult = null
	anvilrepair = null
	max_integrity = INTEGRITY_WORST
	time_multiplier = 2

/*------------\
|  Pitchfork  |
\------------*/

/obj/item/weapon/pitchfork
	name = "pitchfork"
	desc = "Compost, chaff, hay, it matters not."
	icon = 'icons/roguetown/weapons/tools.dmi'
	icon_state = "pitchfork"
	force = DAMAGE_STAFF
	force_wielded = DAMAGE_SPEAR_WIELD - 3
	throwforce = DAMAGE_SPEAR
	wdefense = MEDIOCRE_PARRY
	wlength = WLENGTH_LONG
	possible_item_intents = list(POLEARM_THRUST, POLEARM_BASH)
	gripped_intents = list(DUMP_INTENT,POLEARM_BASH,POLEARM_THRUST)

	mob_overlay_icon = 'icons/roguetown/onmob/onmob.dmi'
	lefthand_file = 'icons/roguetown/onmob/lefthand.dmi'
	righthand_file = 'icons/roguetown/onmob/righthand.dmi'
	experimental_inhand = FALSE
	experimental_onback = FALSE
	experimental_onhip = FALSE
	gripspriteonmob = TRUE
	w_class = WEIGHT_CLASS_BULKY
	slot_flags = ITEM_SLOT_BACK
	blade_dulling = DULLING_BASHCHOP
	minstr = 6
	drop_sound = 'sound/foley/dropsound/wooden_drop.ogg'
	melting_material = /datum/material/iron
	melt_amount = 75
	associated_skill = /datum/skill/combat/polearms
	thrown_bclass = BCLASS_STAB
	max_integrity = INTEGRITY_POOR

	var/list/forked = list()

/obj/item/weapon/pitchfork/Initialize()
	. = ..()
	AddElement(/datum/element/walking_stick)

/obj/item/weapon/pitchfork/getonmobprop(tag)
	. = ..()
	if(tag)
		switch(tag)
			if("gen")
				return list("shrink" = 0.7,
"sx" = -6,
"sy" = -2,
"nx" = 8,
"ny" = -2,
"wx" = -7,
"wy" = -3,
"ex" = 2,
"ey" = -3,
"northabove" = 0,
"southabove" = 1,
"eastabove" = 1,
"westabove" = 0,
"nturn" = -15,
"sturn" = 12,
"wturn" = 0,
"eturn" = 354,
"nflip" = 0,
"sflip" = 8,
"wflip" = 8,
"eflip" = 0)
			if("wielded")
				return list("shrink" = 0.7,
"sx" = 4,
"sy" = -4,
"nx" = -7,
"ny" = -4,
"wx" = 2,
"wy" = -5,
"ex" = 5,
"ey" = -5,
"northabove" = 0,
"southabove" = 1,
"eastabove" = 1,
"westabove" = 1,
"nturn" = -135,
"sturn" = 135,
"wturn" = -240,
"eturn" = -30,
"nflip" = 0,
"sflip" = 8,
"wflip" = 8,
"eflip" = 1)
			if("onbelt")
				return list("shrink" = 0.5,"sx" = -2,"sy" = -5,"nx" = 4,"ny" = -5,"wx" = 0,"wy" = -5,"ex" = 2,"ey" = -5,"nturn" = 0,"sturn" = 0,"wturn" = 0,"eturn" = 0,"nflip" = 0,"sflip" = 0,"wflip" = 0,"eflip" = 0,"northabove" = 0,"southabove" = 1,"eastabove" = 1,"westabove" = 0)

/datum/intent/pforkdump
	name = "scoop"
	icon_state = "inscoop"
	chargetime = 0
	noaa = TRUE
	candodge = FALSE
	misscost = 0
	no_attack = TRUE

/obj/item/weapon/pitchfork/afterattack(obj/target, mob/user, proximity, list/modifiers)
	if((!proximity) || (!HAS_TRAIT(src, TRAIT_WIELDED)))
		return ..()
	if(isopenturf(target))
		if(forked.len)
			for(var/obj/item/I in forked)
				I.forceMove(target)
				forked -= I
			to_chat(user, span_warning("I dump the stalks."))
		update_appearance(UPDATE_ICON_STATE)
		return
	return ..()

/obj/item/weapon/pitchfork/on_unwield(obj/item/source, mob/living/carbon/user)
	. = ..()
	if(forked.len)
		var/turf/T = get_turf(user)
		for(var/obj/item/I in forked)
			I.forceMove(T)
			forked -= I
		update_appearance(UPDATE_ICON_STATE)

/obj/item/weapon/pitchfork/update_icon_state()
	. = ..()
	icon_state = "[initial(icon_state)][length(forked) ? "stuff" : ""]"
