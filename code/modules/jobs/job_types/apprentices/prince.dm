/datum/job/prince
	title = "Prince"
	f_title = "Princess"
	tutorial = "You've never felt the gnawing of the winter, \
	never known the bite of hunger and certainly have never known a honest day's work. \
	You are as free as any bird in the sky, \
	and you may revel in your debauchery for as long as your parents remain upon the throne: \
	But someday you'll have to grow up, and that will be the day your carelessness will cost you more than a few mammons."
	department_flag = APPRENTICES
	job_flags = (JOB_ANNOUNCE_ARRIVAL | JOB_SHOW_IN_CREDITS | JOB_EQUIP_RANK | JOB_NEW_PLAYER_JOINABLE)
	faction = FACTION_TOWN
	total_positions = 2
	spawn_positions = 2
	display_order = JDO_PRINCE
	give_bank_account = TRUE
	bypass_lastclass = TRUE

	can_have_apprentices = FALSE
	noble_income = 20
	cmode_music = 'sound/music/cmode/nobility/combat_noble.ogg'

	allowed_races = RACES_PLAYER_ROYALTY
	allowed_ages = list(AGE_ADULT, AGE_CHILD)
	advclass_cat_rolls = list(CTAG_HEIR = 20)

	outfit = /datum/outfit/heir

	spells = list(
		/datum/action/cooldown/spell/undirected/list_target/grant_title,
	)

	exp_types_granted = list(EXP_TYPE_NOBLE)

	traits = list(
		TRAIT_NOBLE,
		TRAIT_KNOWKEEPPLANS
	)

/datum/job/prince/after_spawn(mob/living/carbon/human/spawned, client/player_client)
	. = ..()
	addtimer(CALLBACK(SSfamilytree, TYPE_PROC_REF(/datum/controller/subsystem/familytree, AddRoyal), spawned, FAMILY_PROGENY), 10 SECONDS)
	if(GLOB.keep_doors.len > 0)
		addtimer(CALLBACK(GLOBAL_PROC, GLOBAL_PROC_REF(know_keep_door_password), spawned), 5 SECONDS)

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

	jobstats = list(
		STATKEY_STR = 1,
		STATKEY_PER = 1,
		STATKEY_CON = 1,
		STATKEY_SPD = 1,
		STATKEY_LCK = 1
	)

	skills = list(
		/datum/skill/combat/axesmaces = 1,
		/datum/skill/combat/bows = 2,
		/datum/skill/combat/crossbows = 2,
		/datum/skill/combat/swords = 2,
		/datum/skill/combat/wrestling = 2,
		/datum/skill/combat/unarmed = 2,
		/datum/skill/combat/knives = 1,
		/datum/skill/misc/swimming = 2,
		/datum/skill/misc/climbing = 2,
		/datum/skill/misc/athletics = 1,
		/datum/skill/misc/riding = 3,
		/datum/skill/misc/reading = 2,
		/datum/skill/labor/mathematics = 3
	)

	traits = list(
		TRAIT_MEDIUMARMOR
	)

/datum/outfit/heir/daring
	name = "Daring Twit (Prince)"
	pants = /obj/item/clothing/pants/tights
	shirt = /obj/item/clothing/shirt/undershirt/colored/guard
	armor = /obj/item/clothing/armor/chainmail
	shoes = /obj/item/clothing/shoes/nobleboot
	belt = /obj/item/storage/belt/leather
	beltl = /obj/item/weapon/sword
	beltr = /obj/item/key/manor
	neck = /obj/item/storage/belt/pouch/coins/rich
	backr = /obj/item/storage/backpack/satchel

/datum/job/advclass/heir/aristocrat
	title = "Sheltered Aristocrat"
	tutorial = "Life has been kind to you; you've an entire keep at your disposal, servants to wait on you, and a whole retinue of guards to guard you. You've nothing to prove; just live the good life and you'll be a lord someday, too. A lack of ambition translates into a lacking skillset beyond schooling, though, and your breaks from boredom consist of being a damsel or court gossip."
	outfit = /datum/outfit/heir/aristocrat
	category_tags = list(CTAG_HEIR)
	jobstats = list(
		STATKEY_PER = 2,
		STATKEY_STR = -1,
		STATKEY_INT = 2,
		STATKEY_LCK = 1,
		STATKEY_SPD = 1
	)

	skills = list(
		/datum/skill/combat/bows = 1,
		/datum/skill/combat/wrestling = 1,
		/datum/skill/combat/unarmed = 1,
		/datum/skill/combat/knives = 1,
		/datum/skill/misc/swimming = 2,
		/datum/skill/misc/climbing = 1,
		/datum/skill/misc/riding = 2,
		/datum/skill/misc/reading = 3,
		/datum/skill/craft/cooking = 1,
		/datum/skill/misc/sewing = 1,
		/datum/skill/labor/mathematics = 3
	)

	traits = list(
		TRAIT_MEDIUMARMOR,
		TRAIT_BEAUTIFUL
	)

/datum/job/advclass/heir/aristocrat/after_spawn(mob/living/carbon/human/spawned, client/player_client)
	. = ..()
	spawned.adjust_skillrank(/datum/skill/combat/crossbows, pick(0,1), TRUE)
	spawned.adjust_skillrank(/datum/skill/misc/athletics, pick(0,1), TRUE)

	if(spawned.gender == FEMALE)
		spawned.virginity = TRUE

/datum/outfit/heir/aristocrat
	name = "Sheltered Aristocrat (Prince)"
	belt = /obj/item/storage/belt/leather
	beltl = /obj/item/key/manor
	beltr = /obj/item/storage/belt/pouch/coins/rich

/datum/outfit/heir/aristocrat/pre_equip(mob/living/carbon/human/equipped_human, visuals_only)
	. = ..()
	if(equipped_human.gender == MALE)
		pants = /obj/item/clothing/pants/tights
		shirt = /obj/item/clothing/shirt/dress/royal/prince
		belt = /obj/item/storage/belt/leather
		shoes = /obj/item/clothing/shoes/nobleboot
	else
		belt = /obj/item/storage/belt/leather/cloth/lady
		head = /obj/item/clothing/head/hennin
		shirt = /obj/item/clothing/shirt/dress/royal/princess
		shoes = /obj/item/clothing/shoes/shortboots
		pants = /obj/item/clothing/pants/tights/colored/random

/datum/job/advclass/heir/inbred
	title = "Inbred Wastrel"
	tutorial = "Your bloodline ensures Psydon smiles upon you by divine right, the blessing of nobility... until you were born, anyway. You are a child forsaken, and even though your body boils as you go about your day, your spine creaks, and your drooling form needs to be waited on tirelessly you are still considered more important then the peasant that keeps the town fed and warm. Remind them of that fact when your lungs are particularly pus free."
	outfit = /datum/outfit/heir/inbred
	category_tags = list(CTAG_HEIR)
	jobstats = list(
		STATKEY_STR = -2,
		STATKEY_PER = -2,
		STATKEY_INT = -2,
		STATKEY_CON = -2,
		STATKEY_END = -2,
		STATKEY_LCK = -2
	)

	skills = list(
		/datum/skill/combat/bows = 1,
		/datum/skill/combat/wrestling = 1,
		/datum/skill/combat/unarmed = 1,
		/datum/skill/combat/knives = 1,
		/datum/skill/misc/swimming = 2,
		/datum/skill/misc/riding = 2,
		/datum/skill/misc/reading = 3,
		/datum/skill/craft/cooking = 1,
		/datum/skill/misc/sewing = 1
	)

	traits = list(
		TRAIT_CRITICAL_WEAKNESS,
		TRAIT_MEDIUMARMOR,
		TRAIT_UGLY
	)

/datum/job/advclass/heir/inbred/after_spawn(mob/living/carbon/human/spawned, client/player_client)
	. = ..()
	spawned.adjust_skillrank(/datum/skill/combat/crossbows, pick(0,1), TRUE)
	spawned.adjust_skillrank(/datum/skill/misc/climbing,  pick(0,0,1), TRUE)
	spawned.adjust_skillrank(/datum/skill/misc/athletics,  pick(0,1), TRUE)

	if(spawned.gender == FEMALE)
		spawned.virginity = TRUE

/datum/outfit/heir/inbred
	name = "Inbred Wastrel (Prince)"
	belt = /obj/item/storage/belt/leather
	beltl = /obj/item/key/manor
	beltr = /obj/item/storage/belt/pouch/coins/rich

/datum/outfit/heir/inbred/pre_equip(mob/living/carbon/human/equipped_human, visuals_only)
	. = ..()

	if(equipped_human.gender == MALE)
		pants = /obj/item/clothing/pants/tights
		shirt = /obj/item/clothing/shirt/dress/royal/prince
		belt = /obj/item/storage/belt/leather
		shoes = /obj/item/clothing/shoes/nobleboot
	else
		belt = /obj/item/storage/belt/leather/cloth/lady
		head = /obj/item/clothing/head/hennin
		shirt = /obj/item/clothing/shirt/dress/royal/princess
		shoes = /obj/item/clothing/shoes/shortboots
		pants = /obj/item/clothing/pants/tights/colored/random
