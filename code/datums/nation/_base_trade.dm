/datum/trade
	var/name = "???"
	var/desc = "???"

	var/trade_icon = 'icons/effects/effects.dmi'
	var/trade_icon_state = "explosion"
	var/datum/nation/papa
	///if this is true its basically a node on some other tree
	var/global_request = FALSE

	///these are the trades we need to do prior to this one before we can work on this
	var/list/required_trades

	///these are the min and max ranges for how many items we need to import
	var/min_imports = 5
	var/max_imports = 10

	var/target_imports = 0
	var/current_imports = 0

	///this is the type list of supply packs we unlock for completing this
	var/list/supply_packs

	///these are the item types we look for when trying to see if we progressed something
	var/list/acceptable_imports

/datum/trade/New()
	. = ..()
	target_imports = rand(min_imports, max_imports)

/datum/trade/proc/progress_trade(amount)
	current_imports += amount
	if(amount >= target_imports)
		current_imports = target_imports
		papa.complete_trade(src)

/datum/trade/proc/return_valid_count(list/items, only_global)
	if(only_global && !global_request)
		return
	var/count = 0
	for(var/atom/atom in items)
		if(atom.type in required_trades)
			count++
	return count
