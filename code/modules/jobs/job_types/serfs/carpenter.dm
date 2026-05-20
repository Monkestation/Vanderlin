/datum/attribute_holder/sheet/job/carpenter
	attribute_variance = list(
		/datum/attribute/skill/misc/athletics = list(0, 10)
	)
	raw_attribute_list = list(
		STAT_STRENGTH = 1,
		STAT_ENDURANCE = 1,
		STAT_INTELLIGENCE = 1,
		STAT_CONSTITUTION = 1,
		STAT_SPEED = -1,
		/datum/attribute/skill/misc/medicine = 10,
		/datum/attribute/skill/combat/axesmaces = 20,
		/datum/attribute/skill/combat/wrestling = 10,
		/datum/attribute/skill/combat/unarmed = 10,
		/datum/attribute/skill/craft/crafting = 30,
		/datum/attribute/skill/craft/cooking = 10,
		/datum/attribute/skill/craft/carpentry = 50,
		/datum/attribute/skill/misc/swimming = 10,
		/datum/attribute/skill/misc/climbing = 20,
		/datum/attribute/skill/misc/sewing = 10,
		/datum/attribute/skill/misc/reading = 10,
		/datum/attribute/skill/misc/athletics = 30,
		/datum/attribute/skill/labor/lumberjacking = 30,
	)

/datum/job/carpenter
	title = JOB_CARPENTER
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

	attribute_sheet = /datum/attribute_holder/sheet/job/carpenter

	traits = list()


/datum/outfit/carpenter
	name = JOB_CARPENTER
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

