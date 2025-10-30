/atom/movable/screen/buildmode/mode
	name = "Toggle Mode"
	icon_state = "buildmode_basic"
	screen_loc = "NORTH,WEST"

/atom/movable/screen/buildmode/mode/Click(location, control, params)
	var/list/modifiers = params2list(params)
	var/left_click = LAZYACCESS(modifiers, LEFT_CLICK)
	var/right_click = LAZYACCESS(modifiers, RIGHT_CLICK)

	if(left_click)
		bd.toggle_modeswitch()
	else if(right_click)
		bd.mode.change_settings(usr.client)
	update_appearance(UPDATE_ICON_STATE)
	return TRUE

/atom/movable/screen/buildmode/mode/update_icon_state()
	. = ..()
	icon_state = bd.mode.get_button_iconstate()

/atom/movable/screen/buildmode/help
	icon_state = "buildhelp"
	screen_loc = "NORTH,WEST+1"
	name = "Buildmode Help"

/atom/movable/screen/buildmode/help/Click(location, control, params)
	bd.mode.show_help(usr.client)
	return 1

/atom/movable/screen/buildmode/bdir
	icon_state = "build"
	screen_loc = "NORTH,WEST+2"
	name = "Change Dir"

/atom/movable/screen/buildmode/bdir/update_icon_state()
	. = ..()
	dir = bd.build_dir

/atom/movable/screen/buildmode/bdir/Click()
	bd.toggle_dirswitch()
	update_appearance(UPDATE_ICON_STATE)
	return 1

// used to switch between modes
/atom/movable/screen/buildmode/modeswitch
	var/datum/buildmode_mode/modetype

/atom/movable/screen/buildmode/modeswitch/Initialize(mapload, datum/hud/hud_owner, datum/buildmode/build_datum, mode_type)
	. = ..()
	modetype = mode_type
	update_appearance(UPDATE_ICON_STATE | UPDATE_NAME)

/atom/movable/screen/buildmode/modeswitch/update_icon_state()
	if(modetype)
		var/datum/buildmode_mode/M = modetype
		icon_state = "buildmode_[initial(M.key)]"
	return ..()

/atom/movable/screen/buildmode/modeswitch/update_name()
	if(modetype)
		var/datum/buildmode_mode/M = modetype
		var/mode_name = initial(M.key)
		if(!mode_name)
			mode_name = "Unknown"
		name = mode_name
	return ..()

/atom/movable/screen/buildmode/modeswitch/Click()
	bd.change_mode(modetype)

/atom/movable/screen/buildmode/quit
	icon_state = "buildquit"
	screen_loc = "NORTH,WEST+3"
	name = "Quit Buildmode"

/atom/movable/screen/buildmode/quit/Click()
	bd.quit()
	return 1
