/datum/objective/personal/rotten_feast
	name = "Rotten Feast"
	category = "Pestra's Chosen"
	triumph_count = 2
	rewards = list("2 Triumphs", "Pestra grows stronger", "Pestra blesses you (+1 Constitution)")
	var/meals_eaten = 0
	var/meals_required = 1

/datum/objective/personal/rotten_feast/on_creation()
	. = ..()
	if(owner?.current)
		RegisterSignal(owner.current, COMSIG_ROTTEN_FOOD_EATEN, PROC_REF(on_rotten_eaten))
	update_explanation_text()

/datum/objective/personal/rotten_feast/Destroy()
	if(owner?.current)
		UnregisterSignal(owner.current, COMSIG_ROTTEN_FOOD_EATEN)
	return ..()

/datum/objective/personal/rotten_feast/proc/on_rotten_eaten(datum/source, obj/item/eaten_food)
	SIGNAL_HANDLER
	if(completed)
		return

	meals_eaten++
	if(meals_eaten >= meals_required)
		complete_objective()
	else
		to_chat(owner.current, span_notice("Rotten meal consumed! Eat [meals_required - meals_eaten] more to complete Pestra's objective."))

/datum/objective/personal/rotten_feast/complete_objective()
	. = ..()
	to_chat(owner.current, span_greentext("You have consumed enough rotten food to complete Pestra's objective!"))
	adjust_storyteller_influence(PESTRA, 20)
	UnregisterSignal(owner.current, COMSIG_ROTTEN_FOOD_EATEN)

/datum/objective/personal/rotten_feast/reward_owner()
	. = ..()
	owner.current.adjust_stat_modifier(STATMOD_PESTRA_BLESSING, STATKEY_CON, 1)

/datum/objective/personal/rotten_feast/update_explanation_text()
	explanation_text = "Let nothing go to waste! Consume [meals_required] piece of rotten food to gain Pestra's favor!"
