/datum/round_event_control/scholarship_request
	name = "Scholarship Request"
	track = EVENT_TRACK_PERSONAL
	typepath = /datum/round_event/scholarship_request
	weight = 7
	earliest_start = 5 MINUTES
	max_occurrences = 1
	min_players = 35

	tags = list(
		TAG_NOC,
		TAG_WORK,
	)

/datum/round_event_control/scholarship_request/canSpawnEvent(players_amt, gamemode, fake_check)
	. = ..()
	if(!.)
		return FALSE

	var/recipient_found = FALSE
	var/potential_apprentices = 0
	for(var/mob/living/carbon/human/H in GLOB.player_list)
		if(!istype(H) || H.stat == DEAD || !H.client)
			continue
		if(!H.patron || !istype(H.patron, /datum/patron/divine/noc))
			continue
		if(length(H.return_apprentices()) >= H.return_max_apprentices())
			continue
		recipient_found = TRUE
		break
	for(var/mob/living/carbon/human/H in GLOB.player_list)
		if(!istype(H) || H.stat == DEAD || !H.client)
			continue
		if((H.age == AGE_CHILD || (H.job == "Beggar" && istype(H.mind?.assigned_role, /datum/job/vagrant))) && !H.is_apprentice())
			potential_apprentices++

	if(recipient_found && potential_apprentices >= 3)
		return TRUE

	return FALSE

/datum/round_event/scholarship_request/start()
	var/list/valid_targets = list()

	var/potential_apprentices = 0
	for(var/mob/living/carbon/human/H in GLOB.player_list)
		if(!istype(H) || H.stat == DEAD || !H.client)
			continue
		if(!H.patron || !istype(H.patron, /datum/patron/divine/noc))
			continue
		if(length(H.return_apprentices()) >= H.return_max_apprentices())
			continue
		valid_targets += H
	for(var/mob/living/carbon/human/H in GLOB.player_list)
		if(!istype(H) || H.stat == DEAD || !H.client)
			continue
		if((H.age == AGE_CHILD || (H.job == "Beggar" && istype(H.mind?.assigned_role, /datum/job/vagrant))) && !H.is_apprentice())
			potential_apprentices++

	if(!length(valid_targets) || potential_apprentices < 3)
		return

	var/mob/living/carbon/human/chosen_one = pick(valid_targets)

	var/datum/objective/personal/get_apprentice/new_objective = new(owner = chosen_one.mind)
	chosen_one.mind.add_personal_objective(new_objective)

	to_chat(chosen_one, span_userdanger("YOU ARE NOC'S CHOSEN!"))
	to_chat(chosen_one, span_notice("Noc wishes for you to pass your knowledge! Seek a suitable child or downtrodden and make them your new apprentice! (RMB on a target with an empty hand)"))
	chosen_one.playsound_local(chosen_one, 'sound/ambience/noises/mystical (4).ogg', 100)

	chosen_one.mind.announce_personal_objectives()
