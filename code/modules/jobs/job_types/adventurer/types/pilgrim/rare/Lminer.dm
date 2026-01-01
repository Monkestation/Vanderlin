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

	jobstats = list(
		STATKEY_STR = 2,
		STATKEY_INT = 1,
		STATKEY_END = 1,
		STATKEY_CON = 1,
		STATKEY_PER = 1
	)

	skills = list(
		/datum/skill/combat/axesmaces = 2,
		/datum/skill/combat/wrestling = 3,
		/datum/skill/combat/unarmed = 3,
		/datum/skill/craft/crafting = 4,
		/datum/skill/labor/mining = 6,
		/datum/skill/misc/swimming = 3,
		/datum/skill/misc/climbing = 3,
		/datum/skill/craft/masonry = 4,
		/datum/skill/craft/traps = 1,
		/datum/skill/craft/engineering = 4,
		/datum/skill/craft/smelting = 6,
		/datum/skill/misc/reading = 1
	)

/datum/job/advclass/pilgrim/rare/minermaster/after_spawn(mob/living/carbon/human/spawned, client/player_client)
	. = ..()
	spawned.adjust_skillrank(/datum/skill/misc/athletics, pick(3, 3, 4), TRUE)

	if(spawned.age == AGE_OLD)
		spawned.adjust_stat_modifier(STATMOD_JOB, STATKEY_END, -1)
		spawned.adjust_skillrank(/datum/skill/craft/traps, 1, TRUE)
		spawned.adjust_skillrank(/datum/skill/craft/engineering, 1, TRUE)

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