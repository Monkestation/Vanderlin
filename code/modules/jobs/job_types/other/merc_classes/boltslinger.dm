/datum/job/advclass/mercenary/boltslinger
	title = "Boltslinger"
	tutorial = "A cutthroat and a soldier of fortune, your mastery of the crossbow has brought you to many battlefields, all in pursuit of mammon."
	allowed_races = RACES_PLAYER_ALL
	outfit = /datum/outfit/mercenary/boltslinger
	category_tags = list(CTAG_MERCENARY)
	total_positions = 5

	jobstats = list(
		STATKEY_PER = 2,
		STATKEY_END = 1,
		STATKEY_STR = 1
	)

	skills = list(
		/datum/skill/combat/knives = 2,
		/datum/skill/combat/swords = 3,
		/datum/skill/combat/polearms = 1,
		/datum/skill/combat/crossbows = 4,
		/datum/skill/craft/tanning = 1,
		/datum/skill/combat/unarmed = 1,
		/datum/skill/craft/crafting = 1,
		/datum/skill/misc/swimming = 2,
		/datum/skill/misc/climbing = 2,
		/datum/skill/misc/riding = 3,
		/datum/skill/misc/sewing = 3,
		/datum/skill/misc/medicine = 2,
		/datum/skill/craft/cooking = 1,
		/datum/skill/misc/reading = 1,
		/datum/skill/misc/athletics = 3
	)

	traits = list(
		TRAIT_MEDIUMARMOR
	)

/datum/job/advclass/mercenary/boltslinger/after_spawn(mob/living/carbon/human/spawned, client/player_client)
	. = ..()
	spawned.merctype = 6
	spawned.adjust_skillrank(/datum/skill/combat/shields, pick(0,0,1))

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