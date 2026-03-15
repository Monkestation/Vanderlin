/datum/attribute_holder/sheet/job/gaffer
	attribute_variance = list(
		/datum/attribute/skill/combat/swords = list(0, 10)
	)
	raw_attribute_list = list(
		STAT_SPEED = 2,
		STAT_PERCEPTION = 1,
		STAT_STRENGTH = 1,
		/datum/attribute/skill/combat/swords = 10,
		/datum/attribute/skill/combat/knives = 30,
		/datum/attribute/skill/combat/wrestling = 20,
		/datum/attribute/skill/combat/unarmed = 20,
		/datum/attribute/skill/combat/crossbows = 40,
		/datum/attribute/skill/combat/bows = 50,
		/datum/attribute/skill/misc/swimming = 30,
		/datum/attribute/skill/misc/climbing = 30,
		/datum/attribute/skill/misc/athletics = 20,
		/datum/attribute/skill/misc/sneaking = 20,
		/datum/attribute/skill/misc/reading = 50,
		/datum/attribute/skill/craft/cooking = 30,
		/datum/attribute/skill/craft/traps = 10,
		/datum/attribute/skill/labor/butchering = 50,
		/datum/attribute/skill/labor/mathematics = 50,
	)

/datum/attribute_holder/sheet/job/gaffer/old
	raw_attribute_list = list(
		STAT_SPEED = 2,
		STAT_PERCEPTION = 2,
		STAT_STRENGTH = 1,
		/datum/attribute/skill/combat/swords = 10,
		/datum/attribute/skill/combat/knives = 40,
		/datum/attribute/skill/combat/wrestling = 20,
		/datum/attribute/skill/combat/unarmed = 30,
		/datum/attribute/skill/combat/crossbows = 50,
		/datum/attribute/skill/combat/bows = 60,
		/datum/attribute/skill/misc/swimming = 40,
		/datum/attribute/skill/misc/climbing = 40,
		/datum/attribute/skill/misc/athletics = 40,
		/datum/attribute/skill/misc/sneaking = 40,
		/datum/attribute/skill/misc/reading = 50,
		/datum/attribute/skill/craft/cooking = 30,
		/datum/attribute/skill/craft/traps = 10,
		/datum/attribute/skill/labor/butchering = 50,
		/datum/attribute/skill/labor/mathematics = 50,
	)

/datum/job/gaffer
	title = "Gaffer"
	department_flag = SERFS
	faction = "Station"
	job_flags = (JOB_ANNOUNCE_ARRIVAL | JOB_SHOW_IN_CREDITS | JOB_EQUIP_RANK | JOB_NEW_PLAYER_JOINABLE)
	total_positions = 1
	spawn_positions = 1

	//I say we let all species be the gaffer, this is job concerns the adventurers and mercs, and those come in all types and sizes,
	//so it fits better with the wild cards that is this demographic of people
	//having said that I am gate keeping the moment felinids are in the damn game
	allowed_ages = list(AGE_MIDDLEAGED, AGE_OLD, AGE_IMMORTAL) //AGE_OLD with the ring on? I say unlikely - clown
	blacklisted_species = list(SPEC_ID_HALFLING)

	tutorial = "Forced out of your old adventure party, you applied to the Mercenary guild. Eventually becoming \
	the next Guild Master. Gone are the excitements of your past, today your life is engrossed with two \
	things: administrative work, and feeding the monstrous Head Eater. Act as the \
	Mercenary Guild's master in town, and make sure your members bring back the heads of any slain monsters \
	or bandits. For the Head Eater hungers..."

	display_order = JDO_GAFFER
	cmode_music = 'sound/music/cmode/towner/CombatGaffer.ogg'
	outfit = /datum/outfit/gaffer
	give_bank_account = 20
	bypass_lastclass = TRUE
	selection_color = "#3b150e"

	spells = list(/datum/action/cooldown/spell/undirected/list_target/convert_role/mercenary)

	attribute_sheet = /datum/attribute_holder/sheet/job/gaffer
	attribute_sheet_old = /datum/attribute_holder/sheet/job/gaffer/old

	exp_type = list(EXP_TYPE_LIVING, EXP_TYPE_ADVENTURER, EXP_TYPE_RANGER, EXP_TYPE_MERCENARY)
	exp_types_granted = list(EXP_TYPE_ADVENTURER, EXP_TYPE_RANGER, EXP_TYPE_MERCENARY, EXP_TYPE_LEADERSHIP)
	exp_requirements = list(
		EXP_TYPE_LIVING = 1200,
		EXP_TYPE_ADVENTURER = 300,
		EXP_TYPE_RANGER = 300,
		EXP_TYPE_MERCENARY = 120
	)
	traits = list(
		TRAIT_SEEPRICES,
		TRAIT_BURDEN,
		TRAIT_STEELHEARTED,
		TRAIT_OLDPARTY,
	)

/datum/job/gaffer/after_spawn(mob/living/carbon/human/spawned, client/player_client)
	. = ..()
	spawned.add_quirk(/datum/quirk/boon/folk_hero)

/datum/outfit/gaffer
	name = "Gaffer"
	backr = /obj/item/storage/backpack/satchel
	backpack_contents = list(
		/obj/item/storage/belt/pouch/coins/rich = 1,
		/obj/item/merctoken = 2,
		/obj/item/natural/feather,
		/obj/item/paper = 3,
		/obj/item/weapon/knife/dagger/steel,
		/obj/item/paper,
	)
	backl = /obj/item/weapon/sword/long/replica
	belt = /obj/item/storage/belt/leather/plaquegold
	beltl = /obj/item/storage/keyring/gaffer
	beltr = /obj/item/flashlight/flare/torch/lantern
	shirt = /obj/item/clothing/shirt/tunic/colored/black
	wrists = /obj/item/clothing/wrists/bracers/leather/advanced
	armor = /obj/item/clothing/armor/leather/hide
	pants = /obj/item/clothing/pants/trou/leather/advanced
	shoes = /obj/item/clothing/shoes/nobleboot
	cloak = /obj/item/clothing/cloak/raincloak/furcloak/colored/black
	mask = /obj/item/clothing/face/eyepatch/fake

/datum/outfit/gaffer/pre_equip(mob/living/carbon/human/equipped_human, visuals_only)
	. = ..()
	if(!visuals_only)
		ring = /obj/item/clothing/ring/gold/burden
	else
		ring = /obj/item/clothing/ring/gold
