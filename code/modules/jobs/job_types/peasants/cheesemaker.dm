/datum/attribute_holder/sheet/job/cheesemaker
	raw_attribute_list = list(
		STAT_INTELLIGENCE = 1,
		STAT_CONSTITUTION = 2,
		/datum/attribute/skill/combat/knives = 20,
		/datum/attribute/skill/misc/athletics = 20,
		/datum/attribute/skill/combat/wrestling = 10,
		/datum/attribute/skill/combat/unarmed = 10,
		/datum/attribute/skill/craft/crafting = 20,
		/datum/attribute/skill/misc/reading = 10,
		/datum/attribute/skill/labor/taming = 10,
		/datum/attribute/skill/craft/cooking = 40,
		/datum/attribute/skill/labor/farming = 20
	)

/datum/job/cheesemaker
	title = "Cheesemaker"
	tutorial = "Some say Dendor brings bountiful harvests - this much is true, but rot brings forth life. \
	From life brings decay, and from decay brings life. Like your father before you, you let milk rot into cheese. \
	This is your duty, this is your call."
	department_flag = PEASANTS
	job_flags = (JOB_ANNOUNCE_ARRIVAL | JOB_SHOW_IN_CREDITS | JOB_EQUIP_RANK | JOB_NEW_PLAYER_JOINABLE)
	display_order = JDO_CHEESEMAKER
	faction = FACTION_TOWN
	total_positions = 0
	spawn_positions = 0

	allowed_races = RACES_PLAYER_ALL
	outfit = /datum/outfit/cheesemaker
	cmode_music = 'sound/music/cmode/towner/CombatTowner2.ogg'
	can_be_apprentice = TRUE

	job_bitflag = BITFLAG_CONSTRUCTOR

	attribute_sheet = /datum/attribute_holder/sheet/job/cheesemaker

	traits = list()

/datum/outfit/cheesemaker
	name = "Cheesemaker"
	belt = /obj/item/storage/belt/leather
	pants = /obj/item/clothing/pants/tights/colored/random
	shirt = /obj/item/clothing/shirt/shortshirt/colored/random
	cloak = /obj/item/clothing/cloak/apron
	shoes = /obj/item/clothing/shoes/simpleshoes
	backl = /obj/item/storage/backpack/backpack
	neck = /obj/item/storage/belt/pouch/coins/poor
	wrists = /obj/item/clothing/wrists/bracers/leather
	beltr = /obj/item/reagent_containers/glass/bottle/waterskin/milk
	beltl = /obj/item/weapon/knife/villager

	backpack_contents = list(
		/obj/item/reagent_containers/powder/salt = 3,
		/obj/item/reagent_containers/food/snacks/cheddar = 1,
		/obj/item/natural/cloth = 2,
		/obj/item/book/yeoldecookingmanual = 1
	)
