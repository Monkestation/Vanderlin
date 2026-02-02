/datum/chimeric_node/input/sunlight
	name = "sunblighted"
	desc = "Triggered when exposed to the sun for a certain time."
	var/beats_per_trigger = 1
	var/current_beats = 0

/datum/chimeric_node/input/sunlight/set_ranges()
	. = ..()
	beats_per_trigger = round(1 + ((100 - node_purity) * 0.05), 1)

/datum/chimeric_node/input/sunlight/register_triggers(mob/living/carbon/target)
	if(!target)
		return

	unregister_triggers()
	registered_signals += COMSIG_HUMAN_LIFE
	RegisterSignal(target, COMSIG_HUMAN_LIFE, PROC_REF(on_heartbeat))

/datum/chimeric_node/input/sunlight/proc/on_heartbeat(datum/source)
	SIGNAL_HANDLER
	if(GLOB.tod != "day")
		return

	if(isturf(hosted_carbon.loc))
		var/turf/T = hosted_carbon.loc
		if(!T.can_see_sky())
			return
	else
		return

	current_beats++
	if(current_beats >= beats_per_trigger)
		current_beats = 0
		var/potency = node_purity / 100
		trigger_output(potency)
