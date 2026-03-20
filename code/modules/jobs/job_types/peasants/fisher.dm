/datum/attribute_holder/sheet/job/fisher
	attribute_variance = list(
		/datum/attribute/skill/misc/sewing = list(0, 10),
		/datum/attribute/skill/misc/athletics = list(0, 10),
	)
	raw_attribute_list = list(
		STAT_CONSTITUTION = 2,
		STAT_PERCEPTION = 1,
		/datum/attribute/skill/combat/knives = 20,
		/datum/attribute/skill/misc/swimming = 30,
		/datum/attribute/skill/craft/cooking = 20,
		/datum/attribute/skill/craft/crafting = 20,
		/datum/attribute/skill/misc/sewing = 10,
		/datum/attribute/skill/labor/fishing = 40,
		/datum/attribute/skill/misc/medicine = 10,
		/datum/attribute/skill/misc/athletics = 20,
		/datum/attribute/skill/misc/reading = 10
	)

/datum/attribute_holder/sheet/job/fisher/old
	raw_attribute_list = list(
		STAT_CONSTITUTION = 1,
		STAT_PERCEPTION = 2,
		/datum/attribute/skill/combat/knives = 20,
		/datum/attribute/skill/misc/swimming = 30,
		/datum/attribute/skill/craft/cooking = 20,
		/datum/attribute/skill/craft/crafting = 20,
		/datum/attribute/skill/misc/sewing = 10,
		/datum/attribute/skill/labor/fishing = 50,
		/datum/attribute/skill/misc/medicine = 10,
		/datum/attribute/skill/misc/athletics = 20,
		/datum/attribute/skill/misc/reading = 10
	)

/datum/job/fisher
	title = "Fisher"
	tutorial = "Abyssor is angry. Neglected and shunned, his boons yet shy from your hook. \
	Alone, in the stillness of nature, your bag is empty, and yet you fish. Pluck the children of god from their trance, \
	and stare into the water to see the reflection of a drowned body in the making."
	department_flag = PEASANTS
	job_flags = (JOB_ANNOUNCE_ARRIVAL | JOB_SHOW_IN_CREDITS | JOB_EQUIP_RANK | JOB_NEW_PLAYER_JOINABLE)
	display_order = JDO_FISHER
	faction = FACTION_TOWN
	total_positions = 5
	spawn_positions = 5
	bypass_lastclass = TRUE

	allowed_races = RACES_PLAYER_ALL

	outfit = /datum/outfit/fisher
	give_bank_account = 8
	cmode_music = 'sound/music/cmode/towner/CombatTowner2.ogg'
	can_be_apprentice = TRUE

	job_bitflag = BITFLAG_CONSTRUCTOR
	attribute_sheet = /datum/attribute_holder/sheet/job/fisher
	attribute_sheet_old = /datum/attribute_holder/sheet/job/fisher/old

/datum/outfit/fisher
	name = "Fisher"
	neck = /obj/item/storage/belt/pouch/coins/poor
	armor = /obj/item/clothing/armor/gambeson/light/striped
	head = /obj/item/clothing/head/fisherhat
	belt = /obj/item/storage/belt/leather
	beltr = /obj/item/cooking/pan
	beltl = /obj/item/flint
	backl = /obj/item/storage/backpack/satchel
	backr = /obj/item/fishingrod/fisher

	backpack_contents = list(
		/obj/item/weapon/shovel/small = 1,
		/obj/item/natural/worms = 1
	)

/datum/outfit/fisher/pre_equip(mob/living/carbon/human/equipped_human, visuals_only)
	. = ..()
	if(equipped_human.gender == MALE)
		pants = /obj/item/clothing/pants/tights/colored/random
		shirt = /obj/item/clothing/shirt/shortshirt/colored/random
		shoes = /obj/item/clothing/shoes/boots/leather
		backpack_contents += list(
			/obj/item/weapon/knife/villager = 1,
			/obj/item/recipe_book/survival = 1
		)
	else
		shirt = /obj/item/clothing/shirt/dress/gen/colored/random
		shoes = /obj/item/clothing/shoes/boots/leather
		backpack_contents += list(
			/obj/item/weapon/knife/hunting = 1
		)
