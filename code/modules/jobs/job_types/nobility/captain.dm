/datum/attribute_holder/sheet/job/captain
	raw_attribute_list = list(
		STAT_STRENGTH = 2,
		STAT_PERCEPTION = 2,
		STAT_INTELLIGENCE = 1,
		STAT_CONSTITUTION = 1,
		STAT_ENDURANCE = 2,
		/datum/attribute/skill/combat/swords = 30,
		/datum/attribute/skill/combat/wrestling = 40,
		/datum/attribute/skill/combat/axesmaces = 40,
		/datum/attribute/skill/combat/shields = 20,
		/datum/attribute/skill/combat/unarmed = 30,
		/datum/attribute/skill/combat/knives = 30,
		/datum/attribute/skill/combat/polearms = 30,
		/datum/attribute/skill/combat/whipsflails = 20,
		/datum/attribute/skill/combat/crossbows = 30,
		/datum/attribute/skill/combat/bows = 20,
		/datum/attribute/skill/misc/athletics = 40,
		/datum/attribute/skill/misc/swimming = 30,
		/datum/attribute/skill/misc/climbing = 30,
		/datum/attribute/skill/misc/riding = 30,
		/datum/attribute/skill/misc/reading = 20,
		/datum/attribute/skill/labor/mathematics = 30,
	)

/datum/attribute_holder/sheet/job/captain/law
	raw_attribute_list = list()
	clamped_adjustment = list(
		/datum/attribute/skill/combat/swords = list(20, 50),
		/datum/attribute/skill/combat/shields = list(20, 40),
	)

/datum/attribute_holder/sheet/job/captain/justice
	raw_attribute_list = list()
	clamped_adjustment = list(
		/datum/attribute/skill/combat/polearms = list(20, 50),
	)

/datum/job/captain
	title = JOB_GUARD_CAPTAIN
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
	honorary = JOB_GUARD_CAPTAIN

	allowed_races = RACES_PLAYER_NONDISCRIMINATED
	blacklisted_species = list(SPEC_ID_HALFLING)

	outfit = /datum/outfit/captain
	spells = list(
		/datum/action/cooldown/spell/undirected/list_target/convert_role/guard,
		/datum/action/cooldown/spell/undirected/list_target/convert_role/serjeant
		)
	give_bank_account = 120
	cmode_music = 'sound/music/cmode/antag/CombatSausageMaker.ogg'
	noble_income = 11

	exp_type = list(EXP_TYPE_GARRISON)
	exp_types_granted = list(EXP_TYPE_GARRISON, EXP_TYPE_NOBLE, EXP_TYPE_LEADERSHIP)
	exp_requirements = list(
		EXP_TYPE_GARRISON = 1500
	)

	job_bitflag = BITFLAG_ROYALTY | BITFLAG_GARRISON

	attribute_sheet = /datum/attribute_holder/sheet/job/captain

	traits = list(
		TRAIT_NOBLE_BLOOD,
		TRAIT_NOBLE_POWER,
		TRAIT_HEAVYARMOR,
	)
	mind_traits = list(TRAIT_KNOWBANDITS)
	verbs = list(
		/mob/proc/haltyell
	)


/datum/job/captain/after_spawn(mob/living/carbon/human/spawned, client/player_client)
	. = ..()

	if(spawned.dna?.species?.id == SPEC_ID_HUMEN)
		spawned.dna.species.soundpack_m = new /datum/voicepack/male/knight()

/datum/job/captain/on_roundstart(mob/living/carbon/human/spawned, client/player_client)
	. = ..()

	var/static/list/selectableweapon = list(
		"Law and Order" = list(/obj/item/weapon/sword/sabre/captain, /obj/item/weapon/shield/tower/buckleriron/captain),
		"Deliverer of Justice" = /obj/item/weapon/polearm/halberd/bardiche/captain,
	)

	var/choice = spawned.select_equippable(player_client, selectableweapon, message = "Choose thy blade", title = JOB_GUARD_CAPTAIN)
	if(!choice)
		return
	switch(choice)
		if("Law and Order")
			spawned.attributes?.add_sheet(/datum/attribute_holder/sheet/job/captain/law)
		if("Deliverer of Justice")
			spawned.attributes?.add_sheet(/datum/attribute_holder/sheet/job/captain/justice)

/datum/outfit/captain
	name = JOB_GUARD_CAPTAIN
	head = /obj/item/clothing/head/helmet/visored/captain
	gloves = /obj/item/clothing/gloves/plate
	pants = /obj/item/clothing/pants/platelegs/captain
	armor = /obj/item/clothing/armor/brigandine/captain
	neck = /obj/item/clothing/neck/gorget
	shirt = /obj/item/clothing/shirt/undershirt/colored/guard
	shoes = /obj/item/clothing/shoes/boots
	backl = /obj/item/storage/backpack/satchel
	belt = /obj/item/storage/belt/leather/plaquesilver
	beltr = /obj/item/weapon/mace/cudgel
	cloak = /obj/item/clothing/cloak/captain
	backpack_contents = list(
		/obj/item/storage/keyring/captain = 1,
		/obj/item/signal_horn = 1
	)
