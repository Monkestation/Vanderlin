// Make use of MouseEntered/MouseExited to allow for effects and behaviours related to simply hovering above the element

/obj/abstract/visual_ui_element/hoverable
	var/hovering = FALSE
	var/tooltip_title = "Undefined UI Element"
	var/tooltip_content = ""
	var/tooltip_theme = "default"
	var/hover_state = TRUE

/obj/abstract/visual_ui_element/hoverable/MouseEntered(location,control,params)
	start_hovering(location,control,params)
	hovering = 1
	if(element_flags & MINDUI_FLAG_HOVERINFO)
		. = ..()

/obj/abstract/visual_ui_element/hoverable/MouseExited()
	stop_hovering()
	hovering = 0

/obj/abstract/visual_ui_element/hoverable/hide()
	..()
	stop_hovering()
	hovering = 0

/obj/abstract/visual_ui_element/hoverable/disappear()
	..()
	stop_hovering()
	hovering = 0

/obj/abstract/visual_ui_element/hoverable/proc/start_hovering(location, control, params)
	if(hover_state)
		icon_state = "[base_icon_state]-hover"

	if(!(element_flags & MINDUI_FLAG_TOOLTIP))
		return

	var/mob/M = get_user()
	if(!M)
		return
	//I hate this, I hate this, but somehow the tooltips won't appear in the right place unless I do this black magic
	//this only happens with mindUI elements, but the more offset from the center the elements are, tooltips become even more offset.
	//this code corrects this extra offset.
	var/list/modifiers = params2list(params)
	var/screenloc = LAZYACCESS(modifiers, SCREEN_LOC)
	var/x_index = findtext(screenloc, ":", 1, 0)
	var/comma_index = findtext(screenloc,",", x_index, 0)
	var/y_index = findtext(screenloc,":", comma_index, 0)
	var/x_loc = text2num(copytext(screenloc, 1, x_index))
	var/y_loc = text2num(copytext(screenloc, comma_index+1, y_index))
	if (x_loc <= 7)
		x_loc = 7
	else
		x_loc = 9
	if (y_loc <= 7)
		y_loc = 7
	else
		y_loc = 9
	openToolTip(M, src, "icon-x=1;icon-y=1;screen-loc=[x_loc]:1,[y_loc]:1", title = tooltip_title,content = tooltip_content,theme = tooltip_theme)

/obj/abstract/visual_ui_element/hoverable/proc/stop_hovering()
	if(hover_state)
		icon_state = "[base_icon_state]"
	if(!(element_flags & MINDUI_FLAG_TOOLTIP))
		return

	var/mob/M = get_user()
	if(!M)
		return

	closeToolTip(M)
