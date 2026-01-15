/datum/job/folkhero
	title = "Folkhero"
	tutorial = "People recognize you wherever you go, your fame has reached quite a lot of ears.\
	\n\n\
	You are a renowned adventurer, known to many as someone of some skill,  \
	today's a new dae seeking new horizons. \
	\n\n\
	You look forwards. Glory awaits."
	department_flag = OUTSIDERS
	job_flags = (JOB_SHOW_IN_CREDITS | JOB_EQUIP_RANK)
	faction = FACTION_FOREIGNERS
	total_positions = 0
	spawn_positions = 0
	bypass_lastclass = TRUE

	allowed_races = RACES_PLAYER_ALL
	blacklisted_species = list(SPEC_ID_HALFLING, SPEC_ID_KOBOLD, SPEC_ID_HARPY, SPEC_ID_HOLLOWKIN, SPEC_ID_RAKSHARI)

	outfit = null
	outfit_female = null
	advclass_cat_rolls = list(CTAG_FOLKHEROES = 20)
	is_foreigner = TRUE
	is_recognized = TRUE

	exp_type = list(EXP_TYPE_LIVING)
	exp_types_granted = list(EXP_TYPE_ADVENTURER, EXP_TYPE_COMBAT)
	exp_requirements = list(
		EXP_TYPE_LIVING = 600
	)

/datum/job/folkhero/after_spawn(mob/living/carbon/human/spawned, client/player_client)
	. = ..()
	spawned.add_quirk(/datum/quirk/boon/folk_hero)

/datum/job/advclass/folkhero
	abstract_type = /datum/job/advclass/folkhero
	category_tags = list(CTAG_FOLKHEROES)
	exp_types_granted = list(EXP_TYPE_ADVENTURER, EXP_TYPE_COMBAT)

