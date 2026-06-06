/datum/quest/retrieval
	quest_type = QUEST_RETRIEVAL
	quest_difficulty = QUEST_DIFFICULTY_EASY
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


/datum/quest/retrieval/get_additional_reward(turf/target_turf)
	var/item_bonus = progress_required * QUEST_DELIVERY_PER_ITEM_BONUS
	return ROUND_UP(item_bonus)

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
