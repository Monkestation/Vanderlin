/datum/quest
	var/title = ""
	var/datum/weakref/quest_giver_reference
	var/quest_giver_name = ""
	var/datum/weakref/quest_receiver_reference
	var/quest_receiver_name = ""
	var/quest_type = ""
	var/quest_difficulty = ""
	var/reward_amount = 0
	var/deposit_amount = 0
	var/complete = FALSE

	/// Progress tracking
	var/progress_current = 0
	var/progress_required = 1

	/// Target item type for fetch quests
	var/obj/item/target_item_type
	/// Target item type for courier quests
	var/obj/item/target_delivery_item
	/// Target mob type for kill quests
	var/mob/target_mob_type
	/// Location for courier quests
	var/area/indoors/town/target_delivery_location
	/// Location name for kill/clear quests
	var/target_spawn_area = ""

	/// Scroll icon state
	var/quest_icon = "scroll_quest"

	/// Fallback reference to the spawned scroll
	var/obj/item/paper/scroll/quest/quest_scroll
	/// Weak reference to the quest scroll
	var/datum/weakref/quest_scroll_ref
	/// List of weakrefs to actual quest items/mobs for reducing overhead of compass.
	var/list/datum/weakref/tracked_atoms = list()

/datum/quest/Destroy()
	// Clean up mobs with quest components
	for(var/mob/living/M in GLOB.mob_list)
		var/datum/component/quest_object/Q = M.GetComponent(/datum/component/quest_object)
		if(Q && Q.quest_ref?.resolve() == src)
			M.remove_filter("quest_item_outline")
			qdel(Q)

	for(var/datum/weakref/tracked_weakref in tracked_atoms)
		var/atom/target_atom = tracked_weakref.resolve()
		if(QDELETED(target_atom))
			continue

		// Only delete the item if it's part of a fetch or courier quest
		if(quest_type == QUEST_RETRIEVAL && istype(target_atom, target_item_type))
			qdel(target_atom)
		else if(quest_type == QUEST_COURIER && istype(target_atom, target_delivery_item))
			qdel(target_atom)

		tracked_atoms -= tracked_weakref
		qdel(tracked_weakref)

	// Clean up references
	quest_scroll = null
	if(quest_scroll_ref)
		var/obj/item/paper/scroll/quest/Q = quest_scroll_ref.resolve()
		if(Q && !QDELETED(Q))
			Q.assigned_quest = null
			qdel(Q)
		quest_scroll_ref = null

	return ..()

/datum/quest/proc/add_tracked_atom(atom/movable/to_track)
	tracked_atoms += WEAKREF(to_track)

/// Generate quest content - override in subtypes
/datum/quest/proc/generate(obj/effect/landmark/quest_spawner/landmark)
	if(!title)
		title = get_title()
	return TRUE

/// Get the quest title - override in subtypes for dynamic titles
/datum/quest/proc/get_title()
	return title

/// Get objective text for scroll display
/datum/quest/proc/get_objective_text()
	return "Complete the objective."

/// Get location text for scroll display
/datum/quest/proc/get_location_text()
	return target_spawn_area ? "Reported sighting in [target_spawn_area] region." : "Location unknown."

/// Check if quest objectives are complete
/datum/quest/proc/check_completion()
	return progress_current >= progress_required

/// Called when progress is updated
/datum/quest/proc/on_progress_update()
	if(check_completion())
		mark_complete()
	else
		quest_scroll?.update_quest_text()

/// Mark quest as complete
/datum/quest/proc/mark_complete()
	complete = TRUE
	quest_scroll?.update_quest_text()

// Base reward scaled only to difficulty
/datum/quest/proc/get_base_reward()
	switch(quest_difficulty)
		if(QUEST_DIFFICULTY_EASY)
			return rand(QUEST_REWARD_EASY_LOW, QUEST_REWARD_EASY_HIGH)
		if(QUEST_DIFFICULTY_MEDIUM)
			return rand(QUEST_REWARD_MEDIUM_LOW, QUEST_REWARD_MEDIUM_HIGH)
		if(QUEST_DIFFICULTY_HARD)
			return rand(QUEST_REWARD_HARD_LOW, QUEST_REWARD_HARD_HIGH)

// Additional reward, override in subtypes for specific calculations. Called AFTER generation.
/datum/quest/proc/get_additional_reward(turf/target_turf)
	return 0

/// Calculate reward based on base + additional reward. Called AFTER generation.
/datum/quest/proc/calculate_reward(turf/target_turf)
	var/base = get_base_reward()
	var/additional = get_additional_reward(target_turf)
	return base + additional

/// Calculate deposit based on difficulty
/datum/quest/proc/calculate_deposit()
	switch(quest_difficulty)
		if(QUEST_DIFFICULTY_EASY)
			return QUEST_DEPOSIT_EASY
		if(QUEST_DIFFICULTY_MEDIUM)
			return QUEST_DEPOSIT_MEDIUM
		if(QUEST_DIFFICULTY_HARD)
			return QUEST_DEPOSIT_HARD
	return 0

/// Get icon for scroll based on difficulty
/datum/quest/proc/get_scroll_icon()
	switch(quest_difficulty)
		if(QUEST_DIFFICULTY_EASY)
			return "scroll_quest_low"
		if(QUEST_DIFFICULTY_MEDIUM)
			return "scroll_quest_mid"
		if(QUEST_DIFFICULTY_HARD)
			return "scroll_quest_high"
	return quest_icon

/// Get target location for compass - returns turf of nearest tracked atom
/datum/quest/proc/get_target_location()
	var/turf/user_turf = quest_scroll ? get_turf(quest_scroll) : null
	if(!user_turf)
		return null

	var/turf/closest
	var/min_dist = INFINITY

	for(var/datum/weakref/ref in tracked_atoms)
		var/atom/A = ref.resolve()
		if(!A || QDELETED(A))
			continue

		var/turf/A_turf = get_turf(A)
		if(!A_turf)
			continue

		var/dist = get_dist(user_turf, A_turf)
		if(dist < min_dist)
			min_dist = dist
			closest = A_turf

	return closest

/// Check if a user can claim this quest - override for restrictions
/datum/quest/proc/can_claim(mob/user)
	return TRUE

/// Called when quest is claimed by a user
/datum/quest/proc/on_claim(mob/user)
	quest_receiver_reference = WEAKREF(user)
	quest_receiver_name = user.real_name
