/datum/job/carpenter
	title = "Carpenter"
	tutorial = "Others may regard your work as crude and demeaning, but you understand deep in your soul the beauty of woodchopping. \
	For it is by your axe that the great trees of forests are felled, and it is by your hands from which the shining beacon of civilization is built."
	department_flag = PEASANTS
	job_flags = (JOB_ANNOUNCE_ARRIVAL | JOB_SHOW_IN_CREDITS | JOB_EQUIP_RANK | JOB_NEW_PLAYER_JOINABLE)
	display_order = JDO_CARPENTER
	faction = FACTION_TOWN
	total_positions = 6
	spawn_positions = 4
	bypass_lastclass = TRUE

	allowed_races = RACES_PLAYER_ALL
	outfit = /datum/outfit/carpenter
	give_bank_account = 8
	cmode_music = 'sound/music/cmode/towner/CombatTowner.ogg'

	job_bitflag = BITFLAG_CONSTRUCTOR

	jobstats = list(
		STATKEY_STR = 1,
		STATKEY_END = 1,
		STATKEY_INT = 1,
		STATKEY_CON = 1,
		STATKEY_SPD = -1,
	)

	skills = list(
		/datum/skill/misc/medicine = 1,
		/datum/skill/combat/axesmaces = 2,
		/datum/skill/combat/wrestling = 2,
		/datum/skill/combat/unarmed = 2,
		/datum/skill/craft/crafting = 3,
		/datum/skill/craft/cooking = 1,
		/datum/skill/craft/carpentry = 5,
		/datum/skill/misc/swimming = 1,
		/datum/skill/misc/climbing = 2,
		/datum/skill/misc/sewing = 1,
		/datum/skill/misc/reading = 1,
		/datum/skill/misc/athletics = 3,
		/datum/skill/labor/lumberjacking = 3,
	)

	traits = list()

/datum/job/carpenter/after_spawn(mob/living/carbon/human/spawned, client/player_client)
	. = ..()
	spawned.adjust_skillrank(/datum/skill/misc/athletics, pick(0,1), TRUE)

	if(prob(5))
		spawned.adjust_skillrank(/datum/skill/craft/cooking, 1, TRUE)
		spawned.adjust_skillrank(/datum/skill/misc/sewing, 2, TRUE)
		spawned.adjust_skillrank(/datum/skill/labor/lumberjacking, 1, TRUE)
		spawned.adjust_skillrank(/datum/skill/craft/carpentry, 1, TRUE)

/datum/outfit/carpenter
	name = "Carpenter"
	neck = /obj/item/clothing/neck/coif
	armor = /obj/item/clothing/armor/gambeson/light/striped
	pants = /obj/item/clothing/pants/trou
	shirt = /obj/item/clothing/shirt/undershirt/colored/random
	wrists = /obj/item/clothing/wrists/bracers/leather
	shoes = /obj/item/clothing/shoes/boots/leather
	belt = /obj/item/storage/belt/leather
	beltr = /obj/item/storage/belt/pouch/coins/poor
	beltl = /obj/item/weapon/hammer/steel
	backr = /obj/item/weapon/axe/iron
	backl = /obj/item/storage/backpack/backpack

	backpack_contents = list(
		/obj/item/flint = 1,
		/obj/item/weapon/knife/villager = 1,
		/obj/item/recipe_book/carpentry = 1,
	)

/datum/outfit/carpenter/pre_equip(mob/living/carbon/human/H, visuals_only)
	. = ..()
	head = pick(
		/obj/item/clothing/head/hatfur,
		/obj/item/clothing/head/hatblu,
		/obj/item/clothing/head/brimmed,
	)

