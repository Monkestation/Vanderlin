/datum/relic_trigger
	var/one_shot = FALSE
	var/duration_refreshing = FALSE
	var/datum/component/relic/stored_lookup

/datum/relic_trigger/proc/should_fire(atom/parent_atom, datum/relic_information/info)
	return TRUE

/datum/relic_trigger/proc/register_events(atom/parent_atom, datum/component/relic/relic_comp)
	return

/datum/relic_trigger/proc/unregister_events(atom/parent_atom, datum/component/relic/relic_comp)
	return

/datum/relic_trigger/proc/trigger_upstream()
	stored_lookup.activate_relic()
	stored_lookup.play_relic_effects()
