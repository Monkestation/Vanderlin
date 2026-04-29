/datum/attribute_holder/sheet/job/blacksmith
	raw_attribute_list = list(
		STAT_STRENGTH = 1,
		STAT_ENDURANCE = 2,
		STAT_CONSTITUTION = 1,
		STAT_SPEED = -1,
		/datum/attribute/skill/combat/axesmaces = 20,
		/datum/attribute/skill/misc/athletics = 30,
		/datum/attribute/skill/combat/wrestling = 10,
		/datum/attribute/skill/combat/unarmed = 20,
		/datum/attribute/skill/craft/crafting = 30,
		/datum/attribute/skill/craft/blacksmithing = 40,
		/datum/attribute/skill/craft/armorsmithing = 30,
		/datum/attribute/skill/craft/weaponsmithing = 30,
		/datum/attribute/skill/craft/smelting = 30,
		/datum/attribute/skill/craft/engineering = 30,
		/datum/attribute/skill/craft/traps = 20,
		/datum/attribute/skill/misc/reading = 20,
		/datum/attribute/skill/labor/mathematics = 20,
	)

/datum/attribute_holder/sheet/job/blacksmith/old
	attribute_variance = list(
		/datum/attribute/skill/craft/blacksmithing = list(10, 20),
		/datum/attribute/skill/craft/armorsmithing = list(10, 20),
		/datum/attribute/skill/craft/weaponsmithing = list(10, 20),
	)

/datum/job/blacksmith
	title = JOB_BLACKSMITH
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

	traits = list(
		TRAIT_MALUMFIRE,
		TRAIT_SEEPRICES,
	)

	exp_type = list(EXP_TYPE_LIVING)
	exp_requirements = list(EXP_TYPE_LIVING = 600)

	attribute_sheet = /datum/attribute_holder/sheet/job/blacksmith
	attribute_sheet_old = /datum/attribute_holder/sheet/job/blacksmith/old


/datum/outfit/blacksmith
	name = JOB_BLACKSMITH
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

