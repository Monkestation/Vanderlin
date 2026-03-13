/datum/keybinding/ghost
	category = CATEGORY_MISC
	weight = WEIGHT_MOB
	var/emote_key

/datum/keybinding/ghost/can_use(client/user)
	return isobserver(user.mob) ? TRUE : FALSE

/datum/keybinding/ghost/zlevel_upwards
	hotkey_keys = list("Northeast") // PGUP
	name = "Upwards"
	full_name = "Move Upwards"
	description = "Moves your character up a z-level if possible"

/datum/keybinding/ghost/zlevel_upwards/down(client/user)
	. = ..()
	if(.)
		return
	user.mob.up()
	return TRUE

/datum/keybinding/ghost/zlevel_downwards
	hotkey_keys = list("Southeast") // PGDOWN
	name = "Downwards"
	full_name = "Move Downwards"
	description = "Moves your character down a z-level if possible"

/datum/keybinding/ghost/zlevel_downwards/down(client/user)
	. = ..()
	if(.)
		return
	user.mob.down()
	return TRUE
