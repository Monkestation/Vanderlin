/datum/bounty/zalad/nose_gold
	name = "Adornment Order"
	desc = "A desert chief wants golden nose rings as a gift for their kin."
	required_path = /obj/item/clothing/face/facemask/goldnosechain
	required_count = 2
	reward_reputation = 16
	reward_currency = 225
	demanded_by = NOBLEMEN
	required_reputation_tier = 1
	faction_generation_weights = list(/datum/world_faction/zalad_traders = 20)

/datum/bounty/zalad/khopesh_order
	name = "Steel Khopesh Order"
	desc = "The chief's honor guard wants new khopeshes forged."
	required_path = /obj/item/weapon/sword/scimitar/lakkarikhopesh
	required_count = 2
	reward_reputation = 14
	reward_currency = 140
	demanded_by = NOBLEMEN
	required_reputation_tier = 1
	faction_generation_weights = list(/datum/world_faction/zalad_traders = 25)
