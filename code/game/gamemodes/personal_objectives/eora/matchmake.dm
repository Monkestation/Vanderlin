/datum/objective/personal/marriage_broker
	name = "Arrange Marriage"
	category = "Eora's Chosen"
	triumph_count = 3
	immediate_effects = list("Gained an ability to conduct secret marriage ceremonies", "Gained an ability to find marital status of others")
	rewards = list("3 Triumphs", "Eora grows stronger", "Eora blesses you (+1 Fortune)")

/datum/objective/personal/marriage_broker/on_creation()
	. = ..()
	if(owner?.current)
		ADD_TRAIT(owner.current, TRAIT_SECRET_OFFICIANT, OBJECTIVE_TRAIT)
		owner.current.add_spell(/datum/action/cooldown/spell/detect_singles)
	RegisterSignal(SSdcs, COMSIG_GLOBAL_MARRIAGE, PROC_REF(on_global_marriage))
	update_explanation_text()

/datum/objective/personal/marriage_broker/Destroy()
	UnregisterSignal(SSdcs, COMSIG_GLOBAL_MARRIAGE)
	return ..()

/datum/objective/personal/marriage_broker/proc/on_global_marriage(datum/source, mob/living/groom, mob/living/bride)
	SIGNAL_HANDLER
	if(completed)
		return

	complete_objective()

/datum/objective/personal/marriage_broker/complete_objective()
	. = ..()
	to_chat(owner.current, span_greentext("A marriage has happened, completing Eora's objective!"))
	adjust_storyteller_influence(EORA, 20)
	UnregisterSignal(SSdcs, COMSIG_GLOBAL_MARRIAGE)

/datum/objective/personal/marriage_broker/reward_owner()
	. = ..()
	owner.current.adjust_stat_modifier(STATMOD_EORA_BLESSING, STATKEY_LCK, 1)

/datum/objective/personal/marriage_broker/update_explanation_text()
	explanation_text = "Be a matchmaker! Make any marriage happen to please Eora!"
