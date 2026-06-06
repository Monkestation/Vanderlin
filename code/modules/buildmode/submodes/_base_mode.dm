
/**
 * Category switch button
 */
/atom/movable/screen/buildmode/categoryswitch
	var/category_type

/atom/movable/screen/buildmode/categoryswitch/Initialize(mapload, datum/hud/hud_owner, datum/buildmode/build_datum, category)
	. = ..()
	category_type = category
	update_appearance(UPDATE_ICON_STATE | UPDATE_NAME)

/atom/movable/screen/buildmode/categoryswitch/update_icon_state()
	switch(category_type)
		if(BM_CATEGORY_TURF)
			icon_state = "cat_turf"
		if(BM_CATEGORY_OBJ)
			icon_state = "cat_obj"
		if(BM_CATEGORY_MOB)
			icon_state = "cat_mob"
		if(BM_CATEGORY_ITEM)
			icon_state = "cat_item"
	return ..()

/atom/movable/screen/buildmode/categoryswitch/update_name()
	switch(category_type)
		if(BM_CATEGORY_TURF)
			name = "Turfs"
		if(BM_CATEGORY_OBJ)
			name = "Objects"
		if(BM_CATEGORY_MOB)
			name = "Mobs"
		if(BM_CATEGORY_ITEM)
			name = "Items"
	return ..()

/atom/movable/screen/buildmode/categoryswitch/Click()
	bd.change_category(category_type)

/datum/buildmode_mode
	var/key = "oops"
	var/datum/buildmode/BM

	// Corner selection component
	var/use_corner_selection = FALSE
	var/list/preview
	var/turf/cornerA
	var/turf/cornerB

/**
 * Create a new buildmode mode
 *
 * @param {datum/buildmode} BM - The buildmode datum this mode belongs to
 */
/datum/buildmode_mode/New(datum/buildmode/BM)
	src.BM = BM
	preview = list()
	return ..()

/**
 * Clean up resources when deleted
 */
/datum/buildmode_mode/Destroy()
	cornerA = null
	cornerB = null
	QDEL_LIST(preview)
	preview = null
	return ..()

/**
 * Called when entering this mode
 *
 * @param {datum/buildmode} BM - The buildmode datum
 */
/datum/buildmode_mode/proc/enter_mode(datum/buildmode/BM)
	return

/**
 * Called when exiting this mode
 *
 * @param {datum/buildmode} BM - The buildmode datum
 */
/datum/buildmode_mode/proc/exit_mode(datum/buildmode/BM)
	return

/**
 * Get the icon state for the mode button
 *
 * @return {string} - The icon state to use
 */
/datum/buildmode_mode/proc/get_button_iconstate()
	return "buildmode_[key]"

/**
 * Show help for this mode
 *
 * @param {client} c - The client to show help to
 */
/datum/buildmode_mode/proc/show_help(client/c)
	CRASH("No help defined for [src.type], yell at a coder")

/**
 * Change mode settings
 *
 * @param {client} c - The client changing settings
 */
/datum/buildmode_mode/proc/change_settings(client/c)
	to_chat(c, "<span class='warning'>There is no configuration available for this mode</span>")
	return

/**
 * Basic buildmode mode
 */
/datum/buildmode_mode/basic
	key = "basic"

/**
 * Enter mode callback
 */
/datum/buildmode_mode/basic/enter_mode(datum/buildmode/bm)
	to_chat(BM.holder.mob, "<span class='notice'>Basic Build Mode</span>")
	to_chat(BM.holder.mob, "<span class='notice'>Left Mouse Button = Place selected object</span>")
	to_chat(BM.holder.mob, "<span class='notice'>Right Mouse Button = Clear selection</span>")
	to_chat(BM.holder.mob, "<span class='notice'>Shift + Left Mouse Button = Set pixel offset</span>")

/**
 * Exit mode callback
 */
/datum/buildmode_mode/basic/exit_mode(datum/buildmode/bm)
	return

/**
 * Handle click in this mode
 */
/datum/buildmode_mode/basic/handle_click(client/c, list/modifiers, obj/object)
	return FALSE

/**
 * Advanced buildmode mode
 */
/datum/buildmode_mode/advanced
	key = "advanced"

/**
 * Enter mode callback
 */
/datum/buildmode_mode/advanced/enter_mode(datum/buildmode/bm)
	to_chat(BM.holder.mob, "<span class='notice'>Advanced Build Mode</span>")
	to_chat(BM.holder.mob, "<span class='notice'>Left Mouse Button = Create/Delete/Modify objects</span>")
	to_chat(BM.holder.mob, "<span class='notice'>Right Mouse Button = Copy object type</span>")
	to_chat(BM.holder.mob, "<span class='notice'>Middle Mouse Button = Select object to modify</span>")

/**
 * Exit mode callback
 */
/datum/buildmode_mode/advanced/exit_mode(datum/buildmode/bm)
	return

/**
 * Handle click in this mode
 */
/datum/buildmode_mode/advanced/handle_click(client/c, list/modifiers, obj/object)
	var/left_click = LAZYACCESS(modifiers, LEFT_CLICK)
	var/right_click = LAZYACCESS(modifiers, RIGHT_CLICK)
	var/middle_click = LAZYACCESS(modifiers, MIDDLE_CLICK)

	if(left_click)
		if(isturf(object))
			var/turf/T = object
			if(ispath(BM.selected_item, /turf))
				T.ChangeTurf(BM.selected_item)
			else if(ispath(BM.selected_item, /obj) || ispath(BM.selected_item, /mob))
				var/atom/A = new BM.selected_item(T)
				A.setDir(BM.build_dir)
				A.pixel_x = BM.pixel_x_offset
				A.pixel_y = BM.pixel_y_offset
		else if(isobj(object))
			qdel(object)
		return TRUE

	if(right_click)
		if(istype(object))
			BM.select_item(object.type)
		return TRUE

	if(middle_click)
		if(istype(object))
			to_chat(c.mob, "<span class='notice'>Selected [object] for modification.</span>")
		return TRUE

	return FALSE
