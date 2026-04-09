/datum/attribute_holder/sheet/job/boltslinger
	attribute_variance = list(
		/datum/attribute/skill/combat/crossbows = list(0, 10),
	)
	raw_attribute_list = list(
		STAT_PERCEPTION = 2,
		STAT_ENDURANCE = 1,
		STAT_STRENGTH = 1,
		/datum/attribute/skill/combat/knives = 20,
		/datum/attribute/skill/combat/swords = 30,
		/datum/attribute/skill/combat/polearms = 10,
		/datum/attribute/skill/combat/crossbows = 30,
		/datum/attribute/skill/craft/tanning = 10,
		/datum/attribute/skill/combat/wrestling = 10,
		/datum/attribute/skill/combat/unarmed = 10,
		/datum/attribute/skill/craft/crafting = 10,
		/datum/attribute/skill/misc/swimming = 20,
		/datum/attribute/skill/misc/climbing = 20,
		/datum/attribute/skill/misc/riding = 30,
		/datum/attribute/skill/misc/sewing = 30,
		/datum/attribute/skill/misc/medicine = 20,
		/datum/attribute/skill/craft/cooking = 10,
		/datum/attribute/skill/misc/reading = 10,
		/datum/attribute/skill/misc/athletics = 30
	)

/datum/job/advclass/mercenary/boltslinger
	title = "Boltslinger"
	tutorial = "A cutthroat and a soldier of fortune, your mastery of the crossbow has brought you to many battlefields, all in pursuit of mammon."
	allowed_races = RACES_PLAYER_ALL
	outfit = /datum/outfit/mercenary/boltslinger
	category_tags = list(CTAG_MERCENARY)
	total_positions = 5

	attribute_sheet = /datum/attribute_holder/sheet/job/boltslinger

	traits = list(
		TRAIT_MEDIUMARMOR
	)

/datum/job/advclass/mercenary/boltslinger/after_spawn(mob/living/carbon/human/spawned, client/player_client)
	. = ..()
	spawned.merctype = 6

/datum/outfit/mercenary/boltslinger
	name = "Boltslinger (Mercenary)"
	shoes = /obj/item/clothing/shoes/boots/leather
	cloak = /obj/item/clothing/cloak/half
	head = /obj/item/clothing/head/helmet/sallet
	gloves = /obj/item/clothing/gloves/angle
	belt = /obj/item/storage/belt/leather/mercenary
	armor = /obj/item/clothing/armor/cuirass
	beltr = /obj/item/weapon/sword/iron
	beltl = /obj/item/ammo_holder/quiver/bolts
	backr = /obj/item/gun/ballistic/revolver/grenadelauncher/crossbow
	backl = /obj/item/storage/backpack/satchel
	shirt = /obj/item/clothing/shirt/undershirt/colored/black
	pants = /obj/item/clothing/pants/tights/colored/black
	neck = /obj/item/clothing/neck/chaincoif
	scabbards = list(/obj/item/weapon/scabbard/sword)
	backpack_contents = list(
		/obj/item/storage/belt/pouch/coins/poor = 1,
		/obj/item/weapon/knife/hunting = 1
	)
