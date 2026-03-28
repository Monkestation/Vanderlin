/datum/attribute_holder/sheet/job/vagrant
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
	)

/datum/job/vagrant
	title = "Sundweller"
	tutorial = "The stench of your piss-laden clothes dont bug you anymore, \
	the glances of disgust and loathing others give you is just a friendly greeting; \
	the only reason you've not been killed already is because volfs are known to be repelled by decaying flesh. \
	You're going to be a solemn reminder of what happens when something unwanted is born into this world."
	department_flag = PEASANTS
	display_order = JDO_VAGRANT
	job_flags = (JOB_ANNOUNCE_ARRIVAL | JOB_EQUIP_RANK | JOB_NEW_PLAYER_JOINABLE)
	faction = FACTION_TOWN
	total_positions = 4
	spawn_positions = 4
	bypass_lastclass = TRUE
	banned_leprosy = FALSE

	allowed_races = RACES_PLAYER_ALL

	outfit = /datum/outfit/vagrant
	can_random = FALSE
	can_have_apprentices = FALSE
	can_be_apprentice = FALSE

	cmode_music = 'sound/music/cmode/antag/combat_cult.ogg'

	attribute_sheet = /datum/attribute_holder/sheet/job/vagrant

	traits = list(
		TRAIT_NOBLE_BLOOD,
		TRAIT_DEADNOSE,
		TRAIT_STINKY,
		TRAIT_ROT_EATER
	)

/datum/job/vagrant/New()
	. = ..()
	peopleknowme = list()

/datum/job/vagrant/after_spawn(mob/living/carbon/human/spawned, client/player_client)
	. = ..()
	// Hygiene roll
	if(prob(25))
		spawned.set_hygiene(HYGIENE_LEVEL_DISGUSTING)
	else
		spawned.set_hygiene(HYGIENE_LEVEL_DIRTY)

/datum/outfit/vagrant
	name = "Sundweller"

/datum/outfit/vagrant/pre_equip(mob/living/carbon/human/H)
	. = ..()
	head = /obj/item/clothing/head/roguehood/sundweller
	armor = /obj/item/clothing/shirt/robe/colored/sundweller
	belt = /obj/item/storage/belt/leather/rope
	shoes = /obj/item/clothing/shoes/sandals
