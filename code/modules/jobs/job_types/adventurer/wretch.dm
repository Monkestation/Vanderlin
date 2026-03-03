/datum/job/wretch
	title = "Wretch"
	tutorial = "Somewhere in your lyfe, you fell to the wrong side of civilization. Hounded by the consequences of your actions, you now threaten the peace of those who still heed the authority that condemned you."
	department_flag = OUTSIDERS
	job_flags = (JOB_EQUIP_RANK | JOB_NEW_PLAYER_JOINABLE | JOB_SHOW_IN_CREDITS)
	display_order = JDO_WRETCH
	faction = FACTION_NEUTRAL
	total_positions = 2
	spawn_positions = 2

	advclass_cat_rolls = list(CTAG_WRETCH = 20)
	blacklisted_species = list(SPEC_ID_HALFLING)

	is_foreigner = TRUE
	job_reopens_slots_on_death = FALSE
	same_job_respawn_delay = 30 MINUTES

	can_have_apprentices = FALSE
	traits = list(TRAIT_NOAMBUSH)
	antag_role = /datum/antagonist/wretch
	cmode_music = 'sound/music/cmode/antag/combat_bandit2.ogg'

	exp_type = list(EXP_TYPE_LIVING)
	exp_types_granted = list(EXP_TYPE_COMBAT)
	exp_requirements = list(
		EXP_TYPE_LIVING = 1200
	)


/datum/job/wretch/after_spawn(mob/living/carbon/human/spawned, client/player_client)
	..()
	if(!spawned.mind)
		return
	to_chat(spawned, span_boldwarning("You are not an antagonist in the sense you kill everyone you're near, it is up to you to pave your own story. It is your choice if you want to take the roll of a highwayman or robber, or to follow a path of redemption, as your role exists to add flavor the round."))
	to_chat(spawned, span_boldwarning("In the same manner, you are NOT an adventurer."))

/datum/job/advclass/wretch
	abstract_type = /datum/job/advclass/wretch
	category_tags = list(CTAG_WRETCH)
	spawn_with_torch = TRUE
	department_flag = OUTSIDERS

/datum/job/advclass/wretch/proc/wretch_select_bounty(mob/living/carbon/human/H)
	var/bounty_poster = browser_input_list(H, "Who placed a bounty on you?", "Filthy Criminal", list("The Divine Pantheon", "Kingsfield Expanse"))
	if(bounty_poster == "Kingsfield Expanse")
		GLOB.outlawed_players += H.real_name
	else
		GLOB.heretical_players += H.real_name
