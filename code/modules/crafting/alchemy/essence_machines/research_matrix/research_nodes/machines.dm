/datum/thaumic_research_node/machines
	abstract_type = /datum/thaumic_research_node/machines

	var/atom/machine_path

/datum/thaumic_research_node/machines/gnomes
	name = "Life Synthesis"
	desc = "Understand the principals behind life."
	prerequisites = list(/datum/thaumic_research_node/transmutation)
	required_essences = list(/datum/thaumaturgical_essence/life = 200)
	node_x = 480
	node_y = 300

	machine_path = /obj/machinery/essence/test_tube
