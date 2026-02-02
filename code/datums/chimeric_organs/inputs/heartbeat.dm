/datum/chimeric_node/input/heartbeat
	name = "heartbeat"
	desc = "Triggered every few heartbeats."
	var/beats_per_trigger = 1
	var/current_beats = 0

/datum/chimeric_node/input/heartbeat/set_ranges()
	. = ..()
	beats_per_trigger = round(1 + ((100 - node_purity) * 0.05), 1)

/datum/chimeric_node/input/heartbeat/register_triggers(mob/living/carbon/target)
	if(!target)
		return

	unregister_triggers()
	registered_signals += COMSIG_HUMAN_LIFE
	RegisterSignal(target, COMSIG_HUMAN_LIFE, PROC_REF(on_heartbeat))

/datum/chimeric_node/input/heartbeat/proc/on_heartbeat(datum/source)
	SIGNAL_HANDLER

	current_beats++
	if(current_beats >= beats_per_trigger)
		current_beats = 0
		var/potency = node_purity / 100
		trigger_output(potency)
