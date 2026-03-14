// The Overseer, a bit brighter and knows how to count. There to lead the group and motivate those that require it.
/datum/migrant_role/rousman_cheese/overseer
	name = "Rousman Overseer"
	greet_text = "You are an overseer of a rousman clan. A somewhat more intelligent group of rousmen, lead your fellows to make and sell their cheese products."
	migrant_job = /datum/job/migrant/rousman_cheese/overseer

/datum/job/migrant/rousman_cheese
	allowed_races = RACES_PLAYER_ALL
	spawn_type = /mob/living/carbon/human/species/rousman/random_name


/datum/attribute_holder/sheet/job/rousman/overseer
	raw_attribute_list = list(
		STAT_PERCEPTION = 3,
		STAT_INTELLIGENCE = 3,
		/datum/attribute/skill/combat/knives = 20,
		/datum/attribute/skill/combat/whipsflails = 20,
		/datum/attribute/skill/combat/wrestling = 20,
		/datum/attribute/skill/combat/unarmed = 20,
		/datum/attribute/skill/misc/climbing = 30,
		/datum/attribute/skill/misc/athletics = 30,
		/datum/attribute/skill/craft/cooking = 30,
		/datum/attribute/skill/craft/crafting = 30,
		/datum/attribute/skill/misc/reading = 30,
		/datum/attribute/skill/labor/mathematics = 20,
	)

/datum/job/migrant/rousman_cheese/overseer
	title = "Rousman Overseer"
	tutorial = "You are an overseer of a rousman clan. A somewhat more intelligent group of rousmen, lead your fellows to make and sell their cheese products."
	outfit = /datum/outfit/rousman_cheese/overseer
	attribute_sheet = /datum/attribute_holder/sheet/job/rousman/overseer

	languages = list(/datum/language/common)
	honorary = "Overseer"

/datum/job/migrant/rousman_cheese/overseer/after_spawn(mob/living/carbon/human/spawned, client/player_client)
	. = ..()
	var/turf/target_turf = get_turf(spawned)
	var/obj/structure/handcart/cart = new(target_turf)
	var/obj/item/reagent_containers/glass/bucket/pot/copper/pot = new(target_turf)
	var/obj/item/tent_kit/tent = new(target_turf)

	cart.put_in(null, pot, TRUE)
	cart.put_in(null, tent, TRUE)

/datum/outfit/rousman_cheese/overseer
	name = "Rousman Overseer (Migrant Wave)"
	ring = /obj/item/clothing/ring/amber
	armor = /obj/item/clothing/armor/leather/hide/rousman
	cloak = /obj/item/clothing/cloak/poncho/yellow
	r_hand = /obj/item/weapon/knife/dagger/bronze
	wrists = /obj/item/weapon/scabbard/knife
	belt = /obj/item/storage/belt/leather/black
	beltr = /obj/item/weapon/whip
	beltl = /obj/item/storage/belt/pouch/coins/mid
	backl = /obj/item/storage/backpack/satchel/cloth/big
	backpack_contents = list(
		/obj/item/reagent_containers/glass/bottle/black/cheese_soup,
		/obj/item/reagent_containers/glass/bottle/black/cheese_soup
	)

// The cheesemaker, the one that makes the cheese.
/datum/migrant_role/rousman_cheese/cheesemaker
	name = "Rousman Cheesemaker"
	greet_text = "You are a cheesemaker of a rousman clan, listen to your overseer as you work to sell your wares to the locals."
	migrant_job = /datum/job/migrant/rousman_cheese/cheesemaker

/datum/attribute_holder/sheet/job/rousman/cheesemaker
	raw_attribute_list = list(
		STAT_PERCEPTION = 2,
		STAT_INTELLIGENCE = 2,
		/datum/attribute/skill/combat/knives = 20,
		/datum/attribute/skill/combat/wrestling = 20,
		/datum/attribute/skill/combat/unarmed = 20,
		/datum/attribute/skill/misc/climbing = 30,
		/datum/attribute/skill/misc/athletics = 30,
		/datum/attribute/skill/craft/cooking = 30,
		/datum/attribute/skill/craft/crafting = 20,
		/datum/attribute/skill/misc/reading = 10,
	)

/datum/job/migrant/rousman_cheese/cheesemaker
	title = "Rousman Cheesemaker"
	tutorial = "You are a cheesemaker of a rousman clan, listen to your overseer as you work to sell your wares to the locals."
	outfit = /datum/outfit/rousman_cheese/cheesemaker

	attribute_sheet = /datum/attribute_holder/sheet/job/rousman/cheesemaker

	languages = list(/datum/language/common)

/datum/outfit/rousman_cheese/cheesemaker
	name = "Rousman Cheesemaker (Migrant Wave)"
	armor = /obj/item/clothing/armor/leather/hide/rousman
	r_hand = /obj/item/reagent_containers/glass/bucket/pot/copper
	belt = /obj/item/storage/belt/leather/black
	beltr = /obj/item/weapon/knife/dagger/bronze
	beltl = /obj/item/storage/belt/pouch/coins/poor
	backl = /obj/item/storage/backpack/satchel/cloth/big
	backpack_contents = list(
		/obj/item/reagent_containers/food/snacks/cheddar,
		/obj/item/reagent_containers/food/snacks/cheddar/aged,
		/obj/item/reagent_containers/glass/bottle/black/cheese_soup
	)

// Cheesemonger, the seller and aficionado
/datum/migrant_role/rousman_cheese/cheesemonger
	name = "Rousman Cheesemonger"
	greet_text = "You are a cheesemonger of a rousman clan, listen to your overseer as you work to sell your wares to the locals."
	migrant_job = /datum/job/migrant/rousman_cheese/cheesemonger

/datum/attribute_holder/sheet/job/rousman/cheesemonger
	raw_attribute_list = list(
		STAT_PERCEPTION = 2,
		STAT_INTELLIGENCE = 2,
		/datum/attribute/skill/combat/knives = 20,
		/datum/attribute/skill/combat/wrestling = 20,
		/datum/attribute/skill/combat/unarmed = 20,
		/datum/attribute/skill/misc/climbing = 30,
		/datum/attribute/skill/misc/athletics = 30,
		/datum/attribute/skill/craft/cooking = 20,
		/datum/attribute/skill/craft/crafting = 30,
		/datum/attribute/skill/misc/reading = 10,
	)

/datum/job/migrant/rousman_cheese/cheesemonger
	title = "Rousman Cheesemonger"
	tutorial = "You are a cheesemonger of a rousman clan, listen to your overseer as you work to sell your wares to the locals."
	outfit = /datum/outfit/rousman_cheese/cheesemonger

	attribute_sheet = /datum/attribute_holder/sheet/job/rousman/cheesemonger

	languages = list(/datum/language/common)

/datum/outfit/rousman_cheese/cheesemonger
	name = "Rousman Cheesemonger (Migrant Wave)"
	armor = /obj/item/clothing/armor/leather/hide/rousman
	belt = /obj/item/storage/belt/leather/black
	beltr = /obj/item/weapon/knife/dagger/bronze
	beltl = /obj/item/storage/belt/pouch/coins/poor
	backl = /obj/item/storage/backpack/satchel/cloth/big
	backpack_contents = list(
		/obj/item/reagent_containers/food/snacks/cheesebun,
		/obj/item/reagent_containers/food/snacks/cheesebun,
		/obj/item/reagent_containers/food/snacks/cheesebun,
		/obj/item/reagent_containers/food/snacks/cheesebun,
		/obj/item/reagent_containers/food/snacks/cheesecake_cooked,
		/obj/item/reagent_containers/food/snacks/cheesecake_cooked,
		/obj/item/reagent_containers/glass/bottle/black/cheese_soup
	)


// The wave

/datum/migrant_wave/rousman_cheese
	name = "Rousman Cheese Convoy"
	max_spawns = 4
	shared_wave_type = /datum/migrant_wave/rousman_cheese
	downgrade_wave = /datum/migrant_wave/rousman_cheese_down
	can_roll = FALSE // Admin activated only
	weight = 0
	triumph_threshold = 50
	roles = list(
		/datum/migrant_role/rousman_cheese/overseer = 1,
		/datum/migrant_role/rousman_cheese/cheesemaker = 2,
		/datum/migrant_role/rousman_cheese/cheesemonger = 2
	)
	greet_text = "A somewhat more intelligent group of rousmen, those who truly appreciate the value of cheese products and wish to spread them to all."

/datum/migrant_wave/rousman_cheese_down
	name = "Rousman Expedition"
	max_spawns = 4
	shared_wave_type = /datum/migrant_wave/rousman_cheese
	downgrade_wave = /datum/migrant_wave/rousman_cheese_down_one
	can_roll = FALSE
	roles = list(
		/datum/migrant_role/rousman_cheese/overseer = 1,
		/datum/migrant_role/rousman_cheese/cheesemaker = 1,
		/datum/migrant_role/rousman_cheese/cheesemonger = 1
	)
	greet_text = "A somewhat more intelligent group of rousmen, those who truly appreciate the value of cheese products and wish to spread them to all."

/datum/migrant_wave/rousman_cheese_down_one
	name = "Rousman Expedition"
	max_spawns = 4
	shared_wave_type = /datum/migrant_wave/rousman_cheese
	can_roll = FALSE
	roles = list(
		/datum/migrant_role/rousman_cheese/overseer = 1,
	)
	greet_text = "A somewhat more intelligent group of rousmen, those who truly appreciate the value of cheese products and wish to spread them to all."


