
/obj/item/clothing/head/hooded
	var/obj/item/clothing/connectedc
	dynamic_hair_suffix = ""
	icon = 'icons/roguetown/clothing/head.dmi'
	mob_overlay_icon = 'icons/roguetown/clothing/onmob/head.dmi'
	abstract_type = /obj/item/clothing/head/hooded

/obj/item/clothing/head/hooded/Destroy()
	connectedc = null
	return ..()

/obj/item/clothing/head/hooded/attack_hand_secondary(mob/user, list/modifiers)
	. = ..()
	if(. == SECONDARY_ATTACK_CANCEL_ATTACK_CHAIN)
		return
	if(connectedc)
		connectedc.ToggleHood()
		return SECONDARY_ATTACK_CANCEL_ATTACK_CHAIN

/obj/item/clothing/head/hooded/dropped()
	. = ..()
	if(connectedc)
		connectedc.RemoveHood()

/obj/item/clothing/head/hooded/equipped(mob/user, slot)
	. = ..()
	if(!(slot & ITEM_SLOT_HEAD))
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

/obj/item/clothing/head/roguehood/colored
	misc_flags = CRAFTING_TEST_EXCLUDE

/obj/item/clothing/head/roguehood/colored/uncolored
	color = CLOTHING_LINEN

/obj/item/clothing/head/roguehood/colored/brown
	color = CLOTHING_BARK_BROWN

/obj/item/clothing/head/roguehood/colored/red
	color = CLOTHING_BLOOD_RED

/obj/item/clothing/head/roguehood/colored/black
	color = CLOTHING_SOOT_BLACK

/obj/item/clothing/head/roguehood/colored/green
	color = CLOTHING_FOREST_GREEN

/obj/item/clothing/head/roguehood/colored/random/Initialize()
	color = pick( CLOTHING_PEASANT_BROWN, CLOTHING_SPRING_GREEN, CLOTHING_CHESTNUT, CLOTHING_YELLOW_OCHRE)
	return ..()

/obj/item/clothing/head/roguehood/colored/mage/Initialize()
	color = pick(CLOTHING_MAGE_BLUE, CLOTHING_MAGE_GREEN, CLOTHING_MAGE_ORANGE, CLOTHING_MAGE_YELLOW)
	return ..()

/obj/item/clothing/head/roguehood/colored/guard
	color = CLOTHING_PLUM_PURPLE
	uses_lord_coloring = LORD_PRIMARY

/obj/item/clothing/head/roguehood/colored/guardsecond
	color = CLOTHING_BLOOD_RED
	uses_lord_coloring = LORD_SECONDARY

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
		user.update_fov_angles()
		user.regenerate_clothes()

/obj/item/clothing/head/roguehood/ResetAdjust(mob/user)
	. = ..()
	flags_inv = default_hidden
	if(iscarbon(user))
		var/mob/living/carbon/H = user
		H.update_inv_head()

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

/obj/item/clothing/head/roguehood/leather
	name = "leather hood"
	desc = "A simple if foreboding hood made out of leather. Worn by street thug and honest yeoman both. \
	Protects from the eventual stabbing, but not much more."
	icon_state = "leatherhood"
	item_state = "leatherhood"
	body_parts_covered = HEAD_EXCEPT_MOUTH | NECK
	flags_inv = HIDEFACE
	armor = ARMOR_LEATHER
	blocksound = SOFTUNDERHIT
