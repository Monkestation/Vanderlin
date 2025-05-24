/**find and set
 * Finds an item near themselves, sets a blackboard key as it. Very useful for ais that need to use machines or something.
 * if you want to do something more complicated than find a single atom, change the search_tactic() proc
 * cool tip: search_tactic() can set lists
 */
/datum/ai_behavior/find_and_set
	action_cooldown = 2 SECONDS

/datum/ai_behavior/find_and_set/perform(delta_time, datum/ai_controller/controller, set_key, locate_path, search_range)
	. = ..()
	var/find_this_thing = search_tactic(controller, locate_path, search_range)
	if(find_this_thing)
		controller.set_blackboard_key(set_key, find_this_thing)
		finish_action(controller, TRUE)
	else
		finish_action(controller, FALSE)

/datum/ai_behavior/find_and_set/proc/search_tactic(datum/ai_controller/controller, locate_path, search_range)
	return locate(locate_path) in oview(search_range, controller.pawn)

/**
 * Variant of find and set that fails if the living pawn doesn't hold something
 */
/datum/ai_behavior/find_and_set/pawn_must_hold_item

/datum/ai_behavior/find_and_set/pawn_must_hold_item/search_tactic(datum/ai_controller/controller)
	var/mob/living/living_pawn = controller.pawn
	if(!living_pawn.get_inactive_held_item() && !living_pawn.get_active_held_item())
		return //we want to fail the search if we don't have something held
	return ..()

/**
 * Variant of find and set that also requires the item to be edible. checks hands too
 */
/datum/ai_behavior/find_and_set/edible

/datum/ai_behavior/find_and_set/edible/search_tactic(datum/ai_controller/controller, locate_path, search_range)
	var/mob/living/living_pawn = controller.pawn
	var/list/food_candidates = list()
	for(var/held_candidate as anything in living_pawn.held_items)
		if(!held_candidate || !istype(held_candidate, /obj/item/reagent_containers/food))
			continue
		food_candidates += held_candidate
	var/list/local_results = locate(locate_path) in oview(search_range, controller.pawn)
	for(var/local_candidate in local_results)
		if(!istype(local_candidate, /obj/item/reagent_containers/food))
			continue
		food_candidates += local_candidate
	if(food_candidates.len)
		return pick(food_candidates)

/**
 * Variant of find and set that only checks in hands, search range should be excluded for this
 */
/datum/ai_behavior/find_and_set/in_hands

/datum/ai_behavior/find_and_set/in_hands/search_tactic(datum/ai_controller/controller, locate_path)
	var/mob/living/living_pawn = controller.pawn
	return locate(locate_path) in living_pawn.held_items

/datum/ai_behavior/find_and_set/in_hands/given_list

/datum/ai_behavior/find_and_set/in_hands/given_list/search_tactic(datum/ai_controller/controller, locate_paths)
	var/list/found = typecache_filter_list(controller.pawn, locate_paths)
	if(length(found))
		return pick(found)

/**
 * Variant of find and set that takes a list of things to find.
 */
/datum/ai_behavior/find_and_set/in_list

/datum/ai_behavior/find_and_set/in_list/search_tactic(datum/ai_controller/controller, locate_paths, search_range)
	var/list/found = typecache_filter_list(oview(search_range, controller.pawn), locate_paths)
	if(length(found))
		return pick(found)

/datum/ai_behavior/find_and_set/in_list/saiga

/datum/ai_behavior/find_and_set/in_list/saiga/search_tactic(datum/ai_controller/controller, locate_paths, search_range)
	var/list/found = typecache_filter_list(oview(search_range, controller.pawn), locate_paths)
	if(length(found))
		controller.set_blackboard_key(BB_BASIC_MOB_FLEEING, FALSE)
		return pick(found)

/datum/ai_behavior/find_and_set/dead_bodies

/datum/ai_behavior/find_and_set/dead_bodies/search_tactic(datum/ai_controller/controller, locate_paths, search_range)
	var/list/found = list()
	for(var/mob/living/mob in oview(search_range, controller.pawn))
		if(mob.stat < DEAD)
			continue
		found |= mob
	if(!length(found))
		return null
	return pick(found)

/datum/ai_behavior/find_and_set/dead_bodies/bog_troll/finish_action(datum/ai_controller/controller, succeeded, ...)
	. = ..()
	if(succeeded)
		if(istype(controller.pawn, /mob/living/simple_animal/hostile/retaliate/troll))
			var/mob/living/simple_animal/hostile/retaliate/troll/mob = controller.pawn
			mob.ambush()

/datum/ai_behavior/find_and_set/dead_bodies/mimic/finish_action(datum/ai_controller/controller, succeeded, ...)
	. = ..()
	if(succeeded)
		controller.pawn.icon_state = "mimicopen"

/**
 * Variant of find and set which returns the nearest wall which isn't invulnerable
 */
/datum/ai_behavior/find_and_set/nearest_wall

/datum/ai_behavior/find_and_set/nearest_wall/search_tactic(datum/ai_controller/controller, locate_path, search_range)
	var/mob/living/living_pawn = controller.pawn

	var/list/nearby_walls = list()
	for (var/turf/closed/new_wall in oview(search_range, controller.pawn))
		if (isindestructiblewall(new_wall))
			continue
		nearby_walls += new_wall

	if(nearby_walls.len)
		return get_closest_atom(/turf/closed/, nearby_walls, living_pawn)

/**
 * A variant that looks for a human who is not dead or incapacitated, and has a mind
 */
/datum/ai_behavior/find_and_set/conscious_person

/datum/ai_behavior/find_and_set/conscious_person/search_tactic(datum/ai_controller/controller, locate_path, search_range)
	var/list/customers = list()
	for(var/mob/living/carbon/human/target in oview(search_range, controller.pawn))
		if(IS_DEAD_OR_INCAP(target) || !target.mind)
			continue
		customers += target

	if(customers.len)
		return pick(customers)

	return null

/datum/ai_behavior/find_and_set/nearby_friends
	action_cooldown = 2 SECONDS

/datum/ai_behavior/find_and_set/nearby_friends/search_tactic(datum/ai_controller/controller, locate_path, search_range)
	var/atom/friend = locate(/mob/living/carbon/human) in oview(search_range, controller.pawn)

	if(isnull(friend))
		return null

	var/mob/living/living_pawn = controller.pawn
	var/potential_friend = living_pawn.faction.Find(REF(friend)) ? friend : null
	return potential_friend


/datum/ai_behavior/find_and_set/in_list/turf_types

/datum/ai_behavior/find_and_set/in_list/turf_types/search_tactic(datum/ai_controller/controller, locate_paths, search_range)
	var/list/found = RANGE_TURFS(search_range, controller.pawn)
	shuffle_inplace(found)
	for(var/turf/possible_turf as anything in found)
		if(!is_type_in_typecache(possible_turf, locate_paths))
			continue
		if(can_see(controller.pawn, possible_turf, search_range))
			return possible_turf
	return null

/datum/ai_behavior/find_and_set/in_list/closest_turf

/datum/ai_behavior/find_and_set/in_list/closest_turf/search_tactic(datum/ai_controller/controller, locate_paths, search_range)
	var/list/found = RANGE_TURFS(search_range, controller.pawn)
	for(var/turf/possible_turf as anything in found)
		if(!is_type_in_typecache(possible_turf, locate_paths) || !can_see(controller.pawn, possible_turf, search_range))
			found -= possible_turf
	return (length(found)) ? get_closest_atom(/turf, found, controller.pawn) : null
