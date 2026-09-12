/datum/bounty/generic/iron_ore
	name = "Iron Shipment"
	desc = "We need raw iron ore for the smiths."
	required_path = /obj/item/ore/iron
	required_count = 8
	reward_reputation = 8
	reward_currency = 105
	demanded_by = PEASANTS

/datum/bounty/generic/coal
	name = "Coal Shipment"
	desc = "We need raw coal for the smiths."
	required_path = /obj/item/ore/coal
	required_count = 12
	reward_reputation = 8
	reward_currency = 145
	demanded_by = PEASANTS

/datum/bounty/generic/lumber
	name = "Lumber Delivery"
	desc = "Construction crews are out of timber."
	required_path = /obj/item/natural/wood/plank
	required_count = 10
	reward_reputation = 6
	reward_currency = 75
	demanded_by = PEASANTS

/datum/bounty/generic/grain_tax
	name = "Grain Tax"
	desc = "The granaries are running low before winter."
	required_path = /obj/item/reagent_containers/food/snacks/produce/grain/wheat
	required_count = 15
	reward_reputation = 10
	reward_currency = 75
	demanded_by = PEASANTS

/datum/bounty/generic/rope_order
	name = "Rope Order"
	desc = "Riggers and builders alike are short on good rope."
	required_path = /obj/item/rope
	required_count = 6
	reward_reputation = 5
	reward_currency = 60
	demanded_by = PEASANTS

/datum/bounty/generic/cloth_bolt
	name = "Weaver's Request"
	desc = "The tailors' guild needs raw cloth to keep their looms running."
	required_path = /obj/item/natural/cloth
	required_count = 10
	reward_reputation = 7
	reward_currency = 90
	demanded_by = PEASANTS

/datum/bounty/generic/parchment_order
	name = "Scribe's Order"
	desc = "The scriveners' office has run dry on parchment."
	required_path = /obj/item/paper
	required_count = 10
	reward_reputation = 5
	reward_currency = 45
	demanded_by = PEASANTS
