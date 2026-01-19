/**
 * # Plexora Subsystem
 *
 * This subsystem is for the Plexora Discord bot bridge.
 *
 * The repo for this can be found at https://github.com/monkestation/plexora
 *
 * The distinction between Plexora (the bot) and Plexora (the subsystem)
 * will be plexora (the bot) and SSplexora (the subsystem)
 *
 * NOTES:
 * * SSplexora makes heavy use of topics, and rust_g HTTP requests
 * * Lets hope to god plexora is configured properly and DOESNT CRASh,
 *	 -because i seriously do not want to put error catchers in
 *	 -EVERY FUNCTION THAT MAKES AN HTTP REQUEST
 */

#define TOPIC_EMITTER \
	if (input["emitter_token"]) { \
		INVOKE_ASYNC(SSplexora, TYPE_PROC_REF(/datum/controller/subsystem/plexora, topic_listener_response), input["emitter_token"], returning); \
		return; \
	};

#define AUTH_HEADER ("Basic " + CONFIG_GET(string/comms_key))
#define OLD_PLEXORA_CONFIG "config/plexora.json"

SUBSYSTEM_DEF(plexora)
	name = "Plexora"
	wait = 30 SECONDS
	init_order = INIT_ORDER_PLEXORA
	runlevels = ALL

#ifdef UNIT_TESTS
	flags = SS_NO_INIT | SS_NO_FIRE
#endif

	// MUST INCREMENT BY ONE FOR EVERY CHANGE MADE TO PLEXORA
	var/version_increment_counter = 2
	var/plexora_is_alive = FALSE
	var/base_url = ""
	var/enabled = TRUE
	var/tripped_bad_version = FALSE
	var/list/default_headers

	var/restart_type = PLEXORA_SHUTDOWN_NORMAL
	var/mob/restart_requester
	var/list/active_requests = list()

/datum/controller/subsystem/plexora/Initialize()
	if(!CONFIG_GET(flag/plexora_enabled) && !load_old_plexora_config())
		enabled = FALSE
		flags |= SS_NO_FIRE
		return TRUE

	var/comms_key = CONFIG_GET(string/comms_key)
	if (!comms_key)
		stack_trace("SSplexora is enabled BUT there is no configured comms key! Please make sure to set one and update Plexora's server config.")
		enabled = FALSE
		flags |= SS_NO_FIRE
		return FALSE

	base_url = CONFIG_GET(string/plexora_url)

	default_headers = list(
		"Content-Type" = "application/json",
		"Authorization" = AUTH_HEADER,
	)

	// Do a ping test to check if Plexora is actually running
	if (!is_plexora_alive())
		stack_trace("SSplexora is enabled BUT plexora is not alive or running! SS has not been aborted, subsequent fires will take place.")
	else
		serverstarted()

	RegisterSignal(SSticker, COMSIG_TICKER_ROUND_STARTING, PROC_REF(roundstarted))

	return TRUE

/datum/controller/subsystem/plexora/Shutdown()
	var/end_time = REALTIMEOFDAY + (5 SECONDS)
	while((length(active_requests) > 0) && (REALTIMEOFDAY < end_time))
		for(var/datum/http_request/request as anything in active_requests)
			if(request.is_complete())
				active_requests -= request
				qdel(request)
	active_requests.Cut()

/datum/controller/subsystem/plexora/Recover()
	flags |= SS_NO_INIT // Make extra sure we don't initialize twice.
	initialized = SSplexora.initialized
	plexora_is_alive = SSplexora.plexora_is_alive
	base_url = SSplexora.base_url
	enabled = SSplexora.enabled
	tripped_bad_version = SSplexora.tripped_bad_version
	default_headers = SSplexora.default_headers
	active_requests = SSplexora.active_requests
	if(initialized && !enabled)
		flags |= SS_NO_FIRE

// compat thing so that it'll load plexora.json if it's still used
/datum/controller/subsystem/plexora/proc/load_old_plexora_config()
	if(!rustg_file_exists(OLD_PLEXORA_CONFIG))
		return FALSE
	var/list/old_config = json_decode(rustg_file_read(OLD_PLEXORA_CONFIG))
	if(!old_config["enabled"])
		return FALSE
	stack_trace("Falling back to [OLD_PLEXORA_CONFIG], you should really migrate to the PLEXORA_ENABLED and PLEXORA_URL config entries!")
	CONFIG_SET(flag/plexora_enabled, TRUE)
	CONFIG_SET(string/plexora_url, "http://[old_config["ip"]]:[old_config["port"]]")
	return TRUE

/datum/controller/subsystem/plexora/proc/is_plexora_alive()
	. = FALSE
	if(!enabled) return

	var/datum/http_request/request = new(RUSTG_HTTP_METHOD_GET, "[base_url]/alive")
	request.begin_async()
	UNTIL_OR_TIMEOUT(request.is_complete(), 10 SECONDS)
	var/datum/http_response/response = request.into_response()
	if (response.errored)
		plexora_is_alive = FALSE
		log_admin("Failed to check if Plexora is alive! She probably isn't. Check config on both sides")
		CRASH("Failed to check if Plexora is alive! She probably isn't. Check config on both sides")
	else
		var/list/json_body = json_decode(response.body)
		if (json_body["version_increment_counter"] != version_increment_counter)
			if (!tripped_bad_version)
				stack_trace("SSplexora's version does not match Plexora! SSplexora: [version_increment_counter] Plexora: [json_body["version_increment_counter"]]")
				tripped_bad_version = TRUE

		plexora_is_alive = TRUE
		return TRUE

/datum/controller/subsystem/plexora/fire()
	if(!is_plexora_alive()) return
	// Send current status to Plexora
	var/datum/world_topic/status/status_handler = new()
	var/list/status = status_handler.Run()
	status["round_id"] = GLOB.round_id

	var/datum/http_request/status_request = http_request(
		RUSTG_HTTP_METHOD_POST,
		"[base_url]/status",
		json_encode(status),
		default_headers
	)
	status_request.begin_async()
	active_requests += status_request
	for(var/datum/http_request/request as anything in active_requests)
		if(request.is_complete()) // rust-g will clear the job once it's complete
			active_requests -= request
			qdel(request)

/datum/controller/subsystem/plexora/proc/_Shutdown(hard = FALSE, requestedby)
	var/static/server_restart_sent = FALSE

	if (server_restart_sent)
		return
	server_restart_sent = TRUE
	http_basicasync("serverupdates", list(
		"type" = "servershutdown",
		"timestamp" = rustg_unix_timestamp(),
		"roundid" = GLOB.round_id,
		"round_timer" = ROUND_TIME(),
		"map" = SSmapping.config?.map_name,
		"playercount" = length(GLOB.clients),
		"restart_type" = restart_type,
		"requestedby" = usr?.ckey,
		"requestedby_stealthed" = usr?.client?.holder?.fakekey,
	), mark_active = FALSE)

/datum/controller/subsystem/plexora/proc/serverstarted()
	http_basicasync("serverupdates", list(
		"type" = "serverstart",
		"timestamp" = rustg_unix_timestamp(),
		"roundid" = GLOB.round_id,
		"map" = SSmapping.config?.map_name,
		"playercount" = length(GLOB.clients),
	))

/datum/controller/subsystem/plexora/proc/serverinitdone(time)
	http_basicasync("serverupdates", list(
		"type" = "serverinitdone",
		"timestamp" = rustg_unix_timestamp(),
		"roundid" = GLOB.round_id,
		"map" = SSmapping.config?.map_name,
		"playercount" = length(GLOB.clients),
		"init_time" = time,
	))

// This DOES get called, refer to init proc, it uses a signal.
/datum/controller/subsystem/plexora/proc/roundstarted()
	http_basicasync("serverupdates", list(
		"type" = "roundstart",
		"timestamp" = rustg_unix_timestamp(),
		"roundid" = GLOB.round_id,
		"map" = SSmapping.config?.map_name,
		"playercount" = length(GLOB.clients),
	))

/datum/controller/subsystem/plexora/proc/roundended()
	http_basicasync("serverupdates", list(
		"type" = "roundend",
		"timestamp" = rustg_unix_timestamp(),
		"roundid" = GLOB.round_id,
		"round_timer" = ROUND_TIME(),
		"map" = SSmapping.config?.map_name,
		"nextmap" = SSmapping.next_map_config?.map_name,
		"playercount" = length(GLOB.clients),
		"playerstring" = "**Total**: [length(GLOB.clients)]",
	))

/datum/controller/subsystem/plexora/proc/check_byondserver_status(id)
	if (isnull(id)) return

	var/list/body = list(
		"id" = id
	)

	var/datum/http_request/request = new(RUSTG_HTTP_METHOD_GET, "[base_url]/byondserver_alive", json_encode(body), default_headers)
	request.begin_async()
	UNTIL_OR_TIMEOUT(request.is_complete(), 5 SECONDS)
	var/datum/http_response/response = request.into_response()
	if (response.errored)
		stack_trace("check_byondserver_status failed, likely an bad id passed ([id]) aka id of a server that doesnt exist")
		return FALSE
	else
		var/list/json_body = json_decode(response.body)
		return json_body["alive_likely"]

/datum/controller/subsystem/plexora/proc/relay_admin_say(client/user, message)
	http_basicasync("relay_admin_say", list(
		"key" = user.key,
		"message" = message,
		"icon_b64" = icon2base64(getFlatIcon(user.mob, SOUTH, no_anim = TRUE)),
	))

// note: recover_all_SS_and_recreate_master to force mc shit

/datum/controller/subsystem/plexora/proc/mc_alert(alert, level = 5)
	http_basicasync("serverupdates", list(
		"type" = "mcalert",
		"timestamp" = rustg_unix_timestamp(),
		"roundid" = GLOB.round_id,
		"round_timer" = ROUND_TIME(),
		"map" = SSmapping.config?.map_name,
		"playercount" = length(GLOB.clients),
		"playerstring" = "**Total**: [length(GLOB.clients)]",
		"defconstring" = alert,
		"defconlevel" = level,
	))

/datum/controller/subsystem/plexora/proc/new_note(list/note)
	// note["replay_pass"] = CONFIG_GET(string/replay_password)
	http_basicasync("noteupdates", note)

/datum/controller/subsystem/plexora/proc/new_ban(list/ban)
	// TODO: It might be easier to just send off a ban ID to Plexora, but oh well.
	// list values are in sql_ban_system.dm
	// ban["replay_pass"] = CONFIG_GET(string/replay_password)
	http_basicasync("banupdates", ban)

// Maybe we should consider that, if theres no admin_ckey when creating a new ticket,
// This isnt a bwoink. Other wise if it does exist, it is a bwoink.
/datum/controller/subsystem/plexora/proc/aticket_new(datum/admin_help/ticket, msg_raw, is_bwoink, urgent, admin_ckey = null)
	if(!enabled) return
	http_basicasync("atickets/new", list(
		"id" = ticket.id,
		"roundid" = GLOB.round_id,
		"round_timer" = ROUND_TIME(),
		"world_time" = world.time,
		"name" = ticket.name,
		"ckey" = ticket.initiator_ckey,
		"key_name" = ticket.initiator_key_name,
		"is_bwoink" = is_bwoink,
		"urgent" = urgent,
		"msg_raw" = msg_raw,
		"opened_at" = rustg_unix_timestamp(),
		// "replay_pass" = CONFIG_GET(string/replay_password),
		"icon_b64" = icon2base64(getFlatIcon(ticket.initiator.mob, SOUTH, no_anim = TRUE)),
		"admin_ckey" = admin_ckey,
	))

/datum/controller/subsystem/plexora/proc/aticket_closed(datum/admin_help/ticket, closed_by, close_type = AHELP_CLOSETYPE_CLOSE, close_reason = AHELP_CLOSEREASON_NONE)
	if(!enabled) return
	http_basicasync("atickets/close", list(
		"id" = ticket.id,
		"roundid" = GLOB.round_id,
		"closed_by" = closed_by,
		// Make sure the defines in __DEFINES/admin.dm match up with Plexora's code
		"close_reason" = close_reason,
		"close_type" = close_type,
		"time_closed" = rustg_unix_timestamp(),
	))

/datum/controller/subsystem/plexora/proc/aticket_reopened(datum/admin_help/ticket, reopened_by)
	if(!enabled) return
	http_basicasync("atickets/reopen", list(
		"id" = ticket.id,
		"roundid" = GLOB.round_id,
		"time_reopened" = rustg_unix_timestamp(),
		"reopened_by" = reopened_by, // ckey
	))

/datum/controller/subsystem/plexora/proc/aticket_pm(datum/admin_help/ticket, message, admin_ckey = null)
	if(!enabled || QDELETED(ticket))
		return
	var/list/body = list();
	body["id"] = ticket.id
	body["roundid"] = GLOB.round_id
	body["message"] = message

	// We are just.. going to assume that if there is no admin_ckey param,
	// that the person sending the message is not an admin.
	// no admin_ckey = user is the initiator

	if (admin_ckey)	body["admin_ckey"] = admin_ckey

	http_basicasync("atickets/pm", list(
		"id" = ticket.id,
		"roundid" = GLOB.round_id,
		"message" = message,
		"admin_ckey" = admin_ckey,
	))

/datum/controller/subsystem/plexora/proc/aticket_connection(datum/admin_help/ticket, is_disconnect = TRUE)
	if(!ticket)
		return
	if(!enabled) return
	http_basicasync("atickets/connection_notice", list(
		"id" = ticket.id,
		"roundid" = GLOB.round_id,
		"is_disconnect" = is_disconnect,
		"time_of_connection" = rustg_unix_timestamp(),
	))

/datum/controller/subsystem/plexora/proc/topic_listener_response(token, data)
	if(!enabled) return
	http_basicasync("topic_emitter", list(
		"token" = token,
		"data" = data,
	))

/datum/controller/subsystem/plexora/proc/http_basicasync(path, list/body, mark_active = TRUE)
	RETURN_TYPE(/datum/http_request)
	if(!enabled) return

	var/datum/http_request/request = new(
		RUSTG_HTTP_METHOD_POST,
		"[base_url]/[path]",
		json_encode(body),
		default_headers,
		"tmp/response.json"
	)
	request.begin_async()
	if(mark_active)
		active_requests += request

/datum/world_topic/plx_announce
	keyword = "PLX_announce"
	require_comms_key = TRUE

/datum/world_topic/plx_announce/Run(list/input)
	var/message = input["message"]
	var/from = input["from"]

	var/admin_name = span_adminannounce_big("[from] Announces:")
	var/message_to_announce = ("[span_adminannounce(message)]")
	to_chat(world, announcement_block("[admin_name] \n \n [message_to_announce]"))

/datum/world_topic/plx_restartcontroller
	keyword = "PLX_restartcontroller"
	require_comms_key = TRUE

/datum/world_topic/plx_restartcontroller/Run(list/input)
	var/controller = input["controller"]
	var/username = input["username"]
	var/userid = input["userid"]

	if (!controller)
		return

	switch(LOWER_TEXT(controller))
		if("master")
			Recreate_MC()
			SSblackbox.record_feedback("tally", "admin_verb", 1, "PLX: Restart Master Controller")
		if("failsafe")
			new /datum/controller/failsafe()
			SSblackbox.record_feedback("tally", "admin_verb", 1, "PLX: Restart Failsafe Controller")
	message_admins("PLEXORA: @[username] ([userid]) has restarted the [controller] controller from the Discord.")

/datum/world_topic/plx_globalnarrate
	keyword = "PLX_globalnarrate"
	require_comms_key = TRUE

/datum/world_topic/plx_globalnarrate/Run(list/input)
	var/message = input["contents"]

	for(var/mob/player as anything in GLOB.player_list)
		to_chat(player, message)

/datum/world_topic/plx_who
	keyword = "PLX_who"
	require_comms_key = TRUE

/datum/world_topic/plx_who/Run(list/input)
	. = list()
	for(var/client/client as anything in GLOB.clients)
		if(QDELETED(client))
			continue
		. += list(list("key" = client.holder?.fakekey || client.key, "avgping" = "[round(client.avgping, 1)]ms"))

/datum/world_topic/plx_adminwho
	keyword = "PLX_adminwho"
	require_comms_key = TRUE

/datum/world_topic/plx_adminwho/Run(list/input)
	. = list()
	for (var/client/admin as anything in GLOB.admins)
		if(QDELETED(admin))
			continue
		var/admin_info = list(
			"name" = admin,
			"ckey" = admin.ckey,
			"rank" = admin.holder.rank.name,
			"afk" = admin.is_afk(),
			"stealth" = !!admin.holder.fakekey,
			"stealthkey" = admin.holder.fakekey,
		)

		if(isobserver(admin.mob))
			admin_info["state"] = "observing"
		else if(isnewplayer(admin.mob))
			admin_info["state"] = "lobby"
		else
			admin_info["state"] = "playing"

		. += LIST_VALUE_WRAP_LISTS(admin_info)

/datum/world_topic/plx_getbasicplayerdetails
	keyword = "PLX_getbasicplayerdetails"
	require_comms_key = TRUE

/datum/world_topic/plx_getbasicplayerdetails/Run(list/input)
	var/ckey = input["ckey"]

	if (!ckey)
		return list("error" = PLEXORA_ERROR_MISSING_CKEY)

	var/list/returning = list(
		"ckey" = ckey
	)

	var/client/client = disambiguate_client(ckey)

	if (QDELETED(client))
		returning["present"] = FALSE
	else
		returning["present"] = TRUE
		returning["key"] = client.key

	var/datum/player_details/details = GLOB.player_details[ckey]

	if (details)
		returning["byond_version"] = details.byond_version

	if (QDELETED(client))
		var/datum/client_interface/mock_player = new(ckey)
		mock_player.prefs = new /datum/preferences(mock_player)
		returning["playtime"] = mock_player.get_exp_living(FALSE)
	else
		returning["playtime"] = client.get_exp_living(FALSE)

	return returning

/datum/world_topic/plx_getplayerdetails
	keyword = "PLX_getplayerdetails"
	require_comms_key = TRUE

/datum/world_topic/plx_getplayerdetails/Run(list/input)
	var/ckey = input["ckey"]
	var/omit_logs = input["omit_logs"]

	if (!ckey)
		return list("error" = PLEXORA_ERROR_MISSING_CKEY)

	var/datum/player_details/details = GLOB.player_details[ckey]

	if (QDELETED(details))
		return list("error" = PLEXORA_ERROR_DETAILSNOTEXIST)

	var/client/client = disambiguate_client(ckey)

	var/list/returning = list(
		"ckey" = ckey,
		"present" = !QDELETED(client),
		"admin_datum" = null,
		"logging" = details.logging,
		"played_names" = details.played_names,
		"byond_version" = details.byond_version,
		"achievements" = details.achievements.data,
	)

	var/mob/clientmob
	if (!QDELETED(client))
		returning["playtime"] = client.get_exp_living(FALSE)
		returning["key"] = client.key
		clientmob = client.mob
	else
		for (var/mob/mob as anything in GLOB.mob_list)
			if (!QDELETED(mob) && mob.ckey == ckey)
				clientmob = mob
				break

	if (!omit_logs)
		returning["logging"] = details.logging

	if (GLOB.admin_datums[ckey])
		var/datum/admins/ckeyadatum = GLOB.admin_datums[ckey]
		returning["admin_datum"] = list(
			"name" = ckeyadatum.name,
			"ranks" = ckeyadatum.rank,
			"fakekey" = ckeyadatum.fakekey,
			"deadmined" = ckeyadatum.deadmined,
			"bypass_2fa" = TRUE,
			"admin_signature" = ckeyadatum.admin_signature,
		)

	returning["mob"] = list(
		"name" = clientmob.name,
		"real_name" = clientmob.real_name,
		"type" = clientmob.type,
		"gender" = clientmob.gender,
		"stat" = clientmob.stat,
	)
	if (!QDELETED(client) && isliving(clientmob))
		var/mob/living/livingmob = clientmob
		returning["health"] = livingmob.health
		returning["maxHealth"] = livingmob.maxHealth
		returning["bruteloss"] = livingmob.bruteloss
		returning["fireloss"] = livingmob.fireloss
		returning["toxloss"] = livingmob.toxloss
		returning["oxyloss"] = livingmob.oxyloss

	TOPIC_EMITTER

	return returning

/datum/world_topic/plx_mobpicture
	keyword = "PLX_mobpicture"
	require_comms_key = TRUE

/datum/world_topic/plx_mobpicture/Run(list/input)
	var/ckey = input["ckey"]

	var/client/client = disambiguate_client(ckey)

	if (QDELETED(client))
		return list("error" = PLEXORA_ERROR_CLIENTNOTEXIST)

	var/returning = list(
		"icon_b64" = icon2base64(getFlatIcon(client.mob, no_anim = TRUE))
	)

	TOPIC_EMITTER

	return returning

/datum/world_topic/plx_forceemote
	keyword = "PLX_forceemote"
	require_comms_key = TRUE

/datum/world_topic/plx_forceemote/Run(list/input)
	var/target_ckey = input["ckey"]
	var/emote = input["emote"]
	var/emote_args = input["emote_args"]

	var/client/client = disambiguate_client(ckey(target_ckey))

	if (QDELETED(client))
		return list("error" = PLEXORA_ERROR_CLIENTNOTEXIST)

	var/mob/client_mob = client.mob

	if (QDELETED(client_mob))
		return list("error" = PLEXORA_ERROR_CLIENTNOMOB)

	return list(
		"success" = client_mob.emote(emote, message = emote_args, intentional = FALSE)
	)

/datum/world_topic/plx_forcesay
	keyword = "PLX_forcesay"
	require_comms_key = TRUE

/datum/world_topic/plx_forcesay/Run(list/input)
	var/target_ckey = input["ckey"]
	var/message = input["message"]

	var/client/client = disambiguate_client(ckey(target_ckey))

	if (QDELETED(client))
		return list("error" = PLEXORA_ERROR_CLIENTNOTEXIST)

	var/mob/client_mob = client.mob

	if (QDELETED(client_mob))
		return list("error" = PLEXORA_ERROR_CLIENTNOMOB)

	client_mob.say(message, forced = TRUE)

/datum/world_topic/plx_kick
	keyword = "PLX_kick"
	require_comms_key = TRUE

/datum/world_topic/plx_kick/Run(list/input)
	var/ckey = input["ckey"]
	var/reason = input["reason"]
	var/kicker = input["admin_ckey"]

	if(!ckey || !kicker)
		return list("error" = PLEXORA_ERROR_BAD_PARAM, "param" = "ckey/admin_ckey", "reason" = "missing required parameter")

	var/client/client = disambiguate_client(ckey)

	if(QDELETED(client))
		return list("error" = PLEXORA_ERROR_CLIENTNOTEXIST)

	// Mock admin
	var/datum/client_interface/mockadmin = new(
		key = kicker,
	)

	to_chat(client, span_boldannounce("You have been kicked from the server by [key_name_admin(mockadmin)]. Reason: [reason]"))

	qdel(client)

	log_admin("Discord: [key_name(mockadmin)] has kicked [key_name(client)] from the server! Reason: [reason]")
	message_admins("Discord: [key_name_admin(mockadmin)] has kicked [key_name_admin(client)] from the server! Reason: [reason]")

/datum/world_topic/plx_ticketaction
	keyword = "PLX_ticketaction"
	require_comms_key = TRUE

/datum/world_topic/plx_ticketaction/Run(list/input)
	var/ticketid = input["id"]
	var/action_by_ckey = input["action_by"]
	var/action = input["action"]


	var/datum/client_interface/mockadmin = new(key = action_by_ckey)

	usr = mockadmin

	var/datum/admin_help/ticket = GLOB.ahelp_tickets.TicketByID(ticketid)
	if (QDELETED(ticket)) return list("error" = PLEXORA_ERROR_TICKETNOTEXIST)

	if (action != "reopen" && ticket.state != AHELP_ACTIVE)
		return

	switch(action)
		if("reopen")
			if (ticket.state == AHELP_ACTIVE) return
			SSplexora.aticket_reopened(ticket, action_by_ckey)
			ticket.Reopen()
		if("reject")
			SSplexora.aticket_closed(ticket, action_by_ckey, AHELP_CLOSETYPE_REJECT)
			ticket.Reject(action_by_ckey)
		if("icissue")
			SSplexora.aticket_closed(ticket, action_by_ckey, AHELP_CLOSETYPE_RESOLVE, AHELP_CLOSEREASON_IC)
			ticket.ICIssue(action_by_ckey)
		if("mentorissue")
			SSplexora.aticket_closed(ticket, action_by_ckey, AHELP_CLOSETYPE_RESOLVE, AHELP_CLOSEREASON_MENTOR)
			ticket.mentorissue(action_by_ckey)
		if("close")
			SSplexora.aticket_closed(ticket, action_by_ckey, AHELP_CLOSETYPE_CLOSE)
			ticket.Close(action_by_ckey)
		if("resolve")
			SSplexora.aticket_closed(ticket, action_by_ckey, AHELP_CLOSETYPE_RESOLVE)
			ticket.Resolve(action_by_ckey)

/datum/world_topic/plx_sendaticketpm
	keyword = "PLX_sendaticketpm"
	require_comms_key = TRUE

/datum/world_topic/plx_sendaticketpm/Run(list/input)
	// We're kind of copying /proc/TgsPm here...
	var/ticketid = text2num(input["ticket_id"])
	var/input_ckey = input["ckey"]
	var/sender = input["sender_ckey"]
	var/stealth = input["stealth"]
	var/message = input["message"]

	var/requested_ckey = ckey(input_ckey)
	var/client/recipient = disambiguate_client(requested_ckey)

	if (QDELETED(recipient))
		return list("error" = PLEXORA_ERROR_CLIENTNOTEXIST)

	var/datum/admin_help/ticket = ticketid ? GLOB.ahelp_tickets.TicketByID(ticketid) : GLOB.ahelp_tickets.CKey2ActiveTicket(requested_ckey)

	if (QDELETED(ticket))
		return list("error" = PLEXORA_ERROR_TICKETNOTEXIST)

	var/plx_tagged = "[sender]"

	var/adminname = stealth ? "Administrator" : plx_tagged
	var/stealthkey = GetTgsStealthKey()

	message = sanitize(copytext_char(message, 1, MAX_MESSAGE_LEN))
	message = emoji_parse(message)

	if (!message)
		return list("error" = PLEXORA_ERROR_SANITIZATION_FAILED)

	// I have no idea what this does honestly.


	// The ckey of our recipient, with a reply link, and their mob if one exists
	var/recipient_name_linked = key_name_admin(recipient)
	// The ckey of our recipient, with their mob if one exists. No link
	var/recipient_name = key_name_admin(recipient)

	message_admins("External message from [sender] to [recipient_name_linked] : [message]")
	log_admin_private("External PM: [sender] -> [recipient_name] : [message]")

	to_chat(recipient,
		message = "<font color='red' size='4'><b>-- Administrator private message --</b></font>",
		)

	recipient.receive_ahelp(
		"<a href='?priv_msg=[stealthkey]'>[adminname]</a>",
		message,
	)

	to_chat(recipient,
		message = span_adminsay("<i>Click on the administrator's name to reply.</i>"),)


	admin_ticket_log(recipient, "<font color='purple'>PM From [adminname]: [message]</font>", player_message = "<font color='purple'>PM From [adminname]: [message]</font>")

	window_flash(recipient, ignorepref = TRUE)
	// Nullcheck because we run a winset in window flash and I do not trust byond
	if(!QDELETED(recipient))
		//always play non-admin recipients the adminhelp sound
		SEND_SOUND(recipient, 'sound/misc/adminhelp.ogg')

		recipient.externalreplyamount = EXTERNALREPLYCOUNT

/datum/world_topic/plx_relayadminsay
	keyword = "PLX_relayadminsay"
	require_comms_key = TRUE

/datum/world_topic/plx_relayadminsay/Run(list/input)
	var/sender = input["sender"]
	var/msg = input["message"]

	msg = emoji_parse(copytext_char(sanitize(msg), 1, MAX_MESSAGE_LEN))
	if(!msg)
		return

	msg = keywords_lookup(msg)

	// TODO: Load sender's color prefs? idk
	msg = span_adminsay("[span_prefix("ADMIN (DISCORD):")] <EM>[sender]</EM>: <span class='message linkify'>[msg]</span>")

	to_chat(GLOB.admins,msg)

	SSblackbox.record_feedback("tally", "admin_say_relay", 1, "Asay external") //If you are copy-pasting this, ensure the 2nd parameter is unique to the new proc!

/datum/world_topic/plx_givetriumphs
	keyword = "PLX_givetriumphs"
	require_comms_key = TRUE

/datum/world_topic/plx_givetriumphs/Run(list/input)
	var/ckey = input["ckey"]
	var/amount = input["amount"]
	var/reason = input["reason"]

	if (!ckey)
		return list("error" = PLEXORA_ERROR_MISSING_CKEY)

	amount = text2num(amount)

	if (!amount || amount <= 0)
		return list("error" = PLEXORA_ERROR_BAD_PARAM, "param" = "amount", "reason" = "parameter must be a number greater than 0")

	adjust_triumphs(ckey, amount, reason, counted = FALSE, silent = FALSE, override_bonus = TRUE)

	return "[ckey] awarded [amount] triumphs.  They now have [SStriumphs.get_triumphs(ckey)]."

#undef OLD_PLEXORA_CONFIG
#undef AUTH_HEADER
#undef TOPIC_EMITTER


/client
	///Internal counter for clients sending external (IRC/Discord) relay messages via ahelp to prevent spamming. Set to a number every time an admin reply is sent, decremented for every client send.
	var/externalreplyamount = 0

/// Takes an argument which could be either a ckey, /client, or IRC marker, and returns a client if possible
/// Returns [EXTERNAL_PM_USER] if an IRC marker is detected
/// Otherwise returns null
/proc/disambiguate_client(whom)
	if(istype(whom, /client))
		return whom

	if(!istext(whom) || !(length(whom) >= 1))
		return null

	var/searching_ckey = whom
	if(whom[1] == "@")
		searching_ckey = findTrueKey(whom)

	if(searching_ckey == EXTERNAL_PM_USER)
		return EXTERNAL_PM_USER

	return GLOB.directory[searching_ckey]

/// Takes a stealthed ckey as input, returns the true key it represents
/proc/findTrueKey(stealth_key)
	if(!stealth_key)
		return
	for(var/potentialKey in GLOB.stealthminID)
		if(GLOB.stealthminID[potentialKey] == stealth_key)
			return potentialKey


/client/proc/receive_ahelp(reply_to, message, span_class = "adminsay")
	to_chat(
		src,
		message = "<span class='[span_class]'>Admin PM from-<b>[reply_to]</b>: [message]</span>",
	)

/// This should match the interface of /client wherever necessary.
/datum/client_interface
	/// Player preferences datum for the client
	var/datum/preferences/prefs

	/// The view of the client, similar to /client/var/view.
	var/view = "15x15"

	/// Objects on the screen of the client
	var/list/screen = list()

	/// The mob the client controls
	var/mob/mob

	/// The ckey for this mock interface
	var/ckey = "mockclient"

	/// The key for this mock interface
	var/key = "mockclient"

	/// client prefs
	var/fps
	var/hotkeys
	var/tgui_say
	var/typing_indicators
	var/datum/interaction_mode/imode
	var/context_menu_requires_shift = FALSE

	///these persist between logins/logouts during the same round.
	var/datum/player_details/player_details
	var/reconnecting = FALSE

/datum/client_interface/proc/IsByondMember()
	return FALSE

/datum/client_interface/New(key)
	..()
	if(key)
		src.key = key
		ckey = ckey(key)
		if(GLOB.player_details[ckey])
			reconnecting = TRUE
			player_details = GLOB.player_details[ckey]
		else
			player_details = new(ckey)
			player_details.byond_version = world.byond_version
			player_details.byond_build = world.byond_build
			GLOB.player_details[ckey] = player_details

/datum/client_interface/proc/set_macros()
	return

/datum/client_interface/proc/set_right_click_menu_mode()
	return

/datum/client_interface/proc/is_afk(duration)
	return FALSE

/datum/client_interface/proc/punish_log(whom, punishment)
	var/msg = "[key_name_admin(src)] punished [key_name_admin(whom)] with [punishment]."
	message_admins(msg)
	admin_ticket_log(whom, msg)
	log_admin("[key_name(src)] punished [key_name(whom)] with [punishment].")

/datum/client_interface/proc/get_exp_living(pure_numeric = FALSE)
	if(!prefs?.exp?[EXP_TYPE_LIVING])
		return pure_numeric ? 0 : "No data"
	var/exp_living = text2num(prefs.exp[EXP_TYPE_LIVING])
	return pure_numeric ? exp_living : get_exp_format(exp_living)

/datum/client_interface/proc/operator""()
	return "[key]"

/// Gets TGS's stealth key, generates one if none is found
/proc/GetTgsStealthKey()
	var/static/tgsStealthKey
	if(tgsStealthKey)
		return tgsStealthKey

	tgsStealthKey = generateStealthCkey()
	GLOB.stealthminID[EXTERNAL_PM_USER] = tgsStealthKey
	return tgsStealthKey

/// Hands back a stealth ckey to use, guarenteed to be unique
/proc/generateStealthCkey()
	var/guess = rand(0, 1000)
	var/text_guess
	var/valid_found = FALSE
	while(valid_found == FALSE)
		valid_found = TRUE
		text_guess = "@[num2text(guess)]"
		// We take a guess at some number, and if it's not in the existing stealthmin list we exit
		for(var/key in GLOB.stealthminID)
			// If it is in the list tho, we up one number, and redo the loop
			if(GLOB.stealthminID[key] == text_guess)
				guess += 1
				valid_found = FALSE
				break

	return text_guess
