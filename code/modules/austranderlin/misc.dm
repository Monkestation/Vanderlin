
/// spongebob - please for the love of fuck do not use this for any actual mapping purposes
/obj/item/painting/the_bob
	icon_state = "spongebob"
	desc = "The servant of the month for the past 30 consecutive months. It is a priceless work of art."
	sellprice = 808 //BOB
	deployed_structure = /obj/structure/fluff/walldeco/painting/the_bob

/obj/structure/fluff/walldeco/painting/the_bob
	desc = "The servant of the month for the past 30 consecutive months. It is a priceless work of art."
	icon_state = "spongebob_deployed"
	stolen_painting = /obj/item/painting/the_bob

///random placed items
/obj/item/clothing/shirt/robe/colored/sundweller
	color = CLOTHING_MUSTARD_YELLOW

/obj/item/clothing/head/roguehood/colored/sundweller
	color = CLOTHING_MUSTARD_YELLOW

/obj/item/clothing/cloak/heartfelt/shit
	name = "shitstained cloak"
	desc = "You are the lord of this shithouse."
	misc_flags = CRAFTING_TEST_EXCLUDE

/obj/item/clothing/head/priesthat/sunlord
	name = "piss-soaked hat"
	desc = "The sacred headpiece of the Sunlord."

/obj/item/carvedgem/amber/duck/sunduck
	name = "sunduck"
	sellprice = 0
	desc = "Quack! Quack!"


/obj/structure/kybraxor/smol
	pixel_x = -32
	pixel_y = -32
	vol = 20

/obj/structure/kybraxor/smol/Initialize()
	. = ..()
	transform = transform.Scale(1 / 3)
