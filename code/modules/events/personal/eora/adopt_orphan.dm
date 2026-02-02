/datum/round_event_control/adoption_call
	name = "Adoption Call"
	track = EVENT_TRACK_PERSONAL
	typepath = /datum/round_event/adoption_call
	weight = 7
	earliest_start = 10 MINUTES
	max_occurrences = 1
	min_players = 35

	tags = list(
		TAG_EORA,
		TAG_BOON,
	)

/datum/round_event_control/adoption_call/canSpawnEvent(players_amt, gamemode, fake_check)
	. = ..()
	if(!.)
		return FALSE

	var/recipient_found = FALSE
	var/orphans = 0
	var/potential_orphans = 0
	for(var/mob/living/carbon/human/H in GLOB.player_list)
		if(!istype(H) || H.stat == DEAD || !H.client)
			continue
		if(!H.patron || !istype(H.patron, /datum/patron/divine/eora))
			continue
		if(H.age == AGE_CHILD)
			continue
		recipient_found = TRUE
		break

	for(var/mob/living/carbon/human/child in GLOB.player_list)
		if(child.age != AGE_CHILD || child.stat == DEAD || !child.client)
			continue
		if(!child.family_datum && (child.job == "Orphan" && istype(child.mind?.assigned_role, /datum/job/orphan)))
			orphans++
		else if(!child.family_datum || !length(child.family_member_datum?.parents))
			potential_orphans++

	if(recipient_found && (orphans + potential_orphans) >= 2)
		return TRUE

	return FALSE

/datum/round_event/adoption_call/start()
	var/list/valid_targets = list()
	var/orphans = 0
	var/potential_orphans = 0

	for(var/mob/living/carbon/human/H in GLOB.player_list)
		if(!istype(H) || H.stat == DEAD || !H.client)
			continue
		if(!H.patron || !istype(H.patron, /datum/patron/divine/eora))
			continue
		if(H.age == AGE_CHILD)
			continue
		valid_targets += H

	for(var/mob/living/carbon/human/child in GLOB.player_list)
		if(child.age != AGE_CHILD || child.stat == DEAD || !child.client)
			continue
		if(!child.family_datum && (child.job == "Orphan" && istype(child.mind?.assigned_role, /datum/job/orphan)))
			orphans++
		else if(!child.family_datum || !length(child.family_member_datum?.parents))
			potential_orphans++

	if(!length(valid_targets) || (orphans + potential_orphans) < 2)
		return

	var/mob/living/carbon/human/chosen_one = pick(valid_targets)

	var/datum/objective/personal/adopt_orphan/new_objective = new(owner = chosen_one.mind)
	chosen_one.mind.add_personal_objective(new_objective)

	chosen_one.add_spell(/datum/action/cooldown/spell/adopt_child)

	bordered_message(chosen_one, list(
		span_userdanger("YOU ARE EORA'S CHOSEN!"),
		span_notice("Eora weeps for the orphaned children! Find an orphan and adopt them as your own child to earn her favor!"),
	))
	chosen_one.playsound_local(chosen_one, 'sound/vo/female/gen/giggle (1).ogg', 100)

	chosen_one.mind.announce_personal_objectives()
