/datum/quest/custom
	quest_type = QUEST_CUSTOM
	quest_difficulty = QUEST_DIFFICULTY_EASY
	/// Bitfield of CUSTOM_QUEST_* flags — controls where this type can be issued from.
	var/custom_quest_flags = CUSTOM_QUEST_NOTICEBOARD | CUSTOM_QUEST_PLEDGE
	/// Label shown in the quest-type picker. Must be set on each concrete subtype.
	var/issue_label = ""
	/// Weakref to the /obj/item/paper/scroll/quest/pledge that created this quest, if any.
	var/datum/weakref/pledge_ref

/datum/quest/custom/get_title()
	return title ? title : "Special Commission"

/datum/quest/custom/get_objective_text()
	return "Speak with [quest_giver_name ? quest_giver_name : "the steward"] for details."

/datum/quest/custom/get_location_text()
	return "Speak to [quest_giver_name ? quest_giver_name : "the steward"] for instructions."

/datum/quest/custom/generate(obj/effect/landmark/quest_spawner/landmark)
	add_abstract_elastic_data(ELASCAT_ECONOMY, ELASDATA_QUEST_CREATED, 1)
	if(!title)
		title = get_title()
	if(landmark)
		var/datum/threat_region/TR = SSregionthreat.get_region_for_turf(get_turf(landmark))
		if(TR)
			threat_region_name = TR.region_name
	progress_required = 1
	return TRUE

/datum/quest/custom/check_completion()
	return progress_current >= progress_required

/**
 * Interactive builder: called when a steward issues this quest from the notice board.
 * Handles all tgui prompts needed to fully configure the datum.
 * fill_common_fields() should be called inside here for difficulty + reward.
 * Returns TRUE on success, FALSE if the user cancelled or input was invalid.
 */
/datum/quest/custom/proc/build_from_user(mob/user)
	return FALSE

/**
 * Non-interactive builder: called when a sealed pledge scroll is posted to the board.
 * Copies pledge fields onto this datum. Subtypes call ..() then fill their own vars.
 * Returns TRUE on success, FALSE if required pledge data is missing.
 */
/datum/quest/custom/proc/build_from_pledge(obj/item/paper/scroll/quest/pledge/PL, mob/steward)
	quest_difficulty = PL.pledge_difficulty
	reward_amount = PL.escrowed_mammons
	title = PL.pledge_title
	quest_giver_reference = WEAKREF(steward)
	quest_giver_name = steward.real_name
	return TRUE

/datum/quest/custom/proc/build_pledge(obj/item/paper/scroll/quest/pledge/PL)
	PL.pledge_difficulty = quest_difficulty
	PL.pledge_reward = reward_amount
	PL.pledge_title = title

/**
 * Validate a turn-in at the board's input_point.
 * The default falls through to manual steward validation.
 * Subtypes that do automatic checking (items, reagents) override this.
 * Returns TRUE if the quest was completed by this call.
 */
/datum/quest/custom/proc/validate(mob/steward, turf/input_point)
	return steward_validate(steward)

/datum/quest/custom/proc/on_validate_fail(mob/steward, turf/input_point, atom/movable/talker)
	talker.say("Validation failed for \"[title]\". Ensure the required items or conditions are met.")

/datum/quest/custom/proc/steward_validate(mob/steward)
	if(!ishuman(steward))
		return FALSE
	var/datum/job/steward_job = steward.job ? SSjob.GetJob(steward.job) : null
	if(!steward_job?.is_quest_giver)
		to_chat(steward, span_warning("Only a quest-issuing role can validate quests."))
		return FALSE
	if(complete)
		to_chat(steward, span_notice("This quest is already complete."))
		return FALSE
	log_quest(steward.ckey, steward.mind, steward, "Validate custom quest: [title]")
	mark_complete()
	to_chat(steward, span_notice("You validate \"[title]\" as complete."))
	return TRUE

/// Shared helper — asks for difficulty + reward and writes them onto the datum.
/// Returns TRUE if the user completed both prompts.
/datum/quest/custom/proc/fill_common_fields(mob/user)
	var/list/diff_choices = list(QUEST_DIFFICULTY_EASY, QUEST_DIFFICULTY_MEDIUM, QUEST_DIFFICULTY_HARD)
	var/diff = tgui_input_list(user, "Quest difficulty?", "Custom Quest Difficulty", diff_choices)
	if(!diff)
		return FALSE
	quest_difficulty = diff

	var/suggested_reward = get_base_reward()
	var/reward = tgui_input_number(user,
		"Set the reward (mammons). Suggested: [suggested_reward]",
		"Reward", suggested_reward, 9999, 1)
	if(!reward || reward < 1)
		return FALSE

	reward_amount = reward
	return TRUE
