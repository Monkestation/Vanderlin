/datum/attribute_holder/sheet/job/pilgrim/fisher
	attribute_variance = list(
		/datum/attribute/skill/misc/sewing = list(10, 20),
		/datum/attribute/skill/misc/athletics = list(20, 30)
	)
	raw_attribute_list = list(
		STAT_CONSTITUTION = 2,
		/datum/attribute/skill/combat/knives = 20,
		/datum/attribute/skill/misc/swimming = 30,
		/datum/attribute/skill/craft/cooking = 20,
		/datum/attribute/skill/craft/crafting = 20,
		/datum/attribute/skill/labor/fishing = 40,
		/datum/attribute/skill/misc/medicine = 10,
		/datum/attribute/skill/misc/reading = 10,
		/datum/attribute/skill/misc/climbing = 10,
	)

/datum/attribute_holder/sheet/job/pilgrim/fisher/old
	attribute_variance = list(
		/datum/attribute/skill/misc/sewing = list(10, 20),
		/datum/attribute/skill/misc/athletics = list(20, 30)
	)
	raw_attribute_list = list(
		STAT_CONSTITUTION = 1,
		STAT_PERCEPTION = 1,
		/datum/attribute/skill/combat/knives = 20,
		/datum/attribute/skill/misc/swimming = 30,
		/datum/attribute/skill/craft/cooking = 20,
		/datum/attribute/skill/craft/crafting = 20,
		/datum/attribute/skill/labor/fishing = 50,
		/datum/attribute/skill/misc/medicine = 10,
		/datum/attribute/skill/misc/reading = 10,
		/datum/attribute/skill/misc/climbing = 10,
	)

/datum/job/advclass/pilgrim/fisher
	title = "Fisher"
	tutorial = "Simple folk with an affinity for catching fish out of any body of water, \
				they are decent cooks and swimmers, living off the gifts of Abyssor."
	allowed_sexes = list(MALE, FEMALE)
	outfit = /datum/outfit/pilgrim/fisher
	category_tags = list(CTAG_PILGRIM)
	apprentice_name = "Fisher Apprentice"
	cmode_music = 'sound/music/cmode/towner/CombatBeggar.ogg'

	attribute_sheet = /datum/attribute_holder/sheet/job/pilgrim/fisher
	attribute_sheet_old = /datum/attribute_holder/sheet/job/pilgrim/fisher/old

/datum/outfit/pilgrim/fisher
	name = "Fisher (Pilgrim)"
	neck = /obj/item/storage/belt/pouch/coins/poor
	head = /obj/item/clothing/head/fisherhat
	backl = /obj/item/storage/backpack/satchel
	backr = /obj/item/fishingrod/fisher
	belt = /obj/item/storage/belt/leather
	beltr = /obj/item/cooking/pan
	beltl = /obj/item/flint

/datum/outfit/pilgrim/fisher/pre_equip(mob/living/carbon/human/equipped_human, visuals_only)
	. = ..()
	if(equipped_human.gender == MALE)
		pants = /obj/item/clothing/pants/tights/colored/random
		shirt = pick(/obj/item/clothing/shirt/undershirt/colored/random, /obj/item/clothing/shirt/shortshirt/colored/random)
		shoes = pick(/obj/item/clothing/shoes/simpleshoes, /obj/item/clothing/shoes/boots/leather)
		armor = /obj/item/clothing/armor/gambeson/light/striped
		backpack_contents = list(
			/obj/item/weapon/knife/villager = 1,
			/obj/item/natural/worms = 1,
			/obj/item/weapon/shovel/small = 1,
			/obj/item/reagent_containers/food/snacks/saltfish = 1
		)
	else
		shirt = /obj/item/clothing/shirt/dress/gen/colored/random
		armor = /obj/item/clothing/armor/gambeson/light/striped
		shoes = /obj/item/clothing/shoes/boots/leather
		backpack_contents = list(
			/obj/item/weapon/knife/hunting = 1,
			/obj/item/natural/worms = 1,
			/obj/item/weapon/shovel/small = 1
		)
