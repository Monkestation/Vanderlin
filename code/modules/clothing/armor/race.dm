/obj/item/clothing/armor/plate/full/dwarven
	name = "grudgebearer dwarven plate"
	desc = "A sturdy set of dwarven plate armor, forged in the old ways. It cannot be worked on without intrinsic dwarven knowledge."
	icon = 'icons/roguetown/clothing/special/race_armor.dmi'
	mob_overlay_icon = 'icons/roguetown/clothing/special/onmob/race_armor.dmi'
	allowed_race = list(SPEC_ID_DWARF)
	icon_state = "dwarfchest"
	item_state = "dwarfchest"
	melt_amount = 375
	item_weight = 17 KILOGRAMS
	stand_speed_reduction = 1.2

/obj/item/clothing/armor/plate/full/dwarven/smith
	name = "grudgebearer splint apron"
	desc = "A mixture of plate and maille, worn by dwarven smiths. It cannot be worked on without intrinsic dwarven knowledge."
	icon_state = "dsmithchest"
	item_state = "dsmithchest"
	armor_class = AC_MEDIUM
	body_parts_covered = CHEST|GROIN|VITALS|LEGS
	max_integrity = ARMOR_INT_CHEST_MEDIUM_STEEL
	melt_amount = 250
