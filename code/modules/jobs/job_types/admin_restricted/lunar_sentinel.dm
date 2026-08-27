/datum/attribute_holder/sheet/job/lunar_sentinel
	raw_attribute_list = list(
		STAT_STRENGTH = 2,
		STAT_CONSTITUTION = 2,
		STAT_ENDURANCE = 2,
		STAT_SPEED = -1,
		/datum/attribute/skill/combat/wrestling = 30,
		/datum/attribute/skill/combat/unarmed = 20,
		/datum/attribute/skill/combat/shields = 30,
		/datum/attribute/skill/misc/climbing = 10,
		/datum/attribute/skill/misc/athletics = 30,
		/datum/attribute/skill/misc/reading = 20,
		/datum/attribute/skill/magic/holy = 40,
		/datum/attribute/skill/misc/medicine = 10,
		/datum/attribute/skill/misc/sewing = 20,
	)

/datum/job/admin/lunar_sentinel
	title = JOB_ADMIN_LUNAR_SENTINEL
	tutorial = "You are a devoted follower of Noc. \
	Sentinel of the Lunar Order you serve the agents of The Moon Prince. \
	Keep safe the nite."
	department_flag = ADMIN_SPECIAL
	job_flags = (JOB_ANNOUNCE_ARRIVAL | JOB_SHOW_IN_CREDITS | JOB_EQUIP_RANK | JOB_NEW_PLAYER_JOINABLE)
	factions = list(FACTION_TOWN)
	cmode_music = 'sound/music/cmode/church/CombatNoc.ogg'
	allowed_races = RACES_PLAYER_NONDISCRIMINATED
	blacklisted_species = list(SPEC_ID_HALFLING)
	allowed_patrons = list(/datum/patron/divine/noc)

	outfit = /datum/outfit/admin/lunar_sentinel

	give_bank_account = 30
	knows_the_town = TRUE
	known_by_the_town = TRUE

	jobs_i_always_know = list(JOB_MONARCH, JOB_ADMIN_ORACLE, JOB_ADMIN_LUNAR_SENTINEL, JOB_ADMIN_LUNAR_CHAMPION)
	jobs_always_know_me = list(JOB_ADMIN_ORACLE, JOB_ADMIN_LUNAR_SENTINEL, JOB_ADMIN_LUNAR_CHAMPION)

	exp_type = list(EXP_TYPE_CHURCH, EXP_TYPE_COMBAT)
	exp_types_granted = list(EXP_TYPE_CHURCH, EXP_TYPE_COMBAT, EXP_TYPE_CLERIC)
	exp_requirements = list(
		EXP_TYPE_CHURCH = 900,
		EXP_TYPE_COMBAT = 900
	)

	attribute_sheet = /datum/attribute_holder/sheet/job/lunar_sentinel

	traits = list(
		TRAIT_LUNAR_ORDER,
		TRAIT_STEELHEARTED,
		TRAIT_DEADNOSE,
		TRAIT_HEAVYARMOR,
		TRAIT_MEDIUMARMOR,
		TRAIT_DUALWIELDER,
	)

	languages = list(
		/datum/language/celestial_moon,
		/datum/language/celestial,
		/datum/language/hellspeak
	)

/datum/job/admin/lunar_sentinel/after_spawn(mob/living/carbon/human/spawned, client/player_client)
	. = ..()
	ADD_TRAIT(spawned, TRAIT_VIRGIN, JOB_TRAIT)

	var/holder = spawned.patron?.devotion_holder
	if(holder)
		var/datum/devotion/devotion = new holder()
		devotion.make_templar()
		devotion.grant_to(spawned)

/datum/job/admin/lunar_sentinel/on_roundstart(mob/living/spawned, client/player_client)
	. = ..()
	var/static/list/selectable = list(
		"Moonlight Khopesh" = /obj/item/weapon/sword/sabre/noc,
		"Lunar Flail" = /obj/item/weapon/flail/silver/noc,
	)
	var/choice = spawned.select_equippable(player_client, selectable, message = "Choose Your Specialisation", title = "TEMPLAR")
	if(!choice)
		return
	switch(choice)
		if("Moonlight Khopesh")
			spawned.attributes?.add_sheet(/datum/attribute_holder/sheet/job/templar/patron/noc/khopesh)
		if("Lunar Flail")
			spawned.attributes?.add_sheet(/datum/attribute_holder/sheet/job/templar/patron/noc/flail)

/datum/outfit/admin/lunar_sentinel
	name = JOB_ADMIN_LUNAR_SENTINEL
	head = /obj/item/clothing/head/helmet/visored/knight/owl/lunar
	neck = /obj/item/clothing/neck/gorget/silver
	armor = /obj/item/clothing/armor/brigandine
	shirt = /obj/item/clothing/armor/chainmail
	pants = /obj/item/clothing/pants/chainlegs
	shoes = /obj/item/clothing/shoes/boots/armor/light
	gloves = /obj/item/clothing/gloves/plate
	cloak = /obj/item/clothing/cloak/stabard/templar/noc
	wrists = /obj/item/clothing/neck/psycross/silver/divine/noc
	belt = /obj/item/storage/belt/leather
	beltr = /obj/item/flashlight/flare/torch/lantern
	backl = /obj/item/storage/backpack/satchel
	backpack_contents = list(
		/obj/item/needle = 1,
		/obj/item/storage/belt/pouch/coins/mid = 1,
		/obj/item/storage/keyring/oracle
	)
