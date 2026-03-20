/datum/attribute_holder/sheet/job/pilgrim/minermaster
	attribute_variance = list(
		/datum/attribute/skill/misc/athletics = list(30, 40)
	)
	raw_attribute_list = list(
		STAT_STRENGTH = 2,
		STAT_INTELLIGENCE = 1,
		STAT_ENDURANCE = 1,
		STAT_CONSTITUTION = 1,
		STAT_PERCEPTION = 1,
		/datum/attribute/skill/combat/axesmaces = 20,
		/datum/attribute/skill/combat/wrestling = 20,
		/datum/attribute/skill/combat/unarmed = 20,
		/datum/attribute/skill/craft/crafting = 40,
		/datum/attribute/skill/labor/mining = 60,
		/datum/attribute/skill/misc/swimming = 30,
		/datum/attribute/skill/misc/climbing = 30,
		/datum/attribute/skill/craft/masonry = 40,
		/datum/attribute/skill/craft/traps = 10,
		/datum/attribute/skill/craft/engineering = 40,
		/datum/attribute/skill/craft/smelting = 60,
		/datum/attribute/skill/misc/reading = 10
	)

/datum/attribute_holder/sheet/job/pilgrim/minermaster/old
	attribute_variance = list(
		/datum/attribute/skill/misc/athletics = list(30, 40)
	)
	raw_attribute_list = list(
		STAT_STRENGTH = 2,
		STAT_INTELLIGENCE = 1,
		STAT_CONSTITUTION = 1,
		STAT_PERCEPTION = 1,
		/datum/attribute/skill/combat/axesmaces = 20,
		/datum/attribute/skill/combat/wrestling = 20,
		/datum/attribute/skill/combat/unarmed = 20,
		/datum/attribute/skill/craft/crafting = 40,
		/datum/attribute/skill/labor/mining = 60,
		/datum/attribute/skill/misc/swimming = 30,
		/datum/attribute/skill/misc/climbing = 30,
		/datum/attribute/skill/craft/masonry = 40,
		/datum/attribute/skill/craft/traps = 20,
		/datum/attribute/skill/craft/engineering = 50,
		/datum/attribute/skill/craft/smelting = 60,
		/datum/attribute/skill/misc/reading = 10
	)

/datum/job/advclass/pilgrim/rare/minermaster
	title = "Master Miner"
	tutorial = "Hardy dwarves who dedicated their entire life to a singular purpose: \
	the acquisition of ore, precious stones, and anything deep below the mines."
	allowed_races = list(SPEC_ID_DWARF)
	outfit = /datum/outfit/pilgrim/minermaster
	total_positions = 1
	roll_chance = 0
	category_tags = list(CTAG_PILGRIM, CTAG_TOWNER)
	apprentice_name = "Miner Apprentice"
	cmode_music = 'sound/music/cmode/towner/CombatTowner2.ogg'
	is_recognized = TRUE

	attribute_sheet = /datum/attribute_holder/sheet/job/pilgrim/minermaster
	attribute_sheet_old = /datum/attribute_holder/sheet/job/pilgrim/minermaster/old

/datum/outfit/pilgrim/minermaster
	name = "Master Miner (Pilgrim)"
	head = /obj/item/clothing/head/helmet/leather/minershelm
	pants = /obj/item/clothing/pants/trou
	armor = /obj/item/clothing/armor/gambeson/light/striped
	shirt = /obj/item/clothing/shirt/undershirt/colored/random
	shoes = /obj/item/clothing/shoes/boots/leather
	belt = /obj/item/storage/belt/leather
	neck = /obj/item/storage/belt/pouch/coins/mid
	beltl = /obj/item/weapon/pick
	backl = /obj/item/storage/backpack/backpack
