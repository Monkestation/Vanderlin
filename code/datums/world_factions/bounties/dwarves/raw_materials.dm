/datum/bounty/dwarf/ingot_tribute
	name = "Riddle of Steel Tribute"
	desc = "The forge-masters demand the secret of true steel."
	required_path = /obj/item/riddleofsteel
	required_count = 1
	reward_reputation = 100
	reward_currency = 100
	demanded_by = NOBLEMEN
	required_reputation_tier = 2

/datum/bounty/dwarf/coal_supply
	name = "Forge Fuel"
	desc = "The forges burn through coal day and night."
	required_path = /obj/item/ore/coal
	required_count = 10
	reward_reputation = 20
	reward_currency = 120
	demanded_by = PEASANTS
	faction_generation_weights = list(/datum/world_faction/mountain_clans = 35)
