/datum/nation
	var/name = "???"
	var/desc = "???"

	///this is our rep with the nation
	var/nation_rep = 0
	///this is the cost in mammons of how much it costs to buy into the nation
	var/national_currency_cost = 1
	///list of breakpoints to names for nation rep
	var/alist/reputation_breakpoints = list(
		"Neutral" = 0,
		"Friendly" = 50,
		"Trusted" = 200,
		"Honored" = 300,
		"Revered" = 600,
		"Exalted" = 800,
		"Legendary" = 1000,
	)

	///how many agreements we've finished and can recycle into new agreements
	var/finished_agreements = 0

	///this is a list of all of our nodes starts as paths on init it will bloom into basically singletons
	var/list/nodes = list()
	///this is a list of all the completed paths we have done for trades
	var/list/completed_trades
	///this is a lazyman accessor for what we can currently work on trade wise
	var/list/lazyman
	///this is the reward cache from doing other things with the nation
	var/list/cached_rewards = list()

	///list of all possible trade requests we can have
	var/list/possible_trade_requests = list()
	///list of the chosen agreements
	var/list/active_agreements
	///everypony viewing the nation
	var/list/ui_users = list()

	/// Weighted preferences for trader types - higher numbers = more likely
	var/list/weighted_trader_data = list(
		/datum/trader_data/food_merchant = 10,
		/datum/trader_data/clothing_merchant = 10,
		/datum/trader_data/tool_merchant = 10,
		/datum/trader_data/luxury_merchant = 10,
		/datum/trader_data/alchemist = 10,
		/datum/trader_data/material_merchant = 10
	)

	var/list/trader_outfits = list(
		/obj/effect/mob_spawn/human/rakshari/trader
	)

/datum/nation/New()
	. = ..()
	var/list/actual_nodes = list()
	for(var/datum/trade/node as anything in nodes)
		var/datum/trade/real_node = new node
		actual_nodes |= real_node
	nodes = actual_nodes

	populate_lazyman()
	setup_possible_cache()
	setup_agreements(rand(3, length(possible_trade_requests) * 0.25))

/datum/nation/Destroy(force, ...)
	. = ..()
	QDEL_LIST(nodes)
	lazyman = null

/datum/nation/proc/get_nation_tier()
	var/last_tier = "Neutral"
	for(var/tier in reputation_breakpoints)
		if(nation_rep < reputation_breakpoints[tier])
			return last_tier
		last_tier = tier

/datum/nation/proc/progress_nation()
	populate_lazyman() //this is purely for offcases that an admin fucks with something
	if(finished_agreements > 0)
		var/new_requests = rand(1, finished_agreements)
		finished_agreements -= new_requests
		setup_agreements(new_requests)

	var/current_slots_used = length(active_agreements) + finished_agreements
	var/max_slots = get_max_agreements()
	if(prob(30) && (current_slots_used < max_slots))
		setup_agreements(1)

/datum/nation/proc/get_max_agreements()
	var/base_cap = 3
	var/tier = get_nation_tier()
	switch(reputation_breakpoints[tier])
		if(1)
			base_cap += 1
		if(2 to 3)
			base_cap += 2
		if(4 to 5)
			base_cap += 4
		if(6)
			base_cap += 6
	return base_cap

/datum/nation/proc/populate_lazyman()
	for(var/datum/trade/node in nodes)
		if(!can_work_on(node))
			continue
		LAZYOR(lazyman, node)

/datum/nation/proc/setup_possible_cache()
	for(var/datum/trade_agreement/agreement_path as anything in possible_trade_requests)
		possible_trade_requests[agreement_path] = initial(agreement_path.weight)

/datum/nation/proc/complete_trade(datum/trade/node)
	LAZYADD(completed_trades, node.type)
	LAZYREMOVE(lazyman, node)
	SSmerchant.unlock_supply_packs(node.supply_packs)
	populate_lazyman()

/datum/nation/proc/can_work_on(datum/trade/node)
	for(var/requirement as anything in node.required_trades)
		if(!(requirement in completed_trades))
			return FALSE
	return TRUE

/datum/nation/proc/handle_import_shipment(list/items, obj/structure/industrial_lift/tram/platform)
	for(var/datum/trade_agreement/agreement in active_agreements)
		if(!agreement.active)
			continue
		items = agreement.process_shipment(items, platform)
		if(agreement.amount_requested <= 0)
			qdel(agreement)

	for(var/datum/trade/node in lazyman)
		var/valid_items = node.return_valid_count(items)
		if(!valid_items)
			continue
		node.progress_trade(valid_items)

/datum/nation/proc/handle_global_shipment(list/items)
	for(var/datum/trade/node in lazyman)
		var/valid_items = node.return_valid_count(items, TRUE)
		if(!valid_items)
			continue
		node.progress_trade(valid_items)


/datum/nation/proc/setup_agreements(amount)
	for(var/i = 1 to amount)
		var/picked_path = pickweight(possible_trade_requests)
		var/datum/trade_agreement/new_agreement = new picked_path(src)
		possible_trade_requests[picked_path] = max(new_agreement.minimum_weight, possible_trade_requests[picked_path] - 10)
		LAZYADD(active_agreements, new_agreement)

/datum/nation/proc/activate_agreement(datum/trade_agreement/agreement)
	if(agreement.active)
		return FALSE
	agreement.activate_agreement()
	return TRUE

/datum/nation/proc/spawn_traders(datum/lift_master/lift)
	var/max_traders = rand(1, min(4, length(weighted_trader_data)))
	var/list/available_types = weighted_trader_data.Copy()

	var/list/lifts = lift.lift_platforms.Copy()

	var/turf/spawn_location = null
	for(var/i = 1 to max_traders)
		while(spawn_location == null)
			if(!length(lifts))
				lifts = lift.lift_platforms.Copy()
			var/obj/structure/industrial_lift/tram/picked_lift = pick_n_take(lifts)
			if(picked_lift.fake)
				continue
			spawn_location = get_turf(picked_lift)

		if(!length(available_types))
			available_types = weighted_trader_data.Copy()
		var/trader_type = pickweight(available_types)
		available_types -= trader_type
		var/datum/trader_data/trader_data = new trader_type()
		customize_trader_stock(trader_data)

		var/picked_outfit = pick(trader_outfits)
		if(length(trader_data.outfit_override))
			picked_outfit = pick(trader_data.outfit_override)

		var/mob/living/simple_animal/hostile/retaliate/trader/faction_trader/new_trader = new(spawn_location, TRUE, picked_outfit, WEAKREF(src))
		new_trader.set_custom_trade(trader_data)
		new_trader.faction_ref = WEAKREF(src)
		spawn_location = null

/datum/nation/proc/customize_trader_stock(datum/trader_data/new_data)
	return
