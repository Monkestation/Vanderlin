/datum/bounty/dwarf/pick_order
	name = "Clan Pick Requisition"
	desc = "The deep tunnels are eating through pickaxes faster than the smiths can make them."
	required_path = /obj/item/weapon/pick
	required_count = 8
	reward_reputation = 25
	reward_currency = 180
	demanded_by = PEASANTS
	supply_pack_modifiers = list(
		/datum/supply_pack/rawmats/copper = 0.95,
		/datum/supply_pack/rawmats/tin = 0.95,
		/datum/supply_pack/rawmats/coal = 0.95,
		/datum/supply_pack/rawmats/iron = 0.95,
	)
