/// Static typecache list of things we might want to find
GLOBAL_LIST_INIT(find_and_set_interested_atoms, typecacheof(list(/obj/item, /mob/living, /turf, /obj/structure)))

/datum/ai_behavior/find_and_set
	action_cooldown = 2 SECONDS
	/// How far can we see stuff when setting up fields?
	var/vision_range = 7

/datum/ai_behavior/find_and_set/get_cooldown(datum/ai_controller/cooldown_for)
	if(cooldown_for.blackboard[BB_FIND_TARGETS_FIELD(type)])
		return 60 SECONDS
	return ..()

// Override existing variants to customize their field behavior

/datum/ai_behavior/find_and_set/pawn_must_hold_item
	vision_range = 5

/datum/ai_behavior/find_and_set/pawn_must_hold_item/atom_allowed(atom/movable/checking, locate_path, atom/pawn)
	var/mob/living/living_pawn = pawn
	if(!living_pawn.get_inactive_held_item() && !living_pawn.get_active_held_item())
		return FALSE
	return ..()

/datum/ai_behavior/find_and_set/edible
	vision_range = 9

/datum/ai_behavior/find_and_set/edible/atom_allowed(atom/movable/checking, locate_path, atom/pawn)
	if(checking == pawn)
		return FALSE
	if(!istype(checking, /obj/item/reagent_containers/food))
		return FALSE
	return TRUE

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

/datum/ai_behavior/find_and_set/in_hands
	vision_range = 1

/datum/ai_behavior/find_and_set/in_hands/failed_to_find_anything(datum/ai_controller/controller, set_key, locate_path, search_range)
	return // Don't set up fields for hand searches

/datum/ai_behavior/find_and_set/in_hands/search_tactic(datum/ai_controller/controller, locate_path)
	var/mob/living/living_pawn = controller.pawn
	return locate(locate_path) in living_pawn.held_items

/datum/ai_behavior/find_and_set/in_hands/given_list
	vision_range = 1

/datum/ai_behavior/find_and_set/in_hands/given_list/failed_to_find_anything(datum/ai_controller/controller, set_key, locate_paths, search_range)
	return

/datum/ai_behavior/find_and_set/in_hands/given_list/search_tactic(datum/ai_controller/controller, locate_paths)
	var/list/found = typecache_filter_list(controller.pawn, locate_paths)
	if(length(found))
		return pick(found)

/datum/ai_behavior/find_and_set/in_list
	vision_range = 8

/datum/ai_behavior/find_and_set/in_list/atom_allowed(atom/movable/checking, locate_paths, atom/pawn)
	if(checking == pawn)
		return FALSE
	if(!is_type_in_typecache(checking, locate_paths))
		return FALSE
	return TRUE

/datum/ai_behavior/find_and_set/in_list/search_tactic(datum/ai_controller/controller, locate_paths, search_range)
	var/list/found = typecache_filter_list(oview(search_range, controller.pawn), locate_paths)
	if(length(found))
		return pick(found)

/datum/ai_behavior/find_and_set/in_list/saiga
	vision_range = 12

/datum/ai_behavior/find_and_set/in_list/saiga/new_atoms_found(list/atom/movable/found, datum/ai_controller/controller)
	. = ..()
	if(.)
		controller.set_blackboard_key(BB_BASIC_MOB_FLEEING, FALSE)

/datum/ai_behavior/find_and_set/in_list/saiga/search_tactic(datum/ai_controller/controller, locate_paths, search_range)
	var/list/found = typecache_filter_list(oview(search_range, controller.pawn), locate_paths)
	if(length(found))
		controller.set_blackboard_key(BB_BASIC_MOB_FLEEING, FALSE)
		return pick(found)

/datum/ai_behavior/find_and_set/dead_bodies
	vision_range = 10

/datum/ai_behavior/find_and_set/dead_bodies/atom_allowed(atom/movable/checking, locate_paths, atom/pawn)
	if(checking == pawn)
		return FALSE
	if(!ismob(checking))
		return FALSE
	var/mob/living/mob_checking = checking
	if(mob_checking.stat < DEAD)
		return FALSE
	return TRUE

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

/datum/ai_behavior/find_and_set/nearest_wall
	vision_range = 7

/datum/ai_behavior/find_and_set/nearest_wall/failed_to_find_anything(datum/ai_controller/controller, set_key, locate_path, search_range)
	return // Walls don't move

/datum/ai_behavior/find_and_set/nearest_wall/search_tactic(datum/ai_controller/controller, locate_path, search_range)
	var/mob/living/living_pawn = controller.pawn
	var/list/nearby_walls = list()
	for (var/turf/closed/new_wall in oview(search_range, controller.pawn))
		if (isindestructiblewall(new_wall))
			continue
		nearby_walls += new_wall
	if(nearby_walls.len)
		return get_closest_atom(/turf/closed/, nearby_walls, living_pawn)

/datum/ai_behavior/find_and_set/conscious_person
	vision_range = 12

/datum/ai_behavior/find_and_set/conscious_person/atom_allowed(atom/movable/checking, locate_path, atom/pawn)
	if(checking == pawn)
		return FALSE
	if(!ishuman(checking))
		return FALSE
	var/mob/living/carbon/human/human = checking
	if(IS_DEAD_OR_INCAP(human) || !human.mind)
		return FALSE
	return TRUE

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
	vision_range = 15

/datum/ai_behavior/find_and_set/nearby_friends/atom_allowed(atom/movable/checking, locate_path, atom/pawn)
	if(checking == pawn)
		return FALSE
	if(!ishuman(checking))
		return FALSE
	var/mob/living/living_pawn = pawn
	return living_pawn.faction.Find(REF(checking)) ? TRUE : FALSE

/datum/ai_behavior/find_and_set/nearby_friends/search_tactic(datum/ai_controller/controller, locate_path, search_range)
	var/atom/friend = locate(/mob/living/carbon/human) in oview(search_range, controller.pawn)
	if(isnull(friend))
		return null
	var/mob/living/living_pawn = controller.pawn
	var/potential_friend = living_pawn.faction.Find(REF(friend)) ? friend : null
	return potential_friend

/datum/ai_behavior/find_and_set/in_list/turf_types
	vision_range = 7

/datum/ai_behavior/find_and_set/in_list/turf_types/failed_to_find_anything(datum/ai_controller/controller, set_key, locate_paths, search_range)
	return // Turfs don't move

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
	vision_range = 7

/datum/ai_behavior/find_and_set/in_list/closest_turf/failed_to_find_anything(datum/ai_controller/controller, set_key, locate_paths, search_range)
	return // Turfs don't move

/datum/ai_behavior/find_and_set/in_list/closest_turf/search_tactic(datum/ai_controller/controller, locate_paths, search_range)
	var/list/found = RANGE_TURFS(search_range, controller.pawn)
	for(var/turf/possible_turf as anything in found)
		if(!is_type_in_typecache(possible_turf, locate_paths) || !can_see(controller.pawn, possible_turf, search_range))
			found -= possible_turf
	return (length(found)) ? get_closest_atom(/turf, found, controller.pawn) : null

/datum/ai_behavior/find_and_set/unclaimed_stall
	vision_range = 5

/datum/ai_behavior/find_and_set/unclaimed_stall/failed_to_find_anything(datum/ai_controller/controller, set_key, locate_path, search_range)
	return // Stalls are static

/datum/ai_behavior/find_and_set/unclaimed_stall/search_tactic(datum/ai_controller/controller, locate_path, search_range)
	var/list/found_stalls = list()
	for(var/obj/effect/landmark/stall/stall in GLOB.trader_location)
		if(!stall.claimed_by_trader)
			found_stalls += stall
	if(length(found_stalls))
		return pick(found_stalls)
	return null

/datum/ai_behavior/find_and_set/armor
	vision_range = 8

/datum/ai_behavior/find_and_set/armor/atom_allowed(atom/movable/checking, locate_path, atom/pawn)
	if(checking == pawn)
		return FALSE
	if(!istype(checking, /obj/item/clothing))
		return FALSE
	var/obj/item/clothing/clothing = checking
	var/mob/living/carbon/living_pawn = pawn
	var/datum/ai_controller/controller = living_pawn.ai_controller
	if(clothing.armor_class != controller.blackboard[BB_ARMOR_CLASS])
		return FALSE
	if(!(living_pawn?.dna?.species?.id in clothing.allowed_race))
		return FALSE
	return TRUE

/datum/ai_behavior/find_and_set/armor/search_tactic(datum/ai_controller/controller, locate_path, search_range)
	var/mob/living/carbon/living_pawn = controller.pawn
	var/list/armor = list()
	for(var/obj/item/clothing/local_candidate as anything in oview(search_range, controller.pawn))
		if(!istype(local_candidate, /obj/item/clothing))
			continue
		var/obj/item/clothing/clothing = local_candidate
		if(clothing.armor_class != controller.blackboard[BB_ARMOR_CLASS])
			continue
		if(!(living_pawn?.dna?.species?.id in local_candidate.allowed_race))
			continue
		armor += local_candidate
	if(armor.len)
		return pick(armor)

/datum/ai_behavior/find_and_set/home
	vision_range = 10

/datum/ai_behavior/find_and_set/home/atom_allowed(atom/movable/checking, locate_path, atom/pawn)
	if(checking == pawn)
		return FALSE
	if(istype(pawn.loc, locate_path))
		return FALSE // already home
	if(!istype(checking, /obj/structure))
		return FALSE
	if(!SEND_SIGNAL(checking, COMSIG_HABITABLE_HOME, pawn))
		return FALSE
	return TRUE

/datum/ai_behavior/find_and_set/home/search_tactic(datum/ai_controller/controller, locate_path, search_range)
	var/list/valid_homes = list()
	var/mob/living/pawn = controller.pawn
	if(istype(pawn.loc, locate_path))
		return pawn.loc //for premade homes
	for(var/obj/structure/potential_home in oview(search_range, pawn))
		if(!SEND_SIGNAL(potential_home, COMSIG_HABITABLE_HOME, pawn))
			continue
		valid_homes += potential_home
	if(valid_homes.len)
		return pick(valid_homes)

/datum/ai_behavior/find_and_set/better_weapon
	vision_range = 7

/datum/ai_behavior/find_and_set/better_weapon/atom_allowed(atom/movable/checking, locate_path, atom/pawn)
	if(checking == pawn)
		return FALSE
	var/mob/living/carbon/living_pawn = pawn
	var/datum/ai_controller/controller = living_pawn.ai_controller
	if(!istype(checking, controller.blackboard[BB_WEAPON_TYPE]))
		return FALSE
	var/obj/item/held_item = living_pawn.get_active_held_item()
	if(istype(held_item, /obj/item/weapon/shield))
		held_item = living_pawn.get_inactive_held_item()
	if(held_item)
		var/obj/item/weapon/candidate = checking
		if(held_item.force >= candidate.force)
			return FALSE
	return TRUE

/datum/ai_behavior/find_and_set/better_weapon/search_tactic(datum/ai_controller/controller, locate_path, search_range)
	var/mob/living/carbon/living_pawn = controller.pawn
	var/obj/item/held_item = living_pawn.get_active_held_item()
	if(istype(held_item, /obj/item/weapon/shield))
		living_pawn.swap_hand()
		held_item = living_pawn.get_active_held_item()
	var/list/weapons = list()
	for(var/obj/item/weapon/local_candidate in oview(search_range, controller.pawn))
		if(!istype(local_candidate, controller.blackboard[BB_WEAPON_TYPE]))
			continue
		if(held_item)
			if(held_item.force >= local_candidate.force)
				continue
		weapons += local_candidate
	if(weapons.len)
		return pick(weapons)

/datum/ai_behavior/find_and_set/human_beg
	vision_range = 6

/datum/ai_behavior/find_and_set/human_beg/atom_allowed(atom/movable/checking, locate_path, atom/pawn)
	if(checking == pawn)
		return FALSE
	if(!ishuman(checking))
		return FALSE
	var/mob/living/carbon/human/human_target = checking
	if(human_target.stat != CONSCIOUS || isnull(human_target.mind))
		return FALSE
	var/mob/living/living_pawn = pawn
	var/datum/ai_controller/controller = living_pawn.ai_controller
	var/list/locate_items = controller.blackboard[BB_BASIC_FOODS]
	if(!length(typecache_filter_list(human_target.held_items, locate_items)))
		return FALSE
	return TRUE

/datum/ai_behavior/find_and_set/human_beg/search_tactic(datum/ai_controller/controller, locate_path, search_range)
	var/list/locate_items = controller.blackboard[BB_BASIC_FOODS]
	for(var/mob/living/carbon/human/human_target in oview(search_range, controller.pawn))
		if(human_target.stat != CONSCIOUS || isnull(human_target.mind))
			continue
		if(!length(typecache_filter_list(human_target.held_items, locate_items)))
			continue
		return human_target
	return null

/datum/ai_behavior/find_and_set/cat_tresspasser
	vision_range = 8

/datum/ai_behavior/find_and_set/cat_tresspasser/atom_allowed(atom/movable/checking, locate_path, atom/pawn)
	if(checking == pawn)
		return FALSE
	if(!istype(checking, /mob/living/simple_animal/pet/cat))
		return FALSE
	var/mob/living/simple_animal/pet/cat/potential_enemy = checking
	if(potential_enemy.gender != MALE)
		return FALSE
	var/mob/living/living_pawn = pawn
	var/datum/ai_controller/controller = living_pawn.ai_controller
	var/list/ignore_types = controller.blackboard[BB_BABIES_CHILD_TYPES]
	if(is_type_in_list(potential_enemy, ignore_types))
		return FALSE
	var/datum/ai_controller/basic_controller/enemy_controller = potential_enemy.ai_controller
	if(isnull(enemy_controller))
		return FALSE
	//theyre already engaged in a battle, leave them alone!
	if(enemy_controller.blackboard_key_exists(BB_TRESSPASSER_TARGET))
		return FALSE
	return TRUE

/datum/ai_behavior/find_and_set/cat_tresspasser/new_atoms_found(list/atom/movable/found, datum/ai_controller/controller)
	var/atom/pawn = controller.pawn
	var/list/accepted_cats = list()

	// Get the stored parameters from the field
	var/datum/proximity_monitor/advanced/ai_find_tracking/field = controller.blackboard[BB_FIND_TARGETS_FIELD(type)]
	if(!field)
		return FALSE

	for(var/maybe_cat as anything in found)
		if(maybe_cat == pawn)
			continue
		if(!atom_allowed(maybe_cat, field.locate_path, pawn))
			continue
		accepted_cats += maybe_cat

	if(!length(accepted_cats))
		return FALSE

	// Special handling for cat trespasser - set mutual targeting
	var/mob/living/simple_animal/pet/cat/target_cat = pick(accepted_cats)
	var/datum/ai_controller/basic_controller/enemy_controller = target_cat.ai_controller
	//u choose me and i choose u
	enemy_controller.set_blackboard_key(BB_TRESSPASSER_TARGET, controller.pawn)

	controller.set_blackboard_key(field.set_key, target_cat)
	finish_action(controller, succeeded = TRUE)
	return TRUE

/datum/ai_behavior/find_and_set/cat_tresspasser/search_tactic(datum/ai_controller/controller, locate_path, search_range)
	var/list/ignore_types = controller.blackboard[BB_BABIES_CHILD_TYPES]
	for(var/mob/living/simple_animal/pet/cat/potential_enemy in oview(search_range, controller.pawn))
		if(potential_enemy.gender != MALE)
			continue
		if(is_type_in_list(potential_enemy, ignore_types))
			continue
		var/datum/ai_controller/basic_controller/enemy_controller = potential_enemy.ai_controller
		if(isnull(enemy_controller))
			continue
		//theyre already engaged in a battle, leave them alone!
		if(enemy_controller.blackboard_key_exists(BB_TRESSPASSER_TARGET))
			continue
		//u choose me and i choose u
		enemy_controller.set_blackboard_key(BB_TRESSPASSER_TARGET, controller.pawn)
		return potential_enemy
	return null

/datum/ai_behavior/find_and_set/swim_alternate
	vision_range = 5

/datum/ai_behavior/find_and_set/swim_alternate/failed_to_find_anything(datum/ai_controller/controller, set_key, locate_path, search_range)
	// If we're using a field rn, just don't do anything yeah?
	if(controller.blackboard[BB_FIND_TARGETS_FIELD(type)])
		return

	var/aggro_range = vision_range
	// takes the larger between our range() input and our implicit oview() input (world.view)
	aggro_range = max(aggro_range, ROUND_UP(max(getviewsize(world.view)) / 2))
	// Set up proximity field to wait for something to come along - use custom swim monitor
	var/datum/proximity_monitor/advanced/ai_find_tracking/swim_alternate/detection_field = new(
		controller.pawn,
		aggro_range,
		TRUE,
		src,
		controller,
		set_key,
		locate_path,
		search_range,
	)
	// Store this field in our blackboard
	controller.set_blackboard_key(BB_FIND_TARGETS_FIELD(type), detection_field)

/datum/ai_behavior/find_and_set/swim_alternate/atom_allowed(atom/movable/checking, locate_path, atom/pawn)
	return FALSE // This one is turf-based

/datum/ai_behavior/find_and_set/swim_alternate/new_atoms_found(list/atom/movable/found, datum/ai_controller/controller)
	return FALSE // This behavior looks for turfs, not movable atoms

/datum/ai_behavior/find_and_set/swim_alternate/search_tactic(datum/ai_controller/controller, locate_path, search_range)
	var/mob/living/living_pawn = controller.pawn
	if(QDELETED(living_pawn))
		return null
	var/look_for_land = controller.blackboard[BB_CURRENTLY_SWIMMING]
	var/list/possible_turfs = list()
	for(var/turf/possible_turf in oview(search_range, living_pawn))
		if(isclosedturf(possible_turf) || isopenspace(possible_turf))
			continue
		if(possible_turf.is_blocked_turf())
			continue
		if(look_for_land == istype(possible_turf, /turf/open/water))
			continue
		possible_turfs += possible_turf
	if(!length(possible_turfs))
		return null
	return(pick(possible_turfs))

// Custom proximity monitor for swim_alternate that checks turfs
/datum/proximity_monitor/advanced/ai_find_tracking/swim_alternate

/datum/proximity_monitor/advanced/ai_find_tracking/swim_alternate/setup_field_turf(turf/target)
	. = ..()
	var/mob/living/living_pawn = target_controller.pawn
	if(QDELETED(living_pawn))
		return
	var/look_for_land = target_controller.blackboard[BB_CURRENTLY_SWIMMING]

	if(isclosedturf(target) || isopenspace(target))
		return
	if(target.is_blocked_turf())
		return
	if(look_for_land == istype(target, /turf/open/water))
		return

	// Found a valid turf
	target_controller.set_blackboard_key(set_key, target)
	parent_behavior.finish_action(target_controller, succeeded = TRUE)

/datum/ai_behavior/find_and_set/perform(delta_time, datum/ai_controller/controller, set_key, locate_path, search_range)
	. = ..()
	var/find_this_thing = search_tactic(controller, locate_path, search_range)
	if(find_this_thing)
		controller.set_blackboard_key(set_key, find_this_thing)
		finish_action(controller, TRUE)
	else
		failed_to_find_anything(controller, set_key, locate_path, search_range)
		finish_action(controller, FALSE)

/datum/ai_behavior/find_and_set/proc/search_tactic(datum/ai_controller/controller, locate_path, search_range)
	return locate(locate_path) in oview(search_range, controller.pawn)

/datum/ai_behavior/find_and_set/proc/failed_to_find_anything(datum/ai_controller/controller, set_key, locate_path, search_range)
	// If we're using a field rn, just don't do anything yeah?
	if(controller.blackboard[BB_FIND_TARGETS_FIELD(type)])
		return

	var/aggro_range = vision_range
	// takes the larger between our range() input and our implicit oview() input (world.view)
	aggro_range = max(aggro_range, ROUND_UP(max(getviewsize(world.view)) / 2))
	// Set up proximity field to wait for something to come along
	var/datum/proximity_monitor/advanced/ai_find_tracking/detection_field = new(
		controller.pawn,
		aggro_range,
		TRUE,
		src,
		controller,
		set_key,
		locate_path,
		search_range,
	)
	// Store this field in our blackboard
	controller.set_blackboard_key(BB_FIND_TARGETS_FIELD(type), detection_field)

/datum/ai_behavior/find_and_set/proc/new_turf_found(turf/found, datum/ai_controller/controller)
	var/valid_found = FALSE
	var/atom/pawn = controller.pawn
	for(var/maybe_item as anything in found)
		if(maybe_item == pawn)
			continue
		if(!is_type_in_typecache(maybe_item, GLOB.find_and_set_interested_atoms))
			continue
		// Get the stored parameters from the field
		var/datum/proximity_monitor/advanced/ai_find_tracking/field = controller.blackboard[BB_FIND_TARGETS_FIELD(type)]
		if(!field)
			continue
		if(!atom_allowed(maybe_item, field.locate_path, pawn))
			continue
		valid_found = TRUE
		break
	if(!valid_found)
		return
	// If we found any one thing we "could" use, then run the full search again
	var/datum/proximity_monitor/field = controller.blackboard[BB_FIND_TARGETS_FIELD(type)]
	qdel(field) // autoclears so it's fine
	// Fire instantly
	controller.modify_cooldown(src, world.time)

/datum/ai_behavior/find_and_set/proc/new_atoms_found(list/atom/movable/found, datum/ai_controller/controller)
	var/atom/pawn = controller.pawn
	var/list/accepted_items = list()

	// Get the stored parameters from the field
	var/datum/proximity_monitor/advanced/ai_find_tracking/field = controller.blackboard[BB_FIND_TARGETS_FIELD(type)]
	if(!field)
		return FALSE

	for(var/maybe_item as anything in found)
		if(maybe_item == pawn)
			continue
		if(!atom_allowed(maybe_item, field.locate_path, pawn))
			continue
		accepted_items += maybe_item

	if(!length(accepted_items))
		return FALSE

	// Found something acceptable, set it and finish
	var/atom/final_item = pick_final_item(controller, accepted_items)
	controller.set_blackboard_key(field.set_key, final_item)

	finish_action(controller, succeeded = TRUE)
	return TRUE

/datum/ai_behavior/find_and_set/proc/atom_allowed(atom/movable/checking, locate_path, atom/pawn)
	if(checking == pawn)
		return FALSE
	if(!istype(checking, locate_path))
		return FALSE
	return TRUE

/datum/ai_behavior/find_and_set/proc/pick_final_item(datum/ai_controller/controller, list/filtered_items)
	return pick(filtered_items)

/datum/ai_behavior/find_and_set/finish_action(datum/ai_controller/controller, succeeded, ...)
	. = ..()
	if(succeeded)
		var/datum/proximity_monitor/field = controller.blackboard[BB_FIND_TARGETS_FIELD(type)]
		qdel(field) // autoclears so it's fine
		controller.CancelActions()
		controller.modify_cooldown(src, world.time + get_cooldown(controller))

/**
 * Proximity monitor for find_and_set tracking
 */
/datum/proximity_monitor/advanced/ai_find_tracking
	var/datum/ai_behavior/find_and_set/parent_behavior
	var/datum/ai_controller/target_controller
	var/set_key
	var/locate_path
	var/search_range

/datum/proximity_monitor/advanced/ai_find_tracking/New(atom/center, range, ignore_if_not_on_turf, datum/ai_behavior/find_and_set/behavior, datum/ai_controller/controller, key, path, s_range)
	parent_behavior = behavior
	target_controller = controller
	set_key = key
	locate_path = path
	search_range = s_range
	. = ..()

/datum/proximity_monitor/advanced/ai_find_tracking/setup_field_turf(turf/target)
	. = ..()
	parent_behavior.new_turf_found(target, target_controller)

/datum/proximity_monitor/advanced/ai_find_tracking/field_edge_crossed(atom/movable/movable, turf/location, direction)
	. = ..()
	parent_behavior.new_atoms_found(list(movable), target_controller)

/datum/proximity_monitor/advanced/ai_find_tracking/field_turf_crossed(atom/movable/movable, turf/location)
	. = ..()
	parent_behavior.new_atoms_found(list(movable), target_controller)

/datum/proximity_monitor/advanced/ai_find_tracking/Destroy()
	if(target_controller)
		target_controller.clear_blackboard_key(BB_FIND_TARGETS_FIELD(parent_behavior.type))
	parent_behavior = null
	target_controller = null
	return ..()
