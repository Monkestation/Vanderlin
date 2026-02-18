/datum/job/advclass/mercenary/expegasusknight
	title = "Ex-Pegasus Knight"
	tutorial = "A former pegasus knight hailing from the southern Elven nation of Lakkari. Once a graceful warrior that ruled the skies, now a traveling sellsword that rules the streets, doing Faience's dirtiest work."
	allowed_races = RACES_PLAYER_ELF
	outfit = /datum/outfit/mercenary/expegasusknight
	category_tags = list(CTAG_MERCENARY)
	total_positions = 0 //Disabled because Lakkari isn't lore-approved

	jobstats = list(
		STATKEY_END = 2,
		STATKEY_STR = 1,
		STATKEY_SPD = 2
	)

	skills = list(
		/datum/skill/combat/knives = 3,
		/datum/skill/misc/athletics = 3,
		/datum/skill/combat/unarmed = 2,
		/datum/skill/combat/wrestling = 2,
		/datum/skill/misc/sneaking = 1,
		/datum/skill/misc/swimming = 2,
		/datum/skill/misc/climbing = 3,
		/datum/skill/misc/medicine = 1,
		/datum/skill/combat/swords = 3,
		/datum/skill/combat/shields = 3,
		/datum/skill/misc/reading = 2,
		/datum/skill/misc/riding = 3
	)

	traits = list(
		TRAIT_MEDIUMARMOR
	)

/datum/job/advclass/mercenary/expegasusknight/after_spawn(mob/living/carbon/human/spawned, client/player_client)
	. = ..()
	spawned.merctype = 11

/datum/outfit/mercenary/expegasusknight
	name = "Ex-Pegasus Knight (Mercenary)"
	shoes = /obj/item/clothing/shoes/ridingboots
	cloak = /obj/item/clothing/cloak/pegasusknight
	head = /obj/item/clothing/head/helmet/pegasusknight
	gloves = /obj/item/clothing/gloves/angle
	wrists = /obj/item/clothing/wrists/bracers/leather
	belt = /obj/item/storage/belt/leather/mercenary/black
	armor = /obj/item/clothing/armor/gambeson
	backl = /obj/item/storage/backpack/satchel
	backr = /obj/item/weapon/shield/tower/buckleriron
	beltr = /obj/item/weapon/sword/long/shotel
	beltl = /obj/item/weapon/knife/dagger/steel/njora
	shirt = /obj/item/clothing/armor/chainmail/iron
	pants = /obj/item/clothing/pants/trou/leather
	backpack_contents = list(/obj/item/storage/belt/pouch/coins/poor = 1)
