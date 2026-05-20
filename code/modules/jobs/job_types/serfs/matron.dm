/datum/attribute_holder/sheet/job/matron
	raw_attribute_list = list(
		STAT_STRENGTH = -1,
		STAT_INTELLIGENCE =  2,
		STAT_PERCEPTION =  1,
		STAT_SPEED =  2,
		/datum/attribute/skill/misc/sewing = 30,
		/datum/attribute/skill/misc/sneaking = 40,
		/datum/attribute/skill/misc/stealing = 40,
		/datum/attribute/skill/misc/lockpicking = 40,
		/datum/attribute/skill/craft/traps = 20,
		/datum/attribute/skill/misc/climbing = 40,
		/datum/attribute/skill/misc/athletics = 20,
		/datum/attribute/skill/craft/cooking = 40,
		/datum/attribute/skill/misc/medicine = 10,
		/datum/attribute/skill/misc/reading = 30,
		/datum/attribute/skill/combat/knives = 50,
		/datum/attribute/skill/combat/unarmed = 20,
		/datum/attribute/skill/combat/wrestling = 20,
	)

/datum/attribute_holder/sheet/job/matron/old
	raw_attribute_list = list(
		STAT_STRENGTH = -1,
		STAT_INTELLIGENCE =  2,
		STAT_PERCEPTION =  1,
		STAT_SPEED =  3,
		STAT_ENDURANCE = 1,
		/datum/attribute/skill/misc/sewing = 30,
		/datum/attribute/skill/misc/sneaking = 50,
		/datum/attribute/skill/misc/stealing = 60,
		/datum/attribute/skill/misc/lockpicking = 50,
		/datum/attribute/skill/craft/traps = 20,
		/datum/attribute/skill/misc/climbing = 53,
		/datum/attribute/skill/misc/athletics = 20,
		/datum/attribute/skill/craft/cooking = 40,
		/datum/attribute/skill/misc/medicine = 10,
		/datum/attribute/skill/misc/reading = 30,
		/datum/attribute/skill/combat/knives = 60,
		/datum/attribute/skill/combat/unarmed = 30,
		/datum/attribute/skill/combat/wrestling = 20,
	)

/datum/job/matron
	title = JOB_MATRON
	tutorial = "You are the Matron of the orphanage, once a cunning rogue who walked the shadows alongside legends. \
		Time has softened your edge but not your wit, thanks to your unlikely kinship with your old adventuring party. \
		Now, you guide the orphans with both a firm and gentle hand, ensuring they grow up sharp, swift, and self-sufficient. \
		Perhaps one day, those fledglings might leap from your nest and soar to a greater legacy."
	department_flag = PEASANTS
	job_flags = (JOB_ANNOUNCE_ARRIVAL | JOB_SHOW_IN_CREDITS | JOB_EQUIP_RANK | JOB_NEW_PLAYER_JOINABLE)
	display_order = JDO_MATRON
	faction = FACTION_TOWN
	total_positions = 1
	spawn_positions = 1
	bypass_lastclass = TRUE

	allowed_sexes = list(FEMALE)
	allowed_ages = list(AGE_MIDDLEAGED, AGE_OLD, AGE_IMMORTAL)
	allowed_races = RACES_PLAYER_NO_KOBOLD
	blacklisted_species = list(SPEC_ID_HALFLING)

	outfit = /datum/outfit/matron
	give_bank_account = 35
	can_have_apprentices = TRUE
	cmode_music = 'sound/music/cmode/nobility/CombatSpymaster.ogg'
	honorary = "Miss"

	spells = list(
		/datum/action/cooldown/spell/undirected/hag_call,
		/datum/action/cooldown/spell/undirected/seek_orphan,
	)

	attribute_sheet = /datum/attribute_holder/sheet/job/matron
	attribute_sheet_old = /datum/attribute_holder/sheet/job/matron/old

	exp_type = list(EXP_TYPE_LIVING, EXP_TYPE_ADVENTURER, EXP_TYPE_THIEF)
	exp_types_granted = list(EXP_TYPE_ADVENTURER, EXP_TYPE_THIEF)
	exp_requirements = list(
		EXP_TYPE_LIVING = 1200,
		EXP_TYPE_ADVENTURER = 300,
		EXP_TYPE_THIEF = 300
	)

	mind_traits = list(
		TRAIT_KNOW_THIEF_DOORS
	)
	traits = list(
		TRAIT_THIEVESGUILD,
		TRAIT_OLDPARTY,
		TRAIT_EARGRAB,
		TRAIT_KITTEN_MOM,
	)

	languages = list(/datum/language/thievescant)

/datum/job/matron/after_spawn(mob/living/carbon/human/spawned, client/player_client)
	. = ..()
	spawned.add_quirk(/datum/quirk/boon/folk_hero)

/datum/outfit/matron
	name = JOB_MATRON
	shirt = /obj/item/clothing/shirt/dress/gen/colored/black
	armor = /obj/item/clothing/armor/leather/vest/colored/black
	pants = /obj/item/clothing/pants/trou/beltpants
	belt = /obj/item/storage/belt/leather/cloth/lady
	shoes = /obj/item/clothing/shoes/boots/leather
	backr = /obj/item/storage/backpack/satchel
	cloak = /obj/item/clothing/cloak/matron

	backpack_contents = list(
		/obj/item/weapon/knife/dagger/steel/stiletto = 1,
		/obj/item/key/matron = 1
	)

/datum/outfit/matron/pre_equip(mob/living/carbon/human/equipped_human, visuals_only)
	. = ..()
	if(has_world_trait(/datum/world_trait/orphanage_renovated))
		beltl = /obj/item/storage/belt/pouch/coins/rich
	else
		beltl = /obj/item/storage/belt/pouch/coins/mid
