
/datum/thaumic_research_node/gnome_speed
	name = "Improved Essence Incorporation"
	desc = "Improves the speed at which life essences coalesce to form life."
	icon_state = "node"
	prerequisites = list(/datum/thaumic_research_node/machines/gnomes)
	required_essences = list(
		/datum/thaumaturgical_essence/life = 20,
		/datum/thaumaturgical_essence/motion = 10,
	)
	node_x = 340
	node_y = 420

	bonus_type = "additive"
	bonus_value = 0.33

/datum/thaumic_research_node/gnome_speed/two
	name = "Enhanced Essence Incorporation"
	desc = "Further improves the speed at which life essences coalesce into gnomes."
	icon_state = "node"
	prerequisites = list(/datum/thaumic_research_node/gnome_speed)
	required_essences = list(
		/datum/thaumaturgical_essence/life = 30,
		/datum/thaumaturgical_essence/motion = 15,
		/datum/thaumaturgical_essence/energia = 10,
	)
	node_x = 220
	node_y = 480

	bonus_value = 0.50

/datum/thaumic_research_node/gnome_speed/three
	name = "Perfected Essence Incorporation"
	desc = "Maximizes the speed at which life essences coalesce."
	icon_state = "node"
	prerequisites = list(/datum/thaumic_research_node/gnome_speed/two)
	required_essences = list(
		/datum/thaumaturgical_essence/life = 50,
		/datum/thaumaturgical_essence/motion = 25,
		/datum/thaumaturgical_essence/energia = 15,
		/datum/thaumaturgical_essence/cycle = 20,
	)
	node_x = 160
	node_y = 600

	bonus_value = 0.75
