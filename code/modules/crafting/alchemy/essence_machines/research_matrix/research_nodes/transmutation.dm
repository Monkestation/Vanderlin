/datum/thaumic_research_node/transmutation
	name = "Essence Transmutation"
	desc = "The art of converting one type of magical essence into another through careful application of thaumic principles and controlled energy transfer. This will increase transmutation speed."
	prerequisites = list(/datum/thaumic_research_node/basic_understanding)
	required_essences = list(/datum/thaumaturgical_essence/fire = 10, /datum/thaumaturgical_essence/earth = 10)
	node_x = 140
	node_y = 480

	bonus_type = "additive"
	bonus_value = 0.35
