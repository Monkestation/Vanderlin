/datum/keybinding/client
	category = CATEGORY_CLIENT
	weight = WEIGHT_HIGHEST


/datum/keybinding/client/admin_help
	hotkey_keys = list("F1")
	classic_keys = list("F1")
	name = "admin_help"
	full_name = "Admin Help"
	description = "Ask an admin for help."

/datum/keybinding/client/admin_help/down(client/user, turf/target, mousepos_x, mousepos_y)
	. = ..()
	user.get_adminhelp()
	return TRUE
