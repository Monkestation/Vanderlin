/datum/job/matron
	title = "Matron"
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

	allowed_sexes = list(FEMALE)
	allowed_ages = list(AGE_MIDDLEAGED, AGE_OLD, AGE_IMMORTAL)
	allowed_races = RACES_PLAYER_NONEXOTIC
	blacklisted_species = list(SPEC_ID_HALFLING)

	outfit = /datum/outfit/matron
	give_bank_account = 35
	can_have_apprentices = TRUE
	cmode_music = 'sound/music/cmode/nobility/CombatSpymaster.ogg'

	spells = list(
		/datum/action/cooldown/spell/undirected/hag_call,
		/datum/action/cooldown/spell/undirected/seek_orphan,
	)

	exp_type = list(EXP_TYPE_LIVING, EXP_TYPE_ADVENTURER, EXP_TYPE_THIEF)
	exp_types_granted = list(EXP_TYPE_ADVENTURER, EXP_TYPE_THIEF)
	exp_requirements = list(
		EXP_TYPE_LIVING = 1200,
		EXP_TYPE_ADVENTURER = 300,
		EXP_TYPE_THIEF = 300
	)

	skills = list(
		/datum/skill/misc/sewing = 3,
		/datum/skill/misc/sneaking = 4,
		/datum/skill/misc/stealing = 4,
		/datum/skill/misc/lockpicking = 4,
		/datum/skill/craft/traps = 2,
		/datum/skill/misc/climbing = 4,
		/datum/skill/misc/athletics = 2,
		/datum/skill/craft/cooking = 4,
		/datum/skill/misc/medicine = 1,
		/datum/skill/misc/reading = 3,
		/datum/skill/combat/knives = 5,
		/datum/skill/combat/unarmed = 2,
		/datum/skill/combat/wrestling = 2,
	)

	jobstats = list(
		STATKEY_STR = -1,
		STATKEY_INT =  2,
		STATKEY_PER =  1,
		STATKEY_SPD =  2
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
	if(spawned.age == AGE_OLD)
		spawned.adjust_skillrank(/datum/skill/combat/unarmed, 1, TRUE)
		spawned.adjust_skillrank(/datum/skill/combat/knives, 1, TRUE)
		spawned.adjust_skillrank(/datum/skill/misc/lockpicking, 1, TRUE)
		spawned.adjust_skillrank(/datum/skill/misc/stealing, 2, TRUE)
		spawned.adjust_skillrank(/datum/skill/misc/sneaking, 1, TRUE)
		spawned.adjust_skillrank(/datum/skill/misc/climbing, 1, TRUE)

		spawned.adjust_stat_modifier(STATMOD_JOB, STATKEY_SPD, 1)
		spawned.adjust_stat_modifier(STATMOD_JOB, STATKEY_END, 1)

/datum/outfit/matron
	name = "Matron"
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
