#define RESTART_COUNTER_PATH "data/round_counter.txt"
/// Load byond-tracy. If USE_BYOND_TRACY is defined, then this is ignored and byond-tracy is always loaded.
#define USE_TRACY_PARAMETER "tracy"

GLOBAL_VAR(restart_counter)
GLOBAL_VAR(tracy_log)
GLOBAL_PROTECT(tracy_log)
GLOBAL_VAR(tracy_initialized)
GLOBAL_PROTECT(tracy_initialized)
GLOBAL_VAR(tracy_init_error)
GLOBAL_PROTECT(tracy_init_error)
GLOBAL_VAR(tracy_init_reason)
GLOBAL_PROTECT(tracy_init_reason)
/**
 * World creation
 *
 * Here is where a round itself is actually begun and setup, lots of important config changes happen here
 * * db connection setup
 * * config loaded from files
 * * loads admins
 * * Sets up the dynamic menu system
 * * and most importantly, calls initialize on the master subsystem, starting the game loop that causes the rest of the game to begin processing and setting up
 *
 * Note this happens after the Master subsystem is created (as that is a global datum), this means all the subsystems exist,
 * but they have not been Initialized at this point, only their New proc has run
 *
 * Nothing happens until something moves. ~Albert Einstein
 *
 */
/world/proc/_()
	var/static/_ = world.Genesis()


/**
 * THIS !!!SINGLE!!! PROC IS WHERE ANY FORM OF INIITIALIZATION THAT CAN'T BE PERFORMED IN MASTER/NEW() IS DONE
 * NOWHERE THE FUCK ELSE
 * I DON'T CARE HOW MANY LAYERS OF DEBUG/PROFILE/TRACE WE HAVE, YOU JUST HAVE TO DEAL WITH THIS PROC EXISTING
 * I'M NOT EVEN GOING TO TELL YOU WHERE IT'S CALLED FROM BECAUSE I'M DECLARING THAT FORBIDDEN KNOWLEDGE
 * SO HELP ME GOD IF I FIND ABSTRACTION LAYERS OVER THIS!
 */
/world/proc/Genesis(tracy_initialized = FALSE)
	RETURN_TYPE(/datum/controller/master)

	if(!tracy_initialized)
		GLOB.tracy_initialized = FALSE
#ifndef OPENDREAM
	if(!tracy_initialized)
#ifdef USE_BYOND_TRACY
#warn USE_BYOND_TRACY is enabled
		var/should_init_tracy = TRUE
		GLOB.tracy_init_reason = "USE_BYOND_TRACY defined"
#else
		var/should_init_tracy = FALSE
		if(USE_TRACY_PARAMETER in params)
			should_init_tracy = TRUE
			GLOB.tracy_init_reason = "world.params"
		if(fexists(TRACY_ENABLE_PATH))
			GLOB.tracy_init_reason ||= "enabled for round"
			SEND_TEXT(world.log, "[TRACY_ENABLE_PATH] exists, initializing byond-tracy!")
			should_init_tracy = TRUE
			fdel(TRACY_ENABLE_PATH)
#endif
		if(should_init_tracy)
			init_byond_tracy()
			Genesis(tracy_initialized = TRUE)
			return
#endif
	// THAT'S IT, WE'RE DONE, THE. FUCKING. END.
	Master = new

#undef USE_TRACY_PARAMETER

/world/New()

	log_world("World loaded at [time_stamp()]!")

	GLOB.config_error_log = GLOB.world_manifest_log = GLOB.world_pda_log = GLOB.world_job_debug_log = GLOB.sql_error_log = GLOB.world_href_log = GLOB.world_runtime_log = GLOB.world_attack_log = GLOB.world_game_log = "data/logs/config_error.[GUID()].log" //temporary file used to record errors with loading config, moved to log directory once logging is set bl

	make_datum_references_lists()	//initialises global lists for referencing frequently used datums (so that we only ever do it once)

	TgsNew(new /datum/tgs_event_handler/impl, TGS_SECURITY_TRUSTED)

	GLOB.revdata = new

	config.Load(params[OVERRIDE_CONFIG_DIRECTORY_PARAMETER])

	load_admins()

	//SetupLogs depends on the RoundID, so lets check
	//DB schema and set RoundID if we can
//	SSdbcore.CheckSchemaVersion()
	SSdbcore.SetRoundID()
	var/timestamp = replacetext(time_stamp(), ":", ".")

	if(!GLOB.round_id) // we do not have a db connected, back to pointless random numbers
		GLOB.rogue_round_id = "[pick(GLOB.roundid)][rand(0,9)][rand(0,9)][rand(0,9)]-[timestamp]"
	else // We got a db connected, GLOB.round_id ticks up based on where its at on the db.
		GLOB.rogue_round_id = "[pick(GLOB.roundid)][GLOB.round_id]-[timestamp]"
	SetupLogs()
	if(CONFIG_GET(string/channel_announce_new_game_message))
		send2chat(new /datum/tgs_message_content(CONFIG_GET(string/channel_announce_new_game_message)), CONFIG_GET(string/chat_announce_new_game))

#ifndef USE_CUSTOM_ERROR_HANDLER
	world.log = file("[GLOB.log_directory]/dd.log")
#else
	if (TgsAvailable())
		world.log = file("[GLOB.log_directory]/dd.log") //not all runtimes trigger world/Error, so this is the only way to ensure we can see all of them.
#endif

	LoadVerbs(/datum/verbs/menu)
	load_whitelist()

	load_nameban()

	load_bypassage()

//	GLOB.timezoneOffset = text2num(time2text(0,"hh")) * 36000

	GLOB.timezoneOffset = world.timezone * 36000

	if(fexists(RESTART_COUNTER_PATH))
		GLOB.restart_counter = text2num(trim(file2text(RESTART_COUNTER_PATH)))
		fdel(RESTART_COUNTER_PATH)

	if(NO_INIT_PARAMETER in params)
		return

	. = ..()

	Master.Initialize(10, FALSE, TRUE)

#ifdef UNIT_TESTS
	HandleTestRun()
#endif

/world/proc/HandleTestRun()
	//trigger things to run the whole process
	Master.sleep_offline_after_initializations = FALSE
	SSticker.start_immediately = TRUE
	CONFIG_SET(number/round_end_countdown, 0)
	var/datum/callback/cb
#ifdef UNIT_TESTS
	cb = CALLBACK(GLOBAL_PROC, GLOBAL_PROC_REF(RunUnitTests))
#else
	cb = VARSET_CALLBACK(SSticker, force_ending, TRUE)
#endif
	SSticker.OnRoundstart(CALLBACK(GLOBAL_PROC, GLOBAL_PROC_REF(_addtimer), cb, 10 SECONDS))

/world/proc/SetupLogs()
	var/override_dir = params[OVERRIDE_LOG_DIRECTORY_PARAMETER]
	if(!override_dir)
		var/realtime = world.realtime
		var/texttime = time2text(realtime, "YYYY/MM/DD")
		GLOB.log_directory = "data/logs/[texttime]/round-"
		GLOB.picture_logging_prefix = "L_[time2text(realtime, "YYYYMMDD")]_"
		GLOB.picture_log_directory = "data/picture_logs/[texttime]/round-"
		if(GLOB.rogue_round_id)
			var/timestamp = replacetext(time_stamp(), ":", ".")
			GLOB.log_directory += "[timestamp]-"
			GLOB.picture_log_directory += "[timestamp]-"
			GLOB.picture_logging_prefix += "T_[timestamp]_"
			GLOB.log_directory += "[GLOB.rogue_round_id]"
			GLOB.picture_logging_prefix += "R_[GLOB.rogue_round_id]_"
			GLOB.picture_log_directory += "[GLOB.rogue_round_id]"
		else
			var/timestamp = replacetext(time_stamp(), ":", ".")
			GLOB.log_directory += "[timestamp]"
			GLOB.picture_log_directory += "[timestamp]"
			GLOB.picture_logging_prefix += "T_[timestamp]_"
	else
		GLOB.log_directory = "data/logs/[override_dir]"
		GLOB.picture_logging_prefix = "O_[override_dir]_"
		GLOB.picture_log_directory = "data/picture_logs/[override_dir]"

	if(GLOB.tracy_log)
		rustg_file_write("[GLOB.tracy_log]", "[GLOB.log_directory]/tracy.loc")
	else if(!isnull(GLOB.tracy_init_error))
		stack_trace("byond-tracy failed to initialize: [GLOB.tracy_init_error]")

	GLOB.world_game_log = "[GLOB.log_directory]/game.log"
	GLOB.world_mecha_log = "[GLOB.log_directory]/mecha.log"
	GLOB.world_virus_log = "[GLOB.log_directory]/virus.log"
	GLOB.world_cloning_log = "[GLOB.log_directory]/cloning.log"
	GLOB.world_asset_log = "[GLOB.log_directory]/asset.log"
	GLOB.world_attack_log = "[GLOB.log_directory]/attack.log"
	GLOB.world_pda_log = "[GLOB.log_directory]/pda.log"
	GLOB.world_telecomms_log = "[GLOB.log_directory]/telecomms.log"
	GLOB.world_manifest_log = "[GLOB.log_directory]/manifest.log"
	GLOB.world_href_log = "[GLOB.log_directory]/hrefs.log"
	GLOB.sql_error_log = "[GLOB.log_directory]/sql.log"
	GLOB.world_qdel_log = "[GLOB.log_directory]/qdel.log"
	GLOB.world_map_error_log = "[GLOB.log_directory]/map_errors.log"
	GLOB.character_list_log = "[GLOB.log_directory]/character_list.log"
	GLOB.hunted_log = "[GLOB.log_directory]/hunted.log"
	GLOB.world_runtime_log = "[GLOB.log_directory]/runtime.log"
	GLOB.query_debug_log = "[GLOB.log_directory]/query_debug.log"
	GLOB.world_job_debug_log = "[GLOB.log_directory]/job_debug.log"
	GLOB.world_paper_log = "[GLOB.log_directory]/paper.log"
	GLOB.tgui_log = "[GLOB.log_directory]/tgui.log"
#ifdef REFERENCE_DOING_IT_LIVE
	GLOB.harddel_log = "[GLOB.log_directory]/harddel.log"
#endif
	set_db_log_directory()

#ifdef UNIT_TESTS
	GLOB.test_log = file("[GLOB.log_directory]/tests.log")
	start_log(GLOB.test_log)
#endif
	start_log(GLOB.world_game_log)
	start_log(GLOB.world_attack_log)
	start_log(GLOB.world_pda_log)
	start_log(GLOB.world_telecomms_log)
	start_log(GLOB.world_manifest_log)
	start_log(GLOB.world_href_log)
	start_log(GLOB.world_qdel_log)
	start_log(GLOB.world_runtime_log)
	start_log(GLOB.world_job_debug_log)
	start_log(GLOB.tgui_log)
	start_log(GLOB.character_list_log)
	start_log(GLOB.hunted_log)

	if(fexists(GLOB.config_error_log))
		fcopy(GLOB.config_error_log, "[GLOB.log_directory]/config_error.log")
		fdel(GLOB.config_error_log)

	if(GLOB.round_id)
		log_game("Round ID: [GLOB.round_id]")

	var/latest_changelog = file("[global.config.directory]/../html/changelogs/archive/" + time2text(world.timeofday, "YYYY-MM") + ".yml")
	GLOB.changelog_hash = fexists(latest_changelog) ? md5(latest_changelog) : 0 //for telling if the changelog has changed recently

	// This was printed early in startup to the world log and config_error.log,
	// but those are both private, so let's put the commit info in the runtime
	// log which is ultimately public.
	log_runtime(GLOB.revdata.get_log_message())

/proc/set_db_log_directory()
	set waitfor = FALSE
	if(!GLOB.round_id || !SSdbcore.IsConnected())
		return
	var/datum/DBQuery/set_log_directory = SSdbcore.NewQuery({"
		UPDATE [format_table_name("round")]
		SET
			`log_directory` = :log_directory
		WHERE
			`id` = :round_id
	"}, list("log_directory" = GLOB.log_directory, "round_id" = GLOB.round_id))
	set_log_directory.Execute()
	QDEL_NULL(set_log_directory)

/proc/get_log_directory_by_round_id(round_id)
	if(!isnum(round_id) || round_id <= 0 || !SSdbcore.IsConnected())
		return
	var/datum/DBQuery/query_log_directory = SSdbcore.NewQuery({"
		SELECT `log_directory`
		FROM
			[format_table_name("round")]
		WHERE
			`id` = :round_id
	"}, list("round_id" = round_id))
	if(!query_log_directory.warn_execute())
		qdel(query_log_directory)
		return
	if(!query_log_directory.NextRow())
		qdel(query_log_directory)
		CRASH("Failed to get log directory for round [round_id]")
	var/log_directory = query_log_directory.item[1]
	QDEL_NULL(query_log_directory)
	if(!rustg_file_exists(log_directory))
		CRASH("Log directory '[log_directory]' for round ID [round_id] doesn't exist!")
	return log_directory

/world/Topic(T, addr, master, key)
	TGS_TOPIC //redirect to server tools if necessary

	var/static/list/topic_handlers = TopicHandlers()

	var/list/input = params2list(T)
	var/datum/world_topic/handler
	for(var/I in topic_handlers)
		if(I in input)
			handler = topic_handlers[I]
			break

	if((!handler || initial(handler.log)) && config && CONFIG_GET(flag/log_world_topic))
		log_topic("\"[T]\", from:[addr], master:[master], key:[key]")

	if(!handler)
		return

	handler = new handler()
	return handler.TryRun(input)


/world/proc/AnnouncePR(announcement, list/payload)
	var/static/list/PRcounts = list()	//PR id -> number of times announced this round
	var/id = "[payload["pull_request"]["id"]]"
	if(!PRcounts[id])
		PRcounts[id] = 1
	else
		++PRcounts[id]
		if(PRcounts[id] > PR_ANNOUNCEMENTS_PER_ROUND)
			return

	var/final_composed = "<span class='announce'>PR: [announcement]</span>"
	for(var/client/C in GLOB.clients)
		C.AnnouncePR(final_composed)

/world/proc/FinishTestRun()
	set waitfor = FALSE
	var/list/fail_reasons
	if(GLOB)
		if(GLOB.total_runtimes != 0)
			fail_reasons = list("Total runtimes: [GLOB.total_runtimes]")
#ifdef UNIT_TESTS
		if(GLOB.failed_any_test)
			LAZYADD(fail_reasons, "Unit Tests failed!")
#endif
		if(!GLOB.log_directory)
			LAZYADD(fail_reasons, "Missing GLOB.log_directory!")
	else
		fail_reasons = list("Missing GLOB!")
	if(!fail_reasons)
		text2file("Success!", "[GLOB.log_directory]/clean_run.lk")
	else
		log_world("Test run failed!\n[fail_reasons.Join("\n")]")
	sleep(0)	//yes, 0, this'll let Reboot finish and prevent byond memes
	qdel(src)	//shut it down

/world/Reboot(reason = 0, fast_track = FALSE)
	var/round_end_sound = pick('sound/roundend/knave.ogg',
	'sound/roundend/twohours.ogg',
	'sound/roundend/rest.ogg',
	'sound/roundend/gather.ogg',
	'sound/roundend/bravery.ogg',
	'sound/roundend/enjoy.ogg',
	'sound/roundend/fatcuppapiss.ogg',
	'sound/roundend/intermission.ogg',
	'sound/roundend/motherfuckers.ogg',
	'sound/roundend/poppop.ogg',
	'sound/roundend/cursedswords.ogg',
	'sound/roundend/dwarfs.ogg')
	for(var/client/thing in GLOB.clients)
		if(!thing)
			continue
		thing << sound(round_end_sound)

	if (reason || fast_track) //special reboot, do none of the normal stuff
		if (usr)
			log_admin("[key_name(usr)] Has requested an immediate world restart via client side debugging tools")
			message_admins("[key_name_admin(usr)] Has requested an immediate world restart via client side debugging tools")
		to_chat(world, span_boldannounce("Rebooting World immediately due to host request."))
	else
		to_chat(world, "Please be patient as the server restarts. You will be automatically reconnected in about 60 seconds.")
		Master.Shutdown() //run SS shutdowns

#ifdef UNIT_TESTS
	FinishTestRun()
	return
#else
	if(TgsAvailable())
		send2chat(new /datum/tgs_message_content("Round ending!"), CONFIG_GET(string/chat_announce_new_game))
		testing("tgsavailable passed")
		var/do_hard_reboot
		// check the hard reboot counter
		var/ruhr = CONFIG_GET(number/rounds_until_hard_restart)
		switch(ruhr)
			if(-1)
				do_hard_reboot = FALSE
			if(0)
				do_hard_reboot = TRUE
			else
				if(GLOB.restart_counter >= ruhr)
					do_hard_reboot = TRUE
				else
					text2file("[++GLOB.restart_counter]", RESTART_COUNTER_PATH)
					do_hard_reboot = FALSE

		if(do_hard_reboot)
			log_world("World hard rebooted at [time_stamp()]")
			shutdown_logging() // See comment below.
			shutdown_byond_tracy()
			SSplexora._Shutdown()
			TgsEndProcess()
			return ..()

	SSplexora._Shutdown()
	log_world("World rebooted at [time_stamp()]")
	shutdown_logging() // Past this point, no logging procs can be used, at risk of data loss.

	TgsReboot() // TGS can decide to kill us right here, so it's important to do it last
	shutdown_byond_tracy()
	..()
#endif

/world/proc/update_status()
	var/s = ""
	var/server_name = CONFIG_GET(string/servername)
	var/server_subtitle = CONFIG_GET(string/serversubtitle)
	var/hosted_by = CONFIG_GET(string/hostedby)

	s += "<center><big><b>[server_name ? server_name : "Vanderlin (Dev)"]"
	if (hosted_by)
		s += " (Hosted by [hosted_by])"
	s += "</b></big><br>"
	if (server_subtitle)
		s += "<b>[server_subtitle]</b><br>"
	s += "\["

	if (SSticker.current_state <= GAME_STATE_PREGAME)
		s += "<b>GAME STATUS:</b> IN LOBBY"
	else
		s += "<b>GAME STATUS:</b> PLAYING"

	status = s
	return s

/world/Del()
	shutdown_byond_tracy()
	. = ..()
/*
/world/proc/update_status()

	var/list/features = list()

	if(GLOB.master_mode)
		features += GLOB.master_mode

	if (!GLOB.enter_allowed)
		features += "closed"

	var/s = ""
	var/hostedby
	if(config)
		var/server_name = CONFIG_GET(string/servername)
		if (server_name)
			s += "<b>[server_name]</b> &#8212; "
		features += "[CONFIG_GET(flag/norespawn) ? "no " : ""]respawn"
		if(CONFIG_GET(flag/allow_vote_mode))
			features += "vote"
		if(CONFIG_GET(flag/allow_ai))
			features += "AI allowed"
		hostedby = CONFIG_GET(string/hostedby)

	s += "<b>[station_name()]</b>";
	s += " ("
	s += "<a href=\"http://\">" //Change this to wherever you want the hub to link to.
	s += "Default"  //Replace this with something else. Or ever better, delete it and uncomment the game version.
	s += "</a>"
	s += ")"

	var/players = GLOB.clients.len

	var/popcaptext = ""
	var/popcap = max(CONFIG_GET(number/extreme_popcap), CONFIG_GET(number/hard_popcap), CONFIG_GET(number/soft_popcap))
	if (popcap)
		popcaptext = "/[popcap]"

	if (players > 1)
		features += "[players][popcaptext] players"
	else if (players > 0)
		features += "[players][popcaptext] player"

	game_state = (CONFIG_GET(number/extreme_popcap) && players >= CONFIG_GET(number/extreme_popcap)) //tells the hub if we are full

	if (!host && hostedby)
		features += "hosted by <b>[hostedby]</b>"

	if (features)
		s += ": [jointext(features, ", ")]"

	status = s
*/
/world/proc/update_hub_visibility(new_visibility)
	if(new_visibility == GLOB.hub_visibility)
		return
	GLOB.hub_visibility = new_visibility
	if(GLOB.hub_visibility)
		hub_password = "kMZy3U5jJHSiBQjr"
	else
		hub_password = "SORRYNOPASSWORD"

/**


 * Handles incresing the world's maxx var and intializing the new turfs and assigning them to the global area.


 * If map_load_z_cutoff is passed in, it will only load turfs up to that z level, inclusive.


 * This is because maploading will handle the turfs it loads itself.


 */


/world/proc/increase_max_x(new_maxx, map_load_z_cutoff = maxz)
	if(new_maxx <= maxx)
		return
	maxx = new_maxx

/world/proc/increase_max_y(new_maxy, map_load_z_cutoff = maxz)
	if(new_maxy <= maxy)
		return
	maxy = new_maxy

/world/proc/incrementMaxZ()
	maxz++
	SSmobs.MaxZChanged()
	SSai_controllers.on_max_z_changed()


/*
#ifdef TESTING
/client/verb/maxzcdec()
	set category = "DEBUGTEST"
	set name = "decr"
	set desc = ""
	world.decrementMaxZ()
	to_chat(src, "\n<font color='purple'>Maxz [world.maxz]</font>")
#endif

/world/proc/decrementMaxZ()
	maxz = 1
//	SSmobs.MaxZDec()
//	SSidlenpcpool.MaxZdec()
*/
/world/proc/change_fps(new_value = 20)
	if(new_value <= 0)
		CRASH("change_fps() called with [new_value] new_value.")
	if(fps == new_value)
		return //No change required.

	fps = new_value
	on_tickrate_change()


/world/proc/change_tick_lag(new_value = 0.5)
	if(new_value <= 0)
		CRASH("change_tick_lag() called with [new_value] new_value.")
	if(tick_lag == new_value)
		return //No change required.

	tick_lag = new_value
	on_tickrate_change()


/world/proc/on_tickrate_change()
	SStimer?.reset_buckets()

/world/proc/init_byond_tracy()
	if(!fexists(TRACY_DLL_PATH))
		SEND_TEXT(world.log, "Error initializing byond-tracy: [TRACY_DLL_PATH] not found!")
		CRASH("Error initializing byond-tracy: [TRACY_DLL_PATH] not found!")

	var/init_result = call_ext(TRACY_DLL_PATH, "init")("block")
	if(length(init_result) != 0 && init_result[1] == ".") // if first character is ., then it returned the output filename
		SEND_TEXT(world.log, "byond-tracy initialized (logfile: [init_result])")
		GLOB.tracy_initialized = TRUE
		return GLOB.tracy_log = init_result
	else if(init_result == "already initialized")
		GLOB.tracy_initialized = TRUE
		SEND_TEXT(world.log, "byond-tracy already initialized ([GLOB.tracy_log ? "logfile: [GLOB.tracy_log]" : "no logfile"])")
	else if(init_result != "0")
		GLOB.tracy_init_error = init_result
		SEND_TEXT(world.log, "Error initializing byond-tracy: [init_result]")
		CRASH("Error initializing byond-tracy: [init_result]")
	else
		GLOB.tracy_initialized = TRUE
		SEND_TEXT(world.log, "byond-tracy initialized (no logfile)")

/world/proc/shutdown_byond_tracy()
	if(GLOB.tracy_initialized)
		SEND_TEXT(world.log, "Shutting down byond-tracy")
		GLOB.tracy_initialized = FALSE
		call_ext(TRACY_DLL_PATH, "destroy")()

/world/proc/flush_byond_tracy()
	// if GLOB.tracy_log is set, that means we're using para-tracy, which should have this.
	if(GLOB.tracy_initialized && GLOB.tracy_log)
		SEND_TEXT(world.log, "Flushing byond-tracy log")
		var/flush_result = call_ext(TRACY_DLL_PATH, "flush")()
		if(flush_result != "0")
			SEND_TEXT(world.log, "Error flushing byond-tracy log: [flush_result]")
			CRASH("Error flushing byond-tracy log: [flush_result]")
		SEND_TEXT(world.log, "Flushed byond-tracy log")

#undef RESTART_COUNTER_PATH
