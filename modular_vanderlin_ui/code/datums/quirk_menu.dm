/datum/quirk_menu
	var/datum/preferences/prefs

/datum/quirk_menu/New(datum/preferences/prefs)
	src.prefs = prefs

/datum/quirk_menu/Destroy()
	prefs = null
	return ..()

/datum/quirk_menu/ui_state(mob/user)
	return GLOB.always_state

/datum/quirk_menu/ui_interact(mob/user, datum/tgui/ui)
	ui = SStgui.try_update_ui(user, src, ui)
	if(!ui)
		ui = new(user, src, "QuirkMenu", "Quirk Selection")
		ui.open()

/datum/quirk_menu/ui_data(mob/user)
	var/list/data = list()
	data["balance"] = prefs.calculate_quirk_balance()
	data["boon_count"] = prefs.count_boons_in_list()
	data["max_boons"] = MAX_BOONS
	var/list/categories = list()
	for(var/category in GLOB.quirk_points_by_type)
		var/list/entries = list()
		for(var/list/entry in GLOB.quirk_points_by_type[category])
			var/quirk_type = entry["type"]
			entries += list(list(
				"name" = entry["name"],
				"desc" = entry["desc"],
				"value" = entry["value"],
				"selected" = (quirk_type in prefs.quirks),
				"can_add" = prefs.can_add_quirk(quirk_type),
			))
		categories[category] = entries
	data["categories"] = categories
	return data

/datum/quirk_menu/ui_act(action, list/params, datum/tgui/ui, datum/ui_state/state)
	. = ..()
	if(.)
		return
	var/quirk_name = params["name"]
	var/quirk_type = GLOB.quirk_registry[quirk_name]
	switch(action)
		if("add_quirk")
			if(!quirk_type)
				return
			prefs.add_quirk(quirk_type)
			return TRUE
		if("remove_quirk")
			if(!quirk_type)
				return
			prefs.remove_quirk(quirk_type)
			return TRUE