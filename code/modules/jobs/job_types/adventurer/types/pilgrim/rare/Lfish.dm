/datum/attribute_holder/sheet/job/pilgrim/fishermaster
	raw_attribute_list = list(
		STAT_CONSTITUTION = 2,
		STAT_PERCEPTION = 2,
		/datum/attribute/skill/combat/wrestling = 10,
		/datum/attribute/skill/combat/unarmed = 10,
		/datum/attribute/skill/combat/knives = 20,
		/datum/attribute/skill/misc/swimming = 50,
		/datum/attribute/skill/craft/cooking = 30,
		/datum/attribute/skill/craft/crafting = 20,
		/datum/attribute/skill/labor/fishing = 50,
		/datum/attribute/skill/misc/medicine = 10,
		/datum/attribute/skill/misc/athletics = 30,
		/datum/attribute/skill/misc/reading = 10
	)

/datum/attribute_holder/sheet/job/pilgrim/fishermaster/old
	raw_attribute_list = list(
		STAT_CONSTITUTION = 2,
		STAT_PERCEPTION = 2,
		/datum/attribute/skill/combat/wrestling = 10,
		/datum/attribute/skill/combat/unarmed = 10,
		/datum/attribute/skill/combat/knives = 20,
		/datum/attribute/skill/misc/swimming = 50,
		/datum/attribute/skill/craft/cooking = 30,
		/datum/attribute/skill/craft/crafting = 20,
		/datum/attribute/skill/labor/fishing = 60,
		/datum/attribute/skill/misc/medicine = 10,
		/datum/attribute/skill/misc/athletics = 30,
		/datum/attribute/skill/misc/reading = 10,
		/datum/attribute/skill/combat/polearms = 10
	)

/datum/job/advclass/pilgrim/rare/fishermaster
	title = "Master Fisher"
	tutorial = "Seafarers who have mastered the tides, and are able to catch any fish with ease \
	no matter the body of water. They have learned to thrive off the gifts of Abyssor, not simply survive."
	allowed_sexes = list(MALE, FEMALE)
	outfit = /datum/outfit/pilgrim/fishermaster
	total_positions = 1
	roll_chance = 0
	category_tags = list(CTAG_PILGRIM, CTAG_TOWNER)
	apprentice_name = "Fisher Apprentice"
	cmode_music = 'sound/music/cmode/towner/CombatTowner.ogg'
	is_recognized = TRUE

	attribute_sheet = /datum/attribute_holder/sheet/job/pilgrim/fishermaster
	attribute_sheet_old = /datum/attribute_holder/sheet/job/pilgrim/fishermaster/old

/datum/outfit/pilgrim/fishermaster
	name = "Master Fisher (Pilgrim)"
	neck = /obj/item/storage/belt/pouch/coins/mid
	head = /obj/item/clothing/head/fisherhat
	backr = /obj/item/storage/backpack/satchel
	armor = /obj/item/clothing/armor/leather/jacket/sea
	belt = /obj/item/storage/belt/leather
	beltl = /obj/item/weapon/knife/hunting
	backpack_contents = list(
		/obj/item/natural/worms = 2,
		/obj/item/weapon/shovel/small = 1
	)

/datum/outfit/pilgrim/fishermaster/pre_equip(mob/living/carbon/human/equipped_human, visuals_only)
	. = ..()
	if(equipped_human.gender == MALE)
		pants = /obj/item/clothing/pants/trou
		shirt = /obj/item/clothing/shirt/shortshirt/colored/random
		shoes = /obj/item/clothing/shoes/boots/leather
		backl = /obj/item/fishingrod/fisher
		beltr = /obj/item/cooking/pan
	else
		pants = /obj/item/clothing/pants/trou
		shoes = /obj/item/clothing/shoes/boots/leather
		shirt = /obj/item/clothing/shirt/shortshirt/colored/random
		beltr = /obj/item/fishingrod/fisher
