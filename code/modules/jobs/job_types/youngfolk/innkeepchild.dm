/datum/job/innkeep_son
	title = "Innkeepers Son"
	f_title = "Innkeepers Daughter"
	tutorial = "One nite the Innkeeper took you in during a harsh winter, \
	you've been thankful ever since."
	department_flag = YOUNGFOLK
	job_flags = (JOB_ANNOUNCE_ARRIVAL | JOB_SHOW_IN_CREDITS | JOB_EQUIP_RANK | JOB_NEW_PLAYER_JOINABLE)
	display_order = JDO_INNKEEP_CHILD
	faction = FACTION_TOWN
	total_positions = 1
	spawn_positions = 1
	bypass_lastclass = TRUE

	allowed_ages = list(AGE_CHILD)
	allowed_races = RACES_PLAYER_ALL

	outfit = /datum/outfit/innkeep_son
	can_have_apprentices = FALSE
	cmode_music = 'sound/music/cmode/towner/CombatInn.ogg'

	job_bitflag = BITFLAG_CONSTRUCTOR

	jobstats = list(
		STATKEY_END = 1,
		STATKEY_STR = -1,
		STATKEY_CON = -1
	)

	skills = list(
		/datum/skill/combat/wrestling = 1,
		/datum/skill/combat/unarmed = 2,
		/datum/skill/craft/cooking = 2,
		/datum/skill/misc/reading = 1,
		/datum/skill/misc/medicine = 1,
		/datum/skill/misc/stealing = 1,
		/datum/skill/misc/climbing = 1,
		/datum/skill/misc/athletics = 1
	)

/datum/outfit/innkeep_son
	name = "Inkeeper Son"
	pants = /obj/item/clothing/pants/tights/colored/random
	shirt = /obj/item/clothing/shirt/shortshirt/colored/random
	shoes = /obj/item/clothing/shoes/shortboots
	belt = /obj/item/storage/belt/leather
	beltl = /obj/item/storage/belt/pouch/coins/poor
	neck = /obj/item/storage/keyring/innkeep

/datum/outfit/innkeep_son/pre_equip(mob/living/carbon/human/equipped_human)
	. = ..()
	if(equipped_human.gender == MALE)
		cloak = /obj/item/clothing/cloak/apron/waist
	else
		armor = /obj/item/clothing/shirt/dress
