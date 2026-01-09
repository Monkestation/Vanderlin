/datum/job/advclass/wretch/heretic
	title = "Iconoclast"
	tutorial = "You are either a heretic or a fanatic, spurned by the church, cast out from society - frowned upon by the tens for your type of faith."
	allowed_sexes = list(MALE, FEMALE)
	allowed_races = RACES_PLAYER_ALL
	allowed_patrons = ALL_ICONOCLAST_PATRONS
	outfit = /datum/outfit/wretch/heretic
	total_positions = 2
	exp_type = list(EXP_TYPE_COMBAT, EXP_TYPE_CLERIC)
	exp_types_granted = list(EXP_TYPE_COMBAT, EXP_TYPE_CLERIC)

	jobstats = list(
		STATKEY_STR = 2,
		STATKEY_CON = 2,
		STATKEY_END = 2
	)

	skills = list(
		/datum/skill/combat/wrestling = 3,
		/datum/skill/combat/unarmed = 2,
		/datum/skill/combat/shields = 3,
		/datum/skill/misc/climbing = 1,
		/datum/skill/misc/athletics = 3,
		/datum/skill/misc/reading = 2,
		/datum/skill/magic/holy = 3,
		/datum/skill/misc/medicine = 1,
		/datum/skill/misc/sewing = 2
	)

	traits = list(
		TRAIT_STEELHEARTED,
		TRAIT_HEAVYARMOR,
		TRAIT_FANATICAL,
		TRAIT_INHUMENCAMP
	)

/datum/job/advclass/wretch/heretic/after_spawn(mob/living/carbon/human/spawned, client/player_client)
	. = ..()

	switch(spawned.patron?.type)
		if(/datum/patron/divine/astrata)
			spawned.adjust_skillrank(/datum/skill/combat/swords, 4, TRUE)
			spawned.cmode_music = 'sound/music/cmode/church/CombatAstrata.ogg'
		if(/datum/patron/divine/noc)
			spawned.adjust_skillrank(/datum/skill/combat/swords, 4, TRUE)
			ADD_TRAIT(spawned, TRAIT_DUALWIELDER, TRAIT_GENERIC)
			spawned.cmode_music = 'sound/music/cmode/church/CombatNoc.ogg'
		if(/datum/patron/divine/dendor)
			spawned.adjust_skillrank(/datum/skill/combat/polearms, 4, TRUE)
			spawned.cmode_music = 'sound/music/cmode/garrison/CombatForestGarrison.ogg'
		if(/datum/patron/divine/necra)
			spawned.adjust_skillrank(/datum/skill/combat/whipsflails, 4, TRUE)
			spawned.cmode_music = 'sound/music/cmode/church/CombatGravekeeper.ogg'
			ADD_TRAIT(spawned, TRAIT_GRAVEROBBER, TRAIT_GENERIC)
		if(/datum/patron/divine/pestra)
			spawned.adjust_skillrank(/datum/skill/combat/knives, 4, TRUE)
			spawned.adjust_skillrank(/datum/skill/craft/alchemy, 2, TRUE)
			ADD_TRAIT(spawned, TRAIT_DUALWIELDER, TRAIT_GENERIC)
			spawned.cmode_music = 'sound/music/cmode/adventurer/CombatMonk.ogg'
		if(/datum/patron/divine/eora)
			spawned.virginity = FALSE
			ADD_TRAIT(spawned, TRAIT_BEAUTIFUL, TRAIT_GENERIC)
			spawned.adjust_skillrank(/datum/skill/combat/swords, 4, TRUE)
			spawned.cmode_music = 'sound/music/cmode/church/CombatEora.ogg'
		if(/datum/patron/divine/ravox)
			spawned.adjust_skillrank(/datum/skill/combat/swords, 4, TRUE)
			spawned.cmode_music = 'sound/music/cmode/church/CombatRavox.ogg'
		if(/datum/patron/divine/malum)
			spawned.adjust_skillrank(/datum/skill/combat/axesmaces, 4, TRUE)
			spawned.cmode_music = 'sound/music/cmode/adventurer/CombatOutlander2.ogg'
		if(/datum/patron/divine/abyssor)
			spawned.adjust_skillrank(/datum/skill/labor/fishing, 1, TRUE)
			spawned.adjust_skillrank(/datum/skill/combat/polearms, 4, TRUE)
			spawned.cmode_music = 'sound/music/cmode/church/CombatAbyssor.ogg'
		if(/datum/patron/divine/xylix)
			spawned.adjust_skillrank(/datum/skill/combat/whipsflails, 4, TRUE)
			spawned.cmode_music = 'sound/music/cmode/church/CombatXylix.ogg'
		if(/datum/patron/inhumen/graggar)
			spawned.adjust_skillrank(/datum/skill/combat/axesmaces, 4, TRUE)
			ADD_TRAIT(spawned, TRAIT_STRONGBITE, TRAIT_GENERIC)
			spawned.cmode_music = 'sound/music/cmode/antag/combat_werewolf.ogg'
			ADD_TRAIT(spawned, TRAIT_STRONGBITE, TRAIT_GENERIC)
		if(/datum/patron/inhumen/graggar_zizo)
			spawned.adjust_skillrank(/datum/skill/combat/axesmaces, 4, TRUE)
			spawned.cmode_music = 'sound/music/cmode/antag/combat_werewolf.ogg'
		if(/datum/patron/inhumen/zizo)
			spawned.adjust_skillrank(/datum/skill/combat/swords, 4, TRUE)
			spawned.cmode_music = 'sound/music/cmode/antag/combat_cult.ogg'
			spawned.grant_language(/datum/language/undead)
		if(/datum/patron/inhumen/matthios)
			spawned.adjust_skillrank(/datum/skill/combat/whipsflails, 4, TRUE)
			spawned.cmode_music = 'sound/music/cmode/antag/CombatBandit1.ogg'
		if(/datum/patron/inhumen/baotha)
			spawned.adjust_skillrank(/datum/skill/combat/knives, 4, TRUE)
			spawned.adjust_skillrank(/datum/skill/craft/alchemy, 2, TRUE)
			ADD_TRAIT(spawned, TRAIT_DUALWIELDER, TRAIT_GENERIC)
			spawned.cmode_music = 'sound/music/cmode/antag/CombatBaotha.ogg'
		if(/datum/patron/psydon,  /datum/patron/psydon/extremist)
			spawned.adjust_skillrank(/datum/skill/combat/swords, 4, TRUE)
			spawned.cmode_music = 'sound/music/cmode/church/CombatInquisitor.ogg'
			spawned.grant_language(/datum/language/oldpsydonic)
		else
			spawned.adjust_skillrank(/datum/skill/combat/swords, 4, TRUE)
			spawned.cmode_music = 'sound/music/cmode/church/CombatInquisitor.ogg'

	if(!spawned.has_language(/datum/language/celestial) && (spawned.patron?.type in ALL_TEMPLE_PATRONS))
		spawned.grant_language(/datum/language/celestial)

	var/holder = spawned.patron?.devotion_holder
	if(holder)
		var/datum/devotion/devotion = new holder()
		devotion.make_acolyte()
		devotion.grant_to(spawned)

	if(spawned.dna?.species?.id == SPEC_ID_HUMEN && spawned.gender == MALE)
		spawned.dna.species.soundpack_m = new /datum/voicepack/male/knight()

	wretch_select_bounty(spawned)

/datum/outfit/wretch/heretic
	name = "Iconoclast (Wretch)"
	head = /obj/item/clothing/head/helmet/heavy/necked
	cloak = /obj/item/clothing/cloak/tabard/crusader/tief
	armor = /obj/item/clothing/armor/brigandine
	shirt = /obj/item/clothing/armor/chainmail
	pants = /obj/item/clothing/pants/chainlegs
	shoes = /obj/item/clothing/shoes/boots/armor/light
	backl = /obj/item/storage/backpack/satchel
	backpack_contents = list(
		/obj/item/weapon/knife/hunting = 1,
		/obj/item/storage/belt/pouch/coins/poor = 1,
		/obj/item/rope/chain = 1,
		/obj/item/reagent_containers/glass/bottle/stronghealthpot = 1,
	)
	belt = /obj/item/storage/belt/leather/black
	ring = /obj/item/clothing/ring/silver
	gloves = /obj/item/clothing/gloves/chain
	l_hand =  /obj/item/weapon/shield/tower/metal

/datum/outfit/wretch/heretic/pre_equip(mob/living/carbon/human/equipped_human, visuals_only)
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
			backpack_contents += /obj/item/reagent_containers/glass/bottle/strongpoison
			beltr = /obj/item/weapon/knife/dagger/steel/pestrasickle
			beltl = /obj/item/weapon/knife/dagger/steel/pestrasickle
		if(/datum/patron/divine/eora)
			head = /obj/item/clothing/head/helmet/sallet/eoran
			wrists = /obj/item/clothing/neck/psycross/silver/eora
			cloak = /obj/item/clothing/cloak/stabard/templar/eora
			beltr = /obj/item/weapon/sword/rapier/eora
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
			backr = /obj/item/weapon/polearm/spear/abyssor
		if(/datum/patron/divine/xylix)
			wrists = /obj/item/clothing/neck/psycross/silver/xylix
			head = /obj/item/clothing/head/helmet/heavy/necked/xylix
			cloak = /obj/item/clothing/cloak/stabard/templar/xylix
			beltl = /obj/item/weapon/whip/xylix
		if(/datum/patron/inhumen/graggar)
			head = /obj/item/clothing/head/helmet/heavy/graggar
			armor = /obj/item/clothing/armor/plate/full/graggar
			neck = /obj/item/clothing/neck/gorget
			gloves = /obj/item/clothing/gloves/plate/graggar
			pants = /obj/item/clothing/pants/platelegs/graggar
			shoes = /obj/item/clothing/shoes/boots/armor/graggar
			cloak = /obj/item/clothing/cloak/graggar
			backr = /obj/item/weapon/greataxe/steel/doublehead/graggar
		if(/datum/patron/inhumen/graggar_zizo)
			head = /obj/item/clothing/head/helmet/heavy/graggar
			armor = /obj/item/clothing/armor/plate/full/graggar
			neck = /obj/item/clothing/neck/gorget
			gloves = /obj/item/clothing/gloves/plate/graggar
			pants = /obj/item/clothing/pants/platelegs/graggar
			shoes = /obj/item/clothing/shoes/boots/armor/graggar
			cloak = /obj/item/clothing/cloak/graggar
			backr = /obj/item/weapon/greataxe/steel/doublehead/graggar
		if(/datum/patron/inhumen/zizo)
			head = /obj/item/clothing/head/helmet/visored/zizo
			armor = /obj/item/clothing/armor/plate/full/zizo
			neck = /obj/item/clothing/neck/gorget
			gloves = /obj/item/clothing/gloves/plate/zizo
			pants = /obj/item/clothing/pants/platelegs/zizo
			shoes = /obj/item/clothing/shoes/boots/armor/zizo
			backr = /obj/item/weapon/sword/long/greatsword/zizo
		if(/datum/patron/inhumen/matthios)
			head = /obj/item/clothing/head/helmet/heavy/matthios
			armor = /obj/item/clothing/armor/plate/full/matthios
			neck = /obj/item/clothing/neck/gorget
			gloves = /obj/item/clothing/gloves/plate/matthios
			pants = /obj/item/clothing/pants/platelegs/matthios
			shoes = /obj/item/clothing/shoes/boots/armor/matthios
			backr = /obj/item/weapon/flail/peasantwarflail/matthios
		if(/datum/patron/inhumen/baotha)
			head = /obj/item/clothing/head/helmet/heavy/baotha
			mask = /obj/item/clothing/face/spectacles/sglasses
			neck = /obj/item/clothing/neck/gorget
			armor = /obj/item/clothing/armor/plate
			gloves = /obj/item/clothing/gloves/plate
			pants = /obj/item/clothing/pants/platelegs
			shoes = /obj/item/clothing/shoes/boots/armor
			beltr = /obj/item/weapon/knife/dagger/steel/dirk/baotha
			beltl = /obj/item/weapon/knife/dagger/steel/dirk/baotha
		if(/datum/patron/psydon,  /datum/patron/psydon/extremist)
			wrists = /obj/item/clothing/neck/psycross/g
			armor = /obj/item/clothing/armor/cuirass/fluted
			cloak = /obj/item/clothing/cloak/psydontabard
			gloves = /obj/item/clothing/gloves/chain/psydon
			shoes = /obj/item/clothing/shoes/psydonboots
			head = /obj/item/clothing/head/helmet/heavy/psydonhelm
			beltr = /obj/item/weapon/sword/long/psydon
			beltl = /obj/item/weapon/scabbard/sword
		else
			head = /obj/item/clothing/head/helmet/heavy/bucket
			wrists = /obj/item/clothing/neck/psycross/silver/undivided
			cloak = /obj/item/clothing/cloak/templar/undivided
			beltr = /obj/item/weapon/sword/long/decorated
