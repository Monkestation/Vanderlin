/datum/job/advclass/mercenary/housecarl
	title = "Elvish Housecarl"
	tutorial = "Once a mighty guard for your clan leader now freelancer looking to put bread on the table, you have ventured to distance lands for work. Either it be guarding the gold horde of the merchant or the life of the king, you and others like you have been sought out by many to protect their lives and property."
	allowed_races = list(SPEC_ID_ELF, SPEC_ID_HALF_ELF)
	outfit = /datum/outfit/mercenary/housecarl
	category_tags = list(CTAG_MERCENARY)
	total_positions = 4
	cmode_music = 'sound/music/cmode/adventurer/CombatWarrior.ogg'

	jobstats = list(
		STATKEY_STR = 2,
		STATKEY_CON = 2,
		STATKEY_END = 2,
		STATKEY_PER = 1,
		STATKEY_INT = -1,
		STATKEY_SPD = -2,
	)

	skills = list(
		/datum/skill/combat/axesmaces = 4,
		/datum/skill/misc/swimming = 2,
		/datum/skill/misc/climbing = 3,
		/datum/skill/combat/wrestling = 2,
		/datum/skill/combat/unarmed = 3,
		/datum/skill/combat/swords = 2,
		/datum/skill/combat/shields = 3,
		/datum/skill/misc/reading = 1,
		/datum/skill/misc/athletics = 3,
		/datum/skill/misc/medicine = 2,
	)

	traits = list(
		TRAIT_MEDIUMARMOR,
	)

/datum/job/advclass/mercenary/housecarl/after_spawn(mob/living/carbon/human/spawned, client/player_client)
	. = ..()
	spawned.merctype = 9

/datum/outfit/mercenary/housecarl
	name = "Housecarl"
	head = /obj/item/clothing/head/helmet/nasal
	shoes = /obj/item/clothing/shoes/boots
	cloak = /obj/item/clothing/cloak/raincloak/furcloak/colored/brown
	gloves = /obj/item/clothing/gloves/leather/black
	backr = /obj/item/weapon/polearm/halberd/bardiche/woodcutter
	wrists = /obj/item/clothing/wrists/bracers/leather
	shirt = /obj/item/clothing/armor/gambeson
	neck = /obj/item/clothing/neck/highcollier/iron
	armor = /obj/item/clothing/armor/chainmail/hauberk/iron
	belt = /obj/item/storage/belt/leather/mercenary/black
	beltr = /obj/item/storage/belt/pouch/coins/poor
	beltl = /obj/item/weapon/sword/short/iron
	pants = /obj/item/clothing/pants/trou/leather
	backl = /obj/item/weapon/shield/wood
