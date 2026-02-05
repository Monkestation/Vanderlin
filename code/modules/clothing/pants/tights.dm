/obj/item/clothing/pants/tights
	name = "tights"
	desc = "Comfortable loose pants."
	gender = PLURAL
	icon_state = "tights"
	item_state = "tights"
	color = CLOTHING_LINEN

/obj/item/clothing/pants/tights/colored
	misc_flags = CRAFTING_TEST_EXCLUDE

/obj/item/clothing/pants/tights/colored/random/Initialize()
	color = pick_assoc(GLOB.peasant_dyes)
	return ..()

/obj/item/clothing/pants/tights/colored/uncolored
	color = CLOTHING_LINEN

/obj/item/clothing/pants/tights/colored/black
	color = CLOTHING_SOOT_BLACK

/obj/item/clothing/pants/tights/colored/white
	color = CLOTHING_CHALK_WHITE

/obj/item/clothing/pants/tights/colored/red
	color = CLOTHING_BLOOD_RED

/obj/item/clothing/pants/tights/colored/purple
	color = CLOTHING_PLUM_PURPLE

/obj/item/clothing/pants/tights/colored/green
	color = CLOTHING_FOREST_GREEN

/obj/item/clothing/pants/tights/colored/jester
	name = "funny tights"
	color = CLOTHING_SALMON

/obj/item/clothing/pants/tights/colored/lord
	color = CLOTHING_PLUM_PURPLE

/obj/item/clothing/pants/tights/colored/vagrant
	r_sleeve_status = SLEEVE_TORN
	body_parts_covered = GROIN|LEG_LEFT
	torn_sleeve_number = 1

/obj/item/clothing/pants/tights/colored/vagrant/Initialize()
	color = pick(CLOTHING_MUD_BROWN, CLOTHING_OLD_LEATHER, CLOTHING_SPRING_GREEN, CLOTHING_BARK_BROWN, CLOTHING_CANVAS	)
	if(prob(50))
		r_sleeve_status = SLEEVE_NORMAL
		l_sleeve_status = SLEEVE_TORN
		body_parts_covered = GROIN|LEG_RIGHT
	return ..()

/obj/item/clothing/pants/tights/colored/guard
	color = CLOTHING_PLUM_PURPLE
	uses_lord_coloring = LORD_PRIMARY

/obj/item/clothing/pants/tights/colored/guardsecond
	color = CLOTHING_BLOOD_RED
	uses_lord_coloring = LORD_SECONDARY

/obj/item/clothing/pants/tights/sailor
	name = "pants"
	icon_state = "sailorpants"
