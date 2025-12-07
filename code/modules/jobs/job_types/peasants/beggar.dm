
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
	min_pq = -100
	bypass_lastclass = TRUE
	banned_leprosy = FALSE

	allowed_races = RACES_PLAYER_ALL

	outfit = /datum/outfit/vagrant
	can_random = FALSE

	can_have_apprentices = FALSE
	cmode_music = 'sound/music/cmode/towner/CombatBeggar.ogg'

/datum/job/vagrant/New()
	. = ..()
	peopleknowme = list()

/datum/job/vagrant/after_spawn(mob/living/spawned, client/player_client)
	..()
	if(ishuman(spawned))
		var/mob/living/carbon/human/stinky_boy = spawned
		if(prob(25))
			stinky_boy.set_hygiene(HYGIENE_LEVEL_DISGUSTING)
		else
			stinky_boy.set_hygiene(HYGIENE_LEVEL_DIRTY)

/datum/outfit/vagrant/pre_equip(mob/living/carbon/human/H)
	..()
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
	if(H.gender == FEMALE)
		armor = /obj/item/clothing/shirt/rags
	else
		pants = /obj/item/clothing/pants/tights/colored/vagrant
		shirt = /obj/item/clothing/shirt/undershirt/colored/vagrant

	H.adjust_skillrank(/datum/skill/misc/sneaking, pick(1,2,3,4,5), TRUE)
	H.adjust_skillrank(/datum/skill/misc/stealing, pick(1,2,3,4,5), TRUE)
	H.adjust_skillrank(/datum/skill/misc/lockpicking, pick (1,2,3,4,5), TRUE) // thug life
	H.adjust_skillrank(/datum/skill/misc/climbing, pick(2,3,4,5), TRUE)
	H.adjust_skillrank(/datum/skill/combat/wrestling, pick(1,2,3), TRUE) // Street-fu
	H.adjust_skillrank(/datum/skill/combat/unarmed, pick(1,2,3), TRUE)
	H.adjust_skillrank(/datum/skill/craft/alchemy, pick(1,2,3), TRUE)
	H.base_fortune = rand(1, 20)
	H.recalculate_stats(FALSE)
	if(prob(5))
		r_hand = /obj/item/weapon/mace/woodclub
	H.change_stat(STATKEY_INT, -3)
	H.change_stat(STATKEY_CON, -2)
	H.change_stat(STATKEY_END, -2)

/datum/outfit/vagrant
	name = "Beggar"

