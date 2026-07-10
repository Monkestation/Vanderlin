/datum/bounty/dwarf/mead
	name = "Feast Barrel Order"
	desc = "The clan hall wants Mead for the upcoming feast."
	required_reagent_type = /datum/reagent/consumable/ethanol/mead
	required_reagent_amount = 100
	reward_reputation = 8
	reward_currency = 150
	demanded_by = PEASANTS
	faction_generation_weights = list(/datum/world_faction/mountain_clans = 25)
