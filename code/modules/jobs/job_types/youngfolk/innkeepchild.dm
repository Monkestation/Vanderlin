/datum/attribute_holder/sheet/job/innkeep_son
	raw_attribute_list = list(
		STAT_ENDURANCE = 1,
		STAT_STRENGTH = -1,
		STAT_CONSTITUTION = -1,
		/datum/attribute/skill/combat/wrestling = 10,
		/datum/attribute/skill/combat/unarmed = 20,
		/datum/attribute/skill/craft/cooking = 20,
		/datum/attribute/skill/misc/reading = 10,
		/datum/attribute/skill/misc/medicine = 10,
		/datum/attribute/skill/misc/stealing = 10,
		/datum/attribute/skill/misc/climbing = 10,
		/datum/attribute/skill/misc/athletics = 10
	)

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
	can_be_apprentice = TRUE
	cmode_music = 'sound/music/cmode/towner/CombatInn.ogg'

	job_bitflag = BITFLAG_CONSTRUCTOR

	attribute_sheet = /datum/attribute_holder/sheet/job/innkeep_son

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
