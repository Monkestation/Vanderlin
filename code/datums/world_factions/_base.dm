/datum/world_faction
	var/name = "World"
	var/desc = "The entirety of the world"
	var/faction_name
	var/list/sell_value_modifiers = list()
	var/list/last_sell_modification = list()
	var/list/sold_count = list()
	var/list/price_change_manifest = list()
	var/list/hard_value_multipliers = list()
	var/faction_reputation = 200

	var/list/faction_supply_packs = list() // This faction's available supply packs
	var/next_supply_rotation = 0 // Used here as next market price shift timestamp
	var/supply_rotation_interval = 5 MINUTES // How often prices fluctuate
	var/base_max_supply_packs = 30 // Base maximum supply packs available at once
	var/faction_color = "#FFFFFF" // Color for UI theming

	// Reputation thresholds
	var/list/reputation_thresholds = list(0, 100, 200, 400, 600, 800, 1000) // Rep levels
	var/supply_rep_reward_base = 25 // Base rep for buying supplies

	// Essential items that are always in stock
	var/list/essential_packs = list()

	// Pools for different item categories
	var/list/common_pool = list()
	var/list/uncommon_pool = list()
	var/list/rare_pool = list()
	var/list/exotic_pool = list()

	// Configured volatility modifiers for market trends (percentage limits per update)
	var/base_volatility = 12 // 12% max swing up or down standard

	var/list/allowed_maps = list()

	var/list/trader_outfits = list(
		/obj/effect/mob_spawn/human/rakshari/trader
	)

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

	var/list/active_bounties = list()
	var/list/completed_bounties = list()
	var/max_active_bounties = 8

	/// Timestamp for the next independent bounty trickle check
	var/next_bounty_rotation = 0
	/// How often we attempt to trickle in new bounties, independent of the trade boat cycle
	var/bounty_rotation_interval = 3 MINUTES
	/// Minimum delay after a bounty is completed before that slot can be refilled by the trickle
	var/bounty_refill_cooldown = 1 MINUTES

	/// world.time at which the next bounty reroll becomes available
	var/bounty_reroll_ready_time = 0
	/// How long a faction must wait between bounty rerolls
	var/bounty_reroll_cooldown = 5 MINUTES

	/// Chance for this faction to send a trader (0-100), baseline value at trader_chance_baseline_tier
	var/trader_chance = 60
	/// The reputation tier at which trader_chance is treated as the unmodified baseline
	var/trader_chance_baseline_tier = 2
	/// Percentage points added per tier ABOVE the baseline tier (linear growth)
	var/trader_chance_tier_scaling = 10
	/// Percentage points subtracted per tier BELOW the baseline, squared
	var/trader_chance_penalty_scaling = 15

	/// Peak (most likely) trader count at trader_count_baseline_tier
	var/trader_count_base_peak = 2
	/// The reputation tier at which trader_count_base_peak applies unmodified
	var/trader_count_baseline_tier = 2
	/// Traders added to the peak per tier ABOVE baseline (linear growth)
	var/trader_count_tier_scaling = 0.5
	/// Traders subtracted from the peak per tier BELOW baseline, squared
	var/trader_count_penalty_scaling = 0.75
	/// How wide the bell roll can swing around the peak
	var/trader_count_bell_spread = 1

/datum/world_faction/New()
	..()
	initialize_faction_stock()

// Get current reputation tier (0-6)
/datum/world_faction/proc/get_reputation_tier()
	var/tier = 0
	for(var/threshold in reputation_thresholds)
		if(faction_reputation >= threshold)
			tier++
		else
			break
	return max(0, tier - 1) // Adjust since we increment before breaking

/datum/world_faction/proc/fluctuate_bounties()
	if(world.time < next_bounty_rotation)
		return

	next_bounty_rotation = world.time + bounty_rotation_interval

	if(length(active_bounties) >= max_active_bounties)
		return

	generate_bounties(rand(1, 2))

/datum/world_faction/proc/schedule_next_boat_traders()
	if(trader_schedule_generated)
		return // Already scheduled
	next_boat_traders.Cut()
	next_boat_trader_count = 0

	if(!should_send_trader())
		trader_schedule_generated = TRUE
		return

	var/max_traders = min(4, length(trader_type_weights)) // Don't exceed available types

	var/tier = get_reputation_tier()
	var/tier_diff = tier - trader_count_baseline_tier
	var/peak

	if(tier_diff >= 0)
		peak = trader_count_base_peak + (tier_diff * trader_count_tier_scaling)
	else
		peak = trader_count_base_peak - ((tier_diff * tier_diff) * trader_count_penalty_scaling)

	peak = clamp(round(peak), 1, max_traders)

	next_boat_trader_count = roll_bell_quality(peak, trader_count_bell_spread, 1, max_traders)

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
/datum/world_faction/proc/create_scheduled_traders(list/possible_turfs)
	var/list/created_traders = list()

	var/turf/spawn_location //this is legit incase a mapper makes a like... 1 tile boat
	for(var/datum/trader_data/trader_data in next_boat_traders)
		if(length(possible_turfs))
			spawn_location = pick_n_take(possible_turfs)
		var/picked_outfit = pick(trader_outfits)
		if(length(trader_data.outfit_override))
			picked_outfit = pick(trader_data.outfit_override)
		var/mob/living/simple_animal/hostile/retaliate/trader/faction_trader/new_trader = new(spawn_location, TRUE, picked_outfit, WEAKREF(src))
		new_trader.set_custom_trade(trader_data)
		new_trader.faction_ref = WEAKREF(src)
		created_traders += new_trader

	return created_traders

/// Shifts faction_reputation by a relative number of tiers (supports fractional tiers, e.g. -1.5).
/// Interpolates within reputation_thresholds rather than applying a flat number, since tiers aren't evenly spaced.
/datum/world_faction/proc/adjust_reputation_by_tier(tier_delta)
	if(!tier_delta)
		return

	var/current_tier = get_reputation_tier()
	var/max_tier = length(reputation_thresholds) - 1
	var/target_tier = clamp(current_tier + tier_delta, 0, max_tier)

	var/low_tier = floor(target_tier)
	var/high_tier = ceil(target_tier)
	var/frac = target_tier - low_tier

	var/low_value = reputation_thresholds[low_tier + 1]   // BYOND lists are 1-indexed
	var/high_value = reputation_thresholds[high_tier + 1]

	faction_reputation = round(low_value + (high_value - low_value) * frac)

/**
 * Automatically rolls and generates new random weighted bounties, pulling weights from the bounty datums themselves.
 */
/datum/world_faction/proc/generate_bounties(amount = INFINITY)
	if(!length(subtypesof(/datum/bounty)))
		return
	var/current_tier = get_reputation_tier()
	var/generated = 0

	// Keep generating until we hit our maximum active slots, or our per-call cap, whichever's first
	while(length(active_bounties) < max_active_bounties && generated < amount)
		var/list/weighted_selection = list()

		for(var/datum/bounty/bounty_type as anything in subtypesof(/datum/bounty))
			if(IS_ABSTRACT(bounty_type))
				continue
			// Don't duplicate an identical bounty type if it's already active
			var/already_active = FALSE
			for(var/datum/bounty/active in active_bounties)
				if(active.type == bounty_type)
					already_active = TRUE
					break
			if(already_active)
				continue

			// Check if the faction has achieved the required tier
			var/datum/bounty/bounty_initial = new bounty_type
			if(current_tier >= initial(bounty_initial.required_reputation_tier))

				// Read the weight configuration out of the bounty type
				var/list/weights_map = bounty_initial.faction_generation_weights
				var/final_weight = initial(bounty_initial.fallback_weight)

				// Check if this specific faction type (or an exact parent type match) exists in the list
				// Using istype() or basic key lookup. Let's do direct key tracking first:
				if(src.type in weights_map)
					final_weight = weights_map[src.type]
				else
					// Loop to support inherited faction parent types matching safely
					for(var/faction_path in weights_map)
						if(istype(src, faction_path))
							final_weight = weights_map[faction_path]
							break

				if(final_weight > 0)
					weighted_selection[bounty_type] = final_weight

		// If no unique/eligible bounties are left to generate, break out
		if(!length(weighted_selection))
			break

		// Pick a type based on the dynamically assembled weights and instantiate it
		var/chosen_bounty_type = pickweight(weighted_selection)
		var/datum/bounty/new_bounty = new chosen_bounty_type()

		active_bounties += new_bounty
		generated++
		add_abstract_elastic_data(ELASCAT_ECONOMY, ELASDATA_BOUNTIES_GENERATED, 1)

/**
 * Initializes the entire catalog permanently. No elements are dropped or skipped.
 */
/datum/world_faction/proc/initialize_faction_stock()
	faction_supply_packs.Cut()

	var/list/all_possible_packs = essential_packs + common_pool + uncommon_pool + rare_pool + exotic_pool

	var/list/all_packs = subtypesof(/datum/supply_pack)

	for(var/pack_type in all_possible_packs)
		if(pack_type in faction_supply_packs)
			continue
		var/datum/supply_pack/pack = new pack_type()
		if(pack.contains)
			faction_supply_packs[pack_type] = pack
		all_packs -= pack_type

	for(var/pack_type in all_packs) //this fills the rest
		if(pack_type in faction_supply_packs)
			continue
		var/datum/supply_pack/pack = new pack_type()
		if(pack.contains)
			faction_supply_packs[pack_type] = pack

	next_supply_rotation = world.time + supply_rotation_interval
	next_bounty_rotation = world.time

/**
 * Moves supply crate values organically over time.
 * Volatility and price shifts are dynamically determined by the item's rarity group.
 * Reputation acts as a market anchor, pulling volatile price swings downward to favor the buyer.
 */
/datum/world_faction/proc/fluctuate_supply_prices()
	if(world.time < next_supply_rotation)
		return

	var/tier = get_reputation_tier()
	// Each tier shifts the median downward by 2.5% (Max -15% bias at Tier 6)
	var/buyer_bias = tier * 2.5

	for(var/pack_id in faction_supply_packs)
		var/datum/supply_pack/pack = faction_supply_packs[pack_id]
		if(pack.static_cost)
			continue

		// Establish fallback baseline defaults
		var/group_volatility = base_volatility
		var/group_bias = 0 // Extra baked-in trend modifier depending on rarity

		// Dynamic adjustment based on rarity group
		if(pack_id in essential_packs)
			group_volatility = 5   // Essential items stay very market-stable
			group_bias = -2        // Slight natural downward price trend for essentials
		else if(pack_id in common_pool)
			group_volatility = 8   // Low volatility
			group_bias = 0
		else if(pack_id in uncommon_pool)
			group_volatility = 14  // Slightly higher volatility than baseline
			group_bias = 1         // Subtle natural markup force
		else if(pack_id in rare_pool)
			group_volatility = 22  // High volatility, prices can swing wildly
			group_bias = 3         // Noticeable upward trend pressures
		else if(pack_id in exotic_pool)
			group_volatility = 35  // Severe luxury market volatility
			group_bias = 5         // Strong luxury markup force
		else if(pack.cost > pack.baseline_price)
			group_volatility = 5 // basically we want this to be volatile to lower the price ideally
			group_bias = 0
		else
			continue

		// Calculate a dynamically shifted window that stays bound within group limits
		// Buyer bias counters the positive group_bias markup forces at high reputation!
		var/min_swing = -group_volatility + group_bias - buyer_bias
		var/max_swing = group_volatility + group_bias - buyer_bias

		var/change_modifier = 1.0 + (rand(min_swing, max_swing) * 0.01)

		var/old_cost = pack.cost
		var/new_cost = max(1, round(pack.cost * change_modifier))

		if(pack.baseline_price)
			var/floor_cost = max(1, round(pack.baseline_price * SUPPLY_PRICE_FLOOR_MULT))
			var/ceiling_cost = max(floor_cost, round(pack.baseline_price * SUPPLY_PRICE_CEILING_MULT))
			new_cost = clamp(new_cost, floor_cost, ceiling_cost)

		pack.cost = new_cost

		if(old_cost != pack.cost)
			pack.record_cost_history()

	next_supply_rotation = world.time + supply_rotation_interval

/**
 * Nudges a pack's live price up whenever it's bought.
 * Small flat nudge if the pack is already at/above its baseline price; a bigger
 * corrective nudge the further under baseline it currently sits.
 */
/datum/world_faction/proc/apply_purchase_demand_pressure(datum/supply_pack/pack, quantity = 1)
	if(!pack || !quantity)
		return
	if(pack.static_cost || !pack.baseline_price)
		return

	var/old_cost = pack.cost

	for(var/i = 1 to quantity)
		var/ratio = pack.cost / pack.baseline_price // 1.0 = baseline, <1 discounted, >1 marked up

		var/push_percent
		if(ratio <= 1)
			push_percent = SUPPLY_DEMAND_PUSH_BASE + ((1 - ratio) * SUPPLY_DEMAND_PUSH_DISCOUNT_SCALING)
		else
			push_percent = SUPPLY_DEMAND_PUSH_BASE

		pack.cost = max(1, round(pack.cost * (1 + (push_percent * 0.01))))

		var/floor_cost = max(1, round(pack.baseline_price * SUPPLY_PRICE_FLOOR_MULT))
		var/ceiling_cost = max(floor_cost, round(pack.baseline_price * SUPPLY_PRICE_CEILING_MULT))
		pack.cost = clamp(pack.cost, floor_cost, ceiling_cost)

	if(pack.cost != old_cost)
		pack.record_cost_history()

// Award reputation for purchasing supplies
/datum/world_faction/proc/award_supply_reputation(datum/supply_pack/pack)
	var/rep_gain = supply_rep_reward_base
	faction_reputation += rep_gain

	// Check if they hit a new tier
	var/old_tier = get_reputation_tier()
	if(faction_reputation >= reputation_thresholds[old_tier + 2]) // Check next threshold
		to_chat(usr, "<span class='boldnotice'>You've reached a new reputation tier with [faction_name]! Market prices are shifting in your favor.</span>")

/datum/world_faction/proc/handle_world_change()
	for(var/obj/atom as anything in last_sell_modification)
		if(last_sell_modification[atom] > world.time - 15 MINUTES)
			continue
		var/current_price = atom.sellprice * return_sell_modifier(atom)
		sold_count[atom]--
		adjust_sell_multiplier(atom, rand(0.05, 0.15), 1)
		if(return_sell_modifier(atom) == 1)
			last_sell_modification -= atom
		var/new_price = atom.sellprice * return_sell_modifier(atom)
		if(new_price != current_price)
			changed_sell_prices(atom, current_price, new_price)

	fluctuate_supply_prices()
	fluctuate_bounties()

	// Schedule traders for next boat if boat is coming soon or just left
	if(!trader_schedule_generated)
		schedule_next_boat_traders()

/datum/world_faction/proc/get_reagent_sell_values(obj/item/reagent_containers/glass/container)
	var/list/values = list()
	if((!istype(container) && !istype(container, /obj/structure))|| !container.reagents)
		return values
	for(var/datum/reagent/reagent in container.reagents?.reagent_list)
		var/value = FLOOR(reagent.price_per_unit * reagent.volume, 1)
		if(value <= 0)
			continue
		values[reagent.name] = list(reagent.volume, value)
	return values

/datum/world_faction/proc/get_actual_sell_price(atom/sell_type, sell_modifier = 1)
	var/base_price = SSmerchant.get_item_base_value(sell_type)

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

/datum/world_faction/proc/return_sell_modifier(atom/sell_type)
	var/static_modifer = 1
	if(sell_type in hard_value_multipliers)
		static_modifer = hard_value_multipliers[sell_type]

	var/base_modifier = 1
	if(sell_type in sell_value_modifiers)
		base_modifier = sell_value_modifiers[sell_type]

	return base_modifier * static_modifer

/datum/world_faction/proc/get_available_supply_packs()
	return faction_supply_packs

/datum/world_faction/proc/has_supply_pack(datum/supply_pack/pack_type)
	return (pack_type in faction_supply_packs)

/**
 * Handles selling an item & matches against active bounties
 * Returns TRUE if consumed by a bounty, FALSE if treated as a normal sale
 */
/datum/world_faction/proc/handle_selling(atom/movable/selling_item)
	if(istype(selling_item, /obj/item/natural/bundle))
		return handle_selling_bundle(selling_item)
	return handle_selling_single(selling_item)

/datum/world_faction/proc/handle_selling_single(atom/movable/selling_item)
	for(var/datum/bounty/bounty in active_bounties)
		var/bounty_result = bounty.check_completion(selling_item)

		if(bounty_result == BOUNTY_MATCH_CONSUMED)
			// The item was 100% swallowed by the bounty. Check if the bounty is now done.
			if(bounty.current_count >= bounty.required_count || (bounty.required_reagent_type && bounty.current_reagent_amount >= bounty.required_reagent_amount))
				bounty.fulfill_bounty(src)
				active_bounties -= bounty
				completed_bounties += bounty
			return TRUE
		if(bounty_result == BOUNTY_MATCH_PARTIAL)
			if(bounty.current_reagent_amount >= bounty.required_reagent_amount)
				bounty.fulfill_bounty(src)
				active_bounties -= bounty
				completed_bounties += bounty
			return FALSE_BUT_HANDLED

	// If no bounty wanted it at all, log it for market inflation and return FALSE to allow normal sale
	sold_count |= selling_item.type
	sold_count[selling_item.type]++
	if(prob(sold_count[selling_item.type] * 10))
		adjust_sell_multiplier(selling_item.type, -rand(0.01, 0.1))
	return FALSE

/// Bundles represent N copies of stacktype. Feed them into bounties one
/// unit at a time, then dump whatever's left into the market as a block sale.
/datum/world_faction/proc/handle_selling_bundle(obj/item/natural/bundle/bundle)
	var/remaining = bundle.amount
	var/fed_a_bounty = FALSE

	for(var/datum/bounty/bounty in active_bounties)
		if(remaining <= 0)
			break

		while(remaining > 0 && bounty.check_completion_type(bundle.stacktype))
			remaining--
			fed_a_bounty = TRUE

			if(bounty.current_count >= bounty.required_count)
				bounty.fulfill_bounty(src)
				active_bounties -= bounty
				completed_bounties += bounty
				break // This bounty is finished, move to the next active bounty in the loop

	bundle.amount = remaining

	if(bundle.amount <= 0)
		return TRUE // Tell tram loop: "Item is empty/consumed, go ahead and qdel() it"

	if(fed_a_bounty)
		sold_count |= bundle.stacktype
		sold_count[bundle.stacktype] += bundle.amount
		if(prob(sold_count[bundle.stacktype] * 10))
			adjust_sell_multiplier(bundle.stacktype, -rand(0.01, 0.1))

		return FALSE // Tell tram loop: "Keep this object alive and sell the remainder for cash"
	return FALSE // Hand off to normal tram selling logic

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

	var/tier = get_reputation_tier()
	var/tier_diff = tier - trader_chance_baseline_tier
	var/effective_chance

	if(tier_diff >= 0)
		// Linear climb above baseline
		effective_chance = trader_chance + (tier_diff * trader_chance_tier_scaling)
	else
		// Quadratic falloff below baseline, each tier further down hurts more than the last
		effective_chance = trader_chance - ((tier_diff * tier_diff) * trader_chance_penalty_scaling)

	effective_chance = clamp(effective_chance, 0, 100)
	return prob(effective_chance)

/datum/world_faction/proc/create_faction_trader(turf/spawn_location)
	if(!length(trader_type_weights))
		return null
	var/trader_type = pickweight(trader_type_weights)
	var/datum/trader_data/trader_data = new trader_type()
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
	trader_data.active_faction = src

	// Find all compatible packs with this trader type
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

	var/tier = get_reputation_tier()
	var/base_items = 8
	var/max_items = base_items + (tier * 2)

	var/list/unified_selection = list()

	// Add custom items to unified selection
	if(length(trader_data.custom_items))
		for(var/item_type in trader_data.custom_items)
			var/list/item_data = trader_data.custom_items[item_type]
			if(length(item_data) >= 3)
				var/weight = item_data[1]
				var/base_price = item_data[2]

				var/adjusted_weight = weight
				if(base_price > 100)
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
			weight = 8 + tier
		else if(pack_type in rare_pool)
			weight = 5 + (tier * 2)
		else if(pack_type in exotic_pool)
			weight = 2 + (tier * 4)
		unified_selection[pack_type] = weight

	var/items_to_select = min(max_items, length(unified_selection))
	var/custom_items_selected = 0

	for(var/i = 1 to items_to_select)
		if(!length(unified_selection))
			break

		var/selected_entry = pickweight(unified_selection)

		if(selected_entry in trader_data.custom_items)
			if(custom_items_selected >= trader_data.max_custom_items)
				unified_selection -= selected_entry
				i--
				continue

			var/list/original_data = trader_data.custom_items[selected_entry]
			var/final_price = calculate_custom_item_price(original_data[2], tier)
			var/final_quantity = calculate_custom_item_quantity(original_data[3], tier)

			faction_products[selected_entry] = list(final_price, final_quantity)
			custom_items_selected++
		else
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

	for(var/pack_type in compatible_packs)
		var/datum/supply_pack/pack = compatible_packs[pack_type]
		qdel(pack)

	if(length(faction_products))
		trader_data.initial_products = faction_products

/datum/world_faction/proc/calculate_custom_item_price(base_price, tier)
	var/price_modifier = 1.0 - (tier * 0.05)
	return max(1, round(base_price * price_modifier))

/datum/world_faction/proc/calculate_custom_item_quantity(base_quantity, tier)
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
	var/base_price = 20

	if(pack.type in rare_pool)
		base_price *= 2
	else if(pack.type in exotic_pool)
		base_price *= 3
	else if(pack.type in uncommon_pool)
		base_price *= 1.5

	return base_price

/// Maps reputation tier (0-6) to a calculator's best achievable quality tier.
/// quality_scale should be the calculator's lowest and highest quality_descriptor keys.
/datum/world_faction/proc/get_peak_quality(low, high, tier)
	var/tier_fraction = tier / 6 // 0.0 to 1.0
	var/peak = low + round((high - low) * tier_fraction)
	return clamp(peak, low, high)

/datum/world_faction/proc/get_faction_quality_calculator(obj/item/target)
	if(!target)
		return null

	var/tier = get_reputation_tier() // 0-6
	var/datum/quality_calculator/calc
	var/rolled_quality

	if(istype(target, /obj/item/reagent_containers/glass/bottle))
		calc = new /datum/quality_calculator/brewing(
			mat_qual = SMELTERY_QUALITY_NORMAL + tier,
			skill_qual = tier,
			components = 1,
			reagent_qual = 0,
			fresh = 5 MINUTES,
			recipe_mod = 1.0 + (tier * 0.05),
			aging_bonus = 0,
		)
		var/peak = get_peak_quality(-1, COOK_QUALITY_VERYGOOD, tier)
		rolled_quality = roll_bell_quality(peak, spread = 2, low_bound = -1, high_bound = COOK_QUALITY_VERYGOOD)

	else if(istype(target, /obj/item/reagent_containers/food/snacks)) // idk how else to really do this tbh
		calc = new /datum/quality_calculator/cooking(
			mat_qual = SMELTERY_QUALITY_POOR + tier,
			skill_qual = tier,
			components = 1,
			reagent_qual = 1 + (tier * 0.2),
			fresh = 5 MINUTES,
			recipe_mod = 1.0 + (tier * 0.05),
		)
		var/peak = get_peak_quality(-1, COOK_QUALITY_VERYGOOD, tier)
		rolled_quality = roll_bell_quality(peak, spread = 2, low_bound = -1, high_bound = COOK_QUALITY_VERYGOOD)

	else if(target.melting_material || ispath(target.smeltresult, /obj/item/ingot))
		calc = new /datum/quality_calculator/blacksmithing(
			mat_qual = SMELTERY_QUALITY_NORMAL + tier,
			skill_qual = min(6, tier),
			components = 1,
			reagent_qual = 0,
			perf_qual = 60 + (tier * 5),
			diff_mod = 0,
			mini_play = 1,
		)
		var/peak = get_peak_quality(BLACKSMITH_QUALITY_SPOILED, BLACKSMITH_QUALITY_LEGENDARY, tier)
		rolled_quality = roll_bell_quality(peak, spread = 2, low_bound = BLACKSMITH_QUALITY_SPOILED, high_bound = BLACKSMITH_QUALITY_LEGENDARY)

	return list(calc, rolled_quality)

/// Rolls a bell-curve-weighted value centered near `peak`, biased towards peak
/datum/world_faction/proc/roll_bell_quality(peak, spread = 2, low_bound, high_bound)
	// Sum of 3 uniform rolls, each contributing 0 to spread/3, averages
	var/roll = 0
	for(var/i = 1 to 3)
		roll += rand(0, spread * 10)
	roll /= 3 // average of three rolls, now ranges 0 to spread*10, bell-weighted toward spread*5

	var/offset = round((roll / 10) - (spread / 2)) // shifts back up so the bulk centers near peak - (spread/4)

	var/result = peak - offset
	if(!isnull(low_bound))
		result = max(result, low_bound)
	if(!isnull(high_bound))
		result = min(result, high_bound)
	return min(result, peak) // hard guarantee: never above peak


/datum/world_faction/proc/can_reroll_bounty()
	return world.time >= bounty_reroll_ready_time

/datum/world_faction/proc/get_bounty_reroll_seconds_left()
	return max(0, round((bounty_reroll_ready_time - world.time) / 10))

/datum/world_faction/proc/reroll_bounty(datum/bounty/target_bounty, mob/user)
	if(!can_reroll_bounty())
		return FALSE

	if(!istype(target_bounty) || !(target_bounty in active_bounties))
		return FALSE

	active_bounties -= target_bounty
	qdel(target_bounty)

	bounty_reroll_ready_time = world.time + bounty_reroll_cooldown
	add_abstract_elastic_data(ELASCAT_ECONOMY, ELASDATA_BOUNTIES_REROLLED, 1)

	// Slot is now open, so this will generate exactly one replacement
	generate_bounties(1)
	return TRUE

/datum/world_faction/proc/debug_spawn_trader(mob/spawner)
	if(!spawner)
		return null

	var/turf/spawn_location = get_turf(spawner)
	if(!spawn_location)
		to_chat(spawner, "<span class='warning'>Could not find valid spawn location!</span>")
		return null

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
