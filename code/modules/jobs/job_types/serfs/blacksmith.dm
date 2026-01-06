/datum/job/armorsmith
	title = "Armorer"
	tutorial = "You studied for many decades under your master with a few other apprentices to become an Armorer, \
	a trade that certainly has seen a boom in revenue in recent times with many a bannerlord \
	seeing the importance in maintaining a well-equipped army."
	department_flag = SERFS
	job_flags = (JOB_ANNOUNCE_ARRIVAL | JOB_SHOW_IN_CREDITS | JOB_EQUIP_RANK | JOB_NEW_PLAYER_JOINABLE)
	faction = FACTION_TOWN
	total_positions = 1
	spawn_positions = 1
	bypass_lastclass = TRUE
	allowed_races = RACES_PLAYER_ALL

	outfit = /datum/outfit/armorsmith
	display_order = JDO_ARMORER
	give_bank_account = 30
	cmode_music = 'sound/music/cmode/towner/CombatTowner2.ogg'

	job_bitflag = BITFLAG_CONSTRUCTOR

	jobstats = list(
		STATKEY_STR = 1,
		STATKEY_END = 2,
		STATKEY_SPD = -1,
	)

	skills = list(
		/datum/skill/combat/axesmaces = 2,
		/datum/skill/misc/athletics = 3,
		/datum/skill/combat/wrestling = 2,
		/datum/skill/combat/unarmed = 2,
		/datum/skill/craft/crafting = 3,
		/datum/skill/craft/blacksmithing = 4,
		/datum/skill/craft/armorsmithing = 4,
		/datum/skill/craft/weaponsmithing = 2,
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


/datum/job/armorsmith/after_spawn(mob/living/carbon/human/spawned, client/player_client)
	. = ..()
	if(spawned.age == AGE_OLD)
		spawned.adjust_skillrank(/datum/skill/craft/blacksmithing, pick(1,2), TRUE)
		spawned.adjust_skillrank(/datum/skill/craft/armorsmithing, pick(1,2), TRUE)


/datum/outfit/armorsmith
	name = "Armorsmith"
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

/datum/outfit/armorsmith/pre_equip(mob/living/carbon/human/equipped_human, visuals_only)
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

/datum/job/weaponsmith
	title = "Weaponsmith"
	tutorial = "You studied for many decades under your master with a few other apprentices to become a Weaponsmith, \
	a trade that is as ancient as the secrets of steel itself! \
	You've repaired the blades of cooks, the cracked hoes of peasants and greased the spears of many soldiers into war."
	department_flag = SERFS
	job_flags = (JOB_ANNOUNCE_ARRIVAL | JOB_EQUIP_RANK | JOB_NEW_PLAYER_JOINABLE)
	faction = FACTION_TOWN
	total_positions = 1
	spawn_positions = 1
	bypass_lastclass = TRUE

	allowed_races = RACES_PLAYER_ALL

	outfit = /datum/outfit/weaponsmith
	display_order = JDO_WSMITH
	give_bank_account = 30
	cmode_music = 'sound/music/cmode/towner/CombatTowner2.ogg'


	jobstats = list(
		STATKEY_STR = 1,
		STATKEY_END = 2,
		STATKEY_SPD = -1,
	)

	skills = list(
		/datum/skill/combat/axesmaces = 2,
		/datum/skill/misc/athletics = 3,
		/datum/skill/combat/wrestling = 2,
		/datum/skill/combat/unarmed = 2,
		/datum/skill/craft/crafting = 3,
		/datum/skill/craft/blacksmithing = 4,
		/datum/skill/craft/armorsmithing = 2,
		/datum/skill/craft/weaponsmithing = 4,
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


/datum/job/weaponsmith/after_spawn(mob/living/carbon/human/spawned, client/player_client)
	. = ..()
	if(spawned.age == AGE_OLD)
		spawned.adjust_skillrank(/datum/skill/craft/blacksmithing, pick(1,2), TRUE)
		spawned.adjust_skillrank(/datum/skill/craft/weaponsmithing, pick(1,2), TRUE)

/datum/outfit/weaponsmith
	name = "Weaponsmith"
	head = /obj/item/clothing/head/hatfur
	ring = /obj/item/clothing/ring/silver/makers_guild
	backl = /obj/item/weapon/hammer/sledgehammer
	pants = /obj/item/clothing/pants/trou
	shoes = /obj/item/clothing/shoes/boots/leather
	shirt = /obj/item/clothing/shirt/shortshirt
	belt = /obj/item/storage/belt/leather
	beltl = /obj/item/storage/belt/pouch/coins/poor
	beltr = /obj/item/key/blacksmith
	cloak = /obj/item/clothing/cloak/apron/brown

	backpack_contents = list(
		/obj/item/recipe_book/blacksmithing = 1,
	)

/datum/outfit/weaponsmith/pre_equip(mob/living/carbon/human/equipped_human, visuals_only)
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
