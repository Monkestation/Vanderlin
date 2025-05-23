/obj/item/clothing/shoes
	name = "shoes"
	desc = "Typical shoes worn by almost anyone."
	gender = PLURAL //Carn: for grammarically correct text-parsing

	icon = 'icons/roguetown/clothing/feet.dmi'
	mob_overlay_icon = 'icons/roguetown/clothing/onmob/feet.dmi'
	sleeved = 'icons/roguetown/clothing/onmob/feet.dmi'
	sleevetype = "leg"
	bloody_icon_state = "shoeblood"

	equip_sound = 'sound/foley/equip/cloak_equip.ogg'
	pickup_sound = 'sound/foley/equip/cloak_take_off.ogg'
	break_sound = 'sound/foley/cloth_rip.ogg'
	drop_sound = 'sound/foley/dropsound/cloth_drop.ogg'

	body_parts_covered = FEET
	slot_flags = ITEM_SLOT_SHOES
	prevent_crits = list(BCLASS_LASHING, BCLASS_TWIST)
	resistance_flags = FLAMMABLE

	permeability_coefficient = 0.5
	slowdown = SHOES_SLOWDOWN
	strip_delay = 1 SECONDS
	equip_delay_self = 3 SECONDS

	grid_width = 64
	grid_height = 32

	smeltresult = /obj/item/ash
	sellprice = 5
	item_weight = 4

	var/blood_state = BLOOD_STATE_NOT_BLOODY
	var/list/bloody_shoes = list(BLOOD_STATE_MUD = 0, BLOOD_STATE_HUMAN = 0,BLOOD_STATE_XENO = 0, BLOOD_STATE_OIL = 0, BLOOD_STATE_NOT_BLOODY = 0)
	var/offset = 0
	var/equipped_before_drop = FALSE
	var/can_be_bloody = TRUE
	var/is_barefoot = FALSE
	var/chained = 0

/obj/item/clothing/shoes/ComponentInitialize()
	. = ..()
	RegisterSignal(src, COMSIG_COMPONENT_CLEAN_ACT, PROC_REF(clean_blood))

/obj/item/clothing/shoes/suicide_act(mob/living/carbon/user)
	if(rand(2)>1)
		user.visible_message("<span class='suicide'>[user] begins tying \the [src] up waaay too tightly! It looks like [user.p_theyre()] trying to commit suicide!</span>")
		var/obj/item/bodypart/l_leg = user.get_bodypart(BODY_ZONE_L_LEG)
		var/obj/item/bodypart/r_leg = user.get_bodypart(BODY_ZONE_R_LEG)
		if(l_leg)
			l_leg.dismember()
		if(r_leg)
			r_leg.dismember()
		playsound(user, "desceration", 50, TRUE, -1)
		return BRUTELOSS
	else//didnt realize this suicide act existed (was in miscellaneous.dm) and didnt want to remove it, so made it a 50/50 chance. Why not!
		user.visible_message("<span class='suicide'>[user] is bashing [user.p_their()] own head in with [src]! Ain't that a kick in the head?</span>")
		for(var/i = 0, i < 3, i++)
			sleep(3)
			playsound(user, 'sound/blank.ogg', 50, TRUE)
		return(BRUTELOSS)

/obj/item/clothing/shoes/worn_overlays(isinhands = FALSE)
	. = list()
//	if(!isinhands)
//		var/bloody = FALSE
//		if(GET_ATOM_BLOOD_DNA_LENGTH(src))
//			bloody = TRUE
//		else
//			bloody = bloody_shoes[BLOOD_STATE_HUMAN]

//		if(damaged_clothes)
//			. += mutable_appearance('icons/effects/item_damage.dmi', "damagedshoe")
//		if(bloody)
//			. += mutable_appearance('icons/effects/blood.dmi', "shoeblood")

/obj/item/clothing/shoes/equipped(mob/user, slot)
	. = ..()
	if(offset && slot_flags & slotdefine2slotbit(slot))
		user.pixel_y += offset
		worn_y_dimension -= (offset * 2)
		user.update_inv_shoes()
		equipped_before_drop = TRUE

/obj/item/clothing/shoes/proc/restore_offsets(mob/user)
	equipped_before_drop = FALSE
	user.pixel_y -= offset
	worn_y_dimension = world.icon_size

/obj/item/clothing/shoes/dropped(mob/user)
	if(offset && equipped_before_drop)
		restore_offsets(user)
	. = ..()

/obj/item/clothing/shoes/update_clothes_damaged_state(damaging = TRUE)
	..()
	if(ismob(loc))
		var/mob/M = loc
		M.update_inv_shoes()

/obj/item/clothing/shoes/proc/clean_blood(datum/source, strength)
	if(strength < CLEAN_TYPE_BLOOD)
		return
	bloody_shoes = list(BLOOD_STATE_MUD = 0,BLOOD_STATE_HUMAN = 0,BLOOD_STATE_XENO = 0, BLOOD_STATE_OIL = 0, BLOOD_STATE_NOT_BLOODY = 0)
	blood_state = BLOOD_STATE_NOT_BLOODY
	if(ismob(loc))
		var/mob/M = loc
		M.update_inv_shoes()

/obj/item/proc/negates_gravity()
	return FALSE
