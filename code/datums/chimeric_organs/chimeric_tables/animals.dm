/datum/chimeric_table/animal
	name = "Animal"
	compatible_blood_types = list(
		/datum/blood_type/animal,
	)
	preferred_blood_types = list(
		/datum/blood_type/animal,
	)
	incompatible_blood_types = list()
	base_blood_cost = 0.4
	node_tier = 1
	node_purity_min = 30
	node_purity_max = 60

/datum/chimeric_table/troll
	name = "Troll"
	compatible_blood_types = list(
		/datum/blood_type/troll,
	)
	preferred_blood_types = list(
		/datum/blood_type/troll,
	)
	incompatible_blood_types = list()

	input_nodes = list(
		/datum/chimeric_node/input/heartbeat = 5,
		/datum/chimeric_node/input/death = -5,
	)
	output_nodes = list(
		/datum/chimeric_node/output/healing = 10,
	)

	base_blood_cost = 0.6
	node_tier = 2
	node_purity_min = 55
	node_purity_max = 80

/datum/chimeric_table/fey
	name = "Fey"
	compatible_blood_types = list(
		/datum/blood_type/fey,
	)
	preferred_blood_types = list(
		/datum/blood_type/fey,
	)
	incompatible_blood_types = list()

	input_nodes = list(
		/datum/chimeric_node/input/spell_cast = 10,
		/datum/chimeric_node/input/mana_spent = 10,
		/datum/chimeric_node/input/damage/brute = -10,
		/datum/chimeric_node/input/damage/burn = -10,
	)
	output_nodes = list(
		/datum/chimeric_node/output/wild_magic = 10,
		/datum/chimeric_node/output/status_effect = 5,
		/datum/chimeric_node/output/hallucinate = 5,
	)

	base_blood_cost = 0.8
	node_tier = 2
	node_purity_min = 55
	node_purity_max = 80

/datum/chimeric_table/lycan
	name = "Lycan"
	compatible_blood_types = list(
		/datum/blood_type/lycan,
	)
	preferred_blood_types = list(
		/datum/blood_type/lycan,
	)
	incompatible_blood_types = list()

	input_nodes = list(
		/datum/chimeric_node/input/spell_cast = 5,
		/datum/chimeric_node/input/mana_spent = 5,
		/datum/chimeric_node/input/damage/brute = 5,
		/datum/chimeric_node/input/damage/burn = 5,
	)
	output_nodes = list(
		/datum/chimeric_node/output/rewinding = 5,
		/datum/chimeric_node/output/speed = 5,
	)

	base_blood_cost = 0.3
	node_tier = 2
	node_purity_min = 30
	node_purity_max = 55

/datum/chimeric_table/putrid
	name = "Putrid"
	compatible_blood_types = list(
		/datum/blood_type/putrid,
	)
	preferred_blood_types = list(
		/datum/blood_type/putrid,
	)
	incompatible_blood_types = list()
	base_blood_cost = 0.3
	node_tier = 3
	node_purity_min = 0
	node_purity_max = 120
