/mob/living/proc/try_repeatable_craft(obj/item/attacked_atom, obj/item/starting_atom)
	var/list/recipes = list()
	// Simple check first, path is a recipe's starting_atom (the item used to attack)
	for(var/path in GLOB.repeatable_crafting_recipes)
		// more inefficient but allows for inverse start recipes
		var/attacked_item_path = attacked_atom.type
		if(istype(attacked_atom, /obj/item/natural/bundle))
			attacked_item_path = attacked_atom:stacktype
		var/attacking_item_path = starting_atom.type
		if(istype(starting_atom, /obj/item/natural/bundle))
			attacking_item_path = starting_atom:stacktype

		if(!ispath(attacked_item_path, path) && !ispath(attacking_item_path, path))
			continue
		recipes |= GLOB.repeatable_crafting_recipes[path]

	var/list/passed_recipes = list()

	for(var/datum/repeatable_crafting_recipe/recipe in recipes)
		if(!recipe.check_start(attacked_atom, starting_atom, src))
			continue
		if(recipe.requires_learning && !(recipe.type in mind?.learned_recipes))
			continue
		passed_recipes |= recipe

	if(!length(passed_recipes))
		return list()
	return passed_recipes


/mob/living/proc/try_recipes(obj/item/attacked_atom, obj/item/starting_atom)
	if(has_world_trait(/datum/world_trait/delver))
		var/area/area = get_area(src)
		if(area.delver_restrictions)
			return FALSE
		if(!SShousing.check_access(key))
			return FALSE

	if(isitem(attacked_atom) && attacked_atom.in_progress_slapcraft)
		return attacked_atom.in_progress_slapcraft.try_process_item(starting_atom, src)

	var/list/recipes = list()
	recipes |= src.try_orderless_slapcraft(starting_atom, attacked_atom)
	recipes |= src.try_slapcraft(attacked_atom, starting_atom)
	recipes |= src.try_repeatable_craft(attacked_atom, starting_atom)

	if(!length(recipes))
		return FALSE

	var/datum/recipe
	if(length(recipes) == 1 && (istype(recipes[1], /datum/repeatable_crafting_recipe/cooking)))
		recipe = recipes[1]
	else
		recipe = browser_input_list(src, "Choose a recipe to craft", "Recipes", recipes)

	if(!recipe || QDELETED(src) || QDELETED(attacked_atom) || QDELETED(starting_atom))
		return FALSE

	if(!Adjacent(attacked_atom)) // sanity check
		return FALSE

	return execute_recipe(recipe, starting_atom, attacked_atom)

/mob/living/proc/execute_recipe(datum/slapcraft_recipe/target_recipe, obj/item/first_item, obj/item/second_item)
	if(!target_recipe)
		return

	if(istype(target_recipe, /datum/slapcraft_recipe))
		// We have found the recipe we want to do, make an assembly item where the first item used to be.
		var/obj/item/slapcraft_assembly/assembly = new()
		assembly.set_recipe(target_recipe)

		/// The location to place the assembly or items if the user cannot hold them
		var/atom/fallback_loc = drop_location()
		var/atom/alt_fallback = get_turf(second_item)

		var/datum/slapcraft_step/step_one = SLAPCRAFT_STEP(target_recipe.steps[1])

		var/list/errors = list()

		// Instantly and silently perform the first step on the assembly, disassemble it if something went wrong
		if(!step_one.perform(src, second_item, assembly, instant = TRUE, silent = TRUE, error_list = errors))
			assembly.disassemble()
			if(length(errors))
				errors = span_danger("I cannot craft that.<hr>[jointext(errors, "<br>")]")
				to_chat(src, span_notice(errors))
			return TRUE

		fallback_loc = drop_location() //We may have moved

		if(!target_recipe.anchor_craft)
			if(!put_in_hands(assembly))
				assembly.forceMove(fallback_loc)
		else
			assembly.forceMove(alt_fallback)
		var/turf/result_loc = target_recipe.get_result_location(assembly, src)

		var/datum/slapcraft_step/step_two = target_recipe.next_suitable_step(src, first_item, assembly.step_states, check_type_only = TRUE)
		// Perform the second step, also disassemble it if we stopped working on it, because keeping 1 component assembly is futile.
		if(!step_two.perform(src, first_item, assembly, error_list = errors))
			assembly.disassemble()
			if(length(errors))
				errors = span_danger("I cannot craft that.<hr>[jointext(errors, "<br>")]")
				to_chat(src, span_notice(errors))
			return TRUE

		if(QDELING(assembly) && assembly.being_finished)
			var/in_hands = FALSE
			if(length(assembly.finished_items) == 1)
				var/obj/item/finished_item = assembly.finished_items[1].resolve()
				if(isitem(finished_item) && put_in_hands(finished_item))
					in_hands = TRUE

			if(!in_hands)
				for(var/datum/weakref/W as anything in assembly.finished_items)
					var/obj/item/finished_item = W.resolve()
					finished_item.forceMove(result_loc)

			assembly.finished_items = null

		return TRUE
	else if(istype(target_recipe, /datum/orderless_slapcraft))
		var/datum/orderless_slapcraft/recipe = target_recipe
		second_item.in_progress_slapcraft = new recipe.type(null, second_item)
		return second_item.in_progress_slapcraft.try_process_item(first_item, src)

	else if(istype(target_recipe, /datum/repeatable_crafting_recipe))
		var/datum/repeatable_crafting_recipe/recipe = target_recipe
		return recipe.start_recipe(second_item, first_item, src)
