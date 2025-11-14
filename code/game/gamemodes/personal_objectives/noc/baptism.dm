/datum/objective/personal/baptism
	name = "Receive Baptism"
	category = "Noc's Chosen"
	triumph_count = 3
	rewards = list("3 Triumphs", "Noc grows stronger", "Noc blesses you (+1 Intelligence)")

/datum/objective/personal/baptism/on_creation()
	. = ..()
	if(owner?.current)
		if(owner.current.mana_pool?.intrinsic_recharge_sources & MANA_ALL_LEYLINES)
			on_baptism_received()
		else
			RegisterSignal(owner.current, COMSIG_BAPTISM_RECEIVED, PROC_REF(on_baptism_received))
	update_explanation_text()

/datum/objective/personal/baptism/Destroy()
	if(owner?.current)
		UnregisterSignal(owner.current, COMSIG_BAPTISM_RECEIVED)
	return ..()

/datum/objective/personal/baptism/proc/on_baptism_received(datum/source, mob/living/baptizer)
	SIGNAL_HANDLER
	if(completed)
		return

	complete_objective()

/datum/objective/personal/baptism/complete_objective()
	. = ..()
	to_chat(owner.current, span_greentext("You have been baptized and completed Noc's objective!"))
	adjust_storyteller_influence(NOC, 20)
	UnregisterSignal(owner.current, COMSIG_BAPTISM_RECEIVED)

/datum/objective/personal/baptism/reward_owner()
	. = ..()
	owner.current.adjust_stat_modifier(STATMOD_NOC_BLESSING, STATKEY_INT, 1)

/datum/objective/personal/baptism/update_explanation_text()
	explanation_text = "Receive mana baptism in Noc's name to gain their favor!"
