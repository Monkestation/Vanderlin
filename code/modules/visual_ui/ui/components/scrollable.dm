
/obj/abstract/visual_ui_element/scrollable
	name = "UI Scrollable Container"
	icon_state = "scroll_background"
	mouse_opacity = MOUSE_OPACITY_ICON
	layer = VISUAL_UI_STEP_BACK
	var/list/container_elements = list() // Elements contained within this scrollable area
	var/max_height = 320 // Content height in pixels
	var/visible_height = 196 // Visible area height in pixels
	var/visible_width = 160 // Visible area width in pixels
	var/scroll_position = 0 // Current scroll position in pixels
	var/scroll_step = 16 // Pixels to scroll per step

	var/const_offset = 20
	///this is because we have non conformed scrollzones
	var/special_offset = 0
	///this is for our filter's x incases where we do weird modifications
	var/special_x_offset = 0


	// Scroll bar elements
	var/obj/abstract/visual_ui_element/hoverable/scroll_handle = /obj/abstract/visual_ui_element/hoverable/scroll_handle
	var/obj/abstract/visual_ui_element/scroll_track = /obj/abstract/visual_ui_element/scroll_track
	var/obj/abstract/visual_ui_element/mask
	var/list/spawned_contained_elements = list()

	var/scroll_render_target = "scroll_area"  // Unique ID for this scrollable area
	var/static/last_render_target_index = 0

	var/mask_icon_state = "scroll_mask"
	var/matrix/scroll_transform = matrix()

/obj/abstract/visual_ui_element/scrollable/New(turf/loc, datum/visual_ui/P)
	..()

	last_render_target_index++
	scroll_render_target = "*scroll_area_[last_render_target_index]"

	mask = new /obj/abstract/visual_ui_element(null, parent)
	mask.icon = icon
	mask.icon_state = mask_icon_state
	mask.render_target = scroll_render_target
	mask.offset_x = offset_x
	mask.offset_y = offset_y
	mask.update_ui_screen_loc()
	parent.elements += mask

	scroll_track = new scroll_track(null, parent)
	scroll_track.offset_x = offset_x - const_offset
	scroll_track.offset_y = offset_y
	scroll_track.update_ui_screen_loc()
	parent.elements += scroll_track

	scroll_handle = new scroll_handle(null, parent)
	scroll_handle.offset_x = offset_x - const_offset
	scroll_handle.offset_y = offset_y
	scroll_handle.update_ui_screen_loc()
	parent.elements += scroll_handle

	for(var/obj/abstract/visual_ui_element/element as anything in spawned_contained_elements)
		var/obj/abstract/visual_ui_element/new_element = new element(null, parent)
		new_element.offset_x = offset_x
		new_element.offset_y = offset_y
		new_element.update_ui_screen_loc()

		parent.elements += new_element
		register_element(new_element)

// Register an element to be managed by this scrollable container
/obj/abstract/visual_ui_element/scrollable/proc/register_element(obj/abstract/visual_ui_element/element)
	container_elements += element
	element.scrollable_parent = src // Store reference to scrollable parent
	element.filters += filter(type = "alpha", render_source = scroll_render_target, x = special_x_offset)

	recalculate_content_height()
	update_element_positions()
	return element

/obj/abstract/visual_ui_element/scrollable/proc/recalculate_content_height()
	max_height = 0
	for(var/obj/abstract/visual_ui_element/E in container_elements)
		max_height += E.scroll_height

	max_height = max(initial(max_height), abs(max_height))

/obj/abstract/visual_ui_element/scrollable/proc/update_element_positions()
	// Manually update filter offsets to account for scrolling
	for(var/obj/abstract/visual_ui_element/E in container_elements)
		if(!E.initial_offset_y_set)
			E.initial_offset_y = E.offset_y
			E.initial_offset_y_set = TRUE

		E.offset_y = E.initial_offset_y + scroll_position
		E.update_ui_screen_loc()
		var/element_screen_y = offset_y + E.offset_y
		var/relative_y = offset_y - element_screen_y

		// Update the filter's y-offset dynamically
		if(length(E.filters))
			var/F = E.filters[1]
			animate(F, y = (relative_y - (const_offset * 2) + special_offset), x = special_x_offset)

	update_scroll_handle()

/obj/abstract/visual_ui_element/scrollable/proc/scroll_up()
	if(scroll_position < 0)
		scroll_position += scroll_step
		if(scroll_position > 0)
			scroll_position = 0
		update_element_positions()
		update_scroll_handle()

/obj/abstract/visual_ui_element/scrollable/proc/scroll_down()
	var/min_scroll = visible_height - max_height
	if(scroll_position > min_scroll)
		scroll_position -= scroll_step
		if(scroll_position < min_scroll)
			scroll_position = min_scroll
		update_element_positions()
		update_scroll_handle()

/obj/abstract/visual_ui_element/scrollable/proc/update_scroll_handle()
	var/track_height = visible_height - 32

	var/handle_size = min(16, (visible_height / max(max_height, 1)) * track_height)
	handle_size = max(handle_size, 8)  // Ensure minimum handle size

	var/scroll_ratio = 0
	if(max_height > visible_height)  // Only if content exceeds visible area
		scroll_ratio = abs(scroll_position) / (max_height - visible_height)
		scroll_ratio = clamp(scroll_ratio, 0, 1)

	var/usable_track = track_height - handle_size
	var/handle_position = scroll_ratio * usable_track

	scroll_handle.offset_y = FLOOR(offset_y + track_height - handle_position - handle_size,1)
	scroll_handle.update_ui_screen_loc()

/obj/abstract/visual_ui_element/scrollable/MouseWheel(delta_x, delta_y, location, control, params)
	if(delta_y > 0)
		scroll_down()
	else if(delta_y < 0)
		scroll_up()
	return TRUE


/obj/abstract/visual_ui_element/MouseWheel(delta_x, delta_y, location, control, params)
	if(scrollable_parent)
		if(delta_y > 0)
			scrollable_parent.scroll_down()
		else if(delta_y < 0)
			scrollable_parent.scroll_up()
		return TRUE

/obj/abstract/visual_ui_element/scroll_track
	name = "Scroll Track"
	icon = 'icons/visual_ui/192x192.dmi'
	icon_state = "scroll_track"
	mouse_opacity = MOUSE_OPACITY_TRANSPARENT
	layer = VISUAL_UI_BUTTON

/obj/abstract/visual_ui_element/hoverable/scroll_handle
	name = "Scroll Handle"
	icon = 'icons/visual_ui/192x192.dmi'
	icon_state = "scroll"
	mouse_opacity = MOUSE_OPACITY_ICON
	layer = VISUAL_UI_FRONT
	var/dragging = FALSE
	var/drag_start_y = 0
	var/initial_scroll_pos = 0

/obj/abstract/visual_ui_element/hoverable/scroll_handle/MouseDown(location, control, params)
	..()
	dragging = TRUE
	var/list/modifiers = params2list(params)
	var/screenloc = LAZYACCESS(modifiers, SCREEN_LOC)
	if(!screenloc)
		return
	var/list/loc_params = splittext(screenloc, ",")
	var/list/loc_Y = splittext(loc_params[2], ":")
	drag_start_y = text2num(loc_Y[1]) * 32 + text2num(loc_Y[2])

	var/obj/abstract/visual_ui_element/scrollable/container = locate() in parent.elements
	if(container)
		initial_scroll_pos = container.scroll_position

/obj/abstract/visual_ui_element/hoverable/scroll_handle/MouseUp(location, control, params)
	..()
	dragging = FALSE

/obj/abstract/visual_ui_element/hoverable/scroll_handle/MouseDrag(over_object, src_location, over_location, src_control, over_control, params)
	if(!dragging)
		return

	var/list/modifiers = params2list(params)
	var/screenloc = LAZYACCESS(modifiers, SCREEN_LOC)
	if(!screenloc)
		return
	var/list/loc_params = splittext(screenloc, ",")
	var/list/loc_Y = splittext(loc_params[2], ":")
	var/current_y = text2num(loc_Y[1]) * 32 + text2num(loc_Y[2])

	var/delta_y = current_y - drag_start_y

	var/obj/abstract/visual_ui_element/scrollable/container = locate() in parent.elements
	if(container)
		var/track_height = container.visible_height - 32
		var/scroll_ratio = delta_y / track_height
		var/scroll_amount = scroll_ratio * (container.max_height - container.visible_height)

		container.scroll_position = initial_scroll_pos - scroll_amount

		var/min_scroll = container.visible_height - container.max_height
		if(container.scroll_position < min_scroll)
			container.scroll_position = min_scroll
		if(container.scroll_position > 0)
			container.scroll_position = 0

		container.update_element_positions()
		container.update_scroll_handle()
