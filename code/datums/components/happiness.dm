/datum/component/happiness_container
	///our current happiness
	var/current_happiness = 0
	///the maximum happiness for this life set to -1 to disable
	var/maxiumum_life_happiness = -1
	///reagents we like
	var/list/liked_reagents = list()
	///the reagents we dislike
	var/list/disliked_reagents = list()
	///the foods we like
	var/list/liked_foods = list()
	///the foods we dislike
	var/list/disliked_foods = list()
	///the food_types we dislike
	var/list/disliked_food_types = list()
	///this is our thresholds where we do a callback at unhappy
	var/list/unhappy_callbacks = list()

/datum/component/happiness_container/Initialize(maxiumum_life_happiness = -1, liked_reagents = list(), disliked_reagents = list(), liked_foods = list(), disliked_foods = list(), disliked_food_types = list(), unhappy_callbacks = list())
	. = ..()
	src.maxiumum_life_happiness = maxiumum_life_happiness
	src.liked_reagents = liked_reagents
	src.disliked_reagents = disliked_reagents
	src.liked_foods = liked_foods
	src.disliked_foods = disliked_foods
	src.disliked_food_types = disliked_food_types
	src.unhappy_callbacks = unhappy_callbacks

/datum/component/happiness_container/Destroy(force)
	unhappy_callbacks = null
	return ..()

/datum/component/happiness_container/RegisterWithParent()
	. = ..()
	RegisterSignal(parent, COMSIG_HAPPINESS_ADJUST, PROC_REF(adjust_happiness))
	RegisterSignal(parent, COMSIG_MOB_FEED, PROC_REF(on_eat))
	RegisterSignal(parent, COMSIG_HAPPINESS_PASS_HAPPINESS, PROC_REF(pass_happiness))
	RegisterSignal(parent, COMSIG_HAPPINESS_CHECK_RANGE, PROC_REF(passes_happy))
	RegisterSignal(parent, COMSIG_HAPPINESS_RETURN_VALUE, PROC_REF(return_happiness))

/datum/component/happiness_container/UnregisterFromParent()
	. = ..()
	UnregisterSignal(parent, COMSIG_HAPPINESS_ADJUST)
	UnregisterSignal(parent, COMSIG_HAPPINESS_CHECK_RANGE)
	UnregisterSignal(parent, COMSIG_LIVING_ATE)
	UnregisterSignal(parent, COMSIG_HAPPINESS_PASS_HAPPINESS)
	UnregisterSignal(parent, COMSIG_HAPPINESS_RETURN_VALUE)

/datum/component/happiness_container/proc/adjust_happiness(datum/source, adjustment, atom/came_from, natural_cause = FALSE, transfer = FALSE)
	if(adjustment > 0)
		var/maximum_drain = 0
		if(maxiumum_life_happiness == -1)
			maximum_drain = adjustment
		else
			if(maxiumum_life_happiness == 0)
				return
			maximum_drain = min(maxiumum_life_happiness, adjustment)

		if(!transfer)
			maxiumum_life_happiness -= maximum_drain
		current_happiness += maximum_drain
	else
		current_happiness += adjustment
	if(came_from)
		SEND_SIGNAL(parent, COMSIG_FRIENDSHIP_CHANGE, came_from, adjustment * 0.5)

	for(var/datum/callback/callback as anything in unhappy_callbacks)
		if(current_happiness < unhappy_callbacks[callback])
			callback.Invoke()

/datum/component/happiness_container/proc/return_happiness(datum/source)
	return current_happiness

/datum/component/happiness_container/proc/on_eat(datum/source, atom/ate, amount, atom/came_from)
	ate_type(ate.type, came_from)
	for(var/datum/reagent/reagent  as anything in ate.reagents?.reagent_list)
		if(reagent.type in liked_reagents)
			adjust_happiness(parent, liked_reagents[reagent.type] * reagent.volume, came_from)
		if(reagent.type in disliked_reagents)
			adjust_happiness(parent, disliked_reagents[reagent.type] * reagent.volume, came_from)

/datum/component/happiness_container/proc/ate_type(atom/ate)
	if(istype(ate, /obj/item/reagent_containers/food))
		var/obj/item/reagent_containers/food/food = ate
		for(var/food_type in disliked_food_types)
			if(food_type & initial(food.foodtype))
				adjust_happiness(parent, disliked_food_types[food_type])
	if(ate in liked_foods)
		adjust_happiness(parent, liked_foods[ate.type])
	if(ate in disliked_foods)
		adjust_happiness(parent, disliked_foods[ate.type])

/datum/component/happiness_container/proc/pass_happiness(datum/source, atom/target)
	if(!target.GetComponent(/datum/component/happiness_container))
		target.AddComponent(/datum/component/happiness_container)
	SEND_SIGNAL(target, COMSIG_HAPPINESS_ADJUST, current_happiness, null, FALSE, TRUE)


/datum/component/happiness_container/proc/passes_happy(datum/source, check)
	if(check > 0)
		if(!(current_happiness > check))
			return FALSE
	else
		if(!(current_happiness < check))
			return FALSE
	return TRUE
