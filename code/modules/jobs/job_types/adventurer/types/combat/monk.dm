/datum/attribute_holder/sheet/job/monk
	attribute_variance = list(
		/datum/attribute/skill/combat/polearms = list(10, 20),
		/datum/attribute/skill/misc/athletics = list(20, 30)
	)
	raw_attribute_list = list(
		STAT_STRENGTH = 2,
		STAT_CONSTITUTION = 2,
		STAT_ENDURANCE = 2,
		STAT_PERCEPTION = -1,
		STAT_SPEED = 2,
		/datum/attribute/skill/misc/reading = 30,
		/datum/attribute/skill/combat/unarmed = 40,
		/datum/attribute/skill/combat/wrestling = 30,
		/datum/attribute/skill/misc/sewing = 20,
		/datum/attribute/skill/misc/medicine = 10,
		/datum/attribute/skill/misc/climbing = 40,
	)

/datum/attribute_holder/sheet/job/monk/kobold
	attribute_variance = list()
	raw_attribute_list = list(
		STAT_STRENGTH = 2,
		STAT_SPEED = -1,
	)
/datum/job/advclass/combat/monk
	title = "Monk"
	allowed_races = RACES_PLAYER_NONHERETICAL
	allowed_patrons = ALL_TEMPLE_PATRONS
	tutorial = "A traveling monk of the Ten, unmatched in the unarmed arts, with an unwavering devotion to their patron God's Justice."
	total_positions = 4
	outfit = /datum/outfit/adventurer/monk

	category_tags = list(CTAG_ADVENTURER)
	cmode_music = 'sound/music/cmode/adventurer/CombatMonk.ogg'
	exp_types_granted = list(EXP_TYPE_ADVENTURER, EXP_TYPE_COMBAT, EXP_TYPE_CLERIC)
	allowed_patrons = ALL_TEMPLE_PATRONS  // randomize patron if not in ten

	attribute_sheet = /datum/attribute_holder/sheet/job/monk

	traits = list(
		TRAIT_DODGEEXPERT,
	)

/datum/job/advclass/combat/monk/after_spawn(mob/living/carbon/human/spawned, client/player_client)
	. = ..()
	if(spawned.dna?.species.id == "kobold")
		spawned.attributes?.add_sheet(/datum/attribute_holder/sheet/job/monk/kobold)

/datum/outfit/adventurer/monk
	name = "Monk (Adventurer)"

	head = /obj/item/clothing/head/roguehood/colored/brown
	shoes = /obj/item/clothing/shoes/shortboots
	cloak = /obj/item/clothing/cloak/raincloak/furcloak/colored/brown
	armor = /obj/item/clothing/shirt/robe/colored/plain
	wrists = /obj/item/clothing/wrists/bracers/leather
	gloves = /obj/item/clothing/gloves/bandages/pugilist
	belt = /obj/item/storage/belt/leather/rope
	beltr = /obj/item/storage/belt/pouch/coins/poor
	backl = /obj/item/storage/backpack/backpack
	backr = /obj/item/weapon/polearm/woodstaff
	neck = /obj/item/clothing/cloak/templar/undivided

/datum/outfit/adventurer/monk/pre_equip(mob/living/carbon/human/H, visuals_only)
	. = ..()

	switch(H.patron?.type)
		if(/datum/patron/divine/astrata)
			neck = /obj/item/clothing/neck/psycross/silver/divine/astrata
		if(/datum/patron/divine/necra) // Necra acolytes are now gravetenders
			neck = /obj/item/clothing/neck/psycross/silver/divine/necra
		if(/datum/patron/divine/eora)
			neck = /obj/item/clothing/neck/psycross/silver/divine/eora
		if(/datum/patron/divine/noc)
			neck = /obj/item/clothing/neck/psycross/silver/divine/noc
		if(/datum/patron/divine/pestra)
			neck = /obj/item/clothing/neck/psycross/silver/divine/pestra
		if(/datum/patron/divine/dendor)
			neck = /obj/item/clothing/neck/psycross/silver/divine/dendor
		if(/datum/patron/divine/abyssor)
			neck = /obj/item/clothing/neck/psycross/silver/divine/abyssor
		if(/datum/patron/divine/ravox)
			neck = /obj/item/clothing/neck/psycross/silver/divine/ravox
		if(/datum/patron/divine/xylix)
			neck = /obj/item/clothing/neck/psycross/silver/divine/xylix
		if(/datum/patron/divine/malum)
			neck = /obj/item/clothing/neck/psycross/silver/divine/malum
