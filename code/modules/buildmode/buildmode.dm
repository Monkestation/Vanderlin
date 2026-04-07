
// Global cache for appearance objects
GLOBAL_LIST_EMPTY(buildmode_appearance_cache)
/**
 * Enhanced BuildMode Datum
 *
 * Improved buildmode system with categorized selections,
 * embedded HTML interfaces, preview functionality, and grid-based building.
 */
/datum/buildmode
	var/build_dir = SOUTH
	var/datum/buildmode_mode/mode
	var/client/holder

	// Login callback
	var/li_cb

	// UI elements
	var/list/buttons
	var/list/selected_item // Currently selected item to place
	var/mutable_appearance/preview_appearance // Appearance for preview
	var/image/preview_image // Image shown to the user
	var/pixel_x_offset = 0
	var/pixel_y_offset = 0

	// Switching management
	var/switch_state = BM_SWITCHSTATE_NONE
	var/switch_width = 5

	// Mode switch UI
	var/atom/movable/screen/buildmode/mode/modebutton
	var/list/modeswitch_buttons = list()

	// Direction switch UI
	var/atom/movable/screen/buildmode/bdir/dirbutton
	var/list/dirswitch_buttons = list()

	// Category selection UI
	var/atom/movable/screen/buildmode/category/categorybutton
	var/list/category_buttons = list()
	var/current_category = null

	// Item browser interface
	var/datum/browser/item_browser = null
	var/list/cached_icons = list() // Cache for item icons

	// Pixel positioning mode
	var/pixel_positioning_mode = FALSE
	var/atom/movable/buildmode_pixel_dummy/pixel_positioning_dummy = null

	var/list/cached_buildmode_html = list()

/**
 * Creates a new buildmode instance
 *
 * @param {client} c - The client who will use this buildmode
 */
/datum/buildmode/New(client/c)
	mode = new /datum/buildmode_mode/basic(src)
	holder = c
	buttons = list()
	li_cb = CALLBACK(src, PROC_REF(post_login))
	holder.player_details.post_login_callbacks += li_cb
	create_buttons(c)
	holder.screen += buttons
	holder.click_intercept = src
	mode.enter_mode(src)
	current_category = BM_CATEGORY_TURF
	open_item_browser()
	RegisterSignal(holder.mob, COMSIG_MOUSE_ENTERED, PROC_REF(on_mouse_moved))
	RegisterSignal(holder.mob, COMSIG_ATOM_MOUSE_ENTERED, PROC_REF(on_mouse_moved_pre))

/**
 * Clean up and exit buildmode
 */
/datum/buildmode/proc/quit()
	mode.exit_mode(src)
	holder.screen -= buttons
	holder.click_intercept = null
	clear_preview()
	if(item_browser)
		item_browser.close()
		item_browser = null
	if(holder?.mob)
		UnregisterSignal(holder.mob, COMSIG_MOUSE_ENTERED)
		UnregisterSignal(holder.mob, COMSIG_ATOM_MOUSE_ENTERED)

	qdel(src)

/**
 * Clean up resources when deleted
 */
/datum/buildmode/Destroy()
	clear_pixel_positioning_dummy()
	close_switchstates()
	holder.player_details.post_login_callbacks -= li_cb
	holder = null
	QDEL_NULL(mode)
	QDEL_LIST(modeswitch_buttons)
	QDEL_LIST(dirswitch_buttons)
	QDEL_LIST(category_buttons)
	clear_preview()

	if(item_browser)
		item_browser.close()
		item_browser = null

	cached_icons.Cut()
	return ..()

/**
 * Reset UI after client login
 */
/datum/buildmode/proc/post_login()
	if(QDELETED(holder))
		return
	holder.screen += buttons

	switch(switch_state)
		if(BM_SWITCHSTATE_MODE)
			open_modeswitch()
		if(BM_SWITCHSTATE_DIR)
			open_dirswitch()
		if(BM_SWITCHSTATE_CATEGORY)
			open_categoryswitch()
		if(BM_SWITCHSTATE_ITEMS)
			open_item_browser()

/**
 * Create the buildmode UI buttons
 */
/datum/buildmode/proc/create_buttons(client/client)
	var/datum/hud/hud_used = client?.mob?.hud_used
	modebutton = new /atom/movable/screen/buildmode/mode(null, hud_used, src)
	buttons += modebutton
	buttons += new /atom/movable/screen/buildmode/help(null, hud_used, src)
	dirbutton = new /atom/movable/screen/buildmode/bdir(null, hud_used, src)
	buttons += dirbutton
	categorybutton = new /atom/movable/screen/buildmode/category(null, hud_used, src)
	buttons += categorybutton

	var/atom/movable/screen/buildmode/items/itembutton = new(null, hud_used, src)
	buttons += itembutton

	buttons += new /atom/movable/screen/buildmode/quit(null, hud_used, src)

	build_options_grid(subtypesof(/datum/buildmode_mode), modeswitch_buttons, /atom/movable/screen/buildmode/modeswitch, hud_used)
	build_options_grid(list(SOUTH, EAST, WEST, NORTH, NORTHWEST, NORTHEAST, SOUTHWEST, SOUTHEAST), dirswitch_buttons, /atom/movable/screen/buildmode/dirswitch, hud_used)
	build_options_grid(list(
		BM_CATEGORY_TURF,
		BM_CATEGORY_OBJ,
		BM_CATEGORY_MOB,
		BM_CATEGORY_ITEM,
		BM_CATEGORY_WEAPON,
		BM_CATEGORY_CLOTHING,
		BM_CATEGORY_REAGENT_CONTAINERS,
		BM_CATEGORY_FOOD,
	), category_buttons, /atom/movable/screen/buildmode/categoryswitch, hud_used)

/**
 * Create or update the preview appearance that follows the cursor
 *
 * @param {path} item_path - The path of the item to preview
 */
/datum/buildmode/proc/create_preview_appearance(item_path)
	clear_preview()
	if(GLOB.buildmode_appearance_cache[item_path])
		preview_appearance = new
		preview_appearance.appearance = GLOB.buildmode_appearance_cache[item_path]
	else
		preview_appearance = new

		if(ispath(item_path, /turf))
			var/turf/T = item_path
			preview_appearance.icon = initial(T.icon)
			preview_appearance.icon_state = initial(T.icon_state)
			preview_appearance.dir = build_dir
			preview_appearance.color = LIGHT_COLOR_LIGHT_CYAN
		else
			var/atom/movable/temp_atom
			temp_atom = new item_path(null) // Create in nullspace
			preview_appearance.appearance = temp_atom.appearance
			preview_appearance.dir = build_dir
			preview_appearance.color = LIGHT_COLOR_LIGHT_CYAN
			qdel(temp_atom) // Clean up

		GLOB.buildmode_appearance_cache[item_path] = preview_appearance.appearance

	preview_image = new
	preview_image.appearance = preview_appearance
	preview_image.alpha = 150
	preview_image.plane = ABOVE_LIGHTING_PLANE
	preview_image.layer = FLOAT_LAYER
	preview_image.mouse_opacity = MOUSE_OPACITY_TRANSPARENT

	holder.images += preview_image

	update_preview_position()

/proc/get_pixel_offsets_from_screenloc(params)
	var/list/modifiers = params2list(params)
	var/screen_loc = LAZYACCESS(modifiers, SCREEN_LOC)

	if(!screen_loc || !istext(screen_loc))
		return null

	var/list/coords = splittext(screen_loc, ",")
	if(length(coords) != 2)
		return null

	var/list/x_parts = splittext(coords[1], ":") // screen-loc is y,x order!
	var/list/y_parts = splittext(coords[2], ":")

	if(length(x_parts) != 2 || length(y_parts) != 2)
		return null

	var/x_offset = text2num(x_parts[2]) - 16
	var/y_offset = text2num(y_parts[2]) - 16

	return list("x" = x_offset, "y" = y_offset)

/datum/buildmode/proc/on_mouse_moved_pre(datum/source, atom/atom, params)
	if(istype(source, /atom/movable/buildmode_pixel_dummy))
		return
	on_mouse_moved(source, get_turf(atom), params)

/datum/buildmode/proc/on_mouse_moved(datum/source, turf/turf, params)
	if(turf == preview_image?.loc)
		return
	if(!preview_image || !turf)
		return

	// Update the image's location
	preview_image.loc = turf

	// Move pixel dummy and handle tile crossing
	if(pixel_positioning_dummy && params)
		pixel_positioning_dummy.forceMove(turf)
		var/list/offsets = get_pixel_offsets_from_screenloc(params)
		if(offsets)
			pixel_x_offset = offsets["x"]
			pixel_y_offset = offsets["y"]

	if(!pixel_positioning_mode)
		pixel_x_offset = 0
		pixel_y_offset = 0

	// Apply the pixel offsets
	preview_image.pixel_x = pixel_x_offset
	preview_image.pixel_y = pixel_y_offset

/**
 * Update the preview object's position and appearance
 */
/datum/buildmode/proc/update_preview_position()
	if(!preview_image)
		return

	if(!pixel_positioning_mode)
		preview_image.pixel_x = 0
		preview_image.pixel_y = 0
	else
		preview_image.pixel_x = pixel_x_offset
		preview_image.pixel_y = pixel_y_offset
	preview_image.dir = build_dir

/**
 * Clear the current preview
 */
/datum/buildmode/proc/clear_preview()
	if(preview_image)
		holder.images -= preview_image
		qdel(preview_image)
		preview_image = null

	preview_appearance = null

/**
 * Toggle pixel positioning mode
 */
/datum/buildmode/proc/toggle_pixel_positioning_mode(toggled)
	pixel_positioning_mode = toggled


	if(pixel_positioning_mode)
		to_chat(holder.mob, "<span class='notice'>Pixel positioning mode enabled. Move mouse to adjust pixel position.</span>")
		create_pixel_positioning_dummy()
	else
		to_chat(holder.mob, "<span class='notice'>Pixel positioning mode disabled.</span>")
		clear_pixel_positioning_dummy()
		pixel_y_offset = 0
		pixel_x_offset = 0
		update_preview_position()

/**
 * Create dummy object for pixel positioning
 */
/datum/buildmode/proc/create_pixel_positioning_dummy()
	clear_pixel_positioning_dummy()
	if(!preview_image)
		return
	pixel_positioning_dummy = new /atom/movable/buildmode_pixel_dummy(get_turf(preview_image.loc), src)

/**
 * Clear pixel positioning dummy
 */
/datum/buildmode/proc/clear_pixel_positioning_dummy()
	if(pixel_positioning_dummy)
		qdel(pixel_positioning_dummy)
		pixel_positioning_dummy = null

/**
 * Intercept clicks to handle buildmode functionality
 *
 * @param {mob} user - The user clicking
 * @param {string} params - Click parameters
 * @param {atom} object - The object clicked on
 * @return {bool} - Whether the click was handled
 */
/datum/buildmode/proc/InterceptClickOn(mob/user, list/modifiers, atom/object)
	var/left_click = LAZYACCESS(modifiers, LEFT_CLICK)
	var/right_click = LAZYACCESS(modifiers, RIGHT_CLICK)

	if(selected_item && !istype(mode, /datum/buildmode_mode/advanced))
		if(left_click)
			place_object(get_turf(object), user, modifiers)
			return TRUE

		if(right_click)
			clear_selection()
			return TRUE
	return mode.handle_click(user.client, modifiers, object)

/**
 * New buildmode category button
 */
/atom/movable/screen/buildmode/category/update_name()
	. = ..()
	var/category_name = "None"
	switch(bd.current_category)
		if(BM_CATEGORY_TURF)
			category_name = "Turfs"
		if(BM_CATEGORY_OBJ)
			category_name = "Objects"
		if(BM_CATEGORY_MOB)
			category_name = "Mobs"
		if(BM_CATEGORY_ITEM)
			category_name = "Items"

	name = "Build Category: [category_name]"

/**
 * Toggle BuildMode admin command
 *
 * @param {mob} M - The mob to toggle buildmode for
 */
/proc/togglebuildmode(mob/M as mob in GLOB.player_list)
	set name = "Toggle Build Mode"
	set category = "Event"

	if(M.client)
		if(istype(M.client.click_intercept, /datum/buildmode))
			var/datum/buildmode/B = M.client.click_intercept
			B.quit()
			log_admin("[key_name(usr)] has left build mode.")
		else
			new /datum/buildmode(M.client)
			log_admin("[key_name(usr)] has entered build mode.")

/**
 * Dummy object for tracking mouse movement in pixel positioning mode
 */
/atom/movable/buildmode_pixel_dummy
	name = "pixel positioning tracker"
	icon = 'icons/effects/alphacolors.dmi'
	alpha = 1
	glide_size = 1000
	plane = HUD_PLANE
	var/datum/buildmode/parent_buildmode
	var/skip = FALSE

/atom/movable/buildmode_pixel_dummy/Initialize(mapload, datum/buildmode/bm)
	. = ..()
	parent_buildmode = bm

/atom/movable/buildmode_pixel_dummy/Destroy()
	parent_buildmode = null
	return ..()

/atom/movable/buildmode_pixel_dummy/MouseMove(location, control, params)
	if(!parent_buildmode || !parent_buildmode.pixel_positioning_mode)
		return

	var/list/offsets = get_pixel_offsets_from_screenloc(params)
	if(offsets)
		parent_buildmode.pixel_x_offset = offsets["x"]
		parent_buildmode.pixel_y_offset = offsets["y"]
		parent_buildmode.update_preview_position()



/atom/movable/buildmode_pixel_dummy/MouseEntered(location, control, params)
	if(!parent_buildmode || !parent_buildmode.pixel_positioning_mode)
		return

	var/list/offsets = get_pixel_offsets_from_screenloc(params)
	if(offsets)
		parent_buildmode.pixel_x_offset = offsets["x"]
		parent_buildmode.pixel_y_offset = offsets["y"]
		parent_buildmode.update_preview_position()
