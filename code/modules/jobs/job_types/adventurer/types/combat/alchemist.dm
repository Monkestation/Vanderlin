/datum/attribute_holder/sheet/job/alchemist_adventurer
	raw_attribute_list = list(
		STAT_PERCEPTION = 1,
		STAT_INTELLIGENCE = 1,
		STAT_SPEED = 1,
		/datum/attribute/skill/combat/knives = 30,
		/datum/attribute/skill/combat/bows = 20,
		/datum/attribute/skill/combat/wrestling = 10,
		/datum/attribute/skill/combat/unarmed = 10,
		/datum/attribute/skill/labor/butchering = 10,
		/datum/attribute/skill/craft/alchemy = 30,
		/datum/attribute/skill/craft/bombs = 30,
		/datum/attribute/skill/craft/engineering = 20,
		/datum/attribute/skill/craft/crafting = 20,
		/datum/attribute/skill/misc/reading = 20,
		/datum/attribute/skill/misc/medicine = 20,
		/datum/attribute/skill/misc/sewing = 10,
		/datum/attribute/skill/misc/swimming = 10,
		/datum/attribute/skill/misc/climbing = 10,
		/datum/attribute/skill/misc/athletics = 10,
	)

/datum/job/advclass/combat/alchemist
	title = JOB_ALCHEMIST
	tutorial = "No longer working for a clinic or laboratory, these former apothecaries \
				have taken to finding work and riches on the open road. \
				Armed with knowledge of alchemical formulae, alchemists utilize potions, \
				poisons, and explosives alike."
	allowed_races = RACES_PLAYER_ALL
	outfit = /datum/outfit/combat/alchemist
	attribute_sheet = /datum/attribute_holder/sheet/job/alchemist_adventurer
	category_tags = list(CTAG_ADVENTURER)
	cmode_music = 'sound/music/cmode/nobility/combat_physician.ogg'

	traits = list(
    	TRAIT_FORAGER,
		TRAIT_DEADNOSE
	)

/datum/outfit/combat/alchemist
	name = "Alchemist (Adventurer)"
	armor = /obj/item/clothing/armor/gambeson/apothecary
	shoes = /obj/item/clothing/shoes/apothboots
	shirt = /obj/item/clothing/shirt/apothshirt
	pants = /obj/item/clothing/pants/trou/apothecary
	gloves = /obj/item/clothing/gloves/leather/apothecary
	backr = /obj/item/gun/ballistic/bow/short
	backl = /obj/item/storage/backpack/backpack
	belt = /obj/item/storage/belt/leather
	beltl = /obj/item/weapon/knife/hunting
	beltr = /obj/item/ammo_holder/quiver/arrows
	scabbards = list(/obj/item/weapon/scabbard/knife)
	backpack_contents = list(
		/obj/item/pestle,
		/obj/item/reagent_containers/glass/alchemical = 6, //for vial arrows
		/obj/item/reagent_containers/glass/bottle = 2, //for smokebombs
		/obj/item/reagent_containers/glass/mortar,
		/obj/item/flint
	)
