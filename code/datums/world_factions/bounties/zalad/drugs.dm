/datum/bounty/zalad/spice_run
	name = "Spice Run"
	desc = "A discreet buyer wants spice moved quietly through the dunes."
	required_path = /obj/item/reagent_containers/powder/spice
	required_count = 3
	reward_reputation = 18
	reward_currency = 300
	demanded_by = NOBLEMEN
	required_reputation_tier = 2
	faction_generation_weights = list(/datum/world_faction/zalad_traders = 20)
