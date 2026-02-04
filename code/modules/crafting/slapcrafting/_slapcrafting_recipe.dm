/datum/slapcraft_recipe
	abstract_type = /datum/slapcraft_recipe
	/// Name of the recipe. Will use the resulting atom's name if not specified
	var/name
	/// Description of the recipe. May be displayed as additional info in the handbook.
	var/desc
	/// Hint displayed to the user which examines the item required for the first step.
	var/examine_hint

	/// List of all steps to finish this recipe
	var/list/steps

	/// Type of the item that will be yielded as the result.
	var/atom/result_type
	/// Amount of how many resulting types will be crafted.
	var/result_amount = 1
	/// Instead of result type you can use this as associative list of types to amounts for a more varied output
	var/list/result_list

	/// Weight class of the assemblies for this recipe.
	var/assembly_weight_class = WEIGHT_CLASS_NORMAL
	/// Suffix for the assembly name.
	var/assembly_name_prefix = "incomplete"
	/// Should the assembly be dense?
	var/dense_assembly = FALSE

	/// Category this recipe is in the handbook.
	var/category = SLAP_CAT_MISC
	/// Subcategory this recipe is in the handbook.
	var/subcategory = SLAP_SUBCAT_MISC

	/// Appearance in the radial menu for the user to choose from if there are recipe collisions.
	var/image/radial_appearance
	/// Order in which the steps should be performed.
	var/step_order = SLAP_ORDER_STEP_BY_STEP
	// Can this assembly be taken apart before it's finished?
	var/can_disassemble = TRUE

	/// Should we print text when we finish? Mostly used to de-bloat chat.
	var/show_finish_text = FALSE
	///Crafting difficulty for finishing recipe
	var/craftdiff = 1
	var/datum/skill/skillcraft
	var/anchor_craft = FALSE
	var/craftsound
	///Place finished result in front of assembly in user's direction. Mutually exclusive with offset_user.
	var/offset_forward = FALSE
	///Place finished result at user's location. Mutually exclusive with offset_forward.
	var/offset_user = FALSE
	/// Minimum do_after time when repeating failed crafts
	var/repeat_perform_time = 0

/datum/slapcraft_recipe/New()
	. = ..()

	// Set the name from the resulting atom if the name is missing and resulting type is present.
	if(!name)
		var/atom/movable/result_cast
		if(result_list)
			for(var/path in result_list)
				// First association it can get, then break.
				result_cast = path
				break
		else if(result_type)
			result_cast = result_type
		if(result_cast)
			name = initial(result_cast.name)

/datum/slapcraft_recipe/proc/get_radial_image()
	if(!radial_appearance)
		radial_appearance = make_radial_image()
	return radial_appearance

/// Returns the next suitable step to be performed with the item by the user with such step_states
/datum/slapcraft_recipe/proc/next_suitable_step(mob/living/user, obj/item/item, list/step_states, check_type_only)
	var/datum/slapcraft_step/chosen_step
	for(var/step_type in steps)
		if(!check_correct_step(step_type, step_states))
			continue
		var/datum/slapcraft_step/iterated_step = SLAPCRAFT_STEP(step_type)
		if(!iterated_step.perform_check(user, item, null, check_type_only = check_type_only))
			continue
		chosen_step = iterated_step
		break
	return chosen_step

/datum/slapcraft_recipe/proc/is_finished(list/step_states, add_step)
	// Adds step checks if the recipe would be finished with the added step
	if(add_step)
		step_states = step_states.Copy()
		step_states[add_step] = TRUE
	switch(step_order)
		if(SLAP_ORDER_STEP_BY_STEP, SLAP_ORDER_FIRST_AND_LAST)
			//See if the last step was finished.
			var/last_path = steps[steps.len]
			if(step_states[last_path])
				return TRUE
		if(SLAP_ORDER_FIRST_THEN_FREEFORM)
			var/any_missing = FALSE
			for(var/step_path in steps)
				if(!step_states[step_path])
					any_missing = TRUE
					break
			if(!any_missing)
				return TRUE
	return FALSE

/datum/slapcraft_recipe/proc/get_possible_next_steps(list/step_states)
	var/list/possible = list()
	for(var/step_type in steps)
		if(!check_correct_step(step_type, step_states))
			continue
		possible += step_type
	return possible

/// Checks if a step of type `step_type` can be performed with the given `step_states` state.
/datum/slapcraft_recipe/proc/check_correct_step(step_type, list/step_states)
	// Already finished this step.
	if(step_states[step_type])
		return FALSE
	var/first_step = steps[1]
	// We are missing the first step being done, only allow it until we allow something else
	if(!step_states[first_step])
		if(step_type == first_step)
			return TRUE
		else
			return FALSE
	switch(step_order)
		if(SLAP_ORDER_STEP_BY_STEP)
			// Just in case any step is optional we need to figure out which is the furthest step performed.
			var/furthest_step = 0
			var/step_count = 0
			for(var/iterated_step in steps)
				step_count++
				if(step_states[iterated_step])
					furthest_step = step_count

			step_count = 0
			for(var/iterated_step in steps)
				step_count++
				// Step is done, continue
				if(step_states[iterated_step])
					continue
				// This step is before one we have already completed, continue
				// (essentially when skipping an optional step, we dont want to allow that step to be performed)
				if(step_count <= furthest_step)
					continue
				//We reach a step that isn't done. Check if the checked step is the one
				if(iterated_step == step_type)
					return TRUE
				// If the step is optional, perhaps the next one will be eligible.
				var/datum/slapcraft_step/iterated_step_datum = SLAPCRAFT_STEP(iterated_step)
				if(iterated_step_datum.optional)
					continue
				// It wasn't it, return FALSE
				return FALSE
		if(SLAP_ORDER_FIRST_AND_LAST)
			var/last_step = steps[steps.len]
			// If we are trying to do the last step, make sure all the rest ones are finished
			if(step_type == last_step)
				for(var/iterated_step in steps)
					if(step_states[iterated_step])
						continue
					if(iterated_step == last_step)
						return TRUE
					// If the step is optional, we don't mind.
					var/datum/slapcraft_step/iterated_step_datum = SLAPCRAFT_STEP(iterated_step)
					if(iterated_step_datum.optional)
						continue
					return FALSE

			// Middle step, with the last step not being finished, and the first step being finished
			return TRUE

		if(SLAP_ORDER_FIRST_THEN_FREEFORM)
			// We have the first one and we are not repeating a step.
			return TRUE

	return FALSE

/datum/slapcraft_recipe/proc/make_radial_image()
	// If we make an explicit result type, use its icon and icon state in the radial menu to display it.
	var/atom/movable/result_cast = result_type
	if(result_list)
		for(var/path in result_list)
			// First association it can get, then break.
			result_cast = path
			break
	else if(result_type)
		result_cast = result_type
	if(result_cast)
		return image(icon = initial(result_cast.icon), icon_state = initial(result_cast.icon_state))
	//Fallback image idk what to put here.
	return image(icon = 'icons/mob/radial.dmi', icon_state = "radial_rotate")

/// User has finished the recipe in an assembly.
/datum/slapcraft_recipe/proc/finish_recipe(mob/living/user, obj/item/slapcraft_assembly/assembly, last_type, obj/item/last_item)
	var/prob2craft = 25
	var/prob2fail = 1
	if(craftdiff)
		prob2craft -= (25*craftdiff)
	if(skillcraft)
		if(user.mind)
			prob2craft += (user.get_skill_level(skillcraft) * 25)
	else
		prob2craft = 100
	if(isliving(user))
		var/mob/living/L = user
		if(L.STALUC > 10)
			prob2fail = 0
		if(L.STALUC < 10)
			prob2fail += (10-L.STALUC)
		if(L.STAINT > 10)
			prob2craft += ((10-L.STAINT)*-1)*2
	if(prob2craft < 1)
		to_chat(user, "<span class='danger'>I lack the skills for this...</span>")
		breakdown_assembly(assembly)
		return
	else
		prob2craft = CLAMP(prob2craft, 5, 99)
		if(prob(prob2fail)) //critical fail
			to_chat(user, "<span class='danger'>MISTAKE! I've completely fumbled completing \the [name]!</span>")
			breakdown_assembly(assembly)
			return
		if(!prob(prob2craft))
			if(user.client?.prefs.showrolls)
				to_chat(user, "<span class='danger'>I've failed to complete \the [name]. (Success chance: [prob2craft]%)</span>")
			else
				to_chat(user, "<span class='danger'>I've failed to complete \the [name].</span>")
			assembly.step_states[last_type] = FALSE
			var/datum/slapcraft_step/next_step = assembly.recipe.next_suitable_step(user, last_item, assembly.step_states)
			if(!next_step)
				return
			// Try and do it
			next_step.perform(user, last_item, assembly, minimum_perform_time = repeat_perform_time)
			return

	if(show_finish_text)
		to_chat(user, span_notice("You finish \the [name]."))

	if(user.mind && skillcraft)
		if(isliving(user))
			var/mob/living/L = user
			var/amt2raise = L.STAINT * 2// its different over here
			if(craftdiff > 0) //difficult recipe
				amt2raise += (craftdiff * 10)
			if(amt2raise > 0)
				user.mind.add_sleep_experience(skillcraft, amt2raise, FALSE)

	if(craftsound)
		playsound(assembly, craftsound, 100, TRUE)

	assembly.being_finished = TRUE
	var/list/results = list()
	create_items(assembly, results, user)

	// Move items which wanted to go to the resulted item into it. Only supports for the first created item.
	var/atom/movable/first_item = results[1]

	for(var/obj/item/item as anything in assembly.items_to_place_in_result)
		item.forceMove(first_item)

	for(var/obj/item/item as anything in (results - assembly.items_to_place_in_result))
		assembly.finished_items += WEAKREF(item)

	after_create_items(results, assembly)
	dispose_assembly(assembly)

	//Finally, CheckParts on the resulting items.
	for(var/atom/movable/result_item as anything in results)
		result_item.CheckParts()
		result_item.OnCrafted(user.dir, user) //Here so we can handle any items placed into resulting items

/// Runs when the last step tries to be performed and cancels the step if it returns FALSE. Could be used to validate location in structure construction via slap crafting.
/datum/slapcraft_recipe/proc/can_finish(mob/living/user, obj/item/slapcraft_assembly/assembly)
	return TRUE

/// The proc that creates the resulted item(s). Make sure to add them to the passed `results` list.
/datum/slapcraft_recipe/proc/create_items(obj/item/slapcraft_assembly/assembly, list/results, mob/living/user)
	/// Check if we want to craft multiple items, if yes then populate the list passed by the argument with them.
	var/list/multi_to_craft
	if(result_list)
		multi_to_craft = result_list
	else if (result_amount)
		multi_to_craft = list()
		multi_to_craft[result_type] = result_amount

	if(multi_to_craft.len)
		for(var/path in multi_to_craft)
			var/amount = multi_to_craft[path]
			var/shift_pixels = (amount > 1)

			for(var/i in 1 to amount)
				var/atom/movable/new_thing = create_item(path, assembly, user)

				if(shift_pixels)
					new_thing.pixel_x += rand(-4,4)
					new_thing.pixel_y += rand(-4,4)
				results += new_thing

/// Creates and returns a new item. This gets called for every item that is supposed to be created in the recipe.
/datum/slapcraft_recipe/proc/create_item(item_path, obj/item/slapcraft_assembly/assembly, mob/living/user)
	return new item_path(get_result_location(assembly, user))

/// Behaviour after the item is created, and before the slapcrafting assembly is disposed.
/// Here you can move the components into the item if you wish, or do other stuff with them.
/datum/slapcraft_recipe/proc/after_create_items(list/items_list, obj/item/slapcraft_assembly/assembly)
	return

/// Here is the proc to get rid of the assembly, should one want to override it to handle that differently.
/datum/slapcraft_recipe/proc/dispose_assembly(obj/item/slapcraft_assembly/assembly)
	qdel(assembly)

/// Here is the proc to get rid of the assembly, should one want to override it to handle that differently.
/datum/slapcraft_recipe/proc/breakdown_assembly(obj/item/slapcraft_assembly/assembly)
	assembly.disassemble()

/datum/slapcraft_recipe/proc/check_craft_requirements(mob/user, turf/T)
	return TRUE

/datum/slapcraft_recipe/proc/get_result_location(obj/item/slapcraft_assembly/assembly, mob/living/user)
	if(offset_forward)
		return get_step(assembly.drop_location(), user.dir)
	else if(offset_user)
		return get_turf(user)
	return assembly.drop_location()
