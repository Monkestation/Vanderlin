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

/datum/outfit/churchling
	name = "Churchling"

/datum/outfit/churchling/pre_equip(mob/living/carbon/human/H)
	..()
	if(H.mind)
		H.adjust_skillrank(/datum/skill/misc/climbing, 4, TRUE)
		H.adjust_skillrank(/datum/skill/misc/sneaking, 4, TRUE)
		H.adjust_skillrank(/datum/skill/misc/medicine, 1, TRUE)
		H.adjust_skillrank(/datum/skill/magic/holy, 2, TRUE)
		H.adjust_skillrank(/datum/skill/misc/sewing, 2, TRUE)
		H.adjust_skillrank(/datum/skill/misc/reading, 1, TRUE)
		H.adjust_skillrank(/datum/skill/craft/crafting, 1, TRUE)
		H.adjust_skillrank(/datum/skill/craft/cooking, 1, TRUE)
	if(H.gender == FEMALE)
		head = /obj/item/clothing/head/armingcap
		armor = /obj/item/clothing/shirt/dress/gen/colored/random
		shirt = /obj/item/clothing/shirt/undershirt
	else
		armor = /obj/item/clothing/shirt/robe
		shirt = /obj/item/clothing/shirt/undershirt
	pants = /obj/item/clothing/pants/tights
	belt = /obj/item/storage/belt/leather/rope
	shoes = /obj/item/clothing/shoes/simpleshoes
	beltl = /obj/item/key/church
	neck = /obj/item/clothing/neck/psycross/silver
	switch(H.patron?.type)
		if(/datum/patron/divine/astrata)
			neck = /obj/item/clothing/neck/psycross/silver/astrata
		if(/datum/patron/divine/necra) //Necra acolytes are now gravetenders
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

	H.change_stat(STATKEY_PER, 1)
	H.change_stat(STATKEY_SPD, 2)
	if(!H.has_language(/datum/language/celestial)) // For discussing church matters with the other Clergy
		H.grant_language(/datum/language/celestial)
		to_chat(H, "<span class='info'>I can speak Celestial with ,c before my speech.</span>")

	var/holder = H.patron?.devotion_holder
	if(holder)
		var/datum/devotion/devotion = new holder()
		devotion.make_churching()
		devotion.grant_to(H)
