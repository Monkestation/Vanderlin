//................ Orc Armor ............... //
/obj/item/clothing/armor/plate/orc
	name = "crude breastplate"
	icon_state = "marauder_armor"
	item_state = "marauder_armor"
	allowed_race = list(SPEC_ID_ORC)
	smeltresult = /obj/item/ingot/iron
	sellprice = NO_MARKET_VALUE

	armor_class = AC_MEDIUM
	armor = ARMOR_PADDED_GOOD
	body_parts_covered = CHEST|GROIN|ARMS|LEGS|VITALS
	max_integrity = INTEGRITY_POOR

/obj/item/clothing/armor/plate/orc/warlord
	name = "warlord armor"
	desc = "Fearsome armor which covers nearly the entire body."
	icon_state = "warlord_armor"
	item_state = "warlord_armor"
	armor = ARMOR_PLATE_BAD

/obj/item/clothing/armor/chainmail/iron/orc
	name = "crude maille"
	icon_state = "orc_chainvest"
	item_state = "orc_chainvest"
	allowed_race = list(SPEC_ID_ORC)
	sellprice = NO_MARKET_VALUE

	armor_class = AC_MEDIUM
	armor = list("blunt" = 25, "slash" = 25, "stab" = 25,  "piercing" = 50, "fire" = 0, "acid" = 0)
	body_parts_covered = CHEST|GROIN|ARMS|LEGS|VITALS
	prevent_crits = ALL_EXCEPT_BLUNT
	max_integrity = INTEGRITY_POOR

/obj/item/clothing/head/helmet/orc
	name = "Orc Marauder Helmet"
	icon_state = "marauder_helm"
	item_state = "marauder_helm"
	allowed_race = list(SPEC_ID_ORC)
	smeltresult = /obj/item/ingot/iron
	armor = list("blunt" = 60, "slash" = 60, "stab" = 60,  "piercing" = 0, "fire" = 0, "acid" = 0)
	body_parts_covered = HEAD|EARS|HAIR|EYES|NECK
	prevent_crits = list(BCLASS_CUT, BCLASS_CHOP, BCLASS_BLUNT)
	blocksound = PLATEHIT
	max_integrity = 100
	sellprice = 5

/obj/item/clothing/head/helmet/orc/warlord
	name = "Orc Warlord Helmet"
	icon_state = "warlord_helm"
	item_state = "warlord_helm"
	armor = list("blunt" = 70, "slash" = 70, "stab" = 70,  "piercing" = 0, "fire" = 0, "acid" = 0)
	prevent_crits = list(BCLASS_CUT, BCLASS_CHOP, BCLASS_BLUNT, BCLASS_STAB)
	max_integrity = 150
	sellprice = 10

/obj/item/clothing/head/helmet/leather/orc
	slot_flags = ITEM_SLOT_HEAD|ITEM_SLOT_HIP
	name = "leather helmet"
	desc = ""
	body_parts_covered = HEAD|HAIR|EARS|NOSE
	icon_state = "leatherhelm"
	armor = list("blunt" = 27, "slash" = 27, "stab" = 27,  "piercing" = 0, "fire" = 0, "acid" = 0)
	prevent_crits = list(BCLASS_BLUNT, BCLASS_TWIST)
	anvilrepair = null
	sewrepair = /datum/attribute/skill/craft/tanning/patching
	salvage_amount = 1
	salvage_result = /obj/item/natural/hide/cured
	dyeable = TRUE
	blocksound = SOFTHIT

/obj/item/clothing/armor/leather/hide/orc
	name = "orc loincloth"
	icon_state = "orc_leather"
	item_state = "orc_leather"
	icon = 'icons/roguetown/clothing/armor.dmi'
	allowed_race = list(SPEC_ID_ORC)
	armor = list("blunt" = 30, "slash" = 30, "stab" = 30,  "piercing" = 0, "fire" = 0, "acid" = 0)
	body_parts_covered = CHEST|GROIN
	sellprice = 0

///obj/item/clothing/armor/leather/hide/orc


///obj/item/clothing/wrists/bracers/leather/orc dead until i find a way to make them usable
