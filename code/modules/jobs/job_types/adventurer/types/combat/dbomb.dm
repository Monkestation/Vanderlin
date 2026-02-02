/datum/job/advclass/combat/dbomb
	title = "Dwarven Bombardier"
	tutorial = "Tinkering Dwarves that like to blow things up."
	allowed_races = list(SPEC_ID_DWARF)
	outfit = /datum/outfit/adventurer/dbomb
	category_tags = list(CTAG_ADVENTURER)

	jobstats = list(
		STATKEY_STR = 1,
		STATKEY_END = 1,
	)

	skills = list(
		/datum/skill/combat/axesmaces = 2,
		/datum/skill/labor/mining = 1,
		/datum/skill/craft/engineering = 5,
		/datum/skill/craft/bombs = 4,
		/datum/skill/craft/smelting = 1,
		/datum/skill/combat/unarmed = 2,
		/datum/skill/combat/wrestling = 2,
		/datum/skill/craft/crafting = 3,
		/datum/skill/misc/swimming = 1,
		/datum/skill/misc/climbing = 1,
		/datum/skill/misc/athletics = 1,
		/datum/skill/misc/reading = 2,
	)

	traits = list(
		TRAIT_MEDIUMARMOR,
	)

/datum/outfit/adventurer/dbomb
	name = "Dwarven Bombardier (Adventurer)"
	head = /obj/item/clothing/head/helmet/horned
	pants = /obj/item/clothing/pants/trou
	belt = /obj/item/storage/belt/leather
	armor = /obj/item/clothing/armor/chainmail/iron
	wrists = /obj/item/clothing/wrists/bracers/leather
	backl = /obj/item/storage/backpack/backpack
	beltl = /obj/item/weapon/pick
	beltr = /obj/item/weapon/hammer/iron
	backpack_contents = list(/obj/item/explosive/bottle = 1, /obj/item/flint = 1)

/datum/outfit/adventurer/dbomb/pre_equip(mob/living/carbon/human/equipped_human, visuals_only)
	. = ..()
	switch(pick(1,2))
		if(1)
			shoes = /obj/item/clothing/shoes/boots/leather
		if(2)
			shoes = /obj/item/clothing/shoes/simpleshoes