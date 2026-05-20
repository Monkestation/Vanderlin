/datum/attribute_holder/sheet/job/farmer
	raw_attribute_list = list(
		STAT_STRENGTH = 1,
		STAT_CONSTITUTION = 2,
		STAT_ENDURANCE = 1,
		STAT_INTELLIGENCE = -1,
		/datum/attribute/skill/combat/wrestling = 10,
		/datum/attribute/skill/combat/unarmed = 20,
		/datum/attribute/skill/combat/knives = 20,
		/datum/attribute/skill/combat/polearms = 20,
		/datum/attribute/skill/combat/whipsflails = 10,
		/datum/attribute/skill/craft/crafting = 20,
		/datum/attribute/skill/misc/sewing = 10,
		/datum/attribute/skill/labor/farming = 40,
		/datum/attribute/skill/labor/taming = 50,
		/datum/attribute/skill/misc/reading = 10,
		/datum/attribute/skill/craft/cooking = 10,
		/datum/attribute/skill/craft/carpentry = 10,
		/datum/attribute/skill/misc/medicine = 10,
		/datum/attribute/skill/misc/athletics = 30,
		/datum/attribute/skill/craft/tanning = 20,
		/datum/attribute/skill/misc/riding = 10,
		/datum/attribute/skill/labor/butchering = 40
	)

/datum/job/farmer
	title = JOB_SOILSON
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
	can_be_apprentice = TRUE

	job_bitflag = BITFLAG_CONSTRUCTOR

	attribute_sheet = /datum/attribute_holder/sheet/job/farmer

	traits = list(
		TRAIT_DEADNOSE,
		TRAIT_SEEDKNOW
	)

/datum/outfit/farmer/map_override(mob/living/carbon/human/H)
	if(SSmapping.config.map_name != "Voyage")
		return
	head = /obj/item/clothing/head/armingcap
	shirt = /obj/item/clothing/shirt/undershirt/sailor
	pants = /obj/item/clothing/pants/tights/sailor
	wrists = null
	shoes = /obj/item/clothing/shoes/boots

/datum/outfit/farmer
	name = JOB_SOILSON
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

/datum/attribute_holder/sheet/job/soilchild
	raw_attribute_list = list(
		STAT_STRENGTH = -1,
		STAT_CONSTITUTION = 1,
		STAT_ENDURANCE = -1,
		STAT_INTELLIGENCE = 1,
		/datum/attribute/skill/combat/wrestling = 10,
		/datum/attribute/skill/combat/unarmed = 10,
		/datum/attribute/skill/combat/polearms = 10,
		/datum/attribute/skill/craft/crafting = 10,
		/datum/attribute/skill/labor/farming = 20,
		/datum/attribute/skill/labor/taming = 10,
		/datum/attribute/skill/misc/athletics = 20,
		/datum/attribute/skill/misc/climbing = 20,
		/datum/attribute/skill/misc/swimming = 10,
		/datum/attribute/skill/craft/tanning = 10,
		/datum/attribute/skill/labor/butchering = 10
	)

/datum/job/soilchild
	title = JOB_SOILCHILD
	f_title = JOB_SOILCHILD
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

	attribute_sheet = /datum/attribute_holder/sheet/job/soilchild

	traits = list(
		TRAIT_DEADNOSE,
		TRAIT_SEEDKNOW
	)

/datum/outfit/soilchild
	name = JOB_SOILCHILD
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


