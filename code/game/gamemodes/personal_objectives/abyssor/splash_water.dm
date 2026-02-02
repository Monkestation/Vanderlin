/datum/objective/personal/abyssor_splash
	name = "Splash Water"
	category = "Abyssor's Chosen"
	triumph_count = 2
	rewards = list("2 Triumphs", "Abyssor grows stronger", "Abyssor blesses you (+1 Strength)")

/datum/objective/personal/abyssor_splash/on_creation()
	. = ..()
	if(owner?.current)
		RegisterSignal(owner.current, COMSIG_SPLASHED_MOB, PROC_REF(on_mob_splashed))
	update_explanation_text()

/datum/objective/personal/abyssor_splash/Destroy()
	if(owner?.current)
		UnregisterSignal(owner.current, COMSIG_SPLASHED_MOB)
	return ..()

/datum/objective/personal/abyssor_splash/proc/on_mob_splashed(datum/source, mob/target, list/reagents_splashed)
	SIGNAL_HANDLER
	if(completed || target == owner.current || target.stat == DEAD || !target.client)
		return

	var/water_volume = 0
	for(var/datum/reagent/reagent_type as anything in reagents_splashed)
		if(istype(reagent_type, /datum/reagent/water))
			water_volume += reagent_type.volume

	if(water_volume >= 30)
		complete_objective()

/datum/objective/personal/abyssor_splash/complete_objective()
	. = ..()
	to_chat(owner.current, span_greentext("You've unleashed Abyssor's rage, completing the objective!"))
	adjust_storyteller_influence(ABYSSOR, 20)
	UnregisterSignal(owner.current, COMSIG_SPLASHED_MOB)

/datum/objective/personal/abyssor_splash/reward_owner()
	. = ..()
	owner.current.adjust_stat_modifier(STATMOD_ABYSSOR_BLESSING, STATKEY_STR, 1)

/datum/objective/personal/abyssor_splash/update_explanation_text()
	explanation_text = "Abyssor is RAGING! Splash some ingrate who forgot his name with a bucket full of water!"
