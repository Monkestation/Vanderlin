/datum/attribute_holder/sheet/job/tomb_warden
	raw_attribute_list = list(
		STAT_STRENGTH = 1,
		STAT_INTELLIGENCE = 1,
		STAT_PERCEPTION = 1,
		STAT_CONSTITUTION = 1,
		STAT_SPEED = -1,
		/datum/attribute/skill/combat/axesmaces = 50,
		/datum/attribute/skill/combat/bows = 30,
		/datum/attribute/skill/combat/crossbows = 30,
		/datum/attribute/skill/combat/knives = 30,
		/datum/attribute/skill/combat/polearms = 50,
		/datum/attribute/skill/combat/shields = 40,
		/datum/attribute/skill/combat/swords = 50,
		/datum/attribute/skill/combat/unarmed = 40,
		/datum/attribute/skill/combat/whipsflails = 40,
		/datum/attribute/skill/combat/wrestling = 30,
		/datum/attribute/skill/craft/armorsmithing = 10,
		/datum/attribute/skill/craft/cooking = 20,
		/datum/attribute/skill/misc/sewing = 20,
		/datum/attribute/skill/craft/traps = 20,
		/datum/attribute/skill/craft/weaponsmithing = 10,
		/datum/attribute/skill/misc/climbing = 10,
		/datum/attribute/skill/misc/medicine = 20,
		/datum/attribute/skill/misc/reading = 30,
		/datum/attribute/skill/misc/riding = 40,
		/datum/attribute/skill/misc/sneaking = 20,
		/datum/attribute/skill/misc/swimming = 10,
		/datum/attribute/skill/labor/mathematics = 25,
	)

/datum/job/tomb_warden
	title = JOB_TOMB_WARDEN
	department_flag = SERFS
	faction = FACTION_TOWN
	job_flags = (JOB_ANNOUNCE_ARRIVAL | JOB_SHOW_IN_CREDITS | JOB_EQUIP_RANK | JOB_NEW_PLAYER_JOINABLE)
	total_positions = 1
	spawn_positions = 1

	allowed_races = RACES_PLAYER_NO_KOBOLD
	allowed_ages = list(AGE_OLD, AGE_IMMORTAL)
	blacklisted_species = list(SPEC_ID_HALFLING)

	tutorial = "Eat. Train. Sleep. Eat. Train. Sleep.\n\n\
		My daes of adventuring are long past. Mine was a name that none could avoid. I built up a guild from plank and nail, but now my daes are spent raising up fools who may eclipse me, or more likely perish.\n\
		My companions may have slayed the lich in that wretched tomb, but one dae it will return. We cannot stop it this time. There is hope to see one of these fools weave their own legend.\n\n\
		Eat. Train. Sleep. Eat. Train. Sleep."
	honorary = "Warden"

	display_order = JDO_TOMBWARDEN
	cmode_music = 'sound/music/cmode/towner/CombatGaffer.ogg'
	outfit = /datum/outfit/tomb_warden
	give_bank_account = 20
	bypass_lastclass = TRUE
	selection_color = "#3b150e"

	spells = list(/datum/action/cooldown/spell/undirected/list_target/convert_role/mercenary)

	exp_type = list(EXP_TYPE_LIVING, EXP_TYPE_ADVENTURER, EXP_TYPE_MERCENARY, EXP_TYPE_LEADERSHIP)
	exp_types_granted = list(EXP_TYPE_ADVENTURER, EXP_TYPE_MERCENARY, EXP_TYPE_LEADERSHIP)
	exp_requirements = list(
		EXP_TYPE_LIVING = 1200,
		EXP_TYPE_ADVENTURER = 360,
		EXP_TYPE_MERCENARY = 420,
	)

	attribute_sheet = /datum/attribute_holder/sheet/job/tomb_warden

	// Gets crazy multipliers for teaching people
	trainable_skills = list(
		/datum/attribute/skill/combat/axesmaces = 0.4,
		/datum/attribute/skill/combat/bows = 0.35,
		/datum/attribute/skill/combat/crossbows = 0.3,
		/datum/attribute/skill/combat/knives = 0.3,
		/datum/attribute/skill/combat/polearms = 0.4,
		/datum/attribute/skill/combat/unarmed = 0.4,
		/datum/attribute/skill/combat/shields = 0.4,
		/datum/attribute/skill/combat/swords = 0.4,
		/datum/attribute/skill/combat/whipsflails = 0.3,
		/datum/attribute/skill/combat/wrestling = 0.3
	)
	apprentice_name = "Aspiring Warrior"
	max_apprentices = 5

	traits = list(
		TRAIT_SEEPRICES,
		TRAIT_STEELHEARTED,
		TRAIT_OLDPARTY
	)
	forced_flaw = list(
		/datum/quirk/boon/folk_hero
	)

/datum/job/tomb_warden/after_spawn(mob/living/carbon/human/spawned, client/player_client)
	if(spawned.age != AGE_OLD) // this prevents the aasimar power game
		var/prev_age = spawned.age
		spawned.age = AGE_OLD
		spawned.reset_and_reroll_stats()
		spawned.age = prev_age
	. = ..()


/datum/outfit/tomb_warden
	name = JOB_TOMB_WARDEN
	backl = /obj/item/storage/backpack/satchel
	backpack_contents = list(
		/obj/item/merctoken = 2,
		/obj/item/natural/feather,
		/obj/item/paper,
	)
	beltr = /obj/item/storage/belt/pouch/coins/rich
	belt = /obj/item/storage/belt/leather/plaquesilver
	beltl = /obj/item/weapon/sword/arming
	neck = /obj/item/clothing/neck/mercmedal
	ring = /obj/item/clothing/ring/gold
	shirt = /obj/item/clothing/shirt/tunic/colored/black
	wrists = /obj/item/storage/keyring/tombwarden
	armor = /obj/item/clothing/armor/leather/jerkin/belted/long
	pants = /obj/item/clothing/pants/trou/leather
	shoes = /obj/item/clothing/shoes/boots
	cloak = /obj/item/clothing/cloak/raincloak/furcloak
	head = /obj/item/clothing/head/roguehood/leather
	r_hand = /obj/item/weapon/mace/cane
	scabbards = list(/obj/item/weapon/scabbard/sword)
