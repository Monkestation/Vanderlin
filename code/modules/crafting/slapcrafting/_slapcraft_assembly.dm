/obj/item/slapcraft_assembly
	name = "slapcraft assembly"
	w_class = WEIGHT_CLASS_NORMAL
	/// Recipe this assembly is trying to make
	var/datum/slapcraft_recipe/recipe
	/// Associative list of whether the steps are finished or not
	var/list/step_states
	/// Whether it's in the process of being disassembled.
	var/disassembling = FALSE
	/// Whether it's in the process of being finished.
	var/being_finished = FALSE
	/// All items that want to place itself in the resulting item after the recipe is finished.
	var/list/items_to_place_in_result = list()

	///A list of weakrefs to finished items (not including items-in-items), used to move items around after they're complete and this object is qdeling.
	var/list/datum/weakref/finished_items = list()

/obj/item/slapcraft_assembly/examine(mob/user)
	. = ..()
	// Describe the steps that already have been performed on the assembly
	for(var/step_path in recipe.steps)
		if(step_states[step_path])
			var/datum/slapcraft_step/done_step = SLAPCRAFT_STEP(step_path)
			. += span_notice(done_step.finished_desc)
	// Describe how the next steps could be performed
	var/list/next_steps = recipe.get_possible_next_steps(step_states)
	for(var/step_type in next_steps)
		var/datum/slapcraft_step/next_step = SLAPCRAFT_STEP(step_type)
		. += span_boldnotice(next_step.todo_desc)
	// And tell them if it can be disassembled back into the components aswell.
	if(recipe.can_disassemble)
		. += span_boldnotice("Right click to disassemble this back into components.")

/obj/item/slapcraft_assembly/attackby(obj/item/item, mob/user, list/modifiers)
	// Get the next step
	var/datum/slapcraft_step/next_step = recipe.next_suitable_step(user, item, step_states)
	if(!next_step)
		return ..()
	// Try and do it
	next_step.perform(user, item, src)
	return TRUE

/obj/item/slapcraft_assembly/update_overlays()
	. = ..()
	/// Add the appearance of all the components that the assembly is being made with.
	for(var/obj/item/component as anything in contents)
		var/mutable_appearance/component_overlay = mutable_appearance(component.icon, component.icon_state)
		component_overlay.pixel_x = component.pixel_x
		component_overlay.pixel_y = component.pixel_y
		component_overlay.overlays = component.overlays
		. += component_overlay

/obj/item/slapcraft_assembly/attack_hand_secondary(mob/user, list/modifiers)
	. = ..()
	if(. == SECONDARY_ATTACK_CANCEL_ATTACK_CHAIN)
		return
	if(recipe.can_disassemble)
		to_chat(user, span_notice("You take apart \the [src]."))
		disassemble()
	else
		to_chat(user, span_warning("You can't take this apart!"))
	return SECONDARY_ATTACK_CANCEL_ATTACK_CHAIN

// Something in the assembly got deleted. Perhaps burned, melted or otherwise.
/obj/item/slapcraft_assembly/handle_atom_del(atom/deleted_atom)
	disassemble()

// Most likely something gets teleported out of the assembly, or pulled out by other means
/obj/item/slapcraft_assembly/Exited(atom/movable/gone, direction)
	. = ..()
	items_to_place_in_result -= gone
	disassemble()

/obj/item/slapcraft_assembly/Entered(atom/movable/arrived, direction)
	. = ..()
	update_appearance(UPDATE_OVERLAYS)

/obj/item/slapcraft_assembly/Destroy(force)
	disassembling = TRUE
	for(var/obj/item/component as anything in contents)
		if(QDELETED(component))
			continue
		qdel(component)
	return ..()

/// Disassembles the assembly, either qdeling it if its in nullspace, or dumping all of its components on the ground and then qdeling it.
/obj/item/slapcraft_assembly/proc/disassemble(force = FALSE)
	if((disassembling || being_finished) && !force)
		return

	disassembling = TRUE

	var/atom/dump_loc = drop_location()

	if(!dump_loc)
		qdel(src)
		return

	var/mob/living/holder
	if(ismob(loc))
		holder = loc
		if(!holder.is_holding(src))
			holder = null

	moveToNullspace()

	if(length(contents) <= 2 && holder)
		for(var/obj/item/component as anything in contents)
			// Handle atom del causing the assembly to disassemble, don't touch the deleted atom
			if(QDELETED(component))
				continue

			if(!holder.put_in_hands(component))
				component.forceMove(dump_loc)
	else
		for(var/obj/item/component as anything in contents)
			// Handle atom del causing the assembly to disassemble, don't touch the deleted atom
			if(QDELETED(component))
				continue
			component.forceMove(dump_loc)

	qdel(src)

/// Progresses the assembly to the next step and finishes it if made it through the last step.
/obj/item/slapcraft_assembly/proc/finished_step(mob/living/user, datum/slapcraft_step/step_datum, obj/item/last_item)
	// Mark the step as finished.
	step_states[step_datum.type] = TRUE

	if(recipe.is_finished(step_states))
		if(!recipe.check_craft_requirements(user, recipe.get_result_location(src, user)))
			to_chat(user, "<span class='warning'>I can't craft here.</span>")
			step_states[step_datum.type] = FALSE
			return
		recipe.finish_recipe(user, src, step_datum.type, last_item)

/// Sets the recipe of this assembly aswell making the name and description matching.
/obj/item/slapcraft_assembly/proc/set_recipe(datum/slapcraft_recipe/set_recipe)
	recipe = set_recipe
	w_class = recipe.assembly_weight_class
	if(recipe.anchor_craft)
		anchored = TRUE
	density = recipe.dense_assembly
	name = "[set_recipe.assembly_name_prefix] [set_recipe.name]"
	desc = "This seems to be a work in progress [set_recipe.name]"

	// Set step states for this recipe.
	step_states = list()
	for(var/step_path in set_recipe.steps)
		step_states[step_path] = FALSE
