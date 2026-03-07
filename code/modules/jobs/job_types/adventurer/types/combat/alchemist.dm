/datum/job/advclass/combat/alchemist
	title = "Alchemist"
	tutorial = "No longer working for a clinic or laboratory, these former apothecaries \
				have taken to finding work and riches on the open road. \
				Armed with knowledge of alchemical formulae, alchemists utilize potions, \
				poisons, and explosives alike."
	allowed_races = RACES_PLAYER_ALL
	outfit = /datum/outfit/combat/alchemist
	category_tags = list(CTAG_ADVENTURER)
	cmode_music = 'sound/music/cmode/nobility/combat_physician.ogg'

	jobstats = list(
    	STATKEY_PER = 1,
		STATKEY_INT = 1,
		STATKEY_SPD = 1
	)

	skills = list(
  		/datum/skill/combat/knives = 3,
    	/datum/skill/combat/bows = 2,
		/datum/skill/combat/wrestling = 1,
		/datum/skill/combat/unarmed = 1,
    	/datum/skill/labor/butchering = 1,
		/datum/skill/craft/alchemy = 3,
		/datum/skill/craft/bombs = 3,
		/datum/skill/craft/engineering = 2,
  		/datum/skill/craft/crafting = 2,
  		/datum/skill/craft/sewing = 1,
		/datum/skill/misc/reading = 2,
		/datum/skill/misc/medicine = 2,
		/datum/skill/misc/swimming = 1,
		/datum/skill/misc/climbing = 1,
		/datum/skill/misc/athletics = 1
	)

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
	backr = /obj/item/gun/ballistic/revolver/grenadelauncher/bow/short
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
