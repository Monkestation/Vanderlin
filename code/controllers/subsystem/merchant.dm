SUBSYSTEM_DEF(merchant)
	name = "Merchant Packs"
	wait = 60 SECONDS
	init_order = INIT_ORDER_DEFAULT
	runlevels = RUNLEVEL_SETUP | RUNLEVEL_GAME

	var/list/supply_packs = list()
	var/list/supply_cats = list()
	var/list/shoppinglist = list()
	var/list/requestlist = list()
	var/list/fencerequestlist = list()
	var/list/orderhistory = list()
	var/list/trade_requests = list()
	var/list/sending_stuff = list()

	var/datum/lift_master/tram/cargo_boat
	var/cargo_docked = TRUE
	var/datum/lift_master/tram/fence_boat
	var/fence_docked = TRUE

	var/list/world_factions = list()
	var/list/staticly_setup_types = list()

	// New faction management
	var/datum/world_faction/active_faction // Currently selected faction for trading
	var/list/faction_rotation_schedule = list() // When each faction becomes active
	var/list/active_faction_traders = list()

	///this is our list of created nations
	var/list/nations = list()

	/// Cache of recipe component costs to avoid recalculation
	var/static/list/recipe_base_values = list()
	/// Cached list of all valid bounty items (items that can be obtained through gameplay)
	var/static/list/valid_bounty_items = list()
	/// This is a static of possible bounty items
	var/static/list/obtainable_items = list()
	/// Cached list of exclusions for the craft requirements
	var/static/list/exclusions = list()
	/// Same as above but adds all the subtypes
	var/static/list/exclusion_subtypes = list(
		/obj/item/ingot,
		/obj/item/ore,
		/obj/item/natural,
	)



/datum/controller/subsystem/merchant/Initialize(timeofday)
	setup_map_nations()
	// Initialize recipe values and bounty cache BEFORE factions cause they use it
	initialize_recipe_values()
	initialize_bounty_cache()

	// Initialize supply packs
	for(var/pack in subtypesof(/datum/supply_pack))
		var/datum/supply_pack/P = new pack()
		if(!P.contains)
			continue
		supply_packs[P.type] = P
		if(!(P.group in supply_cats))
			supply_cats += P.group

	// Initialize factions
	initialize_factions()
	return ..()

/datum/controller/subsystem/merchant/proc/setup_map_nations()
	return //! TODO: when lore done set this up

/**
 * Initializes recipe base values for ALL recipes
 * This runs once and calculates component costs for every craftable item
 */
/datum/controller/subsystem/merchant/proc/initialize_recipe_values()
	if(length(recipe_base_values))
		return // Already initialized

	log_game("Calculating recipe component costs for all craftable items...")

	// Process ALL repeatable crafting recipes
	for(var/datum/repeatable_crafting_recipe/recipe_type as anything in subtypesof(/datum/repeatable_crafting_recipe))
		var/datum/repeatable_crafting_recipe/recipe = new recipe_type()
		var/output = recipe.output

		if(output)
			var/cost = calculate_component_cost(recipe.requirements, recipe.reagent_requirements)
			recipe_base_values[output] = cost + (recipe.craftdiff * 10)

		qdel(recipe)

	// Process ALL orderless slapcraft recipes
	for(var/datum/orderless_slapcraft/recipe_type as anything in subtypesof(/datum/orderless_slapcraft))
		var/datum/orderless_slapcraft/recipe = new recipe_type()
		var/output = recipe.output_item

		if(output)
			var/cost = calculate_component_cost(recipe.requirements)
			recipe_base_values[output] = cost + 10

		qdel(recipe)

	// Process ALL anvil recipes
	for(var/datum/anvil_recipe/recipe_type as anything in subtypesof(/datum/anvil_recipe))
		var/datum/anvil_recipe/recipe = new recipe_type()
		var/output = recipe.created_item

		if(output)
			var/list/all_requirements = list()
			if(recipe.req_bar)
				all_requirements[recipe.req_bar] = recipe.num_of_materials

			if(length(recipe.additional_items))
				for(var/item in recipe.additional_items)
					all_requirements[item] = 1

			var/cost = calculate_component_cost(all_requirements)
			recipe_base_values[output] = cost + (recipe.craftdiff * 10)

		qdel(recipe)

	// Process ALL artificer recipes
	for(var/datum/artificer_recipe/recipe_type as anything in subtypesof(/datum/artificer_recipe))
		var/datum/artificer_recipe/recipe = new recipe_type()
		var/output = recipe.created_item

		if(output)
			var/list/all_requirements = list()
			if(recipe.required_item)
				all_requirements[recipe.required_item] = 1

			if(length(recipe.additional_items))
				for(var/item in recipe.additional_items)
					all_requirements[item] = 1

			var/cost = calculate_component_cost(all_requirements)
			recipe_base_values[output] = cost + (recipe.craftdiff * 10)

		qdel(recipe)

	// Process ALL container craft recipes
	for(var/datum/container_craft/recipe_type as anything in subtypesof(/datum/container_craft))
		var/datum/container_craft/recipe = new recipe_type()
		var/output = recipe.output

		if(output)
			var/cost = calculate_component_cost(recipe.requirements, recipe.reagent_requirements)
			recipe_base_values[output] = cost + 10

		qdel(recipe)

	log_game("Calculated recipe values for [length(recipe_base_values)] craftable items")

/**
 * Initializes the cache of valid bounty items
 * This includes items that BOTH have sell values AND can be obtained through gameplay
 */
/datum/controller/subsystem/merchant/proc/initialize_bounty_cache()
	if(length(valid_bounty_items))
		return

	// Build obtainable items list
	for(var/datum/supply_pack/pack_type as anything in subtypesof(/datum/supply_pack))
		var/datum/supply_pack/pack = new pack_type()

		if(islist(pack.contains))
			for(var/item_type in pack.contains)
				obtainable_items |= item_type
		else if(pack.contains)
			obtainable_items |= pack.contains

		qdel(pack)

	for(var/path in exclusion_subtypes)
		obtainable_items |= subtypesof(path)

	for(var/path in exclusions)
		obtainable_items |= path

	for(var/datum/repeatable_crafting_recipe/recipe as anything in subtypesof(/datum/repeatable_crafting_recipe))
		var/output = initial(recipe.output)
		if(output)
			obtainable_items |= output

	for(var/datum/container_craft/recipe as anything in subtypesof(/datum/container_craft))
		var/output = initial(recipe.output)
		if(output)
			obtainable_items |= output

	for(var/datum/orderless_slapcraft/recipe as anything in subtypesof(/datum/orderless_slapcraft))
		var/output = initial(recipe.output_item)
		if(output)
			obtainable_items |= output

	for(var/datum/anvil_recipe/recipe as anything in subtypesof(/datum/anvil_recipe))
		var/output = initial(recipe.created_item)
		if(output)
			obtainable_items |= output

	for(var/datum/artificer_recipe/recipe as anything in subtypesof(/datum/artificer_recipe))
		var/output = initial(recipe.created_item)
		if(output)
			obtainable_items |= output

	// Only include items that are both obtainable AND have a base value
	for(var/obj_type in obtainable_items)
		var/base_value = get_item_base_value(obj_type)
		if(base_value > 0)
			valid_bounty_items |= obj_type

	log_game("Initialized [length(valid_bounty_items)] valid bounty items (out of [length(obtainable_items)] obtainable items)")

/**
 * Calculates the total cost of components in a recipe
 * Arguments:
 *   requirements - List of required items (path = amount)
 *   reagent_requirements - Optional list of required reagents
 * Returns:
 *   Total component cost, or 0 if cannot be calculated
 */
/datum/controller/subsystem/merchant/proc/calculate_component_cost(list/requirements, list/reagent_requirements)
	var/total_cost = 0

	// Calculate item component costs
	if(length(requirements))
		for(var/component_type in requirements)
			var/amount = 1

			// Handle different requirement formats
			if(isnum(requirements[component_type]))
				amount = requirements[component_type]
			else if(islist(requirements[component_type]))
				amount = length(requirements[component_type])

			var/component_value = get_item_base_value(component_type)

			if(component_value <= 0)
				// If we can't determine a component's value, we can't calculate total cost
				return 0

			total_cost += component_value * amount

	// Calculate reagent costs (simplified - you may want to add actual reagent values)
	if(length(reagent_requirements))
		for(var/reagent in reagent_requirements)
			var/amount = reagent_requirements[reagent]
			// Use a base cost per unit of reagent (adjust as needed)
			total_cost += amount * 0.5

	return total_cost

/**
 * Gets the base value of an item
 * Checks recipe values first, then falls back to sellprice
 * Arguments:
 *   item_type - The path of the item
 * Returns:
 *   The base value, or 0 if not found
 */
/datum/controller/subsystem/merchant/proc/get_item_base_value(item_type)
	// Check if it's a craftable item with recipe cost
	if(item_type in recipe_base_values)
		return recipe_base_values[item_type]

	// Otherwise use sellprice directly
	var/obj/item/temp = item_type
	var/sellprice = initial(temp.sellprice)

	if(sellprice && sellprice > 0)
		return sellprice

	return 0

/datum/controller/subsystem/merchant/proc/get_sell_price(atom/sell_type, datum/world_faction/faction, sell_modifier = 1)
	if(!faction)
		faction = active_faction

	if(!faction)
		return 0

	return faction.get_actual_sell_price(sell_type, sell_modifier)

/datum/controller/subsystem/merchant/proc/get_sell_modifier(atom/sell_type, datum/world_faction/faction)
	if(!faction)
		faction = active_faction

	if(!faction)
		return 1

	return faction.return_sell_modifier(sell_type)

/datum/controller/subsystem/merchant/proc/is_bounty_item(atom/item_type, datum/world_faction/faction)
	if(!faction)
		faction = active_faction

	if(!faction)
		return FALSE

	return (item_type in faction.bounty_items)

/datum/controller/subsystem/merchant/proc/get_bounty_multiplier(atom/item_type, datum/world_faction/faction)
	if(!faction)
		faction = active_faction

	if(!faction || !(item_type in faction.bounty_items))
		return 0

	return faction.bounty_items[item_type]

/datum/controller/subsystem/merchant/proc/register_sellable_item(atom/sell_type)
	if(sell_type in staticly_setup_types)
		return

	staticly_setup_types |= sell_type
	for(var/datum/world_faction/faction in world_factions)
		faction.setup_sell_data(sell_type)

/datum/controller/subsystem/merchant/proc/initialize_factions()

	for(var/datum/world_faction/faction as anything in subtypesof(/datum/world_faction))
		var/datum/world_faction/new_faction = new faction
		if((SSmapping.config.map_name in new_faction.allowed_maps) || !length(new_faction.allowed_maps))
			world_factions |= new_faction

	// Set initial active faction
	active_faction = world_factions[rand(1, length(world_factions))]

	// Schedule faction rotations (every 45 minutes)
	var/rotation_time = 45 MINUTES
	for(var/i = 1 to length(world_factions))
		var/datum/world_faction/faction = world_factions[i]
		faction_rotation_schedule[faction] = world.time + (rotation_time * (i - 1))

/datum/controller/subsystem/merchant/proc/rotate_active_faction()
	var/datum/world_faction/next_faction
	var/earliest_time = INFINITY

	// Find the faction scheduled to be next
	for(var/datum/world_faction/faction in faction_rotation_schedule)
		var/scheduled_time = faction_rotation_schedule[faction]
		if(scheduled_time <= world.time && scheduled_time < earliest_time)
			earliest_time = scheduled_time
			next_faction = faction

	if(next_faction && next_faction != active_faction)
		active_faction = next_faction
		faction_rotation_schedule[next_faction] = world.time + (45 MINUTES * length(world_factions))

/datum/controller/subsystem/merchant/fire(resumed)
	// Update all factions
	for(var/datum/world_faction/faction in world_factions)
		faction.handle_world_change()

	// Check for faction rotation
	rotate_active_faction()

/datum/controller/subsystem/merchant/proc/prepare_cargo_shipment()
	if(!cargo_boat || !cargo_docked)
		return
	draw_selling_changes()
	cargo_boat.show_tram()
	var/list/boat_spaces = list()
	for(var/obj/structure/industrial_lift/lift in cargo_boat.lift_platforms)
		boat_spaces |= cargo_boat.get_valid_turfs(lift)
	for(var/datum/supply_pack/requested as anything in requestlist)
		if(!requestlist[requested])
			continue
		var/turf/boat_turf = pick_n_take(boat_spaces)
		var/obj/structure/closet/crate/crate_to_use
		for(var/i in 1 to requestlist[requested])
			if(i == 1)
				crate_to_use = requested.generate(boat_turf)
			else
				requested.fill(crate_to_use)
		for(var/obj/structure/industrial_lift/lift in cargo_boat.lift_platforms)
			lift.held_cargo |= crate_to_use
	for(var/atom/movable/item as anything in sending_stuff)
		var/turf/boat_turf = pick(boat_spaces)
		if(ispath(item))
			new item(boat_turf)
		else
			item.forceMove(boat_turf)
	requestlist = list()
	spawn_faction_traders()
	cargo_docked = FALSE
	SEND_GLOBAL_SIGNAL(COMSIG_DISPATCH_CARGO, cargo_boat)

/datum/controller/subsystem/merchant/proc/send_cargo_ship_back()
	var/obj/effect/landmark/tram/queued_path/cargo_stop/cargo_stop = cargo_boat.idle_platform
	cargo_stop.UnregisterSignal(cargo_boat, COMSIG_TRAM_EMPTY)
	if(!SSticker.HasRoundStarted())
		return
	if(!cargo_stop.next_path_id)
		return
	var/obj/effect/landmark/tram/destination_platform
	for (var/obj/effect/landmark/tram/destination as anything in GLOB.tram_landmarks[cargo_stop.specific_lift_id])
		if(destination.platform_code == cargo_stop.next_path_id)
			destination_platform = destination
			break

	if (!destination_platform)
		return FALSE

	cargo_boat.tram_travel(destination_platform, rapid = FALSE)
	cargo_boat.callback_platform = destination_platform



/datum/controller/subsystem/merchant/proc/prepare_fence_shipment()
	if(!fence_boat || !fence_docked)
		return

	fence_boat.show_tram()
	var/list/boat_spaces = list()
	for(var/obj/structure/industrial_lift/lift in fence_boat.lift_platforms)
		boat_spaces |= fence_boat.get_valid_turfs(lift)

	for(var/atom/movable/request as anything in fencerequestlist)
		for(var/i = 1 to fencerequestlist[request])
			var/turf/boat_turf = pick_n_take(boat_spaces)
			var/atom/movable/new_item = new request
			new_item.forceMove(boat_turf)
			for(var/obj/structure/industrial_lift/lift in fence_boat.lift_platforms)
				lift.held_cargo |= new_item

	fencerequestlist = list()
	fence_docked = FALSE
	SEND_GLOBAL_SIGNAL(COMSIG_DISPATCH_CARGO, fence_boat)

/datum/controller/subsystem/merchant/proc/send_fence_ship_back()
	var/obj/effect/landmark/tram/queued_path/fence_stop/cargo_stop = fence_boat.idle_platform
	cargo_stop.UnregisterSignal(fence_boat, COMSIG_TRAM_EMPTY)
	if(!SSticker.HasRoundStarted())
		return
	if(!cargo_stop.next_path_id)
		return
	var/obj/effect/landmark/tram/destination_platform
	for (var/obj/effect/landmark/tram/destination as anything in GLOB.tram_landmarks[cargo_stop.specific_lift_id])
		if(destination.platform_code == cargo_stop.next_path_id)
			destination_platform = destination
			break

	if (!destination_platform)
		return FALSE

	fence_boat.tram_travel(destination_platform, rapid = FALSE)
	fence_boat.callback_platform = destination_platform

/datum/controller/subsystem/merchant/proc/adjust_sell_multiplier(obj/change_type, change = 0)
	active_faction.adjust_sell_multiplier(change_type, change)


/datum/controller/subsystem/merchant/proc/handle_selling(obj/selling_type)
	active_faction.handle_selling(selling_type)

/datum/controller/subsystem/merchant/proc/changed_sell_prices(atom/atom_type, old_price, new_price)
	active_faction.changed_sell_prices(atom_type, old_price, new_price)

/datum/controller/subsystem/merchant/proc/draw_selling_changes()
	for(var/datum/world_faction/active_faction in world_factions)
		active_faction.draw_selling_changes()

/datum/controller/subsystem/merchant/proc/set_faction_sell_values(atom/sell_type)
	staticly_setup_types |= sell_type
	for(var/datum/world_faction/active_faction in world_factions)
		active_faction.setup_sell_data(sell_type)

/datum/controller/subsystem/merchant/proc/spawn_faction_traders()
	if(!cargo_docked || !length(world_factions))
		return

	var/datum/world_faction/selected_faction
	for(var/datum/world_faction/faction in world_factions)
		if(faction.trader_schedule_generated && faction.next_boat_trader_count > 0)
			selected_faction = faction
			break

	if(!selected_faction)
		return

	// Find spawn location on or near the boat
	var/list/possible_turfs = list()
	for(var/obj/structure/industrial_lift/lift in cargo_boat.lift_platforms)
		possible_turfs |= cargo_boat.get_valid_turfs(lift)
	var/atom/spawn_turf = get_turf(pick(possible_turfs))

	if(!spawn_turf)
		return

	// Create all scheduled traders
	var/list/new_traders = selected_faction.create_scheduled_traders(spawn_turf)

	for(var/mob/living/simple_animal/hostile/retaliate/trader/faction_trader/trader in new_traders)
		active_faction_traders += trader
		trader.ai_controller?.set_blackboard_key(BB_CURRENT_MIN_MOVE_DISTANCE, 0)
		trader.ai_controller.PauseAi(1 MINUTES) // Wait a minute then they get off the boat

	// Reset for next boat
	selected_faction.reset_trader_schedule()

/datum/controller/subsystem/merchant/proc/unlock_supply_packs(list/incoming_packs)
	for(var/datum/supply_pack/pack in supply_packs)
		if(!(pack.type in incoming_packs))
			continue
		pack.unlocked = TRUE

/datum/controller/subsystem/merchant/proc/handle_lift_contents(obj/structure/industrial_lift/tram/platform, list/items, datum/nation/shipped_nation)
	if(!length(nations))
		return
	if(shipped_nation)
		shipped_nation.handle_import_shipment(items, platform)
	for(var/datum/nation/other_nation in nations)
		if(shipped_nation == other_nation)
			continue
		shipped_nation.handle_global_shipment(items)


/obj/Initialize()
	. = ..()
	if(sellprice)
		if(!(type in SSmerchant.staticly_setup_types))
			if(!istype(src, /obj/item/coin))
				SSmerchant.set_faction_sell_values(type)

/obj/item/proc/get_sell_price(datum/world_faction/faction, sell_modifier = 1)
	return SSmerchant.get_sell_price(type, faction, sell_modifier)

