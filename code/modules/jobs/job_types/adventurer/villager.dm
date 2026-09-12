/datum/job/villager
	title = JOB_TOWNER
	tutorial = "You've lived in this shithole for effectively all your life. \
	You are not an explorer, nor exactly a warrior in many cases. \
	You're just some average poor bastard who thinks they'll be something someday."
	department_flag = PEASANTS
	job_flags = (JOB_ANNOUNCE_ARRIVAL | JOB_SHOW_IN_CREDITS | JOB_EQUIP_RANK | JOB_NEW_PLAYER_JOINABLE)
	factions = list(FACTION_FOREIGNERS)
	total_positions = 0
	spawn_positions = 0
	banned_leprosy = FALSE
	bypass_lastclass = TRUE

	allowed_races = RACES_PLAYER_ALL
	can_be_apprentice = TRUE

	outfit = null
	outfit_female = null

	give_bank_account = TRUE
	knows_the_town = TRUE
	known_by_the_town = TRUE

/datum/job/villager/setup_known_people()
	for(var/job in jobs_always_know_me)
		jobs_i_know |= job
		jobs_that_know_me |= job

	for(var/X in GLOB.peasant_positions)
		jobs_i_know |= X
		jobs_that_know_me |= X
	for(var/X in GLOB.serf_positions)
		jobs_i_know |= X
	for(var/X in GLOB.church_positions)
		jobs_i_know |= X
	for(var/X in GLOB.garrison_positions)
		jobs_i_know |= X
	for(var/X in GLOB.noble_positions)
		jobs_i_know |= X
