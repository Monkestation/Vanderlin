/obj/structure/closet/crate/chest
	name = "chest"
	desc = ""
	icon = 'icons/roguetown/misc/structure.dmi'
	icon_state = "chestweird2"
	base_icon_state = "chestweird2"
	drag_slowdown = 2
	open_sound = 'sound/misc/chestopen.ogg'
	close_sound = 'sound/misc/chestclose.ogg'
	sellprice = 1 // crate recycling program
	max_integrity = 200
	blade_dulling = DULLING_BASHCHOP
	mob_storage_capacity = 1
	allow_dense = FALSE
	static_price = TRUE

/obj/structure/closet/crate/chest/open(mob/living/user)
	. = ..()
	var/obj/structure/pressure_plate/AM = locate(/obj/structure/pressure_plate) in loc
	if(AM)
		AM.triggerplate()

/obj/structure/closet/crate/chest/gold
	icon_state = "chestweird1"
	base_icon_state = "chestweird1"

/obj/structure/closet/crate/chest/merchant
	lock = /datum/lock/key/merchant

/obj/structure/closet/crate/chest/lootbox/populate_contents()
	var/list/loot = list(
		/obj/item/storage/fancy/cigarettes/zig/empty=40,
		/obj/item/reagent_containers/powder/spice=20,
		/obj/item/explosive/bottle=6,
		/obj/item/weapon/knife/dagger=33,
		/obj/item/reagent_containers/food/snacks/produce/fyritius=10,
		/obj/item/clothing/armor/gambeson=33,
		/obj/item/clothing/armor/leather=33,
		/obj/item/statue/gold/loot=1,
		/obj/item/ingot/iron=22,
		/obj/item/bottlemessage/ancient=22,
		/obj/item/weapon/knife/cleaver=22,
		/obj/item/weapon/mace=22,
		/obj/item/clothing/cloak/raincloak/colored/mortus=22,
		/obj/item/reagent_containers/food/snacks/butter=22,
		/obj/item/clothing/face/cigarette/pipe=10,
		/obj/item/clothing/face/cigarette/pipe/westman=10,
		/obj/item/storage/fancy/cigarettes/zig=33,
		/obj/item/storage/backpack/satchel=33,
		/obj/item/storage/sack=33,
		/obj/item/gem=1,
		/obj/item/gem/blue=2,
		/obj/item/gem/violet=4,
		/obj/item/gem/green=6,
		/obj/item/gem/yellow=10,
		/obj/item/clothing/ring/gold=10,
		/obj/item/coin/silver/pile=4,
		/obj/item/weapon/pick=23,
		/obj/item/book/granter/spell_points=5,
		/obj/item/riddleofsteel=2,
		/obj/item/clothing/neck/talkstone=2
		)
	var/I = pickweight(loot)
	new I(src)

// When players exit the round via boat, their items get transported here
/obj/structure/closet/crate/chest/lostandfound
	desc = "An incredibly sturdy chest; the Guild can afford the best materials after all."
	anchored = 1
	max_integrity = 2000

/obj/structure/closet/crate/chest/wicker
	name = "wicker basket"
	desc = "Fibers interwoven to make a cheap storage bin."
	base_icon_state = "wicker"
	icon_state = "wicker"
	open_sound = 'sound/items/book_open.ogg'
	open_sound = 'sound/items/book_close.ogg'
	close_sound = 'sound/items/book_close.ogg'
	sellprice = 0

/obj/structure/closet/crate/chest/wicker/random_soilson/populate_contents()
	for(var/i = 1 to rand(5, 8))
		var/obj/item/neuFarm/seed/random = pick(subtypesof(/obj/item/neuFarm/seed) - /obj/item/neuFarm/seed/mixed_seed)
		new random (src)

/obj/structure/closet/crate/chest/wicker/random_mushroom/populate_contents()
	for(var/i = 1 to rand(5,8))
		var/obj/item/neuFarm/seed/spore/random = pick(subtypesof(/obj/item/neuFarm/seed/spore))
		new random (get_turf(src))
	. = ..()

/obj/structure/closet/crate/chest/neu
	name = "sturdy oak chest"
	icon_state = "chest_neu"
	base_icon_state = "chest_neu"

/obj/structure/closet/crate/chest/neu_iron
	name = "reinforced chest"
	icon_state = "chestiron_neu"
	base_icon_state = "chestiron_neu"

/obj/structure/closet/crate/chest/neu_fancy
	name = "fancy chest"
	icon_state = "chestfancy_neu"
	base_icon_state = "chestfancy_neu"

/obj/structure/closet/crate/chest/old_crate
	name = "old crate"
	base_icon_state = "woodchestalt"
	icon_state = "woodchestalt"

/obj/structure/closet/crate/chest/crate
	name = "crate"
	base_icon_state = "woodchest"
	icon_state = "woodchest"

/obj/structure/closet/crate/chest/crafted
	name = "handcrafted chest"
	icon_state = "chest_neu"
	base_icon_state = "chest_neu"
	sellprice = 6

/obj/structure/closet/crate/crafted_closet/crafted
	sellprice = 6

//a chest with a corpse in it
/obj/structure/closet/crate/chest/neu_iron/corpse/populate_contents()
	var/mob/living/carbon/human/H = new /mob/living/carbon/human/species/rousman(src)
	H.cure_husk()
	H.update_body()
	H.update_body_parts()
	H.death(TRUE)
