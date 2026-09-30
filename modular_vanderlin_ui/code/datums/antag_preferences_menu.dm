/datum/antag_preferences_menu
	var/datum/preferences/prefs

/datum/antag_preferences_menu/New(datum/preferences/prefs)
	src.prefs = prefs

/datum/antag_preferences_menu/Destroy()
	prefs = null
	return ..()

/datum/antag_preferences_menu/ui_state(mob/user)
	return GLOB.always_state

/datum/antag_preferences_menu/ui_interact(mob/user, datum/tgui/ui)
	ui = SStgui.try_update_ui(user, src, ui)
	if(!ui)
		ui = new(user, src, "AntagPreferences", "Antagonist Preferences")
		ui.open()

/datum/antag_preferences_menu/ui_data(mob/user)
	var/list/data = list()
	var/total_banned = is_total_antag_banned(user.ckey)
	if(total_banned)
		prefs.be_special = list()
	data["total_banned"] = total_banned
	var/list/villains = list()
	for(var/i in GLOB.special_roles_rogue)
		var/list/entry = list("name" = i)
		if(is_antag_banned(user.ckey, i))
			entry["status"] = "banned"
		else
			var/days_remaining = null
			if(ispath(GLOB.special_roles_rogue[i]) && CONFIG_GET(flag/use_age_restriction_for_jobs))
				days_remaining = get_remaining_days(user.client)
			if(days_remaining)
				entry["status"] = "locked"
				entry["days_remaining"] = days_remaining
			else
				entry["status"] = "available"
				entry["enabled"] = (i in prefs.be_special)
		villains += list(entry)
	data["villains"] = villains
	var/list/vessels = list()
	for(var/id in GLOB.vessel_ids)
		if(!user.client.is_whitelisted(id))
			continue
		vessels += list(list("name" = id, "enabled" = (id in prefs.be_special)))
	data["vessels"] = vessels
	return data

/datum/antag_preferences_menu/ui_act(action, list/params, datum/tgui/ui, datum/ui_state/state)
	. = ..()
	if(.)
		return
	switch(action)
		if("toggle")
			var/toggle_type = params["toggle_type"]
			if(!toggle_type)
				return
			if(toggle_type in prefs.be_special)
				prefs.be_special -= toggle_type
			else
				prefs.be_special += toggle_type
			return TRUE