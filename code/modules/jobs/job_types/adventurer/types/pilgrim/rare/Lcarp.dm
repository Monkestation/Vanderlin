/datum/attribute_holder/sheet/job/pilgrim/mastercarpenter
	raw_attribute_list = list(
		STAT_STRENGTH = 2,
		STAT_ENDURANCE = 2,
		STAT_INTELLIGENCE = 1,
		STAT_CONSTITUTION = 1,
		/datum/attribute/skill/misc/medicine = 10,
		/datum/attribute/skill/combat/axesmaces = 20,
		/datum/attribute/skill/misc/athletics = 40,
		/datum/attribute/skill/combat/wrestling = 20,
		/datum/attribute/skill/combat/unarmed = 30,
		/datum/attribute/skill/combat/knives = 10,
		/datum/attribute/skill/misc/swimming = 30,
		/datum/attribute/skill/misc/climbing = 30,
		/datum/attribute/skill/craft/crafting = 40,
		/datum/attribute/skill/craft/carpentry = 60,
		/datum/attribute/skill/craft/engineering = 10,
		/datum/attribute/skill/misc/reading = 20,
		/datum/attribute/skill/craft/cooking = 10,
		/datum/attribute/skill/misc/sewing = 20,
		/datum/attribute/skill/labor/lumberjacking = 40
	)

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

	attribute_sheet = /datum/attribute_holder/sheet/job/pilgrim/mastercarpenter

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
