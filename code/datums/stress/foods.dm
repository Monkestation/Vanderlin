/datum/stress_event/wine_okay
	stress_change = -1
	desc = span_green("That drink was alright.")
	timer = 10 MINUTES

/datum/stress_event/wine_good
	stress_change = -2
	desc = span_green("A decent vintage always goes down easy.")
	timer = 10 MINUTES

/datum/stress_event/wine_great
	stress_change = -3
	desc = span_blue("An absolutely exquisite vintage. Indubitably.")
	timer = 10 MINUTES

/datum/stress_event/noble_lavish_food
	stress_change = -2
	desc = span_green("Truly, a feast befitting my station.")
	timer = 10 MINUTES

/datum/stress_event/favourite_food
	stress_change = -1
	desc = span_green("I ate my favourite food!")
	timer = 5 MINUTES

/datum/stress_event/favourite_food/can_apply(mob/living/user)
	. = ..()
	if(!.)
		return FALSE
	if(user.has_stress_type(/datum/stress_event/favourite_food))
		return FALSE
	else if(ishuman(user))
		var/mob/living/carbon/human/human_eater = user
		if(human_eater.culinary_preferences && human_eater.culinary_preferences[CULINARY_FAVOURITE_FOOD])
			var/favorite_food_type = human_eater.culinary_preferences[CULINARY_FAVOURITE_FOOD]
			var/obj/item/reagent_containers/food/snacks/favorite_food_instance = favorite_food_type
			timer = timer * max(initial(favorite_food_instance.faretype), 1)

			if(human_eater.culinary_preferences[CULINARY_RANDOM_PREFERENCES] && !human_eater.culinary_preferences[FAVOURITE_FOOD_TRIUMPH])
				human_eater.adjust_triumphs(1)
				human_eater.culinary_preferences[FAVOURITE_FOOD_TRIUMPH] = TRUE

			return TRUE

/datum/stress_event/favourite_drink
	stress_change = -1
	desc = span_green("I had my favourite drink!")
	timer = 5 MINUTES

/datum/stress_event/favourite_drink/can_apply(mob/living/user)
	. = ..()
	if(!.)
		return FALSE
	if(user.has_stress_type(/datum/stress_event/favourite_drink))
		return FALSE
	else if(ishuman(user))
		var/mob/living/carbon/human/human_drinker = user
		if(human_drinker.culinary_preferences && human_drinker.culinary_preferences[CULINARY_FAVOURITE_DRINK])
			var/favorite_drink_type = human_drinker.culinary_preferences[CULINARY_FAVOURITE_DRINK]
			var/datum/reagent/consumable/favorite_drink_instance = favorite_drink_type
			timer = timer * max(1 + initial(favorite_drink_instance.quality), 1)

			if(human_drinker.culinary_preferences[CULINARY_RANDOM_PREFERENCES] && !human_drinker.culinary_preferences[FAVOURITE_DRINK_TRIUMPH])
				human_drinker.adjust_triumphs(1)
				human_drinker.culinary_preferences[FAVOURITE_DRINK_TRIUMPH] = TRUE

			return TRUE

/datum/stress_event/hated_food
	stress_change = 1
	desc = span_red("I had to eat my most hated food!")
	timer = 10 MINUTES

/datum/stress_event/hated_food/can_apply(mob/living/user)
	. = ..()
	if(!.)
		return FALSE
	if(user.has_stress_type(/datum/stress_event/hated_food))
		return FALSE

/datum/stress_event/hated_drink
	stress_change = 1
	desc = span_red("I had to consume my most hated drink!")
	timer = 10 MINUTES

/datum/stress_event/hated_drink/can_apply(mob/living/user)
	. = ..()
	if(!.)
		return FALSE
	if(user.has_stress_type(/datum/stress_event/hated_drink))
		return FALSE
