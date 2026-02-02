/datum/objective/personal/consume_organs
	name = "Consume Organs"
	category = "Graggar's Chosen"
	triumph_count = 2
	immediate_effects = list("Gained an ability to rip hearts out of corpses")
	rewards = list("2 Triumphs", "Graggar grows stronger", "Graggar blesses you (+1 Strength, +1 Constitution)")
	var/organs_consumed = 0
	var/hearts_consumed = 0
	var/organs_required = 3
	var/hearts_required = 1

/datum/objective/personal/consume_organs/on_creation()
	. = ..()
	if(owner?.current)
		RegisterSignal(owner.current, COMSIG_ORGAN_CONSUMED, PROC_REF(on_organ_consumed))
	update_explanation_text()

/datum/objective/personal/consume_organs/Destroy()
	if(owner?.current)
		UnregisterSignal(owner.current, COMSIG_ORGAN_CONSUMED)
	return ..()

/datum/objective/personal/consume_organs/proc/on_organ_consumed(datum/source, organ_type, obj/item/organ/organ_inside)
	SIGNAL_HANDLER
	if(completed)
		return

	organs_consumed++

	if(ispath(organ_type, /obj/item/reagent_containers/food/snacks/organ/heart))
		hearts_consumed++
		to_chat(owner.current, span_cult("You feel Graggar's pleasure as you consume a heart!"))
	else
		to_chat(owner.current, span_notice("Organ consumed! [organs_required - organs_consumed] more organ\s needed."))

	if(organs_consumed >= organs_required && hearts_consumed >= hearts_required)
		complete_objective()

/datum/objective/personal/consume_organs/complete_objective()
	. = ..()
	to_chat(owner.current, span_greentext("You have consumed enough organs and hearts to satisfy Graggar!"))
	adjust_storyteller_influence(GRAGGAR, 20)
	UnregisterSignal(owner.current, COMSIG_ORGAN_CONSUMED)

/datum/objective/personal/consume_organs/reward_owner()
	. = ..()
	owner.current.adjust_stat_modifier(STATMOD_GRAGGAR_BLESSING, STATKEY_STR, 1)
	owner.current.adjust_stat_modifier(STATMOD_GRAGGAR_BLESSING, STATKEY_CON, 1)

/datum/objective/personal/consume_organs/update_explanation_text()
	explanation_text = "Consume [organs_required] organ\s, including [hearts_required] heart\s, to appease Graggar!"
