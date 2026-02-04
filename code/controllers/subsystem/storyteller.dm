///how many storytellers can be voted for along with always_votable ones
#define DEFAULT_STORYTELLER_VOTE_OPTIONS 4
///amount of players we can have before no longer running votes for storyteller
#define MAX_POP_FOR_STORYTELLER_VOTE 25
///the duration into the round for which roundstart events are still valid to run
#define ROUNDSTART_VALID_TIMEFRAME 3 MINUTES

SUBSYSTEM_DEF(gamemode)
	name = "Gamemode"
	init_order = INIT_ORDER_GAMEMODE
	runlevels = RUNLEVEL_GAME
	flags = SS_BACKGROUND | SS_KEEP_TIMING
	priority = 20
	wait = 2 SECONDS
	lazy_load = FALSE

	///world.time of our last devotion check we add 2 minutes to this to determine if we should switch storytellers
	var/last_devotion_check = 0

	/// List of our event tracks for fast access during for loops.
	var/list/event_tracks = EVENT_TRACKS
	/// Our storyteller. They progresses our trackboards and picks out events
	var/datum/storyteller/current_storyteller
	/// Result of the storyteller vote/pick. Defaults to Astrata.
	var/selected_storyteller = /datum/storyteller/astrata
	/// List of all the storytellers. Populated at init. Associative from type
	var/list/storytellers = list()
	/// Next process for our storyteller. The wait time is STORYTELLER_WAIT_TIME
	var/next_storyteller_process = 0
	/// Associative list of even track points.
	var/list/event_track_points = list(
		EVENT_TRACK_MUNDANE = 0,
		EVENT_TRACK_PERSONAL = 0,
		EVENT_TRACK_MODERATE = 0,
		EVENT_TRACK_INTERVENTION = 0,
		EVENT_TRACK_CHARACTER_INJECTION = 0,
		EVENT_TRACK_OMENS = 0,
		EVENT_TRACK_RAIDS = 0,
		)
	/// Last point amount gained of each track. Those are recorded for purposes of estimating how long until next event.
	var/list/last_point_gains = list(
		EVENT_TRACK_MUNDANE = 0,
		EVENT_TRACK_PERSONAL = 0,
		EVENT_TRACK_MODERATE = 0,
		EVENT_TRACK_INTERVENTION = 0,
		EVENT_TRACK_CHARACTER_INJECTION = 0,
		EVENT_TRACK_OMENS = 0,
		EVENT_TRACK_RAIDS = 0,
		)
	/// Point thresholds at which the events are supposed to be rolled, it is also the base cost for events.
	var/list/point_thresholds = list(
		EVENT_TRACK_MUNDANE = MUNDANE_POINT_THRESHOLD,
		EVENT_TRACK_PERSONAL = MUNDANE_POINT_THRESHOLD,
		EVENT_TRACK_MODERATE = MODERATE_POINT_THRESHOLD,
		EVENT_TRACK_INTERVENTION = MAJOR_POINT_THRESHOLD,
		EVENT_TRACK_CHARACTER_INJECTION = ROLESET_POINT_THRESHOLD,
		EVENT_TRACK_OMENS = MUNDANE_POINT_THRESHOLD * 1.5,
		EVENT_TRACK_RAIDS = OBJECTIVES_POINT_THRESHOLD * 2,
		)

	/// Minimum population thresholds for the tracks to fire off events.
	var/list/min_pop_thresholds = list(
		EVENT_TRACK_MUNDANE = MUNDANE_MIN_POP,
		EVENT_TRACK_PERSONAL = MUNDANE_MIN_POP,
		EVENT_TRACK_MODERATE = MODERATE_MIN_POP,
		EVENT_TRACK_INTERVENTION = MAJOR_MIN_POP,
		EVENT_TRACK_CHARACTER_INJECTION = CHARACTER_INJECTION_MIN_POP,
		EVENT_TRACK_OMENS = MUNDANE_MIN_POP,
		EVENT_TRACK_RAIDS = OBJECTIVES_MIN_POP,
		)

	/// Configurable multipliers for point gain over time.
	var/list/point_gain_multipliers = list(
		EVENT_TRACK_MUNDANE = 1,
		EVENT_TRACK_PERSONAL = 1,
		EVENT_TRACK_MODERATE = 1,
		EVENT_TRACK_INTERVENTION = 1,
		EVENT_TRACK_CHARACTER_INJECTION = 1,
		EVENT_TRACK_OMENS = 1,
		EVENT_TRACK_RAIDS = 1,
		)
	/// Configurable multipliers for roundstart points.
	var/list/roundstart_point_multipliers = list(
		EVENT_TRACK_MUNDANE = 1,
		EVENT_TRACK_PERSONAL = 1,
		EVENT_TRACK_MODERATE = 1,
		EVENT_TRACK_INTERVENTION = 1,
		EVENT_TRACK_CHARACTER_INJECTION = 1,
		EVENT_TRACK_OMENS = 1,
		EVENT_TRACK_RAIDS = 1,
		)
	/// Whether we allow pop scaling. This is configured by config, or the storyteller UI
	var/allow_pop_scaling = TRUE

	/// Associative list of pop scale thresholds.
	var/list/pop_scale_thresholds = list(
		EVENT_TRACK_MUNDANE = MUNDANE_POP_SCALE_THRESHOLD,
		EVENT_TRACK_PERSONAL = MODERATE_POP_SCALE_THRESHOLD,
		EVENT_TRACK_MODERATE = MODERATE_POP_SCALE_THRESHOLD,
		EVENT_TRACK_INTERVENTION = MAJOR_POP_SCALE_THRESHOLD,
		EVENT_TRACK_CHARACTER_INJECTION = ROLESET_POP_SCALE_THRESHOLD,
		EVENT_TRACK_OMENS = MAJOR_POP_SCALE_THRESHOLD,
		EVENT_TRACK_RAIDS = RAID_POP_SCALE_THRESHOLD,
		)

	/// Associative list of pop scale penalties.
	var/list/pop_scale_penalties = list(
		EVENT_TRACK_MUNDANE = MUNDANE_POP_SCALE_PENALTY,
		EVENT_TRACK_PERSONAL = MODERATE_POP_SCALE_PENALTY,
		EVENT_TRACK_MODERATE = MODERATE_POP_SCALE_PENALTY,
		EVENT_TRACK_INTERVENTION = MAJOR_POP_SCALE_PENALTY,
		EVENT_TRACK_CHARACTER_INJECTION = ROLESET_POP_SCALE_PENALTY,
		EVENT_TRACK_OMENS = MAJOR_POP_SCALE_PENALTY,
		EVENT_TRACK_RAIDS = RAID_POP_SCALE_PENALTY,
		)

	/// Associative list of active multipliers from pop scale penalty.
	var/list/current_pop_scale_multipliers = list(
		EVENT_TRACK_MUNDANE = 1,
		EVENT_TRACK_PERSONAL = 1,
		EVENT_TRACK_MODERATE = 1,
		EVENT_TRACK_INTERVENTION = 1,
		EVENT_TRACK_CHARACTER_INJECTION = 1,
		EVENT_TRACK_OMENS = 1,
		EVENT_TRACK_RAIDS = 1,
		)


	//Gods dreams for the dreamwatcher
	var/list/god_dreams = list()

	//Antag dreams for the dreamwatcher
	var/list/antag_dreams = list()

	/// Associative list of control events by their track category. Compiled in Init
	var/list/event_pools = list()

	/// Events that we have scheduled to run in the nearby future
	var/list/scheduled_events = list()

	/// Associative list of tracks to forced event controls. For admins to force events (though they can still invoke them freely outside of the track system)
	var/list/forced_next_events = list()

	var/list/control = list() //list of all datum/round_event_control. Used for selecting events based on weight and occurrences.
	var/list/running = list() //list of all existing /datum/round_event
	var/list/round_end_data = list() //list of all reports that need to add round end reports

	/// List of all uncategorized events, because they were wizard or holiday events
	var/list/uncategorized = list()

	/// Event frequency multiplier, it exists because wizard, eugh.
	var/event_frequency_multiplier = 1

	/// Current preview page for the statistics UI.
	var/statistics_track_page = EVENT_TRACK_MUNDANE
	/// Page of the UI panel.
	var/panel_page = GAMEMODE_PANEL_MAIN
	/// Whether we are viewing the roundstart events or not
	var/roundstart_event_view = TRUE

	/// Whether the storyteller has been halted
	var/halted_storyteller = FALSE

	/// Ready players for roundstart events.
	var/ready_players = 0
	var/active_players = 0
	var/royalty = 0
	var/constructor = 0
	var/garrison = 0
	var/church = 0

	/// Is storyteller secret or not
	var/secret_storyteller = FALSE

	/// List of new player minds we currently want to give our roundstart antag to
	var/list/roundstart_antag_minds = list()

	var/wizardmode = FALSE //refactor this into just being a unique storyteller

	/// What is our currently desired/selected roundstart event
	var/datum/round_event_control/antagonist/solo/current_roundstart_event
	var/list/last_round_events = list()
	/// Has a roundstart event been run
	var/ran_roundstart = FALSE
	/// Are we able to run roundstart events
	var/can_run_roundstart = TRUE
	var/list/triggered_round_events = list()

	var/round_ends_at = 0
	var/roundvoteend = FALSE
	var/reb_end_time = 0

	var/list/chronicle_sets = list(
		"Total Skills" = list(
			CHRONICLE_STATS_MOST_SKILLS_PERSON,
			CHRONICLE_STATS_LEAST_SKILLS_PERSON,
		),
		"Strength" = list(
			CHRONICLE_STATS_STRONGEST_PERSON,
			CHRONICLE_STATS_WEAKEST_PERSON,
		),
		"Intelligence" = list(
			CHRONICLE_STATS_SMARTEST_PERSON,
			CHRONICLE_STATS_DUMBEST_PERSON,
		),
		"Speed" = list(
			CHRONICLE_STATS_FASTEST_PERSON,
			CHRONICLE_STATS_SLOWEST_PERSON,
		),
		"Wealth" = list(
			CHRONICLE_STATS_RICHEST_PERSON,
			CHRONICLE_STATS_POOREST_PERSON,
		),
		"Luck" = list(
			CHRONICLE_STATS_LUCKIEST_PERSON,
			CHRONICLE_STATS_UNLUCKIEST_PERSON,
		),
		"Perception" = list(
			CHRONICLE_STATS_MOST_PERCEPTIVE_PERSON,
			CHRONICLE_STATS_LEAST_PERCEPTIVE_PERSON,
		),
		"Constitution" = list(
			CHRONICLE_STATS_MOST_RESILIENT_PERSON,
			CHRONICLE_STATS_LEAST_RESILIENT_PERSON,
		),
		"Endurance" = list(
			CHRONICLE_STATS_MOST_ENDURANT_PERSON,
			CHRONICLE_STATS_LEAST_ENDURANT_PERSON,
		),
		"Beauty" = list(
			CHRONICLE_STATS_MOST_BEAUTIFUL_PERSON,
			CHRONICLE_STATS_UGLIEST_PERSON,
		),
		"Emotion" = list(
			CHRONICLE_STATS_JOKESTER,
			CHRONICLE_STATS_CRYBABY,
		),
		"Piety" = list(
			CHRONICLE_STATS_PIOUS,
			CHRONICLE_STATS_FOUL_MOUTH,
		),
	)

	/// Chosen chronicle stats of the notable people, which show at the end round panel
	var/list/chosen_chronicle_stats = list()

/datum/controller/subsystem/gamemode/Initialize(time, zlevel)
#if defined(UNIT_TESTS) || defined(AUTOWIKI) // lazy way of doing this but idc
	flags |= SS_NO_FIRE
	return ..()
#endif
	// Populate event pools
	for(var/track in event_tracks)
		event_pools[track] = list()

	// Populate storytellers
	if(!length(storytellers))//unit tests can force this before init.
		for(var/type in subtypesof(/datum/storyteller))
			storytellers[type] = new type()

	for(var/datum/round_event_control/event_type as anything in typesof(/datum/round_event_control))
		if(!event_type::typepath || !event_type::name)
			continue

		var/datum/round_event_control/event = new event_type
		if(!event.valid_for_map())
			qdel(event)
			continue // event isn't good for this map no point in trying to add it to the list
		control += event //add it to the list of all events (controls)

		///List of Possible influence dreams for the Dreamwatcher
		god_dreams = list(

			//Divine Pantheon

			"Psydon" = list(
				"...golden threads drift through the void, stitching stars where wounds once were... something sacred stirs beneath the quiet...",
				"...a vast warmth flickers behind your closed eyes... broken pieces drift, searching for their whole...",
				"...you walk among ruins humming with warmth... pieces of something divine lie scattered, each pulse a memory, each breath a promise..."
			),

			"Astrata"= list(
				"...radiance floods your dream... it’s not warmth, but judgment disguised as light...",
				"...you dream of unending sunrise, gold pouring over endless skies... judgment walks in daylight’s shoes...",
				"...a glare pierces your soul... you feel seen, judged, burned, yet safe... the light watches, unwavering and eternal..."
			),

			"Noc" = list(
				"...silver light spills across ink-black halls... you hear pages fluttering without wind, and a voice speaks in riddles...",
				"...a tapestry of stars weaves itself in your mind... patterns emerge and vanish, revealing truths never spoken aloud...",
				"...moonlight coils into a key... you reach for it, but your hands are made of questions..."
			),

			"Necra"= list(
				"...the dream begins with a closed door... you knock. Silence answers... when it opens, everything you were is counted, weighed...",
				"...everything is still... you are the last heartbeat in a world already buried... a cold smile waits just past the veil...",
				"...a quiet woman sits by a river made of ash... she nods once, counting your breath..."
			),

			"Pestra"= list(
				"...your dream wilts, then blooms. A garden of endings and beginnings surrounds you...",
				"...you hold your own bones like seeds. Rain falls, and they whisper with life...",
				"...you see a flower bloom in ash. It dies and returns, brighter, stranger. The rhythm of endings comforts you...",
			),

			"Ravox"= list(
				"...a sword rests beside a scale... neither tips...",
				"...steel sings in your dreams... a verdict is written in blood and flame, but justice waits before it lands...",
				"...you duel a mirror image of yourself... the victor is neither, yet the fight continues... law and war share the same breath..."
			),

			"Malum"= list(
				"...hammers echo through your sleep... something is being made, perhaps you...",
				"...your hands ache... you build something vast, but can never see the whole... sparks kiss your skin, and you smile...",
				"...endless clanging fills your mind... with each strike, something within you hardens, reforged in smoke and effort..."
			),

			"Dendor"= list(
				"...animals scream in tongues you almost understand... trees whisper old pain, searching for their shepherd...",
				"...vines coil around your limbs. Roots burst from your feet... the forest within you howls, a kingdom lost to madness...",
				"...eyes glow among tangled thorns... something ancient, betrayed, hungers again..."
			),

			"Abyssor"= list(
				"...the sea invades your lungs... a storm of blood and salt rises...",
				"...fins brush past your legs... the water tastes of fury and old wounds...",
				"...tides drag you under... in the silence, you hear sobbing, not yours... the sea remembers every wound..."
			),


			"Xylix"= list(
				"...you laugh without knowing why... your reflection winks back as a stranger...",
				"...you wear masks you’ve never owned... each one laughs in a new voice... you are a guest in your own skin...",
				"...every path splits... every answer lies... yet you smile... trickery is truth when worn well..."
			),

			"Eora"= list(
				"...you dream in color,red threads, gold loops, blue knots... all pulling gently...",
				"...a weaving surrounds you... every face you’ve loved or hated is there...",
				"...your heart is a loom... dreams pass through it, weaving bonds to people you’ve never met, yet feel you’ve always known..."
			),

			//Inhumen Pantheon

			"Matthios"= list(
				"...a shadow slips your pocket open... you feel lighter in your dream...",
				"...a purse vanishes from your belt... a laugh echoes in your ears... you check your pockets, your name is gone...",
				"...you follow footprints that vanish behind you... no one walks beside you, yet you’re never alone..."
			),

			"Baotha" = list(
				"...everything glows with joy... then it melts, and you, giggle anyway...",
				"...you float through a city of glass, laughter echoing in colors... you smile with no mouth and sing without sound...",
				"...your body dances without thought... every breath tastes like honey and smoke... you forget, and it feels divine..."
			),

			"Graggar"= list(
				"...your mouth is not your own... it’s laughing, snarling, hungry...",
				"...you tear through flesh with joy... your dream is soaked in red... hunger knows your name, and calls you friend...",
				"...an ancient drum beats under your ribs... it demands violence in return for peace..."
			),

			"Zizo"= list(
				"...eyes stare from skulls that still weep... you cradle a child made of frost and ash... it whispers secrets backwards...",
				"...your name is forgotten by everyone in your dream... only bones remember...",
				"...a girl with white eyes smiles at you... her lullaby stitches flesh to spirit..."
			),

			"Unknown" = list("You feel a presence watching your sleep... old, vast, and unknowable. You do not yet know their name.")
		)

		///List of possible antag dreams for the dream watcher
		antag_dreams = list(
			/datum/antagonist/vampire/lord = list(
					"... a pale figure watches from afar... its gaze weighs heavy on your soul",
					"... red velvet, torn and trailing... a presence unseen but always near",
					"... a name you cannot remember sits on your tongue... it tastes of blood and dust"
				),
			/datum/antagonist/vampire = list(
					"... a hand reaches from the dark... obedient, yet trembling",
					"... you kneel, not knowing why... the voice behind you compels it",
					"... a collar of roses and rust... worn by the willing"
				),
			/datum/antagonist/vampire/lords_spawn = list (
					"... fangs bloom from cracked lips... hunger shudders through the air",
					"... you see your reflection... it smiles with borrowed teeth",
					"... a laugh beneath floorboards... young, broken, blood-wet"
				),
			/datum/antagonist/lich = list (
					"... a cold wind whispers names no longer spoken",
					"... the tower bleeds light... skeletal hands trace forbidden runes",
					"... bones rattle in a jar... they whisper of eternity"
				),
			/datum/antagonist/werewolf = list(
					"... fur and fury rise... the moon stains the sky",
					"... howling splits the silence... your hands ache with claws",
					"... you wake with dirt under your nails... and a taste of fur"
				),
			/datum/antagonist/werewolf/lesser = list(
					"... bones snap in rhythm... hunger guides their paws",
					"... they follow the alpha's scent... and dream of killing him",
					"... a low growl rumbles under moonlight... fur and fury rise"
				),
			/datum/antagonist/zizocultist = list(
					"...a circle chants beneath shifting stars... their eyes are wrong",
					"...ink flows upward... the words burn in reverse",
					"...your thoughts are not your own... they hum in unison"
				),
			/datum/antagonist/zizocultist/leader = list(
					"... a silent servant tends to a spiral... it never ends",
					"... you hand someone a book... you've never seen it before",
					"... something stands just behind your shoulder... always just behind"
				),
			/datum/antagonist/prebel = list(
					"... muddy boots march across broken fields... fire follows",
					"... the crowd roars without faces... you hold the torch",
					"... a scythe buried in stone... your hand fits its grip perfectly"
				),
			/datum/antagonist/prebel/head = list(
					"... a crowned figure of burlap and ash... they speak with your voice",
					"... a throne made of pitchforks... it wobbles with every heartbeat",
					"... children chant in the ruins... the rhythm carries a blade"
				),
			/datum/antagonist/aspirant = list(
					"...you climb a tower of mirrors... none reflect the same face",
					"...a blade sings your name... but you've never heard it before",
					"...the stars rearrange themselves... spelling failure"
				),
			/datum/antagonist/bandit = list(
					"... coin clinks like bone... your pockets are never full",
					"... a dagger flickers in the candlelight... too fast to see",
					"... a mask laughs... the voice behind it is yours"
				),
			/datum/antagonist/assassin = list(
					"... a shadow parts from your own... and doesn't return",
					"... footsteps on the ceiling... you hold your breath",
					"... ink-black gloves close around your throat... gently"
				),
			/datum/antagonist/maniac = list(
					"... a door opens inside a room that shouldn't exist... behind it, a thousand mirrors... none show your face",
					"... you hear the world breathe... a hiss, a code, a loop... someone is watching from behind the glass",
					"... you see structures made of meat and bone... they form words you can almost understand... then collapse"
				),
			"Unknown" = list(
					"... something lingers in the darkness",
					"... you feel an unseen presence watching",
					"... the air grows heavy with forgotten whispers"
				)
		)



	load_config_vars()
	load_event_config_vars()

	///Seeding events into track event pools needs to happen after event config vars are loaded
	for(var/datum/round_event_control/event as anything in control)
		if(event.holidayID || event.wizardevent)
			uncategorized += event
			continue
		event_pools[event.track] += event //Add it to the categorized event pools

	load_roundstart_data()

	check_roundstart_gods_rankings()

	initialize_culinary_globals()

	pick_chronicle_stats()

	. = ..()

/datum/controller/subsystem/gamemode/fire(resumed = FALSE)
	if(last_devotion_check < world.time)
		pick_most_influential()
		last_devotion_check = world.time + 2 MINUTES

	if(SSticker.HasRoundStarted() && (world.time - SSticker.round_start_time) >= ROUNDSTART_VALID_TIMEFRAME)
		can_run_roundstart = FALSE
	else if(current_roundstart_event && length(current_roundstart_event.preferred_events)) //note that this implementation is made for preferred_events being other roundstart events
		var/list/preferred_copy = current_roundstart_event.preferred_events.Copy()
		var/datum/round_event_control/selected_event = pickweight(preferred_copy)
		var/player_count = get_active_player_count(alive_check = TRUE, afk_check = TRUE, human_check = TRUE)
		if(ispath(selected_event)) //get the instances if we dont have them
			current_roundstart_event.preferred_events = list()
			for(var/datum/round_event_control/e_control as anything in preferred_copy)
				current_roundstart_event.preferred_events[new e_control] = preferred_copy[e_control]
			preferred_copy = current_roundstart_event.preferred_events.Copy()
			selected_event = null
		else if(!selected_event.canSpawnEvent(player_count))
			preferred_copy -= selected_event
			selected_event = null

		var/sanity = 0
		while(!selected_event && length(preferred_copy) && sanity < 100)
			sanity++
			selected_event = pickweight(preferred_copy)
			if(!selected_event.canSpawnEvent(player_count))
				preferred_copy -= selected_event
				selected_event = null

		if(selected_event)
			current_storyteller.try_buy_event(selected_event)

	///Handle scheduled events
	for(var/datum/scheduled_event/sch_event in scheduled_events)
		if(world.time >= sch_event.start_time)
			sch_event.try_fire()
		else if(!sch_event.alerted_admins && world.time >= sch_event.start_time - 1 MINUTES)
			///Alert admins 1 minute before running and allow them to cancel or refund the event, once again.
			sch_event.alerted_admins = TRUE
			message_admins("Scheduled Event: [sch_event.event] will run in [(sch_event.start_time - world.time) / 10] seconds. (<a href='byond://?src=[REF(sch_event)];action=cancel'>CANCEL</a>) (<a href='byond://?src=[REF(sch_event)];action=refund'>REFUND</a>)")

	if(!halted_storyteller && next_storyteller_process <= world.time && current_storyteller)
		// We update crew information here to adjust population scalling and event thresholds for the storyteller.
		update_crew_infos()
		next_storyteller_process = world.time + STORYTELLER_WAIT_TIME
		current_storyteller.process(STORYTELLER_WAIT_TIME * 0.1)

/datum/controller/subsystem/gamemode/proc/initialize_culinary_globals()
	GLOB.selectable_foods = get_global_selectable_foods()
	GLOB.selectable_drinks = get_global_selectable_drinks()

/// Gets the number of antagonists the antagonist injection events will stop rolling after.
/datum/controller/subsystem/gamemode/proc/get_antag_cap()
	var/total_number = get_correct_popcount() + (garrison * 2)
	var/cap = FLOOR((total_number / ANTAG_CAP_DENOMINATOR), 1) + ANTAG_CAP_FLAT
	return cap

/datum/controller/subsystem/gamemode/proc/get_antag_count()
	. = 0
	var/list/already_counted = list() // Never count the same mind twice
	for(var/datum/antagonist/antag as anything in GLOB.antagonists)
		if(QDELETED(antag) || QDELETED(antag.owner) || already_counted[antag.owner])
			continue
		if((antag.antag_flags & (FLAG_FAKE_ANTAG | FLAG_ANTAG_CAP_IGNORE)))
			continue
		if(antag.antag_flags & FLAG_ANTAG_CAP_TEAM)
			var/datum/team/antag_team = antag.get_team()
			if(antag_team)
				if(already_counted[antag_team])
					continue
				already_counted[antag_team] = TRUE
		var/mob/antag_mob = antag.owner.current
		if(QDELETED(antag_mob) || !antag_mob.key || antag_mob.stat == DEAD || antag_mob.client?.is_afk())
			continue
		already_counted[antag.owner] = TRUE
		.++

/// Whether events can inject more antagonists into the round
/datum/controller/subsystem/gamemode/proc/can_inject_antags()
	return (get_antag_cap() > get_antag_count())

/// Gets candidates for antagonist roles.
/datum/controller/subsystem/gamemode/proc/get_candidates(be_special, job_ban, observers, ready_newplayers, living_players, required_time, inherit_required_time = TRUE, midround_antag_pref, no_antags = TRUE, list/restricted_roles, list/required_roles)
	var/list/candidates = list()

	for(var/mob/player as anything in GLOB.player_list)
		if(QDELETED(player) || !player.client || !player.mind || player.mind.picking)
			continue

		if(job_ban && is_banned_from(player.ckey, list(job_ban)))
			continue

		var/checked_one_box = FALSE

		if(ready_newplayers && isnewplayer(player))
			var/mob/dead/new_player/new_player = player
			if(new_player.ready != PLAYER_READY_TO_PLAY || !new_player.check_preferences())
				continue
			checked_one_box = TRUE

		if(observers && isobserver(player))
			checked_one_box = TRUE

		if(living_players && isliving(player))
			if(!ishuman(player))
				continue

			var/datum/job/tested_job = player.mind.assigned_role
			if(tested_job.parent_job)
				tested_job = tested_job.parent_job

			if(length(restricted_roles) && is_type_in_typecache(tested_job, restricted_roles))
				continue

			if(length(required_roles) && !is_type_in_typecache(tested_job, required_roles))
				continue

			if(player.mind.special_role)
				continue

			if(be_special && !(be_special in player.client.prefs?.be_special))
				continue

			if(no_antags && length(player.mind.antag_datums))
				var/real = FALSE
				for(var/datum/antagonist/antag_datum as anything in player.mind.antag_datums)
					if(!(antag_datum.antag_flags & FLAG_FAKE_ANTAG))
						real = TRUE
						break
				if(real)
					continue

			checked_one_box = TRUE

		if(checked_one_box)
			candidates += player

	return candidates

/// Gets the correct popcount, returning READY people if roundstart, and active people if not.
/datum/controller/subsystem/gamemode/proc/get_correct_popcount()
	if(SSticker.HasRoundStarted())
		update_crew_infos()
		return active_players
	else
		calculate_ready_players()
		return ready_players

/// Refunds and removes a scheduled event.
/datum/controller/subsystem/gamemode/proc/refund_scheduled_event(datum/scheduled_event/refunded)
	if(refunded.cost)
		var/track_type = refunded.event.track
		event_track_points[track_type] += refunded.cost
	remove_scheduled_event(refunded)

/// Removes a scheduled event.
/datum/controller/subsystem/gamemode/proc/remove_scheduled_event(datum/scheduled_event/removed)
	scheduled_events -= removed
	qdel(removed)

/// We need to calculate ready players for the sake of roundstart events becoming eligible.
/datum/controller/subsystem/gamemode/proc/calculate_ready_players()
	ready_players = 0
	for(var/mob/dead/new_player/player as anything in GLOB.new_player_list)
		if(player.ready == PLAYER_READY_TO_PLAY)
			ready_players++

/// We roll points to be spent for roundstart events, including antagonists.
/datum/controller/subsystem/gamemode/proc/roll_pre_setup_points()
#if defined(UNIT_TESTS) || defined(AUTOWIKI) // lazy way of doing this but idc
	return
#endif
	if(current_storyteller?.disable_distribution || halted_storyteller)
		return
	/// Distribute points
	for(var/track in event_track_points)
		var/base_amt
		var/gain_amt
		switch(track)
			if(EVENT_TRACK_MUNDANE)
				base_amt = ROUNDSTART_MUNDANE_BASE
				gain_amt = ROUNDSTART_MUNDANE_GAIN
			if(EVENT_TRACK_PERSONAL)
				base_amt = ROUNDSTART_PERSONAL_BASE
				gain_amt = ROUNDSTART_PERSONAL_GAIN
			if(EVENT_TRACK_MODERATE)
				base_amt = ROUNDSTART_MODERATE_BASE
				gain_amt = ROUNDSTART_MODERATE_GAIN
			if(EVENT_TRACK_INTERVENTION)
				base_amt = ROUNDSTART_MAJOR_BASE
				gain_amt = ROUNDSTART_MAJOR_GAIN
			if(EVENT_TRACK_CHARACTER_INJECTION)
				base_amt = ROUNDSTART_ROLESET_BASE
				gain_amt = ROUNDSTART_ROLESET_GAIN
			if(EVENT_TRACK_OMENS)
				base_amt = 0
				gain_amt = 0
			if(EVENT_TRACK_RAIDS)
				base_amt = 0
				gain_amt = 0

		var/calc_value = base_amt + (gain_amt * ready_players)
		calc_value *= roundstart_point_multipliers[track]
		calc_value *= current_storyteller?.starting_point_multipliers[track]
		calc_value *= (rand(100 - current_storyteller?.roundstart_points_variance,100 + current_storyteller?.roundstart_points_variance)/100)
		event_track_points[track] = min(round(calc_value), round(point_thresholds[track] * 1.25))

	/// If the storyteller guarantees an antagonist roll, add points to make it so.
	if(current_storyteller?.guarantees_roundstart_roleset && event_track_points[EVENT_TRACK_CHARACTER_INJECTION] < point_thresholds[EVENT_TRACK_CHARACTER_INJECTION])
		event_track_points[EVENT_TRACK_CHARACTER_INJECTION] = point_thresholds[EVENT_TRACK_CHARACTER_INJECTION]

	/// If we have any forced events, ensure we get enough points for them
	for(var/track in event_tracks)
		if(forced_next_events[track] && event_track_points[track] < point_thresholds[track])
			event_track_points[track] = point_thresholds[track]

/// At this point we've rolled roundstart events and antags and we handle leftover points here.
/datum/controller/subsystem/gamemode/proc/handle_post_setup_points()
//	for(var/track in event_track_points) //Just halve the points for now.
//		event_track_points[track] *= 0.5 TESTING HOW THINGS GO WITHOUT THIS HALVING OF POINTS
	return

/// Because roundstart events need 2 steps of firing for purposes of antags, here is the first step handled, happening before occupation division.
/datum/controller/subsystem/gamemode/proc/handle_pre_setup_roundstart_events()
	if(current_storyteller?.disable_distribution)
		return
	if(halted_storyteller)
		message_admins("WARNING: Didn't roll roundstart events (including antagonists) due to the storyteller being halted.")
		return
	while(TRUE)
		if(!current_storyteller.handle_tracks())
			break

/// Second step of handlind roundstart events, happening after people spawn.
/datum/controller/subsystem/gamemode/proc/handle_post_setup_roundstart_events()
	/// Start all roundstart events on post_setup immediately
	for(var/datum/round_event/event as anything in running)
		if(!event.control.roundstart)
			continue
		ASYNC
			event.try_start()
		INVOKE_ASYNC(event, TYPE_PROC_REF(/datum/round_event, try_start))

/// Schedules an event to run later.
/datum/controller/subsystem/gamemode/proc/schedule_event(datum/round_event_control/passed_event, passed_time, passed_cost, passed_ignore, passed_announce, _forced = FALSE, omen = FALSE)
	if(_forced)
		passed_ignore = TRUE
	var/datum/scheduled_event/scheduled = new (passed_event, world.time + passed_time, passed_cost, passed_ignore, passed_announce, omen)
	var/round_started = SSticker.HasRoundStarted()
	if(round_started)
		message_admins("Event: [passed_event] has been scheduled to run in [passed_time / 10] seconds. (<a href='byond://?src=[REF(scheduled)];action=cancel'>CANCEL</a>) (<a href='byond://?src=[REF(scheduled)];action=refund'>REFUND</a>)")
	else //Only roundstart events can be scheduled before round start
		message_admins("Event: [passed_event] has been scheduled to run on roundstart. (<a href='byond://?src=[REF(scheduled)];action=cancel'>CANCEL</a>)")
	scheduled_events += scheduled

/datum/controller/subsystem/gamemode/proc/update_crew_infos()
	// Very similar logic to `get_active_player_count()`
	active_players = 0
	royalty = 0
	constructor = 0
	church = 0
	garrison = 0
	for(var/mob/player_mob as anything in GLOB.player_list)
		if(!player_mob.client)
			continue
		if(player_mob.stat) //If they're alive
			continue
		if(player_mob.client.is_afk()) //If afk
			continue
		if(!ishuman(player_mob))
			continue
		active_players++
		var/datum/job/assigned = player_mob.mind?.assigned_role
		if(assigned)
			if(assigned.job_bitflag & BITFLAG_ROYALTY)
				royalty++
			if(assigned.job_bitflag & BITFLAG_CONSTRUCTOR)
				constructor++
			if(assigned.job_bitflag & BITFLAG_CHURCH)
				church++
			if(assigned.job_bitflag & BITFLAG_GARRISON)
				garrison++
	update_pop_scaling()

/datum/controller/subsystem/gamemode/proc/update_pop_scaling()
	for(var/track in event_tracks)
		var/low_pop_bound = min_pop_thresholds[track]
		var/high_pop_bound = pop_scale_thresholds[track]
		var/scale_penalty = pop_scale_penalties[track]

		var/perceived_pop = min(max(low_pop_bound, active_players), high_pop_bound)

		var/divisor = high_pop_bound - low_pop_bound
		/// If the bounds are equal, we'd be dividing by zero or worse, if upper is smaller than lower, we'd be increasing the factor, just make it 1 and continue.
		/// this is only a problem for bad configs
		if(divisor <= 0)
			current_pop_scale_multipliers[track] = 1
			continue
		var/scalar = (perceived_pop - low_pop_bound) / divisor
		var/penalty = scale_penalty - (scale_penalty * scalar)
		var/calculated_multiplier = 1 - (penalty / 100)

		current_pop_scale_multipliers[track] = calculated_multiplier

/datum/controller/subsystem/gamemode/proc/TriggerEvent(datum/round_event_control/event, forced = FALSE)
	. = event.preRunEvent(forced)
	if(. == EVENT_CANT_RUN)//we couldn't run this event for some reason, set its max_occurrences to 0
		event.max_occurrences = 0
	else if(. == EVENT_READY)
		event.runEvent(random = TRUE, admin_forced = forced) // fallback to dynamic
		add_abstract_elastic_data(ELASCAT_STORYTELLER, event.name, 1, 1)

///Resets frequency multiplier.
/datum/controller/subsystem/gamemode/proc/resetFrequency()
	event_frequency_multiplier = 1

///Attempts to select players for special roles the mode might have.
/datum/controller/subsystem/gamemode/proc/pre_setup()
	if(!length(storytellers))
		for(var/type in subtypesof(/datum/storyteller))
			storytellers[type] = new type()

	handle_god_ascensions()
	pick_most_influential(TRUE)
	calculate_ready_players()
	roll_pre_setup_points()
	//handle_pre_setup_roundstart_events()
	return TRUE

///Everyone should now be on the station and have their normal gear.  This is the place to give the special roles extra things
/datum/controller/subsystem/gamemode/proc/post_setup(report) //Gamemodes can override the intercept report. Passing TRUE as the argument will force a report.
	if(!report)
		report = !CONFIG_GET(flag/no_intercept_report)
	addtimer(CALLBACK(GLOBAL_PROC, GLOBAL_PROC_REF(display_roundstart_logout_report)), ROUNDSTART_LOGOUT_REPORT_TIME)

	if(CONFIG_GET(flag/reopen_roundstart_suicide_roles))
		var/delay = CONFIG_GET(number/reopen_roundstart_suicide_roles_delay)
		if(delay)
			delay = (delay SECONDS)
		else
			delay = (4 MINUTES) //default to 4 minutes if the delay isn't defined.
		addtimer(CALLBACK(GLOBAL_PROC, GLOBAL_PROC_REF(reopen_roundstart_suicide_roles)), delay)

	handle_post_setup_roundstart_events()
	handle_post_setup_points()
	refresh_alive_stats(first_post_roundstart_check = TRUE)
	roundstart_event_view = FALSE
	return TRUE


///Handles late-join antag assignments
/datum/controller/subsystem/gamemode/proc/make_antag_chance(mob/living/carbon/human/character)
	return

/datum/controller/subsystem/gamemode/proc/check_finished(force_ending) //to be called by SSticker
	if(!SSticker.setup_done)
		return FALSE
	if(force_ending)
		return TRUE

	var/ttime = world.time - SSticker.round_start_time
	if(ttime >= GLOB.round_timer)
		if(roundvoteend)
			if(ttime >= round_ends_at)
				return TRUE
		else if(!SSvote.mode)
			SSvote.initiate_vote("endround", "The Gods")

	if(SSmapping.retainer.head_rebel_decree)
		if(reb_end_time == 0)
			to_chat(world, span_boldannounce("The peasant rebels took control of the throne, hail the new community!"))
			if(ttime >= INITIAL_ROUND_TIMER)
				reb_end_time = ttime + 15 MINUTES
				to_chat(world, span_boldwarning("The round will end in 15 minutes."))
			else
				reb_end_time = INITIAL_ROUND_TIMER
				to_chat(world, span_boldwarning("The round will end at the 2:30 hour mark."))
		if(ttime >= reb_end_time)
			return TRUE

/datum/controller/subsystem/gamemode/proc/generate_town_goals()
	return

/// Loads json event config values from events.txt
/datum/controller/subsystem/gamemode/proc/load_event_config_vars()
	var/json_file = file("[global.config.directory]/events.json")
	if(!fexists(json_file))
		return
	var/list/decoded = json_decode(file2text(json_file))
	for(var/event_text_path in decoded)
		var/event_path = text2path(event_text_path)
		var/datum/round_event_control/event
		for(var/datum/round_event_control/iterated_event as anything in control)
			if(iterated_event.type == event_path)
				event = iterated_event
				break
		if(!event)
			continue
		var/list/var_list = decoded[event_text_path]
		for(var/variable in var_list)
			var/value = var_list[variable]
			switch(variable)
				if("weight")
					event.weight = value
				if("min_players")
					event.min_players = value
				if("max_occurrences")
					event.max_occurrences = value
				if("earliest_start")
					event.earliest_start = value * (1 MINUTES)
				if("track")
					if(value in event_tracks)
						event.track = value
				if("cost")
					event.cost = value
				if("reoccurence_penalty_multiplier")
					event.reoccurence_penalty_multiplier = value
				if("shared_occurence_type")
					if(!isnull(value))
						value = "[value]"
					event.shared_occurence_type = value

/// Loads config values from game_options.txt
/datum/controller/subsystem/gamemode/proc/load_config_vars()
	point_gain_multipliers[EVENT_TRACK_MUNDANE] = CONFIG_GET(number/mundane_point_gain_multiplier)
	point_gain_multipliers[EVENT_TRACK_PERSONAL] = CONFIG_GET(number/mundane_point_gain_multiplier)
	point_gain_multipliers[EVENT_TRACK_MODERATE] = CONFIG_GET(number/moderate_point_gain_multiplier)
	point_gain_multipliers[EVENT_TRACK_INTERVENTION] = CONFIG_GET(number/major_point_gain_multiplier)
	point_gain_multipliers[EVENT_TRACK_CHARACTER_INJECTION] = CONFIG_GET(number/roleset_point_gain_multiplier)
	point_gain_multipliers[EVENT_TRACK_OMENS] = CONFIG_GET(number/mundane_point_gain_multiplier)
	point_gain_multipliers[EVENT_TRACK_RAIDS] = 1

	roundstart_point_multipliers[EVENT_TRACK_MUNDANE] = CONFIG_GET(number/mundane_roundstart_point_multiplier)
	roundstart_point_multipliers[EVENT_TRACK_PERSONAL] = CONFIG_GET(number/mundane_roundstart_point_multiplier)
	roundstart_point_multipliers[EVENT_TRACK_MODERATE] = CONFIG_GET(number/moderate_roundstart_point_multiplier)
	roundstart_point_multipliers[EVENT_TRACK_INTERVENTION] = CONFIG_GET(number/major_roundstart_point_multiplier)
	roundstart_point_multipliers[EVENT_TRACK_CHARACTER_INJECTION] = CONFIG_GET(number/roleset_roundstart_point_multiplier)
	roundstart_point_multipliers[EVENT_TRACK_OMENS] = CONFIG_GET(number/mundane_roundstart_point_multiplier)
	roundstart_point_multipliers[EVENT_TRACK_RAIDS] = 1

	min_pop_thresholds[EVENT_TRACK_MUNDANE] = CONFIG_GET(number/mundane_min_pop)
	min_pop_thresholds[EVENT_TRACK_PERSONAL] = CONFIG_GET(number/moderate_min_pop)
	min_pop_thresholds[EVENT_TRACK_MODERATE] = CONFIG_GET(number/moderate_min_pop)
	min_pop_thresholds[EVENT_TRACK_INTERVENTION] = CONFIG_GET(number/major_min_pop)
	min_pop_thresholds[EVENT_TRACK_CHARACTER_INJECTION] = CONFIG_GET(number/roleset_min_pop)
	min_pop_thresholds[EVENT_TRACK_OMENS] = CONFIG_GET(number/major_min_pop)
	min_pop_thresholds[EVENT_TRACK_RAIDS] = CONFIG_GET(number/objectives_min_pop)

	point_thresholds[EVENT_TRACK_MUNDANE] = CONFIG_GET(number/mundane_point_threshold)
	point_thresholds[EVENT_TRACK_PERSONAL] = CONFIG_GET(number/mundane_point_threshold)
	point_thresholds[EVENT_TRACK_MODERATE] = CONFIG_GET(number/moderate_point_threshold)
	point_thresholds[EVENT_TRACK_INTERVENTION] = CONFIG_GET(number/major_point_threshold)
	point_thresholds[EVENT_TRACK_CHARACTER_INJECTION] = CONFIG_GET(number/roleset_point_threshold)
	point_thresholds[EVENT_TRACK_OMENS] = CONFIG_GET(number/mundane_point_threshold) * 1.5
	point_thresholds[EVENT_TRACK_RAIDS] = CONFIG_GET(number/objectives_point_threshold) * 2

/datum/controller/subsystem/gamemode/proc/handle_picking_storyteller()
	if(length(GLOB.clients) > MAX_POP_FOR_STORYTELLER_VOTE)
		secret_storyteller = TRUE
		selected_storyteller = pickweight(get_valid_storytellers(TRUE))
		return
	pick_most_influential(TRUE)

/datum/controller/subsystem/gamemode/proc/storyteller_vote_choices()
	var/list/final_choices = list()
	var/list/pick_from = list()
	for(var/datum/storyteller/storyboy in get_valid_storytellers())
		if(storyboy.always_votable)
			final_choices[storyboy.name] = 0
		else
			pick_from[storyboy.name] = storyboy.weight //might be able to refactor this to be slightly better due to get_valid_storytellers returning a weighted list

	var/added_storytellers = 0
	while(added_storytellers < DEFAULT_STORYTELLER_VOTE_OPTIONS && length(pick_from))
		added_storytellers++
		var/picked_storyteller = pickweight(pick_from)
		final_choices[picked_storyteller] = 0
		pick_from -= picked_storyteller
	return final_choices

/datum/controller/subsystem/gamemode/proc/storyteller_desc(storyteller_name)
	for(var/storyteller_type in storytellers)
		var/datum/storyteller/storyboy = storytellers[storyteller_type]
		if(storyboy.name != storyteller_name)
			continue
		return storyboy.desc


/datum/controller/subsystem/gamemode/proc/storyteller_vote_result(winner_name)
	for(var/storyteller_type in storytellers)
		var/datum/storyteller/storyboy = storytellers[storyteller_type]
		if(storyboy.name == winner_name)
			selected_storyteller = storyteller_type
			break

///return a weighted list of all storytellers that are currently valid to roll, if return_types is set then we will return types instead of instances
/datum/controller/subsystem/gamemode/proc/get_valid_storytellers(return_types = FALSE)
	var/client_amount = length(GLOB.clients)
	var/list/valid_storytellers = list()
	for(var/storyteller_type in storytellers)
		var/datum/storyteller/storyboy = storytellers[storyteller_type]
		if(storyboy.restricted || (storyboy.population_min && storyboy.population_min > client_amount) || (storyboy.population_max && storyboy.population_max < client_amount))
			continue

		valid_storytellers[return_types ? storyboy.type : storyboy] = storyboy.weight
	return valid_storytellers

/datum/controller/subsystem/gamemode/proc/init_storyteller()
	set_storyteller(selected_storyteller)

/datum/controller/subsystem/gamemode/proc/set_storyteller(passed_type)
	if(!storytellers[passed_type])
		message_admins("Attempted to set an invalid storyteller type: [passed_type], force setting to guide instead.")
		current_storyteller = storytellers[/datum/storyteller/astrata] //if we dont have any then we brick, lets not do that
		CRASH("Attempted to set an invalid storyteller type: [passed_type].")

	var/datum/storyteller/chosen_storyteller = storytellers[passed_type]
	chosen_storyteller.times_chosen++
	GLOB.featured_stats[FEATURED_STATS_STORYTELLERS]["entries"][initial(chosen_storyteller.name)] = chosen_storyteller.times_chosen
	current_storyteller = chosen_storyteller

/// Panel containing information, variables and controls about the gamemode and scheduled event
/datum/controller/subsystem/gamemode/proc/admin_panel(mob/user)
	update_crew_infos()
	var/round_started = SSticker.HasRoundStarted()
	var/list/dat = list()
	dat += "Storyteller: [current_storyteller ? "[current_storyteller.name]" : "None"] "
	dat += " <a href='byond://?src=[REF(src)];panel=main;action=halt_storyteller' [halted_storyteller ? "class='linkOn'" : ""]>HALT Storyteller</a> <a href='byond://?src=[REF(src)];panel=main;action=open_stats'>Event Panel</a> <a href='byond://?src=[REF(src)];panel=main;action=set_storyteller'>Set Storyteller</a> <a href='byond://?src=[REF(user.client)];panel=main;viewinfluences=1'>View Influences</a> <a href='byond://?src=[REF(src)];panel=main'>Refresh</a>"
	dat += "<BR><font color='#888888'><i>Storyteller determines points gained, event chances, and is the entity responsible for rolling events.</i></font>"
	dat += "<BR>Active Players: [active_players]   (Royalty: [royalty], Garrison: [garrison], Town Workers: [constructor], Church: [church])"
	dat += "<BR>Antagonist Count vs Maximum: [get_antag_count()] / [get_antag_cap()]"
	dat += "<HR>"
	dat += "<a href='byond://?src=[REF(src)];panel=main;action=tab;tab=[GAMEMODE_PANEL_MAIN]' [panel_page == GAMEMODE_PANEL_MAIN ? "class='linkOn'" : ""]>Main</a>"
	dat += " <a href='byond://?src=[REF(src)];panel=main;action=tab;tab=[GAMEMODE_PANEL_VARIABLES]' [panel_page == GAMEMODE_PANEL_VARIABLES ? "class='linkOn'" : ""]>Variables</a>"
	dat += "<HR>"
	switch(panel_page)
		if(GAMEMODE_PANEL_VARIABLES)
			dat += "<a href='byond://?src=[REF(src)];panel=main;action=reload_config_vars'>Reload Config Vars</a> <font color='#888888'><i>Configs located in game_options.txt.</i></font>"
			dat += "<BR><b>Point Gains Multipliers (only over time):</b>"
			dat += "<BR><font color='#888888'><i>This affects points gained over time towards scheduling new events of the tracks.</i></font>"
			for(var/track in event_tracks)
				dat += "<BR>[track]: <a href='byond://?src=[REF(src)];panel=main;action=vars;var=pts_multiplier;track=[track]'>[point_gain_multipliers[track]]</a>"
			dat += "<HR>"

			dat += "<b>Roundstart Points Multipliers:</b>"
			dat += "<BR><font color='#888888'><i>This affects points generated for roundstart events and antagonists.</i></font>"
			for(var/track in event_tracks)
				dat += "<BR>[track]: <a href='byond://?src=[REF(src)];panel=main;action=vars;var=roundstart_pts;track=[track]'>[roundstart_point_multipliers[track]]</a>"
			dat += "<HR>"

			dat += "<b>Minimum Population for Tracks:</b>"
			dat += "<BR><font color='#888888'><i>This are the minimum population caps for events to be able to run.</i></font>"
			for(var/track in event_tracks)
				dat += "<BR>[track]: <a href='byond://?src=[REF(src)];panel=main;action=vars;var=min_pop;track=[track]'>[min_pop_thresholds[track]]</a>"
			dat += "<HR>"

			dat += "<b>Point Thresholds:</b>"
			dat += "<BR><font color='#888888'><i>Those are thresholds the tracks require to reach with points to make an event.</i></font>"
			for(var/track in event_tracks)
				dat += "<BR>[track]: <a href='byond://?src=[REF(src)];panel=main;action=vars;var=pts_threshold;track=[track]'>[point_thresholds[track]]</a>"

		if(GAMEMODE_PANEL_MAIN)
			var/even = TRUE
			dat += "<h2>Event Tracks:</h2>"
			dat += "<font color='#888888'><i>Every track represents progression towards scheduling an event of its severity</i></font>"
			dat += "<table align='center'; width='100%'; height='100%'; style='background-color:#13171C'>"
			dat += "<tr style='vertical-align:top'>"
			dat += "<td width=25%><b>Track</b></td>"
			dat += "<td width=20%><b>Progress</b></td>"
			dat += "<td width=10%><b>Next</b></td>"
			dat += "<td width=10%><b>Forced</b></td>"
			dat += "<td width=35%><b>Actions</b></td>"
			dat += "</tr>"
			for(var/track in event_tracks)
				even = !even
				var/background_cl = even ? "#17191C" : "#23273C"
				var/lower = event_track_points[track]
				var/upper = point_thresholds[track]
				var/percent = round((lower/upper)*100)
				var/next = 0
				var/last_points = last_point_gains[track]
				if(last_points)
					var/points_per_second = last_points / (STORYTELLER_WAIT_TIME / 10)
					if(points_per_second > 0)
						next = round((upper - lower) / points_per_second)
				dat += "<tr style='vertical-align:top; background-color: [background_cl];'>"
				dat += "<td>[track] - [last_points] per process.</td>" //Track
				dat += "<td>[percent]% ([lower]/[upper])</td>" //Progress
				dat += "<td>~[next] seconds</td>" //Next
				var/datum/round_event_control/forced_event = forced_next_events[track]
				var/forced = forced_event ? "[forced_event.name] <a href='byond://?src=[REF(src)];panel=main;action=track_action;track_action=remove_forced;track=[track]'>X</a>" : ""
				dat += "<td>[forced]</td>" //Forced
				dat += "<td><a href='byond://?src=[REF(src)];panel=main;action=track_action;track_action=set_pts;track=[track]'>Set Pts.</a> <a href='byond://?src=[REF(src)];panel=main;action=track_action;track_action=next_event;track=[track]'>Next Event</a></td>" //Actions
				dat += "</tr>"
			dat += "</table>"

			dat += "<h2>Scheduled Events:</h2>"
			dat += "<table align='center'; width='100%'; height='100%'; style='background-color:#13171C'>"
			dat += "<tr style='vertical-align:top'>"
			dat += "<td width=30%><b>Name</b></td>"
			dat += "<td width=17%><b>Severity</b></td>"
			dat += "<td width=12%><b>Time</b></td>"
			dat += "<td width=41%><b>Actions</b></td>"
			dat += "</tr>"
			var/sorted_scheduled = list()
			for(var/datum/scheduled_event/scheduled as anything in scheduled_events)
				sorted_scheduled[scheduled] = scheduled.start_time
			sortTim(sorted_scheduled, associative = TRUE)
			even = TRUE
			for(var/datum/scheduled_event/scheduled as anything in sorted_scheduled)
				even = !even
				var/background_cl = even ? "#17191C" : "#23273C"
				dat += "<tr style='vertical-align:top; background-color: [background_cl];'>"
				dat += "<td>[scheduled.event.name]</td>" //Name
				dat += "<td>[scheduled.event.track]</td>" //Severity
				var/time = (scheduled.event.roundstart && !round_started) ? "ROUNDSTART" : "[(scheduled.start_time - world.time) / (1 SECONDS)] s."
				dat += "<td>[time]</td>" //Time
				dat += "<td>[scheduled.get_href_actions()]</td>" //Actions
				dat += "</tr>"
			dat += "</table>"

			dat += "<h2>Running Events:</h2>"
			dat += "<table align='center'; width='100%'; height='100%'; style='background-color:#13171C'>"
			dat += "<tr style='vertical-align:top'>"
			dat += "<td width=30%><b>Name</b></td>"
			dat += "<td width=70%><b>Actions</b></td>"
			dat += "</tr>"
			even = TRUE
			for(var/datum/round_event/event as anything in running)
				even = !even
				var/background_cl = even ? "#17191C" : "#23273C"
				dat += "<tr style='vertical-align:top; background-color: [background_cl];'>"
				dat += "<td>[event.control.name]</td>" //Name
				dat += "<td>-TBA-</td>" //Actions
				dat += "</tr>"
			dat += "</table>"

	var/datum/browser/noclose/popup = new(user, "gamemode_admin_panel", "Gamemode Panel", 670, 650)
	popup.set_content(dat.Join())
	popup.open()

/// Panel containing information and actions regarding events
/datum/controller/subsystem/gamemode/proc/event_panel(mob/user)
	var/list/dat = list()
	if(current_storyteller)
		dat += "Storyteller: [current_storyteller.name]"
		dat += "<BR>Repetition Penalty Multiplier: [current_storyteller.event_repetition_multiplier]"
		dat += "<BR>Cost Variance: [current_storyteller.cost_variance]"
		if(current_storyteller.tag_multipliers)
			dat += "<BR>Tag Multipliers: "
			for(var/tag in current_storyteller.tag_multipliers)
				dat += "[tag]: [current_storyteller.tag_multipliers[tag]] | "
		current_storyteller.calculate_weights(statistics_track_page)
	else
		dat += "Storyteller: None<BR>Weight and chance statistics will be inaccurate due to the present lack of a storyteller."
	dat += "<BR><a href='byond://?src=[REF(src)];panel=stats;action=set_roundstart'[roundstart_event_view ? "class='linkOn'" : ""]>Show Roundstart Events</a> Forced Roundstart events will use rolled points, and are guaranteed to trigger (even if the used points are not enough)"
	dat += "<BR>Average Event Intervals: "
	for(var/track in event_tracks)
		if(last_point_gains[track])
			var/est_time = round((point_thresholds[track] / last_point_gains[track]) * (STORYTELLER_WAIT_TIME / (1 MINUTES)), 1)
			dat += "[track]: ~[est_time] m. | "
	dat += "<HR>"
	for(var/track in EVENT_PANEL_TRACKS)
		dat += "<a href='byond://?src=[REF(src)];panel=stats;action=set_cat;cat=[track]'[(statistics_track_page == track) ? "class='linkOn'" : ""]>[track]</a>"
	dat += "<HR>"
	/// Create event info and stats table
	dat += "<table align='center'; width='100%'; height='100%'; style='background-color:#13171C'>"
	dat += "<tr style='vertical-align:top'>"
	dat += "<td width=17%><b>Name</b></td>"
	dat += "<td width=16%><b>Tags</b></td>"
	dat += "<td width=8%><b>Occurences</b></td>"
	dat += "<td width=8%><b>Max Occurences</b></td>"
	dat += "<td width=5%><b>M.Pop</b></td>"
	dat += "<td width=5%><b>M.Time</b></td>"
	dat += "<td width=7%><b>Can Occur</b></td>"
	dat += "<td width=7%><b>Failure Reason</b></td>"
	dat += "<td width=16%><b>Weight</b></td>"
	dat += "<td width=26%><b>Actions</b></td>"
	dat += "</tr>"
	var/even = TRUE
	var/total_weight = 0
	var/list/event_lookup
	switch(statistics_track_page)
		if(ALL_EVENTS)
			event_lookup = control
		if(UNCATEGORIZED_EVENTS)
			event_lookup = uncategorized
		else
			event_lookup = event_pools[statistics_track_page]
	var/list/assoc_spawn_weight = list()
	for(var/datum/round_event_control/event as anything in event_lookup)
		var/players_amt = get_active_player_count(alive_check = 1, afk_check = 1, human_check = 1)
		if(event.roundstart != roundstart_event_view)
			continue
		if(event.canSpawnEvent(players_amt))
			total_weight += event.calculated_weight
			assoc_spawn_weight[event] = event.calculated_weight
		else
			assoc_spawn_weight[event] = 0
	sortTim(assoc_spawn_weight, cmp = GLOBAL_PROC_REF(cmp_numeric_dsc), associative = TRUE)
	for(var/datum/round_event_control/event as anything in assoc_spawn_weight)
		even = !even
		var/background_cl = even ? "#17191C" : "#23273C"
		dat += "<tr style='vertical-align:top; background-color: [background_cl];'>"
		dat += "<td>[event.name]</td>" //Name
		dat += "<td>" //Tags
		for(var/tag in event.tags)
			dat += "[tag] "
		dat += "</td>"
		var/occurence_string = "[event.occurrences]"
		if(event.shared_occurence_type)
			occurence_string += " (shared: [event.get_occurences()])"
		var/max_occurence_string = "[event.max_occurrences]"
		dat += "<td>[occurence_string]</td>" //Occurences
		dat += "<td>[max_occurence_string]</td>" //Max Occurences
		dat += "<td>[event.min_players]</td>" //Minimum pop
		dat += "<td>[event.earliest_start / (1 MINUTES)] m.</td>" //Minimum time
		dat += "<td>[assoc_spawn_weight[event] ? "Yes" : "No"]</td>" //Can happen?
		dat += "<td>[event.return_failure_string(active_players)]</td>" //Why can't happen?
		var/weight_string = "(New: [event.calculated_weight] / Raw: [event.weight])"
		if(assoc_spawn_weight[event])
			var/percent = round((event.calculated_weight / total_weight) * 100)
			weight_string = "[percent]% - [weight_string]"
		dat += "<td>[weight_string]</td>" //Weight
		dat += "<td>[event.get_href_actions()]</td>" //Actions
		dat += "</tr>"
	dat += "</table>"
	var/datum/browser/noclose/popup = new(user, "gamemode_event_panel", "Event Panel", 1100, 600)
	popup.set_content(dat.Join())
	popup.open()

/datum/controller/subsystem/gamemode/Topic(href, href_list)
	. = ..()
	var/mob/user = usr
	if(!check_rights(R_ADMIN))
		return
	switch(href_list["panel"])
		if("main")
			switch(href_list["action"])
				if("set_storyteller")
					message_admins("[key_name_admin(usr)] is picking a new Storyteller.")
					var/list/name_list = list()
					for(var/storyteller_type in storytellers)
						var/datum/storyteller/storyboy = storytellers[storyteller_type]
						name_list[storyboy.name] = storyboy.type
					var/new_storyteller_name = input(usr, "Choose a new Storyteller (Circumvents voted one):", "Storyteller")  as null|anything in name_list
					if(!new_storyteller_name)
						message_admins("[key_name_admin(usr)] has cancelled picking a Storyteller.")
						return
					message_admins("[key_name_admin(usr)] has chosen [new_storyteller_name] as the new Storyteller.")
					var/new_storyteller_type = name_list[new_storyteller_name]
					set_storyteller(new_storyteller_type)
				if("halt_storyteller")
					halted_storyteller = !halted_storyteller
					message_admins("[key_name_admin(usr)] has [halted_storyteller ? "HALTED" : "un-halted"] the Storyteller.")
				if("vars")
					var/track = href_list["track"]
					switch(href_list["var"])
						if("pts_multiplier")
							var/new_value = input(usr, "New value:", "Set new value") as num|null
							if(isnull(new_value) || new_value < 0)
								return
							message_admins("[key_name_admin(usr)] set point gain multiplier for [track] track to [new_value].")
							point_gain_multipliers[track] = new_value
						if("roundstart_pts")
							var/new_value = input(usr, "New value:", "Set new value") as num|null
							if(isnull(new_value) || new_value < 0)
								return
							message_admins("[key_name_admin(usr)] set roundstart point multiplier for [track] track to [new_value].")
							roundstart_point_multipliers[track] = new_value
						if("min_pop")
							var/new_value = input(usr, "New value:", "Set new value") as num|null
							if(isnull(new_value) || new_value < 0)
								return
							message_admins("[key_name_admin(usr)] set minimum population for [track] track to [new_value].")
							min_pop_thresholds[track] = new_value
						if("pts_threshold")
							var/new_value = input(usr, "New value:", "Set new value") as num|null
							if(isnull(new_value) || new_value < 0)
								return
							message_admins("[key_name_admin(usr)] set point threshold of [track] track to [new_value].")
							point_thresholds[track] = new_value
				if("reload_config_vars")
					message_admins("[key_name_admin(usr)] reloaded gamemode config vars.")
					load_config_vars()
				if("tab")
					var/tab = href_list["tab"]
					panel_page = tab
				if("open_stats")
					event_panel(user)
					return
				if("track_action")
					var/track = href_list["track"]
					if(!(track in event_tracks))
						return
					switch(href_list["track_action"])
						if("remove_forced")
							if(forced_next_events[track])
								var/datum/round_event_control/event = forced_next_events[track]
								message_admins("[key_name_admin(usr)] removed forced event [event.name] from track [track].")
								forced_next_events -= track
						if("set_pts")
							var/set_pts = input(usr, "New point amount ([point_thresholds[track]]+ invokes event):", "Set points for [track]") as num|null
							if(isnull(set_pts))
								return
							event_track_points[track] = set_pts
							message_admins("[key_name_admin(usr)] set points of [track] track to [set_pts].")
							log_admin_private("[key_name(usr)] set points of [track] track to [set_pts].")
						if("next_event")
							message_admins("[key_name_admin(usr)] invoked next event for [track] track.")
							log_admin_private("[key_name(usr)] invoked next event for [track] track.")
							event_track_points[track] = point_thresholds[track]
							if(current_storyteller)
								current_storyteller.handle_tracks()
			admin_panel(user)
		if("stats")
			switch(href_list["action"])
				if("set_roundstart")
					roundstart_event_view = !roundstart_event_view
				if("set_cat")
					var/new_category = href_list["cat"]
					if(new_category in EVENT_PANEL_TRACKS)
						statistics_track_page = new_category
			event_panel(user)

/datum/controller/subsystem/gamemode/proc/store_roundend_data()
	var/congealed_string = ""
	for(var/event_name as anything in triggered_round_events)
		congealed_string += event_name
		congealed_string += ","
	text2file(congealed_string, "data/last_round_events.txt")

/datum/controller/subsystem/gamemode/proc/load_roundstart_data()
	var/massive_string = trim(file2text("data/last_round_events.txt"))
	if(fexists("data/last_round_events.txt"))
		fdel("data/last_round_events.txt")
	if(!massive_string)
		return
	last_round_events = splittext(massive_string, ",")

	if(!length(last_round_events))
		return
	for(var/event_name as anything in last_round_events)
		for(var/datum/round_event_control/listed as anything in control)
			if(listed.name != event_name)
				continue
			listed.occurrences++
			listed.last_round_occurrences++

/// Chooses a number of chronicle stats from the chronicle sets which will be shown at the round end panel
/datum/controller/subsystem/gamemode/proc/pick_chronicle_stats()
	chosen_chronicle_stats.Cut()

	var/list/current_valid_humans = list()
	var/mob/living/carbon/human/valid_psydon_favourite

	for(var/client/client in GLOB.clients)
		var/mob/living/carbon/human/human_mob = client.mob
		if(!ishuman(human_mob) || !human_mob.mind || human_mob.stat == DEAD)
			continue
		current_valid_humans += human_mob
		if(client.has_triumph_buy(TRIUMPH_BUY_PSYDON_FAVOURITE))
			valid_psydon_favourite = human_mob

	if(valid_psydon_favourite && length(current_valid_humans) >= 2)
		chosen_chronicle_stats += CHRONICLE_STATS_PSYDON_FAVOURITE
		chosen_chronicle_stats += CHRONICLE_STATS_RANDOM_PASSERBY
	else if(valid_psydon_favourite)
		chosen_chronicle_stats += CHRONICLE_STATS_PSYDON_FAVOURITE
		for(var/set_name in chronicle_sets)
			var/list/set_data = chronicle_sets[set_name]
			if(length(set_data) >= 2 && GLOB.chronicle_stats[set_data[1]] && GLOB.chronicle_stats[set_data[2]])
				chosen_chronicle_stats += set_data[1]
				break

	var/list/available_complete_sets = list()
	for(var/set_name in chronicle_sets)
		var/list/set_data = chronicle_sets[set_name]
		if(length(set_data) >= 2 && GLOB.chronicle_stats[set_data[1]] && GLOB.chronicle_stats[set_data[2]])
			if(!(set_data[1] in chosen_chronicle_stats) && !(set_data[2] in chosen_chronicle_stats))
				available_complete_sets[set_name] = set_data

	var/slots_needed = MAX_CHRONICLE_STATS - length(chosen_chronicle_stats)
	var/sets_to_pick = FLOOR(slots_needed / 2, 1)

	for(var/i in 1 to sets_to_pick)
		if(!length(available_complete_sets))
			break

		var/picked_set_name = pick(available_complete_sets)
		var/list/picked_set = available_complete_sets[picked_set_name]

		chosen_chronicle_stats += picked_set[1]
		chosen_chronicle_stats += picked_set[2]

		available_complete_sets -= picked_set_name

	if(length(chosen_chronicle_stats) < MAX_CHRONICLE_STATS)
		var/list/all_stats = list()
		for(var/set_name in chronicle_sets)
			var/list/set_data = chronicle_sets[set_name]
			for(var/stat in set_data)
				if(!(stat in chosen_chronicle_stats) && GLOB.chronicle_stats[stat])
					all_stats += stat

		shuffle_inplace(all_stats)
		for(var/stat in all_stats)
			if(length(chosen_chronicle_stats) >= MAX_CHRONICLE_STATS)
				break
			chosen_chronicle_stats += stat

	if(length(chosen_chronicle_stats) < MAX_CHRONICLE_STATS)
		for(var/set_name in chronicle_sets)
			if(length(chosen_chronicle_stats) >= MAX_CHRONICLE_STATS)
				break
			var/list/set_data = chronicle_sets[set_name]
			for(var/stat in set_data)
				if(length(chosen_chronicle_stats) >= MAX_CHRONICLE_STATS)
					break
				if(!(stat in chosen_chronicle_stats))
					chosen_chronicle_stats += stat

/// Compares influence of all storytellers and sets a new storyteller with a highest influence
/datum/controller/subsystem/gamemode/proc/pick_most_influential(roundstart = FALSE)
	refresh_alive_stats(roundstart)
	var/list/storytellers_with_influence = list()
	var/datum/storyteller/highest
	var/datum/storyteller/lowest

	for(var/storyteller_type in storytellers)
		var/datum/storyteller/initialized_storyteller = storytellers[storyteller_type]
		if(!initialized_storyteller)
			continue
		var/influence = calculate_storyteller_influence(storyteller_type)
		storytellers_with_influence[initialized_storyteller] = influence

		if(!highest)
			highest = initialized_storyteller
			lowest = initialized_storyteller
			continue

		if(influence > storytellers_with_influence[highest])
			highest = initialized_storyteller
		else if(influence == storytellers_with_influence[highest] && prob(50))
			highest = initialized_storyteller

		if(influence < storytellers_with_influence[lowest])
			lowest = initialized_storyteller
		else if(influence == storytellers_with_influence[lowest] && prob(50))
			lowest = initialized_storyteller

	if(!highest)
		return

	var/adjustment = min(3, 1 + (0.4 * FLOOR(max(0, highest.times_chosen - 4) / 4, 1)))

	if(storytellers_with_influence[highest] > adjustment)
		highest.bonus_points -= adjustment

	lowest.bonus_points += adjustment

	set_storyteller(highest.type)

/// To get the most influential God
/datum/controller/subsystem/gamemode/proc/get_most_influential(roundstart = FALSE)
	var/list/storytellers_with_influence = list()
	var/datum/storyteller/highest
	for(var/datum/storyteller/initalized_storyteller as anything in storytellers)
		storytellers_with_influence[initalized_storyteller] = calculate_storyteller_influence(initalized_storyteller.type, roundstart)
		if(!highest)
			highest = initalized_storyteller
			continue
		if(storytellers_with_influence[initalized_storyteller] < storytellers_with_influence[highest])
			continue
		if(storytellers_with_influence[initalized_storyteller] == storytellers_with_influence[highest] && prob(50))
			continue
		highest = initalized_storyteller
	return highest

/// Refreshes statistics regarding alive statuses of certain professions or antags, like nobles
/datum/controller/subsystem/gamemode/proc/refresh_alive_stats(roundstart = FALSE, first_post_roundstart_check = FALSE)
	if(SSticker.current_state == GAME_STATE_FINISHED)
		return

	GLOB.patron_follower_counts.Cut()

	GLOB.featured_stats[FEATURED_STATS_FLAWS]["entries"] = list()

	var/list/statistics_to_clear = list(
		STATS_TOTAL_POPULATION,
		STATS_PSYCROSS_USERS,
		STATS_ALIVE_NOBLES,
		STATS_ALIVE_GARRISON,
		STATS_ALIVE_CLERGY,
		STATS_ALIVE_TRADESMEN,
		STATS_ILLITERATES,
		STATS_WEREVOLVES,
		STATS_VAMPIRES,
		STATS_DEADITES_ALIVE,
		STATS_CLINGY_PEOPLE,
		STATS_HUNTED_PEOPLE,
		STATS_ALCOHOLICS,
		STATS_JUNKIES,
		STATS_KLEPTOMANIACS,
		STATS_GREEDY_PEOPLE,
		STATS_PARENTS,
		STATS_PACIFISTS,
		STATS_MARRIED,
		STATS_MALE_POPULATION,
		STATS_FEMALE_POPULATION,
		STATS_OTHER_GENDER,
		STATS_CHILD_POPULATION,
		STATS_ADULT_POPULATION,
		STATS_MIDDLEAGED_POPULATION,
		STATS_ELDERLY_POPULATION,
		STATS_IMMORTAL_POPULATION,
		STATS_ALIVE_TIEFLINGS,
		STATS_ALIVE_NORTHERN_HUMANS,
		STATS_ALIVE_DWARVES,
		STATS_ALIVE_DARK_ELVES,
		STATS_ALIVE_SNOW_ELVES,
		STATS_ALIVE_HALF_ELVES,
		STATS_ALIVE_HALF_DROWS,
		STATS_ALIVE_HALF_ORCS,
		STATS_ALIVE_KOBOLDS,
		STATS_ALIVE_RAKSHARI,
		STATS_ALIVE_AASIMAR,
		STATS_ALIVE_HOLLOWKINS,
		STATS_ALIVE_HARPIES,
		STATS_ALIVE_TRITONS,
		STATS_ALIVE_MEDICATORS,
		STATS_ALIVE_HALFLINGS,
		STATS_FOREIGNERS,
	)

	for(var/stat_name in statistics_to_clear)
		force_set_round_statistic(stat_name, 0)

	var/total_wealth = 0

	var/list/current_valid_humans = list()

	var/mob/living/carbon/human/valid_psydon_favourite

	var/highest_total_stats = -1
	var/highest_strength = -1
	var/highest_intelligence = -1
	var/highest_wealth = -1
	var/highest_luck = -1
	var/highest_speed = -1
	var/highest_perception = -1
	var/highest_constitution = -1
	var/highest_endurance = -1

	var/lowest_total_stats
	var/lowest_strength
	var/lowest_intelligence
	var/lowest_wealth
	var/lowest_luck
	var/lowest_speed
	var/lowest_perception
	var/lowest_constitution
	var/lowest_endurance

	for(var/client/client in GLOB.clients)
		if(roundstart && istype(client?.mob, /mob/dead/new_player))
			var/mob/dead/new_player/player = client.mob
			if(player.ready == PLAYER_READY_TO_PLAY)
				GLOB.patron_follower_counts[client.prefs.selected_patron.name]++

		var/mob/living/living = client.mob
		if(!istype(living))
			continue
		if(!living.mind)
			continue
		if(living.stat == DEAD)
			continue

		if(!roundstart)
			if(living.patron)
				GLOB.patron_follower_counts[living.patron.name]++
				if(living.job == "Monarch")
					force_set_round_statistic(STATS_MONARCH_PATRON, living.patron.name)
		if(living.mind.has_antag_datum(/datum/antagonist/werewolf))
			record_round_statistic(STATS_WEREVOLVES)
		if(living.mind.has_antag_datum(/datum/antagonist/vampire))
			record_round_statistic(STATS_VAMPIRES)
		if(living.mind.has_antag_datum(/datum/antagonist/zombie) || living.mind.has_antag_datum(/datum/antagonist/skeleton) || living.mind.has_antag_datum(/datum/antagonist/lich))
			record_round_statistic(STATS_DEADITES_ALIVE)
		if(ishuman(living))
			var/mob/living/carbon/human/human_mob = client.mob
			current_valid_humans += human_mob
			record_round_statistic(STATS_TOTAL_POPULATION)
			for(var/obj/item/clothing/neck/current_item in human_mob.get_equipped_items(TRUE))
				if(current_item.type in list(/obj/item/clothing/neck/psycross, /obj/item/clothing/neck/psycross/silver, /obj/item/clothing/neck/psycross/g))
					record_round_statistic(STATS_PSYCROSS_USERS)
					break
			switch(human_mob.gender)
				if(MALE)
					record_round_statistic(STATS_MALE_POPULATION)
				if(FEMALE)
					record_round_statistic(STATS_FEMALE_POPULATION)
				else
					record_round_statistic(STATS_OTHER_GENDER)
			switch(human_mob.age)
				if(AGE_CHILD)
					record_round_statistic(STATS_CHILD_POPULATION)
				if(AGE_ADULT)
					record_round_statistic(STATS_ADULT_POPULATION)
				if(AGE_MIDDLEAGED)
					record_round_statistic(STATS_MIDDLEAGED_POPULATION)
				if(AGE_OLD)
					record_round_statistic(STATS_ELDERLY_POPULATION)
				if(AGE_IMMORTAL)
					record_round_statistic(STATS_IMMORTAL_POPULATION)
			if(length(human_mob.quirks))
				for(var/datum/quirk/vice/charflaw in human_mob.quirks)
					record_featured_object_stat(FEATURED_STATS_FLAWS, charflaw.name)
			if(human_mob.is_noble())
				record_round_statistic(STATS_ALIVE_NOBLES)
			if(human_mob.mind.assigned_role.title in GLOB.garrison_positions)
				record_round_statistic(STATS_ALIVE_GARRISON)
			if((human_mob.mind.assigned_role.title in GLOB.church_positions) || (human_mob.mind.assigned_role.title in GLOB.inquisition_positions))
				record_round_statistic(STATS_ALIVE_CLERGY)
			if((human_mob.mind.assigned_role.title in GLOB.serf_positions) || (human_mob.mind.assigned_role.title in GLOB.peasant_positions) || (human_mob.mind.assigned_role.title in GLOB.company_positions))
				record_round_statistic(STATS_ALIVE_TRADESMEN)
			if(!human_mob.is_literate() && !roundstart && !first_post_roundstart_check)
				record_round_statistic(STATS_ILLITERATES)
			if(HAS_TRAIT(human_mob, TRAIT_FOREIGNER))
				record_round_statistic(STATS_FOREIGNERS)
			if(human_mob.has_quirk(/datum/quirk/vice/clingy))
				record_round_statistic(STATS_CLINGY_PEOPLE)
			if(human_mob.has_quirk(/datum/quirk/vice/alcoholic))
				record_round_statistic(STATS_ALCOHOLICS)
			if(human_mob.has_quirk(/datum/quirk/vice/junkie))
				record_round_statistic(STATS_JUNKIES)
			if(human_mob.has_quirk(/datum/quirk/vice/kleptomaniac))
				record_round_statistic(STATS_KLEPTOMANIACS)
			if(human_mob.has_quirk(/datum/quirk/vice/greedy))
				record_round_statistic(STATS_GREEDY_PEOPLE)
			if(human_mob.has_quirk(/datum/quirk/vice/hunted))
				record_round_statistic(STATS_HUNTED_PEOPLE)
			if(HAS_TRAIT_NOT_FROM(human_mob, TRAIT_PACIFISM, "hugbox"))
				record_round_statistic(STATS_PACIFISTS)
			if(human_mob.family_datum && human_mob.family_member_datum)
				var/datum/family_member/member = human_mob.family_member_datum
				if(member.children.len > 0)
					record_round_statistic(STATS_PARENTS)
				if(human_mob.IsWedded())
					record_round_statistic(STATS_MARRIED)

			// Species
			if(istiefling(human_mob))
				record_round_statistic(STATS_ALIVE_TIEFLINGS)
			if(ishumannorthern(human_mob))
				record_round_statistic(STATS_ALIVE_NORTHERN_HUMANS)
			if(isdwarf(human_mob))
				record_round_statistic(STATS_ALIVE_DWARVES)
			if(isdarkelf(human_mob))
				record_round_statistic(STATS_ALIVE_DARK_ELVES)
			if(issnowelf(human_mob))
				record_round_statistic(STATS_ALIVE_SNOW_ELVES)
			if(ishalfelf(human_mob))
				record_round_statistic(STATS_ALIVE_HALF_ELVES)
			if(ishalfdrow(human_mob))
				record_round_statistic(STATS_ALIVE_HALF_DROWS)
			if(ishalforc(human_mob))
				record_round_statistic(STATS_ALIVE_HALF_ORCS)
			if(iskobold(human_mob))
				record_round_statistic(STATS_ALIVE_KOBOLDS)
			if(israkshari(human_mob))
				record_round_statistic(STATS_ALIVE_RAKSHARI)
			if(isaasimar(human_mob))
				record_round_statistic(STATS_ALIVE_AASIMAR)
			if(ishollowkin(human_mob))
				record_round_statistic(STATS_ALIVE_HOLLOWKINS)
			if(isharpy(human_mob))
				record_round_statistic(STATS_ALIVE_HARPIES)
			if(istriton(human_mob))
				record_round_statistic(STATS_ALIVE_TRITONS)
			if(ismedicator(human_mob))
				record_round_statistic(STATS_ALIVE_MEDICATORS)
			if(ishalfling(human_mob))
				record_round_statistic(STATS_ALIVE_HALFLINGS)

			// Chronicle statistics

			if(human_mob.client.has_triumph_buy(TRIUMPH_BUY_PSYDON_FAVOURITE))
				valid_psydon_favourite = human_mob

			var/total_stats = human_mob.STASTR + human_mob.STAINT + human_mob.STAEND + human_mob.STACON + human_mob.STAPER + human_mob.STASPD + human_mob.STALUC
			if(total_stats > highest_total_stats)
				highest_total_stats = total_stats
				set_chronicle_stat(CHRONICLE_STATS_MOST_SKILLS_PERSON, human_mob, "PRODIGY", "#e9de43", "[total_stats] total stats")

			if(human_mob.STASTR > highest_strength)
				highest_strength = human_mob.STASTR
				set_chronicle_stat(CHRONICLE_STATS_STRONGEST_PERSON, human_mob, "STRONGMAN", "#bd1717", "[human_mob.STASTR] strength")

			if(human_mob.STAINT > highest_intelligence)
				highest_intelligence = human_mob.STAINT
				set_chronicle_stat(CHRONICLE_STATS_SMARTEST_PERSON, human_mob, "GENIUS", "#5eb6e6", "[human_mob.STAINT] intelligence")

			if(human_mob.STALUC > highest_luck)
				highest_luck = human_mob.STALUC
				set_chronicle_stat(CHRONICLE_STATS_LUCKIEST_PERSON, human_mob, "LUCKY DEVIL", "#54d666", "[human_mob.STALUC] luck")

			if(human_mob.STASPD > highest_speed)
				highest_speed = human_mob.STASPD
				set_chronicle_stat(CHRONICLE_STATS_FASTEST_PERSON, human_mob, "SPEEDSTER", "#54d6c2", "[human_mob.STASPD] speed")

			if(human_mob.STAPER > highest_perception)
				highest_perception = human_mob.STAPER
				set_chronicle_stat(CHRONICLE_STATS_MOST_PERCEPTIVE_PERSON, human_mob, "EAGLE-EYED", "#a8d654", "[human_mob.STAPER] perception")

			if(human_mob.STACON > highest_constitution)
				highest_constitution = human_mob.STACON
				set_chronicle_stat(CHRONICLE_STATS_MOST_RESILIENT_PERSON, human_mob, "THE ROCK", "#d67c54", "[human_mob.STACON] constitution")

			if(human_mob.STAEND > highest_endurance)
				highest_endurance = human_mob.STAEND
				set_chronicle_stat(CHRONICLE_STATS_MOST_ENDURANT_PERSON, human_mob, "WORKHORSE", "#dbb169", "[human_mob.STAEND] endurance")

			var/wealth = get_mammons_in_atom(human_mob)
			total_wealth += wealth
			if(wealth > highest_wealth)
				highest_wealth = wealth
				set_chronicle_stat(CHRONICLE_STATS_RICHEST_PERSON, human_mob, "MAGNATE", "#d8dd90", "[wealth] mammons")

			if(isnull(lowest_total_stats))
				lowest_total_stats = total_stats
				set_chronicle_stat(CHRONICLE_STATS_LEAST_SKILLS_PERSON, human_mob, "HOPELESS", "#8a8887", "[total_stats] total stats")
			else if(total_stats < lowest_total_stats)
				lowest_total_stats = total_stats
				set_chronicle_stat(CHRONICLE_STATS_LEAST_SKILLS_PERSON, human_mob, "HOPELESS", "#8a8887", "[total_stats] total stats")

			if(isnull(lowest_strength))
				lowest_strength = human_mob.STASTR
				set_chronicle_stat(CHRONICLE_STATS_WEAKEST_PERSON, human_mob, "WIMP", "#a0836a", "[human_mob.STASTR] strength")
			else if(human_mob.STASTR < lowest_strength)
				lowest_strength = human_mob.STASTR
				set_chronicle_stat(CHRONICLE_STATS_WEAKEST_PERSON, human_mob, "WIMP", "#a0836a", "[human_mob.STASTR] strength")

			if(isnull(lowest_intelligence))
				lowest_intelligence = human_mob.STAINT
				set_chronicle_stat(CHRONICLE_STATS_DUMBEST_PERSON, human_mob, "IDIOT", "#e67e22", "[human_mob.STAINT] intelligence")
			else if(human_mob.STAINT < lowest_intelligence)
				lowest_intelligence = human_mob.STAINT
				set_chronicle_stat(CHRONICLE_STATS_DUMBEST_PERSON, human_mob, "IDIOT", "#e67e22", "[human_mob.STAINT] intelligence")

			if(isnull(lowest_speed))
				lowest_speed = human_mob.STASPD
				set_chronicle_stat(CHRONICLE_STATS_SLOWEST_PERSON, human_mob, "TURTLE", "#a569bd", "[human_mob.STASPD] speed")
			else if(human_mob.STASPD < lowest_speed)
				lowest_speed = human_mob.STASPD
				set_chronicle_stat(CHRONICLE_STATS_SLOWEST_PERSON, human_mob, "TURTLE", "#a569bd", "[human_mob.STASPD] speed")

			if(isnull(lowest_luck))
				lowest_luck = human_mob.STALUC
				set_chronicle_stat(CHRONICLE_STATS_UNLUCKIEST_PERSON, human_mob, "WALKING DISASTER", "#e74c3c", "[human_mob.STALUC] luck")
			else if(human_mob.STALUC < lowest_luck)
				lowest_luck = human_mob.STALUC
				set_chronicle_stat(CHRONICLE_STATS_UNLUCKIEST_PERSON, human_mob, "WALKING DISASTER", "#e74c3c", "[human_mob.STALUC] luck")

			if(isnull(lowest_wealth))
				lowest_wealth = wealth
				set_chronicle_stat(CHRONICLE_STATS_POOREST_PERSON, human_mob, "PAUPER", "#909c63", "[wealth] mammons")
			else if(wealth < lowest_wealth)
				lowest_wealth = wealth
				set_chronicle_stat(CHRONICLE_STATS_POOREST_PERSON, human_mob, "PAUPER", "#909c63", "[wealth] mammons")

			if(isnull(lowest_perception))
				lowest_perception = human_mob.STAPER
				set_chronicle_stat(CHRONICLE_STATS_LEAST_PERCEPTIVE_PERSON, human_mob, "CLUELESS", "#9fb9b9", "[human_mob.STAPER] perception")
			else if(human_mob.STAPER < lowest_perception)
				lowest_perception = human_mob.STAPER
				set_chronicle_stat(CHRONICLE_STATS_LEAST_PERCEPTIVE_PERSON, human_mob, "CLUELESS", "#9fb9b9", "[human_mob.STAPER] perception")

			if(isnull(lowest_constitution))
				lowest_constitution = human_mob.STACON
				set_chronicle_stat(CHRONICLE_STATS_LEAST_RESILIENT_PERSON, human_mob, "FRAGILE", "#a8917d", "[human_mob.STACON] constitution")
			else if(human_mob.STACON < lowest_constitution)
				lowest_constitution = human_mob.STACON
				set_chronicle_stat(CHRONICLE_STATS_LEAST_RESILIENT_PERSON, human_mob, "FRAGILE", "#a8917d", "[human_mob.STACON] constitution")

			if(isnull(lowest_endurance))
				lowest_endurance = human_mob.STAEND
				set_chronicle_stat(CHRONICLE_STATS_LEAST_ENDURANT_PERSON, human_mob, "TIRED", "#a8a0a0", "[human_mob.STAEND] endurance")
			else if(human_mob.STAEND < lowest_endurance)
				lowest_endurance = human_mob.STAEND
				set_chronicle_stat(CHRONICLE_STATS_LEAST_ENDURANT_PERSON, human_mob, "TIRED", "#a8a0a0", "[human_mob.STAEND] endurance")

	force_set_round_statistic(STATS_MAMMONS_HELD, total_wealth)

	var/total_bank_wealth = 0
	for(var/account_name in SStreasury.bank_accounts)
		total_bank_wealth += SStreasury.bank_accounts[account_name]
	force_set_round_statistic(STATS_MAMMONS_IN_BANK, total_bank_wealth)

	var/list/potential_passers = current_valid_humans.Copy()
	var/list/beautiful_candidates = list()
	var/list/ugly_candidates = list()

	for(var/mob/living/carbon/human/human_mob in current_valid_humans)
		if(HAS_TRAIT(human_mob, TRAIT_BEAUTIFUL))
			beautiful_candidates += human_mob
		if(HAS_TRAIT(human_mob, TRAIT_UGLY))
			ugly_candidates += human_mob

	if(length(beautiful_candidates) > 0)
		var/mob/living/carbon/human/selected_beautiful = pick(beautiful_candidates)
		set_chronicle_stat(CHRONICLE_STATS_MOST_BEAUTIFUL_PERSON, selected_beautiful, "BEAUTIFUL", "#f5a2ee", "their beauty")

	if(length(ugly_candidates) > 0)
		var/mob/living/carbon/human/selected_ugly = pick(ugly_candidates)
		set_chronicle_stat(CHRONICLE_STATS_UGLIEST_PERSON, selected_ugly, "EYESORE", "#9e6033", "their ugliness")

	if(valid_psydon_favourite)
		set_chronicle_stat(CHRONICLE_STATS_PSYDON_FAVOURITE, valid_psydon_favourite, "PSYDON'S FAVOURITE", "#e6e6e6", "buying their way in")
		potential_passers -= valid_psydon_favourite

	if(length(potential_passers) > 0)
		var/mob/living/carbon/human/selected_passerby = pick(potential_passers)
		set_chronicle_stat(CHRONICLE_STATS_RANDOM_PASSERBY, selected_passerby, "RANDOM PASSERBY", "#888888", "just happening to be here")

	// Featured chronicle stats
	var/highest_laughs = -1
	var/highest_cries = -1
	var/highest_prayers = -1
	var/highest_slurs = -1
	var/mob/living/top_jokester
	var/mob/living/top_crybaby
	var/mob/living/top_pious
	var/mob/living/top_foul_mouth

	for(var/stat_category in GLOB.chronicle_featured_stats)
		var/list/category_data = GLOB.chronicle_featured_stats[stat_category]
		for(var/datum/weakref/mob_ref in category_data)
			var/mob/living/mob = mob_ref.resolve()
			if(!mob || !(mob in current_valid_humans))
				continue

			var/count = category_data[mob_ref]

			if(stat_category == FEATURED_STATS_JOKESTERS)
				if(count > highest_laughs)
					highest_laughs = count
					top_jokester = mob

			if(stat_category == FEATURED_STATS_CRYBABIES)
				if(count > highest_cries)
					highest_cries = count
					top_crybaby = mob

			if(stat_category == FEATURED_STATS_DEVOUT)
				if(count > highest_prayers)
					highest_prayers = count
					top_pious = mob

			if(stat_category == FEATURED_STATS_SPECIESISTS)
				if(count > highest_slurs)
					highest_slurs = count
					top_foul_mouth = mob

	if(top_jokester && highest_laughs > 1)
		set_chronicle_stat(CHRONICLE_STATS_JOKESTER, top_jokester, "JOKESTER", "#fff89b", "[highest_laughs] laughs")

	if(top_crybaby && highest_cries > 1)
		set_chronicle_stat(CHRONICLE_STATS_CRYBABY, top_crybaby, "CRYBABY", "#8bc1ee", "[highest_cries] cries")

	if(top_pious && highest_prayers > 1)
		set_chronicle_stat(CHRONICLE_STATS_PIOUS, top_pious, "PIOUS", "#faf5c7", "[highest_prayers] prayers")

	if(top_foul_mouth && highest_slurs > 1)
		set_chronicle_stat(CHRONICLE_STATS_FOUL_MOUTH, top_foul_mouth, "FOUL MOUTH", "#e23f3f", "[highest_slurs] slurs")

	pick_chronicle_stats()

/// Returns total follower influence for the given storyteller
/datum/controller/subsystem/gamemode/proc/get_follower_influence(datum/storyteller/chosen_storyteller)
	var/datum/storyteller/initialized_storyteller = storytellers[chosen_storyteller]
	if(!initialized_storyteller)
		return 0

	var/follower_count = GLOB.patron_follower_counts[initialized_storyteller.name] || 0
	var/base_mod = initialized_storyteller.follower_modifier
	var/diminish_threshold = 3
	var/second_diminish_threshold = 6
	var/min_mod = 15
	var/second_min_mod = 10

	// Calculate total influence with diminishing returns
	var/total_influence = 0
	var/current_penalty = 0

	for(var/i in 1 to follower_count)
		if(i <= diminish_threshold)
			total_influence += base_mod
			current_penalty = 0
		else if(i <= second_diminish_threshold)
			current_penalty += 1
			total_influence += max(min_mod, base_mod - current_penalty)
		else
			current_penalty += 2
			total_influence += max(second_min_mod, base_mod - current_penalty)

	total_influence = total_influence * initialized_storyteller.influence_modifier

	return total_influence

/// Returns influence value for a given storyteller for his given statistic
/datum/controller/subsystem/gamemode/proc/calculate_specific_influence(datum/storyteller/chosen_storyteller, statistic)
	var/datum/storyteller/initialized_storyteller = storytellers[chosen_storyteller]
	if(!initialized_storyteller)
		return

	if(!(statistic in initialized_storyteller.influence_factors))
		return

	var/influence = 0
	var/stat_value = GLOB.vanderlin_round_stats[statistic]
	var/list/factors = initialized_storyteller.influence_factors[statistic]
	var/modifier = factors["points"]
	var/capacity = factors["capacity"]

	var/scaling_factor = initialized_storyteller.influence_modifier
	if(modifier < 0)
		scaling_factor = 1 / scaling_factor

	var/raw_contribution = (stat_value * modifier) * scaling_factor
	influence = (modifier < 0) ? max(raw_contribution, capacity) : min(raw_contribution, capacity)

	return influence

/// Return total influence of the storyteller, which includes all his statistics and number of their followers
/datum/controller/subsystem/gamemode/proc/calculate_storyteller_influence(datum/storyteller/chosen_storyteller)
	var/datum/storyteller/initialized_storyteller = storytellers[chosen_storyteller]
	if(!initialized_storyteller)
		return 0

	var/total_influence = get_follower_influence(chosen_storyteller)

	for(var/influence_factor in initialized_storyteller.influence_factors)
		total_influence += calculate_specific_influence(chosen_storyteller, influence_factor)

	total_influence += initialized_storyteller.bonus_points

	return total_influence

/// Adjusts bonus points of the storyteller, which is added to their total influence
/proc/adjust_storyteller_influence(god_name, amount)
	for(var/storyteller_type in SSgamemode.storytellers)
		var/datum/storyteller/S = SSgamemode.storytellers[storyteller_type]
		if(S.name == god_name)
			S.bonus_points += amount
			break

/// Gets total storyteller influence by their name
/proc/get_storyteller_influence(god_name)
	for(var/storyteller_type in SSgamemode.storytellers)
		var/datum/storyteller/S = SSgamemode.storytellers[storyteller_type]
		if(S.name == god_name)
			return SSgamemode.calculate_storyteller_influence(S.type)
	return 0

/// Checks if the given storyteller is ascendant
/proc/is_ascendant(god_name)
	. = FALSE
	for(var/storyteller_type in SSgamemode.storytellers)
		var/datum/storyteller/S = SSgamemode.storytellers[storyteller_type]
		if(S.ascendant && (S.name == god_name))
			return TRUE

#undef DEFAULT_STORYTELLER_VOTE_OPTIONS
#undef MAX_POP_FOR_STORYTELLER_VOTE
#undef ROUNDSTART_VALID_TIMEFRAME
