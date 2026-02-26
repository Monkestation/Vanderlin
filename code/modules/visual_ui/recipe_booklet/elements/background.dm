/obj/abstract/visual_ui_element/book_background
	icon = 'icons/visual_ui/booklet.dmi'
	icon_state = "book_background"
	layer = VISUAL_UI_BACK

/obj/abstract/visual_ui_element/hoverable/book_close
	icon = 'icons/visual_ui/booklet.dmi'
	icon_state = "book_close"
	layer = VISUAL_UI_BUTTON
	mouse_opacity = MOUSE_OPACITY_OPAQUE

/obj/abstract/visual_ui_element/hoverable/book_close/Click()
	var/datum/visual_ui/ancestor = parent.get_ancestor()
	ancestor.hide()

/obj/abstract/visual_ui_element/hoverable/movable/move_book
	icon = 'icons/visual_ui/booklet.dmi'
	icon_state = "book_move"
	layer = VISUAL_UI_BUTTON
	mouse_opacity = MOUSE_OPACITY_OPAQUE

	move_whole_ui = TRUE
