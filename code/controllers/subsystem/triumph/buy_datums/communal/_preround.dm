/datum/triumph_buy/communal/preround
	name = "Pre-Round Communal Fund"
	desc = "A communal fund that can only be contributed to before the round starts. Refunds otherwise."
	category = TRIUMPH_CAT_COMMUNAL

/// Refunds all contributions to their respective donators
/datum/triumph_buy/communal/preround/proc/check_refund()
	if(activated || SStriumphs.communal_pools[type] <= 0)
		return

	for(var/ckey in SStriumphs.communal_contributions[type])
		var/total_contributed = 0
		for(var/amount in SStriumphs.communal_contributions[type][ckey])
			total_contributed += amount

		if(total_contributed > 0)
			var/client/C = GLOB.directory[ckey]
			if(C?.ckey)
				C.adjust_triumphs(total_contributed, counted = FALSE, silent = TRUE, override_bonus = TRUE)
				to_chat(C, span_notice("You were refunded [total_contributed] triumph\s from the [name] as it wasn't fully funded before the round has started."))
			else
				SStriumphs.triumph_adjust(total_contributed, ckey)

	SStriumphs.communal_pools[type] = 0
	SStriumphs.communal_contributions[type] = list()
