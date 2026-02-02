/datum/chimeric_node/input/gluttony
	name = "gluttonous"
	desc = "Triggered when you consume a specific food."

	var/list/triggered_food_types = list(/obj/item/reagent_containers/food)

/datum/chimeric_node/input/gluttony/register_triggers(mob/living/carbon/target)
	if(!target)
		return

	unregister_triggers()
	registered_signals += COMSIG_MOB_FOOD_EAT
	RegisterSignal(target, COMSIG_MOB_FOOD_EAT, PROC_REF(on_food_eat))

/datum/chimeric_node/input/gluttony/proc/on_food_eat(datum/source, obj/item/food_eaten)
	SIGNAL_HANDLER

	var/passed = FALSE
	for(var/path in triggered_food_types)
		if(passed)
			break
		if(!istype(food_eaten, path))
			continue
		passed = TRUE

	if(passed)
		trigger_output(node_purity * 0.01)

/datum/chimeric_node/input/gluttony/organ
	name = "graggerite"
	weight = 5
	triggered_food_types = list(/obj/item/reagent_containers/food/snacks/organ)

/datum/chimeric_node/input/gluttony/cheese
	name = "rous"
	weight = 5
	triggered_food_types = list(/obj/item/reagent_containers/food/snacks/cheese, /obj/item/reagent_containers/food/snacks/cheese_wedge)
