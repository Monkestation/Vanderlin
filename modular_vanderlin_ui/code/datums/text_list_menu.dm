/datum/text_list_menu
	var/datum/preferences/prefs
	var/mob/owner
	var/pref_type
	var/max_entries
	var/max_length
	var/title_text

/datum/text_list_menu/New(datum/preferences/prefs, mob/owner, pref_type, max_entries, max_length, title_text)
	src.prefs = prefs
	src.owner = owner
	src.pref_type = pref_type
	src.max_entries = max_entries
	src.max_length = max_length
	src.title_text = title_text

/datum/text_list_menu/Destroy()
	prefs = null
	owner = null
	return ..()

/datum/text_list_menu/ui_state(mob/user)
	return GLOB.always_state

/datum/text_list_menu/ui_interact(mob/user, datum/tgui/ui)
	ui = SStgui.try_update_ui(user, src, ui)
	if(!ui)
		ui = new(user, src, "TextListMenu", title_text)
		ui.open()

/datum/text_list_menu/ui_data(mob/user)
	var/list/data = list()
	var/list/entries = prefs.read_preference(pref_type)
	data["entries"] = entries ? entries.Copy() : list()
	data["max_entries"] = max_entries
	data["title"] = title_text
	return data

/datum/text_list_menu/ui_act(action, list/params, datum/tgui/ui, datum/ui_state/state)
	. = ..()
	if(.)
		return
	var/list/entries = prefs.read_preference(pref_type)
	if(!entries)
		entries = list()
	switch(action)
		if("add")
			if(length(entries) >= max_entries)
				return
			var/new_entry = input(owner, "Add new entry:", title_text) as text|null
			if(!new_entry || !length(new_entry))
				return
			new_entry = copytext(new_entry, 1, max_length+1)
			entries += new_entry
			prefs.write_preference(pref_type, entries)
			return TRUE
		if("edit")
			var/index = text2num(params["index"]) + 1
			if(index < 1 || index > length(entries))
				return
			var/new_entry = input(owner, "Edit entry:", title_text, entries[index]) as text|null
			if(new_entry == null)
				return
			new_entry = copytext(new_entry, 1, max_length+1)
			entries[index] = new_entry
			prefs.write_preference(pref_type, entries)
			return TRUE
		if("remove")
			var/index = text2num(params["index"]) + 1
			if(index < 1 || index > length(entries))
				return
			entries.Cut(index, index+1)
			prefs.write_preference(pref_type, entries)
			return TRUE