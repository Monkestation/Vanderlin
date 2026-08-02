
/datum/ticket/special
	ticket_type = TICKET_TYPE_SPECIAL
	var/datum/special_trait/special_trait_path

/datum/ticket/special/to_list()
	var/list/L = ..()
	L["special_trait_path"] = special_trait_path
	return L

/datum/ticket/special/details()
	return ", [initial(special_trait_path.name)]"

/datum/ticket/special/from_list(list/L)
	..()
	special_trait_path = L["special_trait_path"]

/datum/ticket/special/enrich_ui_entry(list/entry)
	entry["ui_icon"] = null
	entry["ui_icon_state"] = null
	entry["ui_fa_icon"] = "dice"
	entry["ui_color"] = "#9c27b0"
	entry["ui_type_label"] = "Special Trait"
	entry["ui_grant_summary"] = special_trait_path ? "Queues special: [initial(special_trait_path.name)]" : "Queues a special trait"

/datum/ticket/special/use(client/user)
	if(!special_trait_path)
		return FALSE
	if(user.prefs.next_special_trait)
		to_chat(user, span_warning("You already have a special trait queued. Clear it first."))
		return FALSE
	user.prefs.next_special_trait = special_trait_path
	var/datum/special_trait/trait = SPECIAL_TRAIT(special_trait_path)
	to_chat(user, span_notice("Ticket used! Special trait queued: <b>[trait?.name]</b>!"))
	return TRUE
