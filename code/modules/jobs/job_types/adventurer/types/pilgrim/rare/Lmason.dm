/datum/job/advclass/pilgrim/rare/grandmastermason
	title = "Grandmaster Mason"
	tutorial = "A Grandmaster mason, you built castles and entire cities with your own hands. \
	There is nothing in this world that you can't build, your creed and hardwork has revealed all the secrets of the stone."
	allowed_races = list(SPEC_ID_DWARF)
	outfit = /datum/outfit/pilgrim/grandmastermason
	category_tags = list(CTAG_PILGRIM, CTAG_TOWNER)
	total_positions = 1
	roll_chance = 0
	apprentice_name = "Mason Apprentice"
	cmode_music = 'sound/music/cmode/towner/CombatTowner2.ogg'
	is_recognized = TRUE

	jobstats = list(
		STATKEY_STR = 1,
		STATKEY_INT = 2,
		STATKEY_END = 2,
		STATKEY_CON = 2
	)

	skills = list(
		/datum/skill/combat/axesmaces = 2,
		/datum/skill/labor/mining = 3,
		/datum/skill/combat/wrestling = 2,
		/datum/skill/combat/unarmed = 2,
		/datum/skill/craft/crafting = 5,
		/datum/skill/craft/carpentry = 4,
		/datum/skill/craft/masonry = 6,
		/datum/skill/craft/engineering = 5,
		/datum/skill/misc/lockpicking = 3,
		/datum/skill/craft/smelting = 6,
		/datum/skill/misc/swimming = 3,
		/datum/skill/misc/climbing = 4,
		/datum/skill/misc/athletics = 4,
		/datum/skill/misc/reading = 1
	)

/datum/outfit/pilgrim/grandmastermason
	name = "Grandmaster Mason (Pilgrim)"
	head = /obj/item/clothing/head/hatblu
	armor = /obj/item/clothing/armor/leather/vest
	cloak = /obj/item/clothing/cloak/apron/waist/colored/bar
	pants = /obj/item/clothing/pants/trou
	shirt = /obj/item/clothing/shirt/undershirt/colored/random
	shoes = /obj/item/clothing/shoes/boots/leather
	belt = /obj/item/storage/belt/leather
	beltr = /obj/item/storage/belt/pouch/coins/mid
	beltl = /obj/item/weapon/pick
	backr = /obj/item/weapon/axe/steel
	backl = /obj/item/storage/backpack/backpack
	backpack_contents = list(
		/obj/item/weapon/hammer/steel = 1,
		/obj/item/weapon/chisel = 1
	)

/datum/outfit/pilgrim/grandmastermason/pre_equip(mob/living/carbon/human/equipped_human, visuals_only)
	. = ..()
	if(equipped_human.dna.species.id == SPEC_ID_DWARF)
		head = /obj/item/clothing/head/helmet/leather/minershelm
