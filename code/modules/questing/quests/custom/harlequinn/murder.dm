
/datum/quest/custom/harlequinn_objective/murder
	var/datum/weakref/target_ref
	var/target_name = "Unknown"

/datum/quest/custom/harlequinn_objective/murder/Destroy()
	var/atom/target = target_ref.resolve()
	if(target)
		UnregisterSignal(target, COMSIG_LIVING_DEATH)
	return ..()

/datum/quest/custom/harlequinn_objective/murder/setup_for_harlequinn(datum/antagonist/harlequinn/antag)
	. = ..()
	var/mob/living/carbon/human/harlequinn_mob = antag.owner?.current
	var/list/candidates = list()
	for(var/mob/living/carbon/human/H in GLOB.player_list)
		if(H == harlequinn_mob)
			continue
		if(H.stat == DEAD)
			continue
		if(!H.client)
			continue
		candidates += H

	if(!length(candidates))
		return FALSE

	var/mob/living/carbon/human/target = pick(candidates)
	target_ref = WEAKREF(target)
	target_name = target.real_name
	title = "Eliminate [target_name]"
	reward_amount = 300
	RegisterSignal(target, COMSIG_LIVING_DEATH, PROC_REF(on_death))
	return TRUE

/datum/quest/custom/harlequinn_objective/murder/get_objective_text()
	return "Eliminate [target_name]. Leave no witnesses to your involvement."

/datum/quest/custom/harlequinn_objective/murder/check_completion()
	var/mob/living/carbon/human/T = target_ref?.resolve()
	if(!T || QDELETED(T))
		return TRUE
	return T.stat >= DEAD

/datum/quest/custom/harlequinn_objective/murder/proc/on_death()
	validate()
