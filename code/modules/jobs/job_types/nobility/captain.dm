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
	honorary = "Captain"

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

	jobstats = list(
		STATKEY_STR = 2,
		STATKEY_PER = 2,
		STATKEY_INT = 1,
		STATKEY_CON = 1,
		STATKEY_END = 2
	)

	skills = list(
		/datum/skill/combat/swords = 3,
		/datum/skill/combat/wrestling = 4,
		/datum/skill/combat/axesmaces = 4,
		/datum/skill/combat/shields = 2,
		/datum/skill/combat/unarmed = 3,
		/datum/skill/combat/knives = 3,
		/datum/skill/combat/polearms = 3,
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
		TRAIT_NOBLE_BLOOD,
		TRAIT_NOBLE_POWER,
		TRAIT_HEAVYARMOR,
	)
	mind_traits = list(TRAIT_KNOWBANDITS)

/datum/job/captain/after_spawn(mob/living/carbon/human/spawned, client/player_client)
	. = ..()
	add_verb(spawned, /mob/proc/haltyell)

	if(spawned.dna?.species?.id == SPEC_ID_HUMEN)
		spawned.dna.species.soundpack_m = new /datum/voicepack/male/knight()

	var/static/list/selectableweapon = list(
		"Law and Order" = list(/obj/item/weapon/sword/sabre/captain, /obj/item/weapon/shield/tower/buckleriron/captain),
		"Deliverer of Justice" = /obj/item/weapon/polearm/halberd/bardiche/captain,
	)

	var/choice = spawned.select_equippable(player_client, selectableweapon, message = "Choose thy blade", title = "CAPTAIN")
	if(!choice)
		return
	switch(choice)
		if("Law and Order")
			spawned.clamped_adjust_skillrank(/datum/skill/combat/swords, 2, 5, TRUE)
			spawned.clamped_adjust_skillrank(/datum/skill/combat/shields, 2, 4, TRUE)
		if("Deliverer of Justice")
			spawned.clamped_adjust_skillrank(/datum/skill/combat/polearms, 2, 5, TRUE)

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
	belt = /obj/item/storage/belt/leather/plaquesilver
	beltr = /obj/item/weapon/mace/cudgel
	cloak = /obj/item/clothing/cloak/captain
	backpack_contents = list(
		/obj/item/storage/keyring/captain = 1,
		/obj/item/signal_horn = 1
	)
