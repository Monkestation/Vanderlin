/datum/triumph_buy/communal/psydon_retirement_fund
	name = "Psydon's Retirement Fund"
	desc = "Contribute to a fund that will be redistributed to the poorest players when its full or when the round ends."
	triumph_buy_id = TRIUMPH_BUY_PSYDON_RETIREMENT
	maximum_pool = 300

/datum/triumph_buy/communal/psydon_retirement_fund/on_activate()
	var/total_pool = SStriumphs.communal_pools[type]
	if(total_pool <= 0)
		return

	var/list/eligible = list()
	for(var/client/C in GLOB.clients)
		if(!C?.ckey)
			continue
		eligible += C

	if(!length(eligible))
		return

	if(length(eligible) == 1)
		var/client/C = eligible[1]
		adjust_triumphs(C, total_pool, FALSE, "Psydon's Retirement Fund", override_bonus = TRUE)

		bordered_message(world, list(
			span_reallybig("A total of [total_pool] triumph[total_pool == 1 ? " has" : "s have"] been redistributed to 1 beneficiary from the Psydon's Retirement Fund!"),
		))

		SStriumphs.communal_pools[type] = 0
		SStriumphs.communal_contributions[type] = list()
		return

	var/list/client_data = list()
	for(var/client/C in eligible)
		client_data += list(list(
			"client" = C,
			"triumphs" = SStriumphs.get_triumphs(C.ckey),
		))

	sortTim(client_data, GLOBAL_PROC_REF(cmp_client_triumphs))

	var/list/distribution = list()
	for(var/client/C in eligible)
		distribution[C] = 0

	var/remaining = total_pool
	var/safety_counter = 1500

	while(remaining > 0 && safety_counter > 0)
		safety_counter--

		var/current_min = client_data[1]["triumphs"]
		var/list/current_group = list()

		for(var/list/data in client_data)
			if(data["triumphs"] == current_min)
				current_group += data["client"]
			else
				break

		if(!length(current_group))
			break

		var/next_min = INFINITY
		for(var/list/data in client_data)
			if(data["triumphs"] > current_min && data["triumphs"] < next_min)
				next_min = data["triumphs"]

		if(next_min == INFINITY)
			var/per_player = max(1, FLOOR(remaining / length(current_group), 1))
			for(var/client/C in current_group)
				if(remaining <= 0)
					break
				var/give = min(per_player, remaining)
				distribution[C] += give
				remaining -= give
				for(var/list/data in client_data)
					if(data["client"] == C)
						data["triumphs"] += give
						break
			break

		var/triumphs_needed = next_min - current_min
		var/per_player = max(1, FLOOR(min(remaining, triumphs_needed * length(current_group)) / length(current_group), 1))
		for(var/client/C in current_group)
			if(remaining <= 0)
				break

			var/give = min(per_player, remaining)
			distribution[C] += give
			remaining -= give

			for(var/list/data in client_data)
				if(data["client"] == C)
					data["triumphs"] += give
					break

		sortTim(client_data, GLOBAL_PROC_REF(cmp_client_triumphs))

	var/number_of_beneficiaries = 0
	for(var/client/C in distribution)
		if(distribution[C] > 0)
			number_of_beneficiaries++
			adjust_triumphs(C, distribution[C], FALSE, "Psydon's Retirement Fund", override_bonus = TRUE)

	bordered_message(world, list(
		span_reallybig("A total of [total_pool] triumph[total_pool == 1 ? " has" : "s have"] been redistributed between [number_of_beneficiaries] beneficiaries from the Psydon's Retirement Fund!"),
	))

	SStriumphs.communal_pools[type] = 0
	SStriumphs.communal_contributions[type] = list()

/proc/cmp_client_triumphs(list/a, list/b)
	return a["triumphs"] - b["triumphs"]
