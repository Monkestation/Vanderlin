/datum/attribute_holder/sheet/job/profanepaladin
	raw_attribute_list = list(
		STAT_STRENGTH = 2,
		STAT_PERCEPTION = 2,
		STAT_INTELLIGENCE = 2,
		STAT_CONSTITUTION = 1,
		STAT_ENDURANCE = 1,
		STAT_SPEED = -2,
		/datum/attribute/skill/combat/axesmaces = 20,
		/datum/attribute/skill/combat/wrestling = 30,
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

/datum/job/advclass/combat/profanepaladin
	title = "Profane Paladin"
	tutorial = "There are those who are so dedicated to the worship and service of their inhumen god, that they have become famous amongst their followers, and infamous amongst the common men and women. These Profane Paladins bear the armour and marks of their respective god, travelling across the lands to preach and slay in their name. Naturally, they are branded a heretic by the Ten. Expect no quarter."
	allowed_races = RACES_PLAYER_ALL
	outfit = /datum/outfit/adventurer/profanepaladin
	total_positions = 1
	roll_chance = 7
	category_tags = list(CTAG_ADVENTURER)
	allowed_patrons = ALL_PROFANE_PATRONS
	exp_type = list(EXP_TYPE_ADVENTURER, EXP_TYPE_LIVING, EXP_TYPE_COMBAT, EXP_TYPE_CLERIC)
	exp_types_granted = list(EXP_TYPE_ADVENTURER, EXP_TYPE_COMBAT, EXP_TYPE_CLERIC)

	attribute_sheet = /datum/attribute_holder/sheet/job/profanepaladin

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
			armor = /obj/item/clothing/armor/plate
			gloves = /obj/item/clothing/gloves/plate
			pants = /obj/item/clothing/pants/platelegs
			shoes = /obj/item/clothing/shoes/boots/armor
