
/obj/abstract/visual_ui_element/spellcraft_star/point
	icon_state = "star_point_1"
	name = "material slot"
	layer = VISUAL_UI_BUTTON
	var/index = 0

/obj/abstract/visual_ui_element/spellcraft_star/point/one
	index = 1
	icon_offset_x = 60
	icon_offset_y = 350

/obj/abstract/visual_ui_element/spellcraft_star/point/two
	icon_state = "star_point_2"
	index = 2
	icon_offset_x = 60
	icon_offset_y = 160

/obj/abstract/visual_ui_element/spellcraft_star/point/three
	icon_state = "star_point_3"
	index = 3
	icon_offset_x = 240
	icon_offset_y = 60

/obj/abstract/visual_ui_element/spellcraft_star/point/four
	icon_state = "star_point_4"
	index = 4
	icon_offset_x = 420
	icon_offset_y = 160

/obj/abstract/visual_ui_element/spellcraft_star/point/five
	icon_state = "star_point_5"
	index = 5
	icon_offset_x = 420
	icon_offset_y = 350

/obj/abstract/visual_ui_element/spellcraft_star/point/six
	icon_state = "star_point_6"
	index = 6
	icon_offset_x = 240
	icon_offset_y = 460

/obj/abstract/visual_ui_element/spellcraft_star/point/UpdateIcon(appear = FALSE)
	. = ..()
	cut_overlays()
	var/datum/visual_ui/spellcraft_star/ui = parent
	var/datum/spellcraft_session/session = ui?.get_session()
	var/obj/item/slotted = session?.materials[index]
	if(slotted)
		var/image/item_overlay = image(icon = slotted.icon, icon_state = slotted.icon_state)
		item_overlay.pixel_x = icon_offset_x
		item_overlay.pixel_y = icon_offset_y
		item_overlay.transform = matrix() * 3
		add_overlay(item_overlay)
		name = "material slot ([slotted.name])"
	else
		name = "material slot"

/obj/abstract/visual_ui_element/spellcraft_star/point/Click(location, control, params)
	var/mob/living/user = get_user()
	if(!user)
		return
	var/datum/visual_ui/spellcraft_star/ui = parent
	var/datum/spellcraft_session/session = ui.get_session()
	if(!session)
		return
	var/obj/item/held = user.get_active_held_item()
	if(held)
		if(session.try_insert_material(index, held, user))
			ui.refresh_all()
	else if(session.eject_material(index, user))
		ui.refresh_all()
