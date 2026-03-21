/datum/attribute_holder/sheet/job/churchling
	raw_attribute_list = list(
		STATKEY_PER = 1,
		STAT_SPEED = 2,
		/datum/attribute/skill/misc/climbing = 40,
		/datum/attribute/skill/misc/sneaking = 40,
		/datum/attribute/skill/misc/medicine = 10,
		/datum/attribute/skill/magic/holy = 20,
		/datum/attribute/skill/misc/sewing = 20,
		/datum/attribute/skill/misc/reading = 10,
		/datum/attribute/skill/craft/crafting = 10,
		/datum/attribute/skill/craft/cooking = 10
	)

/datum/job/churchling
	title = "Churchling"
	tutorial = "Your family were zealots. \
	They scolded you with a studded belt and prayed like sinners \
	every waking hour of the day they weren’t toiling in the fields. \
	You escaped them by becoming a churchling-- and a guaranteed education isn't so bad."
	department_flag = YOUNGFOLK
	job_flags = (JOB_ANNOUNCE_ARRIVAL | JOB_SHOW_IN_CREDITS | JOB_EQUIP_RANK | JOB_NEW_PLAYER_JOINABLE)
	display_order = JDO_CHURCHLING
	faction = FACTION_TOWN
	total_positions = 2
	spawn_positions = 2
	bypass_lastclass = TRUE

	allowed_ages = list(AGE_CHILD)
	allowed_races = RACES_PLAYER_ALL
	allowed_patrons = UNDIVIDED_TEMPLE_PATRONS

	outfit = /datum/outfit/churchling
	give_bank_account = TRUE
	can_have_apprentices = FALSE
	can_be_apprentice = TRUE
	cmode_music = 'sound/music/cmode/towner/CombatTowner.ogg'
	job_bitflag = BITFLAG_CHURCH
	exp_types_granted = list(EXP_TYPE_CHURCH, EXP_TYPE_CLERIC)

	attribute_sheet = /datum/attribute_holder/sheet/job/churchling

	languages = list(/datum/language/celestial)

/datum/job/churchling/after_spawn(mob/living/carbon/human/spawned, client/player_client)
	. = ..()
	var/holder = spawned.patron?.devotion_holder
	if(holder)
		var/datum/devotion/devotion = new holder()
		devotion.make_churchling()
		devotion.grant_to(spawned)

/datum/outfit/churchling
	name = "Churchling"
	neck = /obj/item/clothing/neck/psycross/silver/divine
	armor = /obj/item/clothing/shirt/robe
	shirt = /obj/item/clothing/shirt/undershirt
	pants = /obj/item/clothing/pants/tights
	belt = /obj/item/storage/belt/leather/rope
	shoes = /obj/item/clothing/shoes/simpleshoes
	beltl = /obj/item/key/church

/datum/outfit/churchling/pre_equip(mob/living/carbon/human/equipped_human, visuals_only)
	. = ..()
	if(equipped_human.gender == FEMALE)
		head = /obj/item/clothing/head/armingcap
		armor = /obj/item/clothing/shirt/dress/gen/colored/random
		shirt = /obj/item/clothing/shirt/undershirt

	switch(equipped_human.patron?.type)
		if(/datum/patron/divine/astrata)
			neck = /obj/item/clothing/neck/psycross/silver/divine/astrata
		if(/datum/patron/divine/necra)
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
