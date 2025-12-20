
/datum/round_event_control/antagonist
	checks_antag_cap = TRUE
	track = EVENT_TRACK_CHARACTER_INJECTION
	// All lists are typecaches including subtypes of the input jobs
	///list of required roles, needed for this to form, advclasses test their parent job.
	var/list/exclusive_roles
	/// Protected roles from the antag roll, advclasses test their parent job. People will not get those roles if a config is enabled
	var/list/protected_roles
	/// Restricted roles from the antag roll, advclasses test their parent job.
	var/list/restricted_roles
	///these are the jobs we need to get the role, advclasses test their parent job.
	var/list/needed_job
	var/event_icon_state
	var/minor_roleset = FALSE
	var/list/secondary_events = list(
		/datum/round_event_control/antagonist/solo/aspirant,
		/datum/round_event_control/antagonist/solo/maniac
	)
	var/secondary_prob = 25

/datum/round_event_control/antagonist/New()
	. = ..()
	restricted_roles = typecacheof(restricted_roles)
	exclusive_roles = typecacheof(exclusive_roles)
	protected_roles = typecacheof(protected_roles)
	needed_job = typecacheof(needed_job)

/datum/round_event_control/antagonist/canSpawnEvent(players_amt, gamemode, fake_check)
	. = ..()
	if(!.)
		return FALSE

	if(!check_required())
		return FALSE

/datum/round_event_control/antagonist/return_failure_string(players_amt)
	. =..()
	if(!check_enemies())
		if(.)
			. += ", "
		. += "No Enemies"
	if(!check_required())
		if(.)
			. += ", "
		. += "No Required"
	return .

/datum/round_event_control/antagonist/runEvent(random = FALSE, admin_forced = TRUE)
	. = ..()
	try_trigger_minor_event()

/datum/round_event_control/antagonist/proc/try_trigger_minor_event()
	if(!length(secondary_events))
		return

	var/players_amt = get_active_player_count(alive_check = TRUE, afk_check = TRUE, human_check = TRUE)

	if(players_amt < 45)
		return

	if(!prob(secondary_prob))
		return

	var/picked = pick(secondary_events)
	if(!picked)
		return

	var/datum/round_event_control/antagonist/eventpicked = locate(picked) in SSgamemode.control
	if(eventpicked)
		eventpicked.secondary_prob = 0
		SSgamemode.TriggerEvent(eventpicked, forced = FALSE)

/datum/round_event_control/antagonist/proc/check_required()
	if(!length(exclusive_roles))
		return TRUE

	for(var/mob/M as anything in GLOB.player_list)
		if(!M.mind || M.stat == DEAD)
			continue // Dead players cannot count as passing requirements

		var/datum/job/tested_job = M.mind?.assigned_role
		if(tested_job.parent_job)
			tested_job = tested_job.parent_job

		if(is_type_in_typecache(tested_job, exclusive_roles))
			return TRUE

	return FALSE

/datum/round_event_control/antagonist/proc/trim_candidates(list/candidates)
	if(length(needed_job))
		for(var/mob/living/candidate in candidates)
			var/datum/job/tested_job = candidate.mind?.assigned_role
			if(tested_job.parent_job)
				tested_job = tested_job.parent_job

			if(!is_type_in_typecache(tested_job, needed_job))
				candidates -= candidate

	return candidates

/// Check if our enemy_roles requirement is met, if return_players is set then we will return the list of enemy players instead
/datum/round_event_control/proc/check_enemies(return_players = FALSE)
	if(!length(enemy_roles))
		return return_players ? list() : TRUE

	var/job_check = 0
	var/list/enemy_players = list()
	if(roundstart)
		for(var/mob/living/player as anything in GLOB.mob_living_list)
			if(!player.mind)
				continue
			if(player.mind.assigned_role.title in enemy_roles)
				job_check++
				enemy_players += player
	else
		for(var/mob/M in GLOB.mob_living_list)
			if (M.stat == DEAD)
				continue // Dead players cannot count as opponents
			if (M.mind && (M.mind.assigned_role.title in enemy_roles))
				job_check++ // Checking for "enemies" (such as sec officers). To be counters, they must either not be candidates to that
				enemy_players += M

	if(job_check >= required_enemies)
		return return_players ? enemy_players : TRUE
	return return_players ? enemy_players : FALSE

/datum/round_event_control/antagonist/New()
	. = ..()
	if(CONFIG_GET(flag/protect_roles_from_antagonist))
		restricted_roles |= typecacheof(protected_roles)
