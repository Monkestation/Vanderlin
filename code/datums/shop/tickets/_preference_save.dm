/datum/preferences/proc/save_tickets(savefile/S)
	if(!S)
		return
	var/list/serial = list()
	for(var/datum/ticket/t in owned_tickets)
		serial += list(t.to_list())
	S["owned_tickets"] << serial
	S["ticket_history"] << ticket_history

/datum/preferences/proc/load_tickets(savefile/S)
	if(!S)
		return
	var/list/raw
	S["owned_tickets"] >> raw
	owned_tickets = list()
	if(islist(raw))
		for(var/list/entry in raw)
			var/datum/ticket/t = ticket_from_list(entry)
			if(t)
				owned_tickets += t
	var/list/raw_hist
	S["ticket_history"] >> raw_hist
	ticket_history = islist(raw_hist) ? raw_hist : list()
