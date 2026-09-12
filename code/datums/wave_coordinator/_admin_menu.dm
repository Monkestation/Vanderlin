/datum/tgui_wave_creator
	/// Unique set ID used for all spawned landmarks and wave lookup
	var/set_id = "default"
	/// Assoc: mob typepath -> count
	var/list/mob_counts = list()

/datum/tgui_wave_creator/ui_state(mob/user)
	return GLOB.always_state

/datum/tgui_wave_creator/ui_static_data(mob/user)
	var/list/subtypes_out = list()
	for(var/path in subtypesof(/mob/living))
		if(path == /mob/living)
			continue
		subtypes_out += list(list("path" = "[path]", "name" = initial(path:name)))

	return list("living_subtypes" = subtypes_out)

/datum/tgui_wave_creator/ui_data(mob/user)
	var/list/matching = list()
	for(var/obj/effect/landmark/wave_defense/landmark in GLOB.wave_defense_landmarks)
		if(landmark.set_id == set_id)
			matching += landmark
	sortTim(matching, GLOBAL_PROC_REF(cmp_wave_landmark_order))

	var/list/wp_list = list()
	for(var/obj/effect/landmark/wave_defense/landmark as anything in matching)
		wp_list += list(list(
			"ref" = REF(landmark),
			"order" = landmark.order,
			"name" = landmark.name,
		))

	var/list/entries_out = list()
	for(var/path in mob_counts)
		if(mob_counts[path] > 0)
			entries_out += list(list(
				"path" = path,
				"name" = initial(text2path(path):name),
				"count" = mob_counts[path],
			))

	return list(
		"set_id" = set_id,
		"waypoints" = wp_list,
		"mob_entries" = entries_out,
	)

/datum/tgui_wave_creator/ui_act(action, list/params, datum/tgui/ui, datum/ui_state/state)
	. = ..()
	if(.)
		return

	var/mob/user = ui.user

	switch(action)
		if("set_set_id")
			var/new_id = sanitize(params["set_id"])
			if(length(new_id))
				set_id = new_id
			. = TRUE

		if("add_waypoint")
			var/obj/effect/landmark/wave_defense/wp = new(get_turf(user))
			wp.set_id = set_id
			var/highest = 0
			for(var/obj/effect/landmark/wave_defense/existing in GLOB.wave_defense_landmarks)
				if(existing.set_id == set_id && existing.order > highest)
					highest = existing.order
			wp.order = highest + 1
			. = TRUE

		if("remove_waypoint")
			var/obj/effect/landmark/wave_defense/wp = locate(params["ref"])
			if(wp && wp.set_id == set_id)
				qdel(wp)
			. = TRUE

		if("set_mob_count")
			var/path = params["path"]
			var/count = clamp(round(params["count"]), 0, 50)
			if(!ispath(text2path(path), /mob/living))
				return FALSE
			if(count == 0)
				mob_counts.Remove(path)
			else
				mob_counts[path] = count
			. = TRUE

		if("launch_wave")
			spawn_wave(user)
			. = TRUE

/datum/tgui_wave_creator/proc/spawn_wave(mob/admin)
	var/list/points = get_wave_defense_points(set_id)
	if(!length(points))
		to_chat(admin, span_warning("No wave defense landmarks found for set '[set_id]'."))
		return
	var/list/mob/living/wave_mobs = list()
	for(var/path in mob_counts)
		var/count = mob_counts[path]
		var/mobtype = text2path(path)
		if(!ispath(mobtype, /mob/living))
			continue
		for(var/i in 1 to count)
			var/mob/living/m = new mobtype(get_turf(admin))
			wave_mobs += m
	if(!length(wave_mobs))
		to_chat(admin, span_warning("No mobs configured, wave not launched."))
		return
	new /datum/wave_defense_coordinator(
		set_id,
		wave_mobs,
		on_complete = CALLBACK(src, PROC_REF(on_wave_complete), admin),
		on_failed = CALLBACK(src, PROC_REF(on_wave_failed), admin),
	)
	to_chat(admin, span_notice("Wave launched: [length(wave_mobs)] mob(s), [length(points)] waypoint(s)."))
	message_admins("[key_name(admin)] launched a wave ([set_id]) with [length(wave_mobs)] mobs.")

/datum/tgui_wave_creator/proc/on_wave_complete(datum/wave_defense_coordinator/c, mob/admin)
	message_admins("Wave spawned by [admin] completed.")

/datum/tgui_wave_creator/proc/on_wave_failed(datum/wave_defense_coordinator/c, mob/admin)
	message_admins("Wave spawned by [admin] failed.")

/client/proc/open_wave_creator()
	set name = "Open Wave Creator"
	set category = "GameMaster.Fun"
	if(!check_rights(R_ADMIN))
		return
	var/datum/tgui_wave_creator/creator = new
	creator.ui_interact(mob)

/datum/tgui_wave_creator/ui_interact(mob/user, datum/tgui/ui)
	ui = SStgui.try_update_ui(user, src, ui)
	if(!ui)
		ui = new /datum/tgui(user, src, "WaveCreator", "Wave Creator")
		ui.open()
