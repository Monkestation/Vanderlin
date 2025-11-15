
/datum/round_event_control/antagonist
	checks_antag_cap = TRUE
	track = EVENT_TRACK_CHARACTER_INJECTION
	///list of required roles, needed for this to form
	var/list/exclusive_roles
	/// Protected roles from the antag roll. People will not get those roles if a config is enabled
	var/list/protected_roles
	/// Restricted roles from the antag roll
	var/list/restricted_roles
	var/event_icon_state
	///these are the jobs we need to get the role
	var/list/needed_job
	var/minor_roleset = FALSE
	var/list/secondary_events = list(
		/datum/round_event_control/antagonist/solo/aspirant,
		/datum/round_event_control/antagonist/solo/maniac
	)
	var/secondary_prob = 25

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
	for(var/mob/M in GLOB.mob_living_list)
		if(M.stat == DEAD)
			continue // Dead players cannot count as passing requirements
		if(M.mind && (M.mind.assigned_role.title in exclusive_roles))
			return TRUE

/datum/round_event_control/antagonist/proc/trim_candidates(list/candidates)
	if(length(needed_job))
		for(var/mob/living/candidate in candidates)
			if(!(candidate.mind?.assigned_role.title in needed_job))
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
		restricted_roles |= protected_roles

/datum/round_event_control/antagonist/canSpawnEvent(players_amt, gamemode, fake_check)
	. = ..()
	if(!check_required())
		return FALSE

	if(!.)
		return

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
