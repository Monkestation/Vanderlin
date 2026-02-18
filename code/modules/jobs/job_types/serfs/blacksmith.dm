/datum/job/blacksmith
	title = "Blacksmith"
	tutorial = "You studied for many decades under your master with a few other apprentices to become an Blacksmith, \
	a trade that certainly has seen a boom in revenue in recent times with many a bannerlord \
	seeing the importance in maintaining a well-equipped army."
	department_flag = SERFS
	job_flags = (JOB_ANNOUNCE_ARRIVAL | JOB_SHOW_IN_CREDITS | JOB_EQUIP_RANK | JOB_NEW_PLAYER_JOINABLE)
	faction = FACTION_TOWN
	total_positions = 2
	spawn_positions = 2
	bypass_lastclass = TRUE
	allowed_races = RACES_PLAYER_ALL

	outfit = /datum/outfit/blacksmith
	display_order = JDO_BLACKSMITH
	give_bank_account = 30
	cmode_music = 'sound/music/cmode/towner/CombatTowner2.ogg'

	job_bitflag = BITFLAG_CONSTRUCTOR

	jobstats = list(
		STATKEY_STR = 1,
		STATKEY_END = 2,
		STATKEY_CON = 1,
		STATKEY_SPD = -1,
	)

	skills = list(
		/datum/skill/combat/axesmaces = 2,
		/datum/skill/misc/athletics = 3,
		/datum/skill/combat/wrestling = 1,
		/datum/skill/combat/unarmed = 2,
		/datum/skill/craft/crafting = 3,
		/datum/skill/craft/blacksmithing = 4,
		/datum/skill/craft/armorsmithing = 3,
		/datum/skill/craft/weaponsmithing = 3,
		/datum/skill/craft/smelting = 3,
		/datum/skill/craft/engineering = 3,
		/datum/skill/craft/traps = 2,
		/datum/skill/misc/reading = 2,
		/datum/skill/labor/mathematics = 2,
	)

	traits = list(
		TRAIT_MALUMFIRE,
		TRAIT_SEEPRICES,
	)

	exp_type = list(EXP_TYPE_LIVING)
	exp_requirements = list(EXP_TYPE_LIVING = 600)


/datum/job/blacksmith/after_spawn(mob/living/carbon/human/spawned, client/player_client)
	. = ..()
	if(spawned.age == AGE_OLD)
		spawned.adjust_skillrank(/datum/skill/craft/blacksmithing, pick(1,2), TRUE)
		spawned.adjust_skillrank(/datum/skill/craft/armorsmithing, pick(1,2), TRUE)
		spawned.adjust_skillrank(/datum/skill/craft/weaponsmithing, pick(1,2), TRUE)

	if(prob(5))
		spawned.adjust_skillrank(/datum/skill/craft/blacksmithing, 1, TRUE)
		spawned.adjust_skillrank(/datum/skill/craft/armorsmithing, 1, TRUE)
		spawned.adjust_skillrank(/datum/skill/craft/smelting, 1, TRUE)

/datum/outfit/blacksmith
	name = "Blacksmith"
	head = /obj/item/clothing/head/hatfur
	ring = /obj/item/clothing/ring/silver/makers_guild
	backl = /obj/item/weapon/hammer/sledgehammer
	pants = /obj/item/clothing/pants/trou
	shoes = /obj/item/clothing/shoes/simpleshoes/buckle
	shirt = /obj/item/clothing/shirt/shortshirt
	belt = /obj/item/storage/belt/leather
	beltl = /obj/item/storage/belt/pouch/coins/poor
	beltr = /obj/item/key/blacksmith
	cloak = /obj/item/clothing/cloak/apron/brown

	backpack_contents = list(
		/obj/item/recipe_book/blacksmithing = 1,
	)

/datum/outfit/blacksmith/pre_equip(mob/living/carbon/human/equipped_human, visuals_only)
	. = ..()
	if(prob(50))
		head = /obj/item/clothing/head/hatblu
	if(equipped_human.gender == FEMALE)
		pants = /obj/item/clothing/pants/trou
		armor = /obj/item/clothing/shirt/dress/gen/colored/random
		shoes = /obj/item/clothing/shoes/shortboots
		belt = /obj/item/storage/belt/leather
		beltl = /obj/item/storage/belt/pouch/coins/poor
		beltr = /obj/item/key/blacksmith
		cloak = /obj/item/clothing/cloak/apron/brown

