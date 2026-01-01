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

	skills = list(
		/datum/skill/misc/reading = 3,
		/datum/skill/combat/unarmed = 5,
		/datum/skill/combat/wrestling = 4,
		/datum/skill/misc/sewing = 2,
		/datum/skill/magic/holy = 1,
		/datum/skill/misc/medicine = 1,
		/datum/skill/misc/climbing = 4,
	)

	jobstats = list(
		STATKEY_STR = 2,
		STATKEY_CON = 2,
		STATKEY_END = 2,
		STATKEY_PER = -1,
		STATKEY_SPD = 2,
	)

	traits = list(
		TRAIT_DODGEEXPERT,
	)

/datum/job/advclass/combat/monk/after_spawn(mob/living/carbon/human/spawned, client/player_client)
	. = ..()

	spawned.adjust_skillrank(/datum/skill/combat/polearms, pick(1,1,2), TRUE) // Wood staff
	spawned.adjust_skillrank(/datum/skill/misc/athletics, pick(2,2,3), TRUE)

	if(spawned.dna?.species.id == "kobold")
		spawned.adjust_stat_modifier(STATMOD_JOB, STATKEY_STR, 2) // Go, my child. Destroy their ankles.
		spawned.adjust_stat_modifier(STATMOD_JOB, STATKEY_SPD, -1)

	var/holder = spawned.patron?.devotion_holder
	if(holder)
		var/datum/devotion/devotion = new holder()
		devotion.make_churching()
		devotion.grant_to(spawned)

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
			neck = /obj/item/clothing/neck/psycross/silver/astrata
		if(/datum/patron/divine/necra) // Necra acolytes are now gravetenders
			neck = /obj/item/clothing/neck/psycross/silver/necra
		if(/datum/patron/divine/eora)
			neck = /obj/item/clothing/neck/psycross/silver/eora
		if(/datum/patron/divine/noc)
			neck = /obj/item/clothing/neck/psycross/silver/noc
		if(/datum/patron/divine/pestra)
			neck = /obj/item/clothing/neck/psycross/silver/pestra
		if(/datum/patron/divine/dendor)
			neck = /obj/item/clothing/neck/psycross/silver/dendor
		if(/datum/patron/divine/abyssor)
			neck = /obj/item/clothing/neck/psycross/silver/abyssor
		if(/datum/patron/divine/ravox)
			neck = /obj/item/clothing/neck/psycross/silver/ravox
		if(/datum/patron/divine/xylix)
			neck = /obj/item/clothing/neck/psycross/silver/xylix
		if(/datum/patron/divine/malum)
			neck = /obj/item/clothing/neck/psycross/silver/malum
