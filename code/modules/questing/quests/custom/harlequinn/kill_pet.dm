/datum/quest/custom/harlequinn_objective/kill_pet
	var/datum/weakref/pet_ref
	var/pet_name = "Unknown"
	var/owner_name = "Unknown"

/datum/quest/custom/harlequinn_objective/kill_pet/Destroy()
	if(pet_ref)
		var/atom/target = pet_ref?.resolve()
		if(target)
			UnregisterSignal(target, COMSIG_LIVING_DEATH)
	return ..()

/datum/quest/custom/harlequinn_objective/kill_pet/setup_for_harlequinn(datum/antagonist/harlequinn/antag)
	. = ..()
	var/mob/living/carbon/human/harlequinn_mob = antag.owner?.current

	var/list/candidates = list() // list(list("owner" = H, "pet" = A))
	for(var/mob/living/simple_animal/A in GLOB.tamed_mobs)
		if(QDELETED(A) || A.stat == DEAD)
			continue
		var/list/friends = A.ai_controller?.blackboard[BB_FRIENDS_LIST]
		if(!length(friends))
			continue
		for(var/mob/living/carbon/human/H in friends)
			if(H == harlequinn_mob)
				continue
			if(!H.client || H.stat == DEAD)
				continue
			candidates += list(list("owner" = H, "pet" = A))
			break

	if(!length(candidates))
		return FALSE

	var/list/chosen = pick(candidates)
	var/mob/living/simple_animal/pet = chosen["pet"]
	var/mob/living/carbon/human/owner = chosen["owner"]

	pet_ref = WEAKREF(pet)
	pet_name = pet.name
	owner_name = owner.real_name
	title = "Kill [owner_name]'s [pet_name]"
	reward_amount = 300
	RegisterSignal(pet, COMSIG_LIVING_DEATH, PROC_REF(on_death))
	return TRUE

/datum/quest/custom/harlequinn_objective/kill_pet/get_objective_text()
	return "Slay [owner_name]'s [pet_name]. Leave no trace."

/datum/quest/custom/harlequinn_objective/kill_pet/check_completion()
	var/mob/living/simple_animal/T = pet_ref?.resolve()
	if(!T || QDELETED(T))
		return TRUE
	return T.stat >= DEAD


/datum/quest/custom/harlequinn_objective/kill_pet/proc/on_death()
	validate()
