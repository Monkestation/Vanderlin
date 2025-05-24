/datum/repeatable_crafting_recipe
	abstract_type = /datum/repeatable_crafting_recipe

	var/name = "Generic Recipe"
	var/category
	var/atom/output
	var/output_amount = 1
	var/list/requirements = list()
	var/list/reagent_requirements = list()
	///this is a list of tool usage in their order which executes after requirements and reagents are fufilled these are assoc lists going path = list(text, self_text, sound)
	var/list/tool_usage = list()
	///these typepaths and their subtypes won't be considered as requirements for recipes
	var/list/blacklisted_paths = list()

	///do we need to be learned
	var/requires_learning = FALSE

	///our sellprice
	var/sellprice = 0

	///this is the things we check for in our offhand ie herb pouch or something to repeat the craft
	var/list/offhand_repeat_check = list(
		/obj/item/storage/backpack
	)
	///if this is set we also check the floor on the ground
	var/check_around_owner = TRUE
	///this is the atom we need to start the process
	var/atom/starting_atom
	///this is the thing we need to hit to start
	var/atom/attacked_atom

	///our crafting difficulty
	var/craftdiff = 1
	///our skilltype
	var/datum/skill/skillcraft = /datum/skill/craft/crafting
	var/minimum_skill_level = 0
	///the amount of time the atom in question spends doing this recipe
	var/craft_time = 1 SECONDS
	///do we put in hand?
	var/put_items_in_hand = TRUE
	///the time it takes to move an item from ground to hand
	var/ground_use_time = 0.2 SECONDS
	///the time it takes to move an item from storage to hand
	var/storage_use_time = 0.4 SECONDS
	///the time it takes to use reagents on the craft
	var/reagent_use_time = 0.8 SECONDS
	///how long we use a tool on the craft for
	var/tool_use_time = 1.2 SECONDS
	///our crafting message
	var/crafting_message
	///if we need to be on a table
	var/required_table = FALSE
	///intent we require
	var/datum/intent/required_intent
	///do we also use the attacked_atom in the recipe?
	var/uses_attacked_atom = FALSE
	///do we also count subtypes?
	var/subtypes_allowed = FALSE
	///do we also count reagent subtypes?
	var/reagent_subtypes_allowed = FALSE
	///list of types we pass before deletion to the child
	var/list/pass_types_in_end = list()
	///this is our extra % added after all skills and such
	var/extra_chance = 0
	///do we hide from recipe books
	var/hides_from_books = FALSE
	///sound we use for crafting
	var/crafting_sound
	var/sound_volume = 40

/**
 * Checks if the recipe can be started with the given items
 *
 * @param {obj/item} attacked_item - The item being acted upon
 * @param {obj/item} attacking_item - The item the user is using to interact
 * @param {mob} user - The user attempting to craft
 * @return {boolean} - TRUE if recipe can start, FALSE otherwise
 */
/datum/repeatable_crafting_recipe/proc/check_start(obj/item/attacked_item, obj/item/attacking_item, mob/user)
	if((!istype(attacked_item, attacked_atom) && !istype(attacked_item, /obj/item/natural/bundle)) || (required_intent && user.used_intent.type != required_intent))
		return FALSE

	if(minimum_skill_level)
		if(user?.get_skill_level(skillcraft) <= minimum_skill_level)
			return FALSE

	if(istype(attacked_item, /obj/item/natural/bundle))
		var/bundle_path = attacked_item:stacktype
		if(!ispath(bundle_path, attacked_atom))
			return FALSE

	for(var/path in blacklisted_paths)
		if(attacked_item in typesof(path))
			return FALSE

	if(required_table && !locate(/obj/structure/table) in get_turf(attacked_item))
		return FALSE

	var/list/copied_requirements = requirements.Copy()
	var/list/copied_reagent_requirements = reagent_requirements.Copy()
	var/list/copied_tool_usage = tool_usage.Copy()
	var/list/usable_contents = list()

	gather_usable_contents(user, usable_contents)

	var/list/total_list = usable_contents
	var/list/all_blacklisted = typesof_list(blacklisted_paths)

	for(var/path as anything in total_list)
		for(var/required_path as anything in requirements)
			if(!ispath(path, required_path) || (!subtypes_allowed && (path in subtypesof(required_path))) || (path in all_blacklisted))
				continue
			copied_requirements[required_path] -= total_list[path]
			if(copied_requirements[required_path] <= 0)
				copied_requirements -= required_path
			break

	for(var/path as anything in total_list)
		for(var/required_path as anything in tool_usage)
			if(ispath(path, required_path))
				copied_tool_usage -= required_path

	if(length(reagent_requirements))
		var/list/reagent_values = gather_reagents(user)

		for(var/path in reagent_values)
			for(var/required_path as anything in reagent_requirements)
				if(!ispath(path, required_path))
					continue
				if(reagent_values[path] < reagent_requirements[required_path])
					return FALSE
				copied_reagent_requirements -= required_path

	return !(length(copied_requirements) || length(copied_reagent_requirements) || length(copied_tool_usage))

/**
 * Checks the maximum number of repeats possible with available resources
 *
 * @param {obj/item} attacked_item - The item being acted upon
 * @param {obj/item} attacking_item - The item the user is using to interact
 * @param {mob} user - The user attempting to craft
 * @return {number} - Maximum number of crafts possible
 */
/datum/repeatable_crafting_recipe/proc/check_max_repeats(obj/item/attacked_item, obj/item/attacking_item, mob/user)
	var/list/usable_contents = list()

	gather_usable_contents(user, usable_contents)

	// Handle uses_attacked_atom properly - if we use the attacked atom, we need to include it in our calculations
	if(uses_attacked_atom)
		var/attacked_type = attacked_item.type
		if(istype(attacked_item, /obj/item/natural/bundle))
			attacked_type = attacked_item:stacktype
			usable_contents |= attacked_type
			usable_contents[attacked_type] += attacked_item:amount
		else
			usable_contents |= attacked_type
			usable_contents[attacked_type] += 1

	var/max_crafts = 10000
	var/list/total_list = usable_contents
	var/list/all_blacklisted = typesof_list(blacklisted_paths)

	// Check each requirement against available items
	for(var/required_path as anything in requirements)
		var/required_amount = requirements[required_path]
		var/available_amount = 0

		// Count available items that match this requirement
		for(var/path as anything in total_list)
			if(!ispath(path, required_path) || (path in all_blacklisted))
				continue
			if(!subtypes_allowed && (path in subtypesof(required_path)))
				continue
			available_amount += total_list[path]

		if(available_amount == 0)
			return 0 // Can't craft any if we're missing a required component

		var/holder_max_crafts = FLOOR(available_amount / required_amount, 1)
		max_crafts = min(max_crafts, holder_max_crafts)

	// Check reagent requirements
	if(length(reagent_requirements))
		var/list/reagent_values = gather_reagents(user)

		for(var/required_path as anything in reagent_requirements)
			var/required_amount = reagent_requirements[required_path]
			var/available_amount = 0

			// Count available reagents that match this requirement
			for(var/path in reagent_values)
				if(!ispath(path, required_path))
					continue
				if(!reagent_subtypes_allowed && (path in subtypesof(required_path)))
					continue
				available_amount += reagent_values[path]

			if(available_amount == 0)
				return 0 // Can't craft any if we're missing required reagents

			var/holder_max_crafts = FLOOR(available_amount / required_amount, 1)
			max_crafts = min(max_crafts, holder_max_crafts)

	return max_crafts

/**
 * Gathers usable contents from the user and surroundings
 *
 * @param {mob} user - The user attempting to craft
 * @param {list} usable_contents - List to populate with available items
 */
/datum/repeatable_crafting_recipe/proc/gather_usable_contents(mob/user, list/usable_contents)
	for(var/obj/item/I in user.held_items)
		if(istype(I, /obj/item/natural/bundle))
			var/bundle_path = I:stacktype
			usable_contents |= bundle_path
			usable_contents[bundle_path] += I:amount
		else
			usable_contents |= I.type
			usable_contents[I.type]++

	var/obj/item/inactive_hand = user.get_inactive_held_item()
	if(is_type_in_list(inactive_hand, offhand_repeat_check))
		for(var/obj/item/item in inactive_hand.contents)
			if(istype(item, /obj/item/natural/bundle))
				var/bundle_path = item:stacktype
				usable_contents |= bundle_path
				usable_contents[bundle_path] += item:amount
			else
				usable_contents |= item.type
				usable_contents[item.type]++

	if(check_around_owner)
		for(var/turf/listed_turf in range(1, user))
			for(var/obj/item/item in listed_turf.contents)
				if(istype(item, /obj/item/natural/bundle))
					var/bundle_path = item:stacktype
					usable_contents |= bundle_path
					usable_contents[bundle_path] += item:amount
				else
					usable_contents |= item.type
					usable_contents[item.type]++

/**
 * Gathers reagents from containers within reach
 *
 * @param {mob} user - The user attempting to craft
 * @return {list} - List of available reagents and their volumes
 */
/datum/repeatable_crafting_recipe/proc/gather_reagents(mob/user)
	var/list/reagent_values = list()

	collect_reagents_from_containers(user.held_items, reagent_values)

	if(check_around_owner)
		for(var/turf/listed_turf in range(1, user))
			collect_reagents_from_containers(listed_turf.contents, reagent_values)

	return reagent_values

/**
 * Collects reagents from containers in a list
 *
 * @param {list} items - List of items to check for reagents
 * @param {list} reagent_values - List to populate with reagent data
 */
/datum/repeatable_crafting_recipe/proc/collect_reagents_from_containers(list/items, list/reagent_values)
	for(var/obj/item/reagent_containers/container in items)
		for(var/datum/reagent/reagent as anything in container.reagents.reagent_list)
			reagent_values |= reagent.type
			reagent_values[reagent.type] += reagent.volume

/**
 * Converts a list of paths to a list of all their subtypes
 *
 * @param {list} paths - List of typepaths
 * @return {list} - List containing all typepaths and their subtypes
 */
/datum/repeatable_crafting_recipe/proc/typesof_list(list/paths)
	var/list/all_types = list()
	for(var/path in paths)
		all_types |= typesof(path)
	return all_types

/**
 * Processes a bundle item for crafting
 *
 * @param {obj/item/natural/bundle} item - The bundle to process
 * @param {mob} user - The user performing the crafting
 * @param {list} copied_requirements - Current requirements list
 * @param {list} to_delete - List of items marked for deletion
 * @param {list} all_blacklisted - List of blacklisted item types
 * @return {boolean} - TRUE if processing should stop, FALSE otherwise
 */
/datum/repeatable_crafting_recipe/proc/process_bundle(obj/item/natural/bundle/item, mob/user, list/copied_requirements, list/to_delete, list/all_blacklisted)
	var/early_ass_break = FALSE
	var/bundle_path = item:stacktype
	if(bundle_path in all_blacklisted)
		return early_ass_break

	for(var/path in copied_requirements)
		if(QDELETED(item))
			break
		if(!ispath(bundle_path, path))
			continue
		for(var/i = 1 to item:amount)
			if(QDELETED(item) || early_ass_break || !(bundle_path in copied_requirements))
				break

			item:amount--
			var/obj/item/sub_item = new bundle_path(get_turf(item))
			if(item:amount == 0)
				qdel(item)

			user.visible_message(span_info("[user] starts grabbing \a [sub_item] from [item]."),
								span_info("I start grabbing \a [sub_item] from [item]."))

			if(do_after(user, ground_use_time, sub_item, extra_checks = CALLBACK(user, TYPE_PROC_REF(/atom/movable, CanReach), sub_item)))
				if(put_items_in_hand)
					user.put_in_active_hand(sub_item)

				for(var/requirement in copied_requirements)
					if(!istype(sub_item, requirement))
						continue
					copied_requirements[requirement]--
					to_delete += sub_item
					sub_item.forceMove(locate(1,1,1))
					if(copied_requirements[requirement] <= 0)
						copied_requirements -= requirement
						early_ass_break = TRUE
						if(item && item:amount == 1) // to remove 1 count bundles
							new bundle_path(get_turf(item))
							qdel(item)
						break
	return early_ass_break

/**
 * Handles reagent requirements for crafting
 *
 * @param {list} copied_reagent_requirements - Current reagent requirements
 * @param {mob} user - The user performing the crafting
 * @return {boolean} - TRUE if successful, FALSE otherwise
 */
/datum/repeatable_crafting_recipe/proc/handle_reagent_requirements(list/copied_reagent_requirements, mob/user)
	var/obj/item/inactive_held = user.get_inactive_held_item()

	// First check storage
	for(var/obj/item/reagent_containers/container in get_storage_contents(user))
		if(!process_reagent_container(container, copied_reagent_requirements, user, inactive_held, TRUE))
			return FALSE

	// Then check general area
	for(var/obj/item/reagent_containers/container in get_usable_contents(user))
		var/turf/container_loc = get_turf(container)
		var/stored_pixel_x = container.pixel_x
		var/stored_pixel_y = container.pixel_y

		if(!process_reagent_container(container, copied_reagent_requirements, user, container_loc, FALSE, stored_pixel_x, stored_pixel_y))
			return FALSE

	return TRUE

/**
 * Processes a reagent container for crafting
 *
 * @param {obj/item/reagent_containers} container - The container to process
 * @param {list} copied_reagent_requirements - Current reagent requirements
 * @param {mob} user - The user performing the crafting
 * @param {atom} return_loc - Location to return container to
 * @param {boolean} is_storage - Whether the container is from storage
 * @param {number} stored_pixel_x - Original pixel_x of container
 * @param {number} stored_pixel_y - Original pixel_y of container
 * @return {boolean} - TRUE if successful, FALSE otherwise
 */
/datum/repeatable_crafting_recipe/proc/process_reagent_container(obj/item/reagent_containers/container, list/copied_reagent_requirements, mob/user, atom/return_loc, is_storage, stored_pixel_x = 0, stored_pixel_y = 0)
	for(var/required_path as anything in copied_reagent_requirements)
		var/list/reagent_paths = list(required_path)
		if(reagent_subtypes_allowed)
			reagent_paths |= subtypesof(required_path)

		for(var/possible_reagent_path in reagent_paths)
			if(!copied_reagent_requirements[required_path])
				break

			var/reagent_value = container.reagents.get_reagent_amount(possible_reagent_path)
			if(!reagent_value)
				continue

			user.visible_message(span_info("[user] starts to incorporate some liquid into [name]."),
								span_info("You start to pour some liquid into [name]."))

			if(put_items_in_hand)
				var/pickup_time = is_storage ? storage_use_time : ground_use_time
				if(!do_after(user, pickup_time, container, extra_checks = CALLBACK(user, TYPE_PROC_REF(/atom/movable, CanReach), container)))
					continue
				user.put_in_active_hand(container)

			if(istype(container, /obj/item/reagent_containers/glass/bottle))
				var/obj/item/reagent_containers/glass/bottle/bottle = container
				if(bottle.closed)
					bottle.rmb_self(user)

			var/reagent_use_time_real = max(reagent_use_time * 0.1, reagent_use_time / max(1, user.get_skill_level(skillcraft)))
			if(!do_after(user, reagent_use_time_real, container, extra_checks = CALLBACK(user, TYPE_PROC_REF(/atom/movable, CanReach), container)))
				continue

			playsound(get_turf(user), pick(container.poursounds), 100, TRUE)

			if(reagent_value < copied_reagent_requirements[required_path])
				container.reagents.remove_reagent(possible_reagent_path, reagent_value)
				copied_reagent_requirements[required_path] -= reagent_value
				break
			else
				container.reagents.remove_reagent(possible_reagent_path, copied_reagent_requirements[required_path])
				copied_reagent_requirements -= required_path

			if(put_items_in_hand)
				if(is_storage)
					SEND_SIGNAL(return_loc, COMSIG_TRY_STORAGE_INSERT, container, null, TRUE, TRUE)
				else
					user.transferItemToLoc(container, return_loc, TRUE)
					container.pixel_x = stored_pixel_x
					container.pixel_y = stored_pixel_y

	return TRUE

/**
 * Handles tool usage for crafting
 *
 * @param {list} copied_tool_usage - Current tool requirements
 * @param {mob} user - The user performing the crafting
 * @return {boolean} - TRUE if successful, FALSE otherwise
 */
/datum/repeatable_crafting_recipe/proc/handle_tool_usage(list/copied_tool_usage, mob/user)
	var/obj/item/inactive_held = user.get_inactive_held_item()

	// First check storage
	for(var/tool_path in copied_tool_usage)
		for(var/obj/item/potential_tool in get_storage_contents(user))
			if(!istype(potential_tool, tool_path))
				continue

			if(!process_tool(potential_tool, tool_path, copied_tool_usage, user, inactive_held, TRUE))
				return FALSE
			break

	// Then check general area
	for(var/tool_path in copied_tool_usage)
		for(var/obj/item/potential_tool in get_usable_contents(user))
			if(!istype(potential_tool, tool_path))
				continue

			var/turf/container_loc = get_turf(potential_tool)
			var/stored_pixel_x = potential_tool.pixel_x
			var/stored_pixel_y = potential_tool.pixel_y

			if(!process_tool(potential_tool, tool_path, copied_tool_usage, user, container_loc, FALSE, stored_pixel_x, stored_pixel_y))
				return FALSE
			break

	return TRUE

/**
 * Processes a tool for crafting
 *
 * @param {obj/item} potential_tool - The tool to process
 * @param {typepath} tool_path - The required tool typepath
 * @param {list} copied_tool_usage - Current tool requirements
 * @param {mob} user - The user performing the crafting
 * @param {atom} return_loc - Location to return tool to
 * @param {boolean} is_storage - Whether the tool is from storage
 * @param {number} stored_pixel_x - Original pixel_x of tool
 * @param {number} stored_pixel_y - Original pixel_y of tool
 * @return {boolean} - TRUE if successful, FALSE otherwise
 */
/datum/repeatable_crafting_recipe/proc/process_tool(obj/item/potential_tool, tool_path, list/copied_tool_usage, mob/user, atom/return_loc, is_storage, stored_pixel_x = 0, stored_pixel_y = 0)
	var/list/tool_path_extra = copied_tool_usage[tool_path]

	if(put_items_in_hand)
		var/pickup_time = is_storage ? storage_use_time : ground_use_time
		if(!do_after(user, pickup_time, potential_tool, extra_checks = CALLBACK(user, TYPE_PROC_REF(/atom/movable, CanReach), potential_tool)))
			return FALSE
		user.put_in_active_hand(potential_tool)

	user.visible_message(span_info("[user] [tool_path_extra[1]]."), span_info("You [tool_path_extra[2]]."))

	if(length(tool_path_extra) >= 3)
		playsound(get_turf(user), tool_path_extra[3], 100, FALSE)
	var/tool_use_time_real = max(tool_use_time * 0.1, tool_use_time / max(1, user.get_skill_level(skillcraft)))
	if(!do_after(user, tool_use_time_real, potential_tool, extra_checks = CALLBACK(user, TYPE_PROC_REF(/atom/movable, CanReach), potential_tool)))
		return FALSE

	copied_tool_usage -= tool_path

	if(put_items_in_hand)
		if(is_storage)
			SEND_SIGNAL(return_loc, COMSIG_TRY_STORAGE_INSERT, potential_tool, null, TRUE, TRUE)
		else
			user.transferItemToLoc(potential_tool, return_loc, TRUE)
			potential_tool.pixel_x = stored_pixel_x
			potential_tool.pixel_y = stored_pixel_y

	return TRUE

/**
 * Gets items from user's storage
 *
 * @param {mob} user - The user performing the crafting
 * @return {list} - List of items in storage
 */
/datum/repeatable_crafting_recipe/proc/get_storage_contents(mob/user)
	var/list/storage_contents = list()
	var/obj/item/inactive_hand = user.get_inactive_held_item()
	if(is_type_in_list(inactive_hand, offhand_repeat_check))
		for(var/obj/item/item in inactive_hand.contents)
			storage_contents |= item
	return storage_contents

/**
 * Gets items usable for crafting from user and surroundings
 *
 * @param {mob} user - The user performing the crafting
 * @return {list} - List of usable items
 */
/datum/repeatable_crafting_recipe/proc/get_usable_contents(mob/user)
	var/list/usable_contents = list()
	for(var/obj/item/I in user.held_items)
		usable_contents |= I

	if(check_around_owner)
		for(var/turf/listed_turf in range(1, user))
			for(var/obj/item/item in listed_turf.contents)
				usable_contents |= item

	return usable_contents

/**
 * Starts the crafting process
 *
 * @param {obj/item} attacked_item - The item being acted upon
 * @param {obj/item} attacking_item - The item the user is using to interact
 * @param {mob} user - The user attempting to craft
 * @return {boolean} - TRUE if successful, FALSE otherwise
 */
/datum/repeatable_crafting_recipe/proc/start_recipe(obj/item/attacked_item, obj/item/attacking_item, mob/user)
	var/max_crafts = check_max_repeats(attacked_item, attacking_item, user)
	var/requested_crafts = 1
	var/successful_crafts = 0

	if(max_crafts > 1)
		requested_crafts = input(user, "How many [name] do you want to craft?", "Repeat Option", max_crafts) as null|num

	if(!requested_crafts)
		return

	requested_crafts = CLAMP(requested_crafts, 1, max_crafts)

	if((!istype(attacked_item, attacked_atom) && !istype(attacked_item, /obj/item/natural/bundle)) || (istype(attacked_item, /obj/item/natural/bundle) && !ispath(attacked_item:stacktype, attacked_atom)))
		return FALSE

	var/list/all_blacklisted = typesof_list(blacklisted_paths)
	var/attempts = 0
	var/max_attempts = requested_crafts * 20 // Safety to prevent infinite loops

	while(successful_crafts < requested_crafts && attempts < max_attempts)
		attempts++

		var/list/usable_contents = get_usable_contents(user)
		var/list/storage_contents = get_storage_contents(user)

		var/list/copied_requirements = requirements.Copy()
		var/list/copied_reagent_requirements = reagent_requirements.Copy()
		var/list/copied_tool_usage = tool_usage.Copy()
		var/list/to_delete = list()

		var/obj/item/active_item = user.get_active_held_item()

		if(put_items_in_hand && !is_type_in_list(active_item, requirements))
			handle_active_item_placement(active_item, user)

		// Process items from usable contents
		var/crafting_success = TRUE
		for(var/obj/item/item in usable_contents)
			if(!length(copied_requirements))
				break

			if((!is_type_in_list(item, copied_requirements) && !istype(item, /obj/item/natural/bundle)) || (item.type in all_blacklisted))
				continue

			if(istype(item, /obj/item/natural/bundle))
				if(process_bundle(item, user, copied_requirements, to_delete, all_blacklisted))
					break
				continue

			user.visible_message(span_info("[user] starts picking up [item]."), span_info("I start picking up [item]."))

			if(do_after(user, ground_use_time, item, extra_checks = CALLBACK(user, TYPE_PROC_REF(/atom/movable, CanReach), item)))
				if(put_items_in_hand)
					user.put_in_active_hand(item)

				for(var/requirement in copied_requirements)
					if(!istype(item, requirement))
						continue
					copied_requirements[requirement]--
					if(copied_requirements[requirement] <= 0)
						copied_requirements -= requirement
					usable_contents -= item
					to_delete += item
					item.forceMove(locate(1,1,1))
			else
				crafting_success = FALSE
				break

		// Process items from storage
		if(crafting_success && length(copied_requirements))
			for(var/obj/item/item in storage_contents)
				if(!length(copied_requirements))
					break

				if(!is_type_in_list(item, copied_requirements) || (item.type in all_blacklisted))
					continue

				to_chat(user, "You start grabbing [item] from your bag.")

				if(do_after(user, storage_use_time, item))
					SEND_SIGNAL(item.loc, COMSIG_TRY_STORAGE_TAKE, item, user.loc, TRUE)

					if(put_items_in_hand)
						user.put_in_active_hand(item)

					for(var/requirement in copied_requirements)
						if(!istype(item, requirement))
							continue
						copied_requirements[requirement]--
						if(copied_requirements[requirement] <= 0)
							copied_requirements -= requirement
						storage_contents -= item
						to_delete += item
						item.forceMove(locate(1,1,1))
				else
					crafting_success = FALSE
					break

		// Process reagents
		if(crafting_success && length(copied_reagent_requirements))
			crafting_success = handle_reagent_requirements(copied_reagent_requirements, user)

		// Process tools
		if(crafting_success && length(copied_tool_usage))
			crafting_success = handle_tool_usage(copied_tool_usage, user)

		// Complete crafting if all requirements met
		if(crafting_success && !length(copied_requirements) && !length(copied_reagent_requirements) && !length(copied_tool_usage))
			if(complete_crafting(to_delete, user))
				successful_crafts++
				// Let the user know about progress
				to_chat(user, span_notice("Successfully crafted \a [name]. ([successful_crafts]/[requested_crafts])"))
				continue

		// Move items back if failed
		move_items_back(to_delete, user)

		// If we failed at some point in the process, ask if they want to continue trying
		if(!crafting_success && successful_crafts < requested_crafts)
			var/continue_crafting = alert(user, "Crafting failed. Continue attempting to craft [requested_crafts - successful_crafts] more [name]?", "Continue Crafting?", "Yes", "No")
			if(continue_crafting != "Yes")
				break

		// After each successful or failed craft, give the user a moment to react
		sleep(0.5 SECONDS)

	// Final completion message
	if(successful_crafts > 0)
		to_chat(user, span_notice("Finished crafting [successful_crafts] [name][successful_crafts > 1 ? "s" : ""]."))
	else
		to_chat(user, span_warning("Failed to craft any [name]."))

	return TRUE

/**
 * Handles placing active item somewhere safe
 *
 * @param {obj/item} active_item - Item currently in active hand
 * @param {mob} user - The user performing the crafting
 */
/datum/repeatable_crafting_recipe/proc/handle_active_item_placement(obj/item/active_item, mob/user)
	if(!active_item)
		return

	for(var/obj/structure/table/table in range(1, user))
		user.transferItemToLoc(active_item, get_turf(table), TRUE)
		return

	user.transferItemToLoc(active_item, get_turf(user), TRUE)

/**
 * Completes the crafting process
 *
 * @param {list} to_delete - List of items to consume
 * @param {mob} user - The user performing the crafting
 * @return {boolean} - TRUE if successful, FALSE otherwise
 */
/datum/repeatable_crafting_recipe/proc/complete_crafting(list/to_delete, mob/user)
	if(crafting_message)
		user.visible_message(span_info("[user] [crafting_message]."), span_info("I [crafting_message]."))

	if(crafting_sound)
		playsound(user, crafting_sound, sound_volume, TRUE, -1)
	if(crafting_message)
		to_chat(user, span_notice(crafting_message))
	var/crafting_time = max(craft_time * 0.1, craft_time / max(1, user.get_skill_level(skillcraft)))
	if(!do_after(user, crafting_time))
		return FALSE

	var/prob2craft = calculate_craft_chance(user)
	var/prob2fail = calculate_fail_chance(user)

	if(prob2craft < 1)
		to_chat(user, "<span class='danger'>I lack the skills for this...</span>")
		move_products(list(), user)
		move_items_back(to_delete, user)
		return FALSE

	if(prob(prob2fail))
		to_chat(user, "<span class='danger'>MISTAKE! I've completely fumbled the crafting of \the [name]!</span>")
		move_items_back(to_delete, user)
		return FALSE

	if(!prob(prob2craft))
		if(user.client?.prefs.showrolls)
			to_chat(user, "<span class='danger'>I've failed to craft \the [name]. (Success chance: [prob2craft]%)</span>")
		else
			to_chat(user, "<span class='danger'>I've failed to craft \the [name].</span>")
		move_items_back(to_delete, user)
		return FALSE

	var/list/outputs = create_outputs(to_delete, user)

	clean_up_items(to_delete)

	add_skill_experience(user)

	move_products(outputs, user)

	return TRUE

/**
 * Calculates chance of successful crafting
 *
 * @param {mob} user - The user performing the crafting
 * @return {number} - Percentage chance of success
 */
/datum/repeatable_crafting_recipe/proc/calculate_craft_chance(mob/user)
	var/prob2craft = 25

	if(craftdiff)
		prob2craft -= (25 * craftdiff)

	if(skillcraft)
		if(user.mind)
			prob2craft += (user.get_skill_level(skillcraft) * 25)
	else
		prob2craft = 100

	prob2craft += extra_chance

	if(isliving(user))
		var/mob/living/L = user
		if(L.STAINT > 10)
			prob2craft += ((10-L.STAINT)*-1)*2

	return CLAMP(prob2craft, 5, 99)

/**
 * Calculates chance of failing crafting
 *
 * @param {mob} user - The user performing the crafting
 * @return {number} - Percentage chance of success
 */
/datum/repeatable_crafting_recipe/proc/calculate_fail_chance(mob/user)
	var/prob2fail = 1

	if(isliving(user))
		var/mob/living/L = user
		if(L.STALUC > 10)
			prob2fail = 0
		if(L.STALUC < 10)
			prob2fail += (10-L.STALUC)

	return prob2fail

/**
 * Creates the output items
 *
 * @param {list} to_delete - List of items to delete
 * @param {mob} user - The user performing the crafting
 * @return {list} - created outputs
 */
/datum/repeatable_crafting_recipe/proc/create_outputs(list/to_delete, mob/user)
	var/list/outputs = list()

	for(var/spawn_count = 1 to output_amount)
		var/obj/item/new_item = new output(get_turf(user))

		new_item.sellprice = sellprice
		new_item.randomize_price()

		if(length(pass_types_in_end))
			var/list/parts = list()
			for(var/obj/item/listed as anything in to_delete)
				if(!is_type_in_list(listed, pass_types_in_end))
					continue
				parts += listed
			new_item.CheckParts(parts)

		new_item.OnCrafted(user.dir, user)

		outputs += new_item

	return outputs

/datum/repeatable_crafting_recipe/proc/clean_up_items(list/to_delete)
	for(var/obj/item/deleted in to_delete)
		to_delete -= deleted
		var/datum/component/storage/STR = deleted.GetComponent(/datum/component/storage)
		if(STR)
			var/list/things = STR.contents()
			for(var/obj/item/I in things)
				STR.remove_from_storage(I, get_turf(src))
		qdel(deleted)

/datum/repeatable_crafting_recipe/proc/add_skill_experience(mob/user)
	if(!user.mind || !skillcraft || !isliving(user))
		return

	var/mob/living/L = user
	var/amt2raise = L.STAINT * 2

	if(craftdiff > 0)
		amt2raise += (craftdiff * 10)

	if(amt2raise > 0)
		user.mind.add_sleep_experience(skillcraft, amt2raise, FALSE)

/datum/repeatable_crafting_recipe/proc/move_items_back(list/items, mob/user)
	for(var/obj/item/item in items)
		var/early_continue = FALSE
		for(var/obj/structure/table/table in range(1, user))
			item.forceMove(get_turf(table))
			early_continue = TRUE
			break
		if(!early_continue)
			item.forceMove(user.drop_location())
	user.update_inv_hands()

/datum/repeatable_crafting_recipe/proc/move_products(list/products, mob/user)
	var/list/copied_tool_usage = tool_usage.Copy()

	for(var/turf/listed_turf in range(1, user))
		for(var/obj/item in listed_turf.contents)
			for(var/tool in copied_tool_usage)
				if(istype(item, tool))
					copied_tool_usage -= tool
					user.put_in_hands(item)
					break

	if(length(products))
		var/list/items_to_put
		for(var/obj/item/item in products)
			LAZYADD(items_to_put, item)
		if(LAZYLEN(items_to_put))
			user.put_in_hands(pick(items_to_put))

/datum/repeatable_crafting_recipe/proc/generate_html(mob/user)
	var/client/client = user
	if(!istype(client))
		client = user.client
	SSassets.transport.send_assets(client, list("try4_border.png", "try4.png", "slop_menustyle2.css"))
	user << browse_rsc('html/book.png')
	var/html = {"
		<!DOCTYPE html>
		<html lang="en">
		<meta charset='UTF-8'>
		<meta http-equiv='X-UA-Compatible' content='IE=edge,chrome=1'/>
		<meta http-equiv='Content-Type' content='text/html; charset=UTF-8'/>

		<style>
			@import url('https://fonts.googleapis.com/css2?family=Charm:wght@700&display=swap');
			body {
				font-family: "Charm", cursive;
				font-size: 1.2em;
				text-align: center;
				margin: 20px;
				background-color: #f4efe6;
				color: #3e2723;
				background-color: rgb(31, 20, 24);
				background:
					url('[SSassets.transport.get_asset_url("try4_border.png")]'),
					url('book.png');
				background-repeat: no-repeat;
				background-attachment: fixed;
				background-size: 100% 100%;

			}
			h1 {
				text-align: center;
				font-size: 2em;
				border-bottom: 2px solid #3e2723;
				padding-bottom: 10px;
				margin-bottom: 10px;
			}
			.icon {
				width: 64px;
				height: 64px;
				vertical-align: middle;
				margin-right: 10px;
			}
		</style>
		<body>
		  <div>
		    <h1>[name]</h1>
		    <div>
		      <h2>Requirements</h2>
		"}
	for(var/atom/path as anything in requirements)
		var/count = requirements[path]
		if(subtypes_allowed)
			html += "[icon2html(new path, user)] [count] of any [initial(path.name)]<br>"
		else
			html += "[icon2html(new path, user)] [count] [initial(path.name)]<br>"

	html += {"
		</div>
		<div>
		"}

	if(length(tool_usage))
		html += {"
		<br>
		<div>
		    <strong>Required Tools</strong>
			<br>
			  "}
		for(var/atom/path as anything in tool_usage)
			if(subtypes_allowed)
				html += "[icon2html(new path, user)] any [initial(path.name)]<br>"
			else
				html += "[icon2html(new path, user)] [initial(path.name)]<br>"
		html += {"
			</div>
		<div>
		"}

	if(length(reagent_requirements))
		html += {"
		<br>
		<div>
		    <strong>Required Liquids</strong>
			<br>
			  "}
		for(var/atom/path as anything in reagent_requirements)
			var/count = reagent_requirements[path]
			html += "[CEILING(count / 3, 1)] oz of [initial(path.name)]<br>"
		html += {"
			</div>
		<div>
		"}

	html += "<h1>Steps</h1><br>"
	if(subtypes_allowed)
		html += " [icon2html(new starting_atom, user)] <strong class=class='scroll'>start the process by using any [initial(starting_atom.name)] </strong><br>"
	else
		html += "[icon2html(new starting_atom, user)] <strong class=class='scroll'>start the process by using [initial(starting_atom.name)] </strong><br>"

	html += "[icon2html(new attacked_atom, user)] <strong class=class='scroll'>on [initial(attacked_atom.name)]</strong><br>"

	html += {"
		</div>
		</div>
	</body>
	</html>
	"}
	return html

/datum/repeatable_crafting_recipe/proc/show_menu(mob/user)
	user << browse(generate_html(user),"window=recipe;size=500x810")
