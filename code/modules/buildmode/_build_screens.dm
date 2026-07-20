/**
 * Core buildmode mode buttons
 */
/atom/movable/screen/buildmode
	icon = 'icons/misc/buildmode.dmi'
	// If we don't do this, we get occluded by item action buttons
	plane = ABOVE_HUD_PLANE
	var/datum/buildmode/bd

/atom/movable/screen/buildmode/Initialize(mapload, datum/hud/hud_owner, datum/buildmode/build_datum)
	. = ..()
	bd = build_datum

/atom/movable/screen/buildmode/Destroy()
	bd = null
	return ..()

/atom/movable/screen/buildmode/mode
	icon_state = "buildmode1"
	name = "Toggle Mode"
	screen_loc = "NORTH,WEST"

/atom/movable/screen/buildmode/mode/Click()
	bd.toggle_modeswitch()

/atom/movable/screen/buildmode/mode/update_icon_state()
	icon_state = "buildmode[bd.mode.key ? bd.mode.key : 1]"
	return ..()

/atom/movable/screen/buildmode/help
	icon_state = "buildhelp"
	name = "Buildmode Help"
	screen_loc = "NORTH,WEST+1"

/atom/movable/screen/buildmode/help/Click()
	bd.mode.show_help(bd.holder.mob)

/atom/movable/screen/buildmode/bdir
	icon_state = "builddir"
	name = "Change Direction"
	screen_loc = "NORTH,WEST+2"

/atom/movable/screen/buildmode/bdir/update_icon()
	dir = bd.build_dir
	return ..()

/atom/movable/screen/buildmode/bdir/Click()
	bd.toggle_dirswitch()

/atom/movable/screen/buildmode/quit
	icon_state = "buildquit"
	name = "Quit Buildmode"
	screen_loc = "NORTH,WEST+3"

/atom/movable/screen/buildmode/quit/Click()
	bd.quit()

/atom/movable/screen/buildmode/modeswitch/Click()
	bd.change_mode(modetype)

/atom/movable/screen/buildmode/dirswitch
	icon_state = "build"
	var/dir_type

/atom/movable/screen/buildmode/dirswitch/Initialize(mapload, datum/hud/hud_owner, datum/buildmode/build_datum, dir)
	dir_type = dir
	setDir(dir_type)
	return ..()

/atom/movable/screen/buildmode/dirswitch/Click()
	bd.change_dir(dir_type)


/**
 * Handle clicks in this mode
 *
 * @param {client} c - The client who clicked
 * @param {string} modifiers - Click parameters list
 * @param {atom} object - The object clicked on
 * @return {bool} - Whether the click was handled
 */
/datum/buildmode_mode/proc/handle_click(client/client, list/modifiers, atom/object)
	var/left_click = LAZYACCESS(modifiers, LEFT_CLICK)

	if(use_corner_selection)
		if(left_click)
			if(!cornerA)
				cornerA = select_tile(get_turf(object), AREASELECT_CORNERA)
				return TRUE

			if(cornerA && !cornerB)
				cornerB = select_tile(get_turf(object), AREASELECT_CORNERB)
				to_chat(client, span_boldwarning("Region selected, if you're happy with your selection left click again, otherwise right click."))
				return TRUE

			if(cornerA && cornerB)
				handle_selected_area(client, modifiers)
				deselect_region()
				return TRUE
		else
			to_chat(client, span_boldnotice("Region selection canceled!"))
			deselect_region()
			return TRUE

	return FALSE


/**
 * Select a tile as part of region selection
 *
 * @param {turf} T - The turf to select
 * @param {int} corner_to_select - Which corner this is (A or B)
 * @return {turf} - The selected turf
 */
/datum/buildmode_mode/proc/select_tile(turf/T, corner_to_select)
	var/overlaystate
	BM.holder.images -= preview

	switch(corner_to_select)
		if(AREASELECT_CORNERA)
			overlaystate = "greenOverlay"
		if(AREASELECT_CORNERB)
			overlaystate = "blueOverlay"

	var/image/I = image('icons/turf/overlays.dmi', T, overlaystate)
	I.plane = ABOVE_LIGHTING_PLANE
	preview += I
	BM.holder.images += preview
	return T


/**
 * Highlight a region in the preview
 *
 * @param {list} region - The region to highlight
 */
/datum/buildmode_mode/proc/highlight_region(region)
	BM.holder.images -= preview
	for(var/turf/T in region)
		var/image/I = image('icons/turf/overlays.dmi', T, "redOverlay")
		I.plane = ABOVE_LIGHTING_PLANE
		preview += I
	BM.holder.images += preview

/**
 * Deselect the current region
 */
/datum/buildmode_mode/proc/deselect_region()
	BM.holder.images -= preview
	preview.Cut()
	cornerA = null
	cornerB = null


/**
 * Handle operations on the selected area
 *
 * @param {client} c - The client selecting the area
 * @param {string} params - Click parameters
 */
/datum/buildmode_mode/proc/handle_selected_area(client/c, list/modifiers)
	return
