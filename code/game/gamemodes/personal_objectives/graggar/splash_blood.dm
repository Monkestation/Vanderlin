/datum/objective/personal/blood_splash
	name = "Splash Blood"
	category = "Graggar's Chosen"
	triumph_count = 2
	rewards = list("2 Triumphs", "Graggar grows stronger", "Graggar blesses you (+1 Strength, +1 Constitution)")

/datum/objective/personal/blood_splash/on_creation()
	. = ..()
	if(owner?.current)
		RegisterSignal(owner.current, COMSIG_SPLASHED_MOB, PROC_REF(on_blood_splashed))
	update_explanation_text()

/datum/objective/personal/blood_splash/Destroy()
	if(owner?.current)
		UnregisterSignal(owner.current, COMSIG_SPLASHED_MOB)
	return ..()

/datum/objective/personal/blood_splash/proc/on_blood_splashed(datum/source, mob/target, list/reagents_splashed)
	SIGNAL_HANDLER
	if(completed || target != owner.current)
		return

	var/blood_amount = 0
	for(var/datum/reagent/reagent_type as anything in reagents_splashed)
		if(istype(reagent_type, /datum/reagent/blood))
			blood_amount += reagent_type.volume

	if(blood_amount >= 30)
		complete_objective()

/datum/objective/personal/blood_splash/complete_objective()
	. = ..()
	to_chat(owner.current, span_greentext("You have performed the blood ritual, appeasing Graggar!"))
	adjust_storyteller_influence(GRAGGAR, 20)
	UnregisterSignal(owner.current, COMSIG_SPLASHED_MOB)

/datum/objective/personal/blood_splash/reward_owner()
	. = ..()
	owner.current.adjust_stat_modifier(STATMOD_GRAGGAR_BLESSING, STATKEY_STR, 1)
	owner.current.adjust_stat_modifier(STATMOD_GRAGGAR_BLESSING, STATKEY_CON, 1)

/datum/objective/personal/blood_splash/update_explanation_text()
	explanation_text = "There is much power in blood. Splash a bucket full of blood on yourself to appease Graggar!"
