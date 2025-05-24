
/obj/item/clothing/head/hooded
	var/obj/item/clothing/connectedc
	dynamic_hair_suffix = ""
	icon = 'icons/roguetown/clothing/head.dmi'
	mob_overlay_icon = 'icons/roguetown/clothing/onmob/head.dmi'

/obj/item/clothing/head/hooded/Destroy()
	connectedc = null
	return ..()

/obj/item/clothing/head/hooded/attack_right(mob/user)
	if(connectedc)
		connectedc.ToggleHood()

/obj/item/clothing/head/hooded/dropped()
	..()
	if(connectedc)
		connectedc.RemoveHood()

/obj/item/clothing/head/hooded/equipped(mob/user, slot)
	..()
	if(slot != SLOT_HEAD)
		if(connectedc)
			connectedc.RemoveHood()
		else
			qdel(src)

/obj/item/clothing/head/roguehood
	name = "hood"
	desc = "Conceals your face, whether against the rain, or the gazes of others."
	icon_state = "basichood"
	dynamic_hair_suffix = ""
	equip_sound = 'sound/foley/equip/cloak_equip.ogg'
	pickup_sound = 'sound/foley/equip/cloak_take_off.ogg'
	break_sound = 'sound/foley/cloth_rip.ogg'
	drop_sound = 'sound/foley/dropsound/cloth_drop.ogg'
	adjustable = CAN_CADJUST
	toggle_icon_state = TRUE
	var/default_hidden = null

	body_parts_covered = NECK
	salvage_amount = 1
	salvage_result = /obj/item/natural/cloth

/obj/item/clothing/head/roguehood/uncolored
	color = CLOTHING_LINEN

/obj/item/clothing/head/roguehood/brown
	color = CLOTHING_BARK_BROWN

/obj/item/clothing/head/roguehood/red
	color = CLOTHING_BLOOD_RED

/obj/item/clothing/head/roguehood/black
	color = CLOTHING_SOOT_BLACK

/obj/item/clothing/head/roguehood/green
	color = CLOTHING_FOREST_GREEN

/obj/item/clothing/head/roguehood/random/Initialize()
	color = pick( CLOTHING_PEASANT_BROWN, CLOTHING_SPRING_GREEN, CLOTHING_CHESTNUT, CLOTHING_YELLOW_OCHRE)
	..()

/obj/item/clothing/head/roguehood/mage/Initialize()
	color = pick(CLOTHING_MAGE_BLUE, CLOTHING_MAGE_GREEN, CLOTHING_MAGE_ORANGE, CLOTHING_MAGE_YELLOW)
	..()

/obj/item/clothing/head/roguehood/guard
	color = CLOTHING_PLUM_PURPLE

/obj/item/clothing/head/roguehood/guard/Initialize()
	. = ..()
	if(GLOB.lordprimary)
		lordcolor(GLOB.lordprimary,GLOB.lordsecondary)
	else
		GLOB.lordcolor += src

/obj/item/clothing/head/roguehood/guard/Destroy()
	GLOB.lordcolor -= src
	return ..()

/obj/item/clothing/head/roguehood/guardsecond
	color = CLOTHING_BLOOD_RED

/obj/item/clothing/head/roguehood/guardsecond/Initialize()
	. = ..()
	if(GLOB.lordprimary)
		lordcolor(GLOB.lordprimary,GLOB.lordsecondary)
	else
		GLOB.lordcolor += src

/obj/item/clothing/head/roguehood/guardsecond/lordcolor(primary,secondary)
	if(secondary)
		color = secondary

/obj/item/clothing/head/roguehood/guardsecond/Destroy()
	GLOB.lordcolor -= src
	return ..()

/obj/item/clothing/head/roguehood/AdjustClothes(mob/living/carbon/user)
	if(loc == user)
		if(adjustable == CAN_CADJUST)
			adjustable = CADJUSTED
			if(toggle_icon_state)
				icon_state = "[initial(icon_state)]_t"
			flags_inv = HIDEEARS|HIDEFACE|HIDEHAIR|HIDEFACIALHAIR
			body_parts_covered = NECK|HAIR|EARS|HEAD
			if(ishuman(user))
				var/mob/living/carbon/H = user
				H.update_inv_head()
			block2add = FOV_BEHIND
		else if(adjustable == CADJUSTED)
			ResetAdjust(user)
			flags_inv = default_hidden
			if(user)
				if(ishuman(user))
					var/mob/living/carbon/H = user
					H.update_inv_head()
		user.update_fov_angles()
		user.regenerate_clothes()


//............... Feldshers Hood ............... //
/obj/item/clothing/head/roguehood/feld
	name = "feldsher's hood"
	desc = "My cure is most effective."
	icon_state = "feldhood"
	item_state = "feldhood"
	color = null

	prevent_crits = MINOR_CRITICALS

//............... Physicians Hood ............... //
/obj/item/clothing/head/roguehood/phys
	name = "physicker's hood"
	desc = "My cure is mostly effective."
	icon_state = "surghood"
	item_state = "surghood"
	color = null

	prevent_crits = MINOR_CRITICALS


/obj/item/clothing/head/hooded/magehood
	name = "hood"
	desc = ""
	color = null
	icon_state = "adept-red"
	item_state = "adept-red"
	icon = 'icons/roguetown/clothing/head.dmi'
	mob_overlay_icon = 'icons/roguetown/clothing/onmob/head.dmi' //Overrides slot icon behavior
	body_parts_covered = NECK
	armor = ARMOR_PADDED_BAD
	prevent_crits = list(BCLASS_CUT, BCLASS_BLUNT)
	max_integrity = 100
	slot_flags = ITEM_SLOT_HEAD|ITEM_SLOT_MASK
	sleevetype = null
	sleeved = null
	dynamic_hair_suffix = ""
	edelay_type = 1
	adjustable = CAN_CADJUST
	toggle_icon_state = TRUE
	salvage_amount = 1
	salvage_result = /obj/item/natural/cloth
	flags_inv = HIDEHAIR|HIDEFACIALHAIR
	block2add = FOV_BEHIND
	var/newicon
	var/robe_count = 0

/obj/item/clothing/head/hooded/magehood/adept
	name = "hood"
	icon_state = "adept-red"
	item_state = "adept-red"

/obj/item/clothing/head/hooded/magehood/sorcerer
	name = "hood"
	icon_state = "sorcerer-red"
	item_state = "sorcerert-red"


/obj/item/clothing/head/roguehood/faceless
	icon_state = "facelesshood" //Credit goes to Cre
	color = CLOTHING_SOOT_BLACK
