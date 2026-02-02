/datum/job/villager
	title = "Towner"
	tutorial = "You've lived in this shithole for effectively all your life. \
	You are not an explorer, nor exactly a warrior in many cases. \
	You're just some average poor bastard who thinks they'll be something someday."
	department_flag = PEASANTS
	job_flags = (JOB_ANNOUNCE_ARRIVAL | JOB_SHOW_IN_CREDITS | JOB_EQUIP_RANK | JOB_NEW_PLAYER_JOINABLE)
	faction = FACTION_FOREIGNERS
	total_positions = 0
	spawn_positions = 0
	banned_leprosy = FALSE
	bypass_lastclass = TRUE

	advclass_cat_rolls = list(CTAG_TOWNER = 20)
	allowed_races = RACES_PLAYER_ALL

	outfit = null
	outfit_female = null

	give_bank_account = TRUE

/datum/job/villager/after_spawn(mob/living/carbon/spawned, client/player_client)
	..()

/datum/job/villager/New()
	. = ..()
	for(var/X in GLOB.peasant_positions)
		peopleiknow += X
		peopleknowme += X
	for(var/X in GLOB.serf_positions)
		peopleiknow += X
	for(var/X in GLOB.church_positions)
		peopleiknow += X
	for(var/X in GLOB.garrison_positions)
		peopleiknow += X
	for(var/X in GLOB.noble_positions)
		peopleiknow += X
