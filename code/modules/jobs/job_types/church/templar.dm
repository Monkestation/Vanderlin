/datum/attribute_holder/sheet/job/templar
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
		/datum/attribute/skill/magic/holy = 20,
		/datum/attribute/skill/misc/medicine = 10,
		/datum/attribute/skill/misc/sewing = 20
	)

/datum/attribute_holder/sheet/job/templar/patron/astrata
	raw_attribute_list = list(
		/datum/attribute/skill/combat/swords = 40
	)

/datum/attribute_holder/sheet/job/templar/patron/noc
	raw_attribute_list = list(
		/datum/attribute/skill/combat/swords = 40,
		/datum/attribute/skill/labor/mathematics = 20
	)

/datum/attribute_holder/sheet/job/templar/patron/dendor
	raw_attribute_list = list(
		/datum/attribute/skill/combat/polearms = 40
	)

/datum/attribute_holder/sheet/job/templar/patron/necra
	raw_attribute_list = list(
		/datum/attribute/skill/combat/whipsflails = 40
	)

/datum/attribute_holder/sheet/job/templar/patron/pestra
	raw_attribute_list = list(
		/datum/attribute/skill/combat/knives = 40,
		/datum/attribute/skill/craft/alchemy = 20
	)

/datum/attribute_holder/sheet/job/templar/patron/ravox
	raw_attribute_list = list(
		/datum/attribute/skill/combat/swords = 40
	)

/datum/attribute_holder/sheet/job/templar/patron/malum
	raw_attribute_list = list(
		/datum/attribute/skill/combat/axesmaces = 40
	)

/datum/attribute_holder/sheet/job/templar/patron/abyssor
	raw_attribute_list = list(
		/datum/attribute/skill/labor/fishing = 20
	)

/datum/attribute_holder/sheet/job/templar/patron/xylix
	raw_attribute_list = list(
		/datum/attribute/skill/combat/whipsflails = 40
	)

/datum/attribute_holder/sheet/job/templar/patron/eora/rapier
	raw_attribute_list = list(
		/datum/attribute/skill/combat/swords = 40
	)

/datum/attribute_holder/sheet/job/templar/patron/eora/knuckles
	raw_attribute_list = list(
		/datum/attribute/skill/combat/unarmed = 20
	)

/datum/attribute_holder/sheet/job/templar/patron/abyssor/spear
	raw_attribute_list = list(
		/datum/attribute/skill/combat/polearms = 40
	)

/datum/attribute_holder/sheet/job/templar/patron/abyssor/katars
	raw_attribute_list = list(
		/datum/attribute/skill/combat/unarmed = 20
	)

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

	attribute_sheet = /datum/attribute_holder/sheet/job/templar

	traits = list(
		TRAIT_HEAVYARMOR,
		TRAIT_STEELHEARTED,
	)
	mind_traits = list(TRAIT_KNOWBANDITS)

	languages = list(/datum/language/celestial)

/datum/job/templar/after_spawn(mob/living/carbon/human/spawned, client/player_client)
	. = ..()
	switch(spawned.patron?.type)
		if(/datum/patron/divine/astrata)
			spawned.attributes?.add_sheet(/datum/attribute_holder/sheet/job/templar/patron/astrata)
			spawned.cmode_music = 'sound/music/cmode/church/CombatAstrata.ogg'
		if(/datum/patron/divine/noc)
			spawned.attributes?.add_sheet(/datum/attribute_holder/sheet/job/templar/patron/noc)
			ADD_TRAIT(spawned, TRAIT_DUALWIELDER, TRAIT_GENERIC)
			spawned.cmode_music = 'sound/music/cmode/church/CombatNoc.ogg'
		if(/datum/patron/divine/dendor)
			spawned.attributes?.add_sheet(/datum/attribute_holder/sheet/job/templar/patron/dendor)
			spawned.cmode_music = 'sound/music/cmode/church/CombatDendor.ogg'
		if(/datum/patron/divine/necra)
			spawned.attributes?.add_sheet(/datum/attribute_holder/sheet/job/templar/patron/necra)
			ADD_TRAIT(spawned, TRAIT_DEADNOSE, TRAIT_GENERIC)
			ADD_TRAIT(spawned, TRAIT_GRAVEROBBER, TRAIT_GENERIC)
			spawned.cmode_music = 'sound/music/cmode/church/CombatGravekeeper.ogg'
		if(/datum/patron/divine/pestra)
			spawned.attributes?.add_sheet(/datum/attribute_holder/sheet/job/templar/patron/pestra)
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
					spawned.attributes?.add_sheet(/datum/attribute_holder/sheet/job/templar/patron/eora/rapier)
				if("Close Caress (Knuckles)")
					spawned.attributes?.add_sheet(/datum/attribute_holder/sheet/job/templar/patron/eora/knuckles)
		if(/datum/patron/divine/ravox)
			spawned.attributes?.add_sheet(/datum/attribute_holder/sheet/job/templar/patron/ravox)
			spawned.cmode_music = 'sound/music/cmode/church/CombatRavox.ogg'
		if(/datum/patron/divine/malum)
			spawned.attributes?.add_sheet(/datum/attribute_holder/sheet/job/templar/patron/malum)
			spawned.cmode_music = 'sound/music/cmode/adventurer/CombatOutlander2.ogg'
		if(/datum/patron/divine/abyssor)
			spawned.attributes?.add_sheet(/datum/attribute_holder/sheet/job/templar/patron/abyssor)
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
					spawned.attributes?.add_sheet(/datum/attribute_holder/sheet/job/templar/patron/abyssor/spear)
				if("Barotrauma (Katars)")
					spawned.attributes?.add_sheet(/datum/attribute_holder/sheet/job/templar/patron/abyssor/katars)
		if(/datum/patron/divine/xylix)
			spawned.attributes?.add_sheet(/datum/attribute_holder/sheet/job/templar/patron/xylix)
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
			wrists = /obj/item/clothing/neck/psycross/silver/divine/astrata
			head = /obj/item/clothing/head/helmet/heavy/necked/astrata
			cloak = /obj/item/clothing/cloak/stabard/templar/astrata
			backr = /obj/item/weapon/sword/long/exe/astrata
		if(/datum/patron/divine/noc)
			wrists = /obj/item/clothing/neck/psycross/silver/divine/noc
			head = /obj/item/clothing/head/helmet/heavy/necked/noc
			cloak = /obj/item/clothing/cloak/stabard/templar/noc
			beltl = /obj/item/weapon/sword/sabre/noc
		if(/datum/patron/divine/dendor)
			wrists = /obj/item/clothing/neck/psycross/silver/divine/dendor
			head = /obj/item/clothing/head/helmet/heavy/necked/dendorhelm
			cloak = /obj/item/clothing/cloak/stabard/templar/dendor
			backr = /obj/item/weapon/polearm/halberd/bardiche/dendor
		if(/datum/patron/divine/necra)
			wrists = /obj/item/clothing/neck/psycross/silver/divine/necra
			head = /obj/item/clothing/head/helmet/heavy/necked/necra
			cloak = /obj/item/clothing/cloak/stabard/templar/necra
			beltl = /obj/item/weapon/flail/sflail/necraflail
		if(/datum/patron/divine/pestra)
			wrists = /obj/item/clothing/neck/psycross/silver/divine/pestra
			head = /obj/item/clothing/head/helmet/heavy/necked/pestrahelm
			cloak = /obj/item/clothing/cloak/stabard/templar/pestra
			backpack_contents += /obj/item/reagent_containers/glass/bottle/poison
			beltr = /obj/item/weapon/knife/dagger/steel/pestrasickle
			beltl = /obj/item/weapon/knife/dagger/steel/pestrasickle
		if(/datum/patron/divine/eora)
			head = /obj/item/clothing/head/helmet/sallet/eoran
			wrists = /obj/item/clothing/neck/psycross/silver/divine/eora
			cloak = /obj/item/clothing/cloak/stabard/templar/eora
		if(/datum/patron/divine/ravox)
			wrists = /obj/item/clothing/neck/psycross/silver/divine/ravox
			head = /obj/item/clothing/head/helmet/heavy/necked/ravox
			cloak = /obj/item/clothing/cloak/stabard/templar/ravox
			backr = /obj/item/weapon/sword/long/ravox
		if(/datum/patron/divine/malum)
			wrists = /obj/item/clothing/neck/psycross/silver/divine/malum
			head = /obj/item/clothing/head/helmet/heavy/necked/malumhelm
			cloak = /obj/item/clothing/cloak/stabard/templar/malum
			backr = /obj/item/weapon/hammer/sledgehammer/war/malum
		if(/datum/patron/divine/abyssor)
			head = /obj/item/clothing/head/helmet/heavy/necked/abyssor
			armor = /obj/item/clothing/armor/brigandine/abyssor
			wrists = /obj/item/clothing/neck/psycross/silver/divine/abyssor
			cloak = /obj/item/clothing/cloak/stabard/templar/abyssor
		if(/datum/patron/divine/xylix)
			wrists = /obj/item/clothing/neck/psycross/silver/divine/xylix
			head = /obj/item/clothing/head/helmet/heavy/necked/xylix
			cloak = /obj/item/clothing/cloak/stabard/templar/xylix
			beltl = /obj/item/weapon/whip/xylix
