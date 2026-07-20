/obj/item/clothing/armor/cuirass/iron/goblin
	name = "goblin mail"
	icon_state = "plate_armor_item"
	item_state = "plate_armor"
	icon = 'icons/roguetown/mob/monster/goblins.dmi'
	smeltresult = /obj/item/ingot/iron
	armor = list("blunt" = 80, "slash" = 80, "stab" = 80,  "piercing" = 0, "fire" = 0, "acid" = 0)
	allowed_race = list(SPEC_ID_GOBLIN)
	body_parts_covered = CHEST|GROIN|ARMS|LEGS|VITALS
	anvilrepair = /datum/attribute/skill/craft/armor_repair
	max_integrity = 60
	armor_class = AC_LIGHT // Otherwise they get knocked down TOO easily!!!
	sellprice = 0

/obj/item/clothing/armor/leather/goblin
	name = "goblin leather armor"
	icon_state = "leather_armor_item"
	item_state = "leather_armor"
	icon = 'icons/roguetown/mob/monster/goblins.dmi'
	armor = list("blunt" = 60, "slash" = 60, "stab" = 60,  "piercing" = 0, "fire" = 0, "acid" = 0)
	body_parts_covered = CHEST|GROIN|ARMS|VITALS
	armor_class = AC_LIGHT
	max_integrity = 60
	allowed_race = list(SPEC_ID_GOBLIN)
	sellprice = 0
	smeltresult = /obj/item/fertilizer/ash

/obj/item/clothing/armor/leather/hide/goblin
	name = "goblin loincloth"
	icon_state = "cloth_armor"
	item_state = "cloth_armor"
	icon = 'icons/roguetown/mob/monster/goblins.dmi'
	allowed_race = list(SPEC_ID_GOBLIN)
	armor = list("blunt" = 30, "slash" = 30, "stab" = 30,  "piercing" = 0, "fire" = 0, "acid" = 0)
	body_parts_covered = CHEST|GROIN
	sellprice = 0
	smeltresult = /obj/item/fertilizer/ash

/obj/item/clothing/head/helmet/leather/goblin
	name = "goblin leather helmet"
	icon_state = "leather_helm_item"
	item_state = "leather_helm"
	icon = 'icons/roguetown/mob/monster/goblins.dmi'
	armor = list("blunt" = 30, "slash" = 30, "stab" = 30,  "piercing" = 0, "fire" = 0, "acid" = 0)
	body_parts_covered = HEAD|EARS|HAIR|EYES
	allowed_race = list(SPEC_ID_GOBLIN)
	sellprice = 0
	smeltresult = /obj/item/fertilizer/ash

/obj/item/clothing/head/helmet/goblin
	name = "goblin helmet"
	icon_state = "plate_helm_item"
	item_state = "plate_helm"
	smeltresult = /obj/item/ingot/iron
	icon = 'icons/roguetown/mob/monster/goblins.dmi'
	allowed_race = list(SPEC_ID_GOBLIN)
	armor = list("blunt" = 80, "slash" = 80, "stab" = 80,  "piercing" = 0, "fire" = 0, "acid" = 0)
	body_parts_covered = HEAD|EARS|HAIR|EYES
	sellprice = 0
