/datum/quest/custom/tame_animal
	issue_label = "Tame Animal"
	custom_quest_flags = CUSTOM_QUEST_PLEDGE
	var/mob/living/simple_animal/target_animal_type
	var/target_animal_name = ""

/datum/quest/custom/tame_animal/get_title()
	return title ? title : "Tame a [target_animal_name]"

/datum/quest/custom/tame_animal/get_objective_text()
	return "Tame a [target_animal_name] and bring it to the guild board."

/datum/quest/custom/tame_animal/get_location_text()
	return "Bring your tamed [target_animal_name] to [quest_giver_name ? quest_giver_name : "the steward"] at the guild board."

/datum/quest/custom/tame_animal/generate(obj/effect/landmark/quest_spawner/landmark)
	add_abstract_elastic_data(ELASCAT_ECONOMY, ELASDATA_QUEST_CREATED, 1)
	if(!title)
		title = get_title()
	if(landmark)
		var/datum/threat_region/TR = SSregionthreat.get_region_for_turf(get_turf(landmark))
		if(TR)
			threat_region_name = TR.region_name
	progress_required = 1
	return TRUE

/datum/quest/custom/tame_animal/build_from_user(mob/user)
	// Build list of tameable animal types, collapsing children under the
	// closest named parent when multiple subtypes share a name.
	var/list/name_to_path = list()
	for(var/mob/living/simple_animal/animal_type as anything in subtypesof(/mob/living/simple_animal))
		if(IS_ABSTRACT(animal_type))
			continue
		if(!initial(animal_type.tame_chance))
			continue
		var/aname = initial(animal_type.name)
		if(!aname)
			continue
		if(name_to_path[aname])
			// Keep the closest ancestor between the stored path and this one.
			var/atom/stored = name_to_path[aname]
			if(ispath(stored, animal_type))
				name_to_path[aname] = animal_type // animal_type is a parent, prefer it
		else
			name_to_path[aname] = animal_type

	if(!length(name_to_path))
		to_chat(user, span_warning("No tameable animals found."))
		return FALSE

	var/chosen_name = tgui_input_list(user, "Which animal should be tamed?", "Animal Type", name_to_path)
	if(!chosen_name)
		return FALSE

	target_animal_type = name_to_path[chosen_name]
	target_animal_name = chosen_name

	var/auto_title = get_title()
	var/custom_title = tgui_input_text(user, "Give this quest a title (blank = auto):", "Quest Title", "", 80)
	title = custom_title ? custom_title : auto_title

	if(!fill_common_fields(user))
		return FALSE

	quest_giver_reference = WEAKREF(user)
	quest_giver_name = user.real_name
	return TRUE

/datum/quest/custom/tame_animal/build_pledge(obj/item/paper/scroll/quest/pledge/PL)
	..()
	PL.pledge_item_type = target_animal_type
	PL.pledge_item_name = target_animal_name

/datum/quest/custom/tame_animal/build_from_pledge(obj/item/paper/scroll/quest/pledge/PL, mob/steward)
	if(!..())
		return FALSE
	target_animal_type = PL.pledge_item_type
	target_animal_name = PL.pledge_item_name
	progress_required = 1
	return TRUE

/datum/quest/custom/tame_animal/validate(mob/steward, turf/input_point)
	if(!target_animal_type)
		return FALSE

	var/mob/living/simple_animal/found
	for(var/mob/living/simple_animal/A in input_point)
		if(istype(A, target_animal_type) && A.tame)
			found = A
			break

	if(!found)
		return FALSE

	//unfriend the current owner, re-tame to the issuer.
	var/mob/living/issuer = quest_giver_reference?.resolve()
	if(issuer)
		// Unfriend everyone currently allied so the animal bonds cleanly.
		for(var/mob/living/ally in found.ai_controller?.blackboard[BB_FRIENDS_LIST])
			found.unfriend(ally)
		found.tamed(issuer)

	progress_current = progress_required
	mark_complete()
	return TRUE

/datum/quest/custom/tame_animal/on_validate_fail(mob/steward, turf/input_point, atom/movable/talker)
	talker.say("No tamed [target_animal_name] found on the marker. Place your animal there first.")
