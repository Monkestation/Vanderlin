GLOBAL_LIST_EMPTY(antagonist_teams)

//A barebones antagonist team.
/datum/team
	///Name of the entire Team
	var/name = "\improper Team"
	///What members are considered in the roundend report (ex: 'cultists')
	var/member_name = "member"
	///Whether the team shows up in the roundend report.
	var/show_roundend_report = TRUE

	///List of all members in the team
	var/list/datum/mind/members = list()
	///Common objectives, these won't be added or removed automatically, subtypes handle this, this is here for bookkeeping purposes.
	var/list/datum/objective/objectives = list()

/datum/team/New(starting_members)
	. = ..()
	GLOB.antagonist_teams += src
	if(starting_members)
		if(islist(starting_members))
			for(var/datum/mind/M in starting_members)
				add_member(M)
		else
			add_member(starting_members)

/datum/team/Destroy(force, ...)
	GLOB.antagonist_teams -= src
	members = null
	objectives = null
	. = ..()

/datum/team/proc/add_member(datum/mind/new_member)
	members |= new_member

/datum/team/proc/remove_member(datum/mind/member)
	members -= member

/datum/team/proc/add_objective(datum/objective/new_objective, needs_target = FALSE)
	new_objective.team = src
	if(needs_target)
		new_objective.find_target(dupe_search_range = list(src))
	new_objective.update_explanation_text()
	objectives += new_objective

//Display members/victory/failure/objectives for the team
/datum/team/proc/roundend_report()
	var/list/report = list()

	report += span_header(" * [name] * ")
	report += printplayerlist(members)

	if(length(objectives))
		report += span_header("They had the following objectives:")
		var/win = TRUE
		var/objective_count = 0
		var/triumph_count = 0
		for(var/datum/objective/objective as anything in objectives)
			objective_count++
			triumph_count++
			if(objective.check_completion())
				report += "<B>[objective.flavor] #[objective_count]</B>: [objective.explanation_text] [span_greentext("TRIUMPH!")]"
			else
				report += "<B>[objective.flavor] #[objective_count]</B>: [objective.explanation_text] [span_redtext("FAIL.")]"
				win = FALSE

		var/result_sound
		if(win)
			report += span_greentext("\The [name] TRIUMPHED!")
			result_sound = 'sound/misc/triumph.ogg'
			roundend_success()
		else
			report += span_redtext("\The [name] FAILED!")
			result_sound = 'sound/misc/fail.ogg'
			roundend_failure()
			triumph_count = 0

		for(var/datum/mind/member as anything in members)
			if(!member.current)
				continue
			member.current.playsound_local(get_turf(member.current), result_sound, 100, FALSE, pressure_affected = FALSE)
			member.adjust_triumphs(triumph_count, TRUE)
		report += "<br>"

	return report.Join("<br>")

/datum/team/proc/get_team_antags(antag_type,specific = FALSE)
	. = list()
	for(var/datum/antagonist/antagonist as anything in GLOB.antagonists)
		if(antagonist.get_team() == src && (!antag_type || !specific && istype(antagonist, antag_type) || specific && antagonist.type == antag_type))
			. += antagonist

//Builds section for the team
/datum/team/proc/antag_listing_entry()
	//NukeOps:
	// Jim (Status) FLW PM TP
	// Joe (Status) FLW PM TP
	//Disk:
	// Deep Space FLW
	var/list/parts = list()
	parts += "<b>[antag_listing_name()]</b><br>"
	parts += "<table cellspacing=5>"
	for(var/datum/antagonist/antag_entry as anything in get_team_antags())
		parts += antag_entry.antag_listing_entry()
	parts += "</table>"
	return parts.Join()

/datum/team/proc/antag_listing_name()
	return name

/* ROGUETOWN */

/datum/team/proc/roundend_success()

/datum/team/proc/roundend_failure()
