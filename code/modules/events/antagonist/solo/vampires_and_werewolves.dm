/datum/round_event_control/antagonist/solo/vampires_and_werewolves
	name = "Vampires and Verevolves"
	tags = list(
		TAG_DENDOR,
		TAG_GRAGGAR,
		TAG_COMBAT,
		TAG_HAUNTED,
		TAG_VILLAIN,
	)
	roundstart = TRUE
	antag_flag = ROLE_NBEAST
	shared_occurence_type = SHARED_HIGH_THREAT
	denominator = 40

	base_antags = 2
	maximum_antags = 4

	earliest_start = 0 SECONDS
	min_players = 40
	weight = 8
	secondary_prob = 0
	typepath = /datum/round_event/antagonist/solo/vampires_and_werewolves

	restricted_roles = list(
		/datum/job/lord,
		/datum/job/consort,
		/datum/job/priest,
		/datum/job/hand,
		/datum/job/captain,
		/datum/job/prince,
		/datum/job/inquisitor,
		/datum/job/absolver,
		/datum/job/orthodoxist,
		/datum/job/adept,
		/datum/job/forestwarden,
		/datum/job/royalknight,
		/datum/job/templar,
	)

/datum/round_event_control/antagonist/solo/vampires_and_werewolves/valid_for_map()
	if(SSmapping.config.map_name != "Voyage")
		return TRUE
	return FALSE

/datum/round_event/antagonist/solo/vampires_and_werewolves
	var/leader = FALSE

/datum/round_event/antagonist/solo/vampires_and_werewolves/start()
	var/vampire = TRUE
	for(var/datum/mind/antag_mind as anything in setup_minds)
		if(vampire)
			add_vampire(antag_mind)
		else
			add_werewolf(antag_mind, antag_mind.current)
		vampire = !vampire

/datum/round_event/antagonist/solo/vampires_and_werewolves/proc/add_werewolf(datum/mind/antag_mind)
	if(!antag_mind)
		CRASH("add_werewolf was called without an antag datum!")
	antag_mind.add_antag_datum(/datum/antagonist/werewolf)

/datum/round_event/antagonist/solo/vampires_and_werewolves/proc/add_vampire(datum/mind/antag_mind)
	if(!antag_mind)
		CRASH("add_vampire was called without an antag datum!")
	if(ishuman(antag_mind.current))
		var/mob/living/carbon/human/vampire = antag_mind.current
		vampire.adv_hugboxing_cancel() // workaround for pilgrims and adventurers being in the adv_class pick menu
	if(!leader)
		var/datum/job/J = SSjob.GetJob(antag_mind.current?.job)
		J?.adjust_current_positions(-1)
		if(SSmapping.config.map_name != "Voyage")
			antag_mind.current.unequip_everything()
		antag_mind.add_antag_datum(/datum/antagonist/vampire/lord)
		leader = TRUE
		return
	else
		if(!antag_mind.has_antag_datum(/datum/antagonist/vampire))
			var/datum/job/J = SSjob.GetJob(antag_mind.current?.job)
			J?.adjust_current_positions(-1)
			if(SSmapping.config.map_name != "Voyage")
				antag_mind.current.unequip_everything()
			antag_mind.add_antag_datum(/datum/antagonist/vampire/lords_spawn)
		return
