/datum/attribute_holder/sheet/job/steward
	raw_attribute_list = list(
		STAT_STRENGTH = -2,
		STAT_INTELLIGENCE = 5,
		STAT_CONSTITUTION = -2,
		/datum/attribute/skill/combat/knives = 20,
		/datum/attribute/skill/misc/reading = 60,
		/datum/attribute/skill/misc/riding = 20,
		/datum/attribute/skill/misc/stealing = 20,
		/datum/attribute/skill/misc/sneaking = 20,
		/datum/attribute/skill/misc/lockpicking = 60,
		/datum/attribute/skill/labor/mathematics = 50
	)

/datum/job/steward
	title = "Steward"
	tutorial = "Coin, Coin, Coin! Oh beautiful coin: \
	You're addicted to it, and you hold the position as the King's personal treasurer of both coin and information. \
	You know the power silver and gold has on a man's mortal soul, \
	and you know just what lengths they'll go to in order to get even more. Keep your festering economy and your rats alive, theyre the only two things you can weigh any trust into anymore."
	department_flag = NOBLEMEN
	job_flags = (JOB_ANNOUNCE_ARRIVAL | JOB_SHOW_IN_CREDITS | JOB_EQUIP_RANK | JOB_NEW_PLAYER_JOINABLE)
	display_order = JDO_STEWARD
	faction = FACTION_TOWN
	total_positions = 1
	spawn_positions = 1
	bypass_lastclass = TRUE
	is_quest_giver = TRUE
	allowed_races = RACES_PLAYER_NONDISCRIMINATED
	blacklisted_species = list(SPEC_ID_HALFLING)
	outfit = /datum/outfit/steward
	give_bank_account = 100
	noble_income = 16
	cmode_music = 'sound/music/cmode/nobility/combat_noble.ogg'
	job_bitflag = BITFLAG_ROYALTY
	exp_type = list(EXP_TYPE_LIVING)
	exp_types_granted = list(EXP_TYPE_NOBLE)
	exp_requirements = list(
		EXP_TYPE_LIVING = 300
	)
	honorary = "Lord"
	honorary_f = "Lady"

	attribute_sheet = /datum/attribute_holder/sheet/job/steward

	traits = list(
		TRAIT_SEEPRICES,
		TRAIT_NOBLE_BLOOD,
		TRAIT_NOBLE_POWER
	)

/datum/outfit/steward/pre_equip(mob/living/carbon/human/H)
	..()
	if(H.gender == FEMALE)
		shirt = /obj/item/clothing/shirt/dress/stewarddress
	else
		shirt = /obj/item/clothing/shirt/undershirt/fancy
		pants = /obj/item/clothing/pants/trou/leathertights

/datum/job/steward/after_spawn(mob/living/carbon/human/spawned, client/player_client)
	. = ..()
	spawned.virginity = TRUE

/datum/outfit/steward
	name = "Steward"
	shoes = /obj/item/clothing/shoes/simpleshoes/buckle
	shirt = /obj/item/clothing/shirt/dress/stewarddress
	head = /obj/item/clothing/head/stewardtophat
	cloak = /obj/item/clothing/cloak/raincloak/furcloak
	armor = /obj/item/clothing/armor/gambeson/steward
	belt = /obj/item/storage/belt/leather/plaquesilver
	beltr = /obj/item/storage/keyring/steward
	beltl = /obj/item/weapon/knife/dagger/steel
	backr = /obj/item/storage/backpack/satchel
	scabbards = list(/obj/item/weapon/scabbard/knife)
	backpack_contents = list(
		/obj/item/storage/belt/pouch/coins/rich = 1,
		/obj/item/lockpickring/mundane = 1
	)

/datum/outfit/steward/pre_equip(mob/living/carbon/human/equipped_human, visuals_only)
	. = ..()
	if(equipped_human.gender == MALE)
		shirt = /obj/item/clothing/shirt/undershirt/fancy
		pants = /obj/item/clothing/pants/trou/leathertights
