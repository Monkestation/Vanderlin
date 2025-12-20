/datum/job/prince
	title = "Prince"
	f_title = "Princess"
	tutorial = "You’ve never felt the gnawing of the winter, \
	never known the bite of hunger and certainly have never known a honest day's work. \
	You are as free as any bird in the sky, \
	and you may revel in your debauchery for as long as your parents remain upon the throne: \
	But someday you’ll have to grow up, and that will be the day your carelessness will cost you more than a few mammons."
	department_flag = APPRENTICES
	job_flags = (JOB_ANNOUNCE_ARRIVAL | JOB_SHOW_IN_CREDITS | JOB_EQUIP_RANK | JOB_NEW_PLAYER_JOINABLE )
	faction = FACTION_TOWN
	total_positions = 2
	spawn_positions = 2
	allowed_races = RACES_PLAYER_ROYALTY
	spells = list(
		/datum/action/cooldown/spell/undirected/list_target/grant_title,
	)

	allowed_ages = list(AGE_ADULT, AGE_CHILD)
	cmode_music = 'sound/music/cmode/nobility/combat_noble.ogg'
	advclass_cat_rolls = list(CTAG_HEIR = 20)

	display_order = JDO_PRINCE
	give_bank_account = TRUE
	bypass_lastclass = TRUE

	can_have_apprentices = FALSE
	noble_income = 20

	exp_types_granted = list(EXP_TYPE_NOBLE)


/datum/job/prince/after_spawn(mob/living/carbon/spawned, client/player_client)
	. = ..()
	var/mob/living/carbon/human/H = spawned
	addtimer(CALLBACK(SSfamilytree, TYPE_PROC_REF(/datum/controller/subsystem/familytree, AddRoyal), H, FAMILY_PROGENY), 10 SECONDS)
	if(GLOB.keep_doors.len > 0)
		addtimer(CALLBACK(GLOBAL_PROC, GLOBAL_PROC_REF(know_keep_door_password), H), 5 SECONDS)
	ADD_TRAIT(H, TRAIT_KNOWKEEPPLANS, TRAIT_GENERIC)

/datum/job/advclass/heir
	inherit_parent_title = TRUE
	allowed_ages = list(AGE_ADULT, AGE_CHILD)
	allowed_races = RACES_PLAYER_ROYALTY
	exp_type = list(EXP_TYPE_NOBLE)
	exp_types_granted = list(EXP_TYPE_NOBLE)

/datum/job/advclass/heir/daring
	title = "Daring Twit"
	tutorial = "You're a somebody, someone important. It only makes sense you want to make a name for yourself, to gain your own glory so people see how great you really are beyond your bloodline. Plus, if you're beloved by the people for your exploits you'll be chosen! Probably. Shame you're as useful and talented as a squire, despite your delusions to the contrary."
	outfit = /datum/outfit/heir/daring
	category_tags = list(CTAG_HEIR)

/datum/outfit/heir/daring/pre_equip(mob/living/carbon/human/H)
	..()
	pants = /obj/item/clothing/pants/tights
	shirt = /obj/item/clothing/shirt/undershirt/colored/guard
	armor = /obj/item/clothing/armor/chainmail
	shoes = /obj/item/clothing/shoes/nobleboot
	belt = /obj/item/storage/belt/leather
	beltl = /obj/item/weapon/sword
	beltr = /obj/item/key/manor
	neck = /obj/item/storage/belt/pouch/coins/rich
	backr = /obj/item/storage/backpack/satchel
	H.adjust_skillrank(/datum/skill/combat/axesmaces, 1, TRUE)
	H.adjust_skillrank(/datum/skill/combat/bows, 2, TRUE)
	H.adjust_skillrank(/datum/skill/combat/crossbows, 2, TRUE)
	H.adjust_skillrank(/datum/skill/combat/swords, 2, TRUE)
	H.adjust_skillrank(/datum/skill/combat/wrestling, 2, TRUE)
	H.adjust_skillrank(/datum/skill/combat/unarmed, 2, TRUE)
	H.adjust_skillrank(/datum/skill/combat/knives, 1, TRUE)
	H.adjust_skillrank(/datum/skill/misc/swimming, 2, TRUE)
	H.adjust_skillrank(/datum/skill/misc/climbing, 2, TRUE)
	H.adjust_skillrank(/datum/skill/misc/athletics, 1, TRUE)
	H.adjust_skillrank(/datum/skill/misc/riding, 3, TRUE)
	H.adjust_skillrank(/datum/skill/misc/reading, 2, TRUE)
	H.adjust_skillrank(/datum/skill/labor/mathematics, 3, TRUE)
	H.change_stat(STATKEY_STR, 1)
	H.change_stat(STATKEY_PER, 1)
	H.change_stat(STATKEY_CON, 1)
	H.change_stat(STATKEY_SPD, 1)
	H.change_stat(STATKEY_LCK, 1)
	ADD_TRAIT(H, TRAIT_NOBLE, TRAIT_GENERIC)
	ADD_TRAIT(H, TRAIT_MEDIUMARMOR, TRAIT_GENERIC)

/datum/job/advclass/heir/aristocrat
	title = "Sheltered Aristocrat"
	tutorial = "Life has been kind to you; you've an entire keep at your disposal, servants to wait on you, and a whole retinue of guards to guard you. You've nothing to prove; just live the good life and you'll be a lord someday, too. A lack of ambition translates into a lacking skillset beyond schooling, though, and your breaks from boredom consist of being a damsel or court gossip."
	outfit = /datum/outfit/heir/aristocrat
	category_tags = list(CTAG_HEIR)

/datum/outfit/heir/aristocrat/pre_equip(mob/living/carbon/human/H)
	..()
	ADD_TRAIT(H, TRAIT_NOBLE, TRAIT_GENERIC)
	ADD_TRAIT(H, TRAIT_MEDIUMARMOR, TRAIT_GENERIC)
	ADD_TRAIT(H, TRAIT_BEAUTIFUL, TRAIT_GENERIC)
	belt = /obj/item/storage/belt/leather
	beltl = /obj/item/key/manor
	beltr = /obj/item/storage/belt/pouch/coins/rich
	if(H.gender == MALE)
		pants = /obj/item/clothing/pants/tights
		shirt = /obj/item/clothing/shirt/dress/royal/prince
		belt = /obj/item/storage/belt/leather
		shoes = /obj/item/clothing/shoes/nobleboot
	if(H.gender == FEMALE)
		belt = /obj/item/storage/belt/leather/cloth/lady
		head = /obj/item/clothing/head/hennin
		shirt = /obj/item/clothing/shirt/dress/royal/princess
		shoes = /obj/item/clothing/shoes/shortboots
		pants = /obj/item/clothing/pants/tights/colored/random
		H.virginity = TRUE
	H.adjust_skillrank(/datum/skill/combat/bows, 1, TRUE)
	H.adjust_skillrank(/datum/skill/combat/crossbows, pick(0,1), TRUE)
	H.adjust_skillrank(/datum/skill/combat/wrestling, 1, TRUE)
	H.adjust_skillrank(/datum/skill/combat/unarmed, 1, TRUE)
	H.adjust_skillrank(/datum/skill/combat/knives, 1, TRUE)
	H.adjust_skillrank(/datum/skill/misc/swimming, 2, TRUE)
	H.adjust_skillrank(/datum/skill/misc/climbing, 1, TRUE)
	H.adjust_skillrank(/datum/skill/misc/athletics, pick(0,1), TRUE)
	H.adjust_skillrank(/datum/skill/misc/riding, 2, TRUE)
	H.adjust_skillrank(/datum/skill/misc/reading, 3, TRUE)
	H.adjust_skillrank(/datum/skill/craft/cooking, 1, TRUE)
	H.adjust_skillrank(/datum/skill/misc/sewing, 1, TRUE)
	H.adjust_skillrank(/datum/skill/labor/mathematics, 3, TRUE)
	H.change_stat(STATKEY_PER, 2)
	H.change_stat(STATKEY_STR, -1)
	H.change_stat(STATKEY_INT, 2)
	H.change_stat(STATKEY_LCK, 1)
	H.change_stat(STATKEY_SPD, 1)

/datum/job/advclass/heir/inbred
	title = "Inbred Wastrel"
	tutorial = "Your bloodline ensures Psydon smiles upon you by divine right, the blessing of nobility... until you were born, anyway. You are a child forsaken, and even though your body boils as you go about your day, your spine creaks, and your drooling form needs to be waited on tirelessly you are still considered more important then the peasant that keeps the town fed and warm. Remind them of that fact when your lungs are particularly pus free."
	outfit = /datum/outfit/heir/inbred
	category_tags = list(CTAG_HEIR)

/datum/outfit/heir/inbred/pre_equip(mob/living/carbon/human/H)
	..()
	ADD_TRAIT(H, TRAIT_NOBLE, TRAIT_GENERIC)
	ADD_TRAIT(H, TRAIT_CRITICAL_WEAKNESS, TRAIT_GENERIC)
	ADD_TRAIT(H, TRAIT_MEDIUMARMOR, TRAIT_GENERIC)
	ADD_TRAIT(H, TRAIT_UGLY, TRAIT_GENERIC)
	belt = /obj/item/storage/belt/leather
	beltl = /obj/item/key/manor
	beltr = /obj/item/storage/belt/pouch/coins/rich
	if(H.gender == MALE)
		pants = /obj/item/clothing/pants/tights
		shirt = /obj/item/clothing/shirt/dress/royal/prince
		belt = /obj/item/storage/belt/leather
		shoes = /obj/item/clothing/shoes/nobleboot
	if(H.gender == FEMALE)
		belt = /obj/item/storage/belt/leather/cloth/lady
		head = /obj/item/clothing/head/hennin
		shirt = /obj/item/clothing/shirt/dress/royal/princess
		shoes = /obj/item/clothing/shoes/shortboots
		pants = /obj/item/clothing/pants/tights/colored/random
		H.virginity = TRUE

	H.adjust_skillrank(/datum/skill/combat/bows, 1, TRUE)
	H.adjust_skillrank(/datum/skill/combat/crossbows, pick(0,1), TRUE)
	H.adjust_skillrank(/datum/skill/combat/wrestling, 1, TRUE)
	H.adjust_skillrank(/datum/skill/combat/unarmed, 1, TRUE)
	H.adjust_skillrank(/datum/skill/combat/knives, 1, TRUE)
	H.adjust_skillrank(/datum/skill/misc/swimming, 2, TRUE)
	H.adjust_skillrank(/datum/skill/misc/climbing, pick(0,0,1), TRUE)
	H.adjust_skillrank(/datum/skill/misc/athletics, pick(0,1), TRUE)
	H.adjust_skillrank(/datum/skill/misc/riding, 2, TRUE)
	H.adjust_skillrank(/datum/skill/misc/reading, 3, TRUE)
	H.adjust_skillrank(/datum/skill/craft/cooking, 1, TRUE)
	H.adjust_skillrank(/datum/skill/misc/sewing, 1, TRUE)
	H.change_stat(STATKEY_STR, -2)
	H.change_stat(STATKEY_PER, -2)
	H.change_stat(STATKEY_INT, -2)
	H.change_stat(STATKEY_CON, -2)
	H.change_stat(STATKEY_END, -2)
	H.change_stat(STATKEY_LCK, -2) //They already can't run, no need to do speed and torture their move speed.
