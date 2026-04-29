/datum/attribute_holder/sheet/job/artificer
	attribute_variance = list(
		/datum/attribute/skill/labor/lumberjacking = list(10, 20)
	)
	raw_attribute_list = list(
		STAT_STRENGTH = 1,
		STAT_INTELLIGENCE = 2,
		STAT_ENDURANCE = 1,
		STAT_SPEED = -1,
		/datum/attribute/skill/combat/axesmaces = 20,
		/datum/attribute/skill/craft/masonry = 30,
		/datum/attribute/skill/craft/crafting = 40,
		/datum/attribute/skill/craft/engineering = 40,
		/datum/attribute/skill/misc/lockpicking = 30,
		/datum/attribute/skill/misc/swimming = 10,
		/datum/attribute/skill/misc/climbing = 20,
		/datum/attribute/skill/misc/athletics = 20,
		/datum/attribute/skill/labor/mining = 20,
		/datum/attribute/skill/craft/smelting = 40,
		/datum/attribute/skill/misc/reading = 20,
		/datum/attribute/skill/labor/mathematics = 20,
		/datum/attribute/skill/craft/bombs = 30,
	)

/datum/attribute_holder/sheet/job/artificer/old
	raw_attribute_list = list(
		STAT_STRENGTH = 1,
		STAT_INTELLIGENCE = 2,
		STAT_ENDURANCE = 1,
		STAT_SPEED = -1,
		/datum/attribute/skill/combat/axesmaces = 20,
		/datum/attribute/skill/craft/masonry = 30,
		/datum/attribute/skill/craft/crafting = 40,
		/datum/attribute/skill/craft/engineering = 50,
		/datum/attribute/skill/misc/lockpicking = 30,
		/datum/attribute/skill/misc/swimming = 10,
		/datum/attribute/skill/misc/climbing = 20,
		/datum/attribute/skill/misc/athletics = 20,
		/datum/attribute/skill/labor/mining = 20,
		/datum/attribute/skill/craft/smelting = 40,
		/datum/attribute/skill/misc/reading = 20,
		/datum/attribute/skill/labor/mathematics = 20,
		/datum/attribute/skill/craft/bombs = 30,
	)


/datum/job/artificer
	title = JOB_ARTIFICER
	tutorial = "You are one of the greatest minds of Heartfelt- an artificer, an engineer. \
	You will build the future, regardless of what superstition the more mystical minded may spout. \
	You know your machines' inner workings as well as you do stone, down to the last cog."
	department_flag = SERFS
	job_flags = (JOB_ANNOUNCE_ARRIVAL | JOB_SHOW_IN_CREDITS | JOB_EQUIP_RANK | JOB_NEW_PLAYER_JOINABLE)
	display_order = JDO_ARTIFICER
	faction = FACTION_TOWN
	total_positions = 3
	spawn_positions = 3
	bypass_lastclass = TRUE
	allowed_races = RACES_PLAYER_ALL

	outfit = /datum/outfit/artificer
	give_bank_account = 8
	cmode_music = 'sound/music/cmode/adventurer/CombatDream.ogg'

	job_bitflag = BITFLAG_CONSTRUCTOR

	exp_type = list(EXP_TYPE_LIVING)
	exp_requirements = list(
		EXP_TYPE_LIVING = 600
	)

	attribute_sheet = /datum/attribute_holder/sheet/job/artificer
	attribute_sheet_old = /datum/attribute_holder/sheet/job/artificer/old

/datum/outfit/artificer
	name = JOB_ARTIFICER
	head = /obj/item/clothing/head/articap
	armor = /obj/item/clothing/armor/leather/jacket/artijacket
	pants = /obj/item/clothing/pants/trou/artipants
	shirt = /obj/item/clothing/shirt/undershirt/artificer
	shoes = /obj/item/clothing/shoes/simpleshoes/buckle
	belt = /obj/item/storage/belt/leather
	beltr = /obj/item/storage/belt/pouch/coins/mid
	beltl = /obj/item/weapon/mace/cane/bronze
	mask = /obj/item/clothing/face/goggles
	backl = /obj/item/storage/backpack/backpack
	ring = /obj/item/clothing/ring/silver/makers_guild

	backpack_contents = list(
		/obj/item/weapon/hammer/steel = 1,
		/obj/item/flashlight/flare/torch/lantern = 1,
		/obj/item/weapon/knife/villager = 1,
		/obj/item/weapon/chisel = 1,
		/obj/item/storage/keyring/artificer = 1
	)

/datum/outfit/artificer/pre_equip(mob/living/carbon/human/equipped_human, visuals_only)
	. = ..()
	if(equipped_human.dna.species.id == SPEC_ID_DWARF)
		head = /obj/item/clothing/head/helmet/leather/minershelm
		equipped_human.cmode_music = 'sound/music/cmode/combat_dwarf.ogg'
