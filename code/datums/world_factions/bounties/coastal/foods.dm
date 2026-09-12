/datum/bounty/coastal/fish_haul
	name = "Dockside Fish Haul"
	desc = "The fish markets need fresh carp to keep up with demand."
	required_path = /obj/item/reagent_containers/food/snacks/fish/carp
	required_count = 12
	reward_reputation = 20
	reward_currency = 160
	demanded_by = PEASANTS
	faction_generation_weights = list(/datum/world_faction/coastal_merchants = 40)
