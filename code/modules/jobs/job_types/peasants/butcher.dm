/datum/job/butcher
	title = "Butcher"
	tutorial = "Some say youre a strange individual, \
	some say youre a cheat while some claim you are a savant in the art of sausage making. \
	Without your skilled hands and knifework most of the livestock around the town would be wasted."
	display_order = JDO_BUTCHER
	job_flags = (JOB_ANNOUNCE_ARRIVAL | JOB_SHOW_IN_CREDITS | JOB_EQUIP_RANK | JOB_NEW_PLAYER_JOINABLE)
	department_flag = PEASANTS
	faction = FACTION_TOWN
	total_positions = 0
	spawn_positions = 0
	bypass_lastclass = TRUE

	allowed_races = RACES_PLAYER_ALL

	outfit = /datum/outfit/beastmaster
	give_bank_account = TRUE
	cmode_music = 'sound/music/cmode/towner/CombatInn.ogg'

	job_bitflag = BITFLAG_CONSTRUCTOR

	jobstats = list(
		STATKEY_STR = 1,
		STATKEY_CON = 2,
		STATKEY_INT = -1
	)

	skills = list(
		/datum/skill/combat/knives = 2,
		/datum/skill/misc/reading = 1,
		/datum/skill/craft/cooking = 2,
		/datum/skill/combat/wrestling = 2,
		/datum/skill/combat/unarmed = 2,
		/datum/skill/labor/taming = 5,
		/datum/skill/craft/tanning = 2,
		/datum/skill/misc/riding = 1,
		/datum/skill/craft/crafting = 2,
		/datum/skill/labor/butchering = 5
	)

	traits = list(
		TRAIT_STEELHEARTED
	)

/datum/outfit/beastmaster
	name = "Butcher"
	belt = /obj/item/storage/belt/leather
	beltr = /obj/item/storage/meatbag
	beltl = /obj/item/key/butcher
	backl = /obj/item/storage/backpack/satchel
	armor = /obj/item/clothing/armor/leather/vest/colored/butcher
	shoes = /obj/item/clothing/shoes/boots/leather

	backpack_contents = list(
		/obj/item/kitchen/spoon = 1,
		/obj/item/reagent_containers/food/snacks/truffles = 1,
		/obj/item/weapon/knife/hunting = 1
	)

/datum/outfit/beastmaster/pre_equip(mob/living/carbon/human/equipped_human, visuals_only)
	. = ..()
	if(equipped_human.gender == MALE)
		pants = /obj/item/clothing/pants/trou
		wrists = /obj/item/clothing/wrists/bracers/leather
	else
		shirt = /obj/item/clothing/shirt/dress/gen/colored/random
