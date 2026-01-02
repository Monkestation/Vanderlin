/datum/round_event_control/retainer_recruitment
	name = "Retainer Recruitment"
	track = EVENT_TRACK_PERSONAL
	typepath = /datum/round_event/retainer_recruitment
	weight = 7
	earliest_start = 5 MINUTES
	max_occurrences = 1
	min_players = 35

	tags = list(
		TAG_ASTRATA,
	)

/datum/round_event_control/retainer_recruitment/canSpawnEvent(players_amt, gamemode, fake_check)
	. = ..()
	if(!.)
		return FALSE

	for(var/mob/living/carbon/human/human_mob in GLOB.player_list)
		if(!istype(human_mob) || human_mob.stat == DEAD || !human_mob.client)
			continue
		if(!human_mob.patron || !istype(human_mob.patron, /datum/patron/divine/astrata))
			continue
		if(!human_mob.is_noble() || (human_mob.mind?.assigned_role.title in GLOB.church_positions))
			continue
		if(human_mob.get_spell(/datum/action/cooldown/spell/undirected/list_target/convert_role))
			continue
		return TRUE

	return FALSE

/datum/round_event/retainer_recruitment/start()
	var/list/valid_targets = list()
	var/list/minor_nobles = list()

	for(var/mob/living/carbon/human/human_mob in GLOB.player_list)
		if(!istype(human_mob) || human_mob.stat == DEAD || !human_mob.client)
			continue
		if(!human_mob.patron || !istype(human_mob.patron, /datum/patron/divine/astrata))
			continue
		if(!human_mob.is_noble() || (human_mob.mind?.assigned_role.title in GLOB.church_positions))
			continue
		if(human_mob.get_spell(/datum/action/cooldown/spell/undirected/list_target/convert_role))
			continue

		if(istype(human_mob.mind?.assigned_role, /datum/job/minor_noble) || human_mob.job == "Noble")
			minor_nobles += human_mob
		else
			valid_targets += human_mob

	if(length(minor_nobles))
		valid_targets = minor_nobles

	if(!length(valid_targets))
		return

	var/mob/living/carbon/human/noble = pick(valid_targets)

	var/datum/objective/personal/retainer/new_objective = new(owner = noble.mind)
	noble.mind.add_personal_objective(new_objective)

	to_chat(noble, span_userdanger("YOU ARE ASTRATA'S CHOSEN!"))
	to_chat(noble, span_notice("Astrata wants you to demonstrate your ability to lead as a proper noble! Recruit at least one retainer to serve you!"))
	noble.playsound_local(noble, 'sound/magic/bless.ogg', 100)

	noble.mind.announce_personal_objectives()
