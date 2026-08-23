/datum/quest/custom/freeform
	issue_label = "Freeform (Manually Verified)"
	custom_quest_flags = CUSTOM_QUEST_NOTICEBOARD | CUSTOM_QUEST_PLEDGE

	var/custom_objective_text = ""
	var/steward_validated = FALSE

/datum/quest/custom/freeform/get_title()
	return title ? title : "Special Commission"

/datum/quest/custom/freeform/get_objective_text()
	return custom_objective_text ? custom_objective_text \
		: "Speak with [quest_giver_name ? quest_giver_name : "the steward"] for details."

/datum/quest/custom/freeform/check_completion()
	return steward_validated

/datum/quest/custom/freeform/build_from_user(mob/user)
	if(!fill_common_fields(user))
		return FALSE

	var/obj_text = tgui_input_text(user, "Describe what the adventurer must do:", "Quest Objective", "", 200)
	if(!obj_text)
		return FALSE

	custom_objective_text = obj_text
	quest_giver_reference = WEAKREF(user)
	quest_giver_name = user.real_name

	var/auto_title = get_title()
	var/custom_title = tgui_input_text(user, "Give this quest a title:", "Quest Title", "", 80)
	title = custom_title ? custom_title : auto_title
	return TRUE

/datum/quest/custom/freeform/build_from_pledge(obj/item/paper/scroll/quest/pledge/PL, mob/steward)
	. = ..(PL, steward)
	custom_objective_text = PL.pledge_objective
	return TRUE

/datum/quest/custom/freeform/build_pledge(obj/item/paper/scroll/quest/pledge/PL)
	..()
	PL.pledge_objective = custom_objective_text
