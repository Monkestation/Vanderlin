/datum/job/orphan
	title = "Orphan"
	tutorial = "Before you could even form words, you were abandoned, or perhaps lost. \
	Ever since, you have lived in the Orphanage under the Matron's care. \
	Will you make something of yourself, or will you die in the streets as a nobody?"
	department_flag = YOUNGFOLK
	job_flags = (JOB_EQUIP_RANK | JOB_NEW_PLAYER_JOINABLE)
	display_order = JDO_ORPHAN
	faction = FACTION_TOWN
	total_positions = 12
	spawn_positions = 12
	bypass_lastclass = TRUE

	allowed_races = RACES_PLAYER_ALL
	allowed_ages = list(AGE_CHILD)

	outfit = /datum/outfit/orphan
	can_have_apprentices = FALSE
	cmode_music = 'sound/music/cmode/towner/CombatTowner.ogg'

	jobstats = list(
		STATKEY_CON = -1,
		STATKEY_END = -1
	)

	skills = list(
		/datum/skill/misc/sneaking = 2,
		/datum/skill/misc/stealing = 4,
		/datum/skill/misc/climbing = 4
	)

	traits = list(
		TRAIT_ORPHAN
	)

/datum/job/orphan/New()
	. = ..()
	peopleknowme = list()


/datum/job/orphan/after_spawn(mob/living/carbon/human/spawned, client/player_client)
	. = ..()
	var/orphanage_renovated = FALSE
	if(has_world_trait(/datum/world_trait/orphanage_renovated))
		orphanage_renovated = TRUE

	if(!orphanage_renovated)
		spawned.adjust_stat_modifier(STATMOD_JOB, STATKEY_INT, rand(-4, 4))
		spawned.base_fortune = rand(1,20)
	else
		spawned.adjust_stat_modifier(STATMOD_JOB, STATKEY_INT, 4)
		spawned.adjust_stat_modifier(STATMOD_JOB, STATKEY_CON, 2)
		spawned.adjust_stat_modifier(STATMOD_JOB, STATKEY_END, 2)
		spawned.base_fortune = rand(7,20)

	var/hand_1 = spawned.get_active_held_item()
	var/hand_2 = spawned.get_inactive_held_item()

	if(istype(hand_1, /obj/item/instrument) || istype(hand_2, /obj/item/instrument))
		spawned.adjust_skillrank(/datum/skill/misc/music, pick(2,3,4), TRUE)

/datum/outfit/orphan
	name = "Orphan"

/datum/outfit/orphan/pre_equip(mob/living/carbon/human/equipped_human)
	. = ..()
	var/orphanage_renovated = FALSE
	if(has_world_trait(/datum/world_trait/orphanage_renovated))
		orphanage_renovated = TRUE

	if(orphanage_renovated)
		neck = /obj/item/storage/belt/pouch/coins/poor
		shirt = /obj/item/clothing/shirt/undershirt/colored/random
		pants = /obj/item/clothing/pants/tights/colored/random
		belt = /obj/item/storage/belt/leather/rope
		shoes = /obj/item/clothing/shoes/simpleshoes
	else
		if(prob(50))
			shirt = /obj/item/clothing/shirt/undershirt/colored/vagrant
			pants = /obj/item/clothing/pants/tights/colored/vagrant
		else
			armor = /obj/item/clothing/shirt/rags

	if(prob(35) || orphanage_renovated)
		cloak = pick(/obj/item/clothing/cloak/half, /obj/item/clothing/cloak/half/colored/brown)

	if(prob(30) || orphanage_renovated)
		head = pick(
			/obj/item/clothing/head/knitcap,
			/obj/item/clothing/head/bardhat,
			/obj/item/clothing/head/courtierhat,
			/obj/item/clothing/head/fancyhat,
		)

	if(prob(15) || orphanage_renovated)
		r_hand = pick(
			/obj/item/instrument/lute,
			/obj/item/instrument/accord,
			/obj/item/instrument/guitar,
			/obj/item/instrument/flute,
			/obj/item/instrument/hurdygurdy,
			/obj/item/instrument/viola,
		)
