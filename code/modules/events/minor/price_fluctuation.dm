/datum/round_event_control/price_fluctuation
	name = "Shipping Fluctuations"
	track = EVENT_TRACK_MUNDANE
	typepath = /datum/round_event/price_fluctuation
	weight = 10
	max_occurrences = 4
	min_players = 0
	earliest_start = 15 MINUTES

	tags = list(
		TAG_TRADE,
		TAG_WATER,
	)

/datum/round_event/price_fluctuation/start()
	. = ..()
	for(var/i = 1 to rand(7, 25))
		var/pack = pick(SSmerchant.supply_packs)
		var/datum/supply_pack/PA = SSmerchant.supply_packs[pack]
		PA.cost = max(initial(PA.cost) * 0.25, PA.cost + rand(-round(PA.cost * 0.25), round(PA.cost * 0.25)))
