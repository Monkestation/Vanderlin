//Mind helpers

/datum/mind/proc/teach_crafting_recipe(R)
	if(!learned_recipes)
		learned_recipes = list()
	learned_recipes |= R

/datum/mind/proc/forget_crafting_recipe(R)
	if(!learned_recipes)
		return
	learned_recipes -= R

/atom/proc/OnCrafted(dirin, mob/user)
	SHOULD_CALL_PARENT(TRUE)
	if(user)
		SEND_SIGNAL(user, COMSIG_ITEM_CRAFTED, user, type)
		record_featured_stat(FEATURED_STATS_CRAFTERS, user)
	record_featured_object_stat(FEATURED_STATS_CRAFTED_ITEMS, name)
	add_abstract_elastic_data(ELASCAT_CRAFTING, "[initial(name)]", 1)
	return

/obj/OnCrafted(dirin, mob/user)
	if(lock)
		QDEL_NULL(lock)
		can_add_lock = TRUE
	. = ..()

/obj/structure/OnCrafted(dirin, mob/user)
	obj_flags |= CAN_BE_HIT
	. = ..()
