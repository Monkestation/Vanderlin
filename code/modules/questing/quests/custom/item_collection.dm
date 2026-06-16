
/datum/quest/custom/item_collection
	issue_label = "Item Collection"
	custom_quest_flags = CUSTOM_QUEST_NOTICEBOARD | CUSTOM_QUEST_PLEDGE

	var/obj/item/custom_item_type
	var/custom_item_name = ""
	var/custom_item_count = 1

/datum/quest/custom/item_collection/get_title()
	if(title)
		return title
	return "Procure [custom_item_count > 1 ? "[custom_item_count]x " : ""][custom_item_name]"

/datum/quest/custom/item_collection/get_objective_text()
	return "Bring [custom_item_count] [custom_item_name] to [quest_giver_name ? quest_giver_name : "the steward"]."

/datum/quest/custom/item_collection/generate(obj/effect/landmark/quest_spawner/landmark)
	. = ..()
	progress_required = custom_item_count
	return TRUE

/datum/quest/custom/item_collection/check_completion()
	return progress_current >= progress_required

/datum/quest/custom/item_collection/build_from_user(mob/user)
	if(!fill_common_fields(user))
		return FALSE

	var/search_query = tgui_input_text(user, "Search for the item:", "Item Search", "", 60)
	if(!search_query)
		return FALSE

	var/list/results = search_item_types_global(search_query)
	if(!length(results))
		return FALSE

	var/chosen_name = tgui_input_list(user, "Select the item:", "Item Search Results", results)
	if(!chosen_name)
		return FALSE

	custom_item_type = results[chosen_name]
	custom_item_name = chosen_name

	var/count = tgui_input_number(user, "How many [chosen_name] are needed?", "Item Count", 1, 10, 1)
	if(!count || count < 1)
		return FALSE

	custom_item_count = count
	progress_required = count
	quest_giver_reference = WEAKREF(user)
	quest_giver_name = user.real_name

	var/auto_title = get_title()
	var/custom_title = tgui_input_text(user, "Give this quest a title (blank = auto):", "Quest Title", "", 80)
	title = custom_title ? custom_title : auto_title
	return TRUE

/datum/quest/custom/item_collection/build_from_pledge(obj/item/paper/scroll/quest/pledge/PL, mob/steward)
	. = ..(PL, steward)
	custom_item_type = PL.pledge_item_type
	custom_item_name = PL.pledge_item_name
	custom_item_count = PL.pledge_item_count
	progress_required = PL.pledge_item_count
	return TRUE

/datum/quest/custom/item_collection/build_pledge(obj/item/paper/scroll/quest/pledge/PL)
	..()
	PL.pledge_item_type = custom_item_type
	PL.pledge_item_name = custom_item_name
	PL.pledge_item_count = custom_item_count

/datum/quest/custom/item_collection/validate(mob/steward, turf/input_point)
	var/list/items_on_marker = list()
	for(var/obj/item/I in input_point)
		items_on_marker += I
	if(!length(items_on_marker) || !check_item_turnin(items_on_marker, input_point))
		return FALSE
	return TRUE

/datum/quest/custom/item_collection/proc/check_item_turnin(list/items_on_marker, turf/input_point)
	if(!custom_item_type)
		return FALSE
	var/count = 0
	for(var/obj/item/I in items_on_marker)
		if(istype(I, custom_item_type))
			count++
	if(count < custom_item_count)
		return FALSE
	var/obj/item/quest_package/P = new(input_point)
	P.name = "quest parcel ([custom_item_name])"
	P.quest_title = title
	P.pledge_ref = pledge_ref
	var/consumed = 0
	for(var/obj/item/I in items_on_marker)
		if(istype(I, custom_item_type) && consumed < custom_item_count)
			I.forceMove(P)
			consumed++
	progress_current = progress_required
	mark_complete()
	return TRUE
