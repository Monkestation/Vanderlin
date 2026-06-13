#define CUSTOM_MODE_REAGENT "reagent"

/datum/quest/custom/reagent
	issue_label = "Liquid Collection"
	custom_quest_flags = CUSTOM_QUEST_NOTICEBOARD | CUSTOM_QUEST_PLEDGE
	quest_type = QUEST_CUSTOM

	var/reagent_type_path = null
	var/reagent_name = ""
	var/reagent_volume_required = 10
	var/reagent_volume_current = 0

/datum/quest/custom/reagent/build_from_user(mob/user)
	if(!fill_common_fields(user))
		return FALSE

	var/search_query = tgui_input_text(user, "Search for the reagent:", "Reagent Search", "", 60)
	if(!search_query)
		return FALSE

	var/list/results = search_reagent_types_global(search_query)
	if(!length(results))
		return FALSE // caller displays "no results"

	var/chosen_name = tgui_input_list(user, "Select the reagent:", "Reagent Search Results", results)
	if(!chosen_name)
		return FALSE

	reagent_type_path = results[chosen_name]
	reagent_name = chosen_name

	var/volume = tgui_input_number(user,
		"How many ligulae of [chosen_name] are needed? (max 100)",
		"Reagent Volume", 10, 100, 1)
	if(!volume || volume < 1)
		return FALSE

	reagent_volume_required = volume
	progress_required = volume
	quest_giver_reference = WEAKREF(user)
	quest_giver_name = user.real_name

	var/auto_title = get_title()
	var/custom_title = tgui_input_text(user, "Give this quest a title (blank = auto):", "Quest Title", "", 80)
	title = custom_title ? custom_title : auto_title
	return TRUE

/datum/quest/custom/reagent/build_from_pledge(obj/item/paper/scroll/quest/pledge/PL, mob/steward)
	if(!..())
		return FALSE
	reagent_type_path = PL.pledge_reagent_type
	reagent_name = PL.pledge_reagent_name
	reagent_volume_required = PL.pledge_reagent_volume
	progress_required = PL.pledge_reagent_volume
	if(!reagent_type_path || !reagent_name)
		return FALSE
	return TRUE

/datum/quest/custom/reagent/build_pledge(obj/item/paper/scroll/quest/pledge/PL)
	..()
	PL.pledge_reagent_type = reagent_type_path
	PL.pledge_reagent_name = reagent_name
	PL.pledge_reagent_volume = reagent_volume_required

/datum/quest/custom/reagent/validate(mob/steward, turf/input_point)
	return check_reagent_turnin(input_point)

/datum/quest/custom/reagent/get_title()
	if(title)
		return title
	return "Procure [reagent_volume_required] ligulae of [reagent_name ? reagent_name : "reagent"]"

/datum/quest/custom/reagent/get_objective_text()
	return "Bring [reagent_volume_required] ligulae of [reagent_name] (in any container) to \
		[quest_giver_name ? quest_giver_name : "the steward"]'s drop-off point."

/datum/quest/custom/reagent/generate(obj/effect/landmark/quest_spawner/landmark)
	if(!title)
		title = get_title()
	if(landmark)
		var/datum/threat_region/TR = SSregionthreat.get_region_for_turf(get_turf(landmark))
		if(TR)
			threat_region_name = TR.region_name
	progress_required = reagent_volume_required
	return TRUE

/datum/quest/custom/reagent/check_completion()
	return reagent_volume_current >= reagent_volume_required

/// Scans every atom on input_point for the target reagent,
/// marks complete if the threshold is met.
/// Returns TRUE if the quest was completed by this turn-in.
/datum/quest/custom/reagent/proc/check_reagent_turnin(turf/input_point)
	if(!reagent_type_path || complete)
		return FALSE

	// Tally up available volume across all containers on the marker
	var/total = 0
	for(var/atom/movable/A in input_point)
		if(!A.reagents)
			continue
		if(!A.reagents.has_reagent(reagent_type_path))
			continue
		total += A.reagents.get_reagent_amount(reagent_type_path)

	if(total < reagent_volume_required)
		return FALSE

	// Package up all containers that have the reagent
	var/obj/item/quest_package/P = new(input_point)
	P.name = "quest parcel ([reagent_name])"
	P.quest_title = title
	P.pledge_ref = pledge_ref

	for(var/atom/movable/A in input_point)
		if(A == P)
			continue
		if(!A.reagents?.has_reagent(reagent_type_path))
			continue
		A.forceMove(P)

	progress_current = reagent_volume_required
	mark_complete()
	return TRUE

#undef CUSTOM_MODE_REAGENT
