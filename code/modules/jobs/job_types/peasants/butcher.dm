/datum/attribute_holder/sheet/job/butcher
	raw_attribute_list = list(
		STAT_STRENGTH = 1,
		STAT_CONSTITUTION = 2,
		STAT_INTELLIGENCE = -1,
		/datum/attribute/skill/combat/knives = 20,
		/datum/attribute/skill/misc/reading = 10,
		/datum/attribute/skill/craft/cooking = 20,
		/datum/attribute/skill/combat/wrestling = 20,
		/datum/attribute/skill/combat/unarmed = 20,
		/datum/attribute/skill/labor/taming = 50,
		/datum/attribute/skill/craft/tanning = 20,
		/datum/attribute/skill/misc/riding = 10,
		/datum/attribute/skill/craft/crafting = 20,
		/datum/attribute/skill/labor/butchering = 50
	)

/datum/job/butcher
	title = JOB_BUTCHER
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
	attribute_sheet = /datum/attribute_holder/sheet/job/butcher
	outfit = /datum/outfit/beastmaster
	give_bank_account = TRUE
	cmode_music = 'sound/music/cmode/towner/CombatInn.ogg'
	can_be_apprentice = TRUE

	job_bitflag = BITFLAG_CONSTRUCTOR

	traits = list(
		TRAIT_STEELHEARTED
	)

/datum/outfit/beastmaster
	name = JOB_BUTCHER
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
