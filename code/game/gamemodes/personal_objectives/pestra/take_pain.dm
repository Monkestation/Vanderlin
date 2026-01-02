/datum/objective/personal/take_pain
	name = "Take Pain"
	category = "Pestra's Chosen"
	triumph_count = 3
	immediate_effects = list("Gained an ability to take pain of others upon yourself")
	rewards = list("3 Triumphs", "Pestra grows stronger", "Pestra blesses you (+1 Constitution)")
	var/total_pain_taken = 0
	var/target_pain = 500

/datum/objective/personal/take_pain/on_creation()
	. = ..()
	if(owner?.current)
		RegisterSignal(owner.current, COMSIG_PAIN_TRANSFERRED, PROC_REF(on_pain_transferred))
	update_explanation_text()

/datum/objective/personal/take_pain/Destroy()
	if(owner?.current)
		UnregisterSignal(owner.current, COMSIG_PAIN_TRANSFERRED)
	return ..()

/datum/objective/personal/take_pain/proc/on_pain_transferred(datum/source, amount)
	SIGNAL_HANDLER
	if(completed)
		return

	total_pain_taken += amount

	var/progress_ratio = total_pain_taken / target_pain
	if(progress_ratio < 0.25)
		to_chat(owner.current, span_green("You feel a small amount of pain flow through you. Pestra is pleased, but there is much more suffering to relieve."))
	else if(progress_ratio < 0.5)
		to_chat(owner.current, span_green("The pain you've taken weighs heavily upon you. Keep going, Pestra's work is not yet done."))
	else if(progress_ratio < 0.75)
		to_chat(owner.current, span_green("The agony you've absorbed is substantial. You're making good progress in Pestra's name."))
	else if(progress_ratio < 1)
		to_chat(owner.current, span_green("The pain is nearly overwhelming, but you can sense you're close to completing Pestra's task."))

	if(total_pain_taken >= target_pain)
		complete_objective()

/datum/objective/personal/take_pain/complete_objective()
	. = ..()
	to_chat(owner.current, span_greentext("You have taken enough pain from others, completing Pestra's objective! Your sacrifice is rewarded."))
	adjust_storyteller_influence(PESTRA, 20)
	UnregisterSignal(owner.current, COMSIG_PAIN_TRANSFERRED)

/datum/objective/personal/take_pain/reward_owner()
	. = ..()
	owner.current.adjust_stat_modifier(STATMOD_PESTRA_BLESSING, STATKEY_CON, 1)

/datum/objective/personal/take_pain/update_explanation_text()
	explanation_text = "Take enough pain from others upon yourself as an act of mercy and devotion to Pestra."
