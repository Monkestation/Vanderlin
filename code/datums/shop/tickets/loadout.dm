
/datum/ticket/loadout
	ticket_type = TICKET_TYPE_LOADOUT
	var/datum/loadout_item/loadout_item_path

/datum/ticket/loadout/to_list()
	var/list/L = ..()
	L["loadout_item_path"] = loadout_item_path
	return L

/datum/ticket/loadout/details()
	return ", [initial(loadout_item_path.name)]"

/datum/ticket/loadout/from_list(list/L)
	..()
	loadout_item_path = L["loadout_item_path"]

/datum/ticket/loadout/use(client/user)
	if(!loadout_item_path)
		return FALSE
	var/datum/loadout_item/item = GLOB.loadout_items[loadout_item_path]
	if(!item)
		to_chat(user, span_warning("That loadout item no longer exists."))
		return FALSE
	if("[loadout_item_path]" in user.prefs.owned_loadout_items)
		to_chat(user, span_warning("You already own that loadout item."))
		return FALSE
	user.prefs.owned_loadout_items += "[loadout_item_path]"
	user.prefs.save_preferences()
	to_chat(user, span_notice("Ticket used! Permanently unlocked: <b>[item.name]</b>!"))
	return TRUE

/datum/ticket/loadout/enrich_ui_entry(list/entry)
	entry["ui_icon"] = loadout_item_path ? initial(loadout_item_path.ui_icon) : null
	entry["ui_icon_state"] = loadout_item_path ? initial(loadout_item_path.ui_icon_state) : null
	entry["item_name"] = loadout_item_path ? initial(loadout_item_path.name) : null
	entry["ui_fa_icon"] = "box-open"
	entry["ui_color"] = "#2196f3"
	entry["ui_type_label"] = "Loadout Item"
	entry["ui_grant_summary"] = loadout_item_path ? "Grants: [initial(loadout_item_path.name)]" : "Grants a loadout item"

