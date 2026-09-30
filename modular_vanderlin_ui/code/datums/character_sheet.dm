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
	return data

/datum/character_sheet/ui_act(action, list/params, datum/tgui/ui, datum/ui_state/state)
	. = ..()
	if(.)
		return
	switch(action)
		if("close")
			ui.close()
			return TRUE