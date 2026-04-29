/datum/attribute_holder/sheet/job/innkeep
	raw_attribute_list = list(
		STAT_STRENGTH = 1,
		STAT_ENDURANCE = 1,
		STAT_CONSTITUTION = 1,
		/datum/attribute/skill/combat/wrestling = 20,
		/datum/attribute/skill/combat/unarmed = 30,
		/datum/attribute/skill/misc/reading = 20,
		/datum/attribute/skill/craft/cooking = 30,
		/datum/attribute/skill/misc/medicine = 10,
		/datum/attribute/skill/combat/swords = 20,
		/datum/attribute/skill/labor/mathematics = 20
	)

/datum/job/innkeep
	title = JOB_INNKEEP
	tutorial = "Liquor, lodging, and lavish meals... your business is the beating heart of Vanderlin. \
		You're the one who provides the hardworking townsfolk with a place to eat and drink their sorrows away, \
		and accommodations for weary travelers passing through."
	department_flag = SERFS
	job_flags = (JOB_ANNOUNCE_ARRIVAL | JOB_SHOW_IN_CREDITS | JOB_EQUIP_RANK | JOB_NEW_PLAYER_JOINABLE)
	display_order = JDO_INNKEEP
	faction = FACTION_TOWN
	total_positions = 1
	spawn_positions = 1
	bypass_lastclass = TRUE

	allowed_races = RACES_PLAYER_ALL

	outfit = /datum/outfit/innkeep
	give_bank_account = 60
	cmode_music = 'sound/music/cmode/towner/CombatInn.ogg'

	job_bitflag = BITFLAG_CONSTRUCTOR

	attribute_sheet = /datum/attribute_holder/sheet/job/innkeep

	traits = list(
		TRAIT_BOOZE_SLIDER
	)

	exp_type = list(EXP_TYPE_LIVING)

	exp_requirements = list(
		EXP_TYPE_LIVING = 300
	)

/datum/outfit/innkeep
	name = JOB_INNKEEP
	pants = /obj/item/clothing/pants/tights/colored/random
	shirt = /obj/item/clothing/shirt/shortshirt/colored/random
	shoes = /obj/item/clothing/shoes/shortboots
	belt = /obj/item/storage/belt/leather
	beltl = /obj/item/storage/belt/pouch/coins/mid
	beltr = /obj/item/reagent_containers/glass/bottle/beer/blackgoat
	neck = /obj/item/storage/keyring/innkeep
	cloak = /obj/item/clothing/cloak/apron/waist
	backl = /obj/item/storage/backpack/satchel

	backpack_contents = list(
		/obj/item/recipe_book/cooking,
		/obj/item/bottle_kit
	)

/datum/outfit/innkeep/pre_equip(mob/living/carbon/human/equipped_human, visuals_only)
	..()
	if(equipped_human.gender == FEMALE)
		armor = /obj/item/clothing/shirt/dress
		shoes = /obj/item/clothing/shoes/shortboots
		neck = /obj/item/storage/belt/pouch/coins/mid
		belt = /obj/item/storage/belt/leather
		beltl = /obj/item/storage/keyring/innkeep
		beltr = /obj/item/reagent_containers/glass/bottle/beer/blackgoat
