/datum/attribute_holder/sheet/job/miner
	attribute_variance = list(
		/datum/attribute/skill/labor/mining = list(0, 20)
	)
	raw_attribute_list = list(
		STAT_STRENGTH = 1,
		STAT_INTELLIGENCE = -2,
		STAT_ENDURANCE = 2,
		STAT_CONSTITUTION = 1,
		STAT_FORTUNE = 1,
		/datum/attribute/skill/combat/axesmaces = 20,
		/datum/attribute/skill/labor/mining = 40,
		/datum/attribute/skill/combat/wrestling = 10,
		/datum/attribute/skill/combat/unarmed = 20,
		/datum/attribute/skill/craft/crafting = 20,
		/datum/attribute/skill/misc/swimming = 10,
		/datum/attribute/skill/misc/climbing = 20,
		/datum/attribute/skill/misc/medicine = 10,
		/datum/attribute/skill/misc/athletics = 30,
		/datum/attribute/skill/craft/traps = 10,
		/datum/attribute/skill/craft/engineering = 20,
		/datum/attribute/skill/craft/blacksmithing = 10,
		/datum/attribute/skill/craft/smelting = 20,
		/datum/attribute/skill/misc/reading = 10
	)

/datum/job/miner
	title = JOB_MINER
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
	can_be_apprentice = TRUE

	job_bitflag = BITFLAG_CONSTRUCTOR

	attribute_sheet = /datum/attribute_holder/sheet/job/miner

/datum/outfit/miner
	name = JOB_MINER
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

