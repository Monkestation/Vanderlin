/datum/world_faction
	var/name = "World"
	var/desc = "The entirety of the world"
	var/faction_name
	var/list/sell_value_modifiers = list()
	var/list/last_sell_modification = list()
	var/list/sold_count = list()
	var/list/price_change_manifest = list()
	var/list/hard_value_multipliers = list()
	var/faction_reputation = 0

	var/list/faction_supply_packs = list() // This faction's available supply packs
	var/list/bounty_items = list() // Items this faction wants with multipliers
	var/list/bounty_refresh_times = list() // When each bounty expires
	var/next_supply_rotation = 0 // When supply packs refresh
	var/supply_rotation_interval = 15 MINUTES // How often supplies rotate
	var/bounty_rotation_interval = 15 MINUTES // How often bounties rotate
	var/base_max_bounties = 10 // Base maximum number of active bounties
	var/base_max_supply_packs = 30 // Base maximum supply packs available at once
	var/faction_color = "#FFFFFF" // Color for UI theming

	// Reputation thresholds and bonuses
	var/list/reputation_thresholds = list(0, 100, 200, 400, 600, 800, 1000) // Rep levels
	var/bounty_rep_reward_base = 50 // Base rep for completing bounties
	var/supply_rep_reward_base = 25 // Base rep for buying supplies

	// Essential items that are always in stock
	var/list/essential_packs = list()

	// Weighted pools for different item categories
	var/list/common_pool = list()      // Weight 50
	var/list/uncommon_pool = list()    // Weight 30
	var/list/rare_pool = list()        // Weight 15
	var/list/exotic_pool = list()      // Weight 5

	// Pool weights (should add up to 100)
	var/common_weight = 50
	var/uncommon_weight = 30
	var/rare_weight = 15
	var/exotic_weight = 5

	// How many items from each pool to select (beyond essentials) - base values
	var/base_common_picks = 20
	var/base_uncommon_picks = 12
	var/base_rare_picks = 6
	var/base_exotic_picks = 2

	var/list/allowed_maps = list()

	var/list/trader_outfits = list(
		/obj/effect/mob_spawn/human/rakshari/trader
	)

	/// Chance for this faction to send a trader (0-100)
	var/trader_chance = 60
	/// Weighted preferences for trader types - higher numbers = more likely
	var/list/trader_type_weights = list(
		/datum/trader_data/food_merchant = 10,
		/datum/trader_data/clothing_merchant = 10,
		/datum/trader_data/tool_merchant = 10,
		/datum/trader_data/luxury_merchant = 10,
		/datum/trader_data/alchemist = 10,
		/datum/trader_data/material_merchant = 10
	)
	/// Current trader on the boat (if any)
	var/datum/weakref/current_trader_ref

	var/list/next_boat_traders = list() // List of trader data for the next boat
	var/next_boat_trader_count = 0 // How many traders will come on next boat
	var/trader_schedule_generated = FALSE // Whether we've prepared for next boat

	///faction specific weightings for bounties
	// Format: list(path = weight)
	// Example: list(/obj/item/clothing = 300, /obj/item/weapon = 200)
	// Higher weight = more likely to appear as bounty
	///we use base 100 so we have fine control over it
	var/list/bounty_path_weights = list()
	var/default_bounty_weight = 100 // Weight for items not in bounty_path_weights


/datum/world_faction/New()
	..()
	initialize_faction_stock()
	generate_initial_bounties()

/**
 * Gets the weight for a specific item type based on bounty_path_weights
 * Checks the item and all its parent types for matching weights
 */
/datum/world_faction/proc/get_bounty_weight(obj/item_type)
	var/highest_weight = default_bounty_weight

	// Check each weighted path to see if item_type is a subtype
	for(var/weighted_path in bounty_path_weights)
		if(ispath(item_type, weighted_path))
			var/weight = bounty_path_weights[weighted_path]
			// Use the most specific (highest) weight found
			if(weight > highest_weight)
				highest_weight = weight

	return highest_weight

// Get current reputation tier (0-6)
/datum/world_faction/proc/get_reputation_tier()
	var/tier = 0
	for(var/threshold in reputation_thresholds)
		if(faction_reputation >= threshold)
			tier++
		else
			break
	return max(0, tier - 1) // Adjust since we increment before breaking

/datum/world_faction/proc/schedule_next_boat_traders()
	if(trader_schedule_generated)
		return // Already scheduled

	next_boat_traders.Cut()
	next_boat_trader_count = 0

	if(!should_send_trader())
		trader_schedule_generated = TRUE
		return

	// Random number of traders between 1 and 5
	var/max_traders = min(4, length(trader_type_weights)) // Don't exceed available types
	next_boat_trader_count = rand(1, max_traders)

	// Pick trader types (avoid duplicates if possible)
	var/list/available_types = trader_type_weights.Copy()

	for(var/i = 1 to next_boat_trader_count)
		if(!length(available_types))
			// If we run out of unique types, refill the list
			available_types = trader_type_weights.Copy()

		var/trader_type = pickweight(available_types)
		var/datum/trader_data/trader_data = new trader_type()
		customize_trader_inventory(trader_data)

		next_boat_traders += trader_data
		available_types -= trader_type // Remove to avoid duplicates

	trader_schedule_generated = TRUE

// Reset trader schedule when boat leaves
/datum/world_faction/proc/reset_trader_schedule()
	trader_schedule_generated = FALSE
	next_boat_traders.Cut()
	next_boat_trader_count = 0

// Create multiple traders from scheduled list
/datum/world_faction/proc/create_scheduled_traders(turf/spawn_location)
	var/list/created_traders = list()

	for(var/datum/trader_data/trader_data in next_boat_traders)
		var/picked_outfit = pick(trader_outfits)
		if(length(trader_data.outfit_override))
			picked_outfit = pick(trader_data.outfit_override)
		var/mob/living/simple_animal/hostile/retaliate/trader/faction_trader/new_trader = new(spawn_location, TRUE, picked_outfit, WEAKREF(src))
		new_trader.set_custom_trade(trader_data)
		new_trader.faction_ref = WEAKREF(src)
		created_traders += new_trader

	return created_traders

// Get maximum bounties based on reputation
/datum/world_faction/proc/get_max_bounties()
	var/tier = get_reputation_tier()
	return base_max_bounties + tier // Each tier adds 1 more bounty slot

// Get maximum supply packs based on reputation
/datum/world_faction/proc/get_max_supply_packs()
	var/tier = get_reputation_tier()
	return base_max_supply_packs + (tier * 2) // Each tier adds 2 more supply slots

// Get adjusted pool picks based on reputation
/datum/world_faction/proc/get_pool_picks()
	var/tier = get_reputation_tier()
	var/bonus_multiplier = 1 + (tier * 0.15) // 15% more items per tier

	var/list/picks = list()
	picks["common"] = max(base_common_picks, round(base_common_picks * bonus_multiplier))
	picks["uncommon"] = max(base_uncommon_picks, round(base_uncommon_picks * bonus_multiplier))
	picks["rare"] = max(base_rare_picks, round(base_rare_picks * bonus_multiplier))
	picks["exotic"] = max(base_exotic_picks, round(base_exotic_picks * bonus_multiplier))

	return picks

/datum/world_faction/proc/initialize_faction_stock()
	faction_supply_packs.Cut() // Clear existing

	// Always add essential items first
	for(var/pack_type in essential_packs)
		var/datum/supply_pack/pack = new pack_type()
		if(pack.contains)
			faction_supply_packs[pack_type] = pack

	// Add items from weighted pools - use base values for initial setup
	// since reputation might not be initialized yet
	var/tier = get_reputation_tier()
	if(tier == 0 && faction_reputation == 0) // Initial setup
		add_from_pool(common_pool, base_common_picks)
		add_from_pool(uncommon_pool, base_uncommon_picks)
		add_from_pool(rare_pool, base_rare_picks)
		add_from_pool(exotic_pool, base_exotic_picks)
	else // Subsequent setups can use reputation scaling
		var/list/picks = get_pool_picks()
		add_from_pool(common_pool, picks["common"])
		add_from_pool(uncommon_pool, picks["uncommon"])
		add_from_pool(rare_pool, picks["rare"])
		add_from_pool(exotic_pool, picks["exotic"])

	next_supply_rotation = world.time + supply_rotation_interval

// Helper method to add items from a specific pool
/datum/world_faction/proc/add_from_pool(list/pool, picks_count)
	if(!pool || !picks_count)
		return

	var/list/available_pool = pool.Copy()

	for(var/i = 1 to picks_count)
		if(!length(available_pool))
			break

		var/selected_pack = pick(available_pool)
		available_pool -= selected_pack

		// Don't add if already exists (from essentials or another pool)
		if(selected_pack in faction_supply_packs)
			continue

		var/datum/supply_pack/pack = new selected_pack()
		if(pack.contains)
			faction_supply_packs[selected_pack] = pack

/**
 * Generates initial bounties using the weighted system
 */
/datum/world_faction/proc/generate_initial_bounties()
	if(!length(SSmerchant.valid_bounty_items))
		log_game("WARNING: [faction_name] has no valid bounty items!")
		return

	var/max_bounties = get_max_bounties()

	// Build weighted list of all valid bounty items
	var/list/weighted_bounties = list()
	for(var/bounty_type in SSmerchant.valid_bounty_items)
		weighted_bounties[bounty_type] = get_bounty_weight(bounty_type)

	// Pick bounties using weights
	for(var/i = 1 to max_bounties)
		if(!length(weighted_bounties))
			break

		var/bounty_type = pickweight(weighted_bounties)
		weighted_bounties -= bounty_type
		add_bounty(bounty_type)


/**
 * Generates a bounty multiplier based on item value and reputation
 * Higher value items get lower multipliers to balance rewards
 */
/datum/world_faction/proc/generate_bounty_multiplier(atom/bounty_type)
	var/base_value = SSmerchant.get_item_base_value(bounty_type)
	var/tier = get_reputation_tier()

	// Scale multiplier inversely with item value
	var/value_modifier = 1.0
	if(base_value > 0)
		// Expensive items (100+) get lower multipliers
		// Cheap items (1-20) get higher multipliers
		if(base_value >= 100)
			value_modifier = 0.6
		else if(base_value >= 50)
			value_modifier = 0.8
		else if(base_value >= 20)
			value_modifier = 1.0
		else
			value_modifier = 1.2

	// Reputation provides bonus to multipliers
	var/base_min = (12 + (tier * 2)) / 10.0
	var/base_max = (25 + (tier * 3)) / 10.0

	var/multiplier = rand(base_min * 10, base_max * 10) / 10.0
	multiplier *= value_modifier

	return max(1.1, multiplier) // Minimum 1.1x multiplier

/**
 * adds a bounty taking into account calculated multipliers for items
 */
/datum/world_faction/proc/add_bounty(atom/bounty_type, multiplier)
	// Validate that this is an obtainable item
	if(!(bounty_type in SSmerchant.valid_bounty_items))
		log_game("WARNING: Attempted to add invalid bounty [bounty_type] to [faction_name]")
		return FALSE

	if(!multiplier)
		multiplier = generate_bounty_multiplier(bounty_type)

	bounty_items[bounty_type] = multiplier
	bounty_refresh_times[bounty_type] = world.time + bounty_rotation_interval

	return TRUE

/datum/world_faction/proc/remove_bounty(atom/bounty_type)
	bounty_items -= bounty_type
	bounty_refresh_times -= bounty_type

/datum/world_faction/proc/rotate_supply_packs()
	if(world.time < next_supply_rotation)
		return

	// Keep essential items, only rotate the pool-based items
	var/list/items_to_remove = list()
	for(var/pack_type in faction_supply_packs)
		if(!(pack_type in essential_packs))
			items_to_remove += pack_type

	// Remove 40% of non-essential items
	var/removal_count = max(1, round(length(items_to_remove) * 0.4))
	for(var/i = 1 to removal_count)
		if(!length(items_to_remove))
			break
		var/removed_pack = pick(items_to_remove)
		items_to_remove -= removed_pack
		faction_supply_packs -= removed_pack

	// Calculate how many new items we need from each pool (reputation-scaled)
	var/current_non_essential = length(faction_supply_packs) - length(essential_packs)
	var/list/picks = get_pool_picks()
	var/target_total = picks["common"] + picks["uncommon"] + picks["rare"] + picks["exotic"]
	var/needed = target_total - current_non_essential

	if(needed > 0)
		// Distribute new picks proportionally
		var/new_common = max(0, round(needed * (common_weight / 100)))
		var/new_uncommon = max(0, round(needed * (uncommon_weight / 100)))
		var/new_rare = max(0, round(needed * (rare_weight / 100)))
		var/new_exotic = max(0, needed - new_common - new_uncommon - new_rare)

		add_from_pool(common_pool, new_common)
		add_from_pool(uncommon_pool, new_uncommon)
		add_from_pool(rare_pool, new_rare)
		add_from_pool(exotic_pool, new_exotic)

	next_supply_rotation = world.time + supply_rotation_interval


/**
 * Rotates bounties using weighted selection
 */
/datum/world_faction/proc/rotate_bounties()
	var/list/expired_bounties = list()

	// Check for expired bounties
	for(var/bounty_type in bounty_refresh_times)
		if(world.time >= bounty_refresh_times[bounty_type])
			expired_bounties += bounty_type

	// Remove expired bounties and add new ones
	for(var/expired_bounty in expired_bounties)
		remove_bounty(expired_bounty)

		var/tier = get_reputation_tier()
		var/replacement_chance = 70 + (tier * 5)

		if(prob(replacement_chance))
			// Build weighted list of available bounties
			var/list/weighted_available = list()
			for(var/obj_type in SSmerchant.valid_bounty_items)
				if(!(obj_type in bounty_items))
					weighted_available[obj_type] = get_bounty_weight(obj_type)

			if(length(weighted_available))
				var/new_bounty = pickweight(weighted_available)
				add_bounty(new_bounty)

	// If we have fewer bounties than our max, try to add more
	var/max_bounties = get_max_bounties()
	var/current_bounties = length(bounty_items)

	if(current_bounties < max_bounties)
		var/list/weighted_available = list()
		for(var/obj_type in SSmerchant.valid_bounty_items)
			if(!(obj_type in bounty_items))
				weighted_available[obj_type] = get_bounty_weight(obj_type)

		var/bounties_to_add = max_bounties - current_bounties
		for(var/i = 1 to bounties_to_add)
			if(!length(weighted_available))
				break
			var/new_bounty = pickweight(weighted_available)
			weighted_available -= new_bounty
			add_bounty(new_bounty)

// Award reputation for completing bounties
/datum/world_faction/proc/award_bounty_reputation(atom/bounty_type)
	var/base_reward = bounty_rep_reward_base
	var/multiplier = 1

	if(bounty_type in bounty_items)
		multiplier = bounty_items[bounty_type]

	// Higher value bounties give more rep
	var/rep_gain = round(base_reward * multiplier)
	faction_reputation += rep_gain

	// Notify about reputation gain
	to_chat(usr, "<span class='notice'>You gained [rep_gain] reputation with [faction_name]! (Total: [faction_reputation])</span>")

	// Check if they hit a new tier
	var/old_tier = get_reputation_tier()
	if(faction_reputation >= reputation_thresholds[old_tier + 2]) // Check next threshold
		to_chat(usr, "<span class='boldnotice'>You've reached a new reputation tier with [faction_name]! More bounties and supplies are now available.</span>")

// Award reputation for purchasing supplies
/datum/world_faction/proc/award_supply_reputation(datum/supply_pack/pack)
	var/rep_gain = supply_rep_reward_base
	faction_reputation += rep_gain

/datum/world_faction/proc/handle_world_change()
	for(var/obj/atom as anything in last_sell_modification)
		if(last_sell_modification[atom] > world.time - 15 MINUTES)
			continue
		var/current_price = initial(atom.sellprice) * return_sell_modifier(atom)
		sold_count[atom]--
		adjust_sell_multiplier(atom, rand(0.05, 0.15), 1)
		if(return_sell_modifier(atom) == 1)
			last_sell_modification -= atom
		var/new_price = initial(atom.sellprice) * return_sell_modifier(atom)
		if(new_price != current_price)
			changed_sell_prices(atom, current_price, new_price)

	rotate_supply_packs()
	rotate_bounties()

	// Schedule traders for next boat if boat is coming soon or just left
	if(!trader_schedule_generated)
		schedule_next_boat_traders()

/datum/world_faction/proc/get_actual_sell_price(atom/sell_type, sell_modifier = 1)
	var/base_price = 0

	// If this item has an active bounty, use the bounty's base value
	if(sell_type in bounty_items)
		base_price = SSmerchant.get_item_base_value(sell_type)
		var/bounty_multiplier = bounty_items[sell_type]
		return FLOOR(base_price * bounty_multiplier * sell_modifier, 1)

	// Otherwise use normal sellprice with modifiers
	var/obj/item/temp = sell_type
	base_price = initial(temp.sellprice)

	if(!base_price || base_price <= 0)
		return 0

	var/static_modifier = 1
	if(sell_type in hard_value_multipliers)
		static_modifier = hard_value_multipliers[sell_type]

	var/dynamic_modifier = 1
	if(sell_type in sell_value_modifiers)
		dynamic_modifier = sell_value_modifiers[sell_type]

	return FLOOR(base_price * static_modifier * dynamic_modifier * sell_modifier, 1)

/datum/world_faction/proc/setup_sell_data(atom/sell_type)
	sell_value_modifiers |= sell_type
	sell_value_modifiers[sell_type] = 1

	if(sell_type in SSmerchant.obtainable_items)
		SSmerchant.obtainable_items -= sell_type
		SSmerchant.valid_bounty_items |= sell_type

/datum/world_faction/proc/return_sell_modifier(atom/sell_type)
	var/static_modifer = 1
	if(sell_type in hard_value_multipliers)
		static_modifer = hard_value_multipliers[sell_type]

	// Check if this item has a bounty
	var/bounty_modifier = 1
	if(sell_type in bounty_items)
		bounty_modifier = bounty_items[sell_type]

	var/base_modifier = 1
	if(sell_type in sell_value_modifiers)
		base_modifier = sell_value_modifiers[sell_type]

	return base_modifier * static_modifer * bounty_modifier

/datum/world_faction/proc/get_available_supply_packs()
	return faction_supply_packs

/datum/world_faction/proc/has_supply_pack(datum/supply_pack/pack_type)
	return (pack_type in faction_supply_packs)

/**
 * Handles selling an item, including bounty completion with weighted replacement
 */
/datum/world_faction/proc/handle_selling(obj/selling_type)
	sold_count |= selling_type
	sold_count[selling_type]++

	if(selling_type in bounty_items)
		award_bounty_reputation(selling_type)
		remove_bounty(selling_type)

		var/tier = get_reputation_tier()
		var/new_bounty_chance = 60 + (tier * 5)

		if(prob(new_bounty_chance))
			// Build weighted list of available bounties
			var/list/weighted_available = list()
			for(var/obj_type in SSmerchant.valid_bounty_items)
				if(!(obj_type in bounty_items))
					weighted_available[obj_type] = get_bounty_weight(obj_type)

			if(length(weighted_available))
				var/new_bounty = pickweight(weighted_available)
				add_bounty(new_bounty)

	if(!prob(sold_count[selling_type] * 10))
		return
	adjust_sell_multiplier(selling_type, -rand(0.01, 0.1))

/datum/world_faction/proc/handle_supply_purchase(datum/supply_pack/pack)
	award_supply_reputation(pack)

/datum/world_faction/proc/adjust_sell_multiplier(obj/change_type, change = 0, maximum)
	if(!change || !change_type)
		return
	sell_value_modifiers[change_type] += change
	if(sell_value_modifiers[change_type] < 0.1)
		sell_value_modifiers[change_type] = 0.1

	if(maximum)
		if(sell_value_modifiers[change_type] > maximum)
			sell_value_modifiers[change_type] = maximum

	last_sell_modification |= change_type
	last_sell_modification[change_type] = world.time

/datum/world_faction/proc/changed_sell_prices(atom/atom_type, old_price, new_price)
	price_change_manifest |= atom_type
	price_change_manifest[atom_type] = list("[old_price]", "[new_price]")

/datum/world_faction/proc/draw_selling_changes()
	var/index_num = 0
	var/list/sell_data = list()
	for(var/atom/list_type as anything in price_change_manifest)
		if(index_num >= 4)
			SSmerchant.sending_stuff |= new /obj/item/paper/scroll/sell_price_changes(null, sell_data, faction_name)
			index_num = 0
			sell_data = list()
			continue
		sell_data |= list_type
		var/list/prices = price_change_manifest[list_type]
		sell_data[list_type] = prices.Copy()

	if(length(sell_data))
		SSmerchant.sending_stuff |= new /obj/item/paper/scroll/sell_price_changes(null, sell_data, faction_name)

/datum/world_faction/proc/should_send_trader()
	if(!length(trader_type_weights))
		return FALSE
	return prob(trader_chance)


/datum/world_faction/proc/create_faction_trader(turf/spawn_location)
	if(!length(trader_type_weights))
		return null
	var/trader_type = pickweight(trader_type_weights)
	var/datum/trader_data/trader_data = new trader_type()
	// Customize trader with faction-specific items
	customize_trader_inventory(trader_data)
	var/picked_outfit = pick(trader_outfits)
	if(length(trader_data.outfit_override))
		picked_outfit = pick(trader_data.outfit_override)
	var/mob/living/simple_animal/hostile/retaliate/trader/faction_trader/new_trader = new(spawn_location, TRUE, picked_outfit, WEAKREF(src))
	new_trader.set_custom_trade(trader_data)
	new_trader.faction_ref = WEAKREF(src)
	current_trader_ref = WEAKREF(new_trader)
	return new_trader

/datum/world_faction/proc/customize_trader_inventory(datum/trader_data/trader_data)
	var/list/all_packs = essential_packs + common_pool + uncommon_pool + rare_pool + exotic_pool
	var/list/compatible_packs = list()
	var/list/faction_products = list()

	// First, find all compatible packs with this trader type
	for(var/pack_type in all_packs)
		var/passed = FALSE
		var/datum/supply_pack/pack = new pack_type()
		for(var/datum/supply_pack/allowed_pack_type as anything in trader_data.base_type)
			if(istype(pack, allowed_pack_type))
				compatible_packs[pack_type] = pack
				passed = TRUE
				break
		if(!passed)
			qdel(pack)

	// Determine how many items this trader should have based on reputation
	var/tier = get_reputation_tier()
	var/base_items = 8 // Base number of different items a trader carries
	var/max_items = base_items + (tier * 2) // More items available at higher reputation

	// Create unified weighted selection including both custom items and supply packs
	var/list/unified_selection = list()

	// Add custom items to unified selection
	if(length(trader_data.custom_items))
		for(var/item_type in trader_data.custom_items)
			var/list/item_data = trader_data.custom_items[item_type]
			if(length(item_data) >= 3)
				var/weight = item_data[1] // First element is weight
				var/base_price = item_data[2] // Second element is base price

				// Adjust weight based on tier for rarer items
				var/adjusted_weight = weight
				if(base_price > 100) // Higher priced items are rarer
					adjusted_weight += tier

				unified_selection[item_type] = adjusted_weight

	// Add supply packs to unified selection
	for(var/pack_type in compatible_packs)
		var/weight = 10
		if(pack_type in essential_packs)
			weight = 15
		else if(pack_type in common_pool)
			weight = 12
		else if(pack_type in uncommon_pool)
			weight = 8
		else if(pack_type in rare_pool)
			weight = 5 + tier // Rare items more likely at higher rep
		else if(pack_type in exotic_pool)
			weight = 2 + (tier * 2) // Exotic items much more likely at higher rep
		unified_selection[pack_type] = weight

	// Select items from unified pool
	var/items_to_select = min(max_items, length(unified_selection))
	var/custom_items_selected = 0

	for(var/i = 1 to items_to_select)
		if(!length(unified_selection))
			break

		var/selected_entry = pickweight(unified_selection)

		// Check if it's a custom item (exists in trader_data.custom_items)
		if(selected_entry in trader_data.custom_items)
			// Check if we've hit the custom item limit
			if(custom_items_selected >= trader_data.max_custom_items)
				unified_selection -= selected_entry
				i-- // Don't count this iteration
				continue

			var/list/original_data = trader_data.custom_items[selected_entry]

			// Calculate final price and quantity with tier adjustments
			var/final_price = calculate_custom_item_price(original_data[2], tier)
			var/final_quantity = calculate_custom_item_quantity(original_data[3], tier)

			faction_products[selected_entry] = list(final_price, final_quantity)
			custom_items_selected++
		else
			// It's a supply pack
			var/datum/supply_pack/pack = compatible_packs[selected_entry]

			if(islist(pack.contains))
				for(var/item_type in pack.contains)
					var/price = calculate_trader_price(pack, item_type)
					var/quantity = calculate_trader_quantity(pack, tier)
					faction_products[item_type] = list(price, quantity)
			else if(pack.contains)
				var/price = calculate_trader_price(pack, pack.contains)
				var/quantity = calculate_trader_quantity(pack, tier)
				faction_products[pack.contains] = list(price, quantity)

		unified_selection -= selected_entry

	// Clean up all pack instances
	for(var/pack_type in compatible_packs)
		var/datum/supply_pack/pack = compatible_packs[pack_type]
		qdel(pack)

	if(length(faction_products))
		trader_data.initial_products = faction_products

/**
 * Calculates the final price for a custom item based on tier
 * Arguments:
 *   base_price - The base price of the item
 *   tier - The faction's reputation tier
 * Returns:
 *   The adjusted price
 */
/datum/world_faction/proc/calculate_custom_item_price(base_price, tier)
	// Higher tier = slightly lower prices (better deals)
	var/price_modifier = 1.0 - (tier * 0.05) // 5% discount per tier
	return max(1, round(base_price * price_modifier))

/**
 * Calculates the final quantity for a custom item based on tier
 * Arguments:
 *   base_quantity - The base quantity of the item
 *   tier - The faction's reputation tier
 * Returns:
 *   The adjusted quantity
 */
/datum/world_faction/proc/calculate_custom_item_quantity(base_quantity, tier)
	// Higher tier = more stock available
	if(base_quantity == INFINITY)
		return INFINITY
	return base_quantity + tier

/datum/world_faction/proc/calculate_trader_quantity(datum/supply_pack/pack, reputation_tier)
	var/base_quantity = 2

	if(pack.type in essential_packs)
		base_quantity = 3 + reputation_tier
	else if(pack.type in common_pool)
		base_quantity = 2 + (reputation_tier / 2)
	else if(pack.type in uncommon_pool)
		base_quantity = 2
	else if(pack.type in rare_pool)
		base_quantity = 1 + (reputation_tier / 3)
	else if(pack.type in exotic_pool)
		base_quantity = 1

	return max(1, rand(base_quantity, base_quantity + 2))

/datum/world_faction/proc/calculate_trader_price(datum/supply_pack/pack, item_type)
	var/base_price = 20 // Default base price

	// Adjust price based on pack rarity
	if(pack.type in rare_pool)
		base_price *= 2
	else if(pack.type in exotic_pool)
		base_price *= 3
	else if(pack.type in uncommon_pool)
		base_price *= 1.5

	return base_price

/datum/world_faction/proc/get_reputation_status()
	var/tier = get_reputation_tier()
	var/list/tier_names = list("Neutral", "Friendly", "Trusted", "Honored", "Revered", "Exalted", "Legendary")
	var/tier_name = tier_names[min(tier + 1, length(tier_names))]

	var/next_threshold = "MAX"
	if(tier + 1 < length(reputation_thresholds))
		next_threshold = reputation_thresholds[tier + 2]

	return "[tier_name] ([faction_reputation]/[next_threshold])"


/datum/world_faction/proc/debug_spawn_trader(mob/spawner)
	if(!spawner)
		return null

	var/turf/spawn_location = get_turf(spawner)
	if(!spawn_location)
		to_chat(spawner, "<span class='warning'>Could not find valid spawn location!</span>")
		return null

	// Remove existing trader if any
	var/mob/living/simple_animal/hostile/retaliate/trader/faction_trader/old_trader = current_trader_ref?.resolve()
	if(old_trader)
		to_chat(spawner, "<span class='notice'>Removing existing trader...</span>")
		qdel(old_trader)
		current_trader_ref = null

	var/new_trader = create_faction_trader(spawn_location)
	if(new_trader)
		to_chat(spawner, "<span class='notice'>Spawned [faction_name] trader at your location!</span>")
		return new_trader
	else
		to_chat(spawner, "<span class='warning'>Failed to spawn trader!</span>")
		return null

/proc/debug_spawn_random_faction_trader(mob/spawner)
	if(!spawner)
		return

	var/list/available_factions = list()

	for(var/datum/world_faction/faction in SSmerchant.world_factions)
		available_factions += faction

	var/datum/world_faction/chosen_faction = pick(available_factions)
	return chosen_faction.debug_spawn_trader(spawner)

/client/proc/spawn_faction_trader()
	set name = "Spawn Faction Trader"
	set category = "Debug.Spawn"

	if(!check_rights(R_ADMIN))
		return

	debug_spawn_random_faction_trader(mob)
