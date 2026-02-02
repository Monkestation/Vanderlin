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
	allowed_patrons = ALL_TEMPLE_PATRONS

	outfit = /datum/outfit/churchling
	give_bank_account = TRUE
	can_have_apprentices = FALSE
	cmode_music = 'sound/music/cmode/towner/CombatTowner.ogg'
	job_bitflag = BITFLAG_CHURCH
	exp_types_granted = list(EXP_TYPE_CHURCH, EXP_TYPE_CLERIC)

	jobstats = list(
		STATKEY_PER = 1,
		STATKEY_SPD = 2
	)

	skills = list(
		/datum/skill/misc/climbing = 4,
		/datum/skill/misc/sneaking = 4,
		/datum/skill/misc/medicine = 1,
		/datum/skill/magic/holy = 2,
		/datum/skill/misc/sewing = 2,
		/datum/skill/misc/reading = 1,
		/datum/skill/craft/crafting = 1,
		/datum/skill/craft/cooking = 1
	)

	languages = list(/datum/language/celestial)

/datum/job/churchling/after_spawn(mob/living/carbon/human/spawned, client/player_client)
	. = ..()
	var/holder = spawned.patron?.devotion_holder
	if(holder)
		var/datum/devotion/devotion = new holder()
		devotion.make_churching()
		devotion.grant_to(spawned)

/datum/outfit/churchling
	name = "Churchling"
	neck = /obj/item/clothing/neck/psycross/silver/undivided
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
			neck = /obj/item/clothing/neck/psycross/silver/astrata
		if(/datum/patron/divine/necra)
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
