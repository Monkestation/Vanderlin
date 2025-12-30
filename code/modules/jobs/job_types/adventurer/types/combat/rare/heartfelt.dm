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
	skills = list(
		/datum/skill/combat/axesmaces = 2,
		/datum/skill/combat/crossbows = 3,
		/datum/skill/combat/wrestling = 3,
		/datum/skill/combat/unarmed = 1,
		/datum/skill/combat/swords = 4,
		/datum/skill/combat/knives = 3,
		/datum/skill/misc/swimming = 1,
		/datum/skill/misc/climbing = 1,
		/datum/skill/misc/athletics = 4,
		/datum/skill/misc/reading = 4,
		/datum/skill/misc/riding = 3,
		/datum/skill/craft/cooking = 1,
	)

	jobstats = list(
		STATKEY_STR = 1,
		STATKEY_INT = 3,
		STATKEY_END = 3,
		STATKEY_SPD = 1,
		STATKEY_PER = 2,
		STATKEY_LCK = 5,
	)

	traits = list(
		TRAIT_NOBLE,
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



