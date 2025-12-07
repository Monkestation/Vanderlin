//dwarf, master miner

/datum/job/advclass/pilgrim/rare/minermaster
	title = "Master Miner"
	tutorial = "Hardy dwarves who dedicated their entire life to a singular purpose: \
	the acquisition of ore, precious stones, and anything deep below the mines."
	allowed_races = list(SPEC_ID_DWARF)
	outfit = /datum/outfit/adventurer/minermaster
	total_positions = 1
	roll_chance = 0
	category_tags = list(CTAG_PILGRIM, CTAG_TOWNER)
	apprentice_name = "Miner Apprentice"
	cmode_music = 'sound/music/cmode/towner/CombatTowner2.ogg'
	is_recognized = TRUE

/datum/outfit/adventurer/minermaster/pre_equip(mob/living/carbon/human/H)
	..()
	head = /obj/item/clothing/head/helmet/leather/minershelm
	pants = /obj/item/clothing/pants/trou
	armor = /obj/item/clothing/armor/gambeson/light/striped
	shirt = /obj/item/clothing/shirt/undershirt/colored/random
	shoes = /obj/item/clothing/shoes/boots/leather
	belt = /obj/item/storage/belt/leather
	neck = /obj/item/storage/belt/pouch/coins/mid
	beltl = /obj/item/weapon/pick
	backl = /obj/item/storage/backpack/backpack
	if(H.age == AGE_OLD)
		H.change_stat(STATKEY_END, -1)
		H.adjust_skillrank(/datum/skill/craft/traps, 1, TRUE)
		H.adjust_skillrank(/datum/skill/craft/engineering, 1, TRUE)
	if(H.mind)
		H.adjust_skillrank(/datum/skill/combat/axesmaces, 2, TRUE)
		H.adjust_skillrank(/datum/skill/combat/wrestling, 3, TRUE)
		H.adjust_skillrank(/datum/skill/combat/unarmed, 3, TRUE)
		H.adjust_skillrank(/datum/skill/craft/crafting, 4, TRUE)
		H.adjust_skillrank(/datum/skill/labor/mining, 6, TRUE)
		H.adjust_skillrank(/datum/skill/misc/swimming, 3, TRUE)
		H.adjust_skillrank(/datum/skill/misc/climbing, 3, TRUE)
		H.adjust_skillrank(/datum/skill/misc/athletics, pick(3,3,4), TRUE)
		H.adjust_skillrank(/datum/skill/craft/masonry, 4, TRUE)
		H.adjust_skillrank(/datum/skill/craft/traps, 1, TRUE)
		H.adjust_skillrank(/datum/skill/craft/engineering, 4, TRUE)
		H.adjust_skillrank(/datum/skill/craft/smelting, 6, TRUE)
		H.adjust_skillrank(/datum/skill/misc/reading, 1, TRUE)
		H.change_stat(STATKEY_STR, 2)
		H.change_stat(STATKEY_INT, 1)
		H.change_stat(STATKEY_END, 1)
		H.change_stat(STATKEY_CON, 1)
		H.change_stat(STATKEY_PER, 1)
