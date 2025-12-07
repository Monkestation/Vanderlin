
/obj/item/clothing/gloves/plate
	name = "plate gauntlets"
	desc = "Plated gauntlets made out of steel. Offers the best protection against melee attacks."
	icon_state = "gauntlets"
	blocksound = PLATEHIT
	equip_delay_self = 25
	unequip_delay_self = 25
	body_parts_covered = ARMS|HANDS
	blade_dulling = DULLING_BASH
	equip_sound = 'sound/foley/equip/equip_armor_plate.ogg'
	pickup_sound = "rustle"
	break_sound = 'sound/foley/breaksound.ogg'
	drop_sound = 'sound/foley/dropsound/armor_drop.ogg'
	anvilrepair = /datum/skill/craft/armorsmithing
	sewrepair = FALSE
	smeltresult = /obj/item/ingot/iron //no 1 to 1 conversion

	armor_class = AC_HEAVY
	armor = ARMOR_PLATE
	prevent_crits = ALL_EXCEPT_STAB
	max_integrity = INTEGRITY_STRONGEST

	grid_width = 64
	grid_height = 32
	item_weight = 7 * IRON_MULTIPLIER

/obj/item/clothing/gloves/plate/iron
	name = "iron plate gauntlets"
	desc = "Plated gauntlets made out of iron. Offers good protection against melee attacks."
	icon_state = "igauntlets"
	sellprice = VALUE_IRON_ARMOR/2
	armor = ARMOR_PLATE_BAD
	max_integrity = INTEGRITY_STRONG

/obj/item/clothing/gloves/plate/rust
	name = "rusted riveted gauntlets"
	desc = "Riveted gauntlets made out of iron. They're covered in rust.. at least the glove liner is good still."
	icon = 'icons/roguetown/clothing/special/rust_armor.dmi'
	mob_overlay_icon = 'icons/roguetown/clothing/special/onmob/rust_armor.dmi'
	sleeved = 'icons/roguetown/clothing/special/onmob/rust_armor.dmi'
	icon_state = "rustgloves"
	item_state = "rustgloves"
	smeltresult = /obj/item/ingot/iron
	sellprice = VALUE_IRON_ARMOR/2
	armor = ARMOR_PLATE_BAD
	max_integrity = INTEGRITY_STANDARD

/obj/item/clothing/gloves/plate/blk
	name = "blacksteel gauntlets"
	desc = "Gauntlets of blacksteel, offering unmatched protection for the hands."
	icon_state = "bkgloves"
	icon = 'icons/roguetown/clothing/special/blkknight.dmi'
	mob_overlay_icon = 'icons/roguetown/clothing/special/onmob/blkknight.dmi'
	sleeved = 'icons/roguetown/clothing/special/onmob/blkknight.dmi'
	anvilrepair = /datum/skill/craft/blacksmithing
	smeltresult = /obj/item/ingot/blacksteel
	armor_class = AC_MEDIUM
	armor = ARMOR_PLATE_GOOD
	item_weight = 7 * BLACKSTEEL_MULTIPLIER
	sellprice = VALUE_SILVER_ITEM * 2

	//............... Evil Gloves ............... //

/obj/item/clothing/gloves/plate/zizo
	name = "darksteel gauntlets"
	desc = "darksteel plate gauntlets. Called forth from the edge of what should be known. In Her name."
	icon_state = "zizogauntlets"
	icon = 'icons/roguetown/clothing/special/evilarmor.dmi'
	mob_overlay_icon = 'icons/roguetown/clothing/special/onmob/evilarmor.dmi'
	sleeved = 'icons/roguetown/clothing/special/onmob/evilarmor.dmi'
	sellprice = 0 // Incredibly evil Zizoid armor, this should be burnt, nobody wants this

/obj/item/clothing/gloves/plate/matthios
	name = "gilded gauntlets"
	desc = "Shimmering plate gauntlets. Many riches have been taken with these, and just as many lives."
	icon_state = "matthiosgloves"
	icon = 'icons/roguetown/clothing/special/evilarmor.dmi'
	mob_overlay_icon = 'icons/roguetown/clothing/special/onmob/evilarmor.dmi'
	sleeved = 'icons/roguetown/clothing/special/onmob/evilarmor.dmi'
	sellprice = 0 // See above comment

/obj/item/clothing/gloves/plate/graggar
	name = "vicious gauntlets"
	desc = "Plate gauntlets that reek of death. Many lives have been taken with these."
	icon_state = "graggarplategloves"
	icon = 'icons/roguetown/clothing/special/evilarmor.dmi'
	mob_overlay_icon = 'icons/roguetown/clothing/special/onmob/evilarmor.dmi'
	sleeved = 'icons/roguetown/clothing/special/onmob/evilarmor.dmi'
	sellprice = 0 // See above comment
