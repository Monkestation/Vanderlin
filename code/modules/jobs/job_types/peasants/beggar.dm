/datum/attribute_holder/sheet/job/vagrant
	attribute_variance = list(
		STAT_FORTUNE = list(-9, 9),
		/datum/attribute/skill/misc/sneaking = list(10, 40),
		/datum/attribute/skill/misc/stealing = list(10, 40),
		/datum/attribute/skill/misc/lockpicking = list(10, 40),
		/datum/attribute/skill/misc/climbing = list(10, 30),
		/datum/attribute/skill/combat/wrestling = list(-10, 10),
		/datum/attribute/skill/combat/unarmed = list(10, 20),
		/datum/attribute/skill/craft/alchemy = list(10, 20),
	)
	raw_attribute_list = list(
		STAT_INTELLIGENCE = -3,
		STAT_CONSTITUTION = -2,
		STAT_ENDURANCE = -2
	)

/datum/job/vagrant
	title = "Beggar"
	tutorial = "The stench of your piss-laden clothes dont bug you anymore, \
	the glances of disgust and loathing others give you is just a friendly greeting; \
	the only reason you've not been killed already is because volfs are known to be repelled by decaying flesh. \
	You're going to be a solemn reminder of what happens when something unwanted is born into this world."
	department_flag = PEASANTS
	display_order = JDO_VAGRANT
	job_flags = (JOB_ANNOUNCE_ARRIVAL | JOB_EQUIP_RANK | JOB_NEW_PLAYER_JOINABLE)
	faction = FACTION_TOWN
	total_positions = 15
	spawn_positions = 15
	bypass_lastclass = TRUE
	banned_leprosy = FALSE

	allowed_races = RACES_PLAYER_ALL

	outfit = /datum/outfit/vagrant
	can_random = FALSE
	can_have_apprentices = FALSE
	can_be_apprentice = TRUE

	cmode_music = 'sound/music/cmode/towner/CombatBeggar.ogg'

	attribute_sheet = /datum/attribute_holder/sheet/job/vagrant

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
	name = "Beggar"

/datum/outfit/vagrant/pre_equip(mob/living/carbon/human/H)
	. = ..()
	if(prob(20))
		head = /obj/item/clothing/head/knitcap
	if(prob(5))
		beltr = /obj/item/reagent_containers/powder/moondust
	if(prob(10))
		beltl = /obj/item/clothing/face/cigarette/rollie/cannabis
	if(prob(10))
		cloak = /obj/item/clothing/cloak/raincloak/colored/brown
	if(prob(10))
		gloves = /obj/item/clothing/gloves/fingerless
	if(prob(5))
		r_hand = /obj/item/weapon/mace/woodclub

	if(H.gender == FEMALE)
		armor = /obj/item/clothing/shirt/rags
	else
		pants = /obj/item/clothing/pants/tights/colored/vagrant
		shirt = /obj/item/clothing/shirt/undershirt/colored/vagrant

	neck = /obj/item/storage/belt/pouch
