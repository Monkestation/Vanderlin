/datum/thaumic_research_node/splitter_efficiency
	name = "Essence Division"
	desc = "Learn to safely and more precisely divide and separate thaumic materials into their essence parts. This will increase the splitter's efficiency."
	prerequisites = list(/datum/thaumic_research_node/basic_understanding)
	required_essences = list(
		/datum/thaumaturgical_essence/fire = 5,
		/datum/thaumaturgical_essence/earth = 5,
		/datum/thaumaturgical_essence/water = 5,
		/datum/thaumaturgical_essence/life = 5,
		/datum/thaumaturgical_essence/air = 5,
		/datum/thaumaturgical_essence/order = 5,
		/datum/thaumaturgical_essence/chaos = 5,
	)
	node_x = 220
	node_y = 160

	bonus_type = "additive"
	bonus_value = 0.2

/datum/thaumic_research_node/splitter_efficiency/two
	name = "Refined Separation"
	desc = "Advanced techniques for essence splitting that achieve cleaner divisions, increasing the yield of the splitter."
	icon_state = "node"
	prerequisites = list(/datum/thaumic_research_node/splitter_efficiency)
	required_essences = list(
		/datum/thaumaturgical_essence/fire = 10,
		/datum/thaumaturgical_essence/earth = 10,
		/datum/thaumaturgical_essence/water = 10,
		/datum/thaumaturgical_essence/life = 10,
		/datum/thaumaturgical_essence/air = 10,
		/datum/thaumaturgical_essence/order = 5,
		/datum/thaumaturgical_essence/chaos = 5,
	)
	node_x = 460
	node_y = 80

	bonus_value = 0.4

/datum/thaumic_research_node/splitter_efficiency/three
	name = "Master's Division"
	desc = "Expert-level essence separation capable of isolating even the most volatile and complex essences without loss of yield."
	icon_state = "node"
	prerequisites = list(/datum/thaumic_research_node/splitter_efficiency/two)
	required_essences = list(
		/datum/thaumaturgical_essence/fire = 20,
		/datum/thaumaturgical_essence/earth = 20,
		/datum/thaumaturgical_essence/water = 20,
		/datum/thaumaturgical_essence/life = 20,
		/datum/thaumaturgical_essence/air = 20,
		/datum/thaumaturgical_essence/order = 10,
		/datum/thaumaturgical_essence/chaos = 10,
	)
	node_x = 300
	node_y = 200

	bonus_value = 0.6

/datum/thaumic_research_node/splitter_efficiency/four
	name = "Grandmaster's Cleaving"
	desc = "The pinnacle of separation arts, allowing for perfect division of any precursor while ensuring no essence is lost in the process."
	icon_state = "node"
	prerequisites = list(/datum/thaumic_research_node/splitter_efficiency/three)
	required_essences = list(
		/datum/thaumaturgical_essence/fire = 30,
		/datum/thaumaturgical_essence/earth = 30,
		/datum/thaumaturgical_essence/water = 30,
		/datum/thaumaturgical_essence/life = 30,
		/datum/thaumaturgical_essence/air = 30,
		/datum/thaumaturgical_essence/order = 20,
		/datum/thaumaturgical_essence/chaos = 20,
	)
	node_x = 260
	node_y = 320

	bonus_value = 1

/datum/thaumic_research_node/splitter_efficiency/five
	name = "Multiplied Division"
	desc = "Advanced splitting techniques that result in significant reduction of waste."
	icon_state = "node"
	prerequisites = list(/datum/thaumic_research_node/splitter_efficiency/four)
	required_essences = list(
		/datum/thaumaturgical_essence/fire = 30,
		/datum/thaumaturgical_essence/earth = 30,
		/datum/thaumaturgical_essence/water = 30,
		/datum/thaumaturgical_essence/life = 30,
		/datum/thaumaturgical_essence/air = 30,
		/datum/thaumaturgical_essence/order = 20,
		/datum/thaumaturgical_essence/chaos = 20,
		/datum/thaumaturgical_essence/magic = 10,
	)
	node_x = 400
	node_y = 200

	bonus_value = 1.5

/datum/thaumic_research_node/splitter_efficiency/six
	name = "Infinite Fragmentation"
	desc = "The ultimate splitting technique, these result in additional essence yield beyond what was deemed possible."
	icon_state = "node"
	prerequisites = list(/datum/thaumic_research_node/splitter_efficiency/five)
	required_essences = list(
		/datum/thaumaturgical_essence/fire = 30,
		/datum/thaumaturgical_essence/earth = 30,
		/datum/thaumaturgical_essence/water = 30,
		/datum/thaumaturgical_essence/life = 30,
		/datum/thaumaturgical_essence/air = 30,
		/datum/thaumaturgical_essence/order = 30,
		/datum/thaumaturgical_essence/chaos = 30,
		/datum/thaumaturgical_essence/magic = 30,
	)
	node_x = 500
	node_y = 200

	bonus_value = 2
