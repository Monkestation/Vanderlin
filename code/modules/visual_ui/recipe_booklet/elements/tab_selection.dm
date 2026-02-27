/obj/abstract/visual_ui_element/hoverable/tab_selection
	icon = 'icons/visual_ui/booklet.dmi'
	icon_state = "tab_1"

	layer = VISUAL_UI_BUTTON
	mouse_opacity = MOUSE_OPACITY_ICON

	var/tab_key

/obj/abstract/visual_ui_element/hoverable/tab_selection/Click(location, control, params)
	var/datum/visual_ui/ancestor = parent.get_ancestor()
	var/obj/abstract/visual_ui_element/scrollable/recipe_group/grouping = locate(/obj/abstract/visual_ui_element/scrollable/recipe_group) in ancestor.elements
	grouping?.tab_selection_click(tab_key)

/obj/abstract/visual_ui_element/hoverable/tab_selection/two
	icon_state = "tab_2"

/obj/abstract/visual_ui_element/hoverable/tab_selection/three
	icon_state = "tab_3"

/obj/abstract/visual_ui_element/hoverable/tab_selection/four
	icon_state = "tab_4"
