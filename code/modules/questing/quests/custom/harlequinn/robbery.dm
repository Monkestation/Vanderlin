/datum/quest/custom/harlequinn_objective/rob
	var/datum/weakref/target_ref
	var/target_name = "Unknown"

/datum/quest/custom/harlequinn_objective/rob/setup_for_harlequinn(datum/antagonist/harlequinn/antag)
	. = ..()
	var/mob/living/carbon/human/harlequinn_mob = antag.owner?.current

	var/list/tier_weights = list(
		GLOB.noble_positions = 60,
		GLOB.garrison_positions = 30,
		GLOB.church_positions = 20,
		GLOB.inquisition_positions = 20,
		GLOB.serf_positions = 10,
		GLOB.company_positions = 10,
		GLOB.peasant_positions = 5,
		GLOB.apprentices_positions = 3,
		GLOB.youngfolk_positions = 2,
		GLOB.allmig_positions = 2,
	)

	var/list/pool = list()
	for(var/mob/living/carbon/human/H in GLOB.player_list)
		if(H == harlequinn_mob)
			continue
		if(H.stat == DEAD || !H.client)
			continue
		var/datum/job/mob_job = H.job ? SSjob.GetJob(H.job) : null
		if(!mob_job)
			continue
		var/weight = 1
		for(var/list/tier in tier_weights)
			if(mob_job.title in tier)
				weight = tier_weights[tier]
				break
		var/i = 0
		while(i < weight)
			pool += H
			i++

	if(!length(pool))
		return FALSE

	var/mob/living/carbon/human/target = pick(pool)
	target_ref = WEAKREF(target)
	target_name = target.real_name
	title = "Rob [target_name]"
	reward_amount = 300
	RegisterSignal(harlequinn_mob, COMSIG_MOB_STRIPPED_ITEM, PROC_REF(on_item_stripped))
	RegisterSignal(harlequinn_mob, COMSIG_ITEM_STOLEN, PROC_REF(on_item_stripped))
	return TRUE

/datum/quest/custom/harlequinn_objective/rob/get_objective_text()
	return "Steal from [target_name]. They won't miss it."

/datum/quest/custom/harlequinn_objective/rob/check_completion()
	return progress_current >= 1

/datum/quest/custom/harlequinn_objective/rob/proc/unregister_from_harlequinn(mob/living/carbon/human/harlequinn_mob)
	UnregisterSignal(harlequinn_mob, list(COMSIG_MOB_STRIPPED_ITEM, COMSIG_ITEM_STOLEN))

/datum/quest/custom/harlequinn_objective/rob/proc/on_item_stripped(mob/source, mob/living/victim, obj/item/stolen)
	SIGNAL_HANDLER
	var/mob/living/carbon/human/T = target_ref?.resolve()
	if(victim != T)
		return
	progress_current = 1
	unregister_from_harlequinn(source)
	mark_complete()

/datum/quest/custom/harlequinn_objective/rob/Destroy()
	var/mob/living/carbon/human/harlequinn_mob = owning_harlequinn?.resolve()
	if(harlequinn_mob && !QDELETED(harlequinn_mob))
		unregister_from_harlequinn(harlequinn_mob)
	return ..()
