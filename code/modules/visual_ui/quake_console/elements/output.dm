
/obj/abstract/visual_ui_element/scroll_track/dummy
	icon = null
	icon_state = null

/obj/abstract/visual_ui_element/hoverable/scroll_handle/dummy
	icon = null
	icon_state = null

/obj/abstract/visual_ui_element/scrollable/console_output
	name = "Console Output"
	icon = 'icons/visual_ui/quake_console.dmi'
	icon_state = "quake_background"
	mask_icon_state = "quake_scroll_mask"

	offset_x = -190
	offset_y = -215
	special_offset = -70
	special_x_offset = 180

	scroll_handle = /obj/abstract/visual_ui_element/hoverable/scroll_handle/dummy
	scroll_track = /obj/abstract/visual_ui_element/scroll_track/dummy

	mouse_opacity = 1
	var/list/lines = list()
	var/max_lines = 1000
	var/line_height = 18
	var/obj/abstract/visual_ui_element/console_text/text_element

	// Scroll dimensions
	var/console_width = 19 // tiles
	var/console_height = 10 // tiles
	visible_width = 608 // 19 * 32
	visible_height = 320 // 10 * 32
	max_height = 320

/obj/abstract/visual_ui_element/scrollable/console_output/New(turf/loc, datum/visual_ui/P)
	. = ..()
	// Create the text display element
	text_element = new(null, parent)
	text_element.offset_x = offset_x
	text_element.offset_y = offset_y
	text_element.parent = parent
	parent.elements += text_element
	register_element(text_element)

	add_line("Psydon's Awesome Epic Powers")
	add_line("Type 'help' for available commands")

/obj/abstract/visual_ui_element/scrollable/console_output/Click(location, control, params)
	var/obj/abstract/visual_ui_element/console_input/input = locate(/obj/abstract/visual_ui_element/console_input) in parent.elements
	if(input && !input.focused)
		input.focus()

/obj/abstract/visual_ui_element/scrollable/console_output/UpdateIcon(appear = FALSE)
	text_element.lines = lines.Copy()
	text_element.content_height = lines.len * line_height
	text_element.UpdateIcon()

/obj/abstract/visual_ui_element/scrollable/console_output/proc/add_line(text)
	lines += text
	if(lines.len > max_lines)
		lines.Cut(1, 2) // Remove oldest line

	// Auto-scroll to bottom unless user has scrolled up
	if(scroll_position >= 0)
		scroll_position = 0
	else
		// Maintain relative scroll position
		var/new_content_height = lines.len * line_height
		var/new_scroll_max = max(0, new_content_height - visible_height)
		scroll_position = max(-new_scroll_max, scroll_position)

	recalculate_content_height()
	UpdateIcon()
	update_element_positions()

/obj/abstract/visual_ui_element/scrollable/console_output/proc/clear()
	lines.Cut()
	text_element.lines.Cut()
	scroll_position = 0
	recalculate_content_height()
	UpdateIcon()
	update_element_positions()

/obj/abstract/visual_ui_element/scrollable/console_output/recalculate_content_height()
	max_height = 0
	for(var/obj/abstract/visual_ui_element/E in container_elements)
		max_height += E.scroll_height

	max_height = max(initial(max_height), abs( (lines.len * line_height) + 64))

// The scrollable text content
/obj/abstract/visual_ui_element/console_text
	name = "Console Text"
	icon = 'icons/visual_ui/32x32.dmi'
	icon_state = "blank"
	mouse_opacity = 0
	layer = VISUAL_UI_FRONT
	var/list/lines = list()
	var/content_height = 0

/obj/abstract/visual_ui_element/console_text/UpdateIcon(appear = FALSE)
	if(!lines.len)
		return

	var/display_text = ""

	for(var/line in lines)
		display_text += "[line]<br>"

	maptext = MAPTEXT_VATICANUS("<span style='color:#00FF00'>[display_text]</span>")
	maptext_width = 380
	maptext_height = content_height
	maptext_x = 8
	maptext_y = 30
