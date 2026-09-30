/datum/body_markings_menu
	var/datum/preferences/prefs
	var/mob/owner

/datum/body_markings_menu/New(datum/preferences/prefs, mob/owner)
	src.prefs = prefs
	src.owner = owner

/datum/body_markings_menu/Destroy()
	prefs = null
	owner = null
	return ..()

/datum/body_markings_menu/ui_state(mob/user)
	return GLOB.always_state

/datum/body_markings_menu/ui_interact(mob/user, datum/tgui/ui)
	ui = SStgui.try_update_ui(user, src, ui)
	if(!ui)
		ui = new(user, src, "BodyMarkings", "Body Markings")
		ui.open()

/datum/body_markings_menu/ui_data(mob/user)
	var/list/data = list()
	var/static/list/zone_names = list(
		"[BODY_ZONE_HEAD]" = "Head",
		"[BODY_ZONE_CHEST]" = "Chest",
		"[BODY_ZONE_R_ARM]" = "Right Arm",
		"[BODY_ZONE_L_ARM]" = "Left Arm",
		"[BODY_ZONE_R_LEG]" = "Right Leg",
		"[BODY_ZONE_L_LEG]" = "Left Leg",
		"[BODY_ZONE_PRECISE_R_HAND]" = "Right Hand",
		"[BODY_ZONE_PRECISE_L_HAND]" = "Left Hand",
	)
	var/list/zones_data = list()
	for(var/zone in GLOB.marking_zones)
		var/list/markings_data = list()
		var/list/zone_markings = prefs.body_markings[zone]
		if(zone_markings)
			for(var/name in zone_markings)
				markings_data += list(list("name" = name, "color" = zone_markings[name]))
		zones_data += list(list(
			"zone" = zone,
			"display_name" = zone_names[zone] || zone,
			"markings" = markings_data,
			"can_add" = !zone_markings || zone_markings.len < MAXIMUM_MARKINGS_PER_LIMB,
		))
	data["zones"] = zones_data
	return data

/datum/body_markings_menu/ui_act(action, list/params, datum/tgui/ui, datum/ui_state/state)
	. = ..()
	if(.)
		return
	var/zone = params["zone"]
	var/name = params["name"]
	switch(action)
		if("add_marking")
			if(!GLOB.body_markings_per_limb[zone])
				return
			var/list/possible_candidates = marking_list_of_zone_for_species(zone, prefs.pref_species)
			if(prefs.body_markings[zone])
				if(prefs.body_markings[zone].len >= MAXIMUM_MARKINGS_PER_LIMB)
					return
				for(var/keyed_name in prefs.body_markings[zone])
					possible_candidates -= keyed_name
			if(!possible_candidates.len)
				return
			var/desired_marking = input(owner, "Choose your new marking to add:", "Character Preference") as null|anything in possible_candidates
			if(!desired_marking)
				return
			var/datum/body_marking/BD = GLOB.body_markings[desired_marking]
			if(!prefs.body_markings[zone])
				prefs.body_markings[zone] = list()
			prefs.body_markings[zone][BD.name] = BD.get_default_color(prefs.features, prefs.pref_species)
			return TRUE
		if("remove_marking")
			if(!prefs.body_markings[zone] || !prefs.body_markings[zone][name])
				return
			prefs.body_markings[zone] -= name
			if(!prefs.body_markings[zone].len)
				prefs.body_markings -= zone
			return TRUE
		if("change_color")
			if(!prefs.body_markings[zone] || !prefs.body_markings[zone][name])
				return
			var/color = prefs.body_markings[zone][name]
			var/new_color = color_pick_sanitized_lumi(owner, "Choose your markings color:", "Character Preference", "#[color]")
			if(new_color)
				if(!prefs.body_markings[zone] || !prefs.body_markings[zone][name])
					return
				prefs.body_markings[zone][name] = sanitize_hexcolor(new_color, include_crunch = FALSE)
			return TRUE
		if("reset_color")
			if(!prefs.body_markings[zone] || !prefs.body_markings[zone][name])
				return
			var/datum/body_marking/BM = GLOB.body_markings[name]
			prefs.body_markings[zone][name] = BM.get_default_color(prefs.features, prefs.pref_species)
			return TRUE
		if("change_marking")
			var/list/possible_candidates = marking_list_of_zone_for_species(zone, prefs.pref_species)
			if(prefs.body_markings[zone])
				for(var/keyed_name in prefs.body_markings[zone])
					possible_candidates -= keyed_name
			if(!possible_candidates.len)
				return
			var/desired_marking = input(owner, "Choose a marking to change the current one to:", "Character Preference") as null|anything in possible_candidates
			if(!desired_marking)
				return
			if(!prefs.body_markings[zone] || !prefs.body_markings[zone][name])
				return
			var/held_index = LAZYFIND(prefs.body_markings[zone], name)
			var/datum/body_marking/BD = GLOB.body_markings[desired_marking]
			var/marking_content = BD.get_default_color(prefs.features, prefs.pref_species)
			prefs.body_markings[zone] -= name
			prefs.body_markings[zone].Insert(held_index, desired_marking)
			prefs.body_markings[zone][desired_marking] = marking_content
			return TRUE
		if("move_up")
			var/list/marking_list = prefs.body_markings[zone]
			var/current_index = LAZYFIND(marking_list, name)
			if(!current_index || --current_index < 1)
				return
			var/marking_content = marking_list[name]
			marking_list -= name
			marking_list.Insert(current_index, name)
			marking_list[name] = marking_content
			return TRUE
		if("move_down")
			var/list/marking_list = prefs.body_markings[zone]
			var/current_index = LAZYFIND(marking_list, name)
			if(!current_index || ++current_index > length(marking_list))
				return
			var/marking_content = marking_list[name]
			marking_list -= name
			marking_list.Insert(current_index, name)
			marking_list[name] = marking_content
			return TRUE