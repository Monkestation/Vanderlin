/datum/job/adventurer/courtagent
	title = "Court Agent"
	tutorial = "Whether acquired by merit, shrewd negotiation or fulfilled bounties, \
	you have found yourself under the underhanded employ of the Hand. \
	Fulfill desires and whims of the court that they would rather not be publicly known. \
	Your position is anything but secure, and any mistake can leave you disowned and charged like the petty criminal you are. \
	Garrison and Court members know who you are."
	job_flags = (JOB_EQUIP_RANK | JOB_NEW_PLAYER_JOINABLE)
	total_positions = 0
	spawn_positions = 2

	outfit = null
	outfit_female = null

	always_show_on_latechoices = FALSE
	job_reopens_slots_on_death = FALSE
	shows_in_list = FALSE
	can_have_apprentices = FALSE
	scales = FALSE

	exp_types_granted  = list(EXP_TYPE_COMBAT)

//Hooking in here does not mess with their equipment procs
/datum/job/adventurer/courtagent/after_spawn(mob/living/spawned, client/player_client)
	if(ishuman(spawned))
		GLOB.roundstart_court_agents += spawned.real_name
	..()
