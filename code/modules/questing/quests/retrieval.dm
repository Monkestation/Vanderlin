/datum/quest/retrieval
	quest_type = QUEST_RETRIEVAL
	var/list/fetch_items = list(
		/obj/item/weapon/knife/throwingknife/steel,
		/obj/item/weapon/knife,
		/obj/item/reagent_containers/glass/bottle/whitewine
	)

/datum/quest/retrieval/get_title()
	if(title)
		return title
	return "Retrieve [pick("an ancient", "a rare", "a stolen", "a magical")] [pick("artifact", "relic", "doohickey", "treasure")]"

/datum/quest/retrieval/get_objective_text()
	return "Retrieve [progress_required] [initial(target_item_type.name)]."


/datum/quest/retrieval/get_additional_reward(target_turf)
	var/turf/scroll_turf = get_turf(quest_scroll)
	var/distance = CLAMP(get_dist(scroll_turf, target_turf), 0, 200) // Avoid infinity rewards if it bugs out
	var/distance_reward = (distance / QUEST_DELIVERY_DISTANCE_DIVISOR) * QUEST_DELIVERY_DISTANCE_BONUS
	var/item_bonus = progress_required * QUEST_DELIVERY_PER_ITEM_BONUS

	return ROUND_UP(distance_reward + item_bonus)

/datum/quest/retrieval/generate(obj/effect/landmark/quest_spawner/landmark)
	..()
	if(!landmark)
		return FALSE

	// Select random item type from landmark's list
	target_item_type = pick(fetch_items)
	progress_required = rand(1, 3)
	target_spawn_area = get_area_name(get_turf(landmark))

	// Spawn items
	for(var/i in 1 to progress_required)
		var/turf/spawn_turf = landmark.get_safe_spawn_turf()
		if(!spawn_turf)
			continue

		var/obj/item/new_item = new target_item_type(spawn_turf)
		new_item.AddComponent(/datum/component/quest_object/retrieval, src)
		add_tracked_atom(new_item)

	return TRUE
