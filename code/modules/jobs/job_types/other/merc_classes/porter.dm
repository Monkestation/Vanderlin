/datum/attribute_holder/sheet/job/porter
	raw_attribute_list = list(
		STAT_CONSTITUTION = 1,
		STAT_ENDURANCE = 3,
		STAT_INTELLIGENCE = 4, //Unique specimen, They learned many things, it basically nullify and give a bonus of +2 to their INT.
		STAT_SPEED = 2, //Gee, Why do this kobold get more stats than everyone else? the answer is because they have to at the very least escape from being killed and looted.
		STAT_PERCEPTION = -2, //-4 PER with a chance of it being a -5 hit hard
		/datum/attribute/skill/combat/wrestling = 30, //To get out of grasps slippery bastard
		/datum/attribute/skill/combat/unarmed = 10,
		/datum/attribute/skill/misc/athletics = 30,
		/datum/attribute/skill/misc/climbing = 30,
		/datum/attribute/skill/misc/swimming = 20,
		/datum/attribute/skill/misc/reading = 20,
		/datum/attribute/skill/labor/mathematics = 20,
		//Can't expect those kobolds to not be thieves or assist with such things.
		/datum/attribute/skill/misc/stealing = 20,
		/datum/attribute/skill/misc/lockpicking = 20,
		//Jack of All Trade, Master of None.
		/datum/attribute/skill/misc/sewing = 30,
		/datum/attribute/skill/misc/medicine = 30,
		/datum/attribute/skill/labor/fishing = 30,
		/datum/attribute/skill/labor/butchering = 30,
		/datum/attribute/skill/craft/cooking = 30,
		/datum/attribute/skill/craft/tanning = 30,
		/datum/attribute/skill/craft/crafting = 30,
		/datum/attribute/skill/craft/engineering = 30,
		/datum/attribute/skill/craft/carpentry = 30,
		/datum/attribute/skill/craft/masonry = 30,
		/datum/attribute/skill/craft/traps = 30,
		/datum/attribute/skill/craft/weaponsmithing = 10,
		/datum/attribute/skill/craft/armorsmithing = 10,
	)

/datum/job/advclass/mercenary/porter
	title = "Porter"
	tutorial = "You are a jack-of-all-trades from the dank depth of subterra, You've survived by being useful. Whether it's carrying someone's burdens, mending their gears, stitching wounds, or even cooking a surprisingly edible meal, For a price, of course."
	allowed_races = list(SPEC_ID_KOBOLD, SPEC_ID_HALFLING)
	blacklisted_species = null
	outfit = /datum/outfit/mercenary/porter
	category_tags = list(CTAG_MERCENARY)
	total_positions = 2
	cmode_music = 'sound/music/cmode/Combat_Weird.ogg'

	attribute_sheet = /datum/attribute_holder/sheet/job/porter

	traits = list(
		TRAIT_AMAZING_BACK,
		TRAIT_FORAGER,
		TRAIT_MIRACULOUS_FORAGING,
		TRAIT_SEEDKNOW,
		TRAIT_SEEPRICES,
		TRAIT_DODGEEXPERT,
	)

/datum/job/advclass/mercenary/porter/after_spawn(mob/living/carbon/human/spawned, client/player_client)
	. = ..()
	spawned.merctype = 9

/datum/outfit/mercenary/porter
	name = "Porter (Mercenary)"
	head = /obj/item/clothing/head/articap/porter
	armor = /obj/item/clothing/armor/leather/jacket/artijacket/porter
	pants = /obj/item/clothing/pants/trou
	shirt = /obj/item/clothing/shirt/undershirt/colored/black
	shoes = /obj/item/clothing/shoes/boots/leather
	belt = /obj/item/storage/belt/leather
	beltr = /obj/item/storage/messkit
	beltl = /obj/item/weapon/knife/cleaver
	mask = /obj/item/clothing/face/goggles
	backr = /obj/item/fishingrod/fisher
	backl = /obj/item/storage/backpack/backpack/artibackpack/porter //+1 to Row/Columns compared to a regular backpack alongside preserving foods.
	backpack_contents = list(/obj/item/kitchen/rollingpin = 1, /obj/item/storage/belt/pouch/coins/poor, /obj/item/weapon/knife/hunting, /obj/item/weapon/hammer/iron = 1, /obj/item/weapon/shovel/small = 1, /obj/item/recipe_book/survival = 1, /obj/item/recipe_book/cooking = 1, /obj/item/storage/keyring/mercenary, /obj/item/reagent_containers/glass/bucket/pot = 1)
