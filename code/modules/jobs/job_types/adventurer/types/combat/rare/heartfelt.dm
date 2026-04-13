/datum/attribute_holder/sheet/job/heartfeltlord
	raw_attribute_list = list(
		STAT_STRENGTH = 1,
		STAT_INTELLIGENCE = 3,
		STAT_ENDURANCE = 3,
		STAT_SPEED = 1,
		STAT_PERCEPTION = 2,
		STAT_FORTUNE = 5,
		/datum/attribute/skill/combat/axesmaces = 20,
		/datum/attribute/skill/combat/crossbows = 30,
		/datum/attribute/skill/combat/wrestling = 20,
		/datum/attribute/skill/combat/unarmed = 10,
		/datum/attribute/skill/combat/swords = 40,
		/datum/attribute/skill/combat/knives = 30,
		/datum/attribute/skill/misc/swimming = 10,
		/datum/attribute/skill/misc/climbing = 10,
		/datum/attribute/skill/misc/athletics = 30,
		/datum/attribute/skill/misc/reading = 40,
		/datum/attribute/skill/misc/riding = 30,
		/datum/attribute/skill/craft/cooking = 10,
	)

/datum/job/advclass/combat/heartfeltlord
	title = "Lord of Heartfelt"
	tutorial = "You are the lord of Heartfelt, \
	your kingdom lies in ruins ever since it's mechanical servants rose up. \
	You have since fled to the kingdom of Vanderlin, \
	the exact reason of your stay here are up to you."
	allowed_sexes = list(MALE, FEMALE)
	allowed_races = list(SPEC_ID_HUMEN)
	outfit = /datum/outfit/adventurer/heartfeltlord
	total_positions = 1
	roll_chance = 50
	cmode_music = 'sound/music/cmode/adventurer/CombatDream.ogg'

	attribute_sheet = /datum/attribute_holder/sheet/job/heartfeltlord

	traits = list(
		TRAIT_NOBLE_BLOOD,
		TRAIT_NOBLE_POWER,
		TRAIT_HEAVYARMOR,
	)

/datum/outfit/adventurer/heartfeltlord
	name = "Lord of Heartfelt (Adventurer)"

	shirt = /obj/item/clothing/shirt/undershirt
	belt = /obj/item/storage/belt/leather/black
	head = /obj/item/clothing/head/helmet
	shoes = /obj/item/clothing/shoes/nobleboot
	pants = /obj/item/clothing/pants/tights/colored/black
	cloak = /obj/item/clothing/cloak/heartfelt
	armor = /obj/item/clothing/armor/medium/surcoat/heartfelt
	beltr = /obj/item/storage/belt/pouch/coins/rich
	beltl = /obj/item/weapon/sword/long
	gloves = /obj/item/clothing/gloves/leather/black
	neck = /obj/item/clothing/neck/chaincoif
	backpack_contents = list(/obj/item/scomstone = 1)



