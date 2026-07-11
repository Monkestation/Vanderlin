/datum/bounty/coastal/glassware
	name = "Glassware Shipment"
	desc = "A merchant house wants fine glass panes for trade abroad."
	required_path = /obj/item/natural/glass
	required_count = 8
	reward_reputation = 10
	reward_currency = 120
	demanded_by = PEASANTS|NOBLEMEN
	faction_generation_weights = list(/datum/world_faction/coastal_merchants = 30)

/datum/bounty/coastal/instrument_commission
	name = "Bard's Commission"
	desc = "A traveling bard needs a fine guitar before they set sail."
	required_path = /obj/item/instrument/guitar
	required_count = 1
	reward_reputation = 12
	reward_currency = 55
	demanded_by = PEASANTS
	faction_generation_weights = list(/datum/world_faction/coastal_merchants = 20)
