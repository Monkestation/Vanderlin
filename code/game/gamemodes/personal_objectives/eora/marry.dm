/datum/objective/personal/marry
	name = "Find Love"
	category = "Eora's Lovebird"
	triumph_count = 2
	immediate_effects = list("You will feel stressed until you marry someone or enough time has passed (+2 Stress)", "Gained an ability to find marital status of others")
	rewards = list("2 Triumphs", "Eora grows stronger", "True Love", "Eora blesses you (+1 Fortune)")
	var/lovebird_name
	var/lovebird_job

/datum/objective/personal/marry/New(text, datum/mind/owner, lovebird_name, lovebird_job)
	. = ..()
	src.lovebird_name = lovebird_name
	src.lovebird_job = lovebird_job

/datum/objective/personal/marry/on_creation()
	. = ..()
	if(owner?.current)
		owner.current.add_stress(/datum/stress_event/eora_matchmaking)
		owner.current.add_spell(/datum/action/cooldown/spell/detect_singles)
	RegisterSignal(SSdcs, COMSIG_GLOBAL_MARRIAGE, PROC_REF(on_global_marriage))
	update_explanation_text()

/datum/objective/personal/marry/Destroy()
	UnregisterSignal(SSdcs, COMSIG_GLOBAL_MARRIAGE)
	return ..()

/datum/objective/personal/marry/proc/on_global_marriage(datum/source, mob/living/groom, mob/living/bride)
	SIGNAL_HANDLER
	if(completed)
		return

	if(owner.current != groom && owner.current != bride)
		return

	complete_objective()

/datum/objective/personal/marry/complete_objective(escalatation_type = ESCALATION_INTERVENTION_ONLY)
	. = ..()
	owner.current.remove_stress(/datum/stress_event/eora_matchmaking)
	to_chat(owner.current, span_greentext("You have married and therefore completed Eora's wish!"))
	adjust_storyteller_influence(EORA, 10)
	UnregisterSignal(SSdcs, COMSIG_GLOBAL_MARRIAGE)

/datum/objective/personal/marry/complete_objectiv/reward_owner()
	. = ..()
	owner.current.adjust_stat_modifier(STATMOD_EORA_MARRIAGE, STATKEY_LCK, 1)

/datum/objective/personal/marry/update_explanation_text()
	explanation_text = "Eora wants you to find your true love and marry them! Perhaps [lovebird_name], the [lovebird_job] could be a good match?"
