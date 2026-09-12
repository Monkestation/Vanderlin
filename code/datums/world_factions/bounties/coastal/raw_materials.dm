/datum/bounty/coastal/silk_trade
	name = "Silk Trade Order"
	desc = "Silk fetches a fortune in the eastern markets."
	required_path = /obj/item/natural/silk
	required_count = 5
	reward_reputation = 15
	reward_currency = 180
	demanded_by = NOBLEMEN
	required_reputation_tier = 1
	faction_generation_weights = list(/datum/world_faction/coastal_merchants = 25)
