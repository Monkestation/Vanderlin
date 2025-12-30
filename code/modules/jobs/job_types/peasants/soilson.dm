/datum/job/farmer
	title = "Soilson"
	f_title = "Soilbride"
	tutorial = "It is a simple life you live. \
	Your basic understanding of life is something many would be envious of if they knew how perfect it was. \
	You know a good day's work, the sweat on your brow is yours: \
	Famines and plague may take its toll, but you know how to celebrate life well. \
	Till the soil and produce fresh food for those around you, and maybe you'll be more than an unsung hero someday."
	department_flag = PEASANTS
	job_flags = (JOB_ANNOUNCE_ARRIVAL | JOB_SHOW_IN_CREDITS | JOB_EQUIP_RANK | JOB_NEW_PLAYER_JOINABLE)
	display_order = JDO_SOILSON
	faction = FACTION_TOWN
	total_positions = 12
	spawn_positions = 12
	bypass_lastclass = TRUE
	selection_color = "#553e01"

	allowed_races = RACES_PLAYER_ALL

	outfit = /datum/outfit/farmer
	give_bank_account = 20
	cmode_music = 'sound/music/cmode/towner/CombatTowner.ogg'

	job_bitflag = BITFLAG_CONSTRUCTOR

	jobstats = list(
		STATKEY_STR = 1,
		STATKEY_CON = 1,
		STATKEY_END = 1,
		STATKEY_INT = -1
	)

	skills = list(
		/datum/skill/combat/wrestling = 2,
		/datum/skill/combat/unarmed = 2,
		/datum/skill/combat/knives = 2,
		/datum/skill/combat/polearms = 2,
		/datum/skill/combat/whipsflails = 1,
		/datum/skill/craft/crafting = 2,
		/datum/skill/misc/sewing = 1,
		/datum/skill/labor/farming = 4,
		/datum/skill/labor/taming = 5,
		/datum/skill/misc/reading = 1,
		/datum/skill/craft/cooking = 1,
		/datum/skill/craft/carpentry = 1,
		/datum/skill/misc/medicine = 1,
		/datum/skill/misc/athletics = 3,
		/datum/skill/craft/tanning = 2,
		/datum/skill/misc/riding = 1,
		/datum/skill/labor/butchering = 4
	)

	traits = list(
		TRAIT_DEADNOSE,
		TRAIT_SEEDKNOW
	)

/datum/job/farmer/after_spawn(mob/living/carbon/human/spawned, client/player_client)
	. = ..()
	if(prob(5))
		// Bonus stats
		spawned.adjust_stat_modifier(STATMOD_JOB, STATKEY_STR, 1)
		spawned.adjust_stat_modifier(STATMOD_JOB, STATKEY_END, 1)

		// Bonus skills
		spawned.adjust_skillrank(/datum/skill/combat/wrestling, 1, TRUE)
		spawned.adjust_skillrank(/datum/skill/combat/unarmed, 1, TRUE)
		spawned.adjust_skillrank(/datum/skill/combat/knives, 1, TRUE)
		spawned.adjust_skillrank(/datum/skill/combat/polearms, 2, TRUE)
		spawned.adjust_skillrank(/datum/skill/misc/sewing, 1, TRUE)
		spawned.adjust_skillrank(/datum/skill/misc/swimming, pick(0,1,1), TRUE)
		spawned.adjust_skillrank(/datum/skill/misc/climbing, 2, TRUE)
		spawned.adjust_skillrank(/datum/skill/labor/farming, 2, TRUE)
		spawned.adjust_skillrank(/datum/skill/craft/cooking, 1, TRUE)
		spawned.adjust_skillrank(/datum/skill/labor/butchering, 1, TRUE)
		spawned.adjust_skillrank(/datum/skill/misc/athletics, 1, TRUE)
		spawned.adjust_skillrank(/datum/skill/labor/taming, 2, TRUE)

/datum/outfit/farmer/map_override(mob/living/carbon/human/H)
	if(SSmapping.config.map_name != "Voyage")
		return
	head = /obj/item/clothing/head/armingcap
	shirt = /obj/item/clothing/shirt/undershirt/sailor
	pants = /obj/item/clothing/pants/tights/sailor
	wrists = null
	shoes = /obj/item/clothing/shoes/boots

/datum/outfit/farmer
	name = "Soilson"
	neck = /obj/item/storage/belt/pouch/coins/poor
	shoes = /obj/item/clothing/shoes/simpleshoes
	belt = /obj/item/storage/belt/leather/rope
	beltr = /obj/item/key/soilson
	beltl = /obj/item/weapon/knife/villager
	backl = /obj/item/storage/backpack/satchel/cloth

	backpack_contents = list(
		/obj/item/recipe_book/cooking = 1,
		/obj/item/bottle_kit = 1,
		/obj/item/recipe_book/agriculture = 1
	)

/datum/outfit/farmer/pre_equip(mob/living/carbon/human/equipped_human, visuals_only)
	. = ..()
	if(equipped_human.gender == MALE)
		head = /obj/item/clothing/head/strawhat
		pants = /obj/item/clothing/pants/tights/colored/random
		armor = /obj/item/clothing/armor/gambeson/light/striped
		shirt = /obj/item/clothing/shirt/undershirt/colored/random
	else
		head = /obj/item/clothing/head/armingcap
		armor = /obj/item/clothing/shirt/dress/gen/colored/random
		shirt = /obj/item/clothing/shirt/undershirt


/datum/job/soilchild
	title = "Soilchild"
	f_title = "Soilchild"
	tutorial = "Born to the soil, raised by the land. \
	Your parents teach you the ways of farming while you still find time to play. \
	Though young, you already know the feel of dirt between your fingers and the joy of seeing seeds sprout. \
	Help tend the crops, feed the animals, and learn the ways of your people. \
	One day you'll grow to be a proper Soilson, but for now, enjoy learning the trade."
	department_flag = YOUNGFOLK
	job_flags = (JOB_ANNOUNCE_ARRIVAL | JOB_SHOW_IN_CREDITS | JOB_EQUIP_RANK | JOB_NEW_PLAYER_JOINABLE)
	display_order = JDO_SOILCHILD
	faction = FACTION_TOWN
	total_positions = 6
	spawn_positions = 6
	allowed_ages = list(AGE_CHILD)
	bypass_lastclass = TRUE
	selection_color = "#553e01"
	allowed_races = RACES_PLAYER_ALL
	outfit = /datum/outfit/soilchild
	give_bank_account = 10
	cmode_music = 'sound/music/cmode/towner/CombatTowner.ogg'
	job_bitflag = BITFLAG_CONSTRUCTOR

	jobstats = list(
		STATKEY_STR = -1,
		STATKEY_CON = 1,
		STATKEY_END = -1,
		STATKEY_INT = 1
	)

	skills = list(
		/datum/skill/combat/wrestling = 1,
		/datum/skill/combat/unarmed = 1,
		/datum/skill/combat/polearms = 1,
		/datum/skill/craft/crafting = 1,
		/datum/skill/labor/farming = 2,
		/datum/skill/labor/taming = 1,
		/datum/skill/misc/athletics = 2,
		/datum/skill/misc/climbing = 2,
		/datum/skill/misc/swimming = 1,
		/datum/skill/craft/tanning = 1,
		/datum/skill/labor/butchering = 1
	)

	traits = list(
		TRAIT_DEADNOSE,
		TRAIT_SEEDKNOW
	)

/datum/job/soilchild/after_spawn(mob/living/carbon/human/spawned, client/player_client)
	. = ..()
	if(prob(5))
		spawned.adjust_skillrank(/datum/skill/labor/farming, 1, TRUE)
		spawned.adjust_skillrank(/datum/skill/craft/cooking, 1, TRUE)
		spawned.adjust_skillrank(/datum/skill/misc/athletics, 1, TRUE)
		spawned.adjust_skillrank(/datum/skill/labor/taming, 1, TRUE)
		spawned.adjust_skillrank(/datum/skill/craft/tanning, 1, TRUE)
		spawned.adjust_skillrank(/datum/skill/labor/butchering, 1, TRUE)

/datum/outfit/soilchild
	name = "Soilchild"
	neck = /obj/item/storage/belt/pouch/coins/poor
	shoes = /obj/item/clothing/shoes/simpleshoes
	belt = /obj/item/storage/belt/leather/rope
	beltr = /obj/item/key/soilson
	beltl = /obj/item/weapon/knife/villager

/datum/outfit/soilchild/pre_equip(mob/living/carbon/human/equipped_human)
	. = ..()
	if(equipped_human.gender == MALE)
		head = /obj/item/clothing/head/roguehood/colored/random
		if(prob(50))
			head = /obj/item/clothing/head/strawhat
		pants = /obj/item/clothing/pants/tights/colored/random
		armor = /obj/item/clothing/armor/gambeson/light/striped
		shirt = /obj/item/clothing/shirt/undershirt/colored/random
	else
		head = /obj/item/clothing/head/armingcap
		armor = /obj/item/clothing/shirt/dress/gen/colored/random
		shirt = /obj/item/clothing/shirt/undershirt


