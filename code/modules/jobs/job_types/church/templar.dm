/datum/job/templar
	title = "Templar"
	tutorial = "Templars are warriors who have forsaken wealth and station in the service of the church, either from fervent zeal or remorse for past sins.\
	They are vigilant sentinels, guarding priest and altar, steadfast against heresy and shadow-beasts that creep in darkness. \
	But in the quiet of troubled sleep, there is a question left. Does the blood they spill sanctify them, or stain them forever? If service ever demanded it, whose blood would be the price?"
	flag = 0 //unset!!
	department_flag = CHURCHMEN
	job_flags = (JOB_ANNOUNCE_ARRIVAL | JOB_SHOW_IN_CREDITS | JOB_EQUIP_RANK | JOB_NEW_PLAYER_JOINABLE)
	display_order = JDO_TEMPLAR
	faction = FACTION_STATION
	total_positions = 2
	spawn_positions = 2
	min_pq = 8
	bypass_lastclass = TRUE

	allowed_sexes = list(MALE, FEMALE)
	allowed_races = RACES_PLAYER_NONDISCRIMINATED
	allowed_patrons = ALL_TEMPLAR_PATRONS

	outfit = /datum/outfit/job/templar
	give_bank_account = 0

/datum/outfit/job/templar
	name = "Templar"
	jobtype = /datum/job/templar
	allowed_patrons = ALL_TEMPLAR_PATRONS
	job_bitflag = BITFLAG_CHURCH

/datum/outfit/job/templar/pre_equip(mob/living/carbon/human/H)
	..()
	head = /obj/item/clothing/head/helmet/heavy/necked
	cloak = /obj/item/clothing/cloak/tabard/crusader/tief
	switch(H.patron?.type)
		if(/datum/patron/divine/astrata)
			neck = /obj/item/clothing/neck/psycross/silver/astrata
			head = /obj/item/clothing/head/helmet/heavy/necked/astrata
			cloak = /obj/item/clothing/cloak/stabard/templar/astrata
			H.cmode_music = 'sound/music/cmode/adventurer/CombatMonk.ogg'
		if(/datum/patron/divine/noc)
			neck = /obj/item/clothing/neck/psycross/noc
			head = /obj/item/clothing/head/helmet/heavy/necked/noc
			cloak = /obj/item/clothing/cloak/stabard/templar/noc
			H.cmode_music = 'sound/music/cmode/adventurer/CombatMonk.ogg'
		if(/datum/patron/divine/dendor)
			neck = /obj/item/clothing/neck/psycross/silver/dendor
			head = /obj/item/clothing/head/helmet/heavy/necked/dendorhelm
			cloak = /obj/item/clothing/cloak/stabard/templar/dendor
			H.cmode_music = 'sound/music/cmode/garrison/CombatForestGarrison.ogg'
		if(/datum/patron/divine/necra)
			neck = /obj/item/clothing/neck/psycross/silver/necra
			head = /obj/item/clothing/head/helmet/heavy/necked/necra
			cloak = /obj/item/clothing/cloak/stabard/templar/necra
			H.cmode_music = 'sound/music/cmode/church/CombatGravekeeper.ogg'
		if(/datum/patron/divine/pestra)
			neck = /obj/item/clothing/neck/psycross/silver/pestra
			head = /obj/item/clothing/head/helmet/heavy/necked/pestrahelm
			cloak = /obj/item/clothing/cloak/stabard/templar/pestra
			H.cmode_music = 'sound/music/cmode/adventurer/CombatMonk.ogg'
		if(/datum/patron/divine/eora)
			head = /obj/item/clothing/head/helmet/sallet/eoran
			wrists = /obj/item/clothing/neck/psycross/silver/eora
			neck = /obj/item/clothing/neck/chaincoif
			cloak = /obj/item/clothing/cloak/stabard/templar/eora
			H.cmode_music = 'sound/music/cmode/church/CombatEora.ogg'
			H.virginity = FALSE
			ADD_TRAIT(H, TRAIT_BEAUTIFUL, TRAIT_GENERIC)
		if(/datum/patron/divine/ravox)
			wrists = /obj/item/clothing/neck/psycross/silver/ravox
			head = /obj/item/clothing/head/helmet/heavy/necked/ravox
			cloak = /obj/item/clothing/cloak/stabard/templar/ravox
			H.cmode_music = 'sound/music/cmode/adventurer/CombatOutlander2.ogg'
		if(/datum/patron/divine/malum)
			wrists = /obj/item/clothing/neck/psycross/silver/malum
			head = /obj/item/clothing/head/helmet/heavy/necked/malumhelm
			cloak = /obj/item/clothing/cloak/stabard/templar/malum
			H.cmode_music = 'sound/music/cmode/adventurer/CombatOutlander2.ogg'
		if(/datum/patron/divine/abyssor)
			wrists = /obj/item/clothing/neck/psycross/silver/abyssor
			cloak = /obj/item/clothing/cloak/stabard/templar/abyssor
			H.cmode_music = 'sound/music/cmode/adventurer/CombatMonk.ogg'
			H.mind?.adjust_skillrank(/datum/skill/labor/fishing, 1, TRUE)


	armor = /obj/item/clothing/armor/chainmail/hauberk
	shirt = /obj/item/clothing/armor/gambeson
	pants = /obj/item/clothing/pants/chainlegs
	shoes = /obj/item/clothing/shoes/boots
	backl = /obj/item/storage/backpack/satchel
	backpack_contents = list(/obj/item/storage/keyring/priest = 1)
	backr = /obj/item/weapon/shield/tower/metal
	belt = /obj/item/storage/belt/leather/black
	beltl = /obj/item/storage/belt/pouch/coins/poor
	ring = /obj/item/clothing/ring/silver
	gloves = /obj/item/clothing/gloves/chain
	if(H.mind) //Similar stats to Royal Guards, as they're supposed to be on-par
		H.mind?.adjust_skillrank(/datum/skill/combat/wrestling, 4, TRUE)
		H.mind?.adjust_skillrank(/datum/skill/combat/unarmed, 3, TRUE)
		H.mind?.adjust_skillrank(/datum/skill/combat/shields, 3, TRUE)
		H.mind.adjust_skillrank(/datum/skill/misc/athletics, 4, TRUE)
		H.mind.adjust_skillrank(/datum/skill/misc/riding, 3, TRUE)
		H.mind?.adjust_skillrank(/datum/skill/misc/climbing, 2, TRUE)
		H.mind.adjust_skillrank(/datum/skill/misc/swimming, 2, TRUE)
		H.mind?.adjust_skillrank(/datum/skill/misc/athletics, 3, TRUE)
		H.mind?.adjust_skillrank(/datum/skill/misc/reading, 2, TRUE)
		H.mind?.adjust_skillrank(/datum/skill/magic/holy, 2, TRUE)
		H.mind?.adjust_skillrank(/datum/skill/misc/medicine, 1, TRUE)
		H.mind.adjust_skillrank(/datum/skill/misc/sewing, 2, TRUE)
		H.change_stat(STATKEY_STR, 3)
		H.change_stat(STATKEY_PER, 2)
		H.change_stat(STATKEY_END, 2)
		H.change_stat(STATKEY_INT, 1)
		if(!H.has_language(/datum/language/celestial)) // For discussing church matters with the other Clergy
			H.grant_language(/datum/language/celestial)
			to_chat(H, "<span class='info'>I can speak Celestial with ,c before my speech.</span>")
	switch(H.patron?.type)
		if(/datum/patron/divine/abyssor)
			H.mind?.adjust_skillrank(/datum/skill/combat/polearms, 4, TRUE)
			backl = /obj/item/weapon/polearm/spear/billhook
		if(/datum/patron/divine/malum)
			H.mind?.adjust_skillrank(/datum/skill/combat/axesmaces, 4, TRUE)
			beltr = /obj/item/weapon/mace/warhammer/steel
		else
			H.mind?.adjust_skillrank(/datum/skill/combat/swords, 4, TRUE)
			beltr = /obj/item/weapon/sword/long
	ADD_TRAIT(H, TRAIT_HEAVYARMOR, TRAIT_GENERIC)
	ADD_TRAIT(H, TRAIT_STEELHEARTED, TRAIT_GENERIC)
	ADD_TRAIT(H, TRAIT_KNOWBANDITS, TRAIT_GENERIC)

	var/datum/devotion/cleric_holder/C = new /datum/devotion/cleric_holder(H, H.patron)
	//Max devotion limit - Templars are stronger but cannot pray to gain more abilities beyond t1
	C.grant_spells_templar(H)
	H.verbs += list(/mob/living/carbon/human/proc/devotionreport, /mob/living/carbon/human/proc/clericpray)
	if(H.dna?.species)
		if(H.dna.species.id == "human")
			H.dna.species.soundpack_m = new /datum/voicepack/male/knight()
