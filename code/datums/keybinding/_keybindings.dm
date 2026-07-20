/datum/keybinding
	var/list/hotkey_keys
	var/list/classic_keys
	var/name
	var/full_name
	var/description = ""
	var/category = CATEGORY_MISC
	var/weight = WEIGHT_LOWEST
	var/keybind_signal

/datum/keybinding/New()

	// Default keys to the master "hotkey_keys"
	if(LAZYLEN(hotkey_keys) && !LAZYLEN(classic_keys))
		classic_keys = hotkey_keys.Copy()

/datum/keybinding/proc/down(client/user, turf/target, mousepos_x, mousepos_y)
	SHOULD_CALL_PARENT(TRUE)
	if(keybind_signal)
		SEND_SIGNAL(user.mob, keybind_signal)
	return FALSE

/datum/keybinding/proc/up(client/user, turf/target)
	SHOULD_CALL_PARENT(TRUE)
	SEND_SIGNAL(user.mob, DEACTIVATE_KEYBIND(keybind_signal))
	return FALSE

/datum/keybinding/proc/can_use(client/user)
	return TRUE
