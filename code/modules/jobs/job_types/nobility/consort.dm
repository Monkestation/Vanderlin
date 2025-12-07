/datum/job/consort
	title = "Consort"
	tutorial = "Yours was a marriage of political convenience rather than love, \
	yet you have remained the ruling monarch's good friend and confidant throughout your marriage. \
	But your love and loyalty will be tested, for daggers are equally pointed at your throat."
	department_flag = NOBLEMEN
	job_flags = (JOB_ANNOUNCE_ARRIVAL | JOB_SHOW_IN_CREDITS | JOB_EQUIP_RANK | JOB_NEW_PLAYER_JOINABLE)
	display_order = JDO_CONSORT
	faction = FACTION_TOWN
	total_positions = 0
	spawn_positions = 1
	bypass_lastclass = TRUE

	spells = list(/datum/action/cooldown/spell/undirected/list_target/convert_role/servant)
	allowed_races = RACES_PLAYER_ROYALTY
	outfit = /datum/outfit/consort
	advclass_cat_rolls = list(CTAG_CONSORT = 20)
	give_bank_account = 500
	apprentice_name = "Servant"
	cmode_music = 'sound/music/cmode/nobility/combat_noble.ogg'
	noble_income = 22

	job_bitflag = BITFLAG_ROYALTY

	exp_type = list(EXP_TYPE_LIVING, EXP_TYPE_NOBLE)
	exp_types_granted  = list(EXP_TYPE_NOBLE)
	exp_requirements = list(
		EXP_TYPE_LIVING = 600,
		EXP_TYPE_NOBLE = 300
	)


/datum/job/consort/after_spawn(mob/living/spawned, client/player_client)
	. = ..()
	var/mob/living/carbon/human/H = spawned
	addtimer(CALLBACK(SSfamilytree, TYPE_PROC_REF(/datum/controller/subsystem/familytree, AddRoyal), H, (H.gender == FEMALE) ? FAMILY_MOTHER : FAMILY_FATHER), 7 SECONDS)
	if(GLOB.keep_doors.len > 0)
		addtimer(CALLBACK(GLOBAL_PROC, GLOBAL_PROC_REF(know_keep_door_password), H), 5 SECONDS)
	ADD_TRAIT(H, TRAIT_KNOWKEEPPLANS, TRAIT_GENERIC)

/datum/outfit/consort // Default equipment regardless of class.
	head = /obj/item/clothing/head/crown/nyle/consortcrown
	shoes = /obj/item/clothing/shoes/boots
	ring = /obj/item/clothing/ring/silver
	belt = /obj/item/storage/belt/leather
	beltl = /obj/item/storage/keyring/consort
	beltr = /obj/item/storage/belt/pouch/coins/rich

/* ! ! ! CONSORT CLASSES ! ! !
- Highborn: The "default" class, a typical Enigman noble. Decent with swords and a knife. Can sew and read pretty good. A little squishy.
- Courtesan: Ex-classy or not-so-classy prostitute. Concerningly good with that knife and sneaking around. A little dumb.
- Lowborn: A good wholesome peasant spouse. Can cook and swing a pitchfork good. Not so smart or perceptive.
*/
/datum/job/advclass/consort
	inherit_parent_title = TRUE
	exp_types_granted  = list(EXP_TYPE_NOBLE)

/datum/job/advclass/consort/highborn
	title = "Highborn Consort"
	tutorial = "Of a minor noble house, yours is a rather typical tale; you were trained in manners, literature, and intrigue, all to be married off to the next ruler of this damned peninsula."
	outfit = /datum/outfit/consort/highborn

	category_tags = list(CTAG_CONSORT)

/datum/outfit/consort/highborn/pre_equip(mob/living/carbon/human/H)
	. = ..()
	if(H.gender == MALE)
		pants = /obj/item/clothing/pants/tights/colored/black
		shirt = /obj/item/clothing/shirt/undershirt/colored/black
		armor = /obj/item/clothing/armor/leather/vest/winterjacket
	else
		pants = /obj/item/clothing/pants/tights/colored/random
		armor = /obj/item/clothing/armor/leather/vest/winterjacket
		shirt = /obj/item/clothing/armor/gambeson/heavy/winterdress


	H.adjust_skillrank(/datum/skill/combat/swords, 3, TRUE)
	H.adjust_skillrank(/datum/skill/combat/knives, 2, TRUE)
	H.adjust_skillrank(/datum/skill/misc/swimming, 1, TRUE)
	H.adjust_skillrank(/datum/skill/misc/climbing, 1, TRUE)
	H.adjust_skillrank(/datum/skill/misc/athletics, 2, TRUE)
	H.adjust_skillrank(/datum/skill/misc/reading, 3, TRUE)
	H.adjust_skillrank(/datum/skill/misc/sneaking, 1, TRUE)
	H.adjust_skillrank(/datum/skill/misc/riding, 1, TRUE)
	H.adjust_skillrank(/datum/skill/misc/sewing, 2, TRUE)
	H.adjust_skillrank(/datum/skill/combat/unarmed, 1, TRUE)
	H.adjust_skillrank(/datum/skill/labor/mathematics, 3, TRUE)
	if(H.age == AGE_OLD)
		H.adjust_skillrank(/datum/skill/combat/swords, 1, TRUE)
	H.change_stat(STATKEY_INT, 3)
	H.change_stat(STATKEY_END, 1)
	H.change_stat(STATKEY_PER, 3)
	H.change_stat(STATKEY_SPD, 1)
	H.change_stat(STATKEY_LCK, 5)
	H.add_spell(/datum/action/cooldown/spell/undirected/call_bird)
	ADD_TRAIT(H, TRAIT_SEEPRICES, TRAIT_GENERIC)
	ADD_TRAIT(H, TRAIT_NOBLE, TRAIT_GENERIC)
	ADD_TRAIT(H, TRAIT_NUTCRACKER, TRAIT_GENERIC)
	switch(H.patron?.type)
		if(/datum/patron/inhumen/baotha)
			H.cmode_music = 'sound/music/cmode/antag/CombatBaotha.ogg'

/datum/job/advclass/consort/courtesan
	title = "Courtesan Consort"
	tutorial = "Though initially none envied your lot in life, it's certain that your midnight talents haven't gone to waste. Your honeyed words and charm have brought you right to being a ruler's beloved consort."
	outfit = /datum/outfit/consort/courtesan

	category_tags = list(CTAG_CONSORT)

/datum/outfit/consort/courtesan/pre_equip(mob/living/carbon/human/H)
	. = ..()
	if(H.gender == MALE)
		pants = /obj/item/clothing/pants/tights/colored/black
		shirt = /obj/item/clothing/shirt/undershirt/colored/black
		armor = /obj/item/clothing/armor/leather/vest/winterjacket // this is kind of stupid but i love it anyway
	else
		pants = /obj/item/clothing/pants/tights/colored/random
		shirt = /obj/item/clothing/armor/gambeson/heavy/winterdress
		armor = /obj/item/clothing/armor/leather/vest/winterjacket
		cloak = /obj/item/clothing/cloak/raincloak/furcloak

	H.adjust_skillrank(/datum/skill/combat/wrestling, 3, TRUE)
	H.adjust_skillrank(/datum/skill/combat/unarmed, 1, TRUE)
	H.adjust_skillrank(/datum/skill/combat/knives, 3, TRUE)
	H.adjust_skillrank(/datum/skill/misc/swimming, 3, TRUE)
	H.adjust_skillrank(/datum/skill/misc/climbing, 2, TRUE)
	H.adjust_skillrank(/datum/skill/misc/athletics, 2, TRUE)
	H.adjust_skillrank(/datum/skill/misc/reading, 1, TRUE)
	H.adjust_skillrank(/datum/skill/misc/sneaking, 3, TRUE)
	H.adjust_skillrank(/datum/skill/misc/stealing, 3, TRUE)
	H.adjust_skillrank(/datum/skill/misc/riding, 2, TRUE) // oh you know
	H.adjust_skillrank(/datum/skill/misc/lockpicking, 2, TRUE)
	H.adjust_skillrank(/datum/skill/labor/mathematics, 2, TRUE)
	if(H.age == AGE_OLD)
		H.adjust_skillrank(/datum/skill/combat/knives, 1, TRUE)
	H.change_stat(STATKEY_STR, 1)
	H.change_stat(STATKEY_INT, -1)
	H.change_stat(STATKEY_END, 2)
	H.change_stat(STATKEY_SPD, 1)
	H.change_stat(STATKEY_LCK, 3)
	ADD_TRAIT(H, TRAIT_NOBLE, TRAIT_GENERIC)
	ADD_TRAIT(H, TRAIT_NUTCRACKER, TRAIT_GENERIC)
	switch(H.patron?.type)
		if(/datum/patron/inhumen/baotha)
			H.cmode_music = 'sound/music/cmode/antag/CombatBaotha.ogg'

/datum/job/advclass/consort/lowborn
	title = "Lowborn Consort"
	tutorial = "You never could have dreamed your life would be like this. Though your origins are humble, something special about you - whether it was your good looks, your kind heart, or your bravery - has brought you into Vanderlin Keep."
	outfit = /datum/outfit/consort/lowborn

	category_tags = list(CTAG_CONSORT)

/datum/outfit/consort/lowborn/pre_equip(mob/living/carbon/human/H)
	. = ..()
	if(H.gender == MALE)
		pants = /obj/item/clothing/pants/tights/colored/green
		shirt = /obj/item/clothing/shirt/undershirt/colored/black
		armor = /obj/item/clothing/shirt/tunic/colored/green
	else
		shirt = /obj/item/clothing/shirt/dress/silkdress/colored/princess
		armor = /obj/item/clothing/armor/leather/jacket/silk_coat

	H.adjust_skillrank(/datum/skill/combat/wrestling, 3, TRUE)
	H.adjust_skillrank(/datum/skill/combat/unarmed, 3, TRUE)
	H.adjust_skillrank(/datum/skill/combat/polearms, 2, TRUE)
	H.adjust_skillrank(/datum/skill/misc/sewing, 3, TRUE)
	H.adjust_skillrank(/datum/skill/misc/climbing, 1, TRUE)
	H.adjust_skillrank(/datum/skill/misc/athletics, 3, TRUE)
	H.adjust_skillrank(/datum/skill/labor/farming, 3, TRUE)
	H.adjust_skillrank(/datum/skill/misc/reading, 1, TRUE)
	H.adjust_skillrank(/datum/skill/craft/cooking, 3, TRUE)
	H.adjust_skillrank(/datum/skill/craft/crafting, 3, TRUE)
	H.adjust_skillrank(/datum/skill/misc/riding, 1, TRUE)
	if(H.age == AGE_OLD)
		H.adjust_skillrank(/datum/skill/combat/unarmed, 1, TRUE)
	H.change_stat(STATKEY_STR, 1)
	H.change_stat(STATKEY_CON, 2) // good old peasant constitution. in exchange for making them dumb, they will be STRONG.
	H.change_stat(STATKEY_INT, -2) // either a hapless dumbass, or just not educated
	H.change_stat(STATKEY_END, 3)
	H.change_stat(STATKEY_SPD, -1)
	H.change_stat(STATKEY_LCK, 1)
	ADD_TRAIT(H, TRAIT_SEEDKNOW, TRAIT_GENERIC)
	ADD_TRAIT(H, TRAIT_NOBLE, TRAIT_GENERIC)
	ADD_TRAIT(H, TRAIT_NUTCRACKER, TRAIT_GENERIC)
	switch(H.patron?.type)
		if(/datum/patron/inhumen/baotha)
			H.cmode_music = 'sound/music/cmode/antag/CombatBaotha.ogg'

/datum/job/advclass/consort/courtesan/night_spy
	title = "Night-Mother's Spy Consort"
	tutorial = "Raised by the guild to report on all the Monarch's action. Using your honeyed words and charm have brought you right to being a ruler's beloved consort."
	outfit = /datum/outfit/consort/courtesan/spy

	category_tags = list(CTAG_CONSORT)

/datum/job/exlady //just used to change the consort title
	title = "Ex-Consort"
	department_flag = NOBLEMEN
	faction = FACTION_TOWN
	total_positions = 0
	spawn_positions = 0
	display_order = JDO_CONSORT

/datum/outfit/consort/courtesan/spy/pre_equip(mob/living/carbon/human/H)
	. = ..()
	H.grant_language(/datum/language/thievescant)
	to_chat(H, "<span class='info'>I can gesture in thieves' cant with ,t before my speech.</span>")
	ADD_TRAIT(H, TRAIT_THIEVESGUILD, TRAIT_GENERIC)
	ADD_TRAIT(H, TRAIT_NUTCRACKER, TRAIT_GENERIC)
