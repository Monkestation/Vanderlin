/proc/ticket_type_to_path(ticket_type)
	switch(ticket_type)
		if(TICKET_TYPE_LOADOUT)
			return /datum/ticket/loadout
		if(TICKET_TYPE_SPECIAL)
			return /datum/ticket/special
		if(TICKET_TYPE_JOB_BOOST)
			return /datum/ticket/job_boost
		if(TICKET_TYPE_TRIUMPH)
			return /datum/ticket/triumph
	return /datum/ticket

// Deserialise one savefile assoc-list entry into the right subtype.
/proc/ticket_from_list(list/L)
	if(!islist(L))
		return null
	var/subtype = ticket_type_to_path(L["ticket_type"])
	var/datum/ticket/t = new subtype()
	t.from_list(L)
	return t

/proc/generate_ticket_id()
	return "[time2text(world.realtime, "YYYYMMDD-hhmmss")]-[rand(1000,9999)]"

/// Find a ticket datum in a preferences list by ticket_id string.
/proc/find_ticket_in_prefs(datum/preferences/prefs, ticket_id)
	for(var/datum/ticket/t in prefs.owned_tickets)
		if(t.ticket_id == ticket_id)
			return t
	return null

/proc/use_ticket(client/user, datum/ticket/t)
	if(!user?.prefs || !(t in user.prefs.owned_tickets))
		return FALSE

	if(!t.use(user))
		return FALSE

	user.prefs.ticket_history += list(list(
		"event" = "used",
		"description" = "used [t.name], [t.ticket_type][t.details()]",
		"timestamp" = time2text(world.realtime, "YYYY-MM-DD hh:mm:ss"),
		"ticket_id" = t.ticket_id,
		"name" = t.name,
		"type" = t.ticket_type,
	))
	user.prefs.owned_tickets -= t
	user.prefs.save_preferences()
	user.prefs.save_character()
	log_game("TICKETS: [user.ckey] used ticket '[t.name]' ([t.ticket_id]).")
	return TRUE
