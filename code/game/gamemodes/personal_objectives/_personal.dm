/datum/objective/personal
	name = "Generic Personal Objective"
	var/category = "Personal"
	var/list/immediate_effects
	var/list/rewards

/datum/objective/personal/on_creation()
	. = ..()
	if(owner && !(owner in GLOB.personal_objective_minds))
		GLOB.personal_objective_minds |= owner

/datum/objective/personal/proc/complete_objective(escalatation_type = ESCALATION_PERSONAL_AND_INTERVENTION)
	completed = TRUE
	reward_owner()
	switch(escalatation_type)
		if(ESCALATION_NONE)
			return
		if(ESCALATION_PERSONAL_AND_INTERVENTION)
			escalate_objective(event_track = EVENT_TRACK_PERSONAL, second_event_track = EVENT_TRACK_INTERVENTION)
		if(ESCALATION_PERSONAL_ONLY)
			escalate_objective(event_track = EVENT_TRACK_PERSONAL)
		if(ESCALATION_INTERVENTION_ONLY)
			escalate_objective(second_event_track = EVENT_TRACK_INTERVENTION)

/datum/objective/personal/proc/reward_owner()
	owner.adjust_triumphs(triumph_count)

/datum/objective/personal/proc/escalate_objective(event_track, second_event_track, first_value_modifier, second_value_modifier)
	if(event_track)
		var/first_modifer = first_value_modifier || round(rand(50, 75)) / 100
		var/first_points_to_add = SSgamemode.point_thresholds[event_track] * first_modifer
		SSgamemode.event_track_points[event_track] += first_points_to_add
	if(second_event_track)
		var/second_modifer = second_value_modifier || round(rand(10, 15)) / 100
		var/second_points_to_add = SSgamemode.point_thresholds[second_event_track] * second_modifer
		SSgamemode.event_track_points[second_event_track] += second_points_to_add
