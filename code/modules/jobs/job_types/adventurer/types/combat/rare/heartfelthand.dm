/datum/job/advclass/combat/heartfelthand
	title = "Hand of Heartfelt"
	tutorial = "You serve your lord as hand, taking care of diplomatic actions within your realm, \
	but why have you come to Vanderlin?"
	allowed_sexes = list(MALE)
	allowed_races = list(SPEC_ID_HUMEN)
	outfit = /datum/outfit/adventurer/heartfelthand
	total_positions = 1
	roll_chance = 50

	skills = list(
		/datum/skill/combat/axesmaces = 1,
		/datum/skill/combat/wrestling = 2,
		/datum/skill/combat/knives = 3,
		/datum/skill/combat/swords = 3,
		/datum/skill/combat/unarmed = 3,
		/datum/skill/craft/crafting = 1,
		/datum/skill/misc/reading = 3,
		/datum/skill/misc/swimming = 2,
		/datum/skill/misc/climbing = 2,
		/datum/skill/craft/cooking = 1,
		/datum/skill/labor/mathematics = 3,
	)

	jobstats = list(
		STATKEY_STR = 3,
		STATKEY_PER = 2,
		STATKEY_INT = 3,
	)

	traits = list(
		TRAIT_SEEPRICES,
		TRAIT_HEAVYARMOR,
	)

/datum/outfit/adventurer/heartfelthand
	name = "Hand of Heartfelt (Adventurer)"
	shirt = /obj/item/clothing/shirt/undershirt
	belt = /obj/item/storage/belt/leather/black
	shoes = /obj/item/clothing/shoes/nobleboot
	pants = /obj/item/clothing/pants/tights/colored/black
	armor = /obj/item/clothing/armor/medium/surcoat/heartfelt
	beltr = /obj/item/storage/belt/pouch/coins/rich
	gloves = /obj/item/clothing/gloves/leather/black
	beltl = /obj/item/weapon/sword/decorated
	backr = /obj/item/storage/backpack/satchel/heartfelt
	mask = /obj/item/clothing/face/spectacles/golden
	neck = /obj/item/clothing/neck/chaincoif
	backpack_contents = list(/obj/item/scomstone = 1)