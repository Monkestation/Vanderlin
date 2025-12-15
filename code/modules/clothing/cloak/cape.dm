
/obj/item/clothing/cloak/cape
	name = "cape"
	desc = ""
	color = null
	icon_state = "cape"
	item_state = "cape"
	alternate_worn_layer = CLOAK_BEHIND_LAYER
	boobed = TRUE
	sleeved = 'icons/roguetown/clothing/onmob/cloaks.dmi'
	sleevetype = "shirt"
	nodismemsleeves = TRUE
	inhand_mod = FALSE
	slot_flags = ITEM_SLOT_BACK_R | ITEM_SLOT_CLOAK

/obj/item/clothing/cloak/cape/colored
	misc_flags = CRAFTING_TEST_EXCLUDE

/obj/item/clothing/cloak/cape/colored/knight
	color = CLOTHING_PLUM_PURPLE

/obj/item/clothing/cloak/cape/guard
	name = "guard's cape"
	color = CLOTHING_BLOOD_RED
	uses_lord_coloring = LORD_PRIMARY

/obj/item/clothing/cloak/captain
	name = "captain's cape"
	desc = "A cape with a gold-embroidered heraldry of Vanderlin."
	icon = 'icons/roguetown/clothing/special/captain.dmi'
	mob_overlay_icon = 'icons/roguetown/clothing/special/onmob/captain.dmi'
	sleeved = 'icons/roguetown/clothing/special/onmob/captain.dmi'
	sleevetype = "shirt"
	icon_state = "capcloak"
	detail_tag = "_detail"
	alternate_worn_layer = CLOAK_BEHIND_LAYER
	detail_color = CLOTHING_BERRY_BLUE
	uses_lord_coloring = LORD_PRIMARY

/obj/item/clothing/cloak/cape/archivist
	icon_state = "puritan_cape"
	color = CLOTHING_SOOT_BLACK
	allowed_race = SPECIES_BASE_BODY
