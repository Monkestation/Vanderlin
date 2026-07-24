/datum/preferences/proc/open_job_middleware(mob/user)
	var/datum/job_middleware/menu = new(src)
	menu.ui_interact(user)

/// Returns lock info for a job as plain data, or FALSE if not locked.
/// list("code" = short identifier, "label" = short display label, "detail" = list of plain-text lines)
/datum/preferences/proc/get_job_lock_data(datum/job/job, mob/user)
	var/player_species = user.client.prefs.pref_species.id_override || user.client.prefs.pref_species.id
	var/fails_allowed = length(job.allowed_races) && !job.prefs_species_check(src)
	var/fails_blacklist = length(job.blacklisted_species) && (player_species in job.blacklisted_species)

	if(length(job.whitelisted_ckeys) && !(user.ckey in job.whitelisted_ckeys))
		return list(
			"code" = "EVENT_WHITELIST",
			"label" = "EVENT WHITELISTED",
			"detail" = list("This role has been whitelisted by staff for event purposes."),
		)

	if(job.job_flags & JOB_REQUIRE_WHITELIST && !user.client?.is_whitelisted(initial(job.title)))
		return list(
			"code" = "WHITELIST",
			"label" = "WHITELISTED",
			"detail" = list("This role has been whitelisted."),
		)

	if(job.required_playtime_remaining(user.client))
		var/list/lines = list()
		for(var/t in job.exp_requirements)
			var/needed = job.exp_requirements[t]
			var/have = user.client.calc_exp_type(t)
			lines += "[t]: [get_exp_format(have)] / [get_exp_format(needed)]"
		return list(
			"code" = "TIME_LOCK",
			"label" = "TIME LOCK",
			"detail" = lines,
		)

	if(fails_allowed || fails_blacklist)
		if(!user.client.has_triumph_buy(TRIUMPH_BUY_RACE_ALL))
			var/list/allowed_races = job.allowed_races.Copy()
			for(var/blacklist in job.blacklisted_species)
				allowed_races -= blacklist
			return list(
				"code" = "SPECIES_LOCK",
				"label" = "SPECIES LOCK",
				"detail" = list("Species Needed: [jointext(allowed_races, ", ")]"),
			)

	if(length(job.allowed_ages) && !(user.client.prefs.read_preference(/datum/preference/choiced/age) in job.allowed_ages))
		return list(
			"code" = "AGE_LOCK",
			"label" = "AGE LOCK",
			"detail" = list("Ages Needed: [jointext(job.allowed_ages, ", ")]"),
		)

	if(length(job.allowed_sexes) && !(user.client.prefs.read_preference(/datum/preference/choiced/gender) in job.allowed_sexes))
		return list(
			"code" = "SEX_LOCK",
			"label" = "SEX LOCK",
			"detail" = list("Sexes Needed: [jointext(job.allowed_sexes, ", ")]"),
		)

	var/datum/patron/patron = user.client.prefs.read_preference(/datum/preference/choiced/patron)
	if(length(job.allowed_patrons) && !(patron.type in job.allowed_patrons))
		var/list/patron_list = list()
		for(var/datum/patron/mult_patron as anything in job.allowed_patrons)
			patron_list += mult_patron::display_name || mult_patron::name
		return list(
			"code" = "PATRON_LOCK",
			"label" = "PATRON LOCK",
			"detail" = list("Patron Needed: [jointext(patron_list, ", ")]"),
		)

	if(length(job.banned_patrons) && (patron.type in job.banned_patrons))
		var/list/patron_list = list()
		for(var/mult_patron in job.banned_patrons)
			var/datum/patron/P = new mult_patron
			patron_list += (P.display_name ? P.display_name : P.name)
			qdel(P)
		return list(
			"code" = "PATRON_BAN",
			"label" = "PATRON BAN",
			"detail" = list("Patrons Banned: [jointext(patron_list, ", ")]"),
		)

	return FALSE

/// Single source of truth for "what name do we show for this job right now",
/// used by both the tgui menu and anywhere else that needs it (e.g. after_spawn/get_informed_title callers)
/datum/preferences/proc/get_job_display_name(datum/job/job)
	return (read_preference(/datum/preference/choiced/pronouns) == SHE_HER && job.f_title) ? job.f_title : job.title

/datum/preferences/proc/set_job_pref_level(job_title, new_level)
	if(isnull(new_level))
		job_preferences -= job_title
		return TRUE
	if(new_level == JP_HIGH)
		for(var/j in job_preferences)
			if(job_preferences[j] == JP_HIGH)
				job_preferences[j] = JP_MEDIUM
	job_preferences[job_title] = new_level
	return TRUE

/datum/preferences/proc/get_valid_alt_values(datum/job/job, category, mob/user)
	var/is_female = (read_preference(/datum/preference/choiced/pronouns) == SHE_HER)
	var/list/raw_list
	var/base_value

	switch(category)
		if("title")
			base_value = (is_female && job.f_title) ? job.f_title : job.title
			raw_list = list(base_value) + ((is_female && job.unique_alt_titles)? (job.alt_titles_female || list()) : (job.alt_titles || list()))
		if("honorary")
			base_value = (is_female && job.honorary_f) ? job.honorary_f : (job.honorary || "")
			raw_list = list(base_value) + ((is_female && job.unique_alt_honororary) ? (job.alt_honorary_female || list()) : (job.alt_honorary || list()))
		else
			return list()

	var/list/resolved = list()
	var/client/C = user?.client
	for(var/entry in raw_list)
		if(ispath(entry, /datum/alt_title))
			var/datum/alt_title/AT = get_alt_title_instance(entry)
			var/unlocked = AT.is_unlocked_for(C)
			resolved += list(list(
				"value" = AT.get_title(is_female),
				"locked" = !unlocked,
				"reason" = unlocked ? null : AT.get_lock_reason(),
			))
		else
			resolved += list(list("value" = entry, "locked" = FALSE))
	return resolved

/datum/preferences/proc/is_allowed_alt_job_value(job_title, category, value, mob/user)
	var/datum/job/job = SSjob.name_occupations[job_title]
	if(!job)
		return FALSE
	for(var/list/entry in get_valid_alt_values(job, category, user))
		if(entry["value"] == value)
			return !entry["locked"] // reject picking a value that's shown-but-locked
	return FALSE

/datum/preferences/proc/set_job_pref(list/params, mob/user)
	var/job_title = params["job"]
	var/category = params["category"]
	var/value = params["value"]
	if(!is_allowed_alt_job_value(job_title, category, value, user))
		return FALSE

	var/datum/job/job = SSjob.name_occupations[job_title]
	var/list/valid = get_valid_alt_values(job, category, user)
	var/default_value = valid[1]["value"] // first entry is always the "base" choice

	if(!(job_title in alt_job_selections))
		LAZYADD(alt_job_selections, job_title)
		alt_job_selections[job_title] = list()
	var/list/job_sel = alt_job_selections[job_title]

	if(value == default_value)
		job_sel -= category
	else
		job_sel[category] = value

	if(!length(job_sel))
		alt_job_selections -= job_title
	return TRUE
/datum/job_middleware
	var/datum/preferences/prefs

/datum/job_middleware/New(datum/preferences/prefs)
	src.prefs = prefs

/datum/job_middleware/Destroy()
	prefs = null
	return ..()

/datum/job_middleware/ui_state(mob/user)
	return GLOB.always_state

/datum/job_middleware/ui_status(mob/user, datum/ui_state/state)
	if(!prefs || !SSjob)
		return UI_CLOSE
	return ..()

/datum/job_middleware/ui_interact(mob/user, datum/tgui/ui)
	ui = SStgui.try_update_ui(user, src, ui)
	if(!ui)
		ui = new(user, src, "JobPreferences", "Class Selection")
		ui.open()

/datum/job_middleware/ui_close(mob/user)
	qdel(src)

/datum/job_middleware/ui_static_data(mob/user)
	var/list/data = list()

	var/list/omegalist = list(
		list("name" = "Nobles", "jobs" = GLOB.noble_courthand_positions),
		list("name" = "Garrison", "jobs" = GLOB.garrison_positions),
		list("name" = "Gallowband", "jobs" = GLOB.gallowband_positions),
		list("name" = "Churchmen", "jobs" = GLOB.church_positions),
		list("name" = "Peasantry", "jobs" = GLOB.peasant_positions),
		list("name" = "Apprentices", "jobs" = GLOB.apprentices_positions),
		list("name" = "Yeomanry", "jobs" = GLOB.serf_positions),
		list("name" = "Company", "jobs" = GLOB.company_positions),
		list("name" = "Young Folk", "jobs" = GLOB.youngfolk_positions),
		list("name" = "Outsiders", "jobs" = GLOB.allmig_positions),
		list("name" = "Inquisition", "jobs" = GLOB.inquisition_positions),
	)

	var/list/categories = list()
	for(var/list/cat in omegalist)
		var/list/job_titles = cat["jobs"]
		if(!length(job_titles) || !SSjob.name_occupations[job_titles[1]])
			continue

		var/list/job_entries = list()
		for(var/job_title in job_titles)
			var/datum/job/job = SSjob.name_occupations[job_title]
			if(!job)
				continue
			if(!job.total_positions && !job.spawn_positions)
				continue
			if(!job.enabled)
				continue
			if(job.spawn_positions <= 0)
				continue

			var/list/entry = list(
				"title" = job.title,
				"tutorial" = job.tutorial,
				"slots" = job.get_total_positions(),
				"title_choices" = prefs.get_valid_alt_values(job, "title", user),
				"honorary_choices" = prefs.get_valid_alt_values(job, "honorary", user)
			)
			job_entries += list(entry)

		if(!length(job_entries))
			continue

		var/datum/job/first_job = SSjob.name_occupations[job_titles[1]]
		categories += list(list(
			"name" = cat["name"],
			"color" = first_job.selection_color,
			"jobs" = job_entries,
		))

	data["categories"] = categories
	return data

/datum/job_middleware/ui_data(mob/user)
	var/list/data = list()

	data["jobless_role"] = prefs.read_preference(/datum/preference/choiced/joblessrole)
	data["last_class"] = prefs.lastclass

	data["race_banned"] = is_race_banned(user.ckey, prefs.pref_species.id)
	if(data["race_banned"])
		data["race_banned_name"] = prefs.pref_species.id
		return data

	var/list/job_states = list()
	for(var/job_title in SSjob.name_occupations)
		var/datum/job/job = SSjob.name_occupations[job_title]
		if(!job)
			continue

		var/list/entry = list()
		entry["display_name"] = prefs.get_job_display_name(job)
		entry["pref_level"] = prefs.job_preferences[job.title]

		if(is_role_banned(user.ckey, job.title))
			entry["status"] = "banned"
			job_states[job.title] = entry
			continue

		var/days_left = job.available_in_days(user.client)
		if(days_left > 0)
			entry["status"] = "locked"
			entry["lock_label"] = "TIME LOCK"
			entry["lock_detail"] = list("Available in [days_left] day\s")
			job_states[job.title] = entry
			continue

		var/list/lock_data = prefs.get_job_lock_data(job, user)
		if(lock_data)
			entry["status"] = "locked"
			entry["lock_code"] = lock_data["code"]
			entry["lock_label"] = lock_data["label"]
			entry["lock_detail"] = lock_data["detail"]
			job_states[job.title] = entry
			continue

		entry["status"] = "available"

		var/list/current_sel
		if(job.title in prefs.alt_job_selections)
			current_sel = prefs.alt_job_selections[job.title]
		entry["current_title"] = (current_sel && current_sel["title"]) || entry["display_name"]

		var/list/honorary_choices = prefs.get_valid_alt_values(job, "honorary", user)
		entry["current_honorary"] = (current_sel && current_sel["honorary"]) || (length(honorary_choices) ? honorary_choices[1]["value"] : "")

		job_states[job.title] = entry

	data["job_states"] = job_states
	return data

/datum/job_middleware/ui_act(action, list/params)
	. = ..()
	if(.)
		return

	var/mob/user = usr

	switch(action)
		if("set_pref_level")
			if(SSticker.job_change_locked)
				return
			var/job_title = params["job"]
			var/label = params["level"]
			prefs.set_job_pref_level(job_title, label)
			prefs.update_menu_data(user)
			. = TRUE

		if("set_job_pref")
			if(SSticker.job_change_locked)
				return
			prefs.set_job_pref(params, user)
			prefs.update_menu_data(user)
			. = TRUE

		if("toggle_jobless")
			switch(prefs.read_preference(/datum/preference/choiced/joblessrole))
				if(RETURNTOLOBBY)
					prefs.write_preference(/datum/preference/choiced/joblessrole, BERANDOMJOB)
				if(BERANDOMJOB)
					prefs.write_preference(/datum/preference/choiced/joblessrole, RETURNTOLOBBY)
			. = TRUE

		if("reset")
			prefs.reset_jobs(user, TRUE)
			prefs.update_menu_data(user)
			. = TRUE

		if("play_last_class")
			prefs.reset_last_class(user)
			prefs.update_menu_data(user)
			. = TRUE

		if("open_role_settings")
			var/datum/role_settings_menu/menu = new(prefs)
			menu.ui_interact(user)
			. = TRUE
