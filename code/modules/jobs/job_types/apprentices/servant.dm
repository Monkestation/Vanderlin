/datum/attribute_holder/sheet/job/servant
	raw_attribute_list = list(
		STAT_SPEED = 1,
		STAT_ENDURANCE = 1,

		/datum/attribute/skill/combat/knives = 20,
		/datum/attribute/skill/craft/cooking = 30,
		/datum/attribute/skill/craft/crafting = 10,
		/datum/attribute/skill/labor/butchering = 10,
		/datum/attribute/skill/labor/farming = 10,
		/datum/attribute/skill/misc/athletics = 20,
		/datum/attribute/skill/misc/medicine = 10,
		/datum/attribute/skill/misc/reading = 10,
		/datum/attribute/skill/misc/sewing = 30,
		/datum/attribute/skill/misc/sneaking = 20,
		/datum/attribute/skill/misc/stealing = 30
	)

	attribute_variance = list(
		/datum/attribute/skill/craft/crafting = list(0,10),
		/datum/attribute/skill/misc/music = list(0,10)
	)

/datum/attribute_holder/sheet/job/servant/old
	raw_attribute_list = list(
		STAT_SPEED = 1,
		STAT_ENDURANCE = 1,

		/datum/attribute/skill/combat/knives = 20,
		/datum/attribute/skill/craft/cooking = 40,
		/datum/attribute/skill/craft/crafting = 10,
		/datum/attribute/skill/craft/carpentry = 10,
		/datum/attribute/skill/labor/butchering = 10,
		/datum/attribute/skill/labor/farming = 10,
		/datum/attribute/skill/misc/athletics = 20,
		/datum/attribute/skill/misc/medicine = 10,
		/datum/attribute/skill/misc/reading = 10,
		/datum/attribute/skill/misc/sewing = 30,
		/datum/attribute/skill/misc/sneaking = 20,
		/datum/attribute/skill/misc/stealing = 30
	)

/datum/job/servant
	title = JOB_SERVANT
	tutorial = "You are the faceless, nameless labor that keeps the royal court fed, washed, and attended to. \
	You work your fingers to the bone nearly every dae, \
	and have naught to show for it but boney fingers. \
	Perhaps this week you will finally be recognized, or allowed some respite?"
	department_flag = APPRENTICES
	job_flags = (JOB_ANNOUNCE_ARRIVAL | JOB_SHOW_IN_CREDITS | JOB_EQUIP_RANK | JOB_NEW_PLAYER_JOINABLE)
	display_order = JDO_SERVANT
	faction = FACTION_TOWN
	total_positions = 5
	spawn_positions = 5
	bypass_lastclass = TRUE
	give_bank_account = TRUE
	cmode_music = 'sound/music/cmode/towner/CombatPrisoner.ogg'
	can_have_apprentices = FALSE

	allowed_ages = ALL_AGES_LIST_CHILD
	allowed_races = RACES_PLAYER_ALL

	outfit = /datum/outfit/servant
	attribute_sheet = /datum/attribute_holder/sheet/job/servant
	attribute_sheet_old = /datum/attribute_holder/sheet/job/servant/old

	mind_traits = list(
		TRAIT_ROYALSERVANT
	)

/datum/outfit/servant
	name = JOB_SERVANT
	neck = /obj/item/key/manor
	backl = /obj/item/storage/backpack/satchel
	backpack_contents = list(
		/obj/item/recipe_book/cooking = 1,
		/obj/item/storage/belt/pouch/coins/poor = 1
	)

/datum/outfit/servant/pre_equip(mob/living/carbon/human/equipped_human, visuals_only)
	. = ..()
	if(equipped_human.gender == MALE)
		shirt = /obj/item/clothing/shirt/undershirt/formal
		if(equipped_human.age == AGE_OLD)
			pants = /obj/item/clothing/pants/trou/formal
		else
			pants = /obj/item/clothing/pants/trou/formal/shorts
		belt = /obj/item/storage/belt/leather/suspenders
		shoes = /obj/item/clothing/shoes/boots
	else
		armor = /obj/item/clothing/shirt/dress/maid/servant
		shoes = /obj/item/clothing/shoes/simpleshoes
		belt = /obj/item/storage/belt/leather/cloth_belt
		pants = /obj/item/clothing/pants/tights/colored/white
		cloak = /obj/item/clothing/cloak/apron/maid
		head = /obj/item/clothing/head/maidband

/datum/attribute_holder/sheet/job/tapster
	raw_attribute_list = list(
		STAT_SPEED = 1,
		STAT_ENDURANCE = 1,

		/datum/attribute/skill/combat/knives = 20,
		/datum/attribute/skill/misc/reading = 10,
		/datum/attribute/skill/craft/cooking = 30,
		/datum/attribute/skill/labor/butchering = 10,
		/datum/attribute/skill/misc/medicine = 10,
		/datum/attribute/skill/labor/farming = 10,
		/datum/attribute/skill/misc/sewing = 20,
		/datum/attribute/skill/craft/crafting = 10,
		/datum/attribute/skill/misc/sneaking = 20,
		/datum/attribute/skill/misc/stealing = 30
	)

	attribute_variance = list(
		/datum/attribute/skill/misc/music = list(0,10)
	)

/datum/job/tapster
	title = JOB_TAPSTER
	f_title = "Alemaid"
	tutorial = "The Innkeeper needed waiters and extra hands. So here am I, serving the food and drinks while ensuring the tavern rooms are kept clean."
	department_flag = APPRENTICES
	job_flags = (JOB_ANNOUNCE_ARRIVAL | JOB_SHOW_IN_CREDITS | JOB_EQUIP_RANK | JOB_NEW_PLAYER_JOINABLE)
	display_order = JDO_SERVANT
	faction = FACTION_TOWN
	total_positions = 2
	spawn_positions = 2

	bypass_lastclass = TRUE

	allowed_races = RACES_PLAYER_ALL

	outfit = /datum/outfit/tapster
	give_bank_account = TRUE
	can_have_apprentices = FALSE
	cmode_music = 'sound/music/cmode/towner/CombatInn.ogg'

	allowed_races = RACES_PLAYER_ALL

	outfit = /datum/outfit/tapster

	attribute_sheet = /datum/attribute_holder/sheet/job/tapster

	traits = list(
		TRAIT_BOOZE_SLIDER
	)

/datum/outfit/tapster
	name = "Tapster Base"
	shoes = /obj/item/clothing/shoes/simpleshoes
	pants = /obj/item/clothing/pants/tights/colored/uncolored
	shirt = /obj/item/clothing/shirt/undershirt/colored/uncolored
	belt = /obj/item/storage/belt/leather/rope
	beltl = /obj/item/storage/belt/pouch/coins/poor
	backl = /obj/item/storage/backpack/satchel/cloth
	backpack_contents = list(/obj/item/recipe_book/cooking = 1)
	neck = /obj/item/key/tavern

/datum/outfit/tapster/pre_equip(mob/living/carbon/human/equipped_human, visuals_only)
	. = ..()
	if(equipped_human.gender == MALE)
		armor = /obj/item/clothing/armor/leather/vest/colored/black
	else
		cloak = /obj/item/clothing/cloak/apron

/datum/attribute_holder/sheet/job/matron_assistant
	raw_attribute_list = list(
		STAT_SPEED = 1,
		STAT_ENDURANCE = 1,

		/datum/attribute/skill/combat/knives = 20,
		/datum/attribute/skill/misc/reading = 10,
		/datum/attribute/skill/craft/cooking = 30,
		/datum/attribute/skill/labor/butchering = 10,
		/datum/attribute/skill/misc/medicine = 10,
		/datum/attribute/skill/labor/farming = 10,
		/datum/attribute/skill/misc/sewing = 20,
		/datum/attribute/skill/craft/crafting = 10,
		/datum/attribute/skill/misc/sneaking = 20,
		/datum/attribute/skill/misc/stealing = 30
	)

	attribute_variance = list(
		/datum/attribute/skill/misc/music = list(0,10)
	)

/datum/job/matron_assistant
	title = "Orphanage Assistant"
	tutorial = "I once was an orphan, the matron took me in and now I am forever in her debt. \
	That orphanage, those who were like me need guidance, I shall assist the matron in her tasks."
	department_flag = APPRENTICES
	job_flags = (JOB_ANNOUNCE_ARRIVAL | JOB_SHOW_IN_CREDITS | JOB_EQUIP_RANK | JOB_NEW_PLAYER_JOINABLE)
	display_order = JDO_SERVANT
	faction = FACTION_TOWN
	total_positions = 0
	spawn_positions = 0
	bypass_lastclass = TRUE
	give_bank_account = TRUE
	can_have_apprentices = FALSE

	allowed_races = RACES_PLAYER_ALL

	outfit = /datum/outfit/matron_assistant

	attribute_sheet = /datum/attribute_holder/sheet/job/matron_assistant

/datum/outfit/matron_assistant
	name = "Orphanage Assistant Base"
	shoes = /obj/item/clothing/shoes/simpleshoes
	pants = /obj/item/clothing/pants/tights/colored/uncolored
	shirt = /obj/item/clothing/shirt/undershirt/colored/uncolored
	belt = /obj/item/storage/belt/leather/rope
	beltl = /obj/item/storage/belt/pouch/coins/poor
	neck = /obj/item/key/matron
	backl = /obj/item/storage/backpack/satchel
	backpack_contents = list(/obj/item/recipe_book/cooking = 1)

/datum/outfit/matron_assistant/pre_equip(mob/living/carbon/human/equipped_human, visuals_only)
	. = ..()
	if(equipped_human.gender == MALE)
		armor = /obj/item/clothing/armor/leather/vest/colored/black
	else
		cloak = /obj/item/clothing/cloak/apron
