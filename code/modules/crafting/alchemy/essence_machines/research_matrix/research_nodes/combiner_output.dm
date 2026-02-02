
/datum/thaumic_research_node/combiner_output
	name = "Enhanced Yield"
	desc = "Techniques to increase the quantity of combined essences produced from each fusion process without a sacrifice in yield."
	prerequisites = list(/datum/thaumic_research_node/advanced_combiner_applications)
	required_essences = list(
		/datum/thaumaturgical_essence/crystal = 25,
		/datum/thaumaturgical_essence/order = 20,
		/datum/thaumaturgical_essence/earth = 15,
	)
	node_x = 520
	node_y = 880

	bonus_type = "additive"
	bonus_value = 0.3

/datum/thaumic_research_node/combiner_output/two
	name = "Amplified Production"
	desc = "Advanced methods for maximizing essence combination output through improved channeling efficiency and reduced waste."
	icon_state = "node"
	prerequisites = list(/datum/thaumic_research_node/combiner_output)
	required_essences = list(
		/datum/thaumaturgical_essence/crystal = 40,
		/datum/thaumaturgical_essence/order = 35,
		/datum/thaumaturgical_essence/life = 20,
	)
	node_x = 700
	node_y = 840

	bonus_value = 0.5

/datum/thaumic_research_node/combiner_output/three
	name = "Abundance Creation"
	desc = "Master-level techniques for achieving extraordinary yields from essence combination processes while maintaining perfect efficiency."
	icon_state = "node"
	prerequisites = list(/datum/thaumic_research_node/combiner_output/two)
	required_essences = list(
		/datum/thaumaturgical_essence/crystal = 60,
		/datum/thaumaturgical_essence/order = 50,
		/datum/thaumaturgical_essence/life = 40,
		/datum/thaumaturgical_essence/magic = 30,
	)
	node_x = 860
	node_y = 760

	bonus_value = 0.8

/datum/thaumic_research_node/combiner_output/four
	name = "Infinite Synthesis"
	desc = "The pinnacle of combination arts, allowing for theoretically unlimited output from minimal input through perfect efficiency mastery."
	icon_state = "node"
	prerequisites = list(/datum/thaumic_research_node/combiner_output/three)
	required_essences = list(
		/datum/thaumaturgical_essence/crystal = 100,
		/datum/thaumaturgical_essence/magic = 75,
		/datum/thaumaturgical_essence/void = 50,
		/datum/thaumaturgical_essence/chaos = 50,
	)
	node_x = 660
	node_y = 740

	bonus_value = 1.2
