/datum/attribute_holder/sheet/job/grabber
	raw_attribute_list = list(
		STAT_STRENGTH = 1,
		STAT_ENDURANCE = 1,
		STAT_CONSTITUTION = 2,
		STAT_SPEED = -1,
		/datum/attribute/skill/combat/swords = 30,
		/datum/attribute/skill/combat/shields = 10,
		/datum/attribute/skill/combat/axesmaces = 20,
		/datum/attribute/skill/combat/wrestling = 30,
		/datum/attribute/skill/combat/unarmed = 30,
		/datum/attribute/skill/combat/knives = 10,
		/datum/attribute/skill/combat/firearms = 10,
		/datum/attribute/skill/combat/crossbows = 10,
		/datum/attribute/skill/misc/reading = 10,
		/datum/attribute/skill/misc/swimming = 40,
		/datum/attribute/skill/misc/climbing = 30,
		/datum/attribute/skill/misc/athletics = 30,
		/datum/attribute/skill/labor/mathematics = 10
	)

/datum/job/grabber
	title = "Stevedore"
	tutorial = "A stevedore is the lowest yet essential position in the Merchant's employment, reserved for the strong and loyal. \
	You are responsible for hauling materials and goods to-and-fro the docks and warehouses, protecting their transportation from conniving thieves. \
	Keep your eye out for the security of the Merchant, and they will surely treat you like family."
	department_flag = COMPANY
	display_order = JDO_GRABBER
	job_flags = (JOB_ANNOUNCE_ARRIVAL | JOB_SHOW_IN_CREDITS | JOB_EQUIP_RANK | JOB_NEW_PLAYER_JOINABLE)
	faction = FACTION_TOWN
	total_positions = 4
	spawn_positions = 4
	bypass_lastclass = TRUE

	allowed_races = RACES_PLAYER_ALL

	outfit = /datum/outfit/grabber
	give_bank_account = TRUE
	cmode_music = 'sound/music/cmode/towner/CombatTowner2.ogg'
	exp_types_granted = list(EXP_TYPE_MERCHANT_COMPANY)
	can_be_apprentice = TRUE

	attribute_sheet = /datum/attribute_holder/sheet/job/grabber

	traits = list(
		TRAIT_CRATEMOVER
	)

/datum/outfit/grabber
	name = "Stevedore"
	backr = /obj/item/storage/backpack/satchel
	wrists = /obj/item/clothing/wrists/bracers/leather
	gloves = /obj/item/clothing/gloves/fingerless
	neck = /obj/item/storage/belt/pouch/coins/poor
	armor = /obj/item/clothing/armor/leather/jacket/sea
	shirt = /obj/item/clothing/armor/gambeson/light
	pants = /obj/item/clothing/pants/tights/sailor
	belt = /obj/item/storage/belt/leather/rope
	beltr = /obj/item/weapon/mace/cudgel
	beltl = /obj/item/weapon/sword/sabre/cutlass
	scabbards = list(/obj/item/weapon/scabbard/sword)

	backpack_contents = list(
		/obj/item/storage/keyring/stevedore = 1
	)

/datum/outfit/grabber/pre_equip(mob/living/carbon/human/equipped_human, visuals_only)
	. = ..()
	if(equipped_human.gender == MALE)
		shoes = /obj/item/clothing/shoes/boots/leather
		head = /obj/item/clothing/head/headband/colored/red
	else
		shoes = /obj/item/clothing/shoes/gladiator
		head = /obj/item/clothing/head/headband
