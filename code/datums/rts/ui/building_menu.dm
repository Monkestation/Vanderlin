/atom/movable/screen/close_building
	icon = 'icons/hud/rts_ability_hud.dmi'
	icon_state = "close_bar"
	screen_loc = "WEST,SOUTH:96"


/atom/movable/screen/building_button
	icon = 'icons/hud/storage.dmi'
	icon_state = "background"
	screen_loc = "WEST,SOUTH:96"
	no_over_text = FALSE
	var/build_state = TRUE
	var/datum/building_datum/build_datum
	var/datum/building_datum/datum_path

/atom/movable/screen/building_button/proc/update_build_state(mob/camera/strategy_controller/master)
	if(!build_datum)
		build_datum = new datum_path

	if(build_datum.stockpile_needed && !master.resource_stockpile)
		build_state = FALSE
		color = COLOR_RED_LIGHT
		return

	if(!build_datum.resource_check(master))
		build_state = FALSE
		color = COLOR_RED_LIGHT
		return

	build_state = TRUE
	color = null

/atom/movable/screen/building_button/Click(location, control, params)
	. = ..()
	if(!build_state)
		return
	var/mob/camera/strategy_controller/controller = usr
	controller.try_setup_build(datum_path)

/atom/movable/screen/close_building/Click(location, control, params)
	. = ..()
	var/mob/camera/strategy_controller/clicker = usr
	if(!istype(clicker))
		return
	clicker.close_building_ui()

/atom/movable/screen/building_backdrop
	icon = 'icons/hud/rts_ability_hud.dmi'
	icon_state = "button_ui"
	screen_loc = "WEST,SOUTH:96"

	var/list/build_buttons = list()
	var/atom/movable/screen/close_building/close

	var/max_x = 3
	var/max_y = 6

	var/current_x = 0
	var/current_y = 0

/atom/movable/screen/building_backdrop/proc/update(mob/camera/strategy_controller/processer)
	if(!length(build_buttons))
		return
	for(var/atom/movable/screen/building_button/button in build_buttons)
		button.update_build_state(processer)

/atom/movable/screen/building_backdrop/Initialize(mapload, datum/hud/hud_owner)
	. = ..()
	close = new(null, hud_owner)

/atom/movable/screen/building_backdrop/proc/close_uis(mob/camera/strategy_controller/closer)
	for(var/atom/movable/screen/building_button/button as anything in build_buttons)
		build_buttons -= button
		closer.client.screen -= button
		qdel(button)
	closer.client.screen -= src
	closer.client.screen -= close
	current_x = 0
	current_y = 0

/atom/movable/screen/building_backdrop/proc/open_ui(mob/camera/strategy_controller/opener, list/building_datums)
	close_uis(opener)
	for(var/datum/building_datum/datum as anything in building_datums)
		var/atom/movable/screen/building_button/new_button = new
		if(ispath(datum, /datum/building_datum/simple))
			var/datum/building_datum/simple/building = datum
			var/mutable_appearance/MA = mutable_appearance(initial(building.created_atom.icon), initial(building.created_atom.icon_state), new_button.layer + 0.1, new_button.plane)
			var/atom/created_atom = building.created_atom
			var/initial_flags = initial(created_atom.smoothing_flags)
			if(initial_flags & USES_BITMASK_SMOOTHING)
				MA.icon_state = "[initial(created_atom.icon_state)]-0"
			new_button.add_overlay(MA)
			new_button.name = initial(building.created_atom.name)
		else if(ispath(datum, /datum/building_datum))
			var/datum/building_datum/simple/building = datum
			var/mutable_appearance/MA = mutable_appearance(initial(building.ui_icon), initial(building.ui_icon_state), new_button.layer + 0.1, new_button.plane)
			new_button.add_overlay(MA)
			new_button.name = initial(building.name)
		new_button.screen_loc = "WEST:[current_x*32],SOUTH:[96 + (current_y*32)]"
		new_button.datum_path = datum

		current_x++

		if(current_x >= max_x)
			current_x = 0
			current_y++
		opener.client.screen += new_button
		build_buttons += new_button

	opener.client.screen += src
	opener.client.screen += close
