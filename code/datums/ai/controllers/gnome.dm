
/datum/ai_controller/basic_controller/gnome_homunculus
	max_target_distance = 300
	var/datum/action_state_manager/state_manager

	blackboard = list(
		BB_BASIC_MOB_SCARED_ITEM = /obj/item/weapon/whip,
		BB_TARGETTING_DATUM = new /datum/targetting_datum/basic(),
		BB_PET_TARGETING_DATUM = new /datum/targetting_datum/basic(),

		// Waypoints / home
		BB_GNOME_WAYPOINT_A = null,
		BB_GNOME_WAYPOINT_B = null,
		BB_GNOME_HOME_TURF = null,

		// Carry
		BB_SIMPLE_CARRY_ITEM = null,
		BB_GNOME_FOUND_ITEM = null,

		// Transport config (state is enabled when SOURCE + DEST are non-null)
		BB_GNOME_TRANSPORT_SOURCE = null,
		BB_GNOME_TRANSPORT_DEST = null,

		// Splitter config (state is enabled when TARGET_SPLITTER is non-null)
		BB_GNOME_TARGET_SPLITTER = null,

		// Farming config (state is enabled when BB_GNOME_CROP_MODE is TRUE)
		// Kept as a simple bool because farming has no single "target" object.
		BB_GNOME_CROP_MODE = FALSE,
		BB_GNOME_WATER_SOURCE = null,
		BB_GNOME_COMPOST_SOURCE = null,
		BB_GNOME_SEED_SOURCE = null,

		// Alchemy config (state is enabled when BB_GNOME_ALCHEMY_MODE is TRUE)
		BB_GNOME_ALCHEMY_MODE = FALSE,
		BB_GNOME_TARGET_CAULDRON = null,
		BB_GNOME_TARGET_WELL = null,
		BB_GNOME_CURRENT_RECIPE = null,
		BB_GNOME_ESSENCE_STORAGE = null,
		BB_GNOME_BOTTLE_STORAGE = null,

		// Shared
		BB_GNOME_SEARCH_RANGE = 1,
		BB_ACTION_STATE_MANAGER = null,
	)

	ai_traits = STOP_MOVING_WHEN_PULLED
	ai_movement = /datum/ai_movement/hybrid_pathing/gnome
	idle_behavior = /datum/idle_behavior/gnome_enhanced_idle
	planning_subtrees = list(
		/datum/ai_planning_subtree/pet_planning,
		/datum/ai_planning_subtree/simple_find_nearest_target_to_flee_has_item,
		/datum/ai_planning_subtree/flee_target,
		/datum/ai_planning_subtree/priority_action_state_manager,
	)

/datum/ai_controller/basic_controller/gnome_homunculus/TryPossessPawn(atom/new_pawn)
	. = ..()
	if(. & AI_CONTROLLER_INCOMPATIBLE)
		return

	state_manager = new /datum/action_state_manager()
	state_manager.register_signals(src)
	blackboard[BB_ACTION_STATE_MANAGER] = state_manager

	RegisterSignal(new_pawn, COMSIG_ATOM_EXAMINE, PROC_REF(on_examine))
	setup_emotion_behaviors(new_pawn)

/datum/ai_controller/basic_controller/gnome_homunculus/proc/setup_emotion_behaviors(mob/living/host)
	RegisterSignal(host, COMSIG_EMOTION_STORE, PROC_REF(on_emotion_change))
	RegisterSignal(host, COMSIG_MOVABLE_HEAR,  PROC_REF(on_hear_speech))

/datum/ai_controller/basic_controller/gnome_homunculus/proc/on_emotion_change(datum/source, atom/from, emotion, text, intensity)
	SIGNAL_HANDLER
	var/mob/living/host = pawn
	if(!host)
		return

	switch(emotion)
		if(EMOTION_HAPPY)
			movement_delay = max(movement_delay - 1, 1)
		if(EMOTION_SAD, EMOTION_SCARED)
			movement_delay += 2
		if(EMOTION_ANGER)
			// Angry gnomes become uncooperative disable farming and alchemy.
			if(prob(25))
				blackboard[BB_GNOME_CROP_MODE] = FALSE
				blackboard[BB_GNOME_ALCHEMY_MODE] = FALSE
				// No transport/splitter bool to clear; those are driven by target presence.
				// Notify manager so it re-evaluates immediately.
				if(state_manager)
					state_manager.notify_priority_change()

/datum/ai_controller/basic_controller/gnome_homunculus/proc/on_hear_speech(datum/source, mob/living/speaker, message)
	SIGNAL_HANDLER
	var/mob/living/simple_animal/hostile/gnome_homunculus/host = pawn
	if(!host || speaker == host)
		return

	var/friendship_check = SEND_SIGNAL(host, COMSIG_FRIENDSHIP_CHECK_LEVEL, speaker, "friend")
	if(!friendship_check)
		return

	var/datum/component/emotion_buffer/emotions = host.GetComponent(/datum/component/emotion_buffer)
	if(!emotions || emotions.current_emotion != EMOTION_HAPPY)
		return

	var/static/list/boring_words = list(
		"the","and","but","for","you","are","not","can","get","put",
		"all","any","new","now","old","see","two","way","who","boy",
		"did","its","let","own","say","she","too","use"
	)
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

	if(state_manager)
		examine_list += span_notice("Current task: [state_manager.get_state_name()]")

		// Show each state and its cached priority so players can debug.
		for(var/state_name in state_manager.available_states)
			var/datum/action_state/state = state_manager.available_states[state_name]
			var/priority = state.cached_priority
			if(priority > GNOME_PRIORITY_NONE)
				examine_list += span_notice(" - [state_name]: priority [priority]")

/datum/ai_planning_subtree/priority_action_state_manager/SelectBehaviors(datum/ai_controller/controller, delta_time)
	var/datum/action_state_manager/manager = controller.blackboard[BB_ACTION_STATE_MANAGER]
	if(!manager)
		return

	if(manager.process_machine(controller, delta_time))
		return SUBTREE_RETURN_FINISH_PLANNING
