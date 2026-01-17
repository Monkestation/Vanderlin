// Burning stage constants
#define BURN_STAGE_WARNING 1
#define BURN_STAGE_SMOKING 2
#define BURN_STAGE_CRITICAL 3

/datum/component/food_burner
	/// How long before food fully burns (in deciseconds)
	var/burn_time = 3 MINUTES
	/// List of tracked foods with their insertion times and burn progress
	var/list/tracked_foods = list()
	/// Whether smoke should be created when burning food
	var/create_smoke = TRUE
	/// Tracks already processed items to avoid burning them again
	var/list/processed_items = list()
	///this is a callback for if we continue processing a burn
	var/datum/callback/can_burn

/**
 * Initialize the component
 * @param burn_timer How long before food completely burns (in deciseconds)
 * @param smoke Whether to create smoke when burning
 */
/datum/component/food_burner/Initialize(burn_timer = 3 MINUTES, smoke = TRUE, datum/callback/can_burn)
	. = ..()
	burn_time = burn_timer
	create_smoke = smoke
	src.can_burn = can_burn

	START_PROCESSING(SSprocessing, src)
	RegisterSignal(parent, COMSIG_PARENT_EXAMINE, PROC_REF(on_examine))
	RegisterSignal(parent, COMSIG_STORAGE_REMOVED, PROC_REF(on_item_removed))
	RegisterSignal(parent, COMSIG_CONTAINER_CRAFT_COMPLETE, PROC_REF(on_craft_complete))

/**
 * Clean up when component is removed
 */
/datum/component/food_burner/Destroy()
	STOP_PROCESSING(SSprocessing, src)
	can_burn = null
	tracked_foods.Cut()
	processed_items.Cut()
	return ..()

/**
 * Add examination text to warn about possible burning
 */
/datum/component/food_burner/proc/on_examine(datum/source, mob/user, list/examine_text)
	if(length(tracked_foods))
		for(var/obj/item/reagent_containers/food/snacks/food in tracked_foods)
			if(QDELETED(food) || !(food in parent))
				continue

			var/list/food_data = tracked_foods[food]
			var/burn_progress = food_data["progress"]

			if(burn_progress < 0.3)
				examine_text += span_notice("[food] looks fine for now.")
			else if(burn_progress < 0.5)
				examine_text += span_notice("[food] is starting to warm up.")
			else if(burn_progress < 0.75)
				examine_text += span_warning("[food] is getting very hot!")
			else if(burn_progress < 0.9)
				examine_text += span_danger("[food] is smoking and about to burn!")
			else
				examine_text += span_danger("[food] is burning!")

/**
 * Process tick for checking if foods need to progress burning
 */
/datum/component/food_burner/process()
	// Skip processing if the can_burn callback returns false
	if(can_burn && !can_burn.Invoke())
		return

	var/obj/item/container = parent
	var/current_time = world.time
	var/foods_to_burn = list()

	// Check all tracked foods to update burn progress
	for(var/obj/item/reagent_containers/food/snacks/food in tracked_foods)
		if(QDELETED(food) || !(food in container.contents))
			tracked_foods -= food
			continue

		var/list/food_data = tracked_foods[food]
		var/insertion_time = food_data["time"]

		// Calculate how long it's been since insertion
		var/elapsed_time = current_time - insertion_time

		// Calculate burn progress (0.0 to 1.0)
		var/burn_progress = min(elapsed_time / burn_time, 1.0)

		// Update burn progress
		food_data["progress"] = burn_progress

		// Show appropriate burning effects based on progress
		if(burn_progress >= 0.5 && burn_progress < 0.75)
			show_burning_effects(food, BURN_STAGE_WARNING)
		else if(burn_progress >= 0.75 && burn_progress < 0.9)
			show_burning_effects(food, BURN_STAGE_SMOKING)
		else if(burn_progress >= 0.9 && burn_progress < 1.0)
			show_burning_effects(food, BURN_STAGE_CRITICAL)

		// Check if fully burned
		if(burn_progress >= 1.0 && !(food in processed_items))
			foods_to_burn += food

	// Burn any foods that have completed their progress
	for(var/obj/item/reagent_containers/food/snacks/food in foods_to_burn)
		burn_food(food)


/**
 * Show visual and sound effects for a burning food item
 */
/datum/component/food_burner/proc/show_burning_effects(obj/item/reagent_containers/food/snacks/food, burn_stage)
	var/obj/container = parent
	var/list/food_data = tracked_foods[food]

	// Only show effects if we haven't shown this stage for this item yet
	if(!isnull(food_data["last_stage"]) && food_data["last_stage"] >= burn_stage)
		return

	// Update the last shown stage
	food_data["last_stage"] = burn_stage

	// Different messages and effects based on burn stage
	switch(burn_stage)
		if(BURN_STAGE_WARNING)
			container.visible_message(span_warning("Something inside [container] is getting very hot!"))
		if(BURN_STAGE_SMOKING)
			container.visible_message(span_warning("Something inside [container] is starting to smoke!"))
			playsound(container, 'sound/foley/dropsound/food_drop.ogg', 30, TRUE)
			if(create_smoke)
				var/turf/turf = get_turf(container)
				turf.pollute_turf(/datum/pollutant/smoke, 50)
		if(BURN_STAGE_CRITICAL)
			container.visible_message(span_danger("Something inside [container] is burning!"))
			playsound(container, 'sound/foley/dropsound/food_drop.ogg', 50, TRUE)
			if(create_smoke)
				var/turf/turf = get_turf(container)
				turf.pollute_turf(/datum/pollutant/smoke, 75)

/**
 * Remove items from tracking when they're taken out
 */
/datum/component/food_burner/proc/on_item_removed(datum/source, obj/item/removed_item)
	tracked_foods -= removed_item

/**
 * Hook for tracking newly crafted food items
 */
/datum/component/food_burner/proc/on_craft_complete(datum/source, obj/item/crafted_item)
	if(is_food_item(crafted_item) && !(crafted_item in tracked_foods))
		tracked_foods[crafted_item] = list("time" = world.time, "progress" = 0)

/**
 * Turn a food item into a burned food
 */
/datum/component/food_burner/proc/burn_food(obj/item/reagent_containers/food/snacks/food)
	if(QDELETED(food))
		return

	var/obj/container = parent
	var/turf/T = get_turf(container)

	// Final smoke effect if enabled
	if(create_smoke)
		var/datum/effect_system/smoke_spread/smoke = new
		smoke.set_up(0, container)
		smoke.start()

	SEND_SIGNAL(container, COMSIG_TRY_STORAGE_TAKE, food, get_turf(container))
	// Visual and sound effects
	playsound(T, 'sound/foley/dropsound/food_drop.ogg', 50, TRUE)
	container.visible_message(span_danger("[food] inside [container] has burned to a crisp!"))

	// Create the burned food item
	var/obj/item/reagent_containers/food/snacks/badrecipe/burned = new(get_turf(container))
	SEND_SIGNAL(container, COMSIG_TRY_STORAGE_INSERT, burned, null, null, TRUE, TRUE)

	// Mark the original as processed and remove from tracking
	processed_items += food
	tracked_foods -= food

	// Delete the original food
	qdel(food)

/**
 * Helper to check if an item is a food item
 */
/datum/component/food_burner/proc/is_food_item(obj/item/I)
	return istype(I, /obj/item/reagent_containers/food/snacks)

/**
 * Register a newly created food item for burning
 * Can be called externally by other systems
 */
/datum/component/food_burner/proc/register_food(obj/item/reagent_containers/food/snacks/food)
	var/obj/item/container = parent
	if(!QDELETED(food) && (food in container.contents) && !(food in tracked_foods))
		tracked_foods[food] = list("time" = world.time, "progress" = 0)

#undef BURN_STAGE_WARNING
#undef BURN_STAGE_SMOKING
#undef BURN_STAGE_CRITICAL
