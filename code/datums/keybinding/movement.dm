/datum/keybinding/movement
	category = CATEGORY_MOVEMENT
	weight = WEIGHT_HIGHEST

/datum/keybinding/movement/north
	hotkey_keys = list("W", "North")
	classic_keys = list("North")
	name = "North"
	full_name = "Move North"
	description = "Moves your character north"

/datum/keybinding/movement/south
	hotkey_keys = list("S", "South")
	classic_keys = list("South")
	name = "South"
	full_name = "Move South"
	description = "Moves your character south"

/datum/keybinding/movement/west
	hotkey_keys = list("A", "West")
	classic_keys = list("West")
	name = "West"
	full_name = "Move West"
	description = "Moves your character left"

/datum/keybinding/movement/east
	hotkey_keys = list("D", "East")
	classic_keys = list("East")
	name = "East"
	full_name = "Move East"
	description = "Moves your character east"

/datum/keybinding/movement/zlevel_upwards
	hotkey_keys = list("Northeast") // PGUP
	name = "Upwards"
	full_name = "Move Upwards"
	description = "Moves your character up a z-level if possible"

/datum/keybinding/movement/zlevel_upwards/down(client/user, turf/target, mousepos_x, mousepos_y)
	. = ..()
	if(.)
		return
	user.mob.up()
	return TRUE

/datum/keybinding/movement/zlevel_downwards
	hotkey_keys = list("Southeast") // PGDOWN
	name = "Downwards"
	full_name = "Move Downwards"
	description = "Moves your character down a z-level if possible"

/datum/keybinding/movement/zlevel_downwards/down(client/user, turf/target, mousepos_x, mousepos_y)
	. = ..()
	if(.)
		return
	user.mob.down()
	return TRUE
