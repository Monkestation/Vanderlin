/datum/thaumic_research_node
	var/name = "Unknown Research"
	var/desc = "A mysterious field of study."
	var/icon = 'icons/roguetown/misc/alchemy.dmi'
	var/icon_state = "essence"
	var/list/required_essences = list()
	var/list/prerequisites = list()
	var/list/unlocks = list()
	var/experience_reward = 100
	var/node_x = 0
	var/node_y = 0
	var/list/connected_nodes = list()

	var/bonus_value = 0       // The actual bonus value
	var/bonus_type = "additive" // "additive", "multiplicative", or "special"

/datum/thaumic_research_node/Destroy(force, ...)
	connected_nodes = null
	return ..()

/datum/thaumic_research_node/basic_understanding
	name = "Fundamental Thaumaturgy"
	desc = "The foundational principles of essence manipulation and magical theory. Understanding the basic flow of arcane energies is essential before attempting more complex workings."
	node_x = 140
	node_y = 340
	// No essence cost - this is the starting node
