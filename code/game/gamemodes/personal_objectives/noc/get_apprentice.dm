/datum/objective/personal/get_apprentice
	name = "Get Apprentice"
	category = "Noc's Chosen"
	triumph_count = 3
	rewards = list("3 Triumphs", "Noc grows stronger", "Noc blesses you (+1 Intelligence)")

/datum/objective/personal/get_apprentice/on_creation()
	. = ..()
	if(owner?.current)
		RegisterSignal(owner.current, COMSIG_APPRENTICE_MADE, PROC_REF(on_new_apprentice))
	update_explanation_text()

/datum/objective/personal/get_apprentice/Destroy()
	if(owner?.current)
		UnregisterSignal(owner.current, COMSIG_APPRENTICE_MADE)
	return ..()

/datum/objective/personal/get_apprentice/proc/on_new_apprentice(datum/source, mob/new_apprentice)
	SIGNAL_HANDLER
	if(completed)
		return

	complete_objective()

/datum/objective/personal/get_apprentice/complete_objective()
	. = ..()
	to_chat(owner.current, span_greentext("You've obtained a new apprentice, completing Noc's objective!"))
	adjust_storyteller_influence(NOC, 20)
	UnregisterSignal(owner.current, COMSIG_APPRENTICE_MADE)

/datum/objective/personal/get_apprentice/reward_owner()
	. = ..()
	owner.current.adjust_stat_modifier(STATMOD_NOC_BLESSING, STATKEY_INT, 1)

/datum/objective/personal/get_apprentice/update_explanation_text()
	explanation_text = "Obtain a new apprentice to pass your knowledge on! Noc will be watching."
