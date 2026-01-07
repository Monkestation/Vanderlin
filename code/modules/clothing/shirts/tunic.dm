/obj/item/clothing/shirt/tunic
	slot_flags = ITEM_SLOT_ARMOR|ITEM_SLOT_SHIRT
	name = "tunic"
	desc = ""
	body_parts_covered = CHEST|GROIN|VITALS
	boobed = FALSE
	icon_state = "tunic"
	color = CLOTHING_LINEN
	sleevetype = "tunic"
	r_sleeve_status = SLEEVE_NORMAL
	l_sleeve_status = SLEEVE_NORMAL

/obj/item/clothing/shirt/tunic/noblecoat
	name = "fancy coat"
	desc = "A fancy tunic and coat combo. How elegant."
	icon_state = "noblecoat"
	sleevetype = "noblecoat"
	color = CLOTHING_WHITE
	boobed = TRUE
	sellprice = VALUE_FINE_CLOTHING + M_CLOTH*2 + SKILL_3

/obj/item/clothing/shirt/tunic/colored
	misc_flags = CRAFTING_TEST_EXCLUDE

/obj/item/clothing/shirt/tunic/colored/green
	color = CLOTHING_FOREST_GREEN

/obj/item/clothing/shirt/tunic/colored/blue
	color = CLOTHING_SKY_BLUE

/obj/item/clothing/shirt/tunic/colored/red
	color = CLOTHING_BLOOD_RED

/obj/item/clothing/shirt/tunic/colored/purple
	color = CLOTHING_PLUM_PURPLE

/obj/item/clothing/shirt/tunic/colored/black
	color = CLOTHING_SOOT_BLACK

/obj/item/clothing/shirt/tunic/colored/ucolored
	color = CLOTHING_ASH_GREY

/obj/item/clothing/shirt/tunic/colored/random/Initialize()
	color = pick(CLOTHING_PLUM_PURPLE, CLOTHING_BLOOD_RED, CLOTHING_SKY_BLUE, CLOTHING_FOREST_GREEN)
	return ..()

/obj/item/clothing/shirt/tunic/colored/tunicprimary
	color = CLOTHING_BLOOD_RED
	uses_lord_coloring = LORD_PRIMARY
