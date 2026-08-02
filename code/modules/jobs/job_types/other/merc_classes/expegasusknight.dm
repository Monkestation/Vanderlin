/datum/attribute_holder/sheet/job/expegasusknight
	raw_attribute_list = list(
		STAT_ENDURANCE = 2,
		STAT_STRENGTH = 1,
		STAT_SPEED = 2,
		/datum/attribute/skill/combat/knives = 30,
		/datum/attribute/skill/misc/athletics = 30,
		/datum/attribute/skill/combat/unarmed = 20,
		/datum/attribute/skill/combat/wrestling = 20,
		/datum/attribute/skill/misc/sneaking = 10,
		/datum/attribute/skill/misc/swimming = 20,
		/datum/attribute/skill/misc/climbing = 30,
		/datum/attribute/skill/misc/medicine = 10,
		/datum/attribute/skill/combat/swords = 30,
		/datum/attribute/skill/combat/shields = 30,
		/datum/attribute/skill/misc/reading = 20,
		/datum/attribute/skill/misc/riding = 30
	)

/datum/job/advclass/mercenary/expegasusknight
	title = "Ex-Pegasus Knight"
	tutorial = "A former pegasus knight hailing from the southern Elven nation of Lakkari. Once a graceful warrior that ruled the skies, now a traveling sellsword that rules the streets, doing Faience's dirtiest work."
	allowed_races = RACES_PLAYER_ELF
	outfit = /datum/outfit/mercenary/expegasusknight
	category_tags = list(CTAG_MERCENARY)
	total_positions = 0 //Disabled because Lakkari isn't lore-approved

	attribute_sheet = /datum/attribute_holder/sheet/job/expegasusknight

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
