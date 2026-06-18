/obj/item/clothing/head/helmet/heavy/dwarven
	name = "grudgebearer dwarven helm"
	desc = "A hardy dwarven helmet. It lets one's dwarvenly beard to poke out."
	body_parts_covered = HEAD|MOUTH|NOSE|EYES|EARS|NECK	//This specifically omits hair so you could hang your beard out of the helm
	armor = ARMOR_PLATE
	allowed_race = list(SPEC_ID_DWARF)
	icon = 'icons/roguetown/clothing/special/race_armor.dmi'
	mob_overlay_icon = 'icons/roguetown/clothing/special/onmob/race_armor.dmi'
	icon_state = "dwarfhead"
	item_state = "dwarfhead"
	bloody_icon = 'icons/effects/blood64x64.dmi'
	melting_material = /datum/material/steel
	experimental_inhand = TRUE
	experimental_onhip = TRUE
	item_weight = 3.5 KILOGRAMS

/obj/item/clothing/head/helmet/heavy/dwarven/smith
	name = "grudgebearer smith helm"
	desc = "A hardy dwarven helmet. It lets one's dwarvenly beard to poke out. \
	This one is intended for the smiths of the clan. No less protective. All the more stylish."
	icon_state = "dsmithhead"
	item_state = "dsmithhead"
