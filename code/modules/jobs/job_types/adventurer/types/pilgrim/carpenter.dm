/datum/attribute_holder/sheet/job/pilgrim/carpenter
	attribute_variance = list(
		/datum/attribute/skill/misc/athletics = list(30, 40)
	)
	raw_attribute_list = list(
		STAT_STRENGTH = 1,
		STAT_ENDURANCE = 1,
		STAT_INTELLIGENCE = 1,
		STAT_CONSTITUTION = 1,
		STAT_SPEED = -1,
		/datum/attribute/skill/misc/medicine = 10,
		/datum/attribute/skill/combat/axesmaces = 20,
		/datum/attribute/skill/combat/wrestling = 10,
		/datum/attribute/skill/combat/unarmed = 10,
		/datum/attribute/skill/craft/crafting = 30,
		/datum/attribute/skill/craft/cooking = 10,
		/datum/attribute/skill/craft/carpentry = 50,
		/datum/attribute/skill/misc/swimming = 10,
		/datum/attribute/skill/misc/climbing = 20,
		/datum/attribute/skill/misc/sewing = 10,
		/datum/attribute/skill/misc/reading = 10,
		/datum/attribute/skill/labor/lumberjacking = 30,
	)

/datum/job/advclass/carpenter
	title = JOB_CARPENTER
	tutorial = "As a woodsmen or women, you have dedicated your life to both felling \
	trees and bending wood to your will. With enough practice, your only limit is your imagination."
	allowed_sexes = list(MALE, FEMALE)
	outfit = /datum/outfit/adventurer/carpenter
	category_tags = list(CTAG_PILGRIM)
	apprentice_name = "Carpenter Apprentice"
	cmode_music = 'sound/music/cmode/towner/CombatBeggar.ogg'

	attribute_sheet = /datum/attribute_holder/sheet/job/pilgrim/carpenter

/datum/outfit/adventurer/carpenter
	name = JOB_CARPENTER
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
