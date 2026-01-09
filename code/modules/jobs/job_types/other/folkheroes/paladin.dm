/datum/job/advclass/combat/paladin
	title = "Paladin"
	tutorial = "Paladins are former noblemen and clerics who have dedicated themselves to great combat prowess. Often, they were promised redemption for past sins if they crusaded in the name of the gods."
	allowed_races = RACES_PLAYER_NONDISCRIMINATED
	outfit = /datum/outfit/folkhero/paladin
	allowed_patrons = ALL_PALADIN_PATRONS
	total_positions = 1
	category_tags = list(CTAG_FOLKHEROES)

	exp_types_granted = list(EXP_TYPE_ADVENTURER, EXP_TYPE_COMBAT, EXP_TYPE_CLERIC)

	skills = list(
		/datum/skill/combat/axesmaces = 2,
		/datum/skill/combat/wrestling = 2,
		/datum/skill/combat/unarmed = 3,
		/datum/skill/combat/swords = 3,
		/datum/skill/combat/shields = 3,
		/datum/skill/misc/climbing = 1,
		/datum/skill/misc/athletics = 3,
		/datum/skill/misc/reading = 3,
		/datum/skill/magic/holy = 2,
		/datum/skill/craft/cooking = 1,
		/datum/skill/labor/mathematics = 3,
	)

	jobstats = list(
		STATKEY_STR = 2,
		STATKEY_PER = 2,
		STATKEY_INT = 2,
		STATKEY_CON = 1,
		STATKEY_END = 1,
		STATKEY_SPD = -2,
		STATKEY_LCK = 1,
	)

	traits = list(
		TRAIT_HEAVYARMOR,
		TRAIT_NOBLE,
	)

/datum/job/advclass/combat/paladin/after_spawn(mob/living/carbon/human/spawned, client/player_client)
	. = ..()

	spawned.virginity = TRUE

	switch(spawned.patron?.type)
		if(/datum/patron/psydon, /datum/patron/psydon/extremist)
			spawned.cmode_music = 'sound/music/cmode/church/CombatInquisitor.ogg'
			spawned.adjust_skillrank(/datum/skill/combat/swords, 1, TRUE)
			spawned.adjust_stat_modifier(STATMOD_JOB, STATKEY_CON, 1)
			spawned.adjust_stat_modifier(STATMOD_JOB, STATKEY_PER, 1)
			spawned.grant_language(/datum/language/oldpsydonic)
			ADD_TRAIT(spawned, TRAIT_PSYDONIAN_GRIT, TRAIT_GENERIC)
		if(/datum/patron/divine/astrata)
			spawned.cmode_music = 'sound/music/cmode/church/CombatAstrata.ogg'
		if(/datum/patron/divine/noc)
			spawned.cmode_music = 'sound/music/cmode/church/CombatNoc.ogg'
		if(/datum/patron/divine/dendor)
			spawned.cmode_music = 'sound/music/cmode/garrison/CombatForestGarrison.ogg'
		if(/datum/patron/divine/abyssor)
			spawned.cmode_music = 'sound/music/cmode/church/CombatAbyssor.ogg'
		if(/datum/patron/divine/necra)
			spawned.cmode_music = 'sound/music/cmode/church/CombatGravekeeper.ogg'
			ADD_TRAIT(spawned, TRAIT_GRAVEROBBER, TRAIT_GENERIC)
		if(/datum/patron/divine/ravox)
			spawned.cmode_music = 'sound/music/cmode/church/CombatRavox.ogg'
		if(/datum/patron/divine/xylix)
			spawned.cmode_music = 'sound/music/cmode/church/CombatXylix.ogg'
		if(/datum/patron/divine/pestra)
			spawned.cmode_music = 'sound/music/cmode/adventurer/CombatMonk.ogg'
		if(/datum/patron/divine/malum)
			spawned.cmode_music = 'sound/music/cmode/adventurer/CombatOutlander2.ogg'
		if(/datum/patron/divine/eora)
			spawned.cmode_music = 'sound/music/cmode/church/CombatEora.ogg'
			spawned.virginity = FALSE
			ADD_TRAIT(spawned, TRAIT_BEAUTIFUL, TRAIT_GENERIC)
		else
			spawned.cmode_music = 'sound/music/cmode/church/CombatInquisitor.ogg'

	if(!spawned.has_language(/datum/language/celestial) && (spawned.patron?.type in ALL_TEMPLE_PATRONS) && spawned.patron?.type != /datum/patron/psydon)
		spawned.grant_language(/datum/language/celestial)
		to_chat(spawned, "<span class='info'>I can speak Celestial with ,c before my speech.</span>")

	if(spawned.dna?.species.id == SPEC_ID_HUMEN)
		spawned.dna.species.soundpack_m = new /datum/voicepack/male/knight()

	var/holder = spawned.patron?.devotion_holder
	if(holder)
		var/datum/devotion/devotion = new holder()
		devotion.make_templar()
		devotion.grant_to(spawned)

/datum/outfit/folkhero/paladin
	name = "Paladin (Folkhero)"

	armor = /obj/item/clothing/armor/plate
	shirt = /obj/item/clothing/armor/chainmail
	pants = /obj/item/clothing/pants/platelegs
	shoes = /obj/item/clothing/shoes/boots/armor
	belt = /obj/item/storage/belt/leather/steel
	beltl = /obj/item/storage/belt/pouch/coins/mid
	ring = /obj/item/clothing/ring/silver/toper
	cloak = /obj/item/clothing/cloak/tabard/crusader
	neck = /obj/item/clothing/neck/chaincoif
	gloves = /obj/item/clothing/gloves/plate
	backl = /obj/item/weapon/sword/long/judgement
	head = /obj/item/clothing/head/helmet/heavy/bucket
	wrists = /obj/item/clothing/neck/psycross/silver

/datum/outfit/folkhero/paladin/pre_equip(mob/living/carbon/human/H, visuals_only)
	. = ..()

	switch(H.patron?.type)
		if(/datum/patron/psydon, /datum/patron/psydon/extremist)
			head = /obj/item/clothing/head/helmet/heavy/bucket/gold
			wrists = /obj/item/clothing/neck/psycross/g
		if(/datum/patron/divine/astrata)
			head = /obj/item/clothing/head/helmet/heavy/necked/astrata
			wrists = /obj/item/clothing/neck/psycross/silver/astrata
		if(/datum/patron/divine/noc)
			head = /obj/item/clothing/head/helmet/heavy/necked/noc
			wrists = /obj/item/clothing/neck/psycross/silver/noc
		if(/datum/patron/divine/dendor)
			head = /obj/item/clothing/head/helmet/heavy/necked/dendorhelm
			wrists = /obj/item/clothing/neck/psycross/silver/dendor
		if(/datum/patron/divine/abyssor)
			head = /obj/item/clothing/head/helmet/heavy/necked/abyssor
			wrists = /obj/item/clothing/neck/psycross/silver/abyssor
		if(/datum/patron/divine/necra)
			head = /obj/item/clothing/head/helmet/heavy/necked/necra
			wrists = /obj/item/clothing/neck/psycross/silver/necra
		if(/datum/patron/divine/ravox)
			head = /obj/item/clothing/head/helmet/heavy/necked/ravox
			wrists = /obj/item/clothing/neck/psycross/silver/ravox
		if(/datum/patron/divine/xylix)
			head = /obj/item/clothing/head/helmet/heavy/necked/xylix
			wrists = /obj/item/clothing/neck/psycross/silver/xylix
		if(/datum/patron/divine/pestra)
			head = /obj/item/clothing/head/helmet/heavy/necked/pestrahelm
			wrists = /obj/item/clothing/neck/psycross/silver/pestra
		if(/datum/patron/divine/malum)
			head = /obj/item/clothing/head/helmet/heavy/necked/malumhelm
			wrists = /obj/item/clothing/neck/psycross/silver/malum
		if(/datum/patron/divine/eora)
			head = /obj/item/clothing/head/helmet/sallet/eoran
			wrists = /obj/item/clothing/neck/psycross/silver/eora
