/datum/quest/custom/job_quest
	custom_quest_flags = CUSTOM_QUEST_PLEDGE
	var/required_job = null
	var/datum/weakref/signal_target_ref

/datum/quest/custom/job_quest/generate(obj/effect/landmark/quest_spawner/landmark)
	add_abstract_elastic_data(ELASCAT_ECONOMY, ELASDATA_QUEST_CREATED, 1)
	if(!title)
		title = get_title()
	if(landmark)
		var/datum/threat_region/TR = SSregionthreat.get_region_for_turf(get_turf(landmark))
		if(TR)
			threat_region_name = TR.region_name
	return TRUE

/datum/quest/custom/job_quest/build_from_user(mob/user)
	return fill_common_fields(user)

/datum/quest/custom/job_quest/build_from_pledge(obj/item/paper/scroll/quest/pledge/PL, mob/steward)
	return ..()

// Progress must be earned through signals so validate will run it through that.
/datum/quest/custom/job_quest/validate(mob/steward, turf/input_point)
	if(check_completion())
		mark_complete()
		return TRUE
	return FALSE

/datum/quest/custom/job_quest/on_validate_fail(mob/steward, turf/input_point, atom/movable/talker)
	talker.say("\"[title]\" is not yet complete. ([progress_current]/[progress_required])")

/datum/quest/custom/job_quest/check_completion()
	return progress_current >= progress_required

/datum/quest/custom/job_quest/on_claim(mob/acceptor)
	. = ..()
	signal_target_ref = WEAKREF(acceptor)
	register_progress_signals(acceptor)

/datum/quest/custom/job_quest/proc/on_quest_ended()
	var/mob/target = signal_target_ref?.resolve()
	if(target && !QDELETED(target))
		unregister_progress_signals(target)
	signal_target_ref = null

/datum/quest/custom/job_quest/proc/register_progress_signals(mob/acceptor)
	return

/datum/quest/custom/job_quest/proc/unregister_progress_signals(mob/acceptor)
	return

/datum/quest/custom/job_quest/proc/advance_progress(mob/source)
	progress_current = min(progress_current + 1, progress_required)
	if(check_completion())
		on_quest_ended()
		mark_complete()

// Covers abandonment, completion, and round-end — no call site can be missed.
/datum/quest/custom/job_quest/Destroy()
	on_quest_ended()
	return ..()
