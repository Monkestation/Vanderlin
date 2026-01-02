/datum/job/advclass/pilgrim/rare/mastercarpenter
	title = "Master Carpenter"
	tutorial = "A true artisan in the field of woodcrafting, your skills honed by years in a formal guild. \
	As a master carpenter, you transform trees into anything from furniture to entire fortifications."
	allowed_sexes = list(MALE, FEMALE)
	outfit = /datum/outfit/pilgrim/mastercarpenter
	category_tags = list(CTAG_PILGRIM, CTAG_TOWNER)
	total_positions = 1
	roll_chance = 0
	apprentice_name = "Carpenter Apprentice"
	cmode_music = 'sound/music/cmode/towner/CombatTowner2.ogg'
	is_recognized = TRUE

	jobstats = list(
		STATKEY_STR = 2,
		STATKEY_END = 2,
		STATKEY_INT = 1,
		STATKEY_CON = 1
	)

	skills = list(
		/datum/skill/misc/medicine = 1,
		/datum/skill/combat/axesmaces = 2,
		/datum/skill/misc/athletics = 4,
		/datum/skill/combat/wrestling = 3,
		/datum/skill/combat/unarmed = 3,
		/datum/skill/combat/knives = 1,
		/datum/skill/misc/swimming = 3,
		/datum/skill/misc/climbing = 3,
		/datum/skill/craft/crafting = 4,
		/datum/skill/craft/carpentry = 6,
		/datum/skill/craft/engineering = 1,
		/datum/skill/misc/reading = 2,
		/datum/skill/craft/cooking = 1,
		/datum/skill/misc/sewing = 2,
		/datum/skill/labor/lumberjacking = 4
	)

/datum/outfit/pilgrim/mastercarpenter
	name = "Master Carpenter (Pilgrim)"
	neck = /obj/item/clothing/neck/coif
	armor = /obj/item/clothing/armor/leather/jacket
	pants = /obj/item/clothing/pants/trou
	shirt = /obj/item/clothing/shirt/undershirt/colored/random
	wrists = /obj/item/clothing/wrists/bracers/leather
	shoes = /obj/item/clothing/shoes/boots/leather
	belt = /obj/item/storage/belt/leather
	beltr = /obj/item/storage/belt/pouch/coins/mid
	beltl = /obj/item/weapon/hammer/steel
	backl = /obj/item/storage/backpack/backpack
	backr = /obj/item/weapon/polearm/halberd/bardiche/woodcutter
	backpack_contents = list(
		/obj/item/flint = 1,
		/obj/item/weapon/knife/hunting = 1
	)

/datum/outfit/pilgrim/mastercarpenter/pre_equip(mob/living/carbon/human/equipped_human, visuals_only)
	. = ..()
	head = pick(/obj/item/clothing/head/hatfur, /obj/item/clothing/head/hatblu, /obj/item/clothing/head/brimmed)
