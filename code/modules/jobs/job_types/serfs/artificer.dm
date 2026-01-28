/datum/job/artificer
	title = "Artificer"
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

	jobstats = list(
		STATKEY_STR = 1,
		STATKEY_INT = 2,
		STATKEY_END = 1,
		STATKEY_SPD = -1
	)

	skills = list(
		/datum/skill/combat/axesmaces = 2,
		/datum/skill/craft/masonry = 3,
		/datum/skill/craft/crafting = 4,
		/datum/skill/craft/engineering = 4,
		/datum/skill/misc/lockpicking = 3,
		/datum/skill/misc/swimming = 1,
		/datum/skill/misc/climbing = 2,
		/datum/skill/misc/athletics = 2,
		/datum/skill/labor/mining = 2,
		/datum/skill/craft/smelting = 4,
		/datum/skill/misc/reading = 2,
		/datum/skill/labor/mathematics = 2,
		/datum/skill/craft/bombs = 3,
	)

/datum/job/artificer/after_spawn(mob/living/carbon/human/spawned, client/player_client)
	. = ..()
	spawned.adjust_skillrank(/datum/skill/labor/lumberjacking, pick(1,2), TRUE)
	if(spawned.age == AGE_OLD)
		spawned.adjust_skillrank(/datum/skill/craft/engineering, 1, TRUE)

/datum/outfit/artificer
	name = "Artificer"
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
