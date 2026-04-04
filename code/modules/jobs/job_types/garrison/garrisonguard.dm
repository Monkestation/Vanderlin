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
	allowed_races = RACES_PLAYER_ALL

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

/datum/attribute_holder/sheet/job/garrison/footman
	raw_attribute_list = list(
		STAT_STRENGTH = 1,
		STAT_ENDURANCE = 2,
		STAT_CONSTITUTION = 1,
		/datum/attribute/skill/combat/axesmaces = 30,
		/datum/attribute/skill/combat/shields = 30,
		/datum/attribute/skill/combat/swords = 20,
		/datum/attribute/skill/combat/knives = 20,
		/datum/attribute/skill/combat/wrestling = 20,
		/datum/attribute/skill/combat/unarmed = 30,
		/datum/attribute/skill/misc/swimming = 20,
		/datum/attribute/skill/misc/climbing = 30,
		/datum/attribute/skill/misc/athletics = 30,
		/datum/attribute/skill/misc/sneaking = 20,
		/datum/attribute/skill/craft/crafting = 10,
		/datum/attribute/skill/misc/reading = 10
	)

/datum/job/advclass/garrison/footman
	title = "City Watch Footman"
	tutorial = "You are a member of the City Watch. \
	You are well versed in holding the line with a shield while wielding a trusty sword, axe, or mace in the other hand."
	outfit = /datum/outfit/guardsman/footman
	category_tags = list(CTAG_GARRISON)

	attribute_sheet = /datum/attribute_holder/sheet/job/garrison/footman

	traits = list(
		TRAIT_MEDIUMARMOR,
	)
	mind_traits = list(TRAIT_KNOWBANDITS)

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

/datum/attribute_holder/sheet/job/garrison/archer
	raw_attribute_list = list(
		STAT_PERCEPTION = 2,
		STAT_ENDURANCE = 1,
		STAT_SPEED = 2,
		/datum/attribute/skill/combat/bows = 30,
		/datum/attribute/skill/combat/crossbows = 20,
		/datum/attribute/skill/combat/axesmaces = 30,
		/datum/attribute/skill/combat/knives = 20,
		/datum/attribute/skill/combat/swords = 10,
		/datum/attribute/skill/combat/wrestling = 20,
		/datum/attribute/skill/combat/unarmed = 20,
		/datum/attribute/skill/misc/swimming = 20,
		/datum/attribute/skill/misc/climbing = 40,
		/datum/attribute/skill/misc/athletics = 20,
		/datum/attribute/skill/misc/sneaking = 20,
		/datum/attribute/skill/craft/crafting = 10,
		/datum/attribute/skill/misc/reading = 10
	)

/datum/job/advclass/garrison/archer
	title = "City Watch Archer"
	tutorial = "You are a member of the City Watch. Your training with bows makes you a formidable threat when perched atop the walls or rooftops, raining arrows down upon foes with impunity."
	outfit = /datum/outfit/guardsman/archer
	category_tags = list(CTAG_GARRISON)

	attribute_sheet = /datum/attribute_holder/sheet/job/garrison/archer

	traits = list(
		TRAIT_DODGEEXPERT,
	)
	mind_traits = list(TRAIT_KNOWBANDITS)

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

/datum/attribute_holder/sheet/job/garrison/pikeman
	raw_attribute_list = list(
		STAT_STRENGTH = 2,
		STAT_ENDURANCE = 1,
		STAT_CONSTITUTION = 2,
		STAT_SPEED = -1,
		/datum/attribute/skill/combat/polearms = 30,
		/datum/attribute/skill/combat/swords = 20,
		/datum/attribute/skill/combat/axesmaces = 20,
		/datum/attribute/skill/combat/knives = 20,
		/datum/attribute/skill/combat/wrestling = 20,
		/datum/attribute/skill/combat/unarmed = 30,
		/datum/attribute/skill/misc/swimming = 20,
		/datum/attribute/skill/misc/climbing = 30,
		/datum/attribute/skill/misc/athletics = 30,
		/datum/attribute/skill/craft/crafting = 10,
		/datum/attribute/skill/misc/reading = 10
	)

/datum/job/advclass/garrison/pikeman
	title = "City Watch Pikeman"
	tutorial = "You are a pikeman in the City Watch. You are less fleet of foot compared to the rest, but you are burly and well practiced with spears, pikes, billhooks - all the various polearms for striking enemies from a distance."
	outfit = /datum/outfit/guardsman/pikeman
	category_tags = list(CTAG_GARRISON)

	attribute_sheet = /datum/attribute_holder/sheet/job/garrison/pikeman

	traits = list(
		TRAIT_MEDIUMARMOR,
	)
	mind_traits = list(TRAIT_KNOWBANDITS)

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
