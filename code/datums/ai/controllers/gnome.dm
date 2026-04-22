
/datum/ai_controller/basic_controller/gnome_homunculus
	max_target_distance = 300
	var/datum/action_state_manager/state_manager

	blackboard = list(
		BB_BASIC_MOB_SCARED_ITEM = /obj/item/weapon/whip,
		BB_TARGETTING_DATUM = new /datum/targetting_datum/basic(),
		BB_PET_TARGETING_DATUM = new /datum/targetting_datum/basic(),
		BB_GNOME_WAYPOINT_A = null,
		BB_GNOME_WAYPOINT_B = null,
		BB_GNOME_HOME_TURF = null,
		BB_SIMPLE_CARRY_ITEM = null,
		BB_GNOME_TRANSPORT_MODE = FALSE,
		BB_GNOME_TRANSPORT_SOURCE = null,
		BB_GNOME_TRANSPORT_DEST = null,
		BB_GNOME_SPLITTER_MODE = FALSE,
		BB_GNOME_TARGET_SPLITTER = null,
		BB_GNOME_FOUND_ITEM = null,
		BB_GNOME_CROP_MODE = FALSE,
		BB_GNOME_WATER_SOURCE = null,
		BB_GNOME_COMPOST_SOURCE = null,
		BB_GNOME_SEED_SOURCE = null,
		BB_GNOME_ALCHEMY_MODE = FALSE,
		BB_GNOME_TARGET_CAULDRON = null,
		BB_GNOME_TARGET_WELL = null,
		BB_GNOME_CURRENT_RECIPE = null,
		BB_GNOME_ALCHEMY_STATE = ALCHEMY_STATE_IDLE,
		BB_GNOME_ESSENCE_STORAGE = null,
		BB_GNOME_BOTTLE_STORAGE = null,
		BB_GNOME_SEARCH_RANGE = 1,
		BB_ACTION_STATE_MANAGER = null
	)

	ai_traits = STOP_MOVING_WHEN_PULLED
	ai_movement = /datum/ai_movement/hybrid_pathing/gnome
	idle_behavior = /datum/idle_behavior/gnome_enhanced_idle
	planning_subtrees = list(
		/datum/ai_planning_subtree/pet_planning,
		/datum/ai_planning_subtree/simple_find_nearest_target_to_flee_has_item,
		/datum/ai_planning_subtree/flee_target,
		/datum/ai_planning_subtree/action_state_manager,
	)

/datum/ai_controller/basic_controller/gnome_homunculus/TryPossessPawn(atom/new_pawn)
	. = ..()
	if(. & AI_CONTROLLER_INCOMPATIBLE)
		return

	state_manager = new /datum/action_state_manager()
	blackboard[BB_ACTION_STATE_MANAGER] = state_manager

	RegisterSignal(new_pawn, COMSIG_ATOM_EXAMINE, PROC_REF(on_examine))

	setup_emotion_behaviors(new_pawn)

/datum/ai_controller/basic_controller/gnome_homunculus/proc/setup_emotion_behaviors(mob/living/host)
	// Register for emotional events to modify AI behavior
	RegisterSignal(host, COMSIG_EMOTION_STORE, PROC_REF(on_emotion_change))

	// Register for hearing speech to learn words
	RegisterSignal(host, COMSIG_MOVABLE_HEAR, PROC_REF(on_hear_speech))

/datum/ai_controller/basic_controller/gnome_homunculus/proc/on_emotion_change(datum/source, atom/from, emotion, text, intensity)
	SIGNAL_HANDLER
	var/mob/living/host = pawn
	if(!host)
		return

	// Modify gnome behavior based on emotional state
	switch(emotion)
		if(EMOTION_HAPPY)
			// Happy gnomes work faster and are more helpful
			movement_delay = max(movement_delay - 1, 1)
		if(EMOTION_SAD, EMOTION_SCARED)
			// Sad/scared gnomes move slower and might hide
			movement_delay += 2
		if(EMOTION_ANGER)
			// Angry gnomes might be less cooperative
			if(prob(25))
				blackboard[BB_GNOME_TRANSPORT_MODE] = FALSE
				blackboard[BB_GNOME_CROP_MODE] = FALSE

/datum/ai_controller/basic_controller/gnome_homunculus/proc/on_hear_speech(datum/source, mob/living/speaker, message)
	SIGNAL_HANDLER
	var/mob/living/simple_animal/hostile/gnome_homunculus/host = pawn
	if(!host || speaker == host)
		return

	// Check if speaker is a friend or better
	var/friendship_check = SEND_SIGNAL(host, COMSIG_FRIENDSHIP_CHECK_LEVEL, speaker, "friend")
	if(!friendship_check)
		return

	// If we're happy, learn words from friends
	var/datum/component/emotion_buffer/emotions = host.GetComponent(/datum/component/emotion_buffer)
	if(!emotions || emotions.current_emotion != EMOTION_HAPPY)
		return

	var/static/list/boring_words = list("the", "and", "but", "for", "you", "are", "not", "can", "get", "put", "all", "any", "new", "now", "old", "see", "two", "way", "who", "boy", "did", "its", "let", "own", "say", "she", "too", "use")
	var/list/words = splittext(lowertext(message), " ")

	for(var/word in words)
		word = trim(word)
		if(length(word) > 3 && !(word in boring_words))
			host.learned_words[word] = (host.learned_words[word] || 0) + 1
			if(host.learned_words[word] >= 2 && prob(15))
				addtimer(CALLBACK(host, TYPE_PROC_REF(/atom/movable, say), word), rand(5, 30) SECONDS)
				break

/datum/ai_controller/basic_controller/gnome_homunculus/proc/on_examine(atom/source, mob/user, list/examine_list)
	SIGNAL_HANDLER
	var/mob/living/simple_animal/hostile/gnome_homunculus/gnome = source
	var/obj/item/carried_item = blackboard[BB_SIMPLE_CARRY_ITEM]

	if(carried_item)
		examine_list += span_notice("It is carrying [carried_item].")
	if(length(gnome.waypoints))
		examine_list += span_notice("It has [length(gnome.waypoints)] waypoint[length(gnome.waypoints) > 1 ? "s" : ""] set.")

	// Show current state
	if(state_manager)
		examine_list += span_notice("Current state: [state_manager.get_state_name()]")



/datum/ai_planning_subtree/action_state_manager/SelectBehaviors(datum/ai_controller/controller, delta_time)
	var/datum/action_state_manager/manager = controller.blackboard[BB_ACTION_STATE_MANAGER]

	if(!manager)
		return

	if(controller.blackboard[BB_GNOME_TRANSPORT_MODE] && manager.get_state_name() != "transport")
		manager.queue_state("transport")
	else if(controller.blackboard[BB_GNOME_CROP_MODE] && manager.get_state_name() != "farming")
		manager.queue_state("farming")
	else if(controller.blackboard[BB_GNOME_ALCHEMY_MODE] && manager.get_state_name() != "alchemy")
		manager.queue_state("alchemy")
	else if(controller.blackboard[BB_GNOME_SPLITTER_MODE] && manager.get_state_name() != "splitter")
		manager.queue_state("splitter")

	if(manager.process_machine(controller, delta_time))
		return SUBTREE_RETURN_FINISH_PLANNING

/datum/ai_planning_subtree/goap_action_state_manager/SelectBehaviors(datum/ai_controller/controller, delta_time)
	var/datum/action_state_manager/manager = controller.blackboard[BB_ACTION_STATE_MANAGER]
	if(!manager)
		return

	var/best_state = null
	var/lowest_cost = INFINITY

	for(var/state_name in manager.available_states)
		if(state_name == "idle")
			continue

		var/datum/action_state/state = manager.available_states[state_name]

		if(state.can_execute(controller) && state.get_cost(controller) < lowest_cost)
			lowest_cost = state.get_cost(controller)
			best_state = state_name

	if(best_state && manager.get_state_name() != best_state)
		manager.queue_state(best_state)

	if(manager.process_machine(controller, delta_time))
		return SUBTREE_RETURN_FINISH_PLANNING
