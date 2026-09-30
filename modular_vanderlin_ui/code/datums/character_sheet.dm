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
	data["pq"] = get_playerquality(owner.ckey)
	data["faith"] = prefs.read_preference(/datum/preference/choiced/faith)
	data["patron"] = prefs.read_preference(/datum/preference/choiced/patron)
	var/datum/species/species_path = prefs.read_preference(/datum/preference/choiced/species)
	data["species"] = species_path ? species_path::name : "Unknown"
	var/datum/culture/culture_path = prefs.read_preference(/datum/preference/choiced/culture)
	data["culture"] = culture_path ? culture_path::name : "Unknown"
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