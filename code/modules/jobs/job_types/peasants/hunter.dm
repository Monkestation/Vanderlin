/datum/attribute_holder/sheet/job/hunter
	raw_attribute_list = list(
		STAT_PERCEPTION = 3,
		/datum/attribute/skill/craft/crafting = 20,
		/datum/attribute/skill/craft/tanning = 30,
		/datum/attribute/skill/combat/bows = 30,
		/datum/attribute/skill/combat/crossbows = 20,
		/datum/attribute/skill/combat/knives = 20,
		/datum/attribute/skill/craft/cooking = 10,
		/datum/attribute/skill/labor/butchering = 20,
		/datum/attribute/skill/labor/taming = 30,
		/datum/attribute/skill/misc/medicine = 10,
		/datum/attribute/skill/misc/sewing = 20,
		/datum/attribute/skill/misc/sneaking = 20,
		/datum/attribute/skill/craft/traps = 30,
		/datum/attribute/skill/misc/athletics = 30,
		/datum/attribute/skill/misc/climbing = 20,
		/datum/attribute/skill/misc/swimming = 10,
		/datum/attribute/skill/misc/reading = 10
	)

/datum/attribute_holder/sheet/job/hunter/old
	raw_attribute_list = list(
		STAT_PERCEPTION = 1,
		STAT_ENDURANCE = -1,
		/datum/attribute/skill/craft/crafting = 30,
		/datum/attribute/skill/craft/tanning = 30,
		/datum/attribute/skill/combat/bows = 40,
		/datum/attribute/skill/combat/crossbows = 20,
		/datum/attribute/skill/combat/knives = 20,
		/datum/attribute/skill/craft/cooking = 10,
		/datum/attribute/skill/labor/butchering = 20,
		/datum/attribute/skill/labor/taming = 30,
		/datum/attribute/skill/misc/medicine = 10,
		/datum/attribute/skill/misc/sewing = 20,
		/datum/attribute/skill/misc/sneaking = 20,
		/datum/attribute/skill/craft/traps = 40,
		/datum/attribute/skill/misc/athletics = 30,
		/datum/attribute/skill/misc/climbing = 20,
		/datum/attribute/skill/misc/swimming = 10,
		/datum/attribute/skill/misc/reading = 10
	)


/datum/job/hunter
	title = "Hunter"
	f_title = "Huntress"
	tutorial = "Silent and yet full of life, the forests of Dendor grant you both happiness and misery. \
	In tales you've heard of small woodland creechers frolicking, now there is only the beastspawn of Graggar and Dendor... \
	And yet you seek beasts small enough to skin, scalp, and sell. Take heed, lest you become a beast yourself."
	department_flag = PEASANTS
	job_flags = (JOB_ANNOUNCE_ARRIVAL | JOB_SHOW_IN_CREDITS | JOB_EQUIP_RANK | JOB_NEW_PLAYER_JOINABLE)
	display_order = JDO_HUNTER
	faction = FACTION_TOWN
	total_positions = 4
	spawn_positions = 4
	bypass_lastclass = TRUE

	allowed_races = RACES_PLAYER_ALL

	outfit = /datum/outfit/hunter
	give_bank_account = 15
	apprentice_name = "Hunter"
	cmode_music = 'sound/music/cmode/towner/CombatTowner2.ogg'

	job_bitflag = BITFLAG_CONSTRUCTOR

	attribute_sheet = /datum/attribute_holder/sheet/job/hunter
	attribute_sheet_old = /datum/attribute_holder/sheet/job/hunter/old

	traits = list(
		TRAIT_FORAGER
	)

/datum/outfit/hunter
	name = "Hunter"
	pants = /obj/item/clothing/pants/tights/colored/random
	shirt = /obj/item/clothing/shirt/shortshirt/colored/random
	shoes = /obj/item/clothing/shoes/boots/leather
	neck = /obj/item/storage/belt/pouch/coins/poor
	head = /obj/item/clothing/head/brimmed
	cloak = /obj/item/clothing/cloak/raincloak/furcloak/colored/brown

	backr = /obj/item/storage/backpack/satchel
	backl = /obj/item/gun/ballistic/revolver/grenadelauncher/bow

	belt = /obj/item/storage/belt/leather
	beltr = /obj/item/ammo_holder/quiver/arrows
	beltl = /obj/item/storage/meatbag

	gloves = /obj/item/clothing/gloves/leather

	backpack_contents = list(
		/obj/item/flint = 1,
		/obj/item/bait = 1,
		/obj/item/weapon/knife/hunting = 1,
		/obj/item/flashlight/flare/torch/lantern = 1
	)
