/obj/item/clothing/pants/skirt
	name = "skirt"
	desc = "Long, flowing, and modest."
	icon_state = "skirt"
	item_state = "skirt"
	mob_overlay_icon = 'icons/roguetown/clothing/onmob/pants.dmi'
	sleeved = 'icons/roguetown/clothing/onmob/helpers/sleeves_pants.dmi'
	color = CLOTHING_LINEN

/obj/item/clothing/pants/skirt/colored
	misc_flags = CRAFTING_TEST_EXCLUDE

/obj/item/clothing/pants/skirt/colored/random
	name = "skirt"

/obj/item/clothing/pants/skirt/colored/random/Initialize()
	color = pick(CLOTHING_SALMON, CLOTHING_BERRY_BLUE, CLOTHING_SPRING_GREEN, CLOTHING_PEAR_YELLOW)
	return ..()

/obj/item/clothing/pants/skirt/colored/blue
	color = CLOTHING_BERRY_BLUE

/obj/item/clothing/pants/skirt/colored/green
	color = CLOTHING_SPRING_GREEN

/obj/item/clothing/pants/skirt/colored/red
	color = CLOTHING_RED_OCHRE

/obj/item/clothing/pants/skirt/patkilt
	name = "patterned kilt"
	desc = "A thick padded skirt."
	mob_overlay_icon = 'icons/roguetown/clothing/onmob/pants.dmi'
	icon_state = "patkilt"
	item_state = "patkilt"
	color = CLOTHING_LINEN
	max_integrity = 175
	prevent_crits = list(BCLASS_CUT, BCLASS_BLUNT, BCLASS_TWIST, BCLASS_CHOP)
	armor = list("blunt" = 65, "slash" = 50, "stab" = 25, "piercing" = 25,"fire" = 0, "acid" = 0)

/obj/item/clothing/pants/skirt/patkilt/colored
	misc_flags = CRAFTING_TEST_EXCLUDE

/obj/item/clothing/pants/skirt/patkilt/colored/blue
	color = CLOTHING_BERRY_BLUE

/obj/item/clothing/pants/skirt/patkilt/colored/green
	color = CLOTHING_SPRING_GREEN

/obj/item/clothing/pants/skirt/patkilt/colored/red
	color = CLOTHING_RED_OCHRE

/obj/item/clothing/pants/skirt/patkilt/colored/mageblue
	color = CLOTHING_MAGE_BLUE

/obj/item/clothing/pants/skirt/courtphysician
	name = "sanguine skirt"
	desc = "An elegant velvet skirt that does you no good when running to someones aid."
	icon_state = "docskirt"
	item_state = "docskirt"
	icon = 'icons/roguetown/clothing/courtphys.dmi'
	sleeved = 'icons/roguetown/clothing/onmob/helpers/sleeves_courtphys.dmi'
	mob_overlay_icon = 'icons/roguetown/clothing/onmob/courtphys.dmi'
	detail_tag = "_detail"
	uses_lord_coloring = LORD_PRIMARY
	color = null // Why do skirts have colors by default im going to hurt someone
	alternate_worn_layer = SHIRT_LAYER
