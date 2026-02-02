/datum/thaumic_research_node/combiner_speed
	name = "Swift Fusion"
	desc = "Accelerate the essence combination process through improved channeling techniques and optimized magical flow patterns."
	prerequisites = list(/datum/thaumic_research_node/advanced_combiner_applications)
	required_essences = list(
		/datum/thaumaturgical_essence/motion = 20,
		/datum/thaumaturgical_essence/energia = 15,
		/datum/thaumaturgical_essence/fire = 10,
	)
	node_x = 280
	node_y = 700

	bonus_type = "additive"
	bonus_value = 0.35

/datum/thaumic_research_node/combiner_speed/two
	name = "Rapid Synthesis"
	desc = "Further acceleration of the essence combination processes through advanced magical circuitry and enhanced essence bonding techniques."
	icon_state = "node"
	prerequisites = list(/datum/thaumic_research_node/combiner_speed)
	required_essences = list(
		/datum/thaumaturgical_essence/motion = 35,
		/datum/thaumaturgical_essence/energia = 30,
		/datum/thaumaturgical_essence/cycle = 20,
	)
	node_x = 360
	node_y = 800

	bonus_value = 0.6

/datum/thaumic_research_node/combiner_speed/three
	name = "Instantaneous Fusion"
	desc = "Near-instantaneous essence combination achieved through mastery of temporal acceleration and perfected synthesis methods."
	icon_state = "node"
	prerequisites = list(/datum/thaumic_research_node/combiner_output/two)
	required_essences = list(
		/datum/thaumaturgical_essence/motion = 50,
		/datum/thaumaturgical_essence/energia = 45,
		/datum/thaumaturgical_essence/cycle = 35,
		/datum/thaumaturgical_essence/magic = 25,
	)
	node_x = 520
	node_y = 780

	bonus_value = 1

/datum/thaumic_research_node/combiner_speed/four
	name = "Transcendent Velocity"
	desc = "Achieve combination speeds that transcend normal temporal limitations through mastery of advanced magical acceleration."
	icon_state = "node"
	prerequisites = list(/datum/thaumic_research_node/combiner_output/three)
	required_essences = list(
		/datum/thaumaturgical_essence/motion = 75,
		/datum/thaumaturgical_essence/energia = 60,
		/datum/thaumaturgical_essence/cycle = 50,
		/datum/thaumaturgical_essence/magic = 40,
		/datum/thaumaturgical_essence/void = 25,
	)
	node_x = 340
	node_y = 640

	bonus_value = 1.5

/datum/thaumic_research_node/combiner_speed/five
	name = "Eternal Swiftness"
	desc = "The ultimate in combination speed, allowing for continuous, instantaneous essence fusion processes that operate beyond time itself."
	icon_state = "node"
	prerequisites = list(/datum/thaumic_research_node/combiner_output/four)
	required_essences = list(
		/datum/thaumaturgical_essence/motion = 100,
		/datum/thaumaturgical_essence/energia = 85,
		/datum/thaumaturgical_essence/cycle = 75,
		/datum/thaumaturgical_essence/magic = 60,
		/datum/thaumaturgical_essence/void = 50,
		/datum/thaumaturgical_essence/chaos = 40,
	)
	node_x = 560
	node_y = 680

	bonus_value = 2
