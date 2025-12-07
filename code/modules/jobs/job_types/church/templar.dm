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

// Medicators and Tritons are hallowed in the eyes of the Ten, no matter how much Astrata dislikes it, Harpies do not get to be templars because they literally cannot wear plate armour nor lift their weapons.
	allowed_races = RACES_TEMPLAR


	allowed_patrons = ALL_TEMPLAR_PATRONS

	outfit = /datum/outfit/templar
	give_bank_account = 0

	allowed_patrons = ALL_TEMPLAR_PATRONS
	job_bitflag = BITFLAG_CHURCH

	exp_type = list(EXP_TYPE_CHURCH, EXP_TYPE_COMBAT)
	exp_types_granted  = list(EXP_TYPE_CHURCH, EXP_TYPE_COMBAT, EXP_TYPE_CLERIC)
	exp_requirements = list(
		EXP_TYPE_CHURCH = 900,
		EXP_TYPE_COMBAT = 900
	)


/datum/outfit/templar
	name = "Templar"

/datum/outfit/templar/pre_equip(mob/living/carbon/human/H)
	..()
	head = /obj/item/clothing/head/helmet/heavy/necked
	cloak = /obj/item/clothing/cloak/tabard/crusader/tief
	armor = /obj/item/clothing/armor/brigandine
	shirt = /obj/item/clothing/armor/chainmail //hauberk > haubergeon, requested by Tyger
	pants = /obj/item/clothing/pants/chainlegs
	shoes = /obj/item/clothing/shoes/boots/armor/light
	backl = /obj/item/storage/backpack/satchel
	//neck = /obj/item/clothing/neck/chaincoif //requested by Tyger
	backpack_contents = list(/obj/item/storage/keyring/priest = 1)
	backr = /obj/item/weapon/shield/tower/metal
	belt = /obj/item/storage/belt/leather/black
	beltl = /obj/item/storage/belt/pouch/coins/poor
	ring = /obj/item/clothing/ring/silver
	gloves = /obj/item/clothing/gloves/chain
	H.adjust_skillrank(/datum/skill/combat/wrestling, 3, TRUE)
	H.adjust_skillrank(/datum/skill/combat/unarmed, 2, TRUE)
	H.adjust_skillrank(/datum/skill/combat/shields, 3, TRUE)
	H.adjust_skillrank(/datum/skill/misc/climbing, 1, TRUE)
	H.adjust_skillrank(/datum/skill/misc/athletics, 3, TRUE)
	H.adjust_skillrank(/datum/skill/misc/reading, 2, TRUE)
	H.adjust_skillrank(/datum/skill/magic/holy, 2, TRUE)
	H.adjust_skillrank(/datum/skill/misc/medicine, 1, TRUE)
	H.adjust_skillrank(/datum/skill/misc/sewing, 2, TRUE)
	H.change_stat(STATKEY_STR, 2)
	H.change_stat(STATKEY_CON, 2)
	H.change_stat(STATKEY_END, 2)
	H.change_stat(STATKEY_SPD, -1)
	if(!H.has_language(/datum/language/celestial)) // For discussing church matters with the other Clergy
		H.grant_language(/datum/language/celestial)
		to_chat(H, "<span class='info'>I can speak Celestial with ,c before my speech.</span>")
	switch(H.patron?.type) //this is a ridiculous way of doing it and it is annoying.
		if(/datum/patron/divine/astrata)
			wrists = /obj/item/clothing/neck/psycross/silver/astrata
			head = /obj/item/clothing/head/helmet/heavy/necked/astrata
			cloak = /obj/item/clothing/cloak/stabard/templar/astrata
			H.cmode_music = 'sound/music/cmode/church/CombatAstrata.ogg'
			H.adjust_skillrank(/datum/skill/combat/swords, 4, TRUE)
		if(/datum/patron/divine/noc)
			wrists = /obj/item/clothing/neck/psycross/silver/noc
			head = /obj/item/clothing/head/helmet/heavy/necked/noc
			cloak = /obj/item/clothing/cloak/stabard/templar/noc
			H.cmode_music = 'sound/music/cmode/church/CombatNoc.ogg'
			H.adjust_skillrank(/datum/skill/combat/swords, 4, TRUE)
			H.adjust_skillrank(/datum/skill/labor/mathematics, 2, TRUE)
			ADD_TRAIT(H, TRAIT_DUALWIELDER, TRAIT_GENERIC)
		if(/datum/patron/divine/dendor)
			wrists = /obj/item/clothing/neck/psycross/silver/dendor
			head = /obj/item/clothing/head/helmet/heavy/necked/dendorhelm
			cloak = /obj/item/clothing/cloak/stabard/templar/dendor
			H.cmode_music = 'sound/music/cmode/garrison/CombatForestGarrison.ogg'
			H.adjust_skillrank(/datum/skill/combat/polearms, 4, TRUE)
		if(/datum/patron/divine/necra)
			wrists = /obj/item/clothing/neck/psycross/silver/necra
			head = /obj/item/clothing/head/helmet/heavy/necked/necra
			cloak = /obj/item/clothing/cloak/stabard/templar/necra
			H.cmode_music = 'sound/music/cmode/church/CombatGravekeeper.ogg'
			H.adjust_skillrank(/datum/skill/combat/whipsflails, 4, TRUE)
			ADD_TRAIT(H, TRAIT_DEADNOSE, TRAIT_GENERIC)//accustomed to death
		if(/datum/patron/divine/pestra)
			wrists = /obj/item/clothing/neck/psycross/silver/pestra
			head = /obj/item/clothing/head/helmet/heavy/necked/pestrahelm
			cloak = /obj/item/clothing/cloak/stabard/templar/pestra
			H.cmode_music = 'sound/music/cmode/adventurer/CombatMonk.ogg'
			beltr = /obj/item/reagent_containers/glass/bottle/poison //Jacksberry poison, Pestrans are Alchemists, Physicians.
			ADD_TRAIT(H, TRAIT_DUALWIELDER, TRAIT_GENERIC)
			H.adjust_skillrank(/datum/skill/combat/knives, 4, TRUE)
			H.adjust_skillrank(/datum/skill/craft/alchemy, 2, TRUE)
		if(/datum/patron/divine/eora)
			head = /obj/item/clothing/head/helmet/sallet/eoran
			wrists = /obj/item/clothing/neck/psycross/silver/eora
			cloak = /obj/item/clothing/cloak/stabard/templar/eora
			H.cmode_music = 'sound/music/cmode/church/CombatEora.ogg'
			H.virginity = FALSE
			ADD_TRAIT(H, TRAIT_BEAUTIFUL, TRAIT_GENERIC)
		if(/datum/patron/divine/ravox)
			wrists = /obj/item/clothing/neck/psycross/silver/ravox
			head = /obj/item/clothing/head/helmet/heavy/necked/ravox
			cloak = /obj/item/clothing/cloak/stabard/templar/ravox
			H.cmode_music = 'sound/music/cmode/church/CombatRavox.ogg'
			H.adjust_skillrank(/datum/skill/combat/swords, 4, TRUE)
		if(/datum/patron/divine/malum)
			wrists = /obj/item/clothing/neck/psycross/silver/malum
			head = /obj/item/clothing/head/helmet/heavy/necked/malumhelm
			cloak = /obj/item/clothing/cloak/stabard/templar/malum
			H.cmode_music = 'sound/music/cmode/adventurer/CombatOutlander2.ogg'
			H.adjust_skillrank(/datum/skill/combat/axesmaces, 4, TRUE)
		if(/datum/patron/divine/abyssor)
			head = /obj/item/clothing/head/helmet/heavy/necked/abyssor
			armor = /obj/item/clothing/armor/brigandine/abyssor
			wrists = /obj/item/clothing/neck/psycross/silver/abyssor
			cloak = /obj/item/clothing/cloak/stabard/templar/abyssor
			H.cmode_music = 'sound/music/cmode/church/CombatAbyssor.ogg'
			H.adjust_skillrank(/datum/skill/labor/fishing, 2, TRUE)
		if(/datum/patron/divine/xylix)
			wrists = /obj/item/clothing/neck/psycross/silver/xylix
			head = /obj/item/clothing/head/helmet/heavy/necked/xylix
			cloak = /obj/item/clothing/cloak/stabard/templar/xylix
			H.cmode_music = 'sound/music/cmode/church/CombatXylix.ogg'
			H.adjust_skillrank(/datum/skill/combat/whipsflails, 4, TRUE)
	ADD_TRAIT(H, TRAIT_HEAVYARMOR, TRAIT_GENERIC)
	ADD_TRAIT(H, TRAIT_STEELHEARTED, TRAIT_GENERIC)
	ADD_TRAIT(H, TRAIT_KNOWBANDITS, TRAIT_GENERIC)

	var/holder = H.patron?.devotion_holder
	if(holder)
		var/datum/devotion/devotion = new holder()
		devotion.make_templar()
		devotion.grant_to(H)
	if(H.dna?.species)
		if(H.dna.species.id == SPEC_ID_HUMEN)
			H.dna.species.soundpack_m = new /datum/voicepack/male/knight()

/datum/outfit/templar/post_equip(mob/living/carbon/human/H, visuals_only)
	. = ..()
	switch(H.patron?.type) //this is a ridiculous way of doing it and it is annoying.
		if(/datum/patron/divine/astrata)
			var/obj/item/weapon/sword/long/exe/astrata/P = new(get_turf(src))
			H.equip_to_appropriate_slot(P)
		if(/datum/patron/divine/noc)
			var/obj/item/weapon/sword/sabre/noc/P = new(get_turf(src))
			H.equip_to_appropriate_slot(P)
		if(/datum/patron/divine/dendor)
			var/obj/item/weapon/polearm/halberd/bardiche/dendor/P = new(get_turf(src))
			H.equip_to_appropriate_slot(P)
		if(/datum/patron/divine/necra)
			var/obj/item/weapon/flail/sflail/necraflail/P = new(get_turf(src))
			H.equip_to_appropriate_slot(P)
		if(/datum/patron/divine/pestra)
			var/obj/item/weapon/knife/dagger/steel/pestrasickle/P = new(get_turf(src))
			H.equip_to_appropriate_slot(P)
			var/obj/item/weapon/knife/dagger/steel/pestrasickle/L = new(get_turf(src))
			H.equip_to_appropriate_slot(L)
		if(/datum/patron/divine/eora)
			var/static/list/selectable = list( \
			"Heartstring (Rapier)" = /obj/item/weapon/sword/rapier/eora, \
			"Close Caress (Knuckles)" = /obj/item/weapon/knuckles/eora, \
			)
			var/choice = H.select_equippable(H, selectable, message = "Choose Your Specialisation", title = "TEMPLAR")
			if(!choice)
				return
			switch(choice)
				if("Heartstring (Rapier)")
					H.adjust_skillrank(/datum/skill/combat/swords, 4, TRUE)
				if("Close Caress (Knuckles)")
					H.adjust_skillrank(/datum/skill/combat/unarmed, 2, TRUE)
		if(/datum/patron/divine/ravox)
			var/obj/item/weapon/sword/long/ravox/P = new(get_turf(src))
			H.equip_to_appropriate_slot(P)
		if(/datum/patron/divine/malum)
			var/obj/item/weapon/hammer/sledgehammer/war/malum/P = new(get_turf(src))
			H.put_in_hands(P, forced = TRUE)
		if(/datum/patron/divine/abyssor)
			var/static/list/selectable = list( \
			"DepthSeeker (Spear)" = /obj/item/weapon/polearm/spear/abyssor, \
			"Barotrauma (Katars)" = /obj/item/weapon/katar/abyssor, \
			)
			var/choice = H.select_equippable(H, selectable, message = "Choose Your Specialisation", title = "TEMPLAR")
			if(!choice)
				return
			switch(choice)
				if("DepthSeeker (Spear)")
					H.adjust_skillrank(/datum/skill/combat/polearms, 4, TRUE)
				if("Barotrauma (Katars)")
					H.adjust_skillrank(/datum/skill/combat/unarmed, 2, TRUE)
		if(/datum/patron/divine/xylix)
			var/obj/item/weapon/whip/xylix/P = new(get_turf(src))
			H.equip_to_appropriate_slot(P)
