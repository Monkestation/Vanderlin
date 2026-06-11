GLOBAL_DATUM_INIT(ticket_trade_manager, /datum/ticket_trade_manager, new)
#define TICKET_TRADES_FILE "data/ticket_trades.sav"

/datum/ticket_trade
	var/trade_id
	var/from_ckey
	var/to_ckey
	var/list/offered_ticket_ids = list()
	var/list/offered_ticket_names = list()
	var/list/requested_ticket_ids = list()
	var/list/requested_ticket_names = list()
	var/created_at
	var/cancel_requested_at = null

/datum/ticket_trade_manager
	var/list/pending = list()

/datum/ticket_trade_manager/New()
	. = ..()
	load_pending()

/// Returns list of assoc-lists for a ckey, regardless of online status.
/datum/ticket_trade_manager/proc/get_raw_ticket_list(target_ckey, client/online_client)
	if(online_client?.prefs)
		var/list/result = list()
		for(var/datum/ticket/t in online_client.prefs.owned_tickets)
			result += list(t.to_list())
		return result
	return get_raw_ticket_list_offline(target_ckey)

/datum/ticket_trade_manager/proc/get_raw_ticket_list_offline(target_ckey)
	var/target_file = file("data/player_saves/[target_ckey[1]]/[target_ckey]/preferences.sav")
	if(!fexists(target_file))
		return null
	var/savefile/S = new(target_file)
	var/list/raw
	S["owned_tickets"] >> raw
	return islist(raw) ? raw : list()

/// Returns list of ticket_ids that from_ckey has locked in outgoing trades.
/datum/ticket_trade_manager/proc/get_locked_ids_for(from_ckey)
	var/list/locked = list()
	for(var/datum/ticket_trade/tr in pending)
		if(tr.from_ckey == from_ckey)
			for(var/id in tr.offered_ticket_ids)
				locked += id
	return locked

/// Edit an offline player's savefile atomically.
/datum/ticket_trade_manager/proc/savefile_remove_and_add_tickets(
	target_ckey,
	list/ids_to_remove,
	list/datums_to_add,
	partner_ckey,
	timestamp,
	list/removed_names,
	list/added_names,
)
	var/target_file = file("data/player_saves/[target_ckey[1]]/[target_ckey]/preferences.sav")
	if(!fexists(target_file))
		return
	var/savefile/S = new(target_file)
	var/list/raw
	S["owned_tickets"] >> raw
	if(!islist(raw))
		raw = list()

	var/list/clean = list()
	for(var/list/entry in raw)
		if(!(entry["ticket_id"] in ids_to_remove))
			clean += list(entry)
	for(var/datum/ticket/t in datums_to_add)
		clean += list(t.to_list())
	S["owned_tickets"] << clean

	var/list/raw_hist
	S["ticket_history"] >> raw_hist
	if(!islist(raw_hist))
		raw_hist = list()
	if(length(ids_to_remove))
		raw_hist += list(list(
			"event" = "traded_away",
			"timestamp" = timestamp,
			"ticket_ids"= ids_to_remove.Join(","),
			"names" = removed_names.Join(", "),
			"partner" = partner_ckey,
		))
	if(length(datums_to_add))
		raw_hist += list(list(
			"event" = "traded_received",
			"timestamp" = timestamp,
			"ticket_ids" = "",
			"names" = added_names.Join(", "),
			"partner" = partner_ckey,
		))
	S["ticket_history"] << raw_hist

/datum/ticket_trade_manager/proc/offer_trade(client/from_client, to_ckey, list/offered_ids, list/requested_ids)
	if(!from_client?.prefs)
		return FALSE
	if(!islist(offered_ids)) offered_ids = list()
	if(!islist(requested_ids)) requested_ids = list()
	if(!length(offered_ids) && !length(requested_ids))
		to_chat(from_client, span_warning("A trade must include at least one ticket on either side."))
		return FALSE

	// Validate offered tickets exist and aren't locked
	var/list/locked_ids = get_locked_ids_for(from_client.ckey)
	var/list/offered_datums = list()
	for(var/id in offered_ids)
		var/datum/ticket/t = find_ticket_in_prefs(from_client.prefs, id)
		if(!t)
			to_chat(from_client, span_warning("You no longer have ticket [id]."))
			return FALSE
		if(id in locked_ids)
			to_chat(from_client, span_warning("Ticket '[t.name]' is already in a pending trade."))
			return FALSE
		offered_datums += t

	// Validate recipient savefile exists
	var/client/to_client = GLOB.directory[to_ckey]
	if(!to_client)
		var/target_file = file("data/player_saves/[to_ckey[1]]/[to_ckey]/preferences.sav")
		if(!fexists(target_file))
			to_chat(from_client, span_warning("No player with ckey '[to_ckey]' found."))
			return FALSE

	var/list/offered_names = list()
	for(var/datum/ticket/t in offered_datums)
		offered_names += t.name

	var/list/requested_names = list()
	if(length(requested_ids))
		var/list/their_raw = get_raw_ticket_list(to_ckey, to_client)
		for(var/id in requested_ids)
			var/found_name = null
			for(var/list/entry in their_raw)
				if(entry["ticket_id"] == id)
					found_name = entry["name"]
					break
			if(!found_name)
				to_chat(from_client, span_warning("Could not find requested ticket [id] in [to_ckey]'s inventory."))
				return FALSE
			requested_names += found_name

	var/datum/ticket_trade/trade = new
	trade.trade_id = generate_ticket_id()
	trade.from_ckey = from_client.ckey
	trade.to_ckey = to_ckey
	trade.offered_ticket_ids = offered_ids.Copy()
	trade.offered_ticket_names = offered_names
	trade.requested_ticket_ids = requested_ids.Copy()
	trade.requested_ticket_names = requested_names
	trade.created_at = world.time

	pending += trade
	save_pending()

	if(to_client)
		var/list/offer_summary = offered_names.len ? offered_names : list("nothing")
		var/list/want_summary = requested_names.len ? requested_names : list("nothing")
		to_chat(to_client, span_notice( \
			"<b>[from_client.ckey]</b> has sent you a trade offer.\n \
			They offer: [english_list(offer_summary)].\n \
			They want: [english_list(want_summary)].\n \
			Check the Triumph Shop → Tickets tab." \
		))

	log_game("TICKETS: [from_client.ckey] offered trade [trade.trade_id] to [to_ckey]. \
		Offering: [english_list(offered_names)]. \
		Requesting: [english_list(requested_names.len ? requested_names : list("nothing"))].")
	return TRUE

/datum/ticket_trade_manager/proc/accept_trade(client/accepting_client, trade_id)
	if(!accepting_client)
		return FALSE

	var/datum/ticket_trade/trade = find_trade(trade_id)
	if(!trade)
		to_chat(accepting_client, span_warning("That trade no longer exists."))
		return FALSE
	if(trade.to_ckey != accepting_client.ckey)
		to_chat(accepting_client, span_warning("That trade is not addressed to you."))
		return FALSE
	if(trade.cancel_requested_at && (world.time - trade.cancel_requested_at) < (TICKET_TRADE_CANCEL_LOCK * 10))
		to_chat(accepting_client, span_warning("The sender is cancelling this trade, please wait a moment."))
		return FALSE

	var/timestamp = time2text(world.realtime, "YYYY-MM-DD hh:mm:ss")
	var/client/from_client = GLOB.directory[trade.from_ckey]

	// Validate offered tickets still exist in sender's inventory
	var/list/offered_datums = list()
	if(from_client?.prefs)
		for(var/id in trade.offered_ticket_ids)
			var/datum/ticket/t = find_ticket_in_prefs(from_client.prefs, id)
			if(!t)
				to_chat(accepting_client, span_warning("The sender no longer has one of the offered tickets, trade cancelled."))
				pending -= trade
				save_pending()
				return FALSE
			offered_datums += t
	else
		var/list/sender_raw = get_raw_ticket_list_offline(trade.from_ckey)
		if(isnull(sender_raw))
			to_chat(accepting_client, span_warning("Could not read the sender's save, trade cancelled."))
			pending -= trade
			save_pending()
			return FALSE
		for(var/id in trade.offered_ticket_ids)
			var/found = FALSE
			for(var/list/entry in sender_raw)
				if(entry["ticket_id"] == id)
					found = TRUE
					break
			if(!found)
				to_chat(accepting_client, span_warning("The sender no longer has one of the offered tickets, trade cancelled."))
				pending -= trade
				save_pending()
				return FALSE

	// Validate requested tickets still in recipient's inventory
	var/list/requested_datums = list()
	for(var/id in trade.requested_ticket_ids)
		var/datum/ticket/t = find_ticket_in_prefs(accepting_client.prefs, id)
		if(!t)
			to_chat(accepting_client, span_warning("You no longer have one of the requested tickets ([id])."))
			return FALSE
		requested_datums += t

	if(from_client?.prefs)
		for(var/datum/ticket/t in offered_datums)
			from_client.prefs.owned_tickets -= t
		from_client.prefs.ticket_history += list(list(
			"event" = "traded_away",
			"timestamp" = timestamp,
			"ticket_ids" = trade.offered_ticket_ids.Join(","),
			"names" = trade.offered_ticket_names.Join(", "),
			"received_ids" = trade.requested_ticket_ids.Join(","),
			"received_names" = trade.requested_ticket_names.Join(", "),
			"partner" = accepting_client.ckey,
		))
		for(var/datum/ticket/t in requested_datums)
			from_client.prefs.owned_tickets += t
		from_client.prefs.ticket_history += list(list(
			"event" = "traded_received",
			"timestamp" = timestamp,
			"ticket_ids" = trade.requested_ticket_ids.Join(","),
			"names" = trade.requested_ticket_names.Join(", "),
			"partner" = accepting_client.ckey,
		))
		from_client.prefs.save_character()
	else
		savefile_remove_and_add_tickets(
			trade.from_ckey,
			trade.offered_ticket_ids,
			requested_datums,
			accepting_client.ckey,
			timestamp,
			trade.offered_ticket_names,
			trade.requested_ticket_names,
		)

	for(var/datum/ticket/t in requested_datums)
		accepting_client.prefs.owned_tickets -= t
	for(var/datum/ticket/t in offered_datums)
		accepting_client.prefs.owned_tickets += t
	accepting_client.prefs.ticket_history += list(list(
		"event" = "traded_received",
		"timestamp" = timestamp,
		"ticket_ids" = trade.offered_ticket_ids.Join(","),
		"names" = trade.offered_ticket_names.Join(", "),
		"partner" = trade.from_ckey,
	))
	if(length(trade.requested_ticket_ids))
		accepting_client.prefs.ticket_history += list(list(
			"event" = "traded_away",
			"timestamp" = timestamp,
			"ticket_ids" = trade.requested_ticket_ids.Join(","),
			"names" = trade.requested_ticket_names.Join(", "),
			"partner" = trade.from_ckey,
		))
	accepting_client.prefs.save_character()

	pending -= trade
	save_pending()

	to_chat(accepting_client, span_notice("Trade accepted!"))
	if(from_client)
		to_chat(from_client, span_notice("<b>[accepting_client.ckey]</b> accepted your trade offer."))

	log_game("TICKETS: [accepting_client.ckey] accepted trade [trade.trade_id] from [trade.from_ckey].")
	return TRUE

/datum/ticket_trade_manager/proc/cancel_trade(client/cancelling_client, trade_id)
	if(!cancelling_client)
		return FALSE

	var/datum/ticket_trade/trade = find_trade(trade_id)
	if(!trade)
		to_chat(cancelling_client, span_warning("That trade no longer exists."))
		return FALSE
	if(trade.from_ckey != cancelling_client.ckey)
		to_chat(cancelling_client, span_warning("You can only cancel your own outgoing trades."))
		return FALSE
	if(trade.cancel_requested_at)
		to_chat(cancelling_client, span_warning("Cancel already in progress."))
		return FALSE

	trade.cancel_requested_at = world.time
	to_chat(cancelling_client, span_notice("Cancel requested. Processing in [TICKET_TRADE_CANCEL_LOCK] seconds..."))

	spawn(TICKET_TRADE_CANCEL_LOCK SECONDS)
		if(!(trade in pending))
			return
		pending -= trade
		save_pending()
		to_chat(cancelling_client, span_notice("Trade [trade.trade_id] cancelled."))
		var/client/to_client = GLOB.directory[trade.to_ckey]
		if(to_client)
			to_chat(to_client, span_warning("Trade offer from [trade.from_ckey] was cancelled."))
		log_game("TICKETS: [cancelling_client.ckey] cancelled trade [trade.trade_id].")

	return TRUE

/datum/ticket_trade_manager/proc/find_trade(trade_id)
	for(var/datum/ticket_trade/tr in pending)
		if(tr.trade_id == trade_id)
			return tr
	return null

/// Look up any player's ticket list for the trade UI.
/datum/ticket_trade_manager/proc/lookup_inventory(target_ckey)
	var/client/C = GLOB.directory[target_ckey]
	return get_raw_ticket_list(target_ckey, C)

/datum/ticket_trade_manager/proc/save_pending()
	var/savefile/S = new(TICKET_TRADES_FILE)
	var/list/serialized = list()
	for(var/datum/ticket_trade/tr in pending)
		serialized += list(list(
			"trade_id"              = tr.trade_id,
			"from_ckey"             = tr.from_ckey,
			"to_ckey"               = tr.to_ckey,
			"offered_ticket_ids"    = tr.offered_ticket_ids.Join(","),
			"offered_ticket_names"  = tr.offered_ticket_names.Join(","),
			"requested_ticket_ids"  = tr.requested_ticket_ids.Join(","),
			"requested_ticket_names"= tr.requested_ticket_names.Join(","),
			"created_at"            = tr.created_at,
			"cancel_requested_at"   = tr.cancel_requested_at,
		))
	S["pending"] << serialized

/datum/ticket_trade_manager/proc/load_pending()
	if(!fexists(TICKET_TRADES_FILE))
		return
	var/savefile/S = new(TICKET_TRADES_FILE)
	var/list/raw
	S["pending"] >> raw
	if(!islist(raw))
		return
	for(var/list/entry in raw)
		var/datum/ticket_trade/tr = new
		tr.trade_id              = entry["trade_id"]
		tr.from_ckey             = entry["from_ckey"]
		tr.to_ckey               = entry["to_ckey"]
		tr.offered_ticket_ids    = entry["offered_ticket_ids"]   != "" ? splittext(entry["offered_ticket_ids"],   ",") : list()
		tr.offered_ticket_names  = entry["offered_ticket_names"]  != "" ? splittext(entry["offered_ticket_names"],  ",") : list()
		tr.requested_ticket_ids  = entry["requested_ticket_ids"]  != "" ? splittext(entry["requested_ticket_ids"],  ",") : list()
		tr.requested_ticket_names= entry["requested_ticket_names"]!= "" ? splittext(entry["requested_ticket_names"],",") : list()
		tr.created_at            = entry["created_at"]
		tr.cancel_requested_at   = null
		pending += tr

#undef TICKET_TRADES_FILE
