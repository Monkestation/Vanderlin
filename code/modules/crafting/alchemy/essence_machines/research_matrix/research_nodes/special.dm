/datum/thaumic_research_node/gnome_hat_chance
	name = "Gnomish Perfection"
	desc = "The pinnacle of life, Gnomes with Hats. If Psydon were here to witness this, he would weep tears of joy."
	icon_state = "node"
	prerequisites = list(/datum/thaumic_research_node/gnome_speed/three, /datum/thaumic_research_node/gnome_efficency/three)
	required_essences = list(
		/datum/thaumaturgical_essence/life = 300,
		/datum/thaumaturgical_essence/magic = 100,
		/datum/thaumaturgical_essence/order = 75,
		/datum/thaumaturgical_essence/crystal = 50,
	)
	node_x = 320
	node_y = 520

	bonus_type = "special"
	bonus_value = 0.95

/datum/thaumic_research_node/resevoir_decay
	name = "Temporal Decay"
	desc = "Techniques to speed up the flow of time, letting one decay essences into waste in mere seconds."
	icon_state = "node"
	prerequisites = list(/datum/thaumic_research_node/advanced_combiner_applications)
	required_essences = list(
		/datum/thaumaturgical_essence/cycle = 40,
		/datum/thaumaturgical_essence/void = 30,
		/datum/thaumaturgical_essence/chaos = 25,
	)
	node_x = 180
	node_y = 680

/datum/thaumic_research_node/advanced_combiner_applications
	name = "Essence Fusion Mastery"
	desc = "Advanced techniques for combining different magical essences into more powerful and complex compounds. The foundation for all higher-level combination work."
	icon_state = "node"
	required_essences = list(
		/datum/thaumaturgical_essence/fire = 30,
		/datum/thaumaturgical_essence/water = 30,
		/datum/thaumaturgical_essence/earth = 30,
		/datum/thaumaturgical_essence/air = 30,
		/datum/thaumaturgical_essence/order = 20,
		/datum/thaumaturgical_essence/chaos = 20,
	)
	node_x = 300
	node_y = 840
