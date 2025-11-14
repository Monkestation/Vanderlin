/datum/objective/personal/nobility
	name = "Become Noble"
	category = "Astrata's Chosen"
	triumph_count = 3
	rewards = list("3 Triumphs", "Astrata grows stronger", "Astrata blesses you (+1 Fortune)")

/datum/objective/personal/nobility/on_creation()
	. = ..()
	if(owner?.current)
		if(HAS_TRAIT(owner.current, TRAIT_NOBLE))
			on_nobility_granted()
		else
			RegisterSignal(owner.current, SIGNAL_ADDTRAIT(TRAIT_NOBLE), PROC_REF(on_nobility_granted))
	update_explanation_text()

/datum/objective/personal/nobility/Destroy()
	if(owner?.current)
		UnregisterSignal(owner.current, SIGNAL_ADDTRAIT(TRAIT_NOBLE))
	return ..()

/datum/objective/personal/nobility/proc/on_nobility_granted()
	SIGNAL_HANDLER
	if(completed)
		return

	complete_objective()

/datum/objective/personal/nobility/complete_objective()
	. = ..()
	to_chat(owner.current, span_greentext("You have earned nobility and completed Astrata's objective!"))
	adjust_storyteller_influence(ASTRATA, 20)
	UnregisterSignal(owner.current, SIGNAL_ADDTRAIT(TRAIT_NOBLE))

/datum/objective/personal/nobility/reward_owner()
	. = ..()
	owner.current.adjust_stat_modifier(STATMOD_ASTRATA_BLESSING, STATKEY_LCK, 1)

/datum/objective/personal/nobility/update_explanation_text()
	explanation_text = "Become part of the nobility by any means to gain Astrata's approval!"
