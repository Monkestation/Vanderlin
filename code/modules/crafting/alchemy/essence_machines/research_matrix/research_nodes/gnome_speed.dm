
/datum/thaumic_research_node/gnome_speed
	name = "Improved Essence Incorporation"
	desc = "Improves the speed at which life essences coalesce to form life."
	icon_state = "node"
	prerequisites = list(/datum/thaumic_research_node/machines/gnomes)
	required_essences = list(
		/datum/thaumaturgical_essence/life = 50,
		/datum/thaumaturgical_essence/motion = 25,
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
		/datum/thaumaturgical_essence/life = 75,
		/datum/thaumaturgical_essence/motion = 40,
		/datum/thaumaturgical_essence/energia = 25,
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
		/datum/thaumaturgical_essence/life = 100,
		/datum/thaumaturgical_essence/motion = 60,
		/datum/thaumaturgical_essence/energia = 40,
		/datum/thaumaturgical_essence/cycle = 30,
	)
	node_x = 160
	node_y = 600

	bonus_value = 0.75
