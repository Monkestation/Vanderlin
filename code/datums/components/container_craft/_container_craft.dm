
/datum/component/container_craft
	/// Recipe types that can be used with this container
	var/list/viable_recipe_types = list()
	/// Low priority recipes (craft_priority = FALSE)
	var/list/fallback_recipe_types = list()
	/// Callback when craft starts
	var/datum/callback/on_craft_start
	/// Callback when craft fails
	var/datum/callback/on_craft_failed
	/// Callback when craft is successful
	var/datum/callback/on_craft_finished

/**
 * Initialize the component
 */
/datum/component/container_craft/Initialize(list/recipes, temperature_listener, datum/callback/start, datum/callback/fail, datum/callback/success)
	. = ..()
	if(!length(recipes))
		return COMPONENT_INCOMPATIBLE

	viable_recipe_types = list()
	fallback_recipe_types = list()

	for(var/datum/container_craft/recipe as anything in recipes)
		var/datum/container_craft/singleton = GLOB.container_craft_to_singleton[recipe]
		if(!singleton)
			continue
		if(IS_ABSTRACT(singleton))
			continue

		if(singleton.craft_priority)
			viable_recipe_types += recipe
		else
			fallback_recipe_types += recipe

	on_craft_start = start
	on_craft_failed = fail
	on_craft_finished = success
	RegisterSignal(parent, COMSIG_STORAGE_CLOSED, PROC_REF(async_start))
	RegisterSignal(parent, COMSIG_MOVABLE_MOVED, PROC_REF(async_start))
	if(temperature_listener)
		RegisterSignal(parent, COMSIG_REAGENTS_EXPOSE_TEMPERATURE, PROC_REF(async_start))

/**
 * Asynchronously start crafting
 */
/datum/component/container_craft/proc/async_start(datum/source, mob/user)
	INVOKE_ASYNC(src, PROC_REF(attempt_crafts), source, user)

/**
 * Attempt to craft all possible recipes - try normal priority first, then fallbacks
 */
/datum/component/container_craft/proc/attempt_crafts(datum/source, mob/user)
	var/list/stored_items = list()
	var/obj/item/host = parent
	if(!length(host.contents))
		return

	if(!istype(user))
		user = get_mob_by_ckey(host.fingerprintslast)

	// Build list of all items in container by type
	for(var/obj/item/item in host.contents)
		stored_items |= item.type
		stored_items[item.type]++

	// Subtract items already reserved by active crafts in this container
	for(var/datum/container_craft_operation/op in GLOB.active_container_crafts)
		if(op.crafter != host)
			continue

		// op.stored_items is now a list of item references, convert to type counts
		for(var/obj/item/reserved_item in op.stored_items)
			if(QDELETED(reserved_item))
				continue
			var/item_type = reserved_item.type
			if(stored_items[item_type])
				stored_items[item_type]--
				if(stored_items[item_type] <= 0)
					stored_items -= item_type

	// First try normal priority recipes
	for(var/datum/container_craft/recipe as anything in viable_recipe_types)
		var/datum/container_craft/singleton = GLOB.container_craft_to_singleton[recipe]
		if(!singleton)
			continue
		// Try to start the craft
		if(singleton.try_craft(host, stored_items.Copy(), user, on_craft_start, on_craft_failed))
			return  // Success! Stop here

	// If no normal priority recipes worked, try fallback recipes
	for(var/datum/container_craft/recipe as anything in fallback_recipe_types)
		var/datum/container_craft/singleton = GLOB.container_craft_to_singleton[recipe]
		if(!singleton)
			continue
		// Try to start the craft
		if(singleton.try_craft(host, stored_items.Copy(), user, on_craft_start, on_craft_failed))
			return  // Success! Stop here
