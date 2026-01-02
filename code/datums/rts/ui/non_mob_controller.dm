/atom/movable/screen/strategy_ui
	icon = 'icons/hud/rts_mob_hud.dmi'

/atom/movable/screen/strategy_ui/controller_ui
	screen_loc = "WEST,SOUTH"
	icon = null

	var/atom/movable/screen/strategy_ui/action/actions
	var/atom/movable/screen/strategy_ui/stat_pane/stat
	var/atom/movable/screen/strategy_ui/units_preview/units
	var/atom/movable/screen/strategy_ui/ability_bar/ability

	var/atom/movable/screen/strategy_ui/controller_button/bottom/bottom
	var/atom/movable/screen/strategy_ui/controller_button/move/move
	var/atom/movable/screen/strategy_ui/controller_button/destroy/destroy

	var/atom/movable/screen/strategy_ui/controller_button/decor/decor
	var/atom/movable/screen/strategy_ui/controller_button/traps/traps
	var/atom/movable/screen/strategy_ui/controller_button/builds/builds

	var/atom/movable/screen/strategy_ui/controller_button/exit/exit

/atom/movable/screen/strategy_ui/controller_ui/New(loc, ...)
	. = ..()
	create_and_position_buttons()

/atom/movable/screen/strategy_ui/controller_ui/Destroy(force)
	QDEL_NULL(actions)
	QDEL_NULL(stat)
	QDEL_NULL(units)
	QDEL_NULL(ability)
	QDEL_NULL(bottom)
	QDEL_NULL(move)
	QDEL_NULL(decor)
	QDEL_NULL(traps)
	QDEL_NULL(builds)
	QDEL_NULL(exit)
	return ..()

/atom/movable/screen/strategy_ui/controller_ui/vv_edit_var(var_name, var_value)
	switch (var_name)
		if ("screen_loc")
			update_screen_loc(var_value)
			return TRUE

	return ..()

/atom/movable/screen/strategy_ui/controller_ui/proc/add_ui(client/client)
	if(!client)
		return
	update_all()
	client.screen += actions

/atom/movable/screen/strategy_ui/controller_ui/proc/add_ui_buttons(client/client)
	if(!client)
		return
	update_all()
	client.screen += stat
	client.screen += units
	client.screen += ability
	client.screen += decor
	client.screen += traps
	client.screen += builds
	client.screen += bottom
	client.screen += destroy
	client.screen += move
	client.screen += exit

/atom/movable/screen/strategy_ui/controller_ui/proc/remove_ui(client/client)
	if(!client)
		return
	update_all()
	client.screen -= stat
	client.screen -= units
	client.screen -= ability
	client.screen -= decor
	client.screen -= traps
	client.screen -= builds
	client.screen -= bottom
	client.screen -= destroy
	client.screen -= move
	client.screen -= exit

/atom/movable/screen/strategy_ui/controller_ui/proc/create_and_position_buttons()
	actions = new(null, src)
	units = new(null, src)
	ability = new(null, src)
	stat = new(null, src)
	decor = new(null, src)
	traps = new(null, src)
	builds = new(null, src)
	bottom = new(null, src)
	destroy = new(null, src)
	move = new(null, src)
	exit = new(null, src)

	update_screen_loc()
	update_all()

/atom/movable/screen/strategy_ui/controller_ui/proc/update_screen_loc(new_loc)
	if(new_loc)
		screen_loc = new_loc

	actions.screen_loc = screen_loc
	units.screen_loc = screen_loc
	ability.screen_loc = screen_loc
	stat.screen_loc = screen_loc
	decor.screen_loc = screen_loc
	traps.screen_loc = screen_loc
	builds.screen_loc = screen_loc
	bottom.screen_loc = screen_loc
	destroy.screen_loc = screen_loc
	exit.screen_loc = screen_loc
	move.screen_loc = screen_loc

/atom/movable/screen/strategy_ui/controller_ui/proc/update_all()


/atom/movable/screen/strategy_ui/controller_ui/proc/update_text()

/atom/movable/screen/strategy_ui/action
	icon_state = "action"

/atom/movable/screen/strategy_ui/stat_pane
	icon_state = "stats"
	maptext_x = 346
	maptext_y = 62
	maptext_width = 128
	maptext_height = 32

/atom/movable/screen/strategy_ui/units_preview
	icon_state = "units_preview"

/atom/movable/screen/strategy_ui/ability_bar
	icon_state = "ability_bar"

/atom/movable/screen/strategy_ui/controller_button
	icon_state = "button_1"

	var/list/buildings
	var/highlighted = FALSE
	var/highlight_color

/atom/movable/screen/strategy_ui/controller_button/MouseExited()
	if(!usr.client)
		return

	. = ..()
	color = null
	if(highlighted)
		color = highlight_color

/atom/movable/screen/strategy_ui/controller_button/MouseEntered(location,control,params)
	if(!usr.client)
		return

	. = ..()
	color = "#f0efab"
