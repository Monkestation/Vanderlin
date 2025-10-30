
/obj/item/clothing/pants/platelegs
	name = "plated chausses"
	desc = "Cuisses made of plated steel, offering additional protection against blunt force."
	gender = PLURAL
	icon_state = "plate_legs"
	item_state = "plate_legs"
	sewrepair = FALSE
	blocksound = PLATEHIT
	equip_delay_self = 30
	unequip_delay_self = 30
	resistance_flags = FIRE_PROOF
	var/do_sound = FALSE
	equip_sound = 'sound/foley/equip/equip_armor_plate.ogg'
	drop_sound = 'sound/foley/dropsound/armor_drop.ogg'
	pickup_sound = "rustle"
	break_sound = 'sound/foley/breaksound.ogg'
	anvilrepair = /datum/skill/craft/armorsmithing
	melt_amount = 75
	melting_material = /datum/material/steel
	r_sleeve_status = SLEEVE_NOMOD
	l_sleeve_status = SLEEVE_NOMOD
	clothing_flags = CANT_SLEEP_IN

	armor_class = AC_HEAVY
	armor = ARMOR_PLATE
	max_integrity = INTEGRITY_STRONGEST
	prevent_crits = ALL_EXCEPT_BLUNT
	item_weight = 9 * STEEL_MULTIPLIER

/obj/item/clothing/pants/platelegs/Initialize()
	. = ..()
	AddComponent(/datum/component/item_equipped_movement_rustle, custom_sounds = SFX_PLATE_STEP)

/obj/item/clothing/pants/platelegs/iron
	name = "iron plated chausses"
	desc = "Cuisses made of plated iron, offering additional protection against blunt force."
	icon_state = "iplate_legs"
	item_state = "iplate_legs"
	smeltresult = /obj/item/ingot/iron

	armor = ARMOR_PLATE_BAD
	max_integrity = INTEGRITY_STRONG
	item_weight = 9 * IRON_MULTIPLIER

/obj/item/clothing/pants/platelegs/captain
	name = "captain's chausses"
	desc = "Cuisses made of plated steel, offering additional protection against blunt force. These are specially fitted for the captain."
	icon_state = "capplateleg"
	item_state = "capplateleg"
	icon = 'icons/roguetown/clothing/special/captain.dmi'
	mob_overlay_icon = 'icons/roguetown/clothing/special/onmob/captain.dmi'

/obj/item/clothing/pants/platelegs/rust
	name = "rusted chausses"
	desc = "Old rusted chausses made of plated iron. They'll still protect your legs quite well."
	icon = 'icons/roguetown/clothing/special/rust_armor.dmi'
	mob_overlay_icon = 'icons/roguetown/clothing/special/onmob/rust_armor.dmi'
	sleeved = 'icons/roguetown/clothing/special/onmob/rust_armor.dmi'
	icon_state = "rustpants"
	item_state = "rustpants"
	smeltresult = /obj/item/ingot/iron
	sellprice = VALUE_IRON_ARMOR/2
	armor = ARMOR_PLATE_BAD
	max_integrity = INTEGRITY_STANDARD

/obj/item/clothing/pants/platelegs/vampire
	name = "ancient plate greaves"
	desc = "Steel chausses from antiquity, though outdated they offer superior protection."
	icon_state = "vpants"
	item_state = "vpants"
	armor = ARMOR_PLATE_GOOD
	prevent_crits = ALL_CRITICAL_HITS_VAMP // Vampire armors don't protect against lashing, Castlevania reference
	item_weight = 5.5 * STEEL_MULTIPLIER

/obj/item/clothing/pants/platelegs/blk
	name = "blacksteel legs"
	desc = "Leg armor of blacksteel, resilient and surprisingly light."
	icon_state = "bklegs"
	icon = 'icons/roguetown/clothing/special/blkknight.dmi'
	mob_overlay_icon = 'icons/roguetown/clothing/special/onmob/blkknight.dmi'
	sleeved = 'icons/roguetown/clothing/special/onmob/blkknight.dmi'
	anvilrepair = /datum/skill/craft/blacksmithing
	smeltresult = /obj/item/ingot/blacksteel
	armor_class = AC_MEDIUM
	armor = ARMOR_PLATE_GOOD
	item_weight = 9 * BLACKSTEEL_MULTIPLIER
	sellprice = VALUE_SILVER_ITEM * 2

//............... Evil Pants ............... //

/obj/item/clothing/pants/platelegs/zizo
	name = "darksteel garments"
	desc = "Leg garments worn by true anointed of the Dame of Progress. In Her name."
	icon_state = "zizocloth"
	icon = 'icons/roguetown/clothing/special/evilarmor.dmi'
	mob_overlay_icon = 'icons/roguetown/clothing/special/onmob/evilarmor.dmi'
	sleeved = 'icons/roguetown/clothing/special/onmob/evilarmor.dmi'
	sellprice = 0 // Incredibly evil Zizoid armor, this should be burnt, nobody wants this

/obj/item/clothing/pants/platelegs/matthios
	name = "gilded leggings"
	desc = "Plate leggings. perfect for sprinting away after a theft of mammon, or life."
	icon_state = "matthioslegs"
	icon = 'icons/roguetown/clothing/special/evilarmor.dmi'
	mob_overlay_icon = 'icons/roguetown/clothing/special/onmob/evilarmor.dmi'
	sleeved = 'icons/roguetown/clothing/special/onmob/evilarmor.dmi'
	sellprice = 0 // See above comment

/obj/item/clothing/pants/platelegs/graggar
	name = "vicious leggings"
	desc = "A sinister pair of plate chausses that have born witness many violent atrocities."
	icon_state = "graggarplatelegs"
	icon = 'icons/roguetown/clothing/special/evilarmor.dmi'
	mob_overlay_icon = 'icons/roguetown/clothing/special/onmob/evilarmor.dmi'
	sleeved = 'icons/roguetown/clothing/special/onmob/evilarmor.dmi'
	sellprice = 0 // See above comment

//.............. Silver Platelegs .................//

/obj/item/clothing/pants/platelegs/silver
	name = "silver platelegs"
	desc = "A finely forged pair of silver plate leggings, offering additional protection against blunt force."
	icon_state = "silverlegs"
	allowed_ages = ALL_AGES_LIST //placeholder until younglings have onmob sprites for this item
	armor = ARMOR_PLATE_SILVER
	smeltresult = /obj/item/ingot/silver
	item_weight = 9 * SILVER_MULTIPLIER
	sellprice = VALUE_SILVER_ARMOR

/obj/item/clothing/pants/platelegs/silver/Initialize(mapload)
	. = ..()
	enchant(/datum/enchantment/silver)
