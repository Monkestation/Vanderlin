/datum/objective/personal/proper_burial
	name = "Consecrate Graves"
	category = "Necra's Chosen"
	triumph_count = 2
	rewards = list("2 Triumphs", "Necra grows stronger", "You won't get sick from unpleasant smells")
	var/burials_completed = 0
	var/required_burials = 1

/datum/objective/personal/proper_burial/on_creation()
	. = ..()
	if(owner?.current)
		if(owner.current.job == "Gravetender" || istype(owner.current.mind?.assigned_role, /datum/job/undertaker))
			required_burials = 2
		RegisterSignal(owner.current, COMSIG_GRAVE_CONSECRATED, PROC_REF(on_grave_consecrated))
	update_explanation_text()

/datum/objective/personal/proper_burial/Destroy()
	if(owner?.current)
		UnregisterSignal(owner.current, COMSIG_GRAVE_CONSECRATED)
	return ..()

/datum/objective/personal/proper_burial/proc/on_grave_consecrated(datum/source, obj/structure/closet/dirthole/hole)
	SIGNAL_HANDLER
	if(completed)
		return

	burials_completed++
	if(burials_completed >= required_burials)
		complete_objective()
	else
		to_chat(owner.current, span_notice("Grave consecrated! Consecrate [required_burials - burials_completed] more to complete Necra's trial."))

/datum/objective/personal/proper_burial/complete_objective()
	. = ..()
	to_chat(owner.current, span_greentext("You have consecrated enough graves to earn Necra's approval!"))
	adjust_storyteller_influence(NECRA, 20)
	UnregisterSignal(owner.current, COMSIG_GRAVE_CONSECRATED)

/datum/objective/personal/proper_burial/reward_owner()
	. = ..()
	ADD_TRAIT(owner.current, TRAIT_DEADNOSE, OBJECTIVE_TRAIT)

/datum/objective/personal/proper_burial/update_explanation_text()
	explanation_text = "Consecrate [required_burials] grave\s by building a grave marker or using funeral rites to earn Necra's approval."
