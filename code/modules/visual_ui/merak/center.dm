
/obj/abstract/visual_ui_element/spellcraft_star/center
	icon_state = "star_center"
	name = "catalyst slot"
	layer = VISUAL_UI_BUTTON
	icon_offset_x = 240
	icon_offset_y = 240

/obj/abstract/visual_ui_element/spellcraft_star/center/UpdateIcon(appear = FALSE)
	. = ..()
	cut_overlays()
	var/datum/visual_ui/spellcraft_star/ui = parent
	var/datum/spellcraft_session/session = ui?.get_session()
	var/obj/item/slotted = session?.meld
	if(slotted)
		var/image/item_overlay = image(icon = slotted.icon, icon_state = slotted.icon_state)
		item_overlay.pixel_x = icon_offset_x
		item_overlay.pixel_y = icon_offset_y
		item_overlay.transform = matrix() * 3
		add_overlay(item_overlay)
		name = "catalyst slot ([slotted.name])"
	else
		name = "catalyst slot"

/obj/abstract/visual_ui_element/spellcraft_star/center/Click(location, control, params)
	var/mob/living/user = get_user()
	if(!user)
		return
	var/datum/visual_ui/spellcraft_star/ui = parent
	var/datum/spellcraft_session/session = ui.get_session()
	if(!session)
		return
	var/obj/item/held = user.get_active_held_item()
	if(held)
		if(session.try_insert_meld(held, user))
			ui.refresh_all()
	else if(session.eject_meld(user))
		ui.refresh_all()
