//! Once we have actual nations this should be snapped away in favor of SSmerchants.nations[nation_type]
//! This is legit just to show what stuff is like

/datum/trade_agreement/test_request
	name = "I am Pibble"
	desc = "Wash my belly"

	possible_items = list(/obj/item/soap)
	picked_item_count = 1
	mammon_reward = 100

/datum/trade/node_1_1
	name = "Soap Discovery"
	required_trades = list()

/datum/trade/node_1_2
	name = "Basic Hygiene"
	required_trades = list()

/datum/trade/node_1_3
	name = "Water Management"
	required_trades = list()

/datum/trade/node_1_4
	name = "Scent Profiles"
	required_trades = list()

/datum/trade/node_1_5
	name = "Lathering Basics"
	required_trades = list()

/datum/trade/node_2_1
	name = "Industrial Scrubbing"
	required_trades = list(/datum/trade/node_1_1)

/datum/trade/node_2_2
	name = "Laundry Services"
	required_trades = list(/datum/trade/node_1_2)

/datum/trade/node_2_3
	name = "Medical Sanitation"
	required_trades = list(/datum/trade/node_1_2)

/datum/trade/node_2_4
	name = "Perfumed Oils"
	required_trades = list(/datum/trade/node_1_4)

/datum/trade/node_2_5
	name = "Bubble Dynamics"
	required_trades = list(/datum/trade/node_1_5)

/datum/trade/node_3_1
	name = "Heavy Duty Degreaser"
	required_trades = list(/datum/trade/node_2_1)

/datum/trade/node_3_2
	name = "Surgical Scrub"
	required_trades = list(/datum/trade/node_2_3)

/datum/trade/node_3_3
	name = "Universal Solvent"
	required_trades = list(/datum/trade/node_1_3)

/datum/trade/node_3_4
	name = "Luxury Aromatherapy"
	required_trades = list(/datum/trade/node_2_4)

/datum/trade/node_3_5
	name = "Soap Carving"
	required_trades = list(/datum/trade/node_2_5)

/datum/trade/node_4_1
	name = "Bio-Clean Protocols"
	required_trades = list(/datum/trade/node_3_1, /datum/trade/node_3_2)

/datum/trade/node_4_2
	name = "Antiseptic Mastery"
	required_trades = list(/datum/trade/node_3_2)

/datum/trade/node_4_3
	name = "Chemical Synthesis"
	required_trades = list(/datum/trade/node_3_3)

/datum/trade/node_4_4
	name = "Eternal Fragrance"
	required_trades = list(/datum/trade/node_3_4)

/datum/trade/node_4_5
	name = "Surface Tension Elite"
	required_trades = list(/datum/trade/node_3_5)

/datum/trade/node_5_1
	name = "Absolute Sterility"
	required_trades = list(/datum/trade/node_4_1)

/datum/trade/node_5_2
	name = "Molecular Purification"
	required_trades = list(/datum/trade/node_4_2, /datum/trade/node_4_3)

/datum/trade/node_5_3
	name = "The Great Cleanse"
	required_trades = list(/datum/trade/node_4_3)

/datum/trade/node_5_4
	name = "Transcendent Suds"
	required_trades = list(/datum/trade/node_4_4)

/datum/trade/node_5_5
	name = "Omega Hygiene"
	required_trades = list(/datum/trade/node_4_5)

/datum/nation/debug_showcase
	nodes = list(
		/datum/trade/node_1_1, /datum/trade/node_1_2, /datum/trade/node_1_3, /datum/trade/node_1_4, /datum/trade/node_1_5,
		/datum/trade/node_2_1, /datum/trade/node_2_2, /datum/trade/node_2_3, /datum/trade/node_2_4, /datum/trade/node_2_5,
		/datum/trade/node_3_1, /datum/trade/node_3_2, /datum/trade/node_3_3, /datum/trade/node_3_4, /datum/trade/node_3_5,
		/datum/trade/node_4_1, /datum/trade/node_4_2, /datum/trade/node_4_3, /datum/trade/node_4_4, /datum/trade/node_4_5,
		/datum/trade/node_5_1, /datum/trade/node_5_2, /datum/trade/node_5_3, /datum/trade/node_5_4, /datum/trade/node_5_5
	)

	possible_trade_requests = list(/datum/trade_agreement/test_request)

/mob/proc/show_trade_showcase()
	var/datum/nation/debug_showcase/nation = new()
	nation.open_trade_ui(src)
