/*---------\
|  Shovel  |
\---------*/

/obj/item/weapon/shovel
	name = "shovel"
	desc = ""
	icon_state = "shovel"
	icon = 'icons/roguetown/weapons/tools.dmi'
	mob_overlay_icon = 'icons/roguetown/onmob/onmob.dmi'
	force = DAMAGE_CLUB - 5
	force_wielded = DAMAGE_CLUB_WIELD - 2
	wdefense = MEDIOCRE_PARRY
	wlength = WLENGTH_LONG
	possible_item_intents = list(SHOVEL_STRIKE)
	gripped_intents = list(SHOVEL_SCOOP, SHOVEL_IRRIGATE, SHOVEL_STRIKE, AXE_CHOP)

	experimental_onhip = FALSE
	experimental_onback = FALSE
	max_integrity = INTEGRITY_STRONG
	sharpness = IS_SHARP
	w_class = WEIGHT_CLASS_BULKY
	slot_flags = ITEM_SLOT_BACK
	swingsound = list('sound/combat/wooshes/blunt/shovel_swing.ogg','sound/combat/wooshes/blunt/shovel_swing2.ogg')
	drop_sound = 'sound/foley/dropsound/shovel_drop.ogg'
	var/obj/item/natural/clod/dirt/heldclod
	melting_material = /datum/material/iron
	melt_amount = 75
	associated_skill = /datum/attribute/skill/combat/polearms
	max_blade_int = 100
	grid_width = 32
	grid_height = 96
	item_weight = 1.54 KILOGRAMS

/obj/item/weapon/shovel/Destroy()
	if(heldclod)
		QDEL_NULL(heldclod)
	return ..()

/obj/item/weapon/shovel/dropped(mob/user)
	. = ..()
	if(heldclod && isturf(loc))
		heldclod.forceMove(loc)
		heldclod = null
	update_appearance(UPDATE_ICON_STATE)

/obj/item/weapon/shovel/update_icon_state()
	. = ..()
	icon_state = "[heldclod ? "[heldclod.clod_type]" : ""][initial(icon_state)]"
	if(gripsprite)
		toggle_state = "[heldclod ? "[heldclod.clod_type]" : ""][initial(icon_state)]"

/datum/intent/shovelscoop
	name = "scoop"
	icon_state = "inscoop"
	chargetime = 0
	noaa = TRUE
	candodge = FALSE
	misscost = 10
	no_attack = TRUE
	item_damage_type = "blunt"

/datum/intent/irrigate
	name = "irrigate"
	icon_state = "inhoe"
	chargetime = 0
	noaa = TRUE
	candodge = FALSE
	misscost = 10
	no_attack = TRUE
	item_damage_type = "blunt"


/obj/item/weapon/shovel/interact_with_atom(atom/interacting_with, mob/living/user, list/modifiers)
	if(user.cmode)
		return NONE

	if(istype(interacting_with, /obj/structure/snow))
		user.changeNext_move(CLICK_CD_MELEE)

		playsound(interacting_with,'sound/items/dig_shovel.ogg', 100, TRUE)

		var/turf/target_turf = get_turf(interacting_with)
		qdel(interacting_with)
		target_turf.snow = null //ffs

		for(var/turf/turf as anything in get_adjacent_open_turfs(interacting_with))
			var/obj/structure/snow/snow = locate() in turf
			snow?.update_corners()

		return ITEM_INTERACT_SUCCESS

	if(!isturf(interacting_with))
		return NONE

	if(!isturf(user.loc))
		return ITEM_INTERACT_ANY_BLOCKER

	var/turf/turf = interacting_with

	var/datum/intent/used_intent = user.used_intent

	if(istype(used_intent, /datum/intent/shovelscoop))
		var/obj/structure/closet/dirthole/holie = locate() in turf
		if(!heldclod)
			if(holie)
				holie.item_interaction(user, src, modifiers)
			else if(istype(turf, /turf/open/floor/sand))
				new /obj/item/natural/clod/sand(src)
				playsound(turf, 'sound/items/dig_shovel.ogg', 100, TRUE)
				update_appearance(UPDATE_ICON_STATE)
			else
				if(istype(turf, /turf/open/floor/dirt/road))
					new /obj/structure/closet/dirthole(turf)
				else
					turf.ChangeTurf(/turf/open/floor/dirt/road, flags = CHANGETURF_INHERIT_AIR)
				heldclod = new(src)
				playsound(turf, 'sound/items/dig_shovel.ogg', 100, TRUE)
				update_appearance(UPDATE_ICON_STATE)
			return ITEM_INTERACT_SUCCESS

		if(!istype(turf, /turf/open/floor/dirt) && !istype(turf, /turf/open/floor/sand))
			if(istype(turf, /turf/open/water))
				qdel(heldclod)
			else
				heldclod.forceMove(turf)
			heldclod = null
			playsound(turf, 'sound/items/empty_shovel.ogg', 100, TRUE)
			update_appearance(UPDATE_ICON_STATE)
			return ITEM_INTERACT_SUCCESS

		if(holie && holie.stage < 4)
			holie.item_interaction(user, src, modifiers)
		else if(istype(turf, /turf/open/floor/dirt/road))
			qdel(heldclod)
			turf.ChangeTurf(/turf/open/floor/dirt, flags = CHANGETURF_INHERIT_AIR)
		else
			heldclod.forceMove(turf)
		heldclod = null
		playsound(turf, 'sound/items/empty_shovel.ogg', 100, TRUE)
		update_appearance(UPDATE_ICON_STATE)
		return ITEM_INTERACT_SUCCESS

	if(istype(used_intent, /datum/intent/irrigate))
		var/obj/structure/soil/located = locate(/obj/structure/soil) in turf
		if(located)
			to_chat(user, span_notice("[located] is in the way!"))
			return ITEM_INTERACT_BLOCKING
		if(istype(turf, /turf/open/floor/dirt))
			user.visible_message("[user] starts digging an irrigation channel.", "You start digging an irrigation channel.")
			if(!do_after(user, 5 SECONDS * toolspeed, turf))
				return ITEM_INTERACT_BLOCKING

			new /obj/structure/irrigation_channel(turf)

			return ITEM_INTERACT_SUCCESS

/obj/item/weapon/shovel/getonmobprop(tag)
	. = ..()
	if(tag)
		switch(tag)
			if("gen")
				return list("shrink" = 0.6,
"sx" = 0,
"sy" = -8,
"nx" = 2,
"ny" = -7,
"wx" = -4,
"wy" = -6,
"ex" = 5,
"ey" = -7,
"northabove" = 0,
"southabove" = 1,
"eastabove" = 1,
"westabove" = 0,
"nturn" = 105,
"sturn" = -90,
"wturn" = 0,
"eturn" = 90,
"nflip" = 0,
"sflip" = 8,
"wflip" = 8,
"eflip" = 1)
			if("wielded")
				return list("shrink" = 0.7,
"sx" = 3,
"sy" = -5,
"nx" = -7,
"ny" = -4,
"wx" = 0,
"wy" = -5,
"ex" = 5,
"ey" = -4,
"northabove" = 0,
"southabove" = 1,
"eastabove" = 1,
"westabove" = 1,
"nturn" = 140,
"sturn" = -140,
"wturn" = 240,
"eturn" = 30,
"nflip" = 0,
"sflip" = 8,
"wflip" = 8,
"eflip" = 1)
			if("onbelt")
				return list("shrink" = 0.4,"sx" = -2,"sy" = -5,"nx" = 4,"ny" = -5,"wx" = -2,"wy" = -5,"ex" = 2,"ey" = -5,"nturn" = 0,"sturn" = 0,"wturn" = 0,"eturn" = 0,"nflip" = 0,"sflip" = 0,"wflip" = 0,"eflip" = 0,"northabove" = 0,"southabove" = 1,"eastabove" = 1,"westabove" = 0)


// --------- SPADE -----------

/obj/item/weapon/shovel/small
	name = "spade"
	icon_state = "spade"
	item_state = "spade"
	force = DAMAGE_STAFF - 8
	force_wielded = DAMAGE_STAFF_WIELD - 10
	wdefense = BAD_PARRY
	wlength = WLENGTH_SHORT
	possible_item_intents = list(SHOVEL_SCOOP, SHOVEL_IRRIGATE, SHOVEL_STRIKE)
	sharpness = IS_BLUNT
	max_blade_int = 0

	dropshrink = 1
	gripped_intents = null
	slot_flags = ITEM_SLOT_HIP
	w_class = WEIGHT_CLASS_NORMAL
	grid_height = 64
	toolspeed = 2
	smeltresult = null
	item_weight = 792 GRAMS

/obj/item/weapon/shovel/small/getonmobprop(tag)
	. = ..()
	if(tag)
		switch(tag)
			if("gen")
				return list("shrink" = 0.6,"sx" = -7,"sy" = -6,"nx" = 10,"ny" = -6,"wx" = -6,"wy" = -6,"ex" = 5,"ey" = -8,"northabove" = 0,"southabove" = 1,"eastabove" = 1,"westabove" = 0,"nturn" = 30,"sturn" = -15,"wturn" = 0,"eturn" = 0,"nflip" = 0,"sflip" = 8,"wflip" = 8,"eflip" = 0)
			if("onbelt")
				return list("shrink" = 0.3,"sx" = -2,"sy" = -5,"nx" = 4,"ny" = -5,"wx" = 0,"wy" = -5,"ex" = 2,"ey" = -5,"nturn" = 0,"sturn" = 0,"wturn" = 0,"eturn" = 0,"nflip" = 0,"sflip" = 0,"wflip" = 0,"eflip" = 0,"northabove" = 0,"southabove" = 1,"eastabove" = 1,"westabove" = 0)

// --------- BATTLESHOVEL -----------

/obj/item/weapon/shovel/necran
	name = "necran battle shovel"
	desc = "This polearm esque great-shovel is granted for the completion of a gravetenders final initiation rites, for the wielder of this shovel shall rise no more, and with it in hand, neither shall their quarry."
	icon = 'icons/roguetown/weapons/64/polearms.dmi'
	icon_state = "battleshovel"
	SET_BASE_PIXEL(-16, -16)
	inhand_x_dimension = 64
	inhand_y_dimension = 64
	bigboy = TRUE
	gripsprite = TRUE
	experimental_onhip = TRUE
	experimental_onback = TRUE
	force = DAMAGE_SPEAR
	force_wielded = DAMAGE_SPEAR_WIELD
	wdefense = GREAT_PARRY
	wbalance = EASY_TO_DODGE
	wlength = WLENGTH_GREAT
	sharpness = IS_SHARP
	max_blade_int = 200

	dropshrink = 0.75
	gripped_intents = list(SHOVEL_SCOOP, SHOVEL_IRRIGATE, SHOVEL_STRIKE, POLEARM_CHOP)
	grid_height = 96
	grid_width = 64
	toolspeed = 0.8
	smeltresult = null

/obj/item/weapon/shovel/necran/Initialize()
	. = ..()
	AddElement(/datum/element/walking_stick)

/obj/item/weapon/shovel/necran/getonmobprop(tag)
	. = ..()
	if(tag)
		switch(tag)
			if("gen")
				return list("shrink" = 0.5,"sx" = -5,"sy" = 2,"nx" = 7,"ny" = 3,"wx" = -2,"wy" = 1,"ex" = 1,"ey" = 1,"northabove" = 0,"southabove" = 1,"eastabove" = 1,"westabove" = 0,"nturn" = -38,"sturn" = 37,"wturn" = 30,"eturn" = -30,"nflip" = 0,"sflip" = 8,"wflip" = 8,"eflip" = 0)
			if("wielded")
				return list("shrink" = 0.5,"sx" = 5,"sy" = -3,"nx" = -5,"ny" = -2,"wx" = -5,"wy" = -1,"ex" = 3,"ey" = -2,"northabove" = 0,"southabove" = 1,"eastabove" = 1,"westabove" = 0,"nturn" = 7,"sturn" = -7,"wturn" = 16,"eturn" = -22,"nflip" = 8,"sflip" = 0,"wflip" = 8,"eflip" = 0)
			if("onbelt")
				return list("shrink" = 0.3,"sx" = -2,"sy" = -3,"nx" = 4,"ny" = -3,"wx" = 0,"wy" = -3,"ex" = 2,"ey" = -1,"nturn" = 0,"sturn" = 0,"wturn" = 0,"eturn" = 0,"nflip" = 0,"sflip" = 0,"wflip" = 0,"eflip" = 0,"northabove" = 0,"southabove" = 1,"eastabove" = 1,"westabove" = 0)


// --------- BURIAL SHROUD -----------

/obj/item/burial_shroud
	name = "winding sheet"
	desc = "A sheet used to drag bodies easier and shield them from the elements."
	icon = 'icons/obj/bodybag.dmi'
	icon_state = "shroud_folded"
	w_class = WEIGHT_CLASS_SMALL
	item_weight = 125 GRAMS
	var/unfoldedbag_path = /obj/structure/closet/burial_shroud

/obj/item/burial_shroud/attack_self(mob/user, list/modifiers)
	deploy_bodybag(user, user.loc)

/obj/item/burial_shroud/interact_with_atom(atom/interacting_with, mob/living/user, list/modifiers)
	if(isopenturf(interacting_with))
		deploy_bodybag(user, interacting_with)
		return ITEM_INTERACT_SUCCESS

/obj/item/burial_shroud/proc/deploy_bodybag(mob/user, atom/location)
	var/obj/structure/closet/burial_shroud/R = new unfoldedbag_path(location)
	R.open(user)
	R.add_fingerprint(user)
	R.foldedbag_instance = src
	moveToNullspace()
	user.update_a_intents()

/obj/structure/closet/burial_shroud
	name = "winding sheet"
	desc = ""
	icon = 'icons/obj/bodybag.dmi'
	icon_state = "shroud"
	base_icon_state = "shroud"
	density = FALSE
	mob_storage_capacity = 1
	open_sound = 'sound/blank.ogg'
	close_sound = 'sound/blank.ogg'
	open_sound_volume = 15
	close_sound_volume = 15
	integrity_failure = 0
	anchorable = FALSE
	mouse_drag_pointer = MOUSE_ACTIVE_POINTER
	drag_slowdown = 0
	horizontal = TRUE
	var/foldedbag_path = /obj/item/burial_shroud
	var/obj/item/burial_shroud/foldedbag_instance = null

/obj/structure/closet/burial_shroud/Destroy()
	// If we have a stored bag, and it's in nullspace (not in someone's hand), delete it.
	if (foldedbag_instance && !foldedbag_instance.loc)
		QDEL_NULL(foldedbag_instance)
	return ..()

/obj/structure/closet/burial_shroud/open(mob/living/user)
	. = ..()
	if(.)
		mouse_drag_pointer = MOUSE_INACTIVE_POINTER

/obj/structure/closet/burial_shroud/close()
	. = ..()
	if(.)
		density = FALSE
		mouse_drag_pointer = MOUSE_ACTIVE_POINTER

/obj/structure/closet/burial_shroud/MouseDrop(over_object, src_location, over_location)
	. = ..()
	if(over_object == usr && Adjacent(usr) && (in_range(src, usr) || usr.contents.Find(src)))
		if(!ishuman(usr))
			return
		if(contents.len)
			to_chat(usr, "<span class='warning'>There are too many things inside of [src] to fold it up!</span>")
			return
		visible_message("<span class='notice'>[usr] folds up [src].</span>")
		var/obj/item/burial_shroud/B = foldedbag_instance || new foldedbag_path
		usr.put_in_hands(B)
		qdel(src)
