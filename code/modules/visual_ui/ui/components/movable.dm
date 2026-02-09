// Make use of MouseDown/MouseUp/MouseDrop to allow for relocating of the element
// By setting "move_whole_ui" to TRUE, the element will cause its entire parent UI to move with it.

/obj/abstract/visual_ui_element/hoverable/movable
	var/move_whole_ui = FALSE
	var/moving = FALSE
	var/icon/movement

/obj/abstract/visual_ui_element/hoverable/movable/AltClick(mob/user, list/modifiers) // Alt+Click defaults to reset the offset
	reset_loc()

/obj/abstract/visual_ui_element/hoverable/movable/MouseDown(location, control, params)
	if (!movement)
		var/icon/I = new(icon, icon_state)
		I.Blend('icons/visual_ui/mind_ui.dmi', ICON_OVERLAY, I.Width()/2-16, I.Height()/2-16)
		I.Scale(2* I.Width(),2* I.Height()) // doubling the size to account for players generally having more or less a 960x960 resolution
		var/rgba = "#FFFFFF" + copytext(rgb(0,0,0,191), 8)
		I.Blend(rgba, ICON_MULTIPLY)
		movement = I

	var/mob/M = get_user()
	M.client.mouse_pointer_icon = movement
	moving = TRUE

/obj/abstract/visual_ui_element/hoverable/movable/MouseUp(location, control, params)
	var/mob/M = get_user()
	M.client.mouse_pointer_icon = initial(M.client.mouse_pointer_icon)
	if (moving)
		move_loc(params)

/obj/abstract/visual_ui_element/hoverable/movable/MouseDrop(over_object, src_location, over_location, src_control, over_control, params)
	var/mob/M = get_user()
	M.client.mouse_pointer_icon = initial(M.client.mouse_pointer_icon)
	move_loc(params)

/obj/abstract/visual_ui_element/hoverable/movable/proc/move_loc(params)
	moving = FALSE
	var/list/modifiers = params2list(params)
	var/screenloc = LAZYACCESS(modifiers, SCREEN_LOC)
	if(!screenloc)
		return
	//first we need the x and y coordinates in pixels of the element relative to the bottom left corner of the screen
	var/icon/I = new(icon, icon_state)
	var/view = get_view_size()
	var/list/offsets = screen_loc_to_offset(screen_loc, view)
	var/start_x_val = offsets[1]
	var/start_y_val = offsets[2]

	//now we get those of the place where we released the mouse button
	var/list/dest_loc_params = splittext(screenloc, ",")
	var/list/dest_loc_X = splittext(dest_loc_params[1],":")
	var/list/dest_loc_Y = splittext(dest_loc_params[2],":")
	var/dest_pix_x = text2num(dest_loc_X[2]) - round(I.Width()/2)
	var/dest_pix_y = text2num(dest_loc_Y[2]) - round(I.Height()/2)
	var/dest_x_val = text2num(dest_loc_X[1])*32 + dest_pix_x + const_offset_x
	var/dest_y_val = text2num(dest_loc_Y[1])*32 + dest_pix_y + const_offset_y //this probably needs some more advanced math based on screen pos type

	//and calculate the offset between the two, which we can then add to either the element or the whole UI
	if (move_whole_ui)
		parent.offset_x += dest_x_val - start_x_val
		parent.offset_y += dest_y_val - start_y_val
		parent.update_ui_screen_loc()
		for (var/datum/visual_ui/sub in parent.subUIs)
			if (!sub.never_move)
				sub.offset_x += dest_x_val - start_x_val
				sub.offset_y += dest_y_val - start_y_val
				sub.update_ui_screen_loc()
	else
		offset_x += dest_x_val - start_x_val
		offset_y += dest_y_val - start_y_val
		update_ui_screen_loc()

/obj/abstract/visual_ui_element/hoverable/movable/proc/reset_loc()
	if (move_whole_ui)
		parent.offset_x = 0
		parent.offset_y = 0
		parent.update_ui_screen_loc()
	else
		offset_x = initial(offset_x)
		offset_y = initial(offset_y)
		update_ui_screen_loc()
