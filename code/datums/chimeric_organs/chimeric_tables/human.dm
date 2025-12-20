/datum/chimeric_table/human
	name = "Human"
	compatible_blood_types = list(
		/datum/blood_type/human,
	)
	preferred_blood_types = list(
		/datum/blood_type/human,
	)
	incompatible_blood_types = list()

	base_blood_cost = 0.3
	node_tier = 1
	node_purity_min = 30
	node_purity_max = 45

/datum/chimeric_table/rakshari
	name = "Rakshari"
	compatible_blood_types = list(
		/datum/blood_type/human/rakshari,
	)
	preferred_blood_types = list(
		/datum/blood_type/human/rakshari,
	)
	input_nodes = list(
		/datum/chimeric_node/input/fall = 10
	)
	incompatible_blood_types = list()
	base_blood_cost = 0.3
	node_tier = 1
	node_purity_min = 30
	node_purity_max = 45

/datum/chimeric_table/kobold
	name = "Kobold"
	compatible_blood_types = list(
		/datum/blood_type/human/kobold,
	)
	preferred_blood_types = list(
		/datum/blood_type/human/kobold,
	)
	incompatible_blood_types = list()
	output_nodes = list(
		/datum/chimeric_node/output/blasting = 10,
	)
	special_nodes = list(
		/datum/chimeric_node/special/tiny = 20,
	)
	base_blood_cost = 0.3
	node_tier = 1
	node_purity_min = 30
	node_purity_max = 45

/datum/chimeric_table/tiefling
	name = "Tiefling"
	compatible_blood_types = list(
		/datum/blood_type/human/tiefling,
	)
	preferred_blood_types = list(
		/datum/blood_type/human/tiefling,
	)
	incompatible_blood_types = list()

	input_nodes = list(
		/datum/chimeric_node/input/damage/burn = 10
	)

	base_blood_cost = 0.45
	node_tier = 2
	node_purity_min = 30
	node_purity_max = 45

/datum/chimeric_table/demihuman
	name = "Demihuman"
	compatible_blood_types = list(
		/datum/blood_type/human/demihuman,
	)
	preferred_blood_types = list(
		/datum/blood_type/human/demihuman,
	)
	input_nodes = list(
		/datum/chimeric_node/input/damage/brute = 10
	)

	incompatible_blood_types = list()
	base_blood_cost = 0.3
	node_tier = 1
	node_purity_min = 30
	node_purity_max = 45

/datum/chimeric_table/horc
	name = "Half-Orc"
	compatible_blood_types = list(
		/datum/blood_type/human/horc,
	)
	preferred_blood_types = list(
		/datum/blood_type/human/horc,
	)
	input_nodes = list(
		/datum/chimeric_node/input/gluttony/organ = 10
	)
	incompatible_blood_types = list()
	base_blood_cost = 0.3
	node_tier = 1
	node_purity_min = 30
	node_purity_max = 45

/datum/chimeric_table/triton
	name = "Triton"
	compatible_blood_types = list(
		/datum/blood_type/human/triton,
	)
	preferred_blood_types = list(
		/datum/blood_type/human/triton,
	)
	input_nodes = list(
		/datum/chimeric_node/input/reagent = 5
	)
	output_nodes = list(
		/datum/chimeric_node/output/liquid = 5
	)
	incompatible_blood_types = list()
	base_blood_cost = 0.3
	node_tier = 1
	node_purity_min = 30
	node_purity_max = 45

/datum/chimeric_table/medicator
	name = "Medicator"
	compatible_blood_types = list(
		/datum/blood_type/human/medicator,
	)
	preferred_blood_types = list(
		/datum/blood_type/human/medicator,
	)
	input_nodes = list(
		/datum/chimeric_node/input/reagent/blood = 5
	)
	incompatible_blood_types = list()
	base_blood_cost = 0.3
	node_tier = 1
	node_purity_min = 30
	node_purity_max = 45

/datum/chimeric_table/delf
	name = "Dark Elf"
	compatible_blood_types = list(
		/datum/blood_type/human/delf,
	)
	preferred_blood_types = list(
		/datum/blood_type/human/delf,
	)
	incompatible_blood_types = list()

	input_nodes = list(
		/datum/chimeric_node/input/racist = 5
	)

	base_blood_cost = 0.3
	node_tier = 1
	node_purity_min = 30
	node_purity_max = 45

/datum/chimeric_table/cursed_elf
	name = "Cursed Elf"
	compatible_blood_types = list(
		/datum/blood_type/human/cursed_elf,
	)
	preferred_blood_types = list(
		/datum/blood_type/human/cursed_elf,
	)
	incompatible_blood_types = list()

	input_nodes = list(
		/datum/chimeric_node/input/racist = 5
	)

	base_blood_cost = 0.3
	node_tier = 1
	node_purity_min = 30
	node_purity_max = 45

/datum/chimeric_table/elf
	name = "Elf"
	compatible_blood_types = list(
		/datum/blood_type/human/elf,
	)
	preferred_blood_types = list(
		/datum/blood_type/human/elf,
	)
	incompatible_blood_types = list()

	input_nodes = list(
		/datum/chimeric_node/input/racist = 5
	)

	base_blood_cost = 0.3
	node_tier = 1
	node_purity_min = 30
	node_purity_max = 45

/datum/chimeric_table/dwarf
	name = "Dwarf"
	compatible_blood_types = list(
		/datum/blood_type/human/dwarf,
	)
	preferred_blood_types = list(
		/datum/blood_type/human/dwarf,
	)
	incompatible_blood_types = list()

	input_nodes = list(
		/datum/chimeric_node/input/racist/elf = 5
	)

	base_blood_cost = 0.3
	node_tier = 1
	node_purity_min = 30
	node_purity_max = 45

/datum/chimeric_table/rousman
	name = "Rousman"
	compatible_blood_types = list(
		/datum/blood_type/human/corrupted/rousman,
	)
	preferred_blood_types = list(
		/datum/blood_type/human/corrupted/rousman,
	)
	incompatible_blood_types = list()

	input_nodes = list(
		/datum/chimeric_node/input/sunlight = 10,
		/datum/chimeric_node/input/gluttony = 5,
		/datum/chimeric_node/input/gluttony/cheese = 10,
	)

	base_blood_cost = 0.3
	node_tier = 1
	node_purity_min = 30
	node_purity_max = 45

/datum/chimeric_table/goblin
	name = "Goblin"
	compatible_blood_types = list(
		/datum/blood_type/human/corrupted/goblin,
	)
	preferred_blood_types = list(
		/datum/blood_type/human/corrupted/goblin,
	)
	incompatible_blood_types = list()

	input_nodes = list(
		/datum/chimeric_node/input/accumlated_damage = 10,
	)

	base_blood_cost = 0.3
	node_tier = 1
	node_purity_min = 30
	node_purity_max = 45

/datum/chimeric_table/orc
	name = "Orc"
	compatible_blood_types = list(
		/datum/blood_type/human/corrupted/orc,
	)
	preferred_blood_types = list(
		/datum/blood_type/human/corrupted/orc,
	)
	incompatible_blood_types = list()

	input_nodes = list(
		/datum/chimeric_node/input/accumlated_damage = 10,
		/datum/chimeric_node/input/bleeding = 5,
		/datum/chimeric_node/input/wounded = 10,
	)

	base_blood_cost = 0.3
	node_tier = 1
	node_purity_min = 30
	node_purity_max = 45
