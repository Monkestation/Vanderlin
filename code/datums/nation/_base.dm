/datum/nation
	var/name = "???"
	var/desc = "???"

	///this is our rep with the nation
	var/nation_rep = 0
	///this is the cost in mammons of how much it costs to buy into the nation
	var/national_currency_cost = 1

	///this is a list of all of our nodes starts as paths on init it will bloom into basically singletons
	var/list/nodes = list()
	///this is a list of all the completed paths we have done for trades
	var/list/completed_trades
	///this is a lazyman accessor for what we can currently work on trade wise
	var/list/lazyman

/datum/nation/New()
	. = ..()
	var/list/actual_nodes = list()
	for(var/datum/trade/node as anything in nodes)
		var/datum/trade/real_node = new node
		actual_nodes |= real_node
	nodes = actual_nodes

	populate_lazyman()

/datum/nation/Destroy(force, ...)
	. = ..()
	QDEL_LIST(nodes)
	lazyman = null

/datum/nation/proc/populate_lazyman()
	for(var/datum/trade/node in nodes)
		if(!can_work_on(node))
			continue
		LAZYADD(lazyman, node)

/datum/nation/proc/complete_trade(datum/trade/node)
	LAZYADD(completed_trades, node.type)
	LAZYREMOVE(lazyman, node)
	SSmerchant.unlock_supply_packs(node.supply_packs)

/datum/nation/proc/can_work_on(datum/trade/node)
	for(var/requirement as anything in node.required_trades)
		if(!(requirement in completed_trades))
			return FALSE
	return TRUE

/datum/nation/proc/handle_import_shipment(list/items)
	for(var/datum/trade/node in lazyman)
		var/valid_items = node.return_valid_count(items)
		if(!valid_items)
			continue
		node.progress_trade(valid_items)
