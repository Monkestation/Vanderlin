/datum/admin_ticket_granter
	var/client/admin_client
	var/prefill_ckey

/datum/admin_ticket_granter/New(client/C, prefill_ckey)
	admin_client = C
	src.prefill_ckey = prefill_ckey

/datum/admin_ticket_granter/ui_interact(mob/user, datum/tgui/ui)
	ui = SStgui.try_update_ui(user, src, ui)
	if(!ui)
		ui = new /datum/tgui(user, src, "AdminTicketGranter", "Admin Ticket Granter")
		ui.open()

/datum/admin_ticket_granter/ui_state(mob/user)
	return ADMIN_STATE(R_VAREDIT)

/datum/admin_ticket_granter/ui_data(mob/user) //this is kinda weird, but I couldn't think of a way to do this that was "clean" for each subtype, maybe move this to the ticket datum itself?
	var/list/type_schemas = list(
		list(
			"ticket_type"= TICKET_TYPE_LOADOUT,
			"label"= "Loadout Item",
			"fa_icon"= "box-open",
			"color"= "#2196f3",
			"fields" = list(
				list("key" = "loadout_item_path", "label" = "Loadout Item Path",
				 "type" = "typepath","base" = "/datum/loadout_item",
				 "placeholder" = "/datum/loadout_item/...",
				 "required" = TRUE),
			),
		),
		list(
			"ticket_type"= TICKET_TYPE_SPECIAL,
			"label"= "Special Trait",
			"fa_icon"= "dice",
			"color"= "#9c27b0",
			"fields" = list(
				list("key" = "special_trait_path", "label" = "Special Trait Path",
				 "type" = "typepath","base" = "/datum/special_trait",
				 "placeholder" = "/datum/special_trait/...",
				 "required" = TRUE),
			),
		),
		list(
			"ticket_type"= TICKET_TYPE_JOB_BOOST,
			"label"= "Job Boost",
			"fa_icon"= "briefcase",
			"color"= "#ff9800",
			"fields" = list(
				list("key" = "job_boost_job","label" = "Job / Whitelist (blank = global)",
				 "type" = "text",
				 "placeholder" = "e.g. Artificer, or leave blank"),
				list("key" = "job_boost_typepath", "label" = "Boost Type Path",
				 "type" = "typepath","base" = "/datum/job_priority_boost",
				 "placeholder" = "/datum/job_priority_boost/minor",
				 "required" = TRUE),
			),
		),
		list(
			"ticket_type"= TICKET_TYPE_TRIUMPH,
			"label"= "Triumphs",
			"fa_icon"= "trophy",
			"color"= "#ffd700",
			"fields" = list(
				list("key" = "triumph_amount", "label" = "Amount",
				 "type" = "number", "min" = 1,
				 "placeholder" = "e.g. 100",
				 "required" = TRUE),
			),
		),
		//here is how we do stuff
		// list(
		// "ticket_type" = TICKET_TYPE_WHATEVER,
		// "label" = "Whatever",
		// "fa_icon" = "star",
		// "color" = "#e91e63",
		// "fields"= list(
		// list("key" = "whatever_field", "label" = "Field Label",
		//"type" = "text", "required" = TRUE),
		// ),
		// ),
	)

	// Resolve all child typepaths so the UI can show a dropdown.
	// We send them keyed by base path string.
	var/list/typepath_options = list()
	typepath_options["/datum/loadout_item"] = _collect_subtypes(/datum/loadout_item)
	typepath_options["/datum/special_trait"]= _collect_subtypes(/datum/special_trait)
	typepath_options["/datum/job_priority_boost"] = _collect_subtypes(/datum/job_priority_boost)

	return list(
		"type_schemas" = type_schemas,
		"typepath_options" = typepath_options,
		"templates" = collect_templates(),
		"prefill_ckey" = prefill_ckey,
	)

/datum/admin_ticket_granter/proc/_collect_subtypes(base)
	var/list/out = list()
	for(var/path in subtypesof(base))
		var/datum/D = path
		if(initial(D.abstract_type) == path)
			continue
		out += "[path]"
	return out

/datum/admin_ticket_granter/ui_act(action, list/params, datum/tgui/ui, datum/ui_state/state)
	. = ..()
	if(.)
		return

	switch(action)
		if("grant_ticket")
			handle_grant(params, ui.user)
			return TRUE

/datum/admin_ticket_granter/proc/handle_grant(list/params, mob/admin_mob)
	var/target_ckey = trim(params["target_ckey"])
	var/ticket_type = params["ticket_type"]
	var/t_name = trim(params["name"])
	var/t_desc = trim(params["description"])
	var/grant_reason = trim(params["grant_reason"])

	if(!target_ckey || !ticket_type || !t_name)
		to_chat(admin_mob, span_warning("TICKETS: Missing required fields (ckey, type, name)."))
		return

	var/subtype = ticket_type_to_path(ticket_type)
	var/datum/ticket/t = new subtype()
	t.ticket_id = generate_ticket_id()
	t.name = t_name
	t.description = t_desc
	t.granted_by = admin_mob.ckey
	t.granted_at = time2text(world.realtime, "YYYY-MM-DD hh:mm:ss")
	t.grant_reason = grant_reason

	switch(ticket_type)
		if(TICKET_TYPE_LOADOUT)
			var/datum/ticket/loadout/lt = t
			lt.loadout_item_path = params["loadout_item_path"] ? text2path(params["loadout_item_path"]) : null
		if(TICKET_TYPE_SPECIAL)
			var/datum/ticket/special/st = t
			st.special_trait_path = params["special_trait_path"] ? text2path(params["special_trait_path"]) : null
		if(TICKET_TYPE_JOB_BOOST)
			var/datum/ticket/job_boost/jt = t
			jt.job_boost_job = params["job_boost_job"] || null
			jt.boost_typepath = params["job_boost_typepath"] ? text2path(params["job_boost_typepath"]) : /datum/job_priority_boost/minor
		if(TICKET_TYPE_TRIUMPH)
			var/datum/ticket/triumph/tt = t
			tt.triumph_amount = text2num(params["triumph_amount"])

	deliver_ticket(t, target_ckey, admin_mob)

/datum/admin_ticket_granter/proc/collect_templates()
	var/list/out = list()
	for(var/path in subtypesof(/datum/ticket_template))
		var/datum/ticket_template/D = path
		if(initial(D.abstract_type) == path)
			continue
		var/datum/ticket_template/instance = new path()
		out += list(instance.to_ui_list())
		qdel(instance)
	return out

/datum/admin_ticket_granter/proc/deliver_ticket(datum/ticket/t, target_ckey, mob/admin_mob)
	var/client/C = GLOB.directory[target_ckey]
	if(C?.prefs)
		C.prefs.owned_tickets += t
		C.prefs.ticket_history += list(list(
			"event" = "granted",
			"description" = "granted [t.name] ([t.ticket_type][t.details()]) by [admin_mob.ckey]. Reason: [t.grant_reason]",
			"timestamp" = time2text(world.realtime, "YYYY-MM-DD hh:mm:ss"),
			"ticket_id" = t.ticket_id,
			"name" = t.name,
			"type" = t.ticket_type,
		))
		C.prefs.save_preferences()
		to_chat(C, span_notice("You have received a ticket: <b>[t.name]</b>!"))
		to_chat(admin_mob, span_notice("TICKETS: Granted '[t.name]' to [target_ckey] (online)."))
		message_admins("[key_name(admin_mob)] granted ticket '[t.name]' (triumph) to [target_ckey].")
		log_game("TICKETS: [admin_mob.ckey] granted '[t.name]' (triumph) to [target_ckey] via UI (online).")
		return

	var/target_file = file("data/player_saves/[target_ckey[1]]/[target_ckey]/preferences.sav")
	if(!fexists(target_file))
		to_chat(admin_mob, span_warning("TICKETS: No savefile found for [target_ckey]."))
		return
	var/savefile/S = new(target_file)

	var/list/raw
	S["owned_tickets"] >> raw
	if(!islist(raw))
		raw = list()
	raw += list(t.to_list())
	S["owned_tickets"] << raw

	var/list/history
	S["ticket_history"] >> history
	if(!islist(history))
		history = list()
	history += list(list(
		"event" = "granted",
		"description" = "granted [t.name] ([t.ticket_type][t.details()]) by [admin_mob.ckey]. Reason: [t.grant_reason]",
		"timestamp" = time2text(world.realtime, "YYYY-MM-DD hh:mm:ss"),
		"ticket_id" = t.ticket_id,
		"name" = t.name,
		"type" = t.ticket_type,
	))
	S["ticket_history"] << history

	to_chat(admin_mob, span_notice("TICKETS: Granted '[t.name]' to [target_ckey] (offline)."))
	message_admins("[key_name(admin_mob)] granted ticket '[t.name]' (triumph) to [target_ckey].")
	log_game("TICKETS: [admin_mob.ckey] granted '[t.name]' (triumph) to [target_ckey] via UI (offline).")

/client/proc/open_ticket_granter()
	set name = "Grant Ticket"
	set category = "GameMaster.Fun"

	if(!check_rights(R_ADMIN))
		return

	var/datum/admin_ticket_granter/granter = new(src)
	granter.ui_interact(mob)
