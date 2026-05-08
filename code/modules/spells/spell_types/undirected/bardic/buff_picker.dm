/mob/living/carbon/human/proc/get_selected_instrument_buffs()
	if(inspiration)
		return inspiration.selected_buffs
	// Fallback for TRAIT_BARDIC_TRAINING mobs without inspiration datum
	if(!HAS_TRAIT(src, TRAIT_BARDIC_TRAINING))
		return list()
	if(!selected_instrument_buffs)
		selected_instrument_buffs = list()
	return selected_instrument_buffs

/mob/living/carbon/human/proc/get_max_instrument_buff_slots()
	var/music_level = floor(GET_MOB_SKILL_VALUE_OLD(src, /datum/attribute/skill/misc/music))
	switch(music_level)
		if(1 to 3)
			return 1
		if(4 to 5)
			return 2
		if(6 to INFINITY)
			return 3
	return 1

/datum/buff_picker_ui
	var/mob/living/carbon/human/owner

/datum/buff_picker_ui/New(mob/living/carbon/human/H)
	. = ..()
	owner = H

/datum/buff_picker_ui/Destroy()
	owner = null
	return ..()

/datum/buff_picker_ui/ui_state(mob/user)
	return GLOB.always_state

/datum/buff_picker_ui/ui_interact(mob/user, datum/tgui/ui)
	ui = SStgui.try_update_ui(user, src, ui)
	if(!ui)
		ui = new(user, src, "BardBuffPicker", "Bardic Buffs")
		ui.open()

/datum/buff_picker_ui/ui_data(mob/user)
	var/list/data = list()
	data["buff_slots_max"] = owner.get_max_instrument_buff_slots()

	var/music_level = floor(GET_MOB_SKILL_VALUE_OLD(owner, /datum/attribute/skill/misc/music))
	var/list/available_buffs = list()
	var/list/buff_options = list(
		list("path" = /datum/status_effect/bardicbuff/intelligence, "name" = "Noc's Brilliance", "desc" = "+1 INT", "min_level" = 1),
		list("path" = /datum/status_effect/bardicbuff/endurance, "name" = "Malum's Resilience", "desc" = "+1 END", "min_level" = 2),
		list("path" = /datum/status_effect/bardicbuff/constitution, "name" = "Pestra's Blessing", "desc" = "+1 CON", "min_level" = 3),
		list("path" = /datum/status_effect/bardicbuff/speed, "name" = "Xylix's Alacrity", "desc" = "+1 SPD", "min_level" = 4),
		list("path" = /datum/status_effect/bardicbuff/ravox, "name" = "Ravox's Righteous Fury", "desc" = "+1 STR, +1 PER", "min_level" = 5),
		list("path" = /datum/status_effect/bardicbuff/awaken, "name" = "Astrata's Awakening", "desc" = "+energy, +stamina, +1 FOR", "min_level" = 6),
	)

	var/list/selected = owner.get_selected_instrument_buffs()
	for(var/entry in buff_options)
		if(music_level < entry["min_level"])
			continue
		available_buffs += list(list(
			"path" = "[entry["path"]]",
			"name" = entry["name"],
			"desc" = entry["desc"],
			"selected" = ("[entry["path"]]" in selected),
		))
	data["available_buffs"] = available_buffs
	data["selected_buff_count"] = selected.len
	return data

/datum/buff_picker_ui/ui_act(action, list/params, datum/tgui/ui, datum/ui_state/state)
	if(..())
		return TRUE
	switch(action)
		if("toggle_buff")
			if(!HAS_TRAIT(owner, TRAIT_BARDIC_TRAINING))
				return TRUE
			var/buff_path = text2path(params["path"])
			if(!buff_path)
				return TRUE
			var/list/valid_buffs = list(
				/datum/status_effect/bardicbuff/intelligence,
				/datum/status_effect/bardicbuff/endurance,
				/datum/status_effect/bardicbuff/constitution,
				/datum/status_effect/bardicbuff/speed,
				/datum/status_effect/bardicbuff/ravox,
				/datum/status_effect/bardicbuff/awaken,
			)
			if(!(buff_path in valid_buffs))
				return TRUE
			var/music_level = floor(GET_MOB_SKILL_VALUE_OLD(owner, /datum/attribute/skill/misc/music))
			var/list/min_levels = list(
				/datum/status_effect/bardicbuff/intelligence = 1,
				/datum/status_effect/bardicbuff/endurance = 2,
				/datum/status_effect/bardicbuff/constitution = 3,
				/datum/status_effect/bardicbuff/speed = 4,
				/datum/status_effect/bardicbuff/ravox = 5,
				/datum/status_effect/bardicbuff/awaken = 6,
			)
			if(music_level < min_levels[buff_path])
				return TRUE
			var/list/selected = owner.get_selected_instrument_buffs()
			var/path_str = "[buff_path]"
			if(path_str in selected)
				selected.Remove(path_str)
			else
				if(selected.len >= owner.get_max_instrument_buff_slots())
					return TRUE
				selected += path_str
			return TRUE
