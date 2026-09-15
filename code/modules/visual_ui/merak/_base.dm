/datum/visual_ui/spellcraft_star
	uniqueID = "spellcraft_star"
	offset_layer = VISUAL_UI_GROUP_C
	y = "BOTTOM-1:16"
	x = "CENTER-8:16"
	element_types_to_spawn = list(
		/obj/abstract/visual_ui_element/spellcraft_star/center,
		/obj/abstract/visual_ui_element/spellcraft_star/point/one,
		/obj/abstract/visual_ui_element/spellcraft_star/point/two,
		/obj/abstract/visual_ui_element/spellcraft_star/point/three,
		/obj/abstract/visual_ui_element/spellcraft_star/point/four,
		/obj/abstract/visual_ui_element/spellcraft_star/point/five,
		/obj/abstract/visual_ui_element/spellcraft_star/point/six,
		/obj/abstract/visual_ui_element/spellcraft_star/confirm,
	)
	var/datum/weakref/book_ref

/datum/visual_ui/spellcraft_star/New(datum/mind/M, obj/item/spellbook_unfinished/pre_arcyne/book)
	book_ref = WEAKREF(book)
	. = ..(M)

/datum/visual_ui/spellcraft_star/proc/get_book()
	var/obj/item/spellbook_unfinished/pre_arcyne/book = book_ref?.resolve()
	if(QDELETED(book))
		return null
	return book

/datum/visual_ui/spellcraft_star/proc/get_session()
	var/obj/item/spellbook_unfinished/pre_arcyne/book = get_book()
	return book?.session

/datum/visual_ui/spellcraft_star/proc/refresh_all()
	for(var/obj/abstract/visual_ui_element/spellcraft_star/element in elements)
		element.UpdateIcon()

/obj/abstract/visual_ui_element/spellcraft_star
	icon = 'icons/hud/merak.dmi'
	element_flags = MINDUI_FLAG_TOOLTIP
	mouse_opacity = MOUSE_OPACITY_ICON
	var/icon_offset_x = 0
	var/icon_offset_y = 0

/obj/abstract/visual_ui_element/spellcraft_star/proc/get_ui()
	return parent

/obj/abstract/visual_ui_element/spellcraft_star/confirm
	icon_state = "star_confirm"
	name = "bind the tome"

/obj/abstract/visual_ui_element/spellcraft_star/confirm/Click(location, control, params)
	var/mob/living/user = get_user()
	if(!user)
		return
	var/datum/visual_ui/spellcraft_star/ui = parent
	var/datum/spellcraft_session/session = ui.get_session()
	if(!session || !session.can_assemble())
		to_chat(user, span_warning("The star isn't ready yet."))
		return
	if(session.assemble(user))
		ui.hide()
