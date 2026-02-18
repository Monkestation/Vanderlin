/datum/slapcraft_step
	abstract_type = /datum/slapcraft_step
	/// The description of the step, it shows in the slapcraft handbook
	var/desc
	/// The description of the finished step when you examine the assembly.
	var/finished_desc
	/// The description of the step when it's the next one to perform in the assembly.
	var/todo_desc

	/// Quantified description of the required element of this step. "screwdriver" or "15 cable", or "can with 50u. fuel" etc.
	var/list_desc

	/// Visible message when you finish the step.
	var/finish_msg
	/// Visible message when you start the step.
	var/start_msg
	/// Personalized visible message when you finish the step.
	var/finish_msg_self
	/// Personalized visible message when you start the step.
	var/start_msg_self

	/// If the user is holding the item, check if they need to be able to drop it to be able to craft with it.
	var/check_if_mob_can_drop_item = TRUE
	/// Whether we insert the valid item in the assembly.
	var/insert_item = TRUE
	/// Whether we insert the item into the resulting item's contents
	var/insert_item_into_result = FALSE
	///the required skill type needed for this
	var/datum/skill/skill_type
	/// How long does it take to perform the step.
	var/perform_time = 2 SECONDS
	/// Whether we should check the types of the item, if FALSE then make sure `can_perform()` checks conditions.
	var/check_types = TRUE
	/// List of types of items that can be used. Only relevant if `check_types` is TRUE
	var/list/item_types
	/// The typecache of types of the items.
	var/list/typecache
	/// Item types to make a typecache of for blacklisting.
	var/list/blacklist_item_types
	/// Typecache of the blacklist
	var/list/blacklist_typecache
	/// The recipe this step can link to. Make sure to include %LINK% and %ENDLINK% in `desc` to properly linkify it.
	var/recipe_link
	/// Whether this step is optional. This is forbidden for first and last steps of recipes, and cannot be used on recipes with an order of SLAP_ORDER_FIRST_THEN_FREEFORM
	var/optional = FALSE
	var/start_verb = "to"

/datum/slapcraft_step/New()
	. = ..()
	if(check_types)
		if(!item_types || !length(item_types))
			CRASH("Slapcraft step of type [type] wants to check types but is missing `item_types`")
		typecache = typecacheof(item_types)
		if(blacklist_item_types)
			blacklist_typecache = typecacheof(blacklist_item_types)
	if(!list_desc)
		list_desc = make_list_desc()
	if(!desc)
		desc = make_desc()
	if(!todo_desc)
		todo_desc = make_todo_desc()
	if(!finished_desc)
		finished_desc = make_finished_desc()

	if(!finish_msg)
		finish_msg = make_finish_msg()
	if(!start_msg && perform_time)
		start_msg = make_start_msg()
	if(!finish_msg_self)
		finish_msg_self = make_finish_msg_self()
	if(!start_msg_self && perform_time)
		start_msg_self = make_start_msg_self()

/// Checks whether a type is in the typecache of the step.
/datum/slapcraft_step/proc/check_type(checked_type)
	if(!typecache)
		CRASH("Slapcraft step [type] tried to check a type without a typecache!")
	if(typecache[checked_type])
		if(blacklist_typecache?[checked_type])
			return FALSE
		return TRUE

	return FALSE

/// Checks if the passed item is a proper type to perform this step, and whether it passes the `can_perform()` check. Assembly can be null
/datum/slapcraft_step/proc/perform_check(
		mob/living/user,
		obj/item/item,
		obj/item/slapcraft_assembly/assembly,
		check_type_only,
		error_list = list()
	)

	if(check_types && !check_type(item.type))
		return FALSE

	if(!can_perform(user, item, assembly, error_list))
		if(check_types && check_type_only)
			return TRUE
		return FALSE

	//Check if we finish the assembly, and whether that's possible
	if(assembly)
		// If would be finished, but can't be
		if(assembly.recipe.is_finished(assembly.step_states, type) && !assembly.recipe.can_finish(user, assembly))
			return FALSE
	return TRUE

/// Make a user perform this step, by using an item on the assembly, trying to progress the assembly.
/datum/slapcraft_step/proc/perform(mob/living/user, obj/item/item, obj/item/slapcraft_assembly/assembly, instant = FALSE, silent = FALSE, list/error_list = list(), minimum_perform_time)
	if(!perform_check(user, item, assembly, error_list = error_list) || !assembly.recipe.check_correct_step(type, assembly.step_states))
		return FALSE

	if(perform_time && !instant)
		if(!silent)
			user.visible_message(
				span_small(step_replace_text(start_msg, user, item, assembly)),
				span_small(step_replace_text(start_msg_self, user, item, assembly))
				)
		if(!perform_do_after(user, item, assembly, max(perform_time * get_speed_multiplier(user, item, assembly), minimum_perform_time)))
			return FALSE

		// Do checks again because we spent time in a do_after(), this time also check deletions.
		if(QDELETED(assembly) || QDELETED(item) || !perform_check(user, item, assembly) || !assembly.recipe.check_correct_step(type, assembly.step_states))
			return FALSE

	if(!silent)
		user.visible_message(
			span_small(step_replace_text(finish_msg, user, item, assembly)),
			span_small(step_replace_text(finish_msg_self, user, item, assembly))
		)

	if(!silent)
		play_perform_sound(user, item, assembly)

	on_perform(user, item, assembly)

	if(insert_item)
		move_item_to_assembly(user, item, assembly)

	if(progress_crafting(user, item, assembly))
		assembly.finished_step(user, src, item)
	return TRUE

/// Text replacing for sending visibile messages when the steps are happening.
/datum/slapcraft_step/proc/step_replace_text(msg, mob/living/user, obj/item/item, obj/item/slapcraft_assembly/assembly)
	msg = replacetext(msg,"%USER%","[user]")
	msg = replacetext(msg,"%ITEM%","\improper [item]")
	msg = replacetext(msg,"%TARGET%","\improper \the [assembly]")
	return msg

/// Below are virtual procs I allow steps to override for their specific behaviours.

/// Checks whether a user can perform this step with an item. Exists so steps can override this proc for their own behavioural checks.
/// `assembly` can be null here, when the recipe finding checks are trying to figure out what recipe we can make.
/datum/slapcraft_step/proc/can_perform(mob/living/user, obj/item/item, obj/item/slapcraft_assembly/assembly, list/error_list = list())
	SHOULD_CALL_PARENT(TRUE)
	. = TRUE
	// Check if the mob can actually remove the item from their inventory
	if(check_if_mob_can_drop_item && (item.item_flags & IN_INVENTORY) && !user.canUnEquip(item))
		error_list += "I cannot drop [item]."
		. = FALSE

/// Behaviour to happen on performing this step. Perhaps removing a portion of reagents to create an IED or something.
/datum/slapcraft_step/proc/on_perform(mob/living/user, obj/item/item, obj/item/slapcraft_assembly/assembly)
	return

/// Behaviour to move the item into the assembly. Stackable items may want to change how they do this.
/datum/slapcraft_step/proc/move_item_to_assembly(mob/living/user, obj/item/item, obj/item/slapcraft_assembly/assembly)
	user.transferItemToLoc(item, assembly, TRUE, TRUE)
	if(insert_item_into_result)
		assembly.items_to_place_in_result += item

/// Whether the step progresses towards the next step when successfully performed.
/// This can be used to allow "freeform" crafting to put more things into an assembly than required, possibly utilizing it for things like custom burgers
/datum/slapcraft_step/proc/progress_crafting(mob/living/user, obj/item/item, obj/item/slapcraft_assembly/assembly)
	return TRUE

/// Returns a speed multiplier to the time it takes for the step to complete. Useful for tool-related steps
/datum/slapcraft_step/proc/get_speed_multiplier(mob/living/user, obj/item/item, obj/item/slapcraft_assembly/assembly)
	return 1

/// Proc to perform handling a do_after, return FALSE if it failed, TRUE if succeeded.
/datum/slapcraft_step/proc/perform_do_after(mob/living/user, obj/item/item, obj/item/slapcraft_assembly/assembly, time_to_do)
	if(skill_type)
		time_to_do *=  (2 / max(1, user.get_skill_level(skill_type, TRUE)))

	if(HAS_TRAIT(user, TRAIT_QUICK_HANDS))
		time_to_do *= 0.9

	if(!do_after(user, time_to_do, item))
		return FALSE
	return TRUE

/// Plays a sound on successfully performing the step.
/datum/slapcraft_step/proc/play_perform_sound(mob/living/user, obj/item/item, obj/item/slapcraft_assembly/assembly)
	if(!insert_item || !item.drop_sound)
		return
	playsound(assembly, item.drop_sound, DROP_SOUND_VOLUME, ignore_walls = FALSE)

// Procs to generate strings for description steps.
/// Makes a description for the step.
/datum/slapcraft_step/proc/make_desc()
	if(insert_item)
		return "Insert a [list_desc] into the assembly."
	else
		return "Use a [list_desc] on the assembly"

/// Makes a finished description for the step.
/datum/slapcraft_step/proc/make_finished_desc()
	if(insert_item)
		return "\The [list_desc] has been inserted."
	else
		return "\The [list_desc] has been applied."

/// Makes a todo description for the step.
/datum/slapcraft_step/proc/make_todo_desc()
	if(insert_item)
		return "You need to add \a [list_desc] into the assembly."
	else
		return "You need to use \a [list_desc] on the assembly."

/// Makes a list description for the item.
/datum/slapcraft_step/proc/make_list_desc()
	// By default if we check types just grab the first type in the list and use that to describe the step.
	if(check_types)
		var/obj/item/first_path_cast = item_types[1]
		return initial(first_path_cast.name)

/// Makes a description for the visible message of finishing a step.
/datum/slapcraft_step/proc/make_finish_msg()
	if(insert_item)
		return "%USER% inserts %ITEM% into %TARGET%."
	else
		return "%USER% uses %ITEM% on %TARGET%."

/// Makes a description for the visible message of starting a step that requires some time to perform.
/datum/slapcraft_step/proc/make_start_msg()
	if(insert_item)
		return "%USER% begins inserting %ITEM% into %TARGET%."
	else
		return "%USER% begins using %ITEM% on %TARGET%."

/// Makes a personalized description for the visible message of finishing a step.
/datum/slapcraft_step/proc/make_finish_msg_self()
	if(insert_item)
		return "You insert %ITEM% into %TARGET%."
	else
		return "You use %ITEM% on %TARGET%."

/// Makes a personalized description for the visible message of starting a step that requires some time to perform.
/datum/slapcraft_step/proc/make_start_msg_self()
	if(insert_item)
		return "You begin inserting %ITEM% into %TARGET%."
	else
		return "You begin using %ITEM% on %TARGET%."
