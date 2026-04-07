/obj/item/clothing/shirt/shortshirt
	name = "shirt"
	desc = "A simple shirt."
	icon_state = "shortshirt"
	item_state = "shortshirt"
	r_sleeve_status = SLEEVE_NORMAL
	l_sleeve_status = SLEEVE_NORMAL

/obj/item/clothing/shirt/shortshirt/colored
	misc_flags = CRAFTING_TEST_EXCLUDE

/obj/item/clothing/shirt/shortshirt/colored/random/Initialize()
	color = pick_assoc(GLOB.peasant_dyes)
	return ..()

/obj/item/clothing/shirt/shortshirt/colored/uncolored
	color = CLOTHING_LINEN

/obj/item/clothing/shirt/shortshirt/colored/grey
	color = CLOTHING_ASH_GREY

/obj/item/clothing/shirt/shortshirt/colored/merc
	name = "shirt"
	desc = ""
	icon_state = "shortshirt"
	item_state = "shortshirt"
	r_sleeve_status = SLEEVE_TORN
	l_sleeve_status = SLEEVE_TORN
	body_parts_covered = CHEST|VITALS
	torn_sleeve_number = 2
