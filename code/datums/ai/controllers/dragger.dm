/datum/ai_controller/dragger
	movement_delay = 0.3 SECONDS
	ai_movement = /datum/ai_movement/astar
	blackboard = list(
		BB_TARGETTING_DATUM = new /datum/targetting_datum/basic/allow_items(),
		BB_DARKNESS_THRESHOLD = 3, // Threshold for considering an area "dark"
		BB_DRAGGER_HUNTING_COOLDOWN = 0,
		BB_DRAGGER_TELEPORT_COOLDOWN = 0,
		BB_DRAGGER_DRAG_COOLDOWN = 0,
		BB_DRAGGER_DUNGEONEER = TRUE,
	)
	planning_subtrees = list(
		/datum/ai_planning_subtree/dragger_hunting,
		/datum/ai_planning_subtree/simple_find_nearest_target_to_flee/dragger,
		/datum/ai_planning_subtree/flee_target/dragger,
		/datum/ai_planning_subtree/basic_melee_attack_subtree/no_flee/dragger,
		/datum/ai_planning_subtree/dragger_drag_victim
	)
	idle_behavior = /datum/idle_behavior/dragger_idle


/datum/idle_behavior/dragger_idle
	/// Chance to make creepy noises when idle
	var/noise_chance = 2
	/// Chance to sway in place when idle
	var/sway_chance = 5

/datum/idle_behavior/dragger_idle/perform_idle_behavior(delta_time, datum/ai_controller/controller)
	. = ..()
	var/mob/living/simple_animal/hostile/dragger/dragger_pawn = controller.pawn

	if(!dragger_pawn || dragger_pawn.stat != CONSCIOUS)
		return

	// Make occasional noise when idle
	if(prob(noise_chance))
		dragger_pawn.emote("growl")

	// Sway in place occasionally < I need to make a proper sway animation
	if(prob(sway_chance))
		return

