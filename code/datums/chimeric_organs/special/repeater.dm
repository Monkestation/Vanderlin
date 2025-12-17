/datum/chimeric_node/special/repeater
	name = "repeater"
	desc = "Will repeat every output trigger in the organ."

	needs_attachment = FALSE
	attachement_type = null

/datum/chimeric_node/special/repeater/final_setup()
	if(attached_organ)
		RegisterSignal(attached_organ, COMSIG_CHIMERIC_ORGAN_TRIGGER, PROC_REF(repeat_trigger))

/datum/chimeric_node/special/repeater/removal_setup()
	if(attached_organ)
		UnregisterSignal(attached_organ, COMSIG_CHIMERIC_ORGAN_TRIGGER)

/datum/chimeric_node/special/repeater/proc/repeat_trigger(obj/item/organ/trigger_source, datum/chimeric_node/input/triggerer, potency)
	addtimer(CALLBACK(src, PROC_REF(repeat), triggerer, potency), rand(3, 5))

/datum/chimeric_node/special/repeater/proc/repeat(datum/chimeric_node/input/triggerer, potency)
	triggerer.delayed_trigger(potency, FALSE)
