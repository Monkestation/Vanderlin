/obj/machinery/essence/infuser
	name = "essence infuser"
	desc = "Saturates a placed item with alchemical essences to transform it."
	icon = 'icons/roguetown/misc/splitter.dmi'
	icon_state = "splitter"
	network_priority = 4

	var/obj/item/infusion_target = null
	var/datum/infusion_recipe/current_recipe = null
	var/infusing = FALSE
	var/completion_time = 10 SECONDS

/obj/machinery/essence/infuser/Initialize()
	. = ..()
	storage.max_total = 300
	storage.max_types = 10

/obj/machinery/essence/infuser/Destroy()
	STOP_PROCESSING(SSobj, src)
	deltimer(CALLBACK(src, PROC_REF(complete_infusion)))
	if(infusion_target)
		infusion_target.forceMove(get_turf(src))
	if(current_recipe)
		qdel(current_recipe)
	return ..()

/obj/machinery/essence/infuser/build_allowed_types()
	if(!current_recipe || infusing)
		return list()
	var/list/result = list()
	for(var/etype in current_recipe.required_essences)
		var/deficit = current_recipe.required_essences[etype] - storage.get(etype)
		if(deficit > 0)
			result[etype] = deficit
	return result

/obj/machinery/essence/infuser/push_to_linked(datum/essence_storage/from_storage)
	push_surplus_to_linked(from_storage)

// Called each tick only while waiting for essences
/obj/machinery/essence/infuser/process()
	pull_from_linked(storage)
	if(recipe_ready())
		STOP_PROCESSING(SSobj, src)

// Storage changed hook — check if we just received the last essence we needed
/obj/machinery/essence/infuser/on_storage_changed(essence_type, amount, added)
	..()
	if(!added || infusing)
		return
	if(recipe_ready())
		STOP_PROCESSING(SSobj, src)

/obj/machinery/essence/infuser/proc/recipe_ready()
	if(!current_recipe || !infusion_target)
		return FALSE
	for(var/etype in current_recipe.required_essences)
		if(storage.get(etype) < current_recipe.required_essences[etype])
			return FALSE
	return TRUE

/obj/machinery/essence/infuser/proc/begin_infusion(mob/living/user)
	infusing = TRUE
	STOP_PROCESSING(SSobj, src) // No more pulling while infusing
	if(network)
		network.invalidate_cache() // Stop the network routing more essence here

	var/speed = GLOB.thaumic_research.get_research_bonus(/datum/thaumic_research_node/transmutation)
	var/adjusted_time = completion_time / speed

	user.visible_message(span_info("[user] begins the infusion on [infusion_target]."))
	update_appearance(UPDATE_OVERLAYS)

	// Spark effect timer loop
	addtimer(CALLBACK(src, PROC_REF(infusion_spark)), 1 SECONDS, TIMER_LOOP | TIMER_DELETE_ME)
	addtimer(CALLBACK(src, PROC_REF(complete_infusion)), adjusted_time)

/obj/machinery/essence/infuser/proc/infusion_spark()
	if(!infusing)
		return TIMER_DELETE_ME // Stop looping spark once done
	if(prob(50))
		var/datum/effect_system/spark_spread/sparks = new
		sparks.set_up(2, 1, src)
		sparks.start()

/obj/machinery/essence/infuser/proc/complete_infusion()
	if(!infusing) // Guard against double-fire
		return
	infusing = FALSE

	for(var/etype in current_recipe.required_essences)
		storage.remove(etype, current_recipe.required_essences[etype])

	var/atom/new_atom = new current_recipe.result_type(get_turf(src))
	if(istype(infusion_target,/obj/item/essence_node_jar))
		var/obj/item/essence_node_jar/old_jar = infusion_target
		var/obj/item/essence_node_jar/new_jar = new_atom
		if(old_jar.contained_node)
			new_jar.contained_node = old_jar.contained_node
			new_jar.contained_node.forceMove(new_jar)
			old_jar.contained_node = null
			new_jar.update_appearance()

	qdel(infusion_target)
	infusion_target = null

	qdel(current_recipe)
	current_recipe = null

	update_appearance(UPDATE_OVERLAYS)
	visible_message(span_notice("[src] chimes as the infusion completes!"))

/obj/machinery/essence/infuser/attack_hand(mob/living/user)
	if(infusing)
		to_chat(user, span_warning("[src] is currently infusing."))
		return
	if(!infusion_target)
		to_chat(user, span_info("Place an item on [src] first."))
		return
	if(!current_recipe)
		show_recipe_selection(user)
		return
	if(!recipe_ready())
		show_recipe_progress(user)
		return
	begin_infusion(user)

/obj/machinery/essence/infuser/proc/show_recipe_selection(mob/user)
	var/list/opts = list()
	var/list/mapping = list()
	for(var/rpath in subtypesof(/datum/infusion_recipe))
		var/datum/infusion_recipe/r = new rpath
		opts[r.name] = rpath
		mapping[rpath] = r
	if(!opts.len)
		to_chat(user, span_warning("No infusion recipes available."))
		for(var/rpath in mapping)
			qdel(mapping[rpath])
		return
	var/choice = input(user, "Select recipe", "Infusion Recipes") as null|anything in opts
	if(!choice)
		for(var/rpath in mapping)
			qdel(mapping[rpath])
		return
	if(current_recipe)
		qdel(current_recipe)
	current_recipe = mapping[opts[choice]]
	for(var/rpath in mapping)
		if(mapping[rpath] != current_recipe)
			qdel(mapping[rpath])
	if(network)
		network.invalidate_cache()
	push_surplus_to_linked(storage)
	// Start polling for essences if we don't already have them
	if(!recipe_ready())
		START_PROCESSING(SSobj, src)
	to_chat(user, span_info("Recipe selected: [current_recipe.name]"))

/obj/machinery/essence/infuser/proc/clear_recipe(mob/user)
	if(!current_recipe)
		return
	STOP_PROCESSING(SSobj, src)
	deltimer(CALLBACK(src, PROC_REF(complete_infusion)))
	qdel(current_recipe)
	current_recipe = null
	infusing = FALSE
	if(network)
		network.invalidate_cache()
	push_surplus_to_linked(storage)
	update_appearance(UPDATE_OVERLAYS)
	if(user)
		to_chat(user, span_info("Recipe cleared."))

/obj/machinery/essence/infuser/proc/show_recipe_progress(mob/user)
	to_chat(user, span_info("Progress for '[current_recipe.name]':"))
	for(var/etype in current_recipe.required_essences)
		var/datum/thaumaturgical_essence/e = new etype
		to_chat(user, span_info("  [e.name]: [storage.get(etype)]/[current_recipe.required_essences[etype]]"))
		qdel(e)

/obj/machinery/essence/infuser/attackby(obj/item/I, mob/user, list/modifiers)
	if(istype(I, /obj/item/essence_vial))
		return ..()
	if(!infusion_target && !infusing)
		// Check item matches a known recipe
		var/valid = FALSE
		for(var/rpath in subtypesof(/datum/infusion_recipe))
			var/datum/infusion_recipe/r = new rpath
			if(istype(I, r.target_type))
				valid = TRUE
				qdel(r)
				break
			qdel(r)
		if(!valid)
			to_chat(user, span_warning("[I] cannot be infused."))
			return
		if(user.transferItemToLoc(I, src))
			infusion_target = I
			to_chat(user, span_info("You place [I] on [src]."))
			if(current_recipe && !recipe_ready())
				START_PROCESSING(SSobj, src)
			update_appearance(UPDATE_OVERLAYS)
		return
	return ..()

/obj/machinery/essence/infuser/get_mechanics_examine(mob/user)
	. = ..()
	if(infusion_target)
		. += span_notice("Item: [infusion_target]")
	if(current_recipe)
		. += span_notice("Recipe: [current_recipe.name]")
		for(var/etype in current_recipe.required_essences)
			var/needed = current_recipe.required_essences[etype]
			var/have = storage.get(etype)
			var/datum/thaumaturgical_essence/e = new etype
			. += span_notice("  [e.name]: [have]/[needed]")
			qdel(e)
	if(infusing)
		. += span_notice("Infusing...")
