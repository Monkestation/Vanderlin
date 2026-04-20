/datum/organ_process
	/// The slot we process
	var/slot = ""
	/// The mob types we process on
	var/list/mob_types = list(/mob/living/carbon)
	/// Need this to process dead mobs
	var/processes_dead = FALSE
	/// Equal or above this threshold means the process is functioning optimally
	var/optimal_threshold = ORGAN_OPTIMAL_EFFICIENCY
	/// Below this efficiency threshold, we consider the process bruised
	var/bruised_threshold = ORGAN_BRUISED_EFFICIENCY
	/// Below  this efficiency threshold, we consider the process failing
	var/failing_threshold = ORGAN_FAILING_EFFICIENCY
	/// Equal or below  this efficiency threshold, we consider the process destroyed
	var/destroyed_threshold = ORGAN_DESTROYED_EFFICIENCY

/// Checks if owner even makes use of this organ process
/datum/organ_process/proc/needs_process(mob/living/carbon/owner)
	SHOULD_CALL_PARENT(TRUE)
	if(owner.stat >= DEAD && !processes_dead)
		return FALSE
	if(!is_type_in_list(owner, mob_types))
		return FALSE
	return TRUE

/// Handles the processing, if we passed the proper checks
/datum/organ_process/proc/handle_process(mob/living/carbon/owner, delta_time = SSMOBS_DT, times_fired)
	return TRUE
