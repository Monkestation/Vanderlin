/datum/character_sheet
	var/mob/dead/new_player/owner
	var/preview_dir = SOUTH

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

/datum/character_sheet/proc/render_preview(datum/preferences/prefs)
	var/mob/living/carbon/human/dummy/mannequin = generate_or_wait_for_human_dummy("vanderlin_ui_preview")
	prefs.apply_prefs_to(mannequin, TRUE)
	mannequin.dir = preview_dir
	var/result = icon2base64(getFlatIcon(mannequin))
	unset_busy_human_dummy("vanderlin_ui_preview")
	return result

/datum/character_sheet/ui_data(mob/user)
	var/list/data = list()
	if(!owner)
		return data
	var/client/owner_client = owner.client
	if(!owner_client || !owner_client.prefs)
		return data
	var/datum/preferences/prefs = owner_client.prefs
	data["preview_image"] = render_preview(prefs)
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
	data["quirks_count"] = length(prefs.quirks)
	data["pq"] = get_playerquality(owner.ckey)
	data["triumphs"] = SStriumphs.get_triumphs(owner.ckey)
	var/patron_value = prefs.read_preference(/datum/preference/choiced/patron)
	var/datum/patron/faith_patron
	if(istype(patron_value, /datum/patron))
		faith_patron = patron_value
	else if(ispath(patron_value, /datum/patron))
		faith_patron = GLOB.patron_list[patron_value]
	var/datum/faith/selected_faith = GLOB.faith_list[faith_patron?.associated_faith] || GLOB.faith_list[/datum/patron/divine/astrata::associated_faith]
	data["faith"] = selected_faith ? replacetext(replacetext("\The [selected_faith.name]", "\proper", ""), "\improper", "") : "Unknown"
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
	var/list/skin_assoc = prefs.pref_species?.get_skin_list()
	var/skin_value = prefs.read_preference(/datum/preference/choiced/skin_tone)
	var/skin_name = skin_assoc ? find_key_by_value(skin_assoc, skin_value) : null
	data["skin_tone_name"] = skin_name || "Custom"
	data["skin_tone_wording"] = prefs.pref_species?.skin_tone_wording || "Skin tone"
	var/list/skin_options = list()
	for(var/skin_key in skin_assoc)
		var/skin_hex = "[skin_assoc[skin_key]]"
		if(copytext(skin_hex, 1, 2) != "#")
			skin_hex = "#" + skin_hex
		skin_options += list(list("name" = skin_key, "color" = skin_hex))
	data["skin_options"] = skin_options
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
	data["ooc_extra_link"] = prefs.read_preference(/datum/preference/text/ooc_extra_link) || ""
	data["flavortext"] = prefs.read_preference(/datum/preference/text/flavortext) || ""
	var/list/rumors_list = prefs.read_preference(/datum/preference/list_type/rumors)
	data["rumors_count"] = rumors_list ? length(rumors_list) : 0
	var/list/gossip_list = prefs.read_preference(/datum/preference/list_type/noble_gossip)
	data["gossip_count"] = gossip_list ? length(gossip_list) : 0
	var/list/culinary = prefs.read_preference(/datum/preference/list_type/culinary_preferences)
	if(culinary)
		var/obj/item/reagent_containers/food/snacks/fav_food_ref = culinary[CULINARY_FAVOURITE_FOOD]
		data["favourite_food"] = fav_food_ref ? fav_food_ref::name : "None"
		var/datum/reagent/fav_drink_ref = culinary[CULINARY_FAVOURITE_DRINK]
		data["favourite_drink"] = fav_drink_ref ? fav_drink_ref::name : "None"
	else
		data["favourite_food"] = "None"
		data["favourite_drink"] = "None"
	data["nsfw_flavor"] = prefs.read_preference(/datum/preference/toggle/nsfw_flavor) ? "ON" : "OFF"
	data["erp_preferences"] = prefs.read_preference(/datum/preference/text/erp_preferences) || ""
	data["headshot_link"] = prefs.read_preference(/datum/preference/text/headshot_link) || ""
	data["nudeshot_link"] = prefs.read_preference(/datum/preference/text/nudeshot_link) || ""
	var/list/gallery_list = prefs.read_preference(/datum/preference/list_type/character_gallery)
	data["gallery_count"] = gallery_list ? length(gallery_list) : 0
	data["gallery_links"] = gallery_list ? gallery_list.Join(", ") : ""
	var/list/nsfw_gallery_list = prefs.read_preference(/datum/preference/list_type/nsfw_character_gallery)
	data["nsfw_gallery_count"] = nsfw_gallery_list ? length(nsfw_gallery_list) : 0
	data["nsfw_gallery_links"] = nsfw_gallery_list ? nsfw_gallery_list.Join(", ") : ""
	return data

/datum/character_sheet/ui_act(action, list/params, datum/tgui/ui, datum/ui_state/state)
	. = ..()
	if(.)
		return
	switch(action)
		if("close")
			ui.close()
			return TRUE
		if("change_character")
			if(!owner || !owner.client || !owner.client.prefs)
				return
			var/datum/preferences/prefs = owner.client.prefs
			prefs.write_preference(/datum/preference/choiced/selected_accent, ACCENT_DEFAULT)
			var/list/choices = list()
			if(prefs.path)
				var/savefile/S = new /savefile(prefs.path)
				if(S)
					for(var/i = 1, i <= prefs.max_save_slots, i++)
						var/slot_name
						S.cd = "/character[i]"
						S["real_name"] >> slot_name
						if(!slot_name)
							slot_name = "Slot[i]"
						choices[slot_name] = i
			var/choice = browser_input_list(owner, "WHO IS YOUR HERO?", "NECRA AWAITS", choices, prefs.read_preference(/datum/preference/text/real_name))
			if(choice)
				choice = choices[choice]
				if(!prefs.load_character(choice))
					prefs.randomise_appearance_prefs()
					prefs.save_character()
			return TRUE
		if("open_customizers")
			if(!owner || !owner.client || !owner.client.prefs)
				return
			owner.client.prefs.ShowCustomizers(owner)
			return TRUE
		if("open_examine")
			var/datum/character_examine/examine_view = new /datum/character_examine(src)
			examine_view.ui_interact(usr)
			return TRUE
		if("open_descriptors")
			if(!owner || !owner.client || !owner.client.prefs)
				return
			owner.client.prefs.show_descriptors_ui(owner)
			return TRUE
		if("save_character")
			if(!owner || !owner.client || !owner.client.prefs)
				return
			owner.client.prefs.save_character()
			to_chat(owner, span_notice("Character saved."))
			return TRUE
		if("cancel_changes")
			if(!owner || !owner.client || !owner.client.prefs)
				return
			owner.client.prefs.load_character(owner.client.prefs.default_slot)
			to_chat(owner, span_notice("Changes discarded."))
			return TRUE
		if("rotate_preview")
			var/list/cycle = list(SOUTH, EAST, NORTH, WEST)
			var/current_index = cycle.Find(preview_dir)
			if(!current_index)
				current_index = 1
			if(params["way"] == "left")
				current_index--
				if(current_index < 1)
					current_index = length(cycle)
			else
				current_index++
				if(current_index > length(cycle))
					current_index = 1
			preview_dir = cycle[current_index]
			return TRUE
		if("set_skin_tone")
			if(!owner || !owner.client || !owner.client.prefs)
				return
			var/datum/preferences/prefs = owner.client.prefs
			var/list/skin_assoc = prefs.pref_species?.get_skin_list()
			var/chosen_skin = params["name"]
			if(!skin_assoc || !(chosen_skin in skin_assoc))
				return
			prefs.write_preference(/datum/preference/choiced/skin_tone, skin_assoc[chosen_skin])
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
		if("open_quirks")
			if(!owner || !owner.client || !owner.client.prefs)
				return
			var/datum/quirk_menu/qm = new(owner.client.prefs)
			qm.ui_interact(owner)
			return TRUE
		if("open_culinary")
			if(!owner || !owner.client || !owner.client.prefs)
				return
			var/datum/culinary_menu/cm = new(owner.client.prefs, owner)
			cm.ui_interact(owner)
			return TRUE
		if("open_rumors")
			if(!owner || !owner.client || !owner.client.prefs)
				return
			var/datum/text_list_menu/tlm = new(owner.client.prefs, owner, /datum/preference/list_type/rumors, MAX_RUMORS, MAX_GOSSIP_LENGTH, "Rumors")
			tlm.ui_interact(owner)
			return TRUE
		if("open_gossip")
			if(!owner || !owner.client || !owner.client.prefs)
				return
			var/datum/text_list_menu/tlm = new(owner.client.prefs, owner, /datum/preference/list_type/noble_gossip, MAX_NOBLE_GOSSIP, MAX_GOSSIP_LENGTH, "Noble Gossip")
			tlm.ui_interact(owner)
			return TRUE