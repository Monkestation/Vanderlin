/datum/attribute_holder/sheet/job/pilgrim/grandmastermason
	raw_attribute_list = list(
		STAT_STRENGTH = 1,
		STAT_INTELLIGENCE = 2,
		STAT_ENDURANCE = 2,
		STAT_CONSTITUTION = 2,
		/datum/attribute/skill/combat/axesmaces = 20,
		/datum/attribute/skill/labor/mining = 30,
		/datum/attribute/skill/combat/wrestling = 20,
		/datum/attribute/skill/combat/unarmed = 20,
		/datum/attribute/skill/craft/crafting = 50,
		/datum/attribute/skill/craft/carpentry = 40,
		/datum/attribute/skill/craft/masonry = 60,
		/datum/attribute/skill/craft/engineering = 50,
		/datum/attribute/skill/misc/lockpicking = 30,
		/datum/attribute/skill/craft/smelting = 60,
		/datum/attribute/skill/misc/swimming = 30,
		/datum/attribute/skill/misc/climbing = 40,
		/datum/attribute/skill/misc/athletics = 40,
		/datum/attribute/skill/misc/reading = 10
	)

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

	attribute_sheet = /datum/attribute_holder/sheet/job/pilgrim/grandmastermason

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
