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

	allowed_races = RACES_PLAYER_ALL

	outfit = /datum/outfit/fisher
	give_bank_account = 8
	cmode_music = 'sound/music/cmode/towner/CombatTowner2.ogg'

	job_bitflag = BITFLAG_CONSTRUCTOR

	jobstats = list(
		STATKEY_CON = 2,
		STATKEY_PER = 1
	)

	skills = list(
		/datum/skill/combat/knives = 2,
		/datum/skill/misc/swimming = 3,
		/datum/skill/craft/cooking = 2,
		/datum/skill/craft/crafting = 2,
		/datum/skill/misc/sewing = 1,
		/datum/skill/labor/fishing = 4,
		/datum/skill/misc/medicine = 1,
		/datum/skill/misc/athletics = 2,
		/datum/skill/misc/reading = 1
	)

/datum/job/fisher/after_spawn(mob/living/carbon/human/spawned, client/player_client)
	. = ..()
	if(spawned.age == AGE_OLD)
		spawned.adjust_skillrank(/datum/skill/labor/fishing, 1, TRUE)
		spawned.adjust_stat_modifier(STATMOD_JOB, STATKEY_CON, -1)
		spawned.adjust_stat_modifier(STATMOD_JOB, STATKEY_PER, 1)

	spawned.adjust_skillrank(/datum/skill/misc/sewing, pick(0,1), TRUE)
	spawned.adjust_skillrank(/datum/skill/misc/athletics, pick(0,1), TRUE)

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
