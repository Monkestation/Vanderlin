/datum/thaumic_research_node/gnome_efficency
	name = "Improved Essence Handling"
	desc = "Reduces the essence needed to form gnomish life."
	icon_state = "node"
	prerequisites = list(/datum/thaumic_research_node/machines/gnomes)
	required_essences = list(
		/datum/thaumaturgical_essence/life = 50,
		/datum/thaumaturgical_essence/order = 25,
	)
	node_x = 420
	node_y = 440

	bonus_type = "multiplicative"
	bonus_value = 0.1

/datum/thaumic_research_node/gnome_efficency/two
	name = "Advanced Essence Handling"
	desc = "Further reduces the amount of life essence needed to form life."
	icon_state = "node"
	prerequisites = list(/datum/thaumic_research_node/gnome_efficency)
	required_essences = list(
		/datum/thaumaturgical_essence/life = 75,
		/datum/thaumaturgical_essence/order = 40,
		/datum/thaumaturgical_essence/void = 20,
	)
	node_x = 440
	node_y = 540

	bonus_value = 0.2

/datum/thaumic_research_node/gnome_efficency/three
	name = "Masterful Essence Handling"
	desc = "Greatly reduces the amount of life essence needed to form life."
	icon_state = "node"
	prerequisites = list(/datum/thaumic_research_node/gnome_efficency/two)
	required_essences = list(
		/datum/thaumaturgical_essence/life = 100,
		/datum/thaumaturgical_essence/order = 60,
		/datum/thaumaturgical_essence/crystal = 30,
	)
	node_x = 520
	node_y = 600

	bonus_value = 0.2
