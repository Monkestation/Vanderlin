#define ARMOR_CLASS_NONE 0
#define AC_LIGHT 1
#define AC_MEDIUM 2
#define AC_HEAVY 3

/obj/item/clothing
	name = "clothing"
	resistance_flags = FLAMMABLE
	obj_flags = CAN_BE_HIT
	break_sound = 'sound/foley/cloth_rip.ogg'
	blade_dulling = DULLING_CUT
	max_integrity = 200
	integrity_failure = 0.1
	drop_sound = 'sound/foley/dropsound/cloth_drop.ogg'

	//Here we have salvage vars!
	salvage_result = /obj/item/natural/cloth
	salvage_amount = 2
	fiber_salvage = TRUE

	edelay_type = 0

	sellprice = 1

	var/colorgrenz = FALSE
	var/damaged_clothes = 0 //similar to machine's BROKEN stat and structure's broken var
	///What level of bright light protection item has.
	var/flash_protect = FLASH_PROTECTION_NONE
	var/tint = 0				//Sets the item's level of visual impairment tint, normally set to the same as flash_protect
	var/up = 0					//but separated to allow items to protect but not impair vision, like space helmets
	var/visor_flags = 0			//flags that are added/removed when an item is adjusted up/down
	var/visor_flags_inv = 0		//same as visor_flags, but for flags_inv
	var/visor_flags_cover = 0	//same as above, but for flags_cover
//what to toggle when toggled with weldingvisortoggle()
	var/visor_vars_to_toggle = VISOR_FLASHPROTECT | VISOR_TINT | VISOR_VISIONFLAGS | VISOR_DARKNESSVIEW | VISOR_INVISVIEW
	var/alt_desc = null
	var/toggle_message = null
	var/alt_toggle_message = null
	var/active_sound = null
	var/toggle_cooldown = null
	var/cooldown = 0

	var/emote_environment = -1
	var/list/prevent_crits

	var/clothing_flags = NONE

	var/toggle_icon_state = TRUE //appends _t to our icon state when toggled

	//Var modification - PLEASE be careful with this I know who you are and where you live
	var/list/user_vars_to_edit //VARNAME = VARVALUE eg: "name" = "butts"
	var/list/user_vars_remembered //Auto built by the above + dropped() + equipped()

	var/pocket_storage_component_path

	//These allow head/mask items to dynamically alter the user's hair
	// and facial hair, checking hair_extensions.dmi and facialhair_extensions.dmi
	// for a state matching hair_state+dynamic_hair_suffix
	// THESE OVERRIDE THE HIDEHAIR FLAGS
	var/dynamic_hair_suffix = ""//head > mask for head hair
	var/dynamic_fhair_suffix = ""//mask > head for facial hair
	var/list/allowed_sex = list(MALE,FEMALE)
	var/list/allowed_race = ALL_RACES_LIST
	var/armor_class = ARMOR_CLASS_NONE

	var/do_sound_chain = FALSE
	var/do_sound_plate = FALSE

	var/obj/item/clothing/head/hooded/hood
	var/hoodtype
	var/hoodtoggled = FALSE
	var/adjustable = CANT_CADJUST

/obj/item/clothing/Initialize()
	if(CHECK_BITFIELD(clothing_flags, VOICEBOX_TOGGLABLE))
		actions_types += /datum/action/item_action/toggle_voice_box
	. = ..()
	if(ispath(pocket_storage_component_path))
		LoadComponent(pocket_storage_component_path)
	if(prevent_crits)
		if(prevent_crits.len)
			has_inspect_verb = TRUE
	if(armor_class)
		has_inspect_verb = TRUE

	if(do_sound_chain)
		AddComponent(/datum/component/squeak, list('sound/foley/footsteps/armor/chain (1).ogg',\
													'sound/foley/footsteps/armor/chain (2).ogg',\
													'sound/foley/footsteps/armor/chain (3).ogg'), 100)
	else if(do_sound_plate)
		AddComponent(/datum/component/squeak, list('sound/foley/footsteps/armor/plate (1).ogg',\
													'sound/foley/footsteps/armor/plate (2).ogg',\
													'sound/foley/footsteps/armor/plate (3).ogg'), 100)

	if(hoodtype)
		MakeHood()

/obj/item/clothing/Topic(href, href_list)
	. = ..()
	if(href_list["inspect"])
		if(!usr.canUseTopic(src, be_close=TRUE))
			return
		if(armor_class == AC_HEAVY)
			to_chat(usr, "AC: <b>HEAVY</b>")
		if(armor_class == AC_MEDIUM)
			to_chat(usr, "AC: <b>MEDIUM</b>")
		if(armor_class == AC_LIGHT)
			to_chat(usr, "AC: <b>LIGHT</b>")

/obj/item/clothing/examine(mob/user)
	. = ..()
	if(torn_sleeve_number)
		if(torn_sleeve_number == 1)
			. += span_notice("It has one torn sleeve.")
		else
			. += span_notice("Both its sleeves have been torn!")

/obj/item/clothing/MiddleClick(mob/user, params)
	..()
	var/mob/living/L = user
	var/altheld //Is the user pressing alt?
	var/list/modifiers = params2list(params)
	if(modifiers["alt"])
		altheld = TRUE
	if(!isliving(user))
		return
	if(nodismemsleeves)
		return
	if(altheld)
		if(user.zone_selected == l_sleeve_zone)
			if(l_sleeve_status == SLEEVE_ROLLED)
				l_sleeve_status = SLEEVE_NORMAL
				if(l_sleeve_zone == BODY_ZONE_L_ARM)
					body_parts_covered |= ARM_LEFT
				if(l_sleeve_zone == BODY_ZONE_L_LEG)
					body_parts_covered |= LEG_LEFT
			else
				if(l_sleeve_zone == BODY_ZONE_L_ARM)
					body_parts_covered &= ~ARM_LEFT
				if(l_sleeve_zone == BODY_ZONE_L_LEG)
					body_parts_covered &= ~LEG_LEFT
				l_sleeve_status = SLEEVE_ROLLED
			return
		else if(user.zone_selected == r_sleeve_zone)
			if(r_sleeve_status == SLEEVE_ROLLED)
				if(r_sleeve_zone == BODY_ZONE_R_ARM)
					body_parts_covered |= ARM_RIGHT
				if(r_sleeve_zone == BODY_ZONE_R_LEG)
					body_parts_covered |= LEG_RIGHT
				r_sleeve_status = SLEEVE_NORMAL
			else
				if(r_sleeve_zone == BODY_ZONE_R_ARM)
					body_parts_covered &= ~ARM_RIGHT
				if(r_sleeve_zone == BODY_ZONE_R_LEG)
					body_parts_covered &= ~LEG_RIGHT
				r_sleeve_status = SLEEVE_ROLLED
			return
	else
		if(user.zone_selected == r_sleeve_zone)
			if(r_sleeve_status == SLEEVE_NOMOD)
				return
			if(r_sleeve_status == SLEEVE_TORN)
				to_chat(user, span_info("It's torn away."))
				return
			if(!do_after(user, 2 SECONDS, user))
				return
			if(prob(L.STASTR * 8))
				torn_sleeve_number += 1
				r_sleeve_status = SLEEVE_TORN
				user.visible_message(span_notice("[user] tears [src]."))
				playsound(src, 'sound/foley/cloth_rip.ogg', 50, TRUE)
				if(r_sleeve_zone == BODY_ZONE_R_ARM)
					body_parts_covered &= ~ARM_RIGHT
				if(r_sleeve_zone == BODY_ZONE_R_LEG)
					body_parts_covered &= ~LEG_RIGHT
				if(salvage_result == /obj/item/natural/hide/cured)
					to_chat(user, span_info("You ruined a piece of leather."))
					return
				var/obj/item/Sr = new salvage_result(get_turf(src))
				Sr.color = color
				user.put_in_hands(Sr)
				return
			else
				user.visible_message("<span class='warning'>[user] tries to tear [src].</span>")
				return
		if(user.zone_selected == l_sleeve_zone)
			if(l_sleeve_status == SLEEVE_NOMOD)
				return
			if(l_sleeve_status == SLEEVE_TORN)
				to_chat(user, span_info("It's torn away."))
				return
			if(!do_after(user, 2 SECONDS, user))
				return
			if(prob(L.STASTR * 8))
				torn_sleeve_number += 1
				l_sleeve_status = SLEEVE_TORN
				user.visible_message(span_notice("[user] tears [src]."))
				playsound(src, 'sound/foley/cloth_rip.ogg', 50, TRUE)
				if(l_sleeve_zone == BODY_ZONE_L_ARM)
					body_parts_covered &= ~ARM_LEFT
				if(l_sleeve_zone == BODY_ZONE_L_LEG)
					body_parts_covered &= ~LEG_LEFT
				if(salvage_result == /obj/item/natural/hide/cured)
					to_chat(user, span_info("You ruined a piece of leather."))
					return
				var/obj/item/Sr = new salvage_result(get_turf(src))
				Sr.color = color
				user.put_in_hands(Sr)
				return
			else
				user.visible_message(span_warning("[user] tries to tear [src]."))
				return
	if(loc == L)
		L.regenerate_clothes()


/obj/item/clothing/mob_can_equip(mob/M, mob/equipper, slot, disable_warning = 0)
	if(!..())
		return FALSE
	if(slot_flags & slotdefine2slotbit(slot))
		if(M.gender in allowed_sex)
			if(ishuman(M))
				var/mob/living/carbon/human/H = M
				if(H.dna)
					if(H.dna.species.id in allowed_race)
						return TRUE
					else
						return FALSE
			return TRUE
		else
			return FALSE

/obj/item/clothing/proc/step_action() //this was made to rewrite clown shoes squeaking
	SEND_SIGNAL(src, COMSIG_CLOTHING_STEP_ACTION)

/obj/item/clothing/dropped()
	..()
	if(hoodtype)
		RemoveHood()
	if(adjustable > 0)
		ResetAdjust()

/obj/item/clothing/MouseDrop(atom/over_object)
	. = ..()
	var/mob/M = usr

	if(!M.incapacitated(ignore_grab = TRUE) && loc == M && istype(over_object, /atom/movable/screen/inventory/hand))
		if(!allow_attack_hand_drop(M))
			return
		var/atom/movable/screen/inventory/hand/H = over_object
		if(M.putItemFromInventoryInHandIfPossible(src, H.held_index))
			add_fingerprint(usr)

/obj/item/clothing/Destroy()
	user_vars_remembered = null //Oh god somebody put REFERENCES in here? not to worry, we'll clean it up
	if(hoodtype)
		qdel(hood)
		hood = null
	return ..()

/obj/item/clothing/proc/can_use(mob/user)
	if(user && ismob(user))
		if(!user.incapacitated(ignore_grab = TRUE))
			return TRUE
	return FALSE

/obj/item/clothing/attack(mob/living/M, mob/living/user, def_zone)
	if(M.on_fire)
		if(user == M)
			return
		user.changeNext_move(CLICK_CD_MELEE)
		M.visible_message(span_warning("[user] pats out the flames on [M] with [src]!"))
		M.adjust_divine_fire_stacks(-2)
		if(M.fire_stacks > 0)
			M.adjust_fire_stacks(-2)
		take_damage(10, BURN, "fire")
	else
		return ..()

/obj/item/clothing/dropped(mob/user)
	..()
	if(!istype(user))
		return
	if(LAZYLEN(user_vars_remembered))
		for(var/variable in user_vars_remembered)
			if(variable in user.vars)
				if(user.vars[variable] == user_vars_to_edit[variable]) //Is it still what we set it to? (if not we best not change it)
					user.vars[variable] = user_vars_remembered[variable]
		user_vars_remembered = initial(user_vars_remembered) // Effectively this sets it to null.

/obj/item/clothing/equipped(mob/user, slot)
	..()
	if (!istype(user))
		return
	if(slot_flags & slotdefine2slotbit(slot)) //Was equipped to a valid slot for this item?
		if (LAZYLEN(user_vars_to_edit))
			for(var/variable in user_vars_to_edit)
				if(variable in user.vars)
					LAZYSET(user_vars_remembered, variable, user.vars[variable])
					user.vv_edit_var(variable, user_vars_to_edit[variable])

/obj/item/clothing/update_icon()
	cut_overlays()
	if (get_detail_tag())
		var/mutable_appearance/pic = mutable_appearance(icon(icon, "[icon_state][detail_tag]"))
		pic.appearance_flags = RESET_COLOR
		if (get_detail_color())
			pic.color = get_detail_color()
		add_overlay(pic)

/obj/item/clothing/obj_break(damage_flag, silent)
	if(!damaged_clothes)
		update_clothes_damaged_state(TRUE)
	var/brokemessage = FALSE
	var/list/armorlist = armor?.getList()
	for(var/x in armorlist)
		if(armorlist[x] > 0)
			brokemessage = TRUE
			armorlist[x] = 0
	if(ismob(loc) && brokemessage)
		var/mob/M = loc
		to_chat(M, "ARMOR BROKEN...!")
	..()

/obj/item/clothing/proc/update_clothes_damaged_state(damaging = TRUE)
	var/index = "[REF(initial(icon))]-[initial(icon_state)]"
	var/static/list/damaged_clothes_icons = list()
	if(damaging)
		damaged_clothes = 1
		var/icon/damaged_clothes_icon = damaged_clothes_icons[index]
		if(!damaged_clothes_icon)
			damaged_clothes_icon = icon(initial(icon), initial(icon_state), , 1)	//we only want to apply damaged effect to the initial icon_state for each object
			damaged_clothes_icon.Blend("#fff", ICON_ADD) 	//fills the icon_state with white (except where it's transparent)
			damaged_clothes_icon.Blend(icon('icons/effects/item_damage.dmi', "itemdamaged"), ICON_MULTIPLY) //adds damage effect and the remaining white areas become transparant
			damaged_clothes_icon = fcopy_rsc(damaged_clothes_icon)
			damaged_clothes_icons[index] = damaged_clothes_icon
		add_overlay(damaged_clothes_icon, 1)
	else
		damaged_clothes = 0
		cut_overlay(damaged_clothes_icons[index], TRUE)


/*
SEE_SELF  // can see self, no matter what
SEE_MOBS  // can see all mobs, no matter what
SEE_OBJS  // can see all objs, no matter what
SEE_TURFS // can see all turfs (and areas), no matter what
SEE_PIXELS// if an object is located on an unlit area, but some of its pixels are
		  // in a lit area (via pixel_x,y or smooth movement), can see those pixels
BLIND     // can't see anything
*/

/proc/generate_female_clothing(index,t_color,icon,type)
	var/icon/female_clothing_icon	= icon("icon"=icon, "icon_state"=t_color)
	var/icon/female_s				= icon("icon"='icons/mob/clothing/under/masking_helpers.dmi', "icon_state"="[(type == FEMALE_UNIFORM_FULL) ? "female_full" : "female_top"]")
	female_clothing_icon.Blend(female_s, ICON_MULTIPLY)
	female_clothing_icon 			= fcopy_rsc(female_clothing_icon)
	GLOB.female_clothing_icons[index] = female_clothing_icon

/proc/generate_dismembered_clothing(index, t_color, icon, sleeveindex, sleevetype)
	testing("GDC [index]")
	if(sleevetype)
		var/icon/dismembered		= icon("icon"=icon, "icon_state"=t_color)
		var/icon/r_mask				= icon("icon"='icons/roguetown/clothing/onmob/helpers/dismemberment.dmi', "icon_state"="r_[sleevetype]")
		var/icon/l_mask				= icon("icon"='icons/roguetown/clothing/onmob/helpers/dismemberment.dmi', "icon_state"="l_[sleevetype]")
		switch(sleeveindex)
			if(1)
				dismembered.Blend(r_mask, ICON_MULTIPLY)
				dismembered.Blend(l_mask, ICON_MULTIPLY)
			if(2)
				dismembered.Blend(l_mask, ICON_MULTIPLY)
			if(3)
				dismembered.Blend(r_mask, ICON_MULTIPLY)
		dismembered 			= fcopy_rsc(dismembered)
		testing("GDC added [index]")
		GLOB.dismembered_clothing_icons[index] = dismembered

/obj/item/clothing/pants/AltClick(mob/user)
	if(..())
		return 1

	if(!istype(user) || !user.canUseTopic(src, BE_CLOSE, ismonkey(user)))
		return
	else
		if(attached_accessory)
			remove_accessory(user)
		else
			rolldown()

/obj/item/clothing/obj_destruction(damage_flag)
	if(damage_flag == "acid")
		obj_destroyed = TRUE
		acid_melt()
	else if(damage_flag == "fire")
		obj_destroyed = TRUE
		burn()
	else
		if(!ismob(loc))
			obj_destroyed = TRUE
			if(destroy_sound)
				playsound(src, destroy_sound, 100, TRUE)
			if(destroy_message)
				visible_message(destroy_message)
			deconstruct(FALSE)
		else
			return FALSE
	return TRUE


/obj/item/clothing/proc/MakeHood()
	if(!hood)
		var/obj/item/clothing/head/hooded/W = new hoodtype(src)
		W.moveToNullspace()
		W.color = color
		W.connectedc = src
		hood = W

/obj/item/clothing/attack_right(mob/user)
	if(hoodtype)
		ToggleHood()
	if(adjustable > 0)
		if(loc == user)
			AdjustClothes(user)

/obj/item/clothing/proc/AdjustClothes(mob/usFer)
	return //override this in the clothing item itself so we can update the right inv

/obj/item/clothing/proc/ResetAdjust(mob/user)
	adjustable = initial(adjustable)
	icon_state = "[initial(icon_state)]"
	slowdown = initial(slowdown)
	flags_inv = initial(flags_inv)
	flags_cover = initial(flags_cover)
	block2add = initial(block2add)
	body_parts_covered = initial(body_parts_covered)
	prevent_crits = initial(prevent_crits)
	gas_transfer_coefficient = initial(gas_transfer_coefficient)

/obj/item/clothing/equipped(mob/user, slot)
	if(hoodtype && slot != SLOT_ARMOR|SLOT_CLOAK)
		RemoveHood()
	if(adjustable > 0)
		ResetAdjust(user)
	..()

/obj/item/clothing/proc/RemoveHood()
	if(!hood)
		return
	src.icon_state = "[initial(icon_state)]"
	hoodtoggled = FALSE
	if(ishuman(hood.loc))
		var/mob/living/carbon/H = hood.loc
		H.transferItemToLoc(hood, get_turf(src), TRUE)
		hood.moveToNullspace()
		H.update_inv_wear_suit()
		H.update_inv_cloak()
		H.update_inv_neck()
		H.update_inv_pants()
		H.update_fov_angles()
	else
//		hood.forceMove(src)
		hood.moveToNullspace()
	for(var/X in actions)
		var/datum/action/A = X
		A.UpdateButtonIcon()


/obj/item/clothing/proc/ToggleHood()
	if(!hoodtoggled)
		if(ishuman(src.loc))
			var/mob/living/carbon/human/H = src.loc
			if(hood.color != color)
				hood.color = color
			if(slot_flags == ITEM_SLOT_ARMOR)
				if(H.wear_armor != src)
					to_chat(H, "<span class='warning'>I should put that on first.</span>")
					return
			if(slot_flags == ITEM_SLOT_CLOAK)
				if(H.cloak != src)
					to_chat(H, "<span class='warning'>I should put that on first.</span>")
					return
			if(H.head)
				to_chat(H, "<span class='warning'>I'm already wearing something on my head.</span>")
				return
			else if(H.equip_to_slot_if_possible(hood,SLOT_HEAD,0,0,1))
				testing("begintog")
				hoodtoggled = TRUE
				if(toggle_icon_state)
					src.icon_state = "[initial(icon_state)]_t"
				H.update_inv_wear_suit()
				H.update_inv_cloak()
				H.update_inv_neck()
				H.update_inv_pants()
				H.update_fov_angles()

	else
		RemoveHood()
	testing("endtoggle")
