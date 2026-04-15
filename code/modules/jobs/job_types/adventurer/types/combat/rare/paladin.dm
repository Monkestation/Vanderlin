/datum/attribute_holder/sheet/job/paladin
	raw_attribute_list = list(
		STAT_STRENGTH = 2,
		STAT_PERCEPTION = 2,
		STAT_INTELLIGENCE = 2,
		STAT_CONSTITUTION = 1,
		STAT_ENDURANCE = 1,
		STAT_SPEED = -2,
		STAT_FORTUNE = 1,
		/datum/attribute/skill/combat/axesmaces = 20,
		/datum/attribute/skill/combat/wrestling = 20,
		/datum/attribute/skill/combat/unarmed = 30,
		/datum/attribute/skill/combat/swords = 30,
		/datum/attribute/skill/combat/shields = 30,
		/datum/attribute/skill/misc/climbing = 10,
		/datum/attribute/skill/misc/athletics = 30,
		/datum/attribute/skill/misc/reading = 30,
		/datum/attribute/skill/magic/holy = 20,
		/datum/attribute/skill/craft/cooking = 10,
		/datum/attribute/skill/labor/mathematics = 30,
	)

/datum/attribute_holder/sheet/job/paladin/extremist
	raw_attribute_list = list(
		STAT_CONSTITUTION = 1,
		STAT_PERCEPTION = 1,
		/datum/attribute/skill/combat/swords = 10,
	)

/datum/job/advclass/combat/paladin
	title = "Paladin"
	tutorial = "Paladins are former noblemen and clerics who have dedicated themselves to great combat prowess. Often, they were promised redemption for past sins if they crusaded in the name of the gods."
	allowed_races = RACES_PLAYER_NONDISCRIMINATED
	outfit = /datum/outfit/paladin
	allowed_patrons = ALL_CLERIC_PATRONS
	total_positions = 1
	category_tags = list(CTAG_ADVENTURER)
	roll_chance = 7

	exp_types_granted = list(EXP_TYPE_ADVENTURER, EXP_TYPE_COMBAT, EXP_TYPE_CLERIC)

	attribute_sheet = /datum/attribute_holder/sheet/job/paladin

	traits = list(
		TRAIT_HEAVYARMOR,
		TRAIT_STEELHEARTED
	)

/datum/job/advclass/combat/paladin/after_spawn(mob/living/carbon/human/spawned, client/player_client)
	. = ..()
	spawned.virginity = TRUE
	switch(spawned.patron?.type)
		if(/datum/patron/divine/astrata)
			spawned.cmode_music = 'sound/music/cmode/church/CombatAstrata.ogg'
		if(/datum/patron/divine/noc)
			spawned.cmode_music = 'sound/music/cmode/church/CombatNoc.ogg'
		if(/datum/patron/divine/dendor)
			spawned.cmode_music = 'sound/music/cmode/garrison/CombatForestGarrison2.ogg'
		if(/datum/patron/divine/abyssor)
			spawned.cmode_music = 'sound/music/cmode/church/CombatAbyssor.ogg'
		if(/datum/patron/divine/necra)
			spawned.cmode_music = 'sound/music/cmode/church/CombatGravekeeper.ogg'
			ADD_TRAIT(spawned, TRAIT_GRAVEROBBER, JOB_TRAIT)
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
			ADD_TRAIT(spawned, TRAIT_BEAUTIFUL, JOB_TRAIT)
		else
			spawned.cmode_music = 'sound/music/cmode/church/CombatInquisitor.ogg'

	if(!spawned.has_language(/datum/language/celestial) && (spawned.patron?.type in ALL_TEMPLE_PATRONS))
		spawned.grant_language(/datum/language/celestial)
		to_chat(spawned, "<span class='info'>I can speak Celestial with ,c before my speech.</span>")

	if(spawned.dna?.species.id == SPEC_ID_HUMEN)
		spawned.dna.species.soundpack_m = new /datum/voicepack/male/knight()

	var/holder = spawned.patron?.devotion_holder
	if(holder)
		var/datum/devotion/devotion = new holder()
		devotion.make_templar()
		devotion.grant_to(spawned)


/datum/outfit/paladin
	name = "Paladin"

	armor = /obj/item/clothing/armor/cuirass
	shirt = /obj/item/clothing/armor/chainmail
	pants = /obj/item/clothing/pants/chainlegs
	shoes = /obj/item/clothing/shoes/boots
	belt = /obj/item/storage/belt/leather/black
	beltl = /obj/item/storage/belt/pouch/coins/mid
	ring = /obj/item/clothing/ring/silver/toper
	cloak = /obj/item/clothing/cloak/tabard
	neck = /obj/item/clothing/neck/psycross/silver
	gloves = /obj/item/clothing/gloves/leather
	backr = /obj/item/weapon/sword/long/judgement
	backl = /obj/item/storage/backpack/satchel
	head = /obj/item/clothing/head/helmet/heavy/bucket
	wrists = /obj/item/clothing/wrists/bracers/jackchain

/datum/outfit/paladin/pre_equip(mob/living/carbon/human/H, visuals_only)
	. = ..()

	switch(H.patron?.type)
		if(/datum/patron/divine/astrata)
			head = /obj/item/clothing/head/helmet/heavy/necked/astrata
			neck = /obj/item/clothing/neck/psycross/silver/divine/astrata
		if(/datum/patron/divine/noc)
			head = /obj/item/clothing/head/helmet/heavy/necked/noc
			neck = /obj/item/clothing/neck/psycross/silver/divine/noc
		if(/datum/patron/divine/dendor)
			head = /obj/item/clothing/head/helmet/heavy/necked/dendorhelm
			neck = /obj/item/clothing/neck/psycross/silver/divine/dendor
		if(/datum/patron/divine/abyssor)
			head = /obj/item/clothing/head/helmet/heavy/necked/abyssor
			neck = /obj/item/clothing/neck/psycross/silver/divine/abyssor
		if(/datum/patron/divine/necra)
			head = /obj/item/clothing/head/helmet/heavy/necked/necra
			neck = /obj/item/clothing/neck/psycross/silver/divine/necra
		if(/datum/patron/divine/ravox)
			head = /obj/item/clothing/head/helmet/heavy/necked/ravox
			neck = /obj/item/clothing/neck/psycross/silver/divine/ravox
		if(/datum/patron/divine/xylix)
			head = /obj/item/clothing/head/helmet/heavy/necked/xylix
			neck = /obj/item/clothing/neck/psycross/silver/divine/xylix
		if(/datum/patron/divine/pestra)
			head = /obj/item/clothing/head/helmet/heavy/necked/pestrahelm
			neck = /obj/item/clothing/neck/psycross/silver/divine/pestra
		if(/datum/patron/divine/malum)
			head = /obj/item/clothing/head/helmet/heavy/necked/malumhelm
			neck = /obj/item/clothing/neck/psycross/silver/divine/malum
		if(/datum/patron/divine/eora)
			mask = /obj/item/clothing/head/roguehood/eora
			head = /obj/item/clothing/head/helmet/sallet/eoran
			neck = /obj/item/clothing/neck/psycross/silver/divine/eora
