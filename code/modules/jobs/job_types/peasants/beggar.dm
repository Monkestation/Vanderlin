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

	cmode_music = 'sound/music/cmode/towner/CombatBeggar.ogg'

	jobstats = list(
		STATKEY_INT = -3,
		STATKEY_CON = -2,
		STATKEY_END = -2
	)

	skills = list(
		/datum/skill/misc/sneaking = 1,
		/datum/skill/misc/stealing = 1,
		/datum/skill/misc/lockpicking = 1,
		/datum/skill/misc/climbing = 2,
		/datum/skill/combat/wrestling = 1,
		/datum/skill/combat/unarmed = 1,
		/datum/skill/craft/alchemy = 1
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

	// Luck roll
	spawned.base_fortune = rand(1, 20)
	spawned.recalculate_stats(FALSE)

	spawned.adjust_skillrank(/datum/skill/misc/sneaking, pick(1,2,3,4), TRUE)
	spawned.adjust_skillrank(/datum/skill/misc/stealing, pick(1,2,3,4), TRUE)
	spawned.adjust_skillrank(/datum/skill/misc/lockpicking, pick(1,2,3,4), TRUE)
	spawned.adjust_skillrank(/datum/skill/misc/climbing, pick(1,2,3), TRUE)
	spawned.adjust_skillrank(/datum/skill/combat/wrestling, pick(1,2), TRUE)
	spawned.adjust_skillrank(/datum/skill/combat/unarmed, pick(1,2), TRUE)
	spawned.adjust_skillrank(/datum/skill/craft/alchemy, pick(1,2), TRUE)


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
