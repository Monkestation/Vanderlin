/datum/attribute_holder/sheet/job/heartfelthand
	raw_attribute_list = list(
		STAT_STRENGTH = 3,
		STAT_PERCEPTION = 2,
		STAT_INTELLIGENCE = 3,
		/datum/attribute/skill/combat/axesmaces = 10,
		/datum/attribute/skill/combat/wrestling = 20,
		/datum/attribute/skill/combat/knives = 30,
		/datum/attribute/skill/combat/swords = 30,
		/datum/attribute/skill/combat/unarmed = 30,
		/datum/attribute/skill/craft/crafting = 10,
		/datum/attribute/skill/misc/reading = 30,
		/datum/attribute/skill/misc/swimming = 20,
		/datum/attribute/skill/misc/climbing = 20,
		/datum/attribute/skill/craft/cooking = 10,
		/datum/attribute/skill/labor/mathematics = 30,
	)

/datum/job/advclass/combat/heartfelthand
	title = "Hand of Heartfelt"
	tutorial = "You served your lord as hand, taking care of diplomatic actions within your realm, \
	yet your kingdom lies in ruins ever since it's mechanical servants rose up. \
	You have since fled to the kingdom of Vanderlin, \
	the exact reason of your stay here are up to you."
	allowed_sexes = list(MALE)
	allowed_races = list(SPEC_ID_HUMEN)
	outfit = /datum/outfit/adventurer/heartfelthand
	total_positions = 1
	roll_chance = 50

	attribute_sheet = /datum/attribute_holder/sheet/job/heartfelthand

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
	backr = /obj/item/storage/backpack/satchel
	mask = /obj/item/clothing/face/spectacles/golden
	neck = /obj/item/clothing/neck/chaincoif
	backpack_contents = list(/obj/item/scomstone = 1)
