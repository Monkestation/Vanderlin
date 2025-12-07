//this datum is used by the events controller to dictate how it selects events
/datum/round_event_control
	var/name						//The human-readable name of the event
	var/typepath					//The typepath of the event datum /datum/round_event

	var/weight = 10					//The weight this event has in the random-selection process.
									//Higher weights are more likely to be picked.
									//10 is the default weight. 20 is twice more likely; 5 is half as likely as this default.
									//0 here does NOT disable the event, it just makes it extremely unlikely

	var/earliest_start = 10 MINUTES	//The earliest world.time that an event can start (round-duration in deciseconds) default: 10 mins
	var/min_players = 0				//The minimum amount of alive, non-AFK human players on server required to start the event.

	/// How many times this event has occured
	var/occurrences = 0
	/// The maximum number of times this event can occur (naturally), it can still be forced. By setting this to 0 you can effectively disable an event.
	var/max_occurrences = 20
	/// Loaded occurrences from the last round events
	var/last_round_occurrences = 0

	var/holidayID = ""				//string which should be in the SSeventss.holidays list if you wish this event to be holiday-specific
									//anything with a (non-null) holidayID which does not match holiday, cannot run.
	var/wizardevent = FALSE
	var/alert_observers = FALSE		//should we let the ghosts and admins know this event is firing
									//should be disabled on events that fire a lot

	var/list/gamemode_blacklist = list() // Event won't happen in these gamemodes
	var/list/gamemode_whitelist = list() // Event will happen ONLY in these gamemodes if not empty

	var/triggering	//admin cancellation

	var/req_omen = FALSE
	var/list/todreq

	///do we check against the antag cap before attempting a spawn?
	var/checks_antag_cap = FALSE
	/// List of enemy roles, will check if x amount of these exist exist
	var/list/enemy_roles
	///required number of enemies in roles to exist
	var/required_enemies = 0

	/// The typepath to the event group this event is a part of.
	var/datum/event_group/event_group = null
	var/roundstart = FALSE
	var/cost = 1
	var/reoccurence_penalty_multiplier = 0.75
	var/shared_occurence_type
	var/track = EVENT_TRACK_MODERATE
	/// Last calculated weight that the storyteller assigned this event
	var/calculated_weight = 0
	var/tags = list() 	/// Tags of the event
	/// List of the shared occurence types.
	var/list/shared_occurences = list()
	/// Whether a roundstart event can happen post roundstart. Very important for events which override job assignments.
	var/can_run_post_roundstart = TRUE
	/// If set then the type or list of types of storytellers we are restricted to being trigged by
	var/list/allowed_storytellers
	/// List of storytellers that will pick only their dedicated and general events in some cases, like when they are ascendant
	var/list/dedicated_storytellers

/datum/round_event_control/proc/valid_for_map()
	return TRUE

/datum/round_event_control/proc/return_failure_string(players_amt)
	var/string
	if(roundstart && (world.time-SSticker.round_start_time >= 2 MINUTES))
		string += "Roundstart"
	if(length(allowed_storytellers) && !(SSgamemode.current_storyteller.type in allowed_storytellers))
		if(string)
			string += ", "
		string += "Wrong God"
	if(length(todreq) && !(GLOB.tod in todreq))
		if(string)
			string += ", "
		string += "Wrong Time of Day"
	if(occurrences >= max_occurrences)
		if(string)
			string += ", "
		string += "Cap Reached"
	if(earliest_start > max(world.time - SSticker.round_start_time, 0))
		if(string)
			string += ", "
		string +="Too Soon"
	if(players_amt < min_players)
		if(string)
			string += ", "
		string += "Lack of players"
	if(checks_antag_cap)
		if(!roundstart && !SSgamemode.can_inject_antags())
			if(string)
				string += ", "
			string += "Too Many Villians"
	return string

/datum/round_event_control/New()
	if(config && !wizardevent) // Magic is unaffected by configs
		earliest_start = CEILING(earliest_start * CONFIG_GET(number/events_min_time_mul), 1)
		min_players = CEILING(min_players * CONFIG_GET(number/events_min_players_mul), 1)

/datum/round_event_control/wizard
	wizardevent = TRUE

/// Checks if the event can be spawned. Used by event controller and "false alarm" event. Admin-created events override this.
/datum/round_event_control/proc/canSpawnEvent(players_amt, gamemode, fake_check = FALSE)
	if(SSgamemode.current_storyteller?.disable_distribution || SSgamemode.halted_storyteller)
		return FALSE
	if(event_group && !GLOB.event_groups[event_group].can_run())
		return FALSE
	if(roundstart && (!SSgamemode.can_run_roundstart || (SSgamemode.ran_roundstart && !fake_check && !SSgamemode.current_storyteller?.ignores_roundstart)))
		return FALSE

	if(occurrences >= max_occurrences)
		return FALSE
	if(earliest_start > max(world.time - SSticker.round_start_time, 0))
		return FALSE

	if(wizardevent != SSevents.wizardmode)
		return FALSE
	if(players_amt < min_players)
		return FALSE
	if(length(todreq) && !(GLOB.tod in todreq))
		return FALSE

	if(length(allowed_storytellers))
		if(!(SSgamemode.current_storyteller.type in allowed_storytellers))
			return FALSE
	if(length(dedicated_storytellers))
		if(SSgamemode.current_storyteller.ascendant)
			if(!(SSgamemode.current_storyteller.type in dedicated_storytellers))
				return FALSE

	if(req_omen)
		if(!GLOB.badomens.len)
			return FALSE
	if(!name)
		return FALSE

	return TRUE

/datum/round_event_control/proc/preRunEvent()
	if(!ispath(typepath, /datum/round_event))
		return EVENT_CANT_RUN

	triggering = TRUE
	if (alert_observers)
		message_admins("Random Event triggering in 10 seconds: [name] (<a href='byond://?src=[REF(src)];cancel=1'>CANCEL</a>)")
		sleep(100)
		var/players_amt = get_active_player_count(alive_check = TRUE, afk_check = TRUE, human_check = TRUE)
		if(!canSpawnEvent(players_amt, null, fake_check = TRUE))
			message_admins("Second pre-condition check for [name] failed, skipping...")
			return EVENT_INTERRUPTED

	if(!triggering)
		return EVENT_CANCELLED	//admin cancelled

	if(req_omen)
		if(!GLOB.badomens.len)
			return EVENT_CANCELLED
		badomen(pick_n_take(GLOB.badomens))

	triggering = FALSE

	return EVENT_READY

/datum/round_event_control/Topic(href, href_list)
	..()

	if(!check_rights(NONE))
		return

	if(href_list["cancel"])
		if(!triggering)
			to_chat(usr, "<span class='admin'>I am too late to cancel that event</span>")
			return
		triggering = FALSE
		message_admins("[key_name_admin(usr)] cancelled event [name].")
		log_admin_private("[key_name(usr)] cancelled event [name].")
		SSblackbox.record_feedback("tally", "event_admin_cancelled", 1, typepath)

/datum/round_event_control/proc/runEvent(random = FALSE, admin_forced = TRUE)
	var/datum/round_event/round_event = new typepath(TRUE, src)

	round_event.setup()
	round_event.current_players = get_active_player_count(alive_check = 1, afk_check = 1, human_check = 1)
	round_event.control = src
	occurrences++

	triggering = FALSE
	log_game("[random ? "Random" : "Forced"] Event triggering: [name] ([typepath]).")

	if(event_group)
		GLOB.event_groups[event_group].on_run(src)


	SSblackbox.record_feedback("tally", "event_ran", 1, "[name]")
	return round_event


//Special admins setup
/datum/round_event_control/proc/admin_setup()
	return

/datum/round_event	//NOTE: Times are measured in master controller ticks!
	var/processing = TRUE
	var/datum/round_event_control/control

	var/startWhen		= 0	//When in the lifetime to call start().
	var/announceWhen	= 0	//When in the lifetime to call announce(). If you don't want it to announce use announceChance, below.
	var/announceChance	= 100 // Probability of announcing, used in prob(), 0 to 100, default 100. Used in ion storms currently.
	var/endWhen			= 0	//When in the lifetime the event should end.

	var/activeFor		= 0	//How long the event has existed. You don't need to change this.
	var/current_players	= 0 //Amount of of alive, non-AFK human players on server at the time of event start
	var/fakeable = FALSE		//Can be faked by fake news event.

	/// Whether the event called its start() yet or not.
	var/has_started = FALSE
	///have we finished setup?
	var/setup = FALSE

//Called first before processing.
//Allows you to setup your event, such as randomly
//setting the startWhen and or announceWhen variables.
//Only called once.
//EDIT: if there's anything you want to override within the new() call, it will not be overridden by the time this proc is called.
//It will only have been overridden by the time we get to announce() start() tick() or end() (anything but setup basically).
//This is really only for setting defaults which can be overridden later when New() finishes.
/datum/round_event/proc/setup()
	SHOULD_CALL_PARENT(FALSE)
	setup = TRUE
	return

//Called when the tick is equal to the startWhen variable.
//Allows you to start before announcing or vice versa.
//Only called once.
/datum/round_event/proc/start()
	return

//Called after something followable has been spawned by an event
//Provides ghosts a follow link to an atom if possible
//Only called once.
/datum/round_event/proc/announce_to_ghosts(atom/atom_of_interest)
	if(control.alert_observers)
		if (atom_of_interest)
//			notify_ghosts("[control.name] has an object of interest: [atom_of_interest]!", source=atom_of_interest, action=NOTIFY_ORBIT, header="Something's Interesting!")
			return
	return

//Called when the tick is equal to the announceWhen variable.
//Allows you to announce before starting or vice versa.
//Only called once.
/datum/round_event/proc/announce(fake)
	return

//Called on or after the tick counter is equal to startWhen.
//You can include code related to your event or add your own
//time stamped events.
//Called more than once.
/datum/round_event/proc/tick()
	return

//Called on or after the tick is equal or more than endWhen
//You can include code related to the event ending.
//Do not place spawn() in here, instead use tick() to check for
//the activeFor variable.
//For example: if(activeFor == myOwnVariable + 30) doStuff()
//Only called once.
/datum/round_event/proc/end()
	return



//Do not override this proc, instead use the appropiate procs.
//This proc will handle the calls to the appropiate procs.
/datum/round_event/process()
	if(!processing)
		return

	if(activeFor == startWhen)
		processing = FALSE
		start()
		processing = TRUE

	if(activeFor == announceWhen && prob(announceChance))
		processing = FALSE
		announce(FALSE)
		processing = TRUE

	if(startWhen < activeFor && activeFor < endWhen)
		processing = FALSE
		tick()
		processing = TRUE

	if(activeFor == endWhen)
		processing = FALSE
		end()
		processing = TRUE

	// Everything is done, let's clean up.
	if(activeFor >= endWhen && activeFor >= announceWhen && activeFor >= startWhen)
		processing = FALSE
		kill()

	activeFor++


//Garbage collects the event by removing it from the global events list,
//which should be the only place it's referenced.
//Called when start(), announce() and end() has all been called.
/datum/round_event/proc/kill()
	SSevents.running -= src


//Sets up the event then adds the event to the list of running events
/datum/round_event/New(my_processing = TRUE, datum/round_event_control/source)
	control = source
	processing = my_processing
	SSevents.running += src
	return ..()

/// This section of event processing is in a proc because roundstart events may get their start invoked.
/datum/round_event/proc/try_start()
	if(has_started)
		return
	has_started = TRUE
	processing = FALSE
	start()
	processing = TRUE

/datum/round_event_control/roundstart
	roundstart = TRUE
	earliest_start = 0

///Adds an occurence. Has to use the setter to properly handle shared occurences
/datum/round_event_control/proc/add_occurence()
	if(shared_occurence_type)
		if(!shared_occurences[shared_occurence_type])
			shared_occurences[shared_occurence_type] = 0
		shared_occurences[shared_occurence_type]++
	occurrences++

///Subtracts an occurence. Has to use the setter to properly handle shared occurences
/datum/round_event_control/proc/subtract_occurence()
	if(shared_occurence_type)
		if(!shared_occurences[shared_occurence_type])
			shared_occurences[shared_occurence_type] = 0
		shared_occurences[shared_occurence_type]--
	occurrences--

///Gets occurences. Has to use the getter to properly handle shared occurences
/datum/round_event_control/proc/get_occurences()
	if(shared_occurence_type)
		if(!shared_occurences[shared_occurence_type])
			shared_occurences[shared_occurence_type] = 0
		return shared_occurences[shared_occurence_type]
	return occurrences

/// Prints the action buttons for this event.
/datum/round_event_control/proc/get_href_actions()
	if(SSticker.HasRoundStarted())
		if(roundstart)
			if(!can_run_post_roundstart)
				return "<a class='linkOff'>Fire</a> <a class='linkOff'>Schedule</a>"
			return "<a href='byond://?src=[REF(src)];action=fire'>Fire</a> <a href='byond://?src=[REF(src)];action=schedule'>Schedule</a>"
		else
			return "<a href='byond://?src=[REF(src)];action=fire'>Fire</a> <a href='byond://?src=[REF(src)];action=schedule'>Schedule</a> <a href='byond://?src=[REF(src)];action=force_next'>Force Next</a>"
	else
		if(roundstart)
			return "<a href='byond://?src=[REF(src)];action=schedule'>Add Roundstart</a> <a href='byond://?src=[REF(src)];action=force_next'>Force Roundstart</a>"
		else
			return "<a class='linkOff'>Fire</a> <a class='linkOff'>Schedule</a> <a class='linkOff'>Force Next</a>"


/datum/round_event_control/Topic(href, href_list)
	. = ..()

	if(!check_rights(NONE))
		return

	if(QDELETED(src))
		return
	switch(href_list["action"])
		if("schedule")
			message_admins("[key_name_admin(usr)] scheduled event [src.name].")
			log_admin_private("[key_name(usr)] scheduled [src.name].")
			SSgamemode.current_storyteller.buy_event(src, src.track)
		if("force_next")
			message_admins("[key_name_admin(usr)] forced scheduled event [src.name].")
			log_admin_private("[key_name(usr)] forced scheduled event [src.name].")
			SSgamemode.forced_next_events[src.track] = src
		if("fire")
			message_admins("[key_name_admin(usr)] fired event [src.name].")
			log_admin_private("[key_name(usr)] fired event [src.name].")
			runEvent(random = FALSE, admin_forced = TRUE)

//GLOBAL_LIST_INIT(badomens, list("roundstart"))
GLOBAL_LIST_INIT(badomens, list())

/proc/hasomen(input)
	return (input in GLOB.badomens)

/proc/addomen(input)
	if(!(input in GLOB.badomens))
		GLOB.badomens += input

/proc/removeomen(input)
	if(!hasomen(input))
		return
	GLOB.badomens -= input

/datum/round_event_control/proc/badomen(eventreason)
	var/used = "Zizo."
	var/title = "Bad Omen"
	var/sound = 'sound/misc/evilevent.ogg'
	switch(eventreason)
		if(OMEN_ROUNDSTART)
			used = pick( \
				"Zizo.", \
				"Unholy invocations channel the will of Her.", \
				"Forbidden rituals cause echoes through the plane.", \
				"Whispers of the Dark Lady in the shadows.", \
				"The servants of Zizo undermine the Ten.", \
				"Her influence becomes more tangible...", \
				"A foul curse temporarily takes the land.", \
				"The dead churn and dig at their graves.", \
			)
			title = pick( \
				"Zizo Sneers", \
				"The Dark Lady Watches", \
				"Zizo's Attention", \
				"She Peers", \
				"Zizo Smirks", \
			)
			sound = 'sound/misc/gods/zizo_omen.ogg'
		if(OMEN_NOLORD)
			used = "The Monarch is dead! We need a new ruler."
		if(OMEN_NOPRIEST)
			used = "The High Priest is dead!"
		if(OMEN_NOBLEDEATH)
			used = "A Noble has perished."
		if(OMEN_SUNSTEAL)
			used = "The Sun, she is wounded!"
		if(OMEN_SKELETONSIEGE)
			used = "Unwelcome visitors!"
		if("ascend")
			used = "Zizo will rise once again."
		if("psycross")
			used = "You have angered the gods!"
	if(!eventreason)
		return
	if(!used || !title || !sound)
		return
	priority_announce(used, title, sound)
