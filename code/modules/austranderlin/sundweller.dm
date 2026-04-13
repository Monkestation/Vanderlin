/obj/effect/landmark/start/sundweller
	name = "Sundweller"
	icon_state = "arrow"

/datum/attribute_holder/sheet/job/sundweller
	attribute_variance = list(
		/datum/attribute/skill/misc/sneaking = list(10, 40),
		/datum/attribute/skill/misc/stealing = list(10, 40),
		/datum/attribute/skill/misc/lockpicking = list(10, 40),
		/datum/attribute/skill/combat/wrestling = list(10, 20),
		/datum/attribute/skill/combat/unarmed = list(10, 20),
		/datum/attribute/skill/combat/swords = list(10, 20),
		/datum/attribute/skill/combat/axesmaces = list(10, 20),
		/datum/attribute/skill/craft/alchemy = list(10, 20),
	)
	raw_attribute_list = list(
		STAT_FORTUNE = 3, //You live a blessed existence
		/datum/attribute/skill/misc/climbing = 50,
		/datum/attribute/skill/labor/farming = 20,
		/datum/attribute/skill/craft/cooking = 10,
		/datum/attribute/skill/misc/swimming = 20,
		/datum/attribute/skill/misc/athletics = 20,
		/datum/attribute/skill/labor/fishing = 10,
		/datum/attribute/skill/combat/swords = 20,
		/datum/attribute/skill/misc/sewing = 10,
		/datum/attribute/skill/misc/medicine = 15,
		/datum/attribute/skill/craft/crafting = 10,
	)

/datum/job/sundweller
	title = "Sundweller"
	tutorial = "Well-fed and never cold, your God has given you everything. \
				Working in service of divinity has surely granted you a bright future, \
				as long as the fields are tended, the food is made and God's whims are satisfied. \
				You'll bask in his light and glory, Oh praise be the Sunlord."
	department_flag = OUTSIDERS
	display_order = JDO_SUNDWELLER
	job_flags = (JOB_EQUIP_RANK | JOB_NEW_PLAYER_JOINABLE | JOB_SHOW_IN_CREDITS | JOB_SHOW_IN_ACTOR_LIST)
	faction = FACTION_RATS
	total_positions = 0
	spawn_positions = 0
	bypass_lastclass = TRUE
	banned_leprosy = FALSE

	allowed_races = RACES_PLAYER_ALL

	outfit = /datum/outfit/sundweller
	can_random = FALSE
	can_have_apprentices = FALSE
	can_be_apprentice = FALSE

	cmode_music = 'sound/music/cmode/antag/combat_cult.ogg'

	attribute_sheet = /datum/attribute_holder/sheet/job/sundweller
	exp_types_granted = list(EXP_TYPE_CHURCH, EXP_TYPE_CLERIC)

	traits = list(
		TRAIT_DEADNOSE,
		TRAIT_STINKY,
		TRAIT_ROT_EATER
	)

/datum/job/sundweller/New()
	. = ..()
	peopleknowme = list()

/datum/job/sundweller/after_spawn(mob/living/carbon/human/spawned, client/player_client)
	. = ..()
	spawned.set_patron(/datum/patron/godless/sunlord)
	// Hygiene roll
	if(prob(25))
		spawned.set_hygiene(HYGIENE_LEVEL_DISGUSTING)
	else
		spawned.set_hygiene(HYGIENE_LEVEL_DIRTY)

/datum/outfit/sundweller
	name = "Sundweller"
	head = /obj/item/clothing/head/roguehood/colored/sundweller
	armor = /obj/item/clothing/shirt/robe/colored/sundweller
	belt = /obj/item/storage/belt/leather/rope
	shoes = /obj/item/clothing/shoes/sandals
