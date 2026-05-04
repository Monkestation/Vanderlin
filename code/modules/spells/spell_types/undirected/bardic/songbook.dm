#define SONGBOOK_UNLEARN_COOLDOWN 2 MINUTES

GLOBAL_LIST_INIT(learnable_songs, list(
	// Buff Melodies
	/datum/action/cooldown/spell/undirected/song/furtive_fortissimo,
	/datum/action/cooldown/spell/undirected/song/resolute_refrain,
	/datum/action/cooldown/spell/undirected/song/intellectual_interval,
	/datum/action/cooldown/spell/undirected/song/fervor_song,
	/datum/action/cooldown/spell/undirected/song/recovery_song,
	/datum/action/cooldown/spell/undirected/song/accelakathist,
	/datum/action/cooldown/spell/undirected/song/rejuvenation_song,
	// Debuff Dirges
	/datum/action/cooldown/spell/undirected/song/discordant_dirge,
	/datum/action/cooldown/spell/undirected/song/enervating_elegy,
	/datum/action/cooldown/spell/undirected/song/rattling_requiem,
))

/mob/living/carbon/human/proc/open_songbook()
	set name = "Songbook"
	set category = "Inspiration"

	if(!mind)
		return

	if(inspiration)
		var/datum/songbook_ui/picker = new(src)
		picker.ui_interact(src)
	else if(HAS_TRAIT(src, TRAIT_BARDIC_TRAINING))
		var/datum/buff_picker_ui/picker = new(src)
		picker.ui_interact(src)

/datum/songbook_ui
	var/mob/living/carbon/human/owner

/datum/songbook_ui/New(mob/living/carbon/human/H)
	. = ..()
	owner = H

/datum/songbook_ui/Destroy()
	owner = null
	return ..()

/datum/songbook_ui/ui_state(mob/user)
	return GLOB.always_state

/datum/songbook_ui/ui_interact(mob/user, datum/tgui/ui)
	ui = SStgui.try_update_ui(user, src, ui)
	if(!ui)
		ui = new(user, src, "BardSongbook", "Songbook")
		ui.open()

/datum/songbook_ui/proc/can_unlearn()
	if(!owner)
		return FALSE
	var/last_unlearn = owner.mob_timers["songbook_unlearn"]
	if(last_unlearn && world.time < last_unlearn + SONGBOOK_UNLEARN_COOLDOWN)
		return FALSE
	return TRUE

/datum/songbook_ui/ui_data(mob/user)
	var/list/data = list()

	// Songs
	var/list/song_list = list()
	for(var/songpath in GLOB.learnable_songs)
		var/datum/action/cooldown/spell/undirected/song/S = songpath
		var/already_known = FALSE
		if(owner?.mind)
			for(var/datum/action/cooldown/spell/undirected/song/known in owner.actions)
				if(known.type == songpath)
					already_known = TRUE
					break
		song_list += list(list(
			"name" = initial(S.name),
			"desc" = initial(S.desc),
			"type_path" = "[songpath]",
			"known" = already_known,
		))
	data["songs"] = song_list
	data["song_slots_remaining"] = owner?.inspiration ? (owner.inspiration.maxsongs - owner.inspiration.songsbought) : 0

	data["has_bardic_training"] = TRUE
	var/music_level = floor(GET_MOB_SKILL_VALUE_OLD(owner, /datum/attribute/skill/misc/music))
	data["buff_slots_max"] = owner.get_max_instrument_buff_slots()

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
	data["selected_buff_count"] = length(selected)

	var/list/rhythm_list = list()
	var/list/available_rhythms = list(
		/datum/action/cooldown/spell/undirected/rhythm/resonating,
		/datum/action/cooldown/spell/undirected/rhythm/concussive,
		/datum/action/cooldown/spell/undirected/rhythm/frigid,
	)
	if(owner?.inspiration?.level >= BARD_T2)
		available_rhythms += /datum/action/cooldown/spell/undirected/rhythm/regenerating

	var/list/existing_rhythm_types = list()
	if(owner?.mind)
		for(var/datum/action/cooldown/spell/undirected/rhythm/existing in owner.actions)
			existing_rhythm_types += existing.type

	for(var/rhythm_path in available_rhythms)
		var/datum/action/cooldown/spell/undirected/rhythm/R = rhythm_path
		rhythm_list += list(list(
			"name" = initial(R.name),
			"desc" = initial(R.desc),
			"type_path" = "[rhythm_path]",
			"known" = (rhythm_path in existing_rhythm_types),
		))

	var/max_picks = owner?.inspiration?.level >= BARD_T2 ? RHYTHM_PICKS_T2 : RHYTHM_PICKS_T1
	data["rhythms"] = rhythm_list
	data["rhythm_slots_remaining"] = max_picks - existing_rhythm_types.len
	data["can_unlearn"] = can_unlearn()
	if(!can_unlearn())
		var/last_unlearn = owner.mob_timers["songbook_unlearn"]
		var/remaining = round((last_unlearn + SONGBOOK_UNLEARN_COOLDOWN - world.time) / 10)
		var/mins = round(remaining / 60)
		var/secs = remaining % 60
		data["unlearn_cooldown_text"] = "On cooldown ([mins]m [secs]s)"
	else
		data["unlearn_cooldown_text"] = ""
	return data

/datum/songbook_ui/ui_act(action, list/params, datum/tgui/ui, datum/ui_state/state)
	if(..())
		return TRUE
	switch(action)
		if("learn_song")
			if(!owner?.mind || !owner.inspiration)
				return TRUE
			if(owner.inspiration.songsbought >= owner.inspiration.maxsongs)
				return TRUE
			var/song_path = text2path(params["type_path"])
			if(!song_path || !(song_path in GLOB.learnable_songs))
				return TRUE
			for(var/datum/action/cooldown/spell/undirected/song/known in owner.actions)
				if(known.type == song_path)
					return TRUE
			var/datum/action/cooldown/spell/undirected/song/new_song = new song_path
			new_song.Grant(owner)
			owner.inspiration.songsbought += 1
			return TRUE

		if("toggle_buff")
			var/buff_path = text2path(params["path"])
			if(!buff_path)
				return TRUE
			// Validate it's a real bardic buff, I don't want any status effect funny business
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
					return TRUE // At cap, silently reject
				selected += path_str
			return TRUE

		if("unlearn_song")
			if(!owner?.mind || !owner.inspiration)
				return TRUE
			if(!can_unlearn())
				to_chat(owner, span_warning("I need more time before I can forget another song."))
				return TRUE
			var/song_path = text2path(params["type_path"])
			if(!song_path || !(song_path in GLOB.learnable_songs))
				return TRUE
			for(var/datum/status_effect/buff/playing_melody/melody in owner.status_effects)
				owner.remove_status_effect(melody)
			for(var/datum/status_effect/buff/playing_dirge/dirge in owner.status_effects)
				owner.remove_status_effect(dirge)
			for(var/datum/action/action_listed in owner.actions)
				if(song_path != action_listed.type)
					continue
				action_listed.Remove(owner)
			owner.inspiration.songsbought = max(0, owner.inspiration.songsbought - 1)
			owner.mob_timers["songbook_unlearn"] = world.time
			to_chat(owner, span_info("I forget the melody..."))
			return TRUE

		if("learn_rhythm")
			if(!owner?.mind || !owner.inspiration)
				return TRUE
			var/rhythm_path = text2path(params["type_path"])
			if(!rhythm_path)
				return TRUE
			var/list/valid = list(
				/datum/action/cooldown/spell/undirected/rhythm/resonating,
				/datum/action/cooldown/spell/undirected/rhythm/concussive,
				/datum/action/cooldown/spell/undirected/rhythm/frigid,
				/datum/action/cooldown/spell/undirected/rhythm/regenerating,
			)
			if(!(rhythm_path in valid))
				return TRUE
			for(var/datum/action/cooldown/spell/undirected/rhythm/existing in owner.actions)
				if(existing.type == rhythm_path)
					return TRUE
			var/max_picks = owner.inspiration.level >= BARD_T2 ? RHYTHM_PICKS_T2 : RHYTHM_PICKS_T1
			var/existing_count = 0
			for(var/datum/action/cooldown/spell/undirected/rhythm/R in owner.actions)
				existing_count++
			if(existing_count >= max_picks)
				return TRUE

			if(!owner.inspiration.rhythm_tracker)
				owner.inspiration.rhythm_tracker = new /datum/rhythm_tracker()

			var/datum/action/cooldown/spell/undirected/rhythm/new_rhythm = new rhythm_path()
			new_rhythm.tracker = owner.inspiration.rhythm_tracker
			new_rhythm.Grant(owner)
			to_chat(owner, span_info("I attune my blade to the [new_rhythm.name] rhythm."))

			// Grant Crescendo to T2 bards after all rhythm picks
			if((existing_count + 1) >= max_picks)
				if(owner.inspiration.level >= BARD_T2 && !owner.inspiration.rhythm_tracker.crescendo_action)
					var/datum/action/cooldown/spell/crescendo/C = new()
					C.tracker = owner.inspiration.rhythm_tracker
					owner.inspiration.rhythm_tracker.crescendo_action = C
					C.Grant(owner)
			return TRUE

		if("unlearn_rhythm")
			if(!owner?.mind || !owner.inspiration)
				return TRUE
			if(!can_unlearn())
				to_chat(owner, span_warning("I need more time before I can forget another rhythm."))
				return TRUE
			var/rhythm_path = text2path(params["type_path"])
			if(!rhythm_path)
				return TRUE
			// Cancel prime if active
			for(var/datum/action/cooldown/spell/undirected/rhythm/R in owner.actions)
				if(R.type == rhythm_path)
					if(R.primed)
						R.rhythm_fizzle()
					R.Remove(owner)
					break
			owner.mob_timers["songbook_unlearn"] = world.time
			var/rhythm_count = 0
			for(var/datum/action/cooldown/spell/undirected/rhythm/R in owner.actions)
				rhythm_count++
			if(rhythm_count == 0 && owner.inspiration.rhythm_tracker)
				if(owner.inspiration.rhythm_tracker.crescendo_action)
					owner.inspiration.rhythm_tracker.crescendo_action.Remove(owner)
					owner.inspiration.rhythm_tracker.crescendo_action = null
				QDEL_NULL(owner.inspiration.rhythm_tracker)
			to_chat(owner, span_info("I forget the rhythm..."))
			return TRUE

#undef SONGBOOK_UNLEARN_COOLDOWN
