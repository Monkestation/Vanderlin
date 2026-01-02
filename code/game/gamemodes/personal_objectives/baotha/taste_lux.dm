/datum/objective/personal/taste_lux
	name = "Taste Divine Essence"
	category = "Baotha's Chosen"
	triumph_count = 3
	rewards = list("3 Triumphs", "Baotha grows stronger", "Baotha blesses you (+2 Fortune)")

/datum/objective/personal/taste_lux/on_creation()
	. = ..()
	if(owner?.current)
		RegisterSignal(owner.current, COMSIG_LUX_TASTED, PROC_REF(on_lux_tasted))
	update_explanation_text()

/datum/objective/personal/taste_lux/Destroy()
	if(owner?.current)
		UnregisterSignal(owner.current, COMSIG_LUX_TASTED)
	return ..()

/datum/objective/personal/taste_lux/proc/on_lux_tasted()
	SIGNAL_HANDLER
	if(completed)
		return

	complete_objective()

/datum/objective/personal/taste_lux/complete_objective()
	. = ..()
	to_chat(owner.current, span_greentext("You have tasted the divine essence, completing Baotha's objective!"))
	adjust_storyteller_influence(BAOTHA, 20)
	UnregisterSignal(owner.current, COMSIG_LUX_TASTED)

/datum/objective/personal/taste_lux/reward_owner()
	. = ..()
	owner.current.adjust_stat_modifier(STATMOD_BAOTHA_BLESSING, STATKEY_LCK, 2)

/datum/objective/personal/taste_lux/update_explanation_text()
	explanation_text = "Experience the divine by tasting the forbidden Lux essence! Baotha is watching..."
