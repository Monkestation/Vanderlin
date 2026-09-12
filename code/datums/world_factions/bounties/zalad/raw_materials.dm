/datum/bounty/zalad/silk_caravan
	name = "Caravan Silk Order"
	desc = "The caravan masters want silk to trade along the desert routes."
	required_path = /obj/item/natural/silk
	required_count = 5
	reward_reputation = 10
	reward_currency = 150
	demanded_by = PEASANTS
	faction_generation_weights = list(/datum/world_faction/zalad_traders = 35)
