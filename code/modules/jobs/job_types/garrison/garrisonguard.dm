/datum/job/guardsman
	title = "City Watchmen"
	tutorial = "You are a member of the City Watch. \
	You've proven yourself worthy to the Captain and now you've got yourself a salary... \
	as long as you keep the peace that is."
	department_flag = GARRISON
	job_flags = (JOB_ANNOUNCE_ARRIVAL | JOB_SHOW_IN_CREDITS | JOB_EQUIP_RANK | JOB_NEW_PLAYER_JOINABLE)
	display_order = JDO_CITYWATCHMEN
	faction = FACTION_TOWN
	total_positions = 8
	spawn_positions = 8
	bypass_lastclass = TRUE

	allowed_ages = list(AGE_ADULT, AGE_MIDDLEAGED, AGE_IMMORTAL)
	allowed_races = RACES_PLAYER_GUARD

	outfit = /datum/outfit/guardsman
	advclass_cat_rolls = list(CTAG_GARRISON = 20)
	give_bank_account = 30
	cmode_music = 'sound/music/cmode/garrison/CombatGarrison.ogg'

	exp_type = list(EXP_TYPE_LIVING)
	exp_types_granted = list(EXP_TYPE_GARRISON, EXP_TYPE_COMBAT)
	exp_requirements = list(
		EXP_TYPE_LIVING = 300
	)

/datum/job/guardsman/after_spawn(mob/living/carbon/human/spawned, client/player_client)
	. = ..()
	add_verb(spawned, /mob/proc/haltyell)

/datum/outfit/guardsman
	name = "City Watchmen Base"
	cloak = /obj/item/clothing/cloak/half/guard
	pants = /obj/item/clothing/pants/trou/leather/splint
	wrists = /obj/item/clothing/wrists/bracers/ironjackchain
	shoes = /obj/item/clothing/shoes/boots/armor/ironmaille
	belt = /obj/item/storage/belt/leather/townguard
	gloves = /obj/item/clothing/gloves/leather

/datum/outfit/guardsman/pre_equip(mob/living/carbon/human/equipped_human, visuals_only)
	. = ..()
	cloak = pick(/obj/item/clothing/cloak/half/guard, /obj/item/clothing/cloak/half/guardsecond)

	if(equipped_human.dna && !(equipped_human.dna.species.id in RACES_PLAYER_NONDISCRIMINATED))
		mask = /obj/item/clothing/face/shepherd

/datum/outfit/guardsman/post_equip(mob/living/carbon/human/H, visuals_only = FALSE)
	. = ..()
	if(H.cloak && !findtext(H.cloak.name, "([H.real_name])"))
		H.cloak.name = "[H.cloak.name] ([H.real_name])"

/datum/job/advclass/garrison
	exp_types_granted = list(EXP_TYPE_GARRISON, EXP_TYPE_COMBAT)

/datum/job/advclass/garrison/footman
	title = "City Watch Footman"
	tutorial = "You are a member of the City Watch. \
	You are well versed in holding the line with a shield while wielding a trusty sword, axe, or mace in the other hand."
	outfit = /datum/outfit/guardsman/footman
	category_tags = list(CTAG_GARRISON)

	jobstats = list(
		STATKEY_STR = 1,
		STATKEY_END = 2,
		STATKEY_CON = 1
	)

	skills = list(
		/datum/skill/combat/axesmaces = 3,
		/datum/skill/combat/shields = 3,
		/datum/skill/combat/swords = 2,
		/datum/skill/combat/knives = 2,
		/datum/skill/combat/wrestling = 2,
		/datum/skill/combat/unarmed = 3,
		/datum/skill/misc/swimming = 2,
		/datum/skill/misc/climbing = 3,
		/datum/skill/misc/athletics = 3,
		/datum/skill/misc/sneaking = 2,
		/datum/skill/craft/crafting = 1,
		/datum/skill/misc/reading = 1
	)

	traits = list(
		TRAIT_MEDIUMARMOR,
		TRAIT_KNOWBANDITS
	)

/datum/outfit/guardsman/footman
	name = "City Watch Footman"
	head = /obj/item/clothing/head/helmet/townbarbute
	neck = /obj/item/clothing/neck/gorget
	armor = /obj/item/clothing/armor/cuirass/iron
	shirt = /obj/item/clothing/armor/gambeson
	backr = /obj/item/weapon/shield/heater
	backl = /obj/item/storage/backpack/satchel
	beltr = /obj/item/weapon/sword/short/iron
	beltl = /obj/item/weapon/mace/cudgel
	scabbards = list(/obj/item/weapon/scabbard/sword)
	backpack_contents = list(
		/obj/item/rope/chain = 1
	)

/datum/job/advclass/garrison/archer
	title = "City Watch Archer"
	tutorial = "You are a member of the City Watch. Your training with bows makes you a formidable threat when perched atop the walls or rooftops, raining arrows down upon foes with impunity."
	outfit = /datum/outfit/guardsman/archer
	category_tags = list(CTAG_GARRISON)

	jobstats = list(
		STATKEY_PER = 2,
		STATKEY_END = 1,
		STATKEY_SPD = 2
	)

	skills = list(
		/datum/skill/combat/bows = 3,
		/datum/skill/combat/crossbows = 2,
		/datum/skill/combat/axesmaces = 3,
		/datum/skill/combat/knives = 2,
		/datum/skill/combat/swords = 1,
		/datum/skill/combat/wrestling = 2,
		/datum/skill/combat/unarmed = 2,
		/datum/skill/misc/swimming = 2,
		/datum/skill/misc/climbing = 4,
		/datum/skill/misc/athletics = 2,
		/datum/skill/misc/sneaking = 2,
		/datum/skill/craft/crafting = 1,
		/datum/skill/misc/reading = 1
	)

	traits = list(
		TRAIT_DODGEEXPERT,
		TRAIT_KNOWBANDITS
	)

/datum/outfit/guardsman/archer
	name = "City Watch Archer"
	head = /obj/item/clothing/head/helmet/townbarbute
	neck = /obj/item/clothing/neck/chaincoif
	armor = /obj/item/clothing/armor/gambeson/heavy
	backr = /obj/item/gun/ballistic/revolver/grenadelauncher/bow
	backl = /obj/item/storage/backpack/satchel
	beltr = /obj/item/ammo_holder/quiver/arrows
	beltl = /obj/item/weapon/mace/cudgel
	backpack_contents = list(
		/obj/item/rope/chain = 1
	)

/datum/outfit/guardsman/archer/pre_equip(mob/living/carbon/human/equipped_human, visuals_only)
	. = ..()
	shirt = pick(/obj/item/clothing/shirt/undershirt/colored/guard, /obj/item/clothing/shirt/undershirt/colored/guardsecond)

/datum/job/advclass/garrison/pikeman
	title = "City Watch Pikeman"
	tutorial = "You are a pikeman in the City Watch. You are less fleet of foot compared to the rest, but you are burly and well practiced with spears, pikes, billhooks - all the various polearms for striking enemies from a distance."
	outfit = /datum/outfit/guardsman/pikeman
	category_tags = list(CTAG_GARRISON)

	jobstats = list(
		STATKEY_STR = 2,
		STATKEY_END = 1,
		STATKEY_CON = 2,
		STATKEY_SPD = -1
	)

	skills = list(
		/datum/skill/combat/polearms = 3,
		/datum/skill/combat/swords = 2,
		/datum/skill/combat/axesmaces = 2,
		/datum/skill/combat/knives = 2,
		/datum/skill/combat/wrestling = 2,
		/datum/skill/combat/unarmed = 3,
		/datum/skill/misc/swimming = 2,
		/datum/skill/misc/climbing = 3,
		/datum/skill/misc/athletics = 3,
		/datum/skill/craft/crafting = 1,
		/datum/skill/misc/reading = 1
	)

	traits = list(
		TRAIT_MEDIUMARMOR,
		TRAIT_KNOWBANDITS
	)

/datum/outfit/guardsman/pikeman
	name = "City Watch Pikeman"
	head = /obj/item/clothing/head/helmet/townbarbute
	armor = /obj/item/clothing/armor/cuirass/iron
	shirt = /obj/item/clothing/armor/gambeson
	neck = /obj/item/clothing/neck/gorget
	backl = /obj/item/storage/backpack/satchel
	backr = /obj/item/weapon/polearm/spear
	beltl = /obj/item/weapon/sword/short/iron
	beltr = /obj/item/weapon/mace/cudgel
	scabbards = list(/obj/item/weapon/scabbard/sword)
	backpack_contents = list(
		/obj/item/rope/chain = 1
	)

/mob/proc/haltyell()
	set name = "HALT!"
	set category = "Emotes.Noises"
	emote("haltyell")
