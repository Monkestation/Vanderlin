/datum/attribute_holder/sheet/job/tailor
	attribute_variance = list(
		/datum/attribute/skill/misc/sewing = list(10, 20),
		/datum/attribute/skill/craft/tanning = list(10, 20),
	)
	raw_attribute_list = list(
		STAT_INTELLIGENCE = 2,
		STAT_SPEED = 1,
		STAT_PERCEPTION = 1,
		STAT_STRENGTH = -1,
		/datum/attribute/skill/misc/sewing = 30,
		/datum/attribute/skill/craft/tanning = 20,
		/datum/attribute/skill/craft/crafting = 30,
		/datum/attribute/skill/combat/knives = 20,
		/datum/attribute/skill/misc/sneaking = 20,
		/datum/attribute/skill/labor/taming = 30,
		/datum/attribute/skill/misc/medicine = 20,
		/datum/attribute/skill/misc/reading = 10,
		/datum/attribute/skill/craft/carpentry = 10,
		/datum/attribute/skill/misc/stealing = 10,
		/datum/attribute/skill/labor/mathematics = 20
	)

/datum/job/tailor
	title = JOB_TAILOR
	f_title = "Seamstress"
	tutorial = "Cloth, linen, silk and leather. \
	You've tirelessly studied and poured your life into \
	sewing articles of protection, padding, and fashion for serf and noble alike."
	department_flag = SERFS
	job_flags = (JOB_ANNOUNCE_ARRIVAL | JOB_SHOW_IN_CREDITS | JOB_EQUIP_RANK | JOB_NEW_PLAYER_JOINABLE)
	display_order = JDO_TAILOR
	faction = FACTION_TOWN
	total_positions = 1
	spawn_positions = 1
	bypass_lastclass = TRUE

	allowed_races = RACES_PLAYER_ALL

	outfit = /datum/outfit/tailor
	give_bank_account = 25
	cmode_music = 'sound/music/cmode/towner/CombatTowner2.ogg'

	job_bitflag = BITFLAG_CONSTRUCTOR

	attribute_sheet = /datum/attribute_holder/sheet/job/tailor

	traits = list(
		TRAIT_SEEPRICES
	)

/datum/outfit/tailor
	name = JOB_TAILOR
	pants = /obj/item/clothing/pants/tights/colored/red
	shirt = /obj/item/clothing/shirt/undershirt/colored/red
	armor = /obj/item/clothing/shirt/tunic/colored/red
	cloak = /obj/item/clothing/cloak/raincloak/furcloak
	shoes = /obj/item/clothing/shoes/nobleboot
	head = /obj/item/clothing/head/courtierhat
	belt = /obj/item/storage/belt/leather
	beltr = /obj/item/weapon/knife/scissors
	beltl = /obj/item/key/tailor
	backr = /obj/item/storage/backpack/satchel
	neck = /obj/item/storage/belt/pouch/coins/mid

	backpack_contents = list(
		/obj/item/needle = 1,
		/obj/item/natural/bundle/cloth/full = 1,
		/obj/item/natural/bundle/fibers/full = 1,
		/obj/item/dye_pack/luxury = 1,
		/obj/item/recipe_book/sewing_leather = 1,
		/obj/item/weapon/knife/villager = 1
	)

/datum/outfit/tailor/pre_equip(mob/living/carbon/human/equipped_human, visuals_only)
	. = ..()
	if(equipped_human.gender == FEMALE)
		cloak = /obj/item/clothing/cloak/raincloak/furcloak
		shirt = /obj/item/clothing/shirt/dress/gen/colored/purple
		armor = /obj/item/clothing/shirt/tunic/colored/purple
		pants = /obj/item/clothing/pants/tights/colored/purple
