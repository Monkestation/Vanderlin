/datum/job/advclass/combat/profanepaladin
	title = "Profane Paladin"
	tutorial = "There are those who are so dedicated to the worship and service of their inhumen god, \
	that they have become famous amongst their followers, and infamous amongst the common men and women. \
	These Profane Paladins bear the armour and marks of their respective god, travelling across the lands to preach and slay in their name. \
	Naturally, they are branded a heretic by the Ten. Expect no quarter."
	allowed_races = RACES_PLAYER_ALL
	outfit = /datum/outfit/adventurer/profanepaladin
	total_positions = 1
	roll_chance = 15
	category_tags = list(CTAG_ADVENTURER)
	allowed_patrons = ALL_PROFANE_PATRONS
	exp_type = list(EXP_TYPE_ADVENTURER, EXP_TYPE_LIVING, EXP_TYPE_COMBAT, EXP_TYPE_CLERIC)
	exp_types_granted = list(EXP_TYPE_ADVENTURER, EXP_TYPE_COMBAT, EXP_TYPE_CLERIC)

	skills = list(
		/datum/skill/combat/axesmaces = 2,
		/datum/skill/combat/wrestling = 3,
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
	)

	traits = list(
		TRAIT_HEAVYARMOR,
		TRAIT_STEELHEARTED,
	)

/datum/job/advclass/combat/profanepaladin/after_spawn(mob/living/carbon/human/spawned, client/player_client)
	. = ..()
	if(spawned.dna?.species.id == SPEC_ID_HUMEN)
		spawned.dna.species.soundpack_m = new /datum/voicepack/male/knight()

	var/holder = spawned.patron?.devotion_holder
	if(holder)
		var/datum/devotion/devotion = new holder()
		devotion.make_templar()
		devotion.grant_to(spawned)

	switch(spawned.patron?.type)
		if(/datum/patron/inhumen/graggar)
			spawned.cmode_music = 'sound/music/cmode/antag/combat_werewolf.ogg'
		if(/datum/patron/inhumen/graggar_zizo)
			spawned.cmode_music = 'sound/music/cmode/antag/combat_werewolf.ogg'
		if(/datum/patron/inhumen/zizo)
			spawned.cmode_music = 'sound/music/cmode/antag/combat_cult.ogg'
			if(!spawned.has_language(/datum/language/undead))
				spawned.grant_language(/datum/language/undead)
		if(/datum/patron/inhumen/matthios)
			spawned.cmode_music = 'sound/music/cmode/antag/CombatBandit1.ogg'
		if(/datum/patron/inhumen/baotha)
			spawned.cmode_music = 'sound/music/cmode/antag/CombatBaotha.ogg'
		else
			spawned.cmode_music = 'sound/music/cmode/church/CombatInquisitor.ogg'

	GLOB.heretical_players += spawned.real_name

/datum/outfit/adventurer/profanepaladin
	name = "Profane Paladin (Adventurer)"
	shirt = /obj/item/clothing/armor/chainmail
	belt = /obj/item/storage/belt/leather/steel
	beltl = /obj/item/storage/belt/pouch/coins/mid
	ring = /obj/item/clothing/ring/silver/toper
	neck = /obj/item/clothing/neck/chaincoif
	backl = /obj/item/weapon/sword/long/judgement/evil
	head = /obj/item/clothing/head/helmet/heavy/bucket
	armor = /obj/item/clothing/armor/plate
	gloves = /obj/item/clothing/gloves/plate
	pants = /obj/item/clothing/pants/platelegs
	shoes = /obj/item/clothing/shoes/boots/armor

/datum/outfit/adventurer/profanepaladin/pre_equip(mob/living/carbon/human/H, visuals_only)
	. = ..()
	switch(H.patron?.type)
		if(/datum/patron/inhumen/graggar)
			head = /obj/item/clothing/head/helmet/heavy/graggar
			armor = /obj/item/clothing/armor/plate/full/graggar
			gloves = /obj/item/clothing/gloves/plate/graggar
			pants = /obj/item/clothing/pants/platelegs/graggar
			shoes = /obj/item/clothing/shoes/boots/armor/graggar
			cloak = /obj/item/clothing/cloak/graggar
		if(/datum/patron/inhumen/graggar_zizo)
			head = /obj/item/clothing/head/helmet/heavy/graggar
			armor = /obj/item/clothing/armor/plate/full/graggar
			gloves = /obj/item/clothing/gloves/plate/graggar
			pants = /obj/item/clothing/pants/platelegs/graggar
			shoes = /obj/item/clothing/shoes/boots/armor/graggar
			cloak = /obj/item/clothing/cloak/graggar
			H.cmode_music = 'sound/music/cmode/antag/combat_werewolf.ogg'
		if(/datum/patron/inhumen/zizo)
			head = /obj/item/clothing/head/helmet/visored/zizo
			armor = /obj/item/clothing/armor/plate/full/zizo
			gloves = /obj/item/clothing/gloves/plate/zizo
			pants = /obj/item/clothing/pants/platelegs/zizo
			shoes = /obj/item/clothing/shoes/boots/armor/zizo
		if(/datum/patron/inhumen/matthios)
			head = /obj/item/clothing/head/helmet/heavy/matthios
			armor = /obj/item/clothing/armor/plate/full/matthios
			gloves = /obj/item/clothing/gloves/plate/matthios
			pants = /obj/item/clothing/pants/platelegs/matthios
			shoes = /obj/item/clothing/shoes/boots/armor/matthios
		if(/datum/patron/inhumen/baotha)
			head = /obj/item/clothing/head/helmet/heavy/baotha
			mask = /obj/item/clothing/face/spectacles/sglasses
