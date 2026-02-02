/datum/chimeric_node/input/racist
	name = "codger hater"
	desc = "When in view of a dwarf will trigger."
	weight = 5
	var/beats_per_trigger = 1 // How many heartbeats before triggering
	var/current_beats = 0
	var/datum/species/disliked_species = /datum/species/dwarf

/datum/chimeric_node/input/racist/register_triggers(mob/living/carbon/target)
	if(!target)
		return

	unregister_triggers()
	registered_signals += COMSIG_HUMAN_LIFE
	RegisterSignal(target, COMSIG_HUMAN_LIFE, PROC_REF(on_heartbeat))

/datum/chimeric_node/input/racist/proc/on_heartbeat(datum/source)
	SIGNAL_HANDLER
	current_beats++
	if(current_beats < beats_per_trigger)
		return
	current_beats = 0
	for(var/mob/living/carbon/human/human in view(7, hosted_carbon))
		if(is_species(human, disliked_species))
			var/potency = node_purity / 100
			trigger_output(potency)
			return

/datum/chimeric_node/input/racist/elf
	name = "knife ear hater"
	desc = "When in view of an elf will trigger."
	disliked_species = /datum/species/elf
