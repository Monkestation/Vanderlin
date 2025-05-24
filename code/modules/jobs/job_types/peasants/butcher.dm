/datum/job/butcher
	title = "Butcher"
	tutorial = "Some say youre a strange individual, \
	some say youre a cheat while some claim you are a savant in the art of sausage making. \
	Without your skilled hands and knifework most of the livestock around the town would be wasted. "
	display_order = JDO_BUTCHER
	flag = BEASTMASTER
	job_flags = (JOB_ANNOUNCE_ARRIVAL | JOB_SHOW_IN_CREDITS | JOB_EQUIP_RANK | JOB_NEW_PLAYER_JOINABLE)
	department_flag = PEASANTS
	faction = FACTION_STATION
	total_positions = 1
	spawn_positions = 1
	min_pq = -20
	bypass_lastclass = TRUE

	allowed_races = RACES_PLAYER_ALL


	outfit = /datum/outfit/job/beastmaster
	give_bank_account = TRUE
	cmode_music = 'sound/music/cmode/towner/CombatInn.ogg'

/datum/outfit/job/beastmaster
	job_bitflag = BITFLAG_CONSTRUCTOR

/datum/outfit/job/beastmaster/pre_equip(mob/living/carbon/human/H)
	..()

	belt = /obj/item/storage/belt/leather
	beltr= /obj/item/storage/meatbag
	beltl= /obj/item/key/butcher
	backl = /obj/item/storage/backpack/satchel
	armor = /obj/item/clothing/armor/leather/vest/butcher
	shoes = /obj/item/clothing/shoes/boots/leather
	backpack_contents = list(/obj/item/kitchen/spoon, /obj/item/reagent_containers/food/snacks/truffles, /obj/item/weapon/knife/hunting)

	if(H.gender == MALE)
		pants = /obj/item/clothing/pants/trou
		wrists = /obj/item/clothing/wrists/bracers/leather
	else
		shirt = /obj/item/clothing/shirt/dress/gen/random

	ADD_TRAIT(H, TRAIT_STEELHEARTED, TRAIT_GENERIC) // Used to dismembering live stock, desensitized to it.

	H.change_stat(STATKEY_STR, 1)
	H.change_stat(STATKEY_CON, 2) // Built sturdy due to HIGH PROTEIN DIET
	H.change_stat(STATKEY_INT, -1)

	H.adjust_skillrank(/datum/skill/combat/knives, 2, TRUE)
	H.adjust_skillrank(/datum/skill/misc/reading, 1, TRUE)
	H.adjust_skillrank(/datum/skill/craft/cooking, 2, TRUE) // Not a trained cook, but knows a thing or two
	H.adjust_skillrank(/datum/skill/combat/wrestling, 2, TRUE)
	H.adjust_skillrank(/datum/skill/combat/unarmed, 2, TRUE)
	H.adjust_skillrank(/datum/skill/labor/taming, 5, TRUE)
	H.adjust_skillrank(/datum/skill/craft/tanning, 2, TRUE) // Better than a soilson, but doesn't outshine a hunter or a weaver
	H.adjust_skillrank(/datum/skill/misc/riding, 1, TRUE)
	H.adjust_skillrank(/datum/skill/craft/crafting, 2, TRUE)
	H.adjust_skillrank(/datum/skill/labor/butchering, 5, TRUE)

