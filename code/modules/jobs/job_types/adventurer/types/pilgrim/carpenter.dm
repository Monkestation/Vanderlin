/datum/job/advclass/carpenter
	title = "Carpenter"
	tutorial = "As a woodsmen or women, you have dedicated your life to both felling \
	trees and bending wood to your will. With enough practice, your only limit is your imagination."
	allowed_sexes = list(MALE, FEMALE)
	outfit = /datum/outfit/adventurer/carpenter
	category_tags = list(CTAG_PILGRIM)
	apprentice_name = "Carpenter Apprentice"
	cmode_music = 'sound/music/cmode/towner/CombatBeggar.ogg'

	jobstats = list(
		STATKEY_STR = 1,
		STATKEY_END = 1,
		STATKEY_INT = 1,
		STATKEY_CON = 1,
		STATKEY_SPD = -1
	)

	skills = list(
		/datum/skill/misc/medicine = 1,
		/datum/skill/combat/axesmaces = 2,
		/datum/skill/combat/wrestling = 2,
		/datum/skill/combat/unarmed = 2,
		/datum/skill/craft/crafting = 3,
		/datum/skill/craft/cooking = 1,
		/datum/skill/craft/carpentry = 5,
		/datum/skill/misc/swimming = 1,
		/datum/skill/misc/climbing = 2,
		/datum/skill/misc/sewing = 1,
		/datum/skill/misc/reading = 1,
		/datum/skill/labor/lumberjacking = 3
	)

/datum/job/advclass/carpenter/after_spawn(mob/living/carbon/human/spawned, client/player_client)
	. = ..()
	spawned.adjust_skillrank(/datum/skill/misc/athletics, pick(3, 3, 4), TRUE)

/datum/outfit/adventurer/carpenter
	name = "Carpenter"
	neck = /obj/item/clothing/neck/coif
	armor = /obj/item/clothing/armor/gambeson/light/striped
	pants = /obj/item/clothing/pants/trou
	wrists = /obj/item/clothing/wrists/bracers/leather
	shoes = /obj/item/clothing/shoes/boots/leather
	belt = /obj/item/storage/belt/leather
	beltr = /obj/item/storage/belt/pouch/coins/poor
	beltl = /obj/item/weapon/hammer/steel
	backr = /obj/item/weapon/axe/iron
	backl = /obj/item/storage/backpack/backpack
	backpack_contents = list(
		/obj/item/flint = 1,
		/obj/item/weapon/knife/villager = 1
	)

/datum/outfit/adventurer/pilgrim/pre_equip(mob/living/carbon/human/equipped_human, visuals_only)
	. = ..()
	head = pick(/obj/item/clothing/head/hatfur, /obj/item/clothing/head/hatblu, /obj/item/clothing/head/brimmed)
	shirt = pick(/obj/item/clothing/shirt/undershirt/colored/random, /obj/item/clothing/shirt/tunic/colored/random)
