/datum/job/templar
	title = "Templar"
	tutorial = "Templars are warriors who have forsaken wealth and station in the service of the church, either from fervent zeal or remorse for past sins.\
	They are vigilant sentinels, guarding priest and altar, steadfast against heresy and shadow-beasts that creep in darkness. \
	But in the quiet of troubled sleep, there is a question left. Does the blood they spill sanctify them, or stain them forever? If service ever demanded it, whose blood would be the price?"
	department_flag = CHURCHMEN
	job_flags = (JOB_ANNOUNCE_ARRIVAL | JOB_SHOW_IN_CREDITS | JOB_EQUIP_RANK | JOB_NEW_PLAYER_JOINABLE)
	display_order = JDO_TEMPLAR
	faction = FACTION_TOWN
	total_positions = 2
	spawn_positions = 2
	bypass_lastclass = TRUE

	allowed_races = RACES_TEMPLAR
	allowed_patrons = ALL_TEMPLAR_PATRONS

	outfit = /datum/outfit/templar
	give_bank_account = 0

	job_bitflag = BITFLAG_CHURCH

	exp_type = list(EXP_TYPE_CHURCH, EXP_TYPE_COMBAT)
	exp_types_granted = list(EXP_TYPE_CHURCH, EXP_TYPE_COMBAT, EXP_TYPE_CLERIC)
	exp_requirements = list(
		EXP_TYPE_CHURCH = 900,
		EXP_TYPE_COMBAT = 900
	)

	jobstats = list(
		STATKEY_STR = 2,
		STATKEY_CON = 2,
		STATKEY_END = 2,
		STATKEY_SPD = -1
	)

	skills = list(
		/datum/skill/combat/wrestling = 3,
		/datum/skill/combat/unarmed = 2,
		/datum/skill/combat/shields = 3,
		/datum/skill/misc/climbing = 1,
		/datum/skill/misc/athletics = 3,
		/datum/skill/misc/reading = 2,
		/datum/skill/magic/holy = 2,
		/datum/skill/misc/medicine = 1,
		/datum/skill/misc/sewing = 2
	)

	traits = list(
		TRAIT_HEAVYARMOR,
		TRAIT_STEELHEARTED,
		TRAIT_KNOWBANDITS
	)

	languages = list(/datum/language/celestial)

/datum/job/templar/after_spawn(mob/living/carbon/human/spawned, client/player_client)
	. = ..()
	switch(spawned.patron?.type)
		if(/datum/patron/divine/astrata)
			spawned.adjust_skillrank(/datum/skill/combat/swords, 4, TRUE)
			spawned.cmode_music = 'sound/music/cmode/church/CombatAstrata.ogg'
		if(/datum/patron/divine/noc)
			spawned.adjust_skillrank(/datum/skill/combat/swords, 4, TRUE)
			spawned.adjust_skillrank(/datum/skill/labor/mathematics, 2, TRUE)
			ADD_TRAIT(spawned, TRAIT_DUALWIELDER, TRAIT_GENERIC)
			spawned.cmode_music = 'sound/music/cmode/church/CombatNoc.ogg'
		if(/datum/patron/divine/dendor)
			spawned.adjust_skillrank(/datum/skill/combat/polearms, 4, TRUE)
			spawned.cmode_music = 'sound/music/cmode/garrison/CombatForestGarrison.ogg'
		if(/datum/patron/divine/necra)
			spawned.adjust_skillrank(/datum/skill/combat/whipsflails, 4, TRUE)
			ADD_TRAIT(spawned, TRAIT_DEADNOSE, TRAIT_GENERIC)
			ADD_TRAIT(spawned, TRAIT_GRAVEROBBER, TRAIT_GENERIC)
			spawned.cmode_music = 'sound/music/cmode/church/CombatGravekeeper.ogg'
		if(/datum/patron/divine/pestra)
			spawned.adjust_skillrank(/datum/skill/combat/knives, 4, TRUE)
			spawned.adjust_skillrank(/datum/skill/craft/alchemy, 2, TRUE)
			ADD_TRAIT(spawned, TRAIT_DUALWIELDER, TRAIT_GENERIC)
			spawned.cmode_music = 'sound/music/cmode/adventurer/CombatMonk.ogg'
		if(/datum/patron/divine/eora)
			spawned.virginity = FALSE
			ADD_TRAIT(spawned, TRAIT_BEAUTIFUL, TRAIT_GENERIC)
			spawned.cmode_music = 'sound/music/cmode/church/CombatEora.ogg'
			var/static/list/selectable = list(
				"Heartstring (Rapier)" = /obj/item/weapon/sword/rapier/eora,
				"Close Caress (Knuckles)" = /obj/item/weapon/knuckles/eora,
			)
			var/choice = spawned.select_equippable(player_client, selectable, message = "Choose Your Specialisation", title = "TEMPLAR")
			if(!choice)
				return
			switch(choice)
				if("Heartstring (Rapier)")
					spawned.adjust_skillrank(/datum/skill/combat/swords, 4, TRUE)
				if("Close Caress (Knuckles)")
					spawned.adjust_skillrank(/datum/skill/combat/unarmed, 2, TRUE)
		if(/datum/patron/divine/ravox)
			spawned.adjust_skillrank(/datum/skill/combat/swords, 4, TRUE)
			spawned.cmode_music = 'sound/music/cmode/church/CombatRavox.ogg'
		if(/datum/patron/divine/malum)
			spawned.adjust_skillrank(/datum/skill/combat/axesmaces, 4, TRUE)
			spawned.cmode_music = 'sound/music/cmode/adventurer/CombatOutlander2.ogg'
		if(/datum/patron/divine/abyssor)
			spawned.adjust_skillrank(/datum/skill/labor/fishing, 2, TRUE)
			spawned.cmode_music = 'sound/music/cmode/church/CombatAbyssor.ogg'
			var/static/list/selectable = list(
				"DepthSeeker (Spear)" = /obj/item/weapon/polearm/spear/abyssor,
				"Barotrauma (Katars)" = /obj/item/weapon/katar/abyssor,
			)
			var/choice = spawned.select_equippable(player_client, selectable, message = "Choose Your Specialisation", title = "TEMPLAR")
			if(!choice)
				return
			switch(choice)
				if("DepthSeeker (Spear)")
					spawned.adjust_skillrank(/datum/skill/combat/polearms, 4, TRUE)
				if("Barotrauma (Katars)")
					spawned.adjust_skillrank(/datum/skill/combat/unarmed, 2, TRUE)
		if(/datum/patron/divine/xylix)
			spawned.adjust_skillrank(/datum/skill/combat/whipsflails, 4, TRUE)
			spawned.cmode_music = 'sound/music/cmode/church/CombatXylix.ogg'

	var/holder = spawned.patron?.devotion_holder
	if(holder)
		var/datum/devotion/devotion = new holder()
		devotion.make_templar()
		devotion.grant_to(spawned)

	if(spawned.dna?.species?.id == SPEC_ID_HUMEN && spawned.gender == MALE)
		spawned.dna.species.soundpack_m = new /datum/voicepack/male/knight()

/datum/outfit/templar
	name = "Templar"
	head = /obj/item/clothing/head/helmet/heavy/necked
	cloak = /obj/item/clothing/cloak/tabard/crusader/tief
	armor = /obj/item/clothing/armor/brigandine
	shirt = /obj/item/clothing/armor/chainmail
	pants = /obj/item/clothing/pants/chainlegs
	shoes = /obj/item/clothing/shoes/boots/armor/light
	backl = /obj/item/storage/backpack/satchel
	backpack_contents = list(/obj/item/storage/keyring/priest = 1,  /obj/item/storage/belt/pouch/coins/poor = 1)
	belt = /obj/item/storage/belt/leather/black
	ring = /obj/item/clothing/ring/silver
	gloves = /obj/item/clothing/gloves/chain
	l_hand = /obj/item/weapon/shield/tower/metal

/datum/outfit/templar/pre_equip(mob/living/carbon/human/equipped_human, visuals_only)
	. = ..()
	switch(equipped_human.patron?.type)
		if(/datum/patron/divine/astrata)
			wrists = /obj/item/clothing/neck/psycross/silver/astrata
			head = /obj/item/clothing/head/helmet/heavy/necked/astrata
			cloak = /obj/item/clothing/cloak/stabard/templar/astrata
			backr = /obj/item/weapon/sword/long/exe/astrata
		if(/datum/patron/divine/noc)
			wrists = /obj/item/clothing/neck/psycross/silver/noc
			head = /obj/item/clothing/head/helmet/heavy/necked/noc
			cloak = /obj/item/clothing/cloak/stabard/templar/noc
			beltl = /obj/item/weapon/sword/sabre/noc
		if(/datum/patron/divine/dendor)
			wrists = /obj/item/clothing/neck/psycross/silver/dendor
			head = /obj/item/clothing/head/helmet/heavy/necked/dendorhelm
			cloak = /obj/item/clothing/cloak/stabard/templar/dendor
			backr = /obj/item/weapon/polearm/halberd/bardiche/dendor
		if(/datum/patron/divine/necra)
			wrists = /obj/item/clothing/neck/psycross/silver/necra
			head = /obj/item/clothing/head/helmet/heavy/necked/necra
			cloak = /obj/item/clothing/cloak/stabard/templar/necra
			beltl = /obj/item/weapon/flail/sflail/necraflail
		if(/datum/patron/divine/pestra)
			wrists = /obj/item/clothing/neck/psycross/silver/pestra
			head = /obj/item/clothing/head/helmet/heavy/necked/pestrahelm
			cloak = /obj/item/clothing/cloak/stabard/templar/pestra
			backpack_contents += /obj/item/reagent_containers/glass/bottle/poison
			beltr = /obj/item/weapon/knife/dagger/steel/pestrasickle
			beltl = /obj/item/weapon/knife/dagger/steel/pestrasickle
		if(/datum/patron/divine/eora)
			head = /obj/item/clothing/head/helmet/sallet/eoran
			wrists = /obj/item/clothing/neck/psycross/silver/eora
			cloak = /obj/item/clothing/cloak/stabard/templar/eora
		if(/datum/patron/divine/ravox)
			wrists = /obj/item/clothing/neck/psycross/silver/ravox
			head = /obj/item/clothing/head/helmet/heavy/necked/ravox
			cloak = /obj/item/clothing/cloak/stabard/templar/ravox
			backr = /obj/item/weapon/sword/long/ravox
		if(/datum/patron/divine/malum)
			wrists = /obj/item/clothing/neck/psycross/silver/malum
			head = /obj/item/clothing/head/helmet/heavy/necked/malumhelm
			cloak = /obj/item/clothing/cloak/stabard/templar/malum
			backr = /obj/item/weapon/hammer/sledgehammer/war/malum
		if(/datum/patron/divine/abyssor)
			head = /obj/item/clothing/head/helmet/heavy/necked/abyssor
			armor = /obj/item/clothing/armor/brigandine/abyssor
			wrists = /obj/item/clothing/neck/psycross/silver/abyssor
			cloak = /obj/item/clothing/cloak/stabard/templar/abyssor
		if(/datum/patron/divine/xylix)
			wrists = /obj/item/clothing/neck/psycross/silver/xylix
			head = /obj/item/clothing/head/helmet/heavy/necked/xylix
			cloak = /obj/item/clothing/cloak/stabard/templar/xylix
			beltl = /obj/item/weapon/whip/xylix
