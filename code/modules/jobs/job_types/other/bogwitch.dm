/datum/job/bogwitch
	title = "Bog Witch"
	tutorial = "A seer of dreams, a reader of stars, and a master of the arcyne. Along a band of unlikely heroes, you shaped the fate of these lands.\
	Now the days of adventure are gone, replaced by dusty tomes and whispered prophecies. The ruler's coin funds your studies,\
	but debts both magical and mortal are never so easily repaid. With age comes wisdom, but also the creeping dread that your greatest spell work\
	may already be behind you."
	department_flag = OUTSIDERS
	job_flags = (JOB_ANNOUNCE_ARRIVAL | JOB_SHOW_IN_CREDITS | JOB_EQUIP_RANK | JOB_NEW_PLAYER_JOINABLE)
	display_order = JDO_BOGWITCH
	faction = FACTION_TOWN
	total_positions = 0
	spawn_positions = 0
	bypass_lastclass = TRUE
	allowed_races = RACES_PLAYER_ALL
	blacklisted_species = list(SPEC_ID_HALFLING)
	allowed_ages = list(AGE_MIDDLEAGED, AGE_OLD, AGE_IMMORTAL)
	allowed_sexes = list(MALE, FEMALE)
	outfit = /datum/outfit/bogwitch
	give_bank_account = 120
	cmode_music = 'sound/music/cmode/nobility/CombatCourtMagician.ogg'
	banned_patrons = list()

	exp_type = list(EXP_TYPE_LIVING, EXP_TYPE_ADVENTURER, EXP_TYPE_CHURCH, EXP_TYPE_MEDICAL)
	exp_types_granted = list(EXP_TYPE_ADVENTURER, EXP_TYPE_CHURCH, EXP_TYPE_MEDICAL)
	exp_requirements = list(
		EXP_TYPE_LIVING = 1200,
		EXP_TYPE_ADVENTURER = 300,
		EXP_TYPE_CHURCH = 300,
		EXP_TYPE_MEDICAL = 300
	)

	jobstats = list(
		STATKEY_STR = -1,
		STATKEY_INT = 3,
		STATKEY_CON = 1,
		STATKEY_END = 1
	)

	skills = list(
		/datum/skill/misc/athletics = 1,
		/datum/skill/craft/alchemy = 3,
		/datum/skill/misc/climbing = 2,
		/datum/skill/craft/crafting = 3,
		/datum/skill/labor/farming = 3,
		/datum/skill/magic/holy = 3,
		/datum/skill/misc/medicine = 3,
		/datum/skill/combat/polearms = 3,
		/datum/skill/misc/reading = 3,
		/datum/skill/craft/sewing = 2
	)

	traits = list(
		TRAIT_DEADNOSE,
		TRAIT_FORAGER,
		TRAIT_LEGENDARY_ALCHEMIST,
		TRAIT_STEELHEARTED
	)

/datum/job/bogwitch/after_spawn(mob/living/carbon/human/spawned, client/player_client)
	. = ..()
	if(spawned.age == AGE_OLD)
		spawned.adjust_stat_modifier(STATMOD_JOB, STATKEY_SPD, -1)
		spawned.adjust_stat_modifier(STATMOD_JOB, STATKEY_INT, 1)

	var/holder = spawned.patron?.devotion_holder
	if(holder)
		var/datum/devotion/devotion = new holder()
		devotion.make_acolyte()
		devotion.grant_to(spawned)

/datum/job/bogwitch/adjust_patron(mob/living/carbon/human/spawned)
	var/datum/patron/old_patron = spawned.patron
	if(old_patron?.type == /datum/patron/alternate/great_hunt)
		return

	spawned.set_patron(/datum/patron/alternate/great_hunt, TRUE)

	var/datum/patron/new_patron = spawned.patron
	if(old_patron != new_patron) // If the patron we selected first does not match the patron we end up with, display the message.
		to_chat(spawned, span_warning("I've followed the word of [old_patron.display_name ? old_patron.display_name : old_patron] in my younger years, \
		but the path I tread todae has accustomed me to [new_patron.display_name ? new_patron.display_name : new_patron]."))


/datum/outfit/bogwitch
	name = "Bog Witch"
	head = /obj/item/clothing/head/wizhat/witch
	mask = /obj/item/clothing/face/spectacles
	shirt = /obj/item/clothing/shirt/robe/colored/black
	backr = /obj/item/storage/backpack/satchel
	backr = /obj/item/storage/backpack/satchel/surgbag
	cloak = /obj/item/clothing/cloak/wickercloak
	//ring = /obj/item/clothing/ring/gold
	belt = /obj/item/storage/belt/leather
	beltr = /obj/item/storage/keyring/bogwitch
	backl = /obj/item/weapon/polearm/woodstaff
	shoes = /obj/item/clothing/shoes/boots/leather
	pants = /obj/item/clothing/pants/trou/leather
	gloves = /obj/item/clothing/gloves/leather
	//neck = /obj/item/clothing/neck/psycross/great_hunt
	backpack_contents = list(
		/obj/item/scrying = 1
	)

/datum/outfit/bogwitch/post_equip(mob/living/carbon/human/equipped_human, visuals_only)
	. = ..()


