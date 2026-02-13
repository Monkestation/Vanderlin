#define ROUND_START_MUSIC_LIST "strings/round_start_sounds.txt"
#define SS_TICKER_TRAIT "SS_Ticker"

/proc/low_memory_force_start()
	for(var/mob/dead/new_player/player as anything in GLOB.new_player_list)
		player.ready = PLAYER_READY_TO_PLAY

	SSticker.start_immediately = TRUE
	//SSticker.fire()
GLOBAL_VAR_INIT(round_timer, INITIAL_ROUND_TIMER)

SUBSYSTEM_DEF(ticker)
	name = "Ticker"
	init_order = INIT_ORDER_TICKER
	lazy_load = FALSE

	priority = FIRE_PRIORITY_TICKER
	flags = SS_KEEP_TIMING
	runlevels = RUNLEVEL_LOBBY | RUNLEVEL_SETUP | RUNLEVEL_GAME

	var/current_state = GAME_STATE_STARTUP	//state of current round (used by process()) Use the defines GAME_STATE_* !
	var/force_ending = 0					//Round was ended by admin intervention
	// If true, there is no lobby phase, the game starts immediately.
	var/start_immediately = FALSE
	var/setup_done = FALSE //All game setup done including mode post setup and

	var/login_music							//music played in pregame lobby
	var/round_end_sound						//music/jingle played when the world reboots
	var/round_end_sound_sent = TRUE			//If all clients have loaded it

	var/list/datum/mind/minds = list()		//The characters in the game. Used for objective tracking.

	var/delay_end = 0						//if set true, the round will not restart on it's own
	var/admin_delay_notice = ""				//a message to display to anyone who tries to restart the world after a delay
	var/ready_for_reboot = FALSE			//all roundend preparation done with, all that's left is reboot

	var/triai = 0							//Global holder for Triumvirate
	var/tipped = 0							//Did we broadcast the tip of the day yet?
	var/selected_tip						// What will be the tip of the day?

	var/timeLeft						//pregame timer
	var/start_at
	var/timeDelayAdd = 120
	//576000 dusk
	//376000 day
	var/gametime_offset = 288001		//Deciseconds to add to world.time for station time.
	var/station_time_rate_multiplier = 40		//factor of station time progressal vs real time.

	var/totalPlayers = 0					//used for pregame stats on statpanel
	var/totalPlayersReady = 0				//used for pregame stats on statpanel

	var/queue_delay = 0
	var/list/queued_players = list()		//used for join queues when the server exceeds the hard population cap

	var/maprotatechecked = 0

	var/news_report

	var/late_join_disabled

	var/roundend_check_paused = FALSE

	var/amt_ready = 0 // Total count of players that are ready
	var/amt_ready_needed = 1 // Total count of players that are needed ready to start the game

	var/round_start_time = 0
	var/round_start_irl = 0
	var/list/round_start_events
	var/list/round_end_events
	var/mode_result = "undefined"
	var/end_state = "undefined"
	var/job_change_locked = FALSE
	var/list/royals_readied = list()
	/// reports what the ruling mob is.
	var/mob/living/carbon/human/rulermob = null
	/// The appointed regent mob
	var/mob/living/carbon/human/regent_mob = null
	var/failedstarts = 0
	var/list/manualmodes = list()

	var/end_party = FALSE
	var/last_lobby = 0
	var/reboot_anyway

	var/next_lord_check = 0
	var/missing_lord_time = 0

	var/last_bot_update = 0

	var/list/no_ruler_lines = list(
		"Set a Ruler to 'high' in your class preferences to start the game!",
		"PLAY Ruler NOW!", "A Ruler is required to start.",
		"Pray for a Ruler.", "One day, there will be a Ruler.",
		"Just try playing Ruler.", "If you don't play Ruler, the game will never start.",
		"We need at least one Ruler to start the game.",
		"We're waiting for you to pick Ruler to start.",
		"Still no Ruler is readied..",
		"I'm going to lose my mind if we don't get a Ruler readied up.",
		"No. The game will not start because there is no Ruler.",
		"What's the point of Vanderlin without a Ruler?"
	)

	/// ID of round reboot timer, if it exists
	var/reboot_timer = null

/datum/controller/subsystem/ticker/Initialize(timeofday)
	load_mode()

	var/list/byond_sound_formats = list(
		"mid"  = TRUE,
		"midi" = TRUE,
		"mod"  = TRUE,
		"it"   = TRUE,
		"s3m"  = TRUE,
		"xm"   = TRUE,
		"oxm"  = TRUE,
		"wav"  = TRUE,
		"ogg"  = TRUE,
		"raw"  = TRUE,
		"wma"  = TRUE,
		"aiff" = TRUE
	)

	var/list/provisional_title_music = flist("[global.config.directory]/title_music/sounds/")
	var/list/music = list()
	var/use_rare_music = prob(1)

	for(var/S in provisional_title_music)
		var/lower = lowertext(S)
		var/list/L = splittext(lower,"+")
		switch(L.len)
			if(3) //rare+MAP+sound.ogg or MAP+rare.sound.ogg -- Rare Map-specific sounds
				if(use_rare_music)
					if(L[1] == "rare" && L[2] == SSmapping.config.map_name)
						music += S
					else if(L[2] == "rare" && L[1] == SSmapping.config.map_name)
						music += S
			if(2) //rare+sound.ogg or MAP+sound.ogg -- Rare sounds or Map-specific sounds
				if((use_rare_music && L[1] == "rare") || (L[1] == SSmapping.config.map_name))
					music += S
			if(1) //sound.ogg -- common sound
				if(L[1] == "exclude")
					continue
				music += S

//	var/old_login_music = trim(file2text("data/last_round_lobby_music.txt"))
//	if(music.len > 1)
//		music -= old_login_music

	for(var/S in music)
		var/list/L = splittext(S,".")
		if(L.len >= 2)
			var/ext = lowertext(L[L.len]) //pick the real extension, no 'honk.ogg.exe' nonsense here
			if(byond_sound_formats[ext])
				continue
		music -= S

	if(isemptylist(music))
		music = world.file2list(ROUND_START_MUSIC_LIST, "\n")
		login_music = pick(music)
	else
		login_music = "[global.config.directory]/title_music/sounds/[pick(music)]"

	login_music = pick('sound/music/title.ogg','sound/music/title2.ogg','sound/music/title3.ogg')

	start_at = world.time + (CONFIG_GET(number/lobby_countdown) * 10)
	if(CONFIG_GET(flag/randomize_shift_time))
		gametime_offset = rand(0, 23) HOURS
	else if(CONFIG_GET(flag/shift_time_realtime))
		gametime_offset = world.timeofday
	return ..()

/datum/controller/subsystem/ticker/fire()
	if(reboot_anyway)
		if(world.time > reboot_anyway)
			force_ending = TRUE
			reboot_anyway = null
	switch(current_state)
		if(GAME_STATE_STARTUP)
			for(var/client/C in GLOB.clients)
				window_flash(C, ignorepref = TRUE) //let them know lobby has opened up.
			current_state = GAME_STATE_PREGAME
			SEND_SIGNAL(src, COMSIG_TICKER_ENTER_PREGAME)
			fire()
		if(GAME_STATE_PREGAME)
			//lobby stats for statpanels
			if(isnull(timeLeft))
				timeLeft = max(0,start_at - world.time)
			totalPlayers = LAZYLEN(GLOB.new_player_list)
			totalPlayersReady = 0
			for(var/mob/dead/new_player/player as anything in GLOB.new_player_list)
				if(player.ready == PLAYER_READY_TO_PLAY)
					++totalPlayersReady

			readying_update_scale_job()
			if(start_immediately)
				timeLeft = 0

			//countdown
			if(timeLeft < 0)
				return
			timeLeft -= wait

			if(timeLeft <= 300 && !tipped)
				send_tip_of_the_round()
				tipped = TRUE

			if(timeLeft <= 0)
				if(!checkreqroles())
					current_state = GAME_STATE_STARTUP
					start_at = world.time + timeDelayAdd
					timeLeft = null
					Master.SetRunLevel(RUNLEVEL_LOBBY)
				else
					send2chat(new /datum/tgs_message_content("New round starting on Vanderlin!"), CONFIG_GET(string/chat_announce_new_game))
					SEND_SIGNAL(src, COMSIG_TICKER_ENTER_SETTING_UP)
					current_state = GAME_STATE_SETTING_UP
					Master.SetRunLevel(RUNLEVEL_SETUP)
					if(start_immediately)
						fire()

		if(GAME_STATE_SETTING_UP)
			if(!setup())
				//setup failed
				current_state = GAME_STATE_STARTUP
				start_at = world.time + timeDelayAdd
				timeLeft = null
				Master.SetRunLevel(RUNLEVEL_LOBBY)
				SEND_SIGNAL(src, COMSIG_TICKER_ERROR_SETTING_UP)

		if(GAME_STATE_PLAYING)
			check_queue()
			check_maprotate()

			check_for_lord()
			if(!roundend_check_paused && SSgamemode.check_finished(force_ending) || force_ending)
				SSgamemode.refresh_alive_stats()
				current_state = GAME_STATE_FINISHED
				toggle_ooc(TRUE) // Turn it on
				toggle_dooc(TRUE)
				declare_completion(force_ending)
				Master.SetRunLevel(RUNLEVEL_POSTGAME)
			if(SSgamemode.roundvoteend)
				return

/datum/controller/subsystem/ticker/proc/readying_update_scale_job()

	//Get ALL town jobs
	var/list/town_jobs = list()
	for(var/datum/job/J as anything in SSjob.joinable_occupations)
		if (J.faction == FACTION_TOWN)
			town_jobs += J.title

	//Now find players who readied with HIGH preference on those town jobs
	var/list/town_ready = list()

	for(var/mob/dead/new_player/player in GLOB.player_list)
		if(!player || !player.client)
			continue

		if(player.ready != PLAYER_READY_TO_PLAY)
			continue

		//Loop through each job the player has set to HIGH
		for(var/job_name in player.client.prefs.job_preferences)
			if(player.client.prefs.job_preferences[job_name] != JP_HIGH)
				continue

			//Only count if it is a town job
			if(!(job_name in town_jobs))
				continue

			//Check job availability rules
			if(player.client.prefs.lastclass == job_name)
				if (player.IsJobUnavailable(job_name) != JOB_AVAILABLE)
					continue

			//Add to the list
			town_ready += job_name

	var/ready_town_count = length(town_ready)

	for(var/datum/job/job_to_set in SSjob.joinable_occupations)
		if(job_to_set.enabled && job_to_set.scales)
			job_to_set.set_spawn_and_total_positions(ready_town_count)


/datum/controller/subsystem/ticker/proc/checkreqroles()
	var/list/readied_jobs = list()
	var/list/required_jobs = list("Monarch")
#ifdef TESTING
	required_jobs = list()
	readied_jobs = list("Monarch")
#endif
	for(var/V in required_jobs)
		for(var/mob/dead/new_player/player in GLOB.player_list)
			if(!player || !player.client)
				stack_trace("somehow [player] doesn't have a client, wtf?")
				continue
			if(player.client.prefs.job_preferences[V] == JP_HIGH)
				if(player.ready == PLAYER_READY_TO_PLAY)
					if(player.client.prefs.lastclass == V)
						if(player.IsJobUnavailable(V) != JOB_AVAILABLE)
							to_chat(player, span_warning("You cannot be [V] and thus are not considered."))
							continue
					readied_jobs.Add(V)

	if(CONFIG_GET(flag/ruler_required))
		if(!(("Monarch" in readied_jobs) || (start_immediately == TRUE))) //start_immediately triggers when the world is doing a test run or an admin hits start now, we don't need to check for king
			to_chat(world, span_purple("[pick(no_ruler_lines)]"))
			return FALSE

	job_change_locked = TRUE
	return TRUE

/datum/controller/subsystem/ticker/proc/setup()
	message_admins(span_boldannounce("Starting game..."))
	var/init_start = world.timeofday

	CHECK_TICK
	//Configure mode and assign player to special mode stuff
	var/can_continue = 0

	CHECK_TICK

	can_continue =	SSgamemode.pre_setup()

	CHECK_TICK

	can_continue = can_continue && SSjob.DivideOccupations(list()) 				//Distribute jobs
	CHECK_TICK

	log_game("GAME SETUP: Divide Occupations success")

	CHECK_TICK

	if(!CONFIG_GET(flag/ooc_during_round))
		toggle_ooc(FALSE) // Turn it off

	CHECK_TICK
	GLOB.start_landmarks_list = shuffle(GLOB.start_landmarks_list) //Shuffle the order of spawn points so they dont always predictably spawn bottom-up and right-to-left

	create_characters() //Create player characters
	log_game("GAME SETUP: create characters success")
	collect_minds()
	log_game("GAME SETUP: collect minds success")
	equip_characters()
	log_game("GAME SETUP: equip characters success")
	transfer_characters()	//transfer keys to the new mobs
	log_game("GAME SETUP: transfer characters success")

	for(var/datum/callback/cb as anything in round_start_events)
		cb.InvokeAsync()

	log_game("GAME SETUP: round start events success")
	LAZYCLEARLIST(round_start_events)
	CHECK_TICK

	log_game("GAME SETUP: Game start took [(world.timeofday - init_start)/10]s")
	message_admins("GAME SETUP: Game start took [(world.timeofday - init_start)/10]s")

	round_start_time = world.time
	SEND_SIGNAL(src, COMSIG_TICKER_ROUND_STARTING, world.time)
	round_start_irl = REALTIMEOFDAY

	INVOKE_ASYNC(SSdbcore, TYPE_PROC_REF(/datum/controller/subsystem/dbcore, SetRoundStart))

	message_admins(span_boldnotice("Welcome to [SSmapping.config.map_name]!"))

	for(var/client/C in GLOB.clients)
		if(!C?.mob)
			continue
		if(C.mob == SSticker.rulermob)
			C.mob.playsound_local(C.mob, 'sound/misc/royal_roundstart.ogg', 100, FALSE)
		else
			C.mob.playsound_local(C.mob, 'sound/misc/roundstart.ogg', 100, FALSE)

	for(var/datum_type in SStriumphs.communal_pools)
		var/datum/triumph_buy/communal/preround/triumph_buy_preround = locate(datum_type) in SStriumphs.triumph_buy_datums
		if(triumph_buy_preround && istype(triumph_buy_preround))
			triumph_buy_preround.check_refund()

	current_state = GAME_STATE_PLAYING

	Master.SetRunLevel(RUNLEVEL_GAME)

// only reason I haven't removed this is we could use this.
/*
	if(SSevents.holidays)
		to_chat(world, "<span class='notice'>and...</span>")
		for(var/holidayname in SSevents.holidays)
			var/datum/holiday/holiday = SSevents.holidays[holidayname]
			to_chat(world, "<h4>[holiday.greet()]</h4>")
*/

	PostSetup()
	INVOKE_ASYNC(world, TYPE_PROC_REF(/world, flush_byond_tracy))
	log_game("GAME SETUP: postsetup success")

	return TRUE

/datum/controller/subsystem/ticker/proc/PostSetup()
	set waitfor = FALSE

	SSgamemode.current_storyteller?.process(STORYTELLER_WAIT_TIME * 0.1) // we want this asap
	SSgamemode.current_storyteller?.round_started = TRUE

	setup_done = TRUE

	job_change_locked = FALSE

	SStriumphs.fire_on_PostSetup()
	for(var/obj/effect/landmark/start/S in GLOB.start_landmarks_list)
		if(istype(S))							//we can not runtime here. not in this important of a proc.
			S.after_round_start()
		else
			stack_trace("[S] [S.type] found in start landmarks list, which isn't a start landmark!")
	SSgamemode.refresh_alive_stats(first_post_roundstart_check = TRUE)

//These callbacks will fire after roundstart key transfer
/datum/controller/subsystem/ticker/proc/OnRoundstart(datum/callback/cb)
	if(!HasRoundStarted())
		LAZYADD(round_start_events, cb)
	else
		cb.InvokeAsync()

/datum/controller/subsystem/ticker/proc/create_characters()
	for(var/mob/dead/new_player/player as anything in GLOB.new_player_list)
		if(!player)
			stack_trace("There is a null in the player list, report it to the developers!")
			message_admins("There is a null in the player list, report it to the developers!")
			continue
		if(!player.mind)
			stack_trace("There is a mind lacking a player in the new_player_list, report it to the developers!")
			message_admins("There is a mind lacking a player in the new_player_list, report it to the developers!")
			continue
		if(player.ready == PLAYER_READY_TO_PLAY)
			GLOB.joined_player_list += player.ckey
			var/atom/destination = player.mind.assigned_role.get_roundstart_spawn_point()
			if(!destination) // Failed to fetch a proper roundstart location, won't be going anywhere.
				continue
			player.create_character(destination)
		CHECK_TICK

/datum/controller/subsystem/ticker/proc/collect_minds()
	for(var/mob/dead/new_player/P as anything in GLOB.new_player_list)
		if(P.new_character && P.new_character.mind)
			SSticker.minds += P.new_character.mind
		CHECK_TICK

/datum/controller/subsystem/ticker/proc/equip_characters()
	for(var/mob/dead/new_player/new_player_mob as anything in GLOB.new_player_list)
		if(!isliving(new_player_mob.new_character))
			CHECK_TICK
			continue
		var/mob/living/carbon/human/new_player_living = new_player_mob.new_character
		if(!new_player_living.mind || is_unassigned_job(new_player_living.mind.assigned_role))
			CHECK_TICK
			continue
		var/datum/job/player_assigned_role = new_player_living.mind.assigned_role
		if(player_assigned_role.job_flags & JOB_EQUIP_RANK)
			SSjob.EquipRank(new_player_living, player_assigned_role, new_player_mob.client)
		CHECK_TICK

/datum/controller/subsystem/ticker/proc/transfer_characters()
	var/list/livings = list()
	for(var/mob/dead/new_player/player as anything in GLOB.new_player_list)
		var/mob/living = player.transfer_character()
		if(living)
			qdel(player)
			ADD_TRAIT(living, TRAIT_NO_TRANSFORM, SS_TICKER_TRAIT)
			livings += living
			GLOB.character_ckey_list[living.real_name] = living.ckey
		if(ishuman(living))
			try_apply_character_post_equipment(living)

	if(livings.len)
		addtimer(CALLBACK(src, PROC_REF(release_characters), livings), 30, TIMER_CLIENT_TIME)

/datum/controller/subsystem/ticker/proc/release_characters(list/livings)
	for(var/mob/living/L as anything in livings)
		REMOVE_TRAIT(L, TRAIT_NO_TRANSFORM, SS_TICKER_TRAIT)


/datum/controller/subsystem/ticker/proc/send_tip_of_the_round()
/*	var/m
	if(selected_tip)
		m = selected_tip
	else
		var/list/randomtips = world.file2list("strings/tips.txt")
//		var/list/memetips = world.file2list("strings/sillytips.txt")
//		if(randomtips.len && prob(95))
		m = pick(randomtips)
//		else if(memetips.len)
//			m = pick(memetips)
	if(m)
		to_chat(world, "<span class='purple'>Before we begin, remember: [html_encode(m)]</span>")
*/
/datum/controller/subsystem/ticker/proc/check_queue()
	if(!queued_players.len)
		return
	var/hpc = CONFIG_GET(number/hard_popcap)
	if(!hpc)
		listclearnulls(queued_players)
		for (var/mob/dead/new_player/NP in queued_players)
			to_chat(NP, span_danger("The alive players limit has been released!<br><a href='byond://?src=[REF(NP)];late_join=override'>[html_encode(">>Join Game<<")]</a>"))
			SEND_SOUND(NP, sound('sound/blank.ogg'))
			NP.LateChoices()
		queued_players.len = 0
		queue_delay = 0
		return

	queue_delay++
	var/mob/dead/new_player/next_in_line = queued_players[1]

	switch(queue_delay)
		if(5) //every 5 ticks check if there is a slot available
			listclearnulls(queued_players)
			if(living_player_count() < hpc)
				if(next_in_line && next_in_line.client)
					to_chat(next_in_line, "<span class='danger'>A slot has opened! You have approximately 20 seconds to join. <a href='byond://?src=[REF(next_in_line)];late_join=override'>\>\>Join Game\<\<</a></span>")
					SEND_SOUND(next_in_line, sound('sound/blank.ogg'))
					next_in_line.LateChoices()
					return
				queued_players -= next_in_line //Client disconnected, remove he
			queue_delay = 0 //No vacancy: restart timer
		if(25 to INFINITY)  //No response from the next in line when a vacancy exists, remove he
			to_chat(next_in_line, "<span class='danger'>No response received. You have been removed from the line.</span>")
			queued_players -= next_in_line
			queue_delay = 0

/datum/controller/subsystem/ticker/proc/check_maprotate()
	if (!CONFIG_GET(flag/maprotation))
		return
	if (maprotatechecked)
		return

	maprotatechecked = 1

	//map rotate chance defaults to 75% of the length of the round (in minutes)
	if (!prob((world.time/600)*CONFIG_GET(number/maprotatechancedelta)))
		return
	INVOKE_ASYNC(SSmapping, TYPE_PROC_REF(/datum/controller/subsystem/mapping, maprotate))

/datum/controller/subsystem/ticker/proc/HasRoundStarted()
	return current_state >= GAME_STATE_PLAYING

/datum/controller/subsystem/ticker/proc/IsRoundInProgress()
	return current_state == GAME_STATE_PLAYING

/datum/controller/subsystem/ticker/Recover()
	current_state = SSticker.current_state
	force_ending = SSticker.force_ending

	login_music = SSticker.login_music
	round_end_sound = SSticker.round_end_sound

	minds = SSticker.minds

	delay_end = SSticker.delay_end

	triai = SSticker.triai
	tipped = SSticker.tipped
	selected_tip = SSticker.selected_tip

	timeLeft = SSticker.timeLeft

	totalPlayers = SSticker.totalPlayers
	totalPlayersReady = SSticker.totalPlayersReady

	queue_delay = SSticker.queue_delay
	queued_players = SSticker.queued_players
	maprotatechecked = SSticker.maprotatechecked
	round_start_time = SSticker.round_start_time
	round_start_irl = SSticker.round_start_irl

	queue_delay = SSticker.queue_delay
	queued_players = SSticker.queued_players
	maprotatechecked = SSticker.maprotatechecked

	switch (current_state)
		if(GAME_STATE_SETTING_UP)
			Master.SetRunLevel(RUNLEVEL_SETUP)
		if(GAME_STATE_PLAYING)
			Master.SetRunLevel(RUNLEVEL_GAME)
		if(GAME_STATE_FINISHED)
			Master.SetRunLevel(RUNLEVEL_POSTGAME)

/datum/controller/subsystem/ticker/proc/GetTimeLeft()
	if(isnull(SSticker.timeLeft))
		return max(0, start_at - world.time)
	return timeLeft

/datum/controller/subsystem/ticker/proc/SetTimeLeft(newtime)
	if(newtime >= 0 && isnull(timeLeft))	//remember, negative means delayed
		start_at = world.time + newtime
	else
		timeLeft = newtime

/datum/controller/subsystem/ticker/proc/load_mode()
	var/mode = trim(file2text("data/mode.txt"))
	if(mode)
		GLOB.master_mode = mode
	else
		GLOB.master_mode = "extended"
	log_game("Saved mode is '[GLOB.master_mode]'")

/datum/controller/subsystem/ticker/proc/save_mode(the_mode)
	var/F = file("data/mode.txt")
	fdel(F)
	WRITE_FILE(F, the_mode)

/datum/controller/subsystem/ticker/proc/SetRoundEndSound(the_sound)
	set waitfor = FALSE
	round_end_sound_sent = FALSE
	round_end_sound = fcopy_rsc(the_sound)
	for(var/thing in GLOB.clients)
		var/client/C = thing
		if (!C)
			continue
		C.Export("##action=load_rsc", round_end_sound)
	round_end_sound_sent = TRUE

/datum/controller/subsystem/ticker/proc/Reboot(reason, end_string, delay)
	set waitfor = FALSE
	if(usr && !check_rights(R_SERVER, TRUE))
		return

	if(!delay)
		delay = CONFIG_GET(number/round_end_countdown) * 10

	var/skip_delay = check_rights()
	if(delay_end && !skip_delay)
		to_chat(world, span_boldannounce("An admin has delayed the round end."))
		return

	to_chat(world, span_boldannounce("Rebooting World in [DisplayTimeText(delay)]. [reason]"))

	var/statspage = CONFIG_GET(string/roundstatsurl)
	var/gamelogloc = CONFIG_GET(string/gamelogurl)
	if(statspage)
		to_chat(world, span_info("Round statistics and logs can be viewed <a href=\"[statspage][GLOB.round_id]\">at this website!</a>"))
	else if(gamelogloc)
		to_chat(world, span_info("Round logs can be located <a href=\"[gamelogloc]\">at this website!</a>"))

	var/start_wait = world.time
	UNTIL(round_end_sound_sent || (world.time - start_wait) > (delay * 2)) //don't wait forever
	reboot_timer = addtimer(CALLBACK(src, PROC_REF(reboot_callback), reason, end_string), delay - (world.time - start_wait), TIMER_STOPPABLE)

/datum/controller/subsystem/ticker/proc/reboot_callback(reason, end_string)
	if(end_string)
		end_state = end_string

	SStriumphs.end_triumph_saving_time()

	log_game(span_boldannounce("Rebooting World. [reason]"))

	world.Reboot()

/**
 * Deletes the current reboot timer and nulls the var
 *
 * Arguments:
 * * user - the user that cancelled the reboot, may be null
 */
/datum/controller/subsystem/ticker/proc/cancel_reboot(mob/user)
	if(!reboot_timer)
		to_chat(user, span_warning("There is no pending reboot!"))
		return FALSE
	to_chat(world, span_boldannounce("An admin has delayed the round end."))
	deltimer(reboot_timer)
	reboot_timer = null
	return TRUE

/datum/controller/subsystem/ticker/Shutdown()
	save_admin_data()
	update_everything_flag_in_db()

	text2file(login_music, "data/last_round_lobby_music.txt")

#undef ROUND_START_MUSIC_LIST
#undef SS_TICKER_TRAIT
