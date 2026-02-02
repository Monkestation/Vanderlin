/datum/ai_controller/agriopylon
	movement_delay = 0.3 SECONDS
	ai_movement = /datum/ai_movement/hybrid_pathing

	blackboard = list(
		BB_TARGETTING_DATUM = new /datum/targetting_datum/basic(),
		BB_PET_TARGETING_DATUM = new /datum/targetting_datum/basic/not_friends(),
		BB_GNOME_CROP_MODE = FALSE,
		BB_GNOME_WATER_SOURCE = null,
		BB_GNOME_COMPOST_SOURCE = null,
		BB_GNOME_SEED_SOURCE = null,
		BB_GNOME_TARGET_WELL = null,
		BB_GNOME_SEARCH_RANGE = 3,
		BB_ACTION_STATE_MANAGER = null,
		BB_AGRIOPYLON_BLESS_COOLDOWN = 0,
	)

	ai_traits = STOP_MOVING_WHEN_PULLED
	planning_subtrees = list(
		/datum/ai_planning_subtree/pet_planning,
		/datum/ai_planning_subtree/flee_target,
		/datum/ai_planning_subtree/action_state_manager,

	)

	idle_behavior = /datum/idle_behavior/bless_crops

/datum/ai_controller/agriopylon/TryPossessPawn(atom/new_pawn)
	. = ..()
	if(. & AI_CONTROLLER_INCOMPATIBLE)
		return
	var/datum/action_state_manager/state_manager = new /datum/action_state_manager()
	blackboard[BB_ACTION_STATE_MANAGER] = state_manager

