/datum/supply_pack
	abstract_type = /datum/supply_pack
	var/name = "Crate"
	var/group = ""
	var/hidden = FALSE
	var/contraband = FALSE
	var/cost = 700 // Minimum cost, or infinite points are possible.
	var/baseline_price = 0
	var/access = FALSE
	var/access_any = FALSE
	var/list/contains = null
	var/crate_name = "crate"
	var/desc = ""//no desc by default
	var/crate_type = /obj/structure/closet/crate
	var/dangerous = FALSE // Should we message admins?
	var/special = FALSE //Event/Station Goals/Admin enabled packs
	var/special_enabled = FALSE
	var/DropPodOnly = FALSE//only usable by the Bluespace Drop Pod via the express cargo console
	var/admin_spawned = FALSE
	var/small_item = FALSE //Small items can be grouped into a single crate.
	var/static_cost = FALSE
	var/randomprice_factor = 0.07
	var/unlocked = TRUE
	// Stock Market & Price Fluctuation Variables
	var/list/cost_history = list() // Stores a history of previous costs (e.g., list(710, 685, 740...))
	var/max_history_length = 20    // Caps how many data points are saved for the graph
	///are we allowed to be picked as a starting type?
	var/allowed_start = TRUE

/datum/supply_pack/New()
	..()
	var/lim = round(cost * 0.3)
	cost = rand(cost-lim, cost+lim)
	if(cost < 1)
		cost = 1

	#ifdef TESTSERVER
	cost = 1
#else
	if(cost)
		if(cost == initial(cost) && !static_cost)
			var/na = max(round(cost * randomprice_factor, 1), 1)
			cost = max(rand(cost-na, cost+na), 1)
#endif
	if(contains && !islist(contains))
		contains = list(contains)

	// Record initial cost as the first point on our market graph
	record_cost_history()
	baseline_price = cost

/datum/supply_pack/proc/generate(atom/A, datum/bank_account/paying_account)
	var/obj/structure/closet/crate/C
	if(paying_account)
		C = new /obj/structure/closet/crate(A)
		C.name = "[crate_name] - Purchased by [paying_account.account_holder]"
	else
		C = new crate_type(A)
		C.name = "[crate_name] of [LOWER_TEXT(name)]"

	fill(C)
	return C

/datum/supply_pack/proc/fill(obj/structure/closet/crate/C)
	if (admin_spawned)
		for(var/item in contains)
			var/atom/A = new item(C)
			A.flags_1 |= ADMIN_SPAWNED_1
	else
		for(var/item in contains)
			new item(C)

/datum/supply_pack/proc/get_realized_price()
	var/actual_price = 0
	for(var/atom in contains)
		actual_price += SSmerchant.get_item_base_value(atom)
	return actual_price

/**
 * Appends the current cost into the trend line database
 */
/datum/supply_pack/proc/record_cost_history()
	cost_history += cost
	if(length(cost_history) > max_history_length)
		cost_history.Cut(1, 2)
