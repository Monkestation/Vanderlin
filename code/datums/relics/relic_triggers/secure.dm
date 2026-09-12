/datum/relic_trigger/secure
	var/secure_id = SECURE_SPOT_CHURCH
	/// Performance optimization: tracks if the spot is active without casting the atom every tick
	var/is_dirty = FALSE

/datum/relic_trigger/secure/register_events(atom/parent_atom, datum/component/relic/relic_comp)
	stored_lookup = relic_comp

	// Listen for both activation and deactivation
	RegisterSignal(parent_atom, COMSIG_SECURE_SPOT_ACTIVATED, PROC_REF(handle_spot_activation))
	RegisterSignal(parent_atom, COMSIG_SECURE_SPOT_DEACTIVATED, PROC_REF(handle_spot_deactivation))

/datum/relic_trigger/secure/unregister_events(atom/parent_atom, datum/component/relic/relic_comp)
	UnregisterSignal(parent_atom, list(COMSIG_SECURE_SPOT_ACTIVATED, COMSIG_SECURE_SPOT_DEACTIVATED))
	stored_lookup = null

/// Called when an item is inserted
/datum/relic_trigger/secure/proc/handle_spot_activation(atom/source)
	SIGNAL_HANDLER
	is_dirty = TRUE
	trigger_upstream() // Wake up the subsystem loop

/// Called if the item is removed or the spot is emptied/reset
/datum/relic_trigger/secure/proc/handle_spot_deactivation(atom/source)
	SIGNAL_HANDLER
	is_dirty = FALSE

/datum/relic_trigger/secure/should_fire(atom/parent_atom, datum/relic_information/info)
	return is_dirty
