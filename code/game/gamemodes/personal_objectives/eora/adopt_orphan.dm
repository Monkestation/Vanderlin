/datum/objective/personal/adopt_orphan
	name = "Adopt Orphan"
	category = "Eora's Chosen"
	triumph_count = 3
	immediate_effects = list("Gained an ability to adopt children")
	rewards = list("3 Triumphs", "Eora grows stronger", "Eora blesses you (+1 Fortune)")

/datum/objective/personal/adopt_orphan/on_creation()
	. = ..()
	if(owner?.current)
		RegisterSignal(owner.current, COMSIG_ORPHAN_ADOPTED, PROC_REF(on_orphan_adopted))
	update_explanation_text()

/datum/objective/personal/adopt_orphan/Destroy()
	if(owner?.current)
		UnregisterSignal(owner.current, COMSIG_ORPHAN_ADOPTED)
	return ..()

/datum/objective/personal/adopt_orphan/proc/on_orphan_adopted(datum/source, mob/new_child)
	SIGNAL_HANDLER
	if(completed)
		return

	complete_objective()

/datum/objective/personal/adopt_orphan/complete_objective()
	. = ..()
	to_chat(owner.current, span_greentext("You've adopted a child, completing Eora's objective!"))
	adjust_storyteller_influence(EORA, 20)
	UnregisterSignal(owner.current, COMSIG_ORPHAN_ADOPTED)

/datum/objective/personal/adopt_orphan/reward_owner()
	. = ..()
	owner.current.adjust_stat_modifier(STATMOD_EORA_BLESSING, STATKEY_LCK, 1)

/datum/objective/personal/adopt_orphan/update_explanation_text()
	explanation_text = "Adopt an orphan as your own child and provide them a loving home! Eora is counting on you!"
