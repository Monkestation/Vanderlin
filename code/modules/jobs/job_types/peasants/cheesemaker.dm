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

	job_bitflag = BITFLAG_CONSTRUCTOR

	jobstats = list(
		STATKEY_INT = 1,
		STATKEY_CON = 2
	)

	skills = list(
		/datum/skill/combat/knives = 2,
		/datum/skill/misc/athletics = 2,
		/datum/skill/combat/wrestling = 1,
		/datum/skill/combat/unarmed = 1,
		/datum/skill/craft/crafting = 2,
		/datum/skill/misc/reading = 1,
		/datum/skill/labor/taming = 1,
		/datum/skill/craft/cooking = 4,
		/datum/skill/labor/farming = 2
	)

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
