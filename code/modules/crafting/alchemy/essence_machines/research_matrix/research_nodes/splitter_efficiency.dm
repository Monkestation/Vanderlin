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
		/datum/thaumaturgical_essence/fire = 15,
		/datum/thaumaturgical_essence/earth = 15,
		/datum/thaumaturgical_essence/water = 15,
		/datum/thaumaturgical_essence/life = 15,
		/datum/thaumaturgical_essence/air = 15,
		/datum/thaumaturgical_essence/order = 15,
		/datum/thaumaturgical_essence/chaos = 15,
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
		/datum/thaumaturgical_essence/fire = 45,
		/datum/thaumaturgical_essence/earth = 45,
		/datum/thaumaturgical_essence/water = 45,
		/datum/thaumaturgical_essence/life = 45,
		/datum/thaumaturgical_essence/air = 45,
		/datum/thaumaturgical_essence/order = 45,
		/datum/thaumaturgical_essence/chaos = 45,
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
		/datum/thaumaturgical_essence/fire = 100,
		/datum/thaumaturgical_essence/earth = 100,
		/datum/thaumaturgical_essence/water = 100,
		/datum/thaumaturgical_essence/life = 100,
		/datum/thaumaturgical_essence/air = 100,
		/datum/thaumaturgical_essence/order = 100,
		/datum/thaumaturgical_essence/chaos = 100,
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
		/datum/thaumaturgical_essence/fire = 100,
		/datum/thaumaturgical_essence/earth = 100,
		/datum/thaumaturgical_essence/water = 100,
		/datum/thaumaturgical_essence/life = 100,
		/datum/thaumaturgical_essence/air = 100,
		/datum/thaumaturgical_essence/order = 100,
		/datum/thaumaturgical_essence/chaos = 100,
		/datum/thaumaturgical_essence/magic = 50,
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
		/datum/thaumaturgical_essence/fire = 100,
		/datum/thaumaturgical_essence/earth = 100,
		/datum/thaumaturgical_essence/water = 100,
		/datum/thaumaturgical_essence/life = 100,
		/datum/thaumaturgical_essence/air = 100,
		/datum/thaumaturgical_essence/order = 100,
		/datum/thaumaturgical_essence/chaos = 100,
		/datum/thaumaturgical_essence/magic = 100,
	)
	node_x = 500
	node_y = 200

	bonus_value = 2
