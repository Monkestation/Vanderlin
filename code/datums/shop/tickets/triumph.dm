/datum/ticket/triumph
	ticket_type = TICKET_TYPE_TRIUMPH
	var/triumph_amount

/datum/ticket/triumph/to_list()
	var/list/L = ..()
	L["triumph_amount"] = triumph_amount
	return L

/datum/ticket/triumph/details()
	return ", [triumph_amount] triumphs"

/datum/ticket/triumph/from_list(list/L)
	..()
	triumph_amount = L["triumph_amount"]

/datum/ticket/triumph/use(client/user)
	if(!triumph_amount || triumph_amount <= 0)
		return FALSE
	adjust_triumphs(user, triumph_amount, FALSE, "Ticket Used", override_bonus = TRUE)
	return TRUE

/datum/ticket/triumph/enrich_ui_entry(list/entry)
	entry["ui_icon"] = null
	entry["ui_icon_state"] = null
	entry["ui_fa_icon"] = "trophy"
	entry["ui_color"] = "#ffd700"
	entry["ui_type_label"] = "Triumphs"
	entry["ui_grant_summary"] = triumph_amount > 0 ? "Grants: [triumph_amount] triumphs" : "Grants triumphs"
