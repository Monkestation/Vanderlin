
/**
 * Build a grid of option buttons
 *
 * @param {list} elements - List of options to create buttons for
 * @param {list} buttonslist - List to store created buttons
 * @param {path} buttontype - Type of button to create
 */
/datum/buildmode/proc/build_options_grid(list/elements, list/buttonslist, buttontype, datum/hud/hud_used)
	var/pos_idx = 0
	for(var/thing in elements)
		var/x = pos_idx % switch_width
		var/y = FLOOR(pos_idx / switch_width, 1)
		var/atom/movable/screen/buildmode/B = new buttontype(null, hud_used, src, thing)
		// Extra .5 for a nice offset look
		B.screen_loc = "NORTH-[(1 + 0.5 + y*1.5)],WEST+[0.5 + x*1.5]"
		buttonslist += B
		pos_idx++

/**
 * Close all open switchstates
 */
/datum/buildmode/proc/close_switchstates()
	switch(switch_state)
		if(BM_SWITCHSTATE_MODE)
			close_modeswitch()
		if(BM_SWITCHSTATE_DIR)
			close_dirswitch()
		if(BM_SWITCHSTATE_CATEGORY)
			close_categoryswitch()

/**
 * Toggle the mode selection UI
 */
/datum/buildmode/proc/toggle_modeswitch()
	if(switch_state == BM_SWITCHSTATE_MODE)
		close_modeswitch()
	else
		close_switchstates()
		open_modeswitch()

/**
 * Toggle the item browser
 */
/datum/buildmode/proc/toggle_item_browser()
	if(switch_state == BM_SWITCHSTATE_ITEMS)
		close_item_browser()
	else
		// Don't close other switchstates when opening item browser
		// Just switch to it
		if(switch_state != BM_SWITCHSTATE_NONE)
			close_switchstates()
		open_item_browser()

/**
 * Open the mode selection UI
 */
/datum/buildmode/proc/open_modeswitch()
	switch_state = BM_SWITCHSTATE_MODE
	holder.screen += modeswitch_buttons

/**
 * Close the mode selection UI
 */
/datum/buildmode/proc/close_modeswitch()
	switch_state = BM_SWITCHSTATE_NONE
	holder.screen -= modeswitch_buttons

/**
 * Toggle the direction selection UI
 */
/datum/buildmode/proc/toggle_dirswitch()
	if(switch_state == BM_SWITCHSTATE_DIR)
		close_dirswitch()
	else
		close_switchstates()
		open_dirswitch()

/**
 * Open the direction selection UI
 */
/datum/buildmode/proc/open_dirswitch()
	switch_state = BM_SWITCHSTATE_DIR
	holder.screen += dirswitch_buttons

/**
 * Close the direction selection UI
 */
/datum/buildmode/proc/close_dirswitch()
	switch_state = BM_SWITCHSTATE_NONE
	holder.screen -= dirswitch_buttons

/**
 * Toggle the category selection UI
 */
/datum/buildmode/proc/toggle_categoryswitch()
	if(switch_state == BM_SWITCHSTATE_CATEGORY)
		close_categoryswitch()
	else
		close_switchstates()
		open_categoryswitch()

/**
 * Open the category selection UI
 */
/datum/buildmode/proc/open_categoryswitch()
	switch_state = BM_SWITCHSTATE_CATEGORY
	holder.screen += category_buttons

/**
 * Close the category selection UI
 */
/datum/buildmode/proc/close_categoryswitch()
	switch_state = BM_SWITCHSTATE_NONE
	holder.screen -= category_buttons

/**
 * Change the current buildmode
 *
 * @param {path} newmode - The new mode to switch to
 */
/datum/buildmode/proc/change_mode(newmode)
	mode.exit_mode(src)
	QDEL_NULL(mode)
	close_switchstates()
	mode = new newmode(src)
	mode.enter_mode(src)
	modebutton.update_appearance()

/**
 * Change the build direction
 *
 * @param {int} newdir - The new direction to use
 * @return {bool} - Success
 */
/datum/buildmode/proc/change_dir(newdir)
	build_dir = newdir
	close_dirswitch()
	dirbutton.update_appearance()
	update_preview_position()
	return 1

/**
 * Change the current category
 *
 * @param {int} new_category - The new category to select
 */
/datum/buildmode/proc/change_category(new_category)
	close_categoryswitch()
	current_category = new_category
	categorybutton.update_appearance()
	open_item_browser()

/**
 * Place an object at the specified location
 *
 * @param {turf} location - Where to place the object
 * @param {mob} user - Who is placing the object
 * @param {string} params - Click parameters
 */
/datum/buildmode/proc/place_object(turf/location, mob/user, list/modifiers)
	if(!selected_item || !location)
		return

	var/path = selected_item

	if(ispath(path, /turf))
		var/turf/T = location
		T.ChangeTurf(path)
		log_admin("[key_name(user)] placed [path] at [AREACOORD(location)]")
	else
		var/atom/A = new path(location)
		if(build_dir)
			A.setDir(build_dir)
		A.pixel_x = A.base_pixel_x + pixel_x_offset
		A.pixel_y = A.base_pixel_y + pixel_y_offset
		log_admin("[key_name(user)] placed [path] at [AREACOORD(location)]")

/**
 * Clear the current item selection
 */
/datum/buildmode/proc/clear_selection()
	selected_item = null
	clear_preview()
	to_chat(holder.mob, "<span class='notice'>Selection cleared.</span>")
