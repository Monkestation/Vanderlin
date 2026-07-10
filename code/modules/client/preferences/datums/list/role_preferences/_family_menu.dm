/datum/family_middleware
	/// The human whose prefs we are editing.
	var/mob/living/carbon/human/owner
	/// Shortcut to owner's prefs datum.
	var/datum/preferences/prefs

/datum/family_middleware/New(datum/preference/preferences, mob/user)
	owner = user
	prefs = preferences

/datum/family_middleware/ui_interact(mob/user, datum/tgui/ui)
	ui = SStgui.try_update_ui(user, src, ui)
	if(!ui)
		ui = new /datum/tgui(user, src, "FamilyPrefs", "Family & Bonds")
		ui.open()

/datum/family_middleware/ui_state(mob/user)
	return GLOB.always_state

/datum/family_middleware/ui_data(mob/user)
	if(!prefs)
		return list()

	var/family_mode = prefs.read_preference(/datum/preference/choiced/family_mode) || FAMILY_NONE
	var/setspouse = prefs.read_preference(/datum/preference/text/setspouse) || ""
	var/setchild  = prefs.read_preference(/datum/preference/text/setchild)  || ""
	var/setparent = prefs.read_preference(/datum/preference/text/setparent) || ""
	var/was_divorced = prefs.read_preference(/datum/preference/toggle/was_divorced) || FALSE
	var/gender_pref = prefs.read_preference(/datum/preference/choiced/gender_choice) || ANY_GENDER
	var/same_species = prefs.read_preference(/datum/preference/toggle/same_species_family) || FALSE
	var/wants_adoption = prefs.read_preference(/datum/preference/toggle/wants_adoption) || FALSE
	var/list/acc_species = prefs.read_preference(/datum/preference/list_type/role_setting/picker/accepted_species) || list()
	var/list/acc_faiths = prefs.read_preference(/datum/preference/list_type/role_setting/picker/accepted_patrons) || list()
	var/list/job_filter = prefs.read_preference(/datum/preference/list_type/role_setting/picker/family_job_filler) || list()

	var/list/ui_family_modes = list(
		list("key" = FAMILY_NONE, "label" = "None", "icon" = "ban", "desc" = "No family assignment. You arrive as a stranger."),
		list("key" = FAMILY_PARTIAL, "label" = "Partial", "icon" = "seedling", "desc" = "Join a local house as a child or, if older, as an aunt or uncle."),
		list("key" = FAMILY_NEWLYWED, "label" = "Newlywed", "icon" = "ring", "desc" = "Arrive with a spouse only, no broader house assignment."),
		list("key" = FAMILY_FULL, "label" = "Full", "icon" = "crown", "desc" = "Become a house founder or patriarch/matriarch of an existing house.")
	)

	var/list/ui_gender_prefs = list(
		list("key" = ANY_GENDER, "label" = "Any", "icon" = "genderless"),
		list("key" = SAME_GENDER, "label" = "Same", "icon" = "venus-mars"),
		list("key" = DIFFERENT_GENDER, "label" = "Opposite", "icon" = "transgender")
	)

	var/list/all_species = list()
	for(var/id in GLOB.roundstart_species)
		var/st = GLOB.species_list[id]
		var/datum/species/S = new st()
		if(!S.preference_accessible(prefs))
			continue
		all_species += list(list("name" = S.name, "path" = "[st]"))

	var/list/all_faiths = list()
	for(var/faith_type in GLOB.faith_list)
		var/datum/faith/F = GLOB.faith_list[faith_type]
		all_faiths += list(list("name" = F.name, "path" = "[faith_type]"))

	var/list/all_job_groups = list(
		list("label" = "Noble", "key" = "noble"),
		list("label" = "Garrison", "key" = "garrison"),
		list("label" = "Gallowband", "key" = "gallowband"),
		list("label" = "Church", "key" = "church"),
		list("label" = "Inquisition", "key" = "inquisition"),
		list("label" = "Serf", "key" = "serf"),
		list("label" = "Company", "key" = "company"),
		list("label" = "Peasant", "key" = "peasant"),
		list("label" = "Apprentice", "key" = "apprentice"),
		list("label" = "Wanderer", "key" = "allmig"),
	)


	return list(
		"family_mode" = family_mode,
		"setspouse" = setspouse,
		"setchild"  = setchild,
		"setparent" = setparent,
		"was_divorced" = was_divorced,
		"wants_adoption" = wants_adoption,
		"gender_choice" = gender_pref,
		"same_species_family" = same_species,
		"accepted_species" = acc_species,
		"accepted_patron_faiths" = acc_faiths,
		"family_job_filter" = job_filter,
		"all_species" = all_species,
		"all_faiths" = all_faiths,
		"all_job_groups" = all_job_groups,
		"ui_family_modes" = ui_family_modes,
		"ui_gender_prefs" = ui_gender_prefs
	)

/datum/family_middleware/ui_act(action, params, datum/tgui/ui, datum/ui_state/state)
	. = ..()
	if(.)
		return
	if(!prefs)
		return FALSE

	switch(action)

		if("set_family_mode")
			var/mode = params["mode"]
			if(!(mode in list(FAMILY_NONE, FAMILY_PARTIAL, FAMILY_NEWLYWED, FAMILY_FULL)))
				return FALSE
			prefs.write_preference(/datum/preference/choiced/family_mode, mode)
			return TRUE

		if("edit_setspouse")
			var/new_name = tgui_input_text(
				owner,
				"Enter the exact character name of your designated spouse, or leave blank to clear.",
				"Designated Spouse",
				prefs.read_preference(/datum/preference/text/setspouse),
				MAX_NAME_LEN,
			)
			if(new_name == null)
				return FALSE
			prefs.write_preference(/datum/preference/text/setspouse, length(new_name) ? new_name : "")
			return TRUE

		if("clear_setspouse")
			prefs.write_preference(/datum/preference/text/setspouse, "")
			return TRUE

		if("toggle_divorced")
			var/current = prefs.read_preference(/datum/preference/toggle/was_divorced) || FALSE
			prefs.write_preference(/datum/preference/toggle/was_divorced, !current)
			return TRUE

		if("toggle_adoption")
			var/current = prefs.read_preference(/datum/preference/toggle/wants_adoption) || FALSE
			prefs.write_preference(/datum/preference/toggle/wants_adoption, !current)
			return TRUE

		if("set_gender_choice")
			var/choice = params["choice"]
			if(!(choice in list(ANY_GENDER, SAME_GENDER, DIFFERENT_GENDER)))
				return FALSE

			var/pronoun_pref = prefs.read_preference(/datum/preference/choiced/pronouns)
			if((pronoun_pref == THEY_THEM || pronoun_pref == IT_ITS) && choice != ANY_GENDER)
				to_chat(owner, span_warning("With neutral pronouns, you may only choose [ANY_GENDER]."))
				return FALSE

			prefs.write_preference(/datum/preference/choiced/gender_choice, choice)
			return TRUE

		if("toggle_same_species")
			var/current = prefs.read_preference(/datum/preference/toggle/same_species_family) || FALSE
			prefs.write_preference(/datum/preference/toggle/same_species_family, !current)
			return TRUE

		if("toggle_accepted_species")
			var/path = params["path"]
			if(!path)
				return FALSE
			var/list/current = (prefs.read_preference(/datum/preference/list_type/role_setting/picker/accepted_species) || list())
			if(path in current)
				current -= path
			else
				current += path
			prefs.write_preference(/datum/preference/list_type/role_setting/picker/accepted_species, current)
			return TRUE

		if("toggle_accepted_faith")
			var/path = params["path"]
			if(!path)
				return FALSE
			var/list/current = (prefs.read_preference(/datum/preference/list_type/role_setting/picker/accepted_patrons) || list())
			if(path in current)
				current -= path
			else
				current += path
			prefs.write_preference(/datum/preference/list_type/role_setting/picker/accepted_patrons, current)
			return TRUE

		if("toggle_job_group")
			var/key = params["key"]
			if(!key)
				return FALSE
			var/list/valid_keys = list("noble","garrison","gallowband","church","inquisition","serf","company","peasant","apprentice","allmig","youngfolk")
			if(!(key in valid_keys))
				return FALSE
			var/list/current = (prefs.read_preference( /datum/preference/list_type/role_setting/picker/family_job_filler) || list())
			if(key in current)
				current -= key
			else
				current += key
			prefs.write_preference( /datum/preference/list_type/role_setting/picker/family_job_filler, current)
			return TRUE

		if("clear_all_filters")
			prefs.write_preference(/datum/preference/toggle/same_species_family, FALSE)
			prefs.write_preference(/datum/preference/list_type/role_setting/picker/accepted_species, list())
			prefs.write_preference(/datum/preference/list_type/role_setting/picker/accepted_patrons, list())
			prefs.write_preference(/datum/preference/list_type/role_setting/picker/family_job_filler, list())
			return TRUE

		if("edit_setchild")
			var/new_name = tgui_input_text(
				owner,
				"Enter the exact character name of your designated child, or leave blank to clear.",
				"Designated Child",
				prefs.read_preference(/datum/preference/text/setchild),
				MAX_NAME_LEN,
			)
			if(new_name == null)
				return FALSE
			prefs.write_preference(/datum/preference/text/setchild, length(new_name) ? new_name : "")
			return TRUE

		if("clear_setchild")
			prefs.write_preference(/datum/preference/text/setchild, "")
			return TRUE
		if("edit_setparent")
			var/new_name = tgui_input_text(
				owner,
				"Enter the exact character name of your designated parent, or leave blank to clear.",
				"Designated Parent",
				prefs.read_preference(/datum/preference/text/setparent),
				MAX_NAME_LEN,
			)
			if(new_name == null)
				return FALSE
			prefs.write_preference(/datum/preference/text/setparent, length(new_name) ? new_name : "")
			return TRUE

		if("clear_setparent")
			prefs.write_preference(/datum/preference/text/setparent, "")
			return TRUE

	return FALSE
