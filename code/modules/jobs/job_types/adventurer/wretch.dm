/// Wretches don't HAVE a root class, just subclasses!

/datum/job/advclass/wretch
	abstract_type = /datum/job/advclass/wretch
	job_flags = JOB_SHOW_IN_CREDITS
	category_tags = list(CTAG_WRETCH)
	spawn_with_torch = TRUE
	faction = FACTION_NEUTRAL
	department_flag = OUTSIDERS
	can_have_apprentices = FALSE
	cmode_music = 'sound/music/cmode/antag/combat_bandit2.ogg'
	is_foreigner = TRUE

	/// An associative list of honorary titles to choose from.
	/// The key is the title, the value indicates whether it is a prefix (0) or a suffix (1)
	var/list/honoraries = list()

/datum/job/advclass/wretch/on_roundstart(mob/living/carbon/human/spawned, client/player_client)
	. = ..()
	if(length(honoraries) && tgui_alert(player_client, "Do you wish for a random title? You will not receive one if you click No.", "", DEFAULT_INPUT_CHOICES) == CHOICE_YES)
		var/honorary = pick(honoraries)
		if(honoraries[honorary])
			spawned.honorary_suffix = honorary
		else
			spawned.honorary = honorary
	wretch_select_bounty(spawned)

/datum/job/advclass/wretch/proc/wretch_select_bounty(mob/living/carbon/human/H)
	var/bounty_poster = tgui_input_list(H, "Who placed a bounty on you?", "Filthy Criminal", list("The Divine Pantheon", "Kingsfield Expanse"))
	if(bounty_poster == "Kingsfield Expanse")
		GLOB.outlawed_players += H.real_name
	else
		GLOB.heretical_players += H.real_name
