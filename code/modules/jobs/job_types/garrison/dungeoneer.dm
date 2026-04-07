/datum/attribute_holder/sheet/job/dungeoneer
	raw_attribute_list = list(
		STAT_STRENGTH = 2,
		STAT_INTELLIGENCE = -2,
		STAT_ENDURANCE = 2,
		STAT_CONSTITUTION = 1,
		STAT_SPEED = -1,
		STAT_PERCEPTION = -1,
		/datum/attribute/skill/combat/whipsflails = 30,
		/datum/attribute/skill/combat/wrestling = 30,
		/datum/attribute/skill/combat/unarmed = 30,
		/datum/attribute/skill/combat/swords = 10,
		/datum/attribute/skill/misc/swimming = 10,
		/datum/attribute/skill/misc/reading = 10,
		/datum/attribute/skill/misc/climbing = 10,
		/datum/attribute/skill/misc/athletics = 20,
		/datum/attribute/skill/craft/cooking = 10,
		/datum/attribute/skill/misc/sewing = 10,
		/datum/attribute/skill/craft/traps = 30
	)

/datum/job/dungeoneer
	title = "Dungeoneer"
	tutorial = "Be you an instrument of sadism for the King or the guarantor of his merciful hospitality, \
	your duties are a service paid for most handsomely. \
	Perhaps you were promoted from the garrison down to these cells \
	to get your brutality off the town streets where cracked skulls caused outcries, \
	or maybe your soft-hearted lord wanted to be sure his justice was done without malice. \
	In either case, your little world is the lowest office in the Realm; from it your guests see only hell."
	department_flag = GARRISON
	job_flags = (JOB_ANNOUNCE_ARRIVAL | JOB_SHOW_IN_CREDITS | JOB_EQUIP_RANK | JOB_NEW_PLAYER_JOINABLE)
	display_order = JDO_DUNGEONEER
	faction = FACTION_TOWN
	total_positions = 1
	spawn_positions = 1
	can_have_apprentices = TRUE
	bypass_lastclass = TRUE

	allowed_races = RACES_PLAYER_NONEXOTIC
	blacklisted_species = list(SPEC_ID_HALFLING)

	outfit = /datum/outfit/dungeoneer
	give_bank_account = 50
	cmode_music = 'sound/music/cmode/nobility/CombatDungeoneer.ogg'

	job_bitflag = BITFLAG_GARRISON

	exp_type = list(EXP_TYPE_GARRISON)
	exp_types_granted = list(EXP_TYPE_GARRISON, EXP_TYPE_COMBAT)
	exp_requirements = list(
		EXP_TYPE_GARRISON = 300
	)

	attribute_sheet = /datum/attribute_holder/sheet/job/dungeoneer

	traits = list(
		TRAIT_STEELHEARTED
	)

/datum/job/dungeoneer/after_spawn(mob/living/carbon/human/spawned, client/player_client)
	. = ..()
	add_verb(spawned, /mob/living/carbon/human/proc/torture_victim)

	if(spawned.dna?.species?.id == SPEC_ID_HUMEN && spawned.gender == MALE)
		spawned.dna.species.soundpack_m = new /datum/voicepack/male/warrior()

/datum/outfit/dungeoneer
	name = "Dungeoneer"
	head = /obj/item/clothing/head/dungeoneer
	neck = /obj/item/clothing/neck/coif
	wrists = /obj/item/clothing/wrists/bracers/leather
	cloak = /obj/item/clothing/cloak/stabard/colored/dungeon
	armor = /obj/item/clothing/armor/cuirass/iron/rust
	shirt = /obj/item/clothing/shirt/shortshirt/colored/merc
	wrists = /obj/item/clothing/wrists/bracers/leather
	pants = /obj/item/clothing/pants/trou
	shoes = /obj/item/clothing/shoes/boots/leather
	belt = /obj/item/storage/belt/leather
	beltr = /obj/item/weapon/whip/antique
	beltl = /obj/item/storage/belt/pouch/coins/poor
	backr = /obj/item/storage/backpack/satchel	// lack of satchel requires dealing with the merchant to correct, which requires entering town; not ideal. N.
	backpack_contents = list(/obj/item/clothing/head/menacing, /obj/item/storage/keyring/dungeoneer, /obj/item/weapon/knuckles)
