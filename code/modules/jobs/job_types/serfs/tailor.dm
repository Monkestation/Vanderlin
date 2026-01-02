/datum/job/tailor
	title = "Tailor"
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


	jobstats = list(
		STATKEY_INT = 2,
		STATKEY_SPD = 2,
		STATKEY_PER = 1,
		STATKEY_STR = -1
	)

	skills = list(
		/datum/skill/misc/sewing = 3,
		/datum/skill/craft/tanning = 2,
		/datum/skill/craft/crafting = 3,
		/datum/skill/combat/knives = 3,
		/datum/skill/misc/sneaking = 2,
		/datum/skill/labor/taming = 3,
		/datum/skill/misc/medicine = 2,
		/datum/skill/misc/reading = 1,
		/datum/skill/craft/carpentry = 1,
		/datum/skill/misc/stealing = 1,
		/datum/skill/labor/mathematics = 2
	)

	traits = list(
		TRAIT_SEEPRICES
	)

/datum/job/tailor/after_spawn(mob/living/carbon/human/spawned, client/player_client)
	. = ..()
	spawned.adjust_skillrank(/datum/skill/misc/sewing, pick(1, 2), TRUE)
	spawned.adjust_skillrank(/datum/skill/craft/tanning, pick(1, 2), TRUE)

/datum/outfit/tailor
	name = "Tailor"
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
