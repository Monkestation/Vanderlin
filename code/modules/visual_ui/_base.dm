/*
	visual_ui, started on 2021/07/22 by Deity.
	instead of being stored in the mob like /datum/hud, this one is stored in a mob's /datum/mind 's active_uis list
	A mind can store several separate visual_uis, think of each one as its own menu/pop-up, that in turns contains a list of /obj/visual_ui_element,
	or other /datum/visual_ui that
	* mind datums and their elements should avoid holding references to atoms in the real world.
*/

/obj/abstract/proc/get_view_size()
	if(usr && usr.client)
		. = usr.client.view
	else
		. = world.view

// During game setup we fill a list with the IDs and types of every /datum/visual_ui subtypes
GLOBAL_VAR_INIT(visual_ui_init, FALSE)
GLOBAL_LIST_INIT(visual_ui_id_to_type, list())

/proc/init_visual_ui()
	if (GLOB.visual_ui_init)
		return
	GLOB.visual_ui_init = TRUE
	for (var/visual_ui_type in subtypesof(/datum/visual_ui))
		var/datum/visual_ui/ui = visual_ui_type
		GLOB.visual_ui_id_to_type[initial(ui.uniqueID)] = visual_ui_type

//////////////////////MIND UI PROCS/////////////////////////////

/datum/mind
	var/list/active_uis = list()

/datum/mind/Destroy()
	. = ..()
	remove_all_uis()
	QDEL_NULL(active_uis)

/datum/mind/proc/resend_all_uis() // Re-sends all mind uis to client.screen, called on mob/living/Login()
	for (var/visual_ui in active_uis)
		var/datum/visual_ui/ui = active_uis[visual_ui]
		ui.send_to_client()

/datum/mind/proc/remove_all_uis() // Removes all mind uis from client.screen, called on mob/Logout()
	for (var/visual_ui in active_uis)
		var/datum/visual_ui/ui = active_uis[visual_ui]
		ui.remove_from_client()


/datum/mind/proc/display_ui(ui_ID)
	var/datum/visual_ui/ui
	if (ui_ID in active_uis)
		ui = active_uis[ui_ID]
	else
		if (!(ui_ID in GLOB.visual_ui_id_to_type))
			return
		var/ui_type = GLOB.visual_ui_id_to_type[ui_ID]
		ui = new ui_type(src)
	if(!ui.valid())
		ui.hide()
	else
		ui.display()

/datum/mind/proc/hide_ui(ui_ID)
	if (ui_ID in active_uis)
		var/datum/visual_ui/ui = active_uis[ui_ID]
		ui.hide()

/datum/mind/proc/update_ui_screen_loc()
	for (var/visual_ui in active_uis)
		var/datum/visual_ui/ui = active_uis[visual_ui]
		ui.update_ui_screen_loc()

//////////////////////MOB SHORTCUT PROCS////////////////////////

/mob/proc/resend_all_uis()
	if (mind)
		mind.resend_all_uis()

/mob/proc/remove_all_uis()
	if (mind)
		mind.remove_all_uis()

/mob/proc/display_ui(ui_ID = "Hello World")
	if (mind)
		mind.display_ui(ui_ID)

/mob/proc/hide_ui(ui_ID)
	if (mind)
		mind.hide_ui(ui_ID)

/mob/proc/update_ui_screen_loc()
	if (mind)
		mind.update_ui_screen_loc()

/mob/proc/update_ui_element_icon(element_type)
	if (client)
		var/obj/abstract/visual_ui_element/element = locate(element_type) in client.screen
		if (element)
			element.UpdateIcon()

/mob/proc/update_all_element_icons()
	if (client)
		for (var/obj/abstract/visual_ui_element/element in client.screen)
			element.UpdateIcon()


////////////////////////////////////////////////////////////////////
//																  //
//							  MIND UI							  //
//																  //
////////////////////////////////////////////////////////////////////

/datum/visual_ui
	var/uniqueID = "Default"
	var/datum/mind/mind
	var/list/elements = list()	// the objects displayed by the UI. Those can be both non-interactable objects (background/fluff images, foreground shaders) and clickable interace buttons.
	var/list/subUIs	= list()	// children UI. Closing the parent UI closes all the children.
	var/datum/visual_ui/parent = null
	var/offset_x = 0 //KEEP THESE AT 0, they are set by /obj/abstract/visual_ui_element/hoverable/movable/
	var/offset_y = 0
	var/offset_layer = VISUAL_UI_GROUP_A

	var/x = "CENTER"
	var/y = "CENTER"

	var/list/element_types_to_spawn = list()
	var/list/sub_uis_to_spawn = list()

	var/display_with_parent = FALSE
	var/never_move = FALSE

	var/active = TRUE

	var/obj/abstract/visual_ui_element/failsafe/failsafe	// All mind UI datums include one of those so we can detect if the elements somehow disappeared from client.screen

/datum/visual_ui/New(datum/mind/M)
	if (!istype(M))
		qdel(src)
		return
	mind = M
	mind.active_uis[uniqueID] = src
	..()
	spawn_elements()
	for (var/ui_type in sub_uis_to_spawn)
		var/datum/visual_ui/child = new ui_type(mind)
		subUIs += child
		child.parent = src
	send_to_client()

/datum/visual_ui/proc/spawn_elements()
	failsafe = new (null, src)
	elements += failsafe
	for (var/element_type in element_types_to_spawn)
		elements += new element_type(null, src)

// Send every element to the client, called on Login() and when the UI is first added to a mind
/datum/visual_ui/proc/send_to_client()
	var/mob/current = get_user()
	if (current)
		if (!current.client)
			return

		if (!valid() || !display_with_parent) // Makes sure the UI isn't still active when we should have lost it (such as coming out of a mecha while disconnected)
			hide(TRUE)

		for (var/obj/abstract/visual_ui_element/element in elements)
			current.client.screen |= element

// Removes every element from the client, called on Logout()
/datum/visual_ui/proc/remove_from_client()
	var/mob/current = get_user()
	if (current)
		if (!current.client)
			return

		current.client.screen -= elements

// Makes every element visible
/datum/visual_ui/proc/display()
	if (!valid())
		hide(TRUE)
		return
	active = TRUE

	var/mob/M = get_user()
	if (failsafe && M.client && !(failsafe in M.client.screen))
		send_to_client() // The elements disappeared from the client screen due to some fuckery, send them back!

	for (var/obj/abstract/visual_ui_element/element in elements)
		element.appear()
	for (var/datum/visual_ui/child in subUIs)
		if (child.display_with_parent)
			if(child.valid())
				child.display()
			else
				child.hide()

/datum/visual_ui/proc/hide(override = FALSE)
	active = FALSE
	hide_children(override)
	hide_elements(override)

/datum/visual_ui/proc/hide_children(override = FALSE)
	for (var/datum/visual_ui/child in subUIs)
		child.hide(override)

/datum/visual_ui/proc/hide_elements(override = FALSE)
	for (var/obj/abstract/visual_ui_element/element in elements)
		if (override)
			element.invisibility = 101
		else
			element.hide()

/datum/visual_ui/proc/valid()
	return TRUE

/datum/visual_ui/proc/update_ui_screen_loc()
	for (var/obj/abstract/visual_ui_element/element in elements)
		element.update_ui_screen_loc()

/datum/visual_ui/proc/hide_parent(levels=0)
	if (levels <= 0)
		var/datum/visual_ui/ancestor = get_ancestor()
		ancestor.hide()
		return
	else
		var/datum/visual_ui/to_hide = src
		while (levels > 0)
			if (to_hide.parent)
				levels--
				to_hide = to_hide.parent
			else
				break
		to_hide.hide()

/datum/visual_ui/proc/get_ancestor()
	if (parent)
		return parent.get_ancestor()
	else
		return src

/datum/visual_ui/proc/get_user()
	if(mind.current_ghost)
		return mind.current_ghost
	return mind.current

////////////////////////////////////////////////////////////////////
//																  //
//							 UI ELEMENT							  //
//																  //
////////////////////////////////////////////////////////////////////

/obj/abstract/visual_ui_element
	name = "Undefined UI Element"
	icon = 'icons/visual_ui/32x32.dmi'
	icon_state = ""
	mouse_opacity = MOUSE_OPACITY_OPAQUE
	plane = HUD_PLANE

	var/datum/visual_ui/parent = null
	var/element_flags = 0
	//MINDUI_FLAG_PROCESSING - Adds the element to processing_objects and calls process()
	//MINDUI_FLAG_TOOLTIP	 - Displays a tooltip upon mouse hovering (only for /obj/abstract/visual_ui_element/hoverable !)

	var/offset_x = 0
	var/offset_y = 0

	var/const_offset_y = 0 //these are constant offsets to ensure moving is seemless
	var/const_offset_x = 0 //these are constant offsets to ensure moving is seemless

	var/obj/abstract/visual_ui_element/scrollable/scrollable_parent = null
	var/scroll_height = 0

	var/initial_offset_y = 0
	var/initial_offset_y_set = FALSE


/obj/abstract/visual_ui_element/New(turf/loc, datum/visual_ui/P)
	if (!istype(P))
		qdel(src)
		return
	..()
	base_icon_state = icon_state
	parent = P
	update_ui_screen_loc()

	if (element_flags & MINDUI_FLAG_PROCESSING)
		START_PROCESSING(SSobj, src)

/obj/abstract/visual_ui_element/Destroy()
	if (element_flags & MINDUI_FLAG_PROCESSING)
		STOP_PROCESSING(SSobj, src)
	..()

/obj/abstract/visual_ui_element/proc/can_appear()
	return TRUE

/obj/abstract/visual_ui_element/proc/appear()
	if (invisibility)
		invisibility = 0
		UpdateIcon(TRUE)
	else
		invisibility = 0
		UpdateIcon()

/obj/abstract/visual_ui_element/hide()
	if (!parent.active) // we check again for it due to potential spawn() use, and inconsistencies caused by quick UI toggling
		invisibility = 101

//In case we want to make a specific element disappear, and not because the mind UI is inactive.
/obj/abstract/visual_ui_element/proc/disappear()
	invisibility = 101

/obj/abstract/visual_ui_element/proc/get_user()
	if(!parent?.mind)
		return
	if(parent.mind.current_ghost)
		return parent.mind.current_ghost
	return parent.mind.current

/obj/abstract/visual_ui_element/proc/update_ui_screen_loc()
	screen_loc = "[parent.x]:[offset_x + parent.offset_x],[parent.y]:[offset_y+parent.offset_y]"
	layer = initial(layer) + parent.offset_layer

/obj/abstract/visual_ui_element/proc/UpdateIcon(appear = FALSE)
	return

/obj/abstract/visual_ui_element/proc/string_2_image(string, spacing=6, image_font='icons/visual_ui/font_8x8.dmi', _color="#FFFFFF", _pixel_x = 0, _pixel_y = 0) // only supports numbers right now
	if (!string)
		return image(image_font,"")

	var/image/result = image(image_font,"")
	for (var/i = 1 to length(string))
		var/image/I = image(image_font,copytext(string,i,i+1))
		I.pixel_x = (i - 1) * spacing
		result.overlays += I
	result.color = _color
	result.pixel_x = _pixel_x
	result.pixel_y = _pixel_y
	return result

/obj/abstract/visual_ui_element/proc/string_2_maptext(string, font="Consolas", font_size="8pt", _color="#FFFFFF", _pixel_x = 0, _pixel_y = 0)
	if (!string)
		return image(icon = null)

	var/image/I_shadow = image(icon = null)
	I_shadow.maptext = MAPTEXT("<span style='color:#000000;font-size:[font_size];font-family:'[font]';''>[string]</span>")
	I_shadow.maptext_height = 512
	I_shadow.maptext_width = 512
	I_shadow.maptext_x = 1 + _pixel_x
	I_shadow.maptext_y = -1 + _pixel_y
	var/image/I = image(icon = null)
	I.maptext = MAPTEXT("<span style='color:[_color];font-size:[font_size];font-family:'[font]';'>[string]</span>")
	I.maptext_height = 512
	I.maptext_width = 512
	I.maptext_x = _pixel_x
	I.maptext_y = _pixel_y

	overlays += I_shadow
	overlays += I

/obj/abstract/visual_ui_element/proc/slide_ui_element(new_x = 0, new_y = 0, duration, layer = VISUAL_UI_BACK, hide_after = FALSE)
	invisibility = 101
	var/image/ui_image = image(icon, src, icon_state, layer)
	ui_image.overlays = overlays
	var/mob/U = get_user()
	U.client.images |= ui_image
	animate(ui_image, pixel_x = new_x - offset_x, pixel_y = new_y - offset_y,  time = duration)
	spawn(duration)
		offset_x = new_x
		offset_y = new_y
		update_ui_screen_loc()
		U.client.images -= ui_image
		if(!hide_after)
			invisibility = 0

/obj/abstract/visual_ui_element/failsafe
	icon_state = "blank"
	mouse_opacity = MOUSE_OPACITY_TRANSPARENT

/datum/visual_ui/proc/animate_elements(start_y_offset, end_y_offset, duration, on_complete)
	for(var/obj/abstract/visual_ui_element/element in elements)
		// We're using pixel_y for smooth animation rather than screen_loc
		// because screen_loc updates are not as smooth
		var/start_pixel_y = start_y_offset
		var/end_pixel_y = end_y_offset

		element.pixel_y = start_pixel_y
		animate(element, pixel_y = end_pixel_y, time = duration)

	if(on_complete)
		addtimer(on_complete, duration + 1)
