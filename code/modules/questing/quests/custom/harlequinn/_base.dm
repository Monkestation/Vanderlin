/datum/quest/custom/harlequinn_objective
	abstract_type = /datum/quest/custom/harlequinn_objective
	issue_label = ""
	custom_quest_flags = CUSTOM_QUEST_HARLEQUINN // Never on the board, only for harlequinn use
	quest_difficulty = QUEST_DIFFICULTY_HARD
	self_validating = TRUE
	/// The harlequinn antag datum that owns this objective
	var/datum/weakref/owning_harlequinn

/datum/quest/custom/harlequinn_objective/process()
	if(complete)
		STOP_PROCESSING(SSslowobj, src)
		return
	if(check_completion())
		mark_complete()
		STOP_PROCESSING(SSslowobj, src)

/datum/quest/custom/harlequinn_objective/Destroy()
	STOP_PROCESSING(SSslowobj, src)
	return ..()

/// Called during harlequinn setup to configure this quest's target/parameters.
/// Return TRUE on success, FALSE if generation failed (e.g. no valid targets).
/datum/quest/custom/harlequinn_objective/proc/setup_for_harlequinn(datum/antagonist/harlequinn/antag)
	SHOULD_CALL_PARENT(TRUE)
	START_PROCESSING(SSslowobj, src)
	return FALSE

/datum/quest/custom/harlequinn_objective/get_location_text()
	return "Somewhere in the realm."

// These never enter the board pool so steward_validate is irrelevant,
// but override validate() to auto-complete when check_completion() passes.
/datum/quest/custom/harlequinn_objective/validate(mob/steward, turf/input_point)
	if(check_completion())
		mark_complete()
		return TRUE
	else
		quest_scroll?.update_quest_text()

