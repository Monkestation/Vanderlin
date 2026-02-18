/datum/objective/personal/grave_robbery
	name = "Rob Graves"
	category = "Matthios' Chosen"
	triumph_count = 2
	rewards = list("2 Triumphs", "Matthios grows stronger", "Ability to rob graves without being cursed", "Matthios blesses you (+1 Endurance)")
	var/graves_robbed = 0
	var/graves_required = 2

/datum/objective/personal/grave_robbery/on_creation()
	. = ..()
	if(owner?.current)
		RegisterSignal(owner.current, COMSIG_GRAVE_ROBBED, PROC_REF(on_grave_robbed))
	update_explanation_text()

/datum/objective/personal/grave_robbery/Destroy()
	if(owner?.current)
		UnregisterSignal(owner.current, COMSIG_GRAVE_ROBBED)
	return ..()

/datum/objective/personal/grave_robbery/proc/on_grave_robbed(datum/source, mob/user)
	SIGNAL_HANDLER
	if(completed || user != owner.current)
		return

	graves_robbed++
	if(graves_robbed >= graves_required)
		complete_objective()
	else
		to_chat(owner.current, span_notice("Grave robbed! Rob [graves_required - graves_robbed] more to complete Matthios' task."))

/datum/objective/personal/grave_robbery/complete_objective()
	. = ..()
	to_chat(owner.current, span_greentext("You've robbed enough graves to earn Matthios' respect!"))
	adjust_storyteller_influence(MATTHIOS, 20)
	UnregisterSignal(owner.current, COMSIG_GRAVE_ROBBED)

/datum/objective/personal/grave_robbery/reward_owner()
	. = ..()
	ADD_TRAIT(owner.current, TRAIT_GRAVEROBBER, OBJECTIVE_TRAIT)
	owner.current.adjust_stat_modifier(STATMOD_MATTHIOS_BLESSING, STATKEY_END, 1)

/datum/objective/personal/grave_robbery/update_explanation_text()
	explanation_text = "Rob at least [graves_required] graves to earn Matthios' respect."
