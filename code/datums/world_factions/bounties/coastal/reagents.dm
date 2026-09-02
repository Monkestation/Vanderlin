/datum/bounty/coastal/exotic_wine
	name = "Vintner's Request"
	desc = "A noble wants rare red wine for their cellar."
	required_reagent_amount = 100
	required_reagent_type = /datum/reagent/consumable/ethanol/redwine
	reward_reputation = 20
	reward_currency = 200
	demanded_by = NOBLEMEN
	required_reputation_tier = 2
	faction_generation_weights = list(/datum/world_faction/coastal_merchants = 25)
	fallback_weight = 1
