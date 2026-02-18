/*
AI controllers are a datumized form of AI that simulates the input a player would otherwise give to a atom. What this means is that these datums
have ways of interacting with a specific atom and control it. They posses a blackboard with the information the AI knows and has, and will plan behaviors it will try to execute.
*/
/datum/ai_controller
	///The atom this controller is controlling
	var/atom/pawn
	/**
	 * This is a list of variables the AI uses and can be mutated by actions.
	 *
	 * When an action is performed you pass this list and any relevant keys for the variables it can mutate.
	 *
	 * DO NOT set values in the blackboard directly, and especially not if you're adding a datum reference to this!
	 * Use the setters, this is important for reference handing.
	 */
	var/list/blackboard = list()
	///Bitfield of traits for this AI to handle extra behavior
	var/ai_traits
	///Current actions planned to be performed by the AI in the upcoming plan
	var/list/planned_behaviors
	///Current actions being performed by the AI.
	var/list/current_behaviors
	///Current actions and their respective last time ran as an assoc list.
	var/list/behavior_cooldowns = list()
	///The idle behavior this AI performs when it has no actions.
	var/datum/idle_behavior/idle_behavior = null
	///our current cell grid
	var/datum/cell_tracker/our_cells
	///Current status of AI (OFF/ON/IDLE)
	var/ai_status
	///Current movement target of the AI, generally set by decision making.
	var/atom/current_movement_target
	///Identifier for what last touched our movement target, so it can be cleared conditionally
	var/movement_target_source
	///Stored arguments for behaviors given during their initial creation
	var/list/behavior_args = list()
	///Tracks recent pathing attempts, if we fail too many in a row we fail our current plans.
	var/pathing_attempts
	///Can the AI remain in control if there is a client?
	var/continue_processing_when_client = FALSE
	///distance to give up on target
	var/max_target_distance = 14
	///Cooldown for new plans, to prevent AI from going nuts if it can't think of new plans and looping on end
	COOLDOWN_DECLARE(failed_planning_cooldown)
	///All subtrees this AI has available, will run them in order, so make sure they're in the order you want them to run. On initialization of this type, it will start as a typepath(s) and get converted to references of ai_subtrees found in SSai_controllers when init_subtrees() is called
	var/list/planning_subtrees
	// Movement related things here
	///Reference to the movement datum we use. Is a type on initialize but becomes a ref afterwards.
	var/datum/ai_movement/ai_movement = /datum/ai_movement/dumb
	///Cooldown until next movement
	COOLDOWN_DECLARE(movement_cooldown)
	///Delay between movements. This is on the controller so we can keep the movement datum singleton
	var/movement_delay = 0.1 SECONDS
	///A list for the path we're currently following, if we're using AStar pathing
	var/list/movement_path
	///Cooldown for JPS movement, how often we're allowed to try making a new path
	COOLDOWN_DECLARE(repath_cooldown)
	///AI paused time
	var/paused_until = 0

	var/failed_sneak_check = 0
	///Time at which controller became inactive
	var/inactive_timestamp

	///Can this AI idle?
	var/can_idle = TRUE
	///What distance should we be checking for interesting things when considering idling/deidling? Defaults to AI_DEFAULT_INTERESTING_DIST
	var/interesting_dist = AI_DEFAULT_INTERESTING_DIST
	///
	var/movement_displacement_time = 0


/datum/ai_controller/New(atom/new_pawn)
	change_ai_movement_type(ai_movement)
	init_subtrees()

	if(idle_behavior)
		idle_behavior = new idle_behavior()

	PossessPawn(new_pawn)

/datum/ai_controller/Destroy(force, ...)
	UnpossessPawn(FALSE)
	our_cells = null
	set_movement_target(type, null)
	if(ai_movement.moving_controllers[src])
		ai_movement.stop_moving_towards(src)
	return ..()

///Sets the current movement target, with an optional param to override the movement behavior
/datum/ai_controller/proc/set_movement_target(source, atom/target, datum/ai_movement/new_movement)
	if(current_movement_target)
		UnregisterSignal(current_movement_target, list(COMSIG_PARENT_PREQDELETED))
	if(!isnull(target) && !isatom(target))
		stack_trace("[pawn]'s current movement target is not an atom, rather a [target.type]! Did you accidentally set it to a weakref?")
		CancelActions()
		return
	movement_target_source = source
	current_movement_target = target
	if(!isnull(current_movement_target))
		RegisterSignal(current_movement_target, COMSIG_PARENT_PREQDELETED, PROC_REF(on_movement_target_delete))
	if(new_movement)
		change_ai_movement_type(new_movement)

///Overrides the current ai_movement of this controller with a new one
/datum/ai_controller/proc/change_ai_movement_type(datum/ai_movement/new_movement)
	ai_movement = SSai_movement.movement_types[new_movement]

///Completely replaces the planning_subtrees with a new set based on argument provided, list provided must contain specifically typepaths
/datum/ai_controller/proc/replace_planning_subtrees(list/typepaths_of_new_subtrees)
	planning_subtrees = typepaths_of_new_subtrees
	init_subtrees()

/datum/ai_controller/proc/add_to_top(datum/ai_planning_subtree/tree)
	var/list/new_trees = list()
	new_trees += tree
	for(var/datum/ai_planning_subtree/listed_tree as anything in planning_subtrees)
		new_trees |= listed_tree.type
	replace_planning_subtrees(new_trees)

///Loops over the subtrees in planning_subtrees and looks at the ai_controllers to grab a reference, ENSURE planning_subtrees ARE TYPEPATHS AND NOT INSTANCES/REFERENCES BEFORE EXECUTING THIS
/datum/ai_controller/proc/init_subtrees()
	if(!LAZYLEN(planning_subtrees))
		return
	var/list/temp_subtree_list = list()
	for(var/subtree in planning_subtrees)
		var/subtree_instance = GLOB.ai_subtrees[subtree]
		temp_subtree_list += subtree_instance
	planning_subtrees = temp_subtree_list

///Proc to move from one pawn to another, this will destroy the target's existing controller.
/datum/ai_controller/proc/PossessPawn(atom/new_pawn)
	if(pawn) //Reset any old signals
		UnpossessPawn(FALSE)
	if(istype(new_pawn.ai_controller)) //Existing AI, kill it.
		QDEL_NULL(new_pawn.ai_controller)
	if(TryPossessPawn(new_pawn) & AI_CONTROLLER_INCOMPATIBLE)
		qdel(src)
		CRASH("[src] attached to [new_pawn] but these are not compatible!")
	pawn = new_pawn
	pawn.ai_controller = src

	var/turf/pawn_turf = get_turf(pawn)
	if(pawn_turf)
		GLOB.ai_controllers_by_zlevel[pawn_turf.z] += src

	if(!continue_processing_when_client && istype(new_pawn, /mob))
		var/mob/possible_client_holder = new_pawn
		if(possible_client_holder.client)
			set_ai_status(AI_STATUS_OFF)
		else
			set_ai_status(AI_STATUS_ON)
	else
		set_ai_status(AI_STATUS_ON)

	RegisterSignal(pawn, COMSIG_MOVABLE_Z_CHANGED, PROC_REF(on_changed_z_level))
	RegisterSignal(pawn, COMSIG_MOB_LOGIN, PROC_REF(on_sentience_gained))
	RegisterSignal(pawn, COMSIG_MOB_STATCHANGE, PROC_REF(on_stat_changed))

	our_cells = new(interesting_dist, interesting_dist, 1)
	set_new_cells()

	RegisterSignal(pawn, COMSIG_MOVABLE_MOVED, PROC_REF(update_grid))

///Can this pawn interact with objects?
/datum/ai_controller/proc/ai_can_interact()
	SHOULD_CALL_PARENT(TRUE)
	return !QDELETED(pawn)

///Interact with objects
/datum/ai_controller/proc/ai_interact(target, combat_mode, nextmove = FALSE, list/modifiers)
	if(!ai_can_interact())
		return FALSE

	var/atom/final_target = isdatum(target) ? target : blackboard[target] //incase we got a blackboard key instead

	if(QDELETED(final_target))
		return FALSE

	var/mob/living/living_pawn = pawn
	if(nextmove && living_pawn.next_move > world.time)
		return FALSE

	if(living_pawn.body_position == LYING_DOWN)
		living_pawn.aimheight_change(rand(1,9))
	else
		living_pawn.aimheight_change(rand(10,19))

	var/params = list2params(modifiers)

	if(isnull(combat_mode))
		SEND_SIGNAL(living_pawn, COMSIG_HOSTILE_PRE_ATTACKINGTARGET, final_target)
		living_pawn.ClickOn(final_target, params)
		return TRUE

	var/old_combat_mode = living_pawn.cmode
	living_pawn.cmode = combat_mode
	SEND_SIGNAL(living_pawn, COMSIG_HOSTILE_PRE_ATTACKINGTARGET, final_target)
	living_pawn.ClickOn(final_target, params)
	living_pawn.cmode = old_combat_mode
	return TRUE

/datum/ai_controller/proc/update_grid(datum/source, datum/spatial_grid_cell/new_cell)
	SIGNAL_HANDLER
	set_new_cells()

/datum/ai_controller/proc/on_movement_target_delete(atom/source)
	SIGNAL_HANDLER
	set_movement_target(source = type, target = null)

/datum/ai_controller/proc/set_new_cells()
	var/turf/our_turf = get_turf(pawn)
	if(isnull(our_turf))
		return

	var/list/cell_collections = our_cells.recalculate_cells(our_turf)

	for(var/datum/old_grid as anything in cell_collections[2])
		UnregisterSignal(old_grid, list(SPATIAL_GRID_CELL_ENTERED(SPATIAL_GRID_CONTENTS_TYPE_CLIENTS), SPATIAL_GRID_CELL_EXITED(SPATIAL_GRID_CONTENTS_TYPE_CLIENTS)))

	for(var/datum/spatial_grid_cell/new_grid as anything in cell_collections[1])
		RegisterSignal(new_grid, SPATIAL_GRID_CELL_ENTERED(SPATIAL_GRID_CONTENTS_TYPE_CLIENTS), PROC_REF(on_client_enter))
		RegisterSignal(new_grid, SPATIAL_GRID_CELL_EXITED(SPATIAL_GRID_CONTENTS_TYPE_CLIENTS), PROC_REF(on_client_exit))
	recalculate_idle()

/datum/ai_controller/proc/should_idle()
	if(!can_idle)
		return FALSE
	for(var/datum/spatial_grid_cell/grid as anything in our_cells.member_cells)
		if(length(grid.client_contents))
			return FALSE
	return TRUE

/datum/ai_controller/proc/recalculate_idle()
	if(ai_status == AI_STATUS_OFF)
		return
	if(should_idle())
		set_ai_status(AI_STATUS_IDLE)

/datum/ai_controller/proc/on_client_enter(datum/source, atom/target)
	SIGNAL_HANDLER
	if(ai_status == AI_STATUS_IDLE)
		set_ai_status(AI_STATUS_ON)

/datum/ai_controller/proc/on_client_exit(datum/source, datum/exited)
	SIGNAL_HANDLER
	recalculate_idle()

/datum/ai_controller/proc/get_current_turf()
	var/mob/living/mob_pawn = pawn
	var/turf/pawn_turf = get_turf(mob_pawn)
	to_chat(world, "[pawn_turf]")

///Called when the AI controller pawn changes z levels, we check if there's any clients on the new one and wake up the AI if there is.
/datum/ai_controller/proc/on_changed_z_level(atom/source, old_z, new_z, same_z_layer, notify_contents)
	SIGNAL_HANDLER
	if (ismob(pawn))
		var/mob/mob_pawn = pawn
		if((mob_pawn?.client && !continue_processing_when_client))
			return
	if(old_z)
		GLOB.ai_controllers_by_zlevel[old_z] -= src

	if(new_z)
		GLOB.ai_controllers_by_zlevel[new_z] += src
		var/new_level_clients = SSmobs.clients_by_zlevel[new_z].len
		if(new_level_clients)
			set_ai_status(AI_STATUS_IDLE)

///Abstract proc for initializing the pawn to the new controller
/datum/ai_controller/proc/TryPossessPawn(atom/new_pawn)
	return

///Proc for deinitializing the pawn to the old controller
/datum/ai_controller/proc/UnpossessPawn(destroy)
	UnregisterSignal(pawn, list(COMSIG_MOVABLE_Z_CHANGED, COMSIG_MOB_LOGIN, COMSIG_MOB_LOGOUT, COMSIG_MOB_STATCHANGE))
	var/turf/pawn_turf = get_turf(pawn)
	if(pawn_turf)
		GLOB.ai_controllers_by_zlevel[pawn_turf.z] -= src
	if(ai_status)
		GLOB.ai_controllers_by_status[ai_status] -= src
	stop_previous_processing()
	CancelActions()
	pawn.ai_controller = null
	pawn = null
	if(destroy)
		qdel(src)

/// Turn the controller on or off based on if you're alive, we only register to this if the flag is present so don't need to check again
/datum/ai_controller/proc/on_stat_changed(mob/living/source, new_stat)
	SIGNAL_HANDLER
	reset_ai_status()

/// Sets the AI on or off based on current conditions, call to reset after you've manually disabled it somewhere
/datum/ai_controller/proc/reset_ai_status()
	set_ai_status(get_expected_ai_status())

/datum/ai_controller/proc/can_move()
	if(QDELETED(pawn))
		return
	var/mob/living/living_pawn = pawn
	if(HAS_TRAIT(living_pawn, TRAIT_INCAPACITATED))
		return FALSE
	if(ai_traits & STOP_MOVING_WHEN_PULLED && living_pawn.pulledby)
		return FALSE
	if(!isturf(living_pawn.loc)) //No moving if not on a turf
		return FALSE
	if(HAS_TRAIT(living_pawn, TRAIT_IMMOBILIZED))
		return FALSE
	if(living_pawn.pulledby?.grab_state > GRAB_PASSIVE)
		return FALSE

	return TRUE

/**
 * Gets the AI status we expect the AI controller to be on at this current moment.
 * Returns AI_STATUS_OFF if it's inhabited by a Client and shouldn't be, if it's dead and cannot act while dead, or is on a z level without clients.
 * Returns AI_STATUS_ON otherwise.
 */
/datum/ai_controller/proc/get_expected_ai_status()

	if (!ismob(pawn))
		return AI_STATUS_ON

	var/mob/living/mob_pawn = pawn
	if(!continue_processing_when_client && mob_pawn.client)
		return AI_STATUS_OFF

	if(mob_pawn.stat >= UNCONSCIOUS)
		return AI_STATUS_OFF

	var/turf/pawn_turf = get_turf(mob_pawn)
#ifdef TESTING
	if(!pawn_turf)
		CRASH("AI controller [src] controlling pawn ([pawn]) is not on a turf.")
#endif
	if(!("[pawn_turf?.z]" in GLOB.weatherproof_z_levels))
		if(SSmapping.level_has_any_trait(pawn_turf?.z, list(ZTRAIT_IGNORE_WEATHER_TRAIT)))
			GLOB.weatherproof_z_levels |= "[pawn_turf?.z]"
	if("[pawn_turf?.z]" in GLOB.weatherproof_z_levels)
		if(!length(SSmobs.clients_by_zlevel[pawn_turf?.z]))
			return AI_STATUS_OFF
	if(should_idle())
		return AI_STATUS_IDLE
	return AI_STATUS_ON

///Returns TRUE if the ai controller can actually run at the moment.
/datum/ai_controller/proc/able_to_run()
	if(world.time < paused_until)
		return FALSE
	return TRUE

/// Generates a plan and see if our existing one is still valid.
/datum/ai_controller/process(delta_time)
	if(!able_to_run())
		walk(pawn, 0) //stop moving
		return //this should remove them from processing in the future through event-based stuff.

	if(!LAZYLEN(current_behaviors) && idle_behavior)
		idle_behavior.perform_idle_behavior(delta_time, src) //Do some stupid shit while we have nothing to do
		return

	if(current_movement_target)
		if(!isatom(current_movement_target))
			stack_trace("[pawn]'s current movement target is not an atom, rather a [current_movement_target.type]! Did you accidentally set it to a weakref?")
			CancelActions()
			return

		if(get_dist_3d(pawn, current_movement_target) > max_target_distance) //The distance is out of range
			CancelActions()
			return

	SEND_SIGNAL(src, COMSIG_AI_CONTROLLER_PICKED_BEHAVIORS, current_behaviors, planned_behaviors)
	for(var/datum/ai_behavior/current_behavior as anything in current_behaviors)
		// Convert the current behaviour action cooldown to realtime seconds from deciseconds.current_behavior
		// Then pick the max of this and the delta_time passed to ai_controller.process()
		// Action cooldowns cannot happen faster than delta_time, so delta_time should be the value used in this scenario.
		var/action_delta_time = max(current_behavior.get_cooldown(src) * 0.1, delta_time)

		if(current_behavior.behavior_flags & AI_BEHAVIOR_REQUIRE_MOVEMENT) //Might need to move closer
			if(!current_movement_target)
				current_behavior.finish_action(src, FALSE)
				return //This can cause issues, so don't let these slide.

			///Stops pawns from performing such actions that should require the target to be adjacent.
			var/mob/living/moving_pawn = pawn
			var/can_reach = !(current_behavior.behavior_flags & AI_BEHAVIOR_REQUIRE_REACH) || moving_pawn.CanReach(current_movement_target)

			if(isliving(current_movement_target))
				var/mob/living/living_pawn = pawn
				var/mob/living/living_target = current_movement_target
				if(living_target.rogue_sneaking)
					if(!living_pawn.npc_detect_sneak(living_target, 0))
						failed_sneak_check++
				else
					failed_sneak_check = 0

			if(prob(8))
				moving_pawn.emote("cidle")

			if(((can_reach && current_behavior.required_distance >= get_dist(moving_pawn, current_movement_target))) || failed_sneak_check > 4) ///Are we close
				if(ai_movement.moving_controllers[src] == current_movement_target) //We are close enough, if we're moving stop.
					ai_movement.stop_moving_towards(src)

				if(failed_sneak_check > 4)
					ai_movement.stop_moving_towards(src)
				failed_sneak_check = 0

				if(behavior_cooldowns[current_behavior] > world.time) //Still on cooldown
					continue
				ProcessBehavior(action_delta_time, current_behavior)
				return

			else if(ai_movement.moving_controllers[src] != current_movement_target) //We're too far, if we're not already moving start doing it.
				ai_movement.start_moving_towards(src, current_movement_target) //Then start moving

			if(current_behavior.behavior_flags & AI_BEHAVIOR_MOVE_AND_PERFORM) //If we can move and perform then do so.
				if(behavior_cooldowns[current_behavior] > world.time) //Still on cooldown
					continue
				ProcessBehavior(action_delta_time, current_behavior)
				return
		else //No movement required
			if(behavior_cooldowns[current_behavior] > world.time) //Still on cooldown
				continue
			ProcessBehavior(action_delta_time, current_behavior)
			return

///Determines whether the AI can currently make a new plan
/datum/ai_controller/proc/able_to_plan()
	. = TRUE
	for(var/datum/ai_behavior/current_behavior as anything in current_behaviors)
		if(!(current_behavior.behavior_flags & AI_BEHAVIOR_CAN_PLAN_DURING_EXECUTION)) //We have a behavior that blocks planning
			. = FALSE
			break

///This is where you decide what actions are taken by the AI.
/datum/ai_controller/proc/SelectBehaviors(delta_time)
	SHOULD_NOT_SLEEP(TRUE) //Fuck you don't sleep in procs like this.
	if(!COOLDOWN_FINISHED(src, failed_planning_cooldown))
		return FALSE
	LAZYINITLIST(current_behaviors)
	LAZYCLEARLIST(planned_behaviors)

	if(LAZYLEN(planning_subtrees))
		for(var/datum/ai_planning_subtree/subtree as anything in planning_subtrees)
			if(subtree.SelectBehaviors(src, delta_time) == SUBTREE_RETURN_FINISH_PLANNING)
				break

	for(var/datum/ai_behavior/current_behavior as anything in current_behaviors)
		if(LAZYACCESS(planned_behaviors, current_behavior))
			continue
		var/list/arguments = list(src, FALSE)
		var/list/stored_arguments = behavior_args[type]
		if(stored_arguments)
			arguments += stored_arguments
		current_behavior.finish_action(arglist(arguments))


///This proc handles changing ai status, and starts/stops processing if required.
/datum/ai_controller/proc/set_ai_status(new_ai_status)
	if(ai_status == new_ai_status)
		return FALSE //no change

	//remove old status, if we've got one
	if(ai_status)
		GLOB.ai_controllers_by_status[ai_status] -= src
	stop_previous_processing()
	ai_status = new_ai_status
	GLOB.ai_controllers_by_status[new_ai_status] += src
	switch(ai_status)
		if(AI_STATUS_ON)
			START_PROCESSING(SSai_behaviors, src)
		if(AI_STATUS_IDLE)
			START_PROCESSING(SSidle_ai_behaviors, src)
		if(AI_STATUS_OFF)
			CancelActions()

/datum/ai_controller/proc/stop_previous_processing()
	switch(ai_status)
		if(AI_STATUS_ON)
			STOP_PROCESSING(SSai_behaviors, src)
		if(AI_STATUS_IDLE)
			STOP_PROCESSING(SSidle_ai_behaviors, src)

/datum/ai_controller/proc/PauseAi(time)
	paused_until = world.time + time

/datum/ai_controller/proc/modify_cooldown(datum/ai_behavior/behavior, new_cooldown)
	behavior_cooldowns[behavior.type] = new_cooldown

///Call this to add a behavior to the stack.
/datum/ai_controller/proc/queue_behavior(behavior_type, ...)
	var/datum/ai_behavior/behavior = GET_AI_BEHAVIOR(behavior_type)
	if(!behavior)
		CRASH("Behavior [behavior_type] not found.")
	var/list/arguments = args.Copy()
	arguments[1] = src

	if(LAZYACCESS(current_behaviors, behavior)) ///It's still in the plan, don't add it again to current_behaviors but do keep it in the planned behavior list so its not cancelled
		LAZYADDASSOCLIST(planned_behaviors, behavior, TRUE)
		return

	if(!behavior.setup(arglist(arguments)))
		return

	LAZYADDASSOCLIST(current_behaviors, behavior, TRUE)
	LAZYADDASSOCLIST(planned_behaviors, behavior, TRUE)

	arguments.Cut(1, 2)
	if(length(arguments))
		behavior_args[behavior_type] = arguments
	else
		behavior_args -= behavior_type
	SEND_SIGNAL(src, AI_CONTROLLER_BEHAVIOR_QUEUED(behavior_type), arguments)

/datum/ai_controller/proc/ProcessBehavior(delta_time, datum/ai_behavior/behavior)
	var/list/arguments = list(delta_time, src)
	var/list/stored_arguments = behavior_args[behavior.type]
	if(stored_arguments)
		arguments += stored_arguments
	behavior.perform(arglist(arguments))

/datum/ai_controller/proc/CancelActions()
	if(!LAZYLEN(current_behaviors))
		return
	for(var/datum/ai_behavior/current_behavior as anything in current_behaviors)
		var/list/arguments = list(src, FALSE)
		var/list/stored_arguments = behavior_args[current_behavior.type]
		if(stored_arguments)
			arguments += stored_arguments
		current_behavior.finish_action(arglist(arguments))

/datum/ai_controller/proc/on_sentience_gained()
	UnregisterSignal(pawn, COMSIG_MOB_LOGIN)
	if(!continue_processing_when_client)
		set_ai_status(AI_STATUS_OFF) //Can't do anything while player is connected
	set_ai_status(AI_STATUS_OFF) //Can't do anything while player is connected
	RegisterSignal(pawn, COMSIG_MOB_LOGOUT, PROC_REF(on_sentience_lost))

/datum/ai_controller/proc/on_sentience_lost()
	UnregisterSignal(pawn, COMSIG_MOB_LOGOUT)
	set_ai_status(AI_STATUS_ON) //Can't do anything while player is connected
	RegisterSignal(pawn, COMSIG_MOB_LOGIN, PROC_REF(on_sentience_gained))

/// Use this proc to define how your controller defines what access the pawn has for the sake of pathfinding, this requires they either have a key or you give them the lockids you want them to open
/datum/ai_controller/proc/get_access()
	return

/// Returns true if we have a blackboard key with the provided key and it is not qdeleting
/datum/ai_controller/proc/blackboard_key_exists(key)
	var/datum/key_value = blackboard[key]
	if (isdatum(key_value))
		return !QDELETED(key_value)
	if (islist(key_value))
		return length(key_value) > 0
	return !!key_value

/**
 * Used to manage references to datum by AI controllers
 *
 * * tracked_datum - something being added to an ai blackboard
 * * key - the associated key
 */
#define TRACK_AI_DATUM_TARGET(tracked_datum, key) do { \
	if(isweakref(tracked_datum)) { \
		var/datum/weakref/_bad_weakref = tracked_datum; \
		stack_trace("Weakref (Actual datum: [_bad_weakref.resolve()]) found in ai datum blackboard! \
			This is an outdated method of ai reference handling, please remove it."); \
	}; \
	else if(isdatum(tracked_datum)) { \
		var/datum/_tracked_datum = tracked_datum; \
		if(!HAS_TRAIT_FROM(_tracked_datum, TRAIT_AI_TRACKING, "[REF(src)]_[key]")) { \
			RegisterSignal(_tracked_datum, COMSIG_PARENT_QDELETING, PROC_REF(sig_remove_from_blackboard), override = TRUE); \
			ADD_TRAIT(_tracked_datum, TRAIT_AI_TRACKING, "[REF(src)]_[key]"); \
		}; \
	}; \
} while(FALSE)

/**
 * Used to clear previously set reference handing by AI controllers
 *
 * * tracked_datum - something being removed from an ai blackboard
 * * key - the associated key
 */
#define CLEAR_AI_DATUM_TARGET(tracked_datum, key) do { \
	if(isdatum(tracked_datum)) { \
		var/datum/_tracked_datum = tracked_datum; \
		REMOVE_TRAIT(_tracked_datum, TRAIT_AI_TRACKING, "[REF(src)]_[key]"); \
		if(!HAS_TRAIT(_tracked_datum, TRAIT_AI_TRACKING)) { \
			UnregisterSignal(_tracked_datum, COMSIG_PARENT_QDELETING); \
		}; \
	}; \
} while(FALSE)

/// Used for above to track all the keys that have registered a signal
#define TRAIT_AI_TRACKING "tracked_by_ai"

/**
 * Sets the key to the passed "thing".
 *
 * * key - A blackboard key
 * * thing - a value to set the blackboard key to.
 */
/datum/ai_controller/proc/set_blackboard_key(key, thing)
	// Assume it is an error when trying to set a value overtop a list
	if(islist(blackboard[key]) && !islist(thing))
		CRASH("set_blackboard_key attempting to set a blackboard value to key [key] when it's a list!")

	// Clear existing values
	if(!isnull(blackboard[key]))
		clear_blackboard_key(key)

	TRACK_AI_DATUM_TARGET(thing, key)
	blackboard[key] = thing
	post_blackboard_key_set(key)

/**
 * Sets the key at index thing to the passed value
 *
 * Assumes the key value is already a list, if not throws an error.
 *
 * * key - A blackboard key, with its value set to a list
 * * thing - a value which becomes the inner list value's key
 * * value - what to set the inner list's value to
 */
/datum/ai_controller/proc/set_blackboard_key_assoc(key, thing, value)
	if(!islist(blackboard[key]))
		CRASH("set_blackboard_key_assoc called on non-list key [key]!")

	TRACK_AI_DATUM_TARGET(value, key)
	blackboard[key][thing] = value
	post_blackboard_key_set(key)

/**
 * Similar to [proc/set_blackboard_key_assoc] but operates under the assumption the key is a lazylist (so it will create a list)
 * More dangerous / easier to override values, only use when you want to use a lazylist
 *
 * * key - A blackboard key, with its value set to a list
 * * thing - a value which becomes the inner list value's key
 * * value - what to set the inner list's value to
 */
/datum/ai_controller/proc/set_blackboard_key_assoc_lazylist(key, thing, value)
	LAZYINITLIST(blackboard[key])
	TRACK_AI_DATUM_TARGET(thing, key)
	TRACK_AI_DATUM_TARGET(value, key)
	blackboard[key][thing] = value
	post_blackboard_key_set(key)

/**
 * Called after we set a blackboard key, forwards signal information.
 */
/datum/ai_controller/proc/post_blackboard_key_set(key)
	if (isnull(pawn))
		return
	SEND_SIGNAL(pawn, COMSIG_AI_BLACKBOARD_KEY_SET(key), key)

/**
 * Adds the passed "thing" to the associated key
 *
 * Works with lists or numbers, but not lazylists.
 *
 * * key - A blackboard key
 * * thing - a value to set the blackboard key to.
 */
/datum/ai_controller/proc/add_blackboard_key(key, thing)
	TRACK_AI_DATUM_TARGET(thing, key)
	blackboard[key] += thing

/**
 * Similar to [proc/add_blackboard_key], but performs an insertion rather than an add
 * Throws an error if the key is not a list already, intended only for use with lists
 *
 * * key - A blackboard key, with its value set to a list
 * * thing - a value to set the blackboard key to.
 */
/datum/ai_controller/proc/insert_blackboard_key(key, thing)
	if(!islist(blackboard[key]))
		CRASH("insert_blackboard_key called on non-list key [key]!")
	TRACK_AI_DATUM_TARGET(thing, key)
	blackboard[key] |= thing

/**
 * Adds the passed "thing" to the associated key, assuming key is intended to be a lazylist (so it will create a list)
 * More dangerous / easier to override values, only use when you want to use a lazylist
 *
 * * key - A blackboard key
 * * thing - a value to set the blackboard key to.
 */
/datum/ai_controller/proc/add_blackboard_key_lazylist(key, thing)
	LAZYINITLIST(blackboard[key])
	TRACK_AI_DATUM_TARGET(thing, key)
	blackboard[key] += thing

/**
 * Similar to [proc/insert_blackboard_key_lazylist], but performs an insertion / or rather than an add
 *
 * * key - A blackboard key
 * * thing - a value to set the blackboard key to.
 */
/datum/ai_controller/proc/insert_blackboard_key_lazylist(key, thing)
	LAZYINITLIST(blackboard[key])
	TRACK_AI_DATUM_TARGET(thing, key)
	blackboard[key] |= thing

/**
 * Adds the value to the inner list at key with the inner key set to "thing"
 * Throws an error if the key is not a list already, intended only for use with lists
 *
 * * key - A blackboard key, with its value set to a list
 * * thing - a value which becomes the inner list value's key
 * * value - what to set the inner list's value to
 */
/datum/ai_controller/proc/add_blackboard_key_assoc(key, thing, value)
	if(!islist(blackboard[key]))
		CRASH("add_blackboard_key_assoc called on non-list key [key]!")
	TRACK_AI_DATUM_TARGET(thing, key)
	TRACK_AI_DATUM_TARGET(value, key)
	blackboard[key][thing] += value


/**
 * Similar to [proc/add_blackboard_key_assoc], assuming key is intended to be a lazylist (so it will create a list)
 * More dangerous / easier to override values, only use when you want to use a lazylist
 *
 * * key - A blackboard key, with its value set to a list
 * * thing - a value which becomes the inner list value's key
 * * value - what to set the inner list's value to
 */
/datum/ai_controller/proc/add_blackboard_key_assoc_lazylist(key, thing, value)
	LAZYINITLIST(blackboard[key])
	TRACK_AI_DATUM_TARGET(thing, key)
	TRACK_AI_DATUM_TARGET(value, key)
	blackboard[key][thing] += value

/**
 * Clears the passed key, resetting it to null
 *
 * Not intended for use with list keys - use [proc/remove_thing_from_blackboard_key] if you are removing a value from a list at a key
 *
 * * key - A blackboard key
 */
/datum/ai_controller/proc/clear_blackboard_key(key)
	CLEAR_AI_DATUM_TARGET(blackboard[key], key)
	blackboard[key] = null
	if(pawn)
		SEND_SIGNAL(pawn, COMSIG_AI_BLACKBOARD_KEY_CLEARED(key))

/**
 * Remove the passed thing from the associated blackboard key
 *
 * Intended for use with lists, if you're just clearing a reference from a key use [proc/clear_blackboard_key]
 *
 * * key - A blackboard key
 * * thing - a value to set the blackboard key to.
 */
/datum/ai_controller/proc/remove_thing_from_blackboard_key(key, thing)
	var/associated_value = blackboard[key]
	if(thing == associated_value)
		stack_trace("remove_thing_from_blackboard_key was called un-necessarily in a situation where clear_blackboard_key would suffice. ")
		clear_blackboard_key(key)
		return

	if(!islist(associated_value))
		CRASH("remove_thing_from_blackboard_key called with an invalid \"thing\" argument ([thing]). \
			(The associated value of the passed key is not a list and is also not the passed thing, meaning it is clearing an unintended value.)")

	for(var/inner_key in associated_value)
		if(inner_key == thing)
			// flat list
			CLEAR_AI_DATUM_TARGET(thing, key)
			associated_value -= thing
			return
		else if(associated_value[inner_key] == thing)
			// assoc list
			CLEAR_AI_DATUM_TARGET(thing, key)
			associated_value -= inner_key
			return

	CRASH("remove_thing_from_blackboard_key called with an invalid \"thing\" argument ([thing]). \
		(The passed value is not tracked in the passed list.)")

/// Signal proc to go through every key and remove the datum from all keys it finds
/datum/ai_controller/proc/sig_remove_from_blackboard(datum/source)
	SIGNAL_HANDLER

	var/list/list/remove_queue = list(blackboard)
	var/index = 1
	while(index <= length(remove_queue))
		var/list/next_to_clear = remove_queue[index]
		for(var/inner_value in next_to_clear)
			var/associated_value = next_to_clear[inner_value]
			// We are a lists of lists, add the next value to the queue so we can handle references in there
			// (But we only need to bother checking the list if it's not empty.)
			if(islist(inner_value) && length(inner_value))
				UNTYPED_LIST_ADD(remove_queue, inner_value)

			// We found the value that's been deleted. Clear it out from this list
			else if(inner_value == source)
				next_to_clear -= inner_value

			// We are an assoc lists of lists, the list at the next value so we can handle references in there
			// (But again, we only need to bother checking the list if it's not empty.)
			if(islist(associated_value) && length(associated_value))
				UNTYPED_LIST_ADD(remove_queue, associated_value)

			// We found the value that's been deleted, it was an assoc value. Clear it out entirely
			else if(associated_value == source)
				next_to_clear -= inner_value
				SEND_SIGNAL(pawn, COMSIG_AI_BLACKBOARD_KEY_CLEARED(inner_value))

		index += 1

#undef TRACK_AI_DATUM_TARGET
#undef CLEAR_AI_DATUM_TARGET
#undef TRAIT_AI_TRACKING
