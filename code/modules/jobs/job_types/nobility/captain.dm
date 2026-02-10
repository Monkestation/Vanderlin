/datum/job/captain
	title = "Captain"
	tutorial = "Law and Order, your divine reason for existence. \
	You have been given command over the town and keep garrison to help ensure order and peace within the city, \
	and defend it against the many dangers of the peninsula."
	department_flag = NOBLEMEN
	display_order = JDO_CAPTAIN
	job_flags = (JOB_ANNOUNCE_ARRIVAL | JOB_SHOW_IN_CREDITS | JOB_EQUIP_RANK | JOB_NEW_PLAYER_JOINABLE)
	faction = FACTION_TOWN
	total_positions = 1
	spawn_positions = 1
	bypass_lastclass = TRUE

	allowed_races = RACES_PLAYER_NONDISCRIMINATED
	blacklisted_species = list(SPEC_ID_HALFLING)

	outfit = /datum/outfit/captain
	spells = list(/datum/action/cooldown/spell/undirected/list_target/convert_role/guard)
	give_bank_account = 120
	cmode_music = 'sound/music/cmode/antag/CombatSausageMaker.ogg'
	noble_income = 11

	exp_type = list(EXP_TYPE_GARRISON)
	exp_types_granted = list(EXP_TYPE_GARRISON, EXP_TYPE_NOBLE, EXP_TYPE_LEADERSHIP)
	exp_requirements = list(
		EXP_TYPE_GARRISON = 1500
	)

	job_bitflag = BITFLAG_ROYALTY | BITFLAG_GARRISON

	jobstats = list(
		STATKEY_STR = 2,
		STATKEY_PER = 2,
		STATKEY_INT = 1,
		STATKEY_CON = 1,
		STATKEY_END = 2
	)

	skills = list(
		/datum/skill/combat/swords = 5,
		/datum/skill/combat/wrestling = 4,
		/datum/skill/combat/axesmaces = 4,
		/datum/skill/combat/shields = 4,
		/datum/skill/combat/unarmed = 3,
		/datum/skill/combat/knives = 3,
		/datum/skill/combat/polearms = 2,
		/datum/skill/combat/whipsflails = 2,
		/datum/skill/combat/crossbows = 3,
		/datum/skill/combat/bows = 2,
		/datum/skill/misc/athletics = 4,
		/datum/skill/misc/swimming = 3,
		/datum/skill/misc/climbing = 3,
		/datum/skill/misc/riding = 3,
		/datum/skill/misc/reading = 2,
		/datum/skill/labor/mathematics = 3
	)

	traits = list(
		TRAIT_NOBLE,
		TRAIT_HEAVYARMOR,
		TRAIT_KNOWBANDITS
	)

/datum/job/captain/after_spawn(mob/living/carbon/human/spawned, client/player_client)
	. = ..()
	var/prev_real_name = spawned.real_name
	var/prev_name = spawned.name
	var/honorary = "Sir"
	if(spawned.pronouns == SHE_HER)
		honorary = "Dame"
	spawned.real_name = "[honorary] [prev_real_name]"
	spawned.name = "[honorary] [prev_name]"

	add_verb(spawned, /mob/proc/haltyell)

	if(spawned.dna?.species?.id == SPEC_ID_HUMEN)
		spawned.dna.species.soundpack_m = new /datum/voicepack/male/knight()


/datum/outfit/captain
	name = "Captain"
	head = /obj/item/clothing/head/helmet/visored/captain
	gloves = /obj/item/clothing/gloves/plate
	pants = /obj/item/clothing/pants/platelegs/captain
	armor = /obj/item/clothing/armor/brigandine/captain
	neck = /obj/item/clothing/neck/gorget
	shirt = /obj/item/clothing/shirt/undershirt/colored/guard
	shoes = /obj/item/clothing/shoes/boots
	backl = /obj/item/storage/backpack/satchel
	backr = /obj/item/weapon/shield/tower/metal
	belt = /obj/item/storage/belt/leather/plaquesilver
	beltl = /obj/item/weapon/sword/sabre/dec
	beltr = /obj/item/weapon/mace/cudgel
	cloak = /obj/item/clothing/cloak/captain
	scabbards = list(/obj/item/weapon/scabbard/sword/noble)
	backpack_contents = list(
		/obj/item/storage/keyring/captain = 1,
		/obj/item/signal_horn = 1
	)
