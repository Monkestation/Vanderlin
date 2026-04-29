/datum/component/blood_stability
	///The mob that has infused blood
	var/mob/living/carbon/host
	///List of blood types and their stored amounts
	var/list/blood_storage = list()
	///Maximum storage per blood type
	var/max_storage_per_type = 1000

/datum/component/blood_stability/Initialize()
	. = ..()
	if(!ismob(parent))
		return COMPONENT_INCOMPATIBLE
	host = parent

	// Auto-fill the host's own blood type to max
	var/datum/blood_type/host_blood = host.get_blood_type()
	if(host_blood)
		blood_storage[host_blood.type] = max_storage_per_type

	RegisterSignal(parent, COMSIG_HANDLE_INFUSION, PROC_REF(handle_infusion))

/datum/component/blood_stability/Destroy()
	host = null
	blood_storage = null
	UnregisterSignal(parent, COMSIG_HANDLE_INFUSION)
	. = ..()

/datum/component/blood_stability/proc/handle_infusion(datum/source, datum/blood_type/blood_type, amount)
	if(!blood_storage[blood_type])
		blood_storage[blood_type] = 0
	blood_storage[blood_type] = min(max_storage_per_type, blood_storage[blood_type] + amount)
	to_chat(host, span_notice("Your body has absorbed [amount] units of [initial(blood_type.name)] Blood. Total: [blood_storage[blood_type]]"))
	return TRUE

/datum/component/blood_stability/proc/has_blood_amount(blood_type, amount)
	return blood_storage[blood_type] && blood_storage[blood_type] >= amount

/datum/component/blood_stability/proc/get_blood_amount(blood_type)
	return blood_storage[blood_type] || 0

/datum/component/blood_stability/proc/get_total_storage()
	var/total = 0
	for(var/blood_type in blood_storage)
		total += blood_storage[blood_type]
	return total

/datum/component/blood_stability/proc/get_stored_types()
	return blood_storage.Copy()
