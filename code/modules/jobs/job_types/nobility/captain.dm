/datum/job/captain
	title = "Captain"
	tutorial = "Law and Order, your divine reason for existence. \
	You have been given command over the town and keep garrison to help ensure order and peace within the city, \
	and defend it against the many dangers of the peninsula."
	department_flag = NOBLEMEN
	display_order = JDO_CAPTAIN
	job_flags = (JOB_ANNOUNCE_ARRIVAL | JOB_SHOW_IN_CREDITS | JOB_EQUIP_RANK | JOB_NEW_PLAYER_JOINABLE)
	faction = FACTION_TOWN
	total_positions = 1
	spawn_positions = 1
	min_pq = 15
	bypass_lastclass = TRUE

	allowed_races = RACES_PLAYER_NONDISCRIMINATED
	blacklisted_species = list(SPEC_ID_HALFLING)

	outfit = /datum/outfit/captain
	spells = list(/datum/action/cooldown/spell/undirected/list_target/convert_role/guard)
	give_bank_account = 120
	cmode_music = 'sound/music/cmode/antag/CombatSausageMaker.ogg'
	noble_income = 11

	job_bitflag = BITFLAG_ROYALTY | BITFLAG_GARRISON

/datum/job/captain/after_spawn(mob/living/spawned, client/player_client)
	..()
	var/mob/living/carbon/human/H = spawned
	var/prev_real_name = H.real_name
	var/prev_name = H.name
	var/honorary = "Sir"
	if(H.gender == FEMALE)
		honorary = "Dame"
	H.real_name = "[honorary] [prev_real_name]"
	H.name = "[honorary] [prev_name]"

/datum/outfit/captain/pre_equip(mob/living/carbon/human/H)
	..()
	head = /obj/item/clothing/head/helmet/visored/captain
	gloves = /obj/item/clothing/gloves/plate
	pants = /obj/item/clothing/pants/platelegs/captain
	armor = /obj/item/clothing/armor/brigandine/captain
	neck = /obj/item/clothing/neck/gorget
	shirt = /obj/item/clothing/shirt/undershirt/colored/guard
	shoes = /obj/item/clothing/shoes/boots
	backl = /obj/item/storage/backpack/satchel
	backr = /obj/item/weapon/shield/tower/metal
	belt = /obj/item/storage/belt/leather/plaquesilver
	beltl = /obj/item/weapon/sword/sabre/dec
	beltr = /obj/item/weapon/mace/cudgel
	cloak = /obj/item/clothing/cloak/captain
	scabbards = list(/obj/item/weapon/scabbard/sword/noble)
	backpack_contents = list(/obj/item/storage/keyring/captain = 1, /obj/item/signal_horn = 1)
	H.adjust_skillrank(/datum/skill/combat/swords, 5, TRUE)
	H.adjust_skillrank(/datum/skill/combat/wrestling, 4, TRUE)
	H.adjust_skillrank(/datum/skill/combat/axesmaces, 4, TRUE)
	H.adjust_skillrank(/datum/skill/combat/shields, 3, TRUE)
	H.adjust_skillrank(/datum/skill/combat/unarmed, 3, TRUE)
	H.adjust_skillrank(/datum/skill/combat/knives, 3, TRUE)
	H.adjust_skillrank(/datum/skill/combat/polearms, 2, TRUE)
	H.adjust_skillrank(/datum/skill/combat/whipsflails, 2, TRUE)

	H.adjust_skillrank(/datum/skill/combat/crossbows, 3, TRUE)
	H.adjust_skillrank(/datum/skill/combat/bows, 2, TRUE)

	H.adjust_skillrank(/datum/skill/misc/athletics, 4, TRUE)

	H.adjust_skillrank(/datum/skill/misc/swimming, 3, TRUE)
	H.adjust_skillrank(/datum/skill/misc/climbing, 3, TRUE)
	H.adjust_skillrank(/datum/skill/misc/riding, 3, TRUE)
	H.adjust_skillrank(/datum/skill/misc/reading, 2, TRUE)

	H.adjust_skillrank(/datum/skill/labor/mathematics, 3, TRUE)

	H.change_stat(STATKEY_STR, 2)
	H.change_stat(STATKEY_PER, 2)
	H.change_stat(STATKEY_INT, 1)
	H.change_stat(STATKEY_CON, 1)
	H.change_stat(STATKEY_END, 2)

	ADD_TRAIT(H, TRAIT_NOBLE, TRAIT_GENERIC)
	ADD_TRAIT(H, TRAIT_HEAVYARMOR, TRAIT_GENERIC)
	ADD_TRAIT(H, TRAIT_KNOWBANDITS, TRAIT_GENERIC)
	H.verbs |= /mob/proc/haltyell

	if(H.dna?.species?.id == SPEC_ID_HUMEN)
		H.dna.species.soundpack_m = new /datum/voicepack/male/knight()
