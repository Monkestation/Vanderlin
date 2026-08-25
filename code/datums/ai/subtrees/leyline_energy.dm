/datum/ai_planning_subtree/leyline_energy_management

/datum/ai_planning_subtree/leyline_energy_management/SelectBehaviors(datum/ai_controller/controller, seconds_per_tick)
	. = ..()
	var/energy = controller.blackboard[BB_LEYLINE_ENERGY]
	var/max_energy = controller.blackboard[BB_MAX_LEYLINE_ENERGY]
	var/regen_rate = controller.blackboard[BB_ENERGY_REGEN_RATE]

	if(energy < max_energy)
		energy = min(max_energy, energy + (regen_rate * seconds_per_tick))
		controller.set_blackboard_key(BB_LEYLINE_ENERGY, energy)

	var/obj/structure/leyline/source = controller.blackboard[BB_LEYLINE_SOURCE]
	if(!QDELETED(source))
		var/mob/living/simple_animal/hostile/retaliate/leylinelycan/lycan = controller.pawn
		if(get_dist(lycan, source) <= 3)
			energy = min(max_energy, energy + (regen_rate * seconds_per_tick))
			controller.set_blackboard_key(BB_LEYLINE_ENERGY, energy)

