/datum/job/servant
	title = "Servant"
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

	jobstats = list(
		STATKEY_SPD = 1,
		STATKEY_END = 1
	)

	skills = list(
		/datum/skill/combat/knives = 2,
		/datum/skill/craft/cooking = 3,
		/datum/skill/craft/crafting = 1,
		/datum/skill/labor/butchering = 1,
		/datum/skill/labor/farming = 1,
		/datum/skill/misc/athletics = 2,
		/datum/skill/misc/medicine = 1,
		/datum/skill/misc/reading = 1,
		/datum/skill/misc/sewing = 3,
		/datum/skill/misc/sneaking = 2,
		/datum/skill/misc/stealing = 3
	)

	traits = list(
		TRAIT_ROYALSERVANT
	)

/datum/job/servant/after_spawn(mob/living/carbon/human/spawned, client/player_client)
	. = ..()
	spawned.adjust_skillrank(/datum/skill/craft/crafting, pick(0,0,1), TRUE)
	spawned.adjust_skillrank(/datum/skill/misc/music, pick(0,1,1), TRUE)
	if(spawned.age == AGE_OLD)
		spawned.adjust_skillrank(/datum/skill/craft/cooking, 1, TRUE)
		spawned.adjust_skillrank(/datum/skill/craft/carpentry, 1, TRUE)

/datum/outfit/servant
	name = "Servant"
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

/datum/job/tapster
	title = "Tapster"
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

	jobstats = list(
		STATKEY_SPD = 1,
		STATKEY_END = 1
	)

	skills = list(
		/datum/skill/combat/knives = 2,
		/datum/skill/misc/reading = 1,
		/datum/skill/craft/cooking = 3,
		/datum/skill/labor/butchering = 1,
		/datum/skill/misc/medicine = 1,
		/datum/skill/labor/farming = 1,
		/datum/skill/misc/sewing = 2,
		/datum/skill/craft/crafting = 1,
		/datum/skill/misc/sneaking = 2,
		/datum/skill/misc/stealing = 3
	)

	traits = list(
		TRAIT_BOOZE_SLIDER
	)

/datum/job/tapster/after_spawn(mob/living/carbon/human/spawned, client/player_client)
	. = ..()
	spawned.adjust_skillrank(/datum/skill/misc/music, pick(0,1,1), TRUE)

/datum/outfit/tapster
	name = "Tapster Base"
	shoes = /obj/item/clothing/shoes/simpleshoes
	pants = /obj/item/clothing/pants/tights/colored/uncolored
	shirt = /obj/item/clothing/shirt/undershirt/colored/uncolored
	belt = /obj/item/storage/belt/leather/rope
	beltl = /obj/item/storage/belt/pouch/coins/poor
	backl = /obj/item/storage/backpack/satchel
	backpack_contents = list(/obj/item/recipe_book/cooking = 1)
	neck = /obj/item/key/tavern

/datum/outfit/tapster/pre_equip(mob/living/carbon/human/equipped_human, visuals_only)
	. = ..()
	if(equipped_human.gender == MALE)
		armor = /obj/item/clothing/armor/leather/vest/colored/black
	else
		cloak = /obj/item/clothing/cloak/apron

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

	jobstats = list(
		STATKEY_SPD = 1,
		STATKEY_END = 1
	)

	skills = list(
		/datum/skill/combat/knives = 2,
		/datum/skill/misc/reading = 1,
		/datum/skill/craft/cooking = 3,
		/datum/skill/labor/butchering = 1,
		/datum/skill/misc/medicine = 1,
		/datum/skill/labor/farming = 1,
		/datum/skill/misc/sewing = 2,
		/datum/skill/craft/crafting = 1,
		/datum/skill/misc/sneaking = 2,
		/datum/skill/misc/stealing = 3,
	)

/datum/job/matron_assistant/after_spawn(mob/living/carbon/human/spawned, client/player_client)
	. = ..()
	spawned.adjust_skillrank(/datum/skill/misc/music, pick(0,1,1), TRUE)

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

/datum/job/gaffer_assistant
	title = "Ring Servant"
	tutorial = "I never had what it took to be a mercenary, but I offered my service to the Guild regardless. \
	My vow is to serve whomever holds the ring of Burden while avoiding its curse from befalling me."
	department_flag = APPRENTICES
	job_flags = (JOB_ANNOUNCE_ARRIVAL | JOB_SHOW_IN_CREDITS | JOB_EQUIP_RANK | JOB_NEW_PLAYER_JOINABLE)
	display_order = JDO_SERVANT
	faction = FACTION_TOWN
	total_positions = 1
	spawn_positions = 1
	bypass_lastclass = TRUE
	give_bank_account = TRUE
	cmode_music = 'sound/music/cmode/adventurer/CombatIntense.ogg'

	allowed_races = RACES_PLAYER_ALL

	outfit = /datum/outfit/gaffer_assistant
	exp_types_granted = list(EXP_TYPE_MERCENARY)

	jobstats = list(
		STATKEY_SPD = 1,
		STATKEY_END = 1
	)

	skills = list(
		/datum/skill/combat/knives = 2,
		/datum/skill/misc/reading = 1,
		/datum/skill/craft/cooking = 3,
		/datum/skill/labor/butchering = 1,
		/datum/skill/misc/medicine = 1,
		/datum/skill/labor/farming = 1,
		/datum/skill/misc/sewing = 2,
		/datum/skill/craft/crafting = 1,
		/datum/skill/misc/sneaking = 2,
		/datum/skill/misc/stealing = 3,
		/datum/skill/labor/mathematics = 1,
	)

/datum/job/gaffer_assistant/after_spawn(mob/living/carbon/human/spawned, client/player_client)
	. = ..()
	spawned.adjust_skillrank(/datum/skill/misc/music, pick(0,1,1), TRUE)

/datum/outfit/gaffer_assistant
	name = "Ring Servant"
	shoes = /obj/item/clothing/shoes/simpleshoes
	pants = /obj/item/clothing/pants/tights/colored/uncolored
	shirt = /obj/item/clothing/shirt/undershirt/colored/uncolored
	belt = /obj/item/storage/belt/leather/rope
	beltl = /obj/item/storage/belt/pouch/coins/poor
	beltr = /obj/item/storage/keyring/gaffer_assistant
	backl = /obj/item/storage/backpack/satchel
	backpack_contents = list(/obj/item/recipe_book/cooking = 1)

/datum/outfit/gaffer_assistant/pre_equip(mob/living/carbon/human/equipped_human, visuals_only)
	. = ..()
	if(equipped_human.gender == MALE)
		armor = /obj/item/clothing/armor/leather/vest/colored/black
	else
		cloak = /obj/item/clothing/cloak/apron
