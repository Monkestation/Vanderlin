/datum/job/miner
	title = "Miner"
	tutorial = "The depths of the hills, the ends of the lands - deeper and deeper below, you seek salt, ores, rocks - \
	the heat and encroaching darkness shepherds you, giving forth your living... Soon enough, the earth will swallow you whole."
	department_flag = PEASANTS
	display_order = JDO_MINER
	job_flags = (JOB_ANNOUNCE_ARRIVAL | JOB_SHOW_IN_CREDITS | JOB_EQUIP_RANK | JOB_NEW_PLAYER_JOINABLE)
	faction = FACTION_TOWN
	total_positions = 12
	spawn_positions = 12
	bypass_lastclass = TRUE

	allowed_races = RACES_PLAYER_ALL

	outfit = /datum/outfit/miner
	give_bank_account = 6
	cmode_music = 'sound/music/cmode/towner/CombatTowner2.ogg'

	job_bitflag = BITFLAG_CONSTRUCTOR

	jobstats = list(
		STATKEY_STR = 1,
		STATKEY_INT = -2,
		STATKEY_END = 1,
		STATKEY_CON = 1
	)

	skills = list(
		/datum/skill/combat/axesmaces = 2,
		/datum/skill/labor/mining = 4,
		/datum/skill/combat/wrestling = 2,
		/datum/skill/combat/unarmed = 2,
		/datum/skill/craft/crafting = 2,
		/datum/skill/misc/swimming = 1,
		/datum/skill/misc/climbing = 2,
		/datum/skill/misc/medicine = 1,
		/datum/skill/misc/athletics = 3,
		/datum/skill/craft/traps = 1,
		/datum/skill/craft/engineering = 2,
		/datum/skill/craft/blacksmithing = 1,
		/datum/skill/craft/smelting = 2,
		/datum/skill/misc/reading = 1
	)

/datum/job/miner/after_spawn(mob/living/carbon/human/spawned, client/player_client)
	. = ..()
	spawned.adjust_skillrank(/datum/skill/craft/smelting, pick(0,1,1,2), TRUE)

/datum/outfit/miner
	name = "Miner"
	head = /obj/item/clothing/head/armingcap
	pants = /obj/item/clothing/pants/trou
	armor = /obj/item/clothing/armor/gambeson/light/striped
	shirt = /obj/item/clothing/shirt/undershirt/colored/random
	shoes = /obj/item/clothing/shoes/boots/leather

	belt = /obj/item/storage/belt/leather
	neck = /obj/item/storage/belt/pouch/coins/poor
	beltl = /obj/item/weapon/pick
	backr = /obj/item/weapon/shovel
	backl = /obj/item/storage/backpack/backpack

	backpack_contents = list(
		/obj/item/flint = 1,
		/obj/item/weapon/knife/villager = 1,
		/obj/item/storage/keyring/artificer = 1
	)

/datum/outfit/miner/map_override(mob/living/carbon/human/H)
	if(SSmapping.config.map_name != "Voyage")
		return
	head = /obj/item/clothing/head/armingcap
	shirt = /obj/item/clothing/shirt/undershirt/sailor
	pants = /obj/item/clothing/pants/tights/sailor
	shoes = /obj/item/clothing/shoes/boots

/datum/outfit/miner/pre_equip(mob/living/carbon/human/equipped_human, visuals_only)
	. = ..()
	if (equipped_human.dna.species.id == SPEC_ID_DWARF)
		head = /obj/item/clothing/head/helmet/leather/minershelm
		equipped_human.cmode_music = 'sound/music/cmode/combat_dwarf.ogg'
	else
		beltr = /obj/item/flashlight/flare/torch/lantern

