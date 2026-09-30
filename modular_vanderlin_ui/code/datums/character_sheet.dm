/datum/character_sheet
	var/mob/dead/new_player/owner

/datum/character_sheet/New(mob/dead/new_player/owner)
	. = ..()
	src.owner = owner

/datum/character_sheet/Destroy()
	owner = null
	return ..()

/datum/character_sheet/ui_state(mob/user)
	return GLOB.new_player_state

/datum/character_sheet/ui_interact(mob/user, datum/tgui/ui)
	ui = SStgui.try_update_ui(user, src, ui)
	if(!ui)
		ui = new(user, src, "CharacterSheet")
		ui.open()

/datum/character_sheet/ui_data(mob/user)
	var/list/data = list()
	if(!owner)
		return data
	var/client/owner_client = owner.client
	if(!owner_client || !owner_client.prefs)
		return data
	var/datum/preferences/prefs = owner_client.prefs
	data["character_name"] = prefs.read_preference(/datum/preference/text/real_name) || "Unnamed"
	data["pronouns"] = prefs.read_preference(/datum/preference/choiced/pronouns)
	data["age"] = prefs.read_preference(/datum/preference/choiced/age)
	data["voice_type"] = prefs.read_preference(/datum/preference/choiced/voice_type)
	data["accent"] = prefs.read_preference(/datum/preference/choiced/selected_accent)
	data["voice_color"] = "#" + prefs.read_preference(/datum/preference/color/voice_color)
	data["dominant_hand"] = (prefs.read_preference(/datum/preference/choiced/domhand) == 1) ? "Left" : "Right"
	data["nickname_color"] = "#" + prefs.read_preference(/datum/preference/color/nickname_color)
	data["permadeath"] = prefs.read_preference(/datum/preference/toggle/permadeath) ? "ENABLED" : "disabled"
	data["examine_music"] = prefs.read_preference(/datum/preference/choiced/examine_music)
	data["pq"] = get_playerquality(owner.ckey)
	data["triumphs"] = SStriumphs.get_triumphs(owner.ckey)
	data["faith"] = prefs.read_preference(/datum/preference/choiced/faith)
	data["patron"] = prefs.read_preference(/datum/preference/choiced/patron)
	var/loadout1_str = prefs._get_loadout_slot(1)
	var/datum/loadout_item/loadout1_item = loadout1_str ? GLOB.loadout_items[text2path(loadout1_str)] : null
	data["loadout1"] = loadout1_item ? loadout1_item.name : "None"
	var/loadout2_str = prefs._get_loadout_slot(2)
	var/datum/loadout_item/loadout2_item = loadout2_str ? GLOB.loadout_items[text2path(loadout2_str)] : null
	data["loadout2"] = loadout2_item ? loadout2_item.name : "None"
	var/loadout3_str = prefs._get_loadout_slot(3)
	var/datum/loadout_item/loadout3_item = loadout3_str ? GLOB.loadout_items[text2path(loadout3_str)] : null
	data["loadout3"] = loadout3_item ? loadout3_item.name : "None"
	var/datum/species/species_path = prefs.read_preference(/datum/preference/choiced/species)
	data["species"] = species_path ? species_path::name : "Unknown"
	var/datum/culture/culture_path = prefs.read_preference(/datum/preference/choiced/culture)
	data["culture"] = culture_path ? culture_path::name : "Unknown"
	data["skin_tone"] = prefs.read_preference(/datum/preference/choiced/skin_tone)
	data["detail_color"] = "#" + prefs.read_preference(/datum/preference/color/detail_color)
	var/list/bm_count = list()
	for(var/zone in prefs.body_markings)
		bm_count += prefs.body_markings[zone].len
	var/total_markings = 0
	for(var/n in bm_count)
		total_markings += n
	data["markings_count"] = total_markings
	data["family_mode"] = prefs.read_preference(/datum/preference/choiced/family_mode)
	data["gender_pref"] = prefs.read_preference(/datum/preference/choiced/gender_choice)
	data["spouse_pref"] = prefs.read_preference(/datum/preference/text/setspouse) || "None"
	data["ooc_notes"] = prefs.read_preference(/datum/preference/text/ooc_notes) || ""
	var/list/rumors_list = prefs.read_preference(/datum/preference/list_type/rumors)
	data["rumors"] = rumors_list ? rumors_list.Join(", ") : ""
	var/list/gossip_list = prefs.read_preference(/datum/preference/list_type/noble_gossip)
	data["noble_gossip"] = gossip_list ? gossip_list.Join(", ") : ""
	var/list/food_list = prefs.read_preference(/datum/preference/list_type/culinary_preferences)
	data["food_prefs"] = food_list ? food_list.Join(", ") : ""
	data["nsfw_flavor"] = prefs.read_preference(/datum/preference/toggle/nsfw_flavor) ? "ON" : "OFF"
	data["erp_preferences"] = prefs.read_preference(/datum/preference/text/erp_preferences) || ""
	data["headshot_link"] = prefs.read_preference(/datum/preference/text/headshot_link) || ""
	data["nudeshot_link"] = prefs.read_preference(/datum/preference/text/nudeshot_link) || ""
	var/list/gallery_list = prefs.read_preference(/datum/preference/list_type/character_gallery)
	data["gallery_count"] = gallery_list ? length(gallery_list) : 0
	data["gallery_links"] = gallery_list ? gallery_list.Join(", ") : ""
	return data

/datum/character_sheet/ui_act(action, list/params, datum/tgui/ui, datum/ui_state/state)
	. = ..()
	if(.)
		return
	switch(action)
		if("close")
			ui.close()
			return TRUE
		if("edit_field")
			if(!owner)
				return
			var/client/owner_client = owner.client
			if(!owner_client || !owner_client.prefs)
				return
			var/datum/preferences/prefs = owner_client.prefs
			var/pref_key = params["pref_key"]
			var/datum/preference/pref = GLOB.preference_entries_by_key[pref_key]
			if(!pref)
				return
			pref.handle_link(prefs, owner)
			return TRUE
		if("open_job_select")
			if(!owner || !owner.client || !owner.client.prefs)
				return
			owner.client.prefs.open_job_middleware(owner)
			return TRUE
		if("open_antag_prefs")
			if(!owner || !owner.client || !owner.client.prefs)
				return
			var/datum/antag_preferences_menu/antag_menu = new(owner.client.prefs)
			antag_menu.ui_interact(owner)
			return TRUE
		if("open_body_markings")
			if(!owner || !owner.client || !owner.client.prefs)
				return
			var/datum/body_markings_menu/bm_menu = new(owner.client.prefs, owner)
			bm_menu.ui_interact(owner)
			return TRUE