#define LOBBY_SCREEN_SLIDE_DURATION 1.25 SECONDS
#define MOVE_AMOUNT 400

/datum/hud/new_player
	///Whether the menu is currently on the client's screen or not
	var/menu_hud_status = TRUE
	var/list/shown_station_trait_buttons

/datum/hud/new_player/New(mob/owner)
	if (!owner?.client)
		return

	var/atom/movable/screen/using = new /atom/movable/screen/backhudl/empty(null, src)
	static_inventory += using

	var/list/buttons = subtypesof(/atom/movable/screen/lobby)
	for (var/atom/movable/screen/lobby/lobbyscreen as anything in buttons)
		if (!initial(lobbyscreen.always_available))
			continue
		lobbyscreen = new lobbyscreen(null, src)
		static_inventory += lobbyscreen
		if (!lobbyscreen.always_shown)
			lobbyscreen.RegisterSignal(src, COMSIG_HUD_LOBBY_COLLAPSED, TYPE_PROC_REF(/atom/movable/screen/lobby, collapse_button))
			lobbyscreen.RegisterSignal(src, COMSIG_HUD_LOBBY_EXPANDED, TYPE_PROC_REF(/atom/movable/screen/lobby, expand_button))

		if (lobbyscreen.can_be_looked_at_by_skull)
			RegisterSignal(lobbyscreen, COMSIG_ATOM_MOUSE_ENTERED, TYPE_PROC_REF(/datum/hud/new_player, skull_look_at_source))

	. = ..()

/datum/hud/new_player/proc/skull_look_at_source(datum/source)
	SIGNAL_HANDLER

	var/atom/movable/screen/lobby/screen_source = source

	var/atom/movable/screen/lobby/eyes/skull_eyes = locate(/atom/movable/screen/lobby/eyes) in  static_inventory

	var/new_dir = SOUTH

	if(istype(source, /atom/movable/screen/lobby/button/skull))
		skull_eyes.dir = new_dir // if we look at ourselves - assign south
		flick("eyes_hovered_over", skull_eyes)
		return

	var/list/eyes_offsets = screen_loc_to_offset(skull_eyes.screen_loc)

	var/list/source_offsets = screen_loc_to_offset(screen_source.screen_loc)

	var/eyes_x = eyes_offsets[1]
	var/eyes_y = eyes_offsets[2]

	var/source_x = source_offsets[1]
	var/source_y = source_offsets[2]

	var/delta_x = source_x - eyes_x
	var/delta_y = source_y - eyes_y
	if (abs(delta_x) > abs(delta_y) * 2)
		delta_y = 0
	else if (abs(delta_y) > abs(delta_x) * 2)
		delta_x = 0

	new_dir = get_dir_from_offset(SIGN(delta_x), SIGN(delta_y))
	skull_eyes.dir = new_dir

/datum/hud/new_player/proc/everybody_shakes(datum/source)
	SIGNAL_HANDLER
	//var/list/hud_elements = subtypesof(/atom/movable/screen/lobby)

	for(var/atom/movable/screen/element in static_inventory)
		animate(element, element.transform = element.transform.Translate(x = -2 - rand(2, 4), y = 2 + rand(1, 3)), time = 6, easing = ELASTIC_EASING, flags = ANIMATION_PARALLEL)
		animate(element, element.transform = element.transform.Translate(x = -1 - rand(2, 4), y = 2 + rand(1, 3)), time = 3, easing = ELASTIC_EASING)
		animate(element, element.transform = matrix(), time = 3, easing = ELASTIC_EASING)

	shake_camera(mymob, 4, 2)

	playsound(mymob, 'sound/lead_pipe_hit.ogg', 50, TRUE)

//copypaste begin

INITIALIZE_IMMEDIATE(/atom/movable/screen/lobby)

#define BUTTONS_WEST_OFFSET WEST:58

/atom/movable/screen/lobby
	plane = LOBBY_MENU_PLANE
	layer = LOBBY_MENU_LAYER
	screen_loc = "TOP,CENTER"
	/// Whether this HUD element can be hidden from the client's "screen" (moved off-screen) or not
	var/always_shown = FALSE
	/// If true we will create this button every time the HUD is generated
	var/always_available = TRUE
	/// How much to move up on collapse
	var/collapse_y_move = MOVE_AMOUNT
	/// Does the skull look at this when the mouse hovers over it?
	var/can_be_looked_at_by_skull = FALSE
	/// which chink sound to play when clicking this.
	var/click_sound = 'sound/lobby/metal_chink.ogg'

/atom/movable/screen/lobby/Click(location, control, params)
	. = ..()

	click_effect(hud.mymob.client, params)

	if(click_sound)
		hud.mymob.playsound_local(soundin = click_sound, vol = 70, vary = TRUE)

/atom/movable/screen/lobby/proc/click_effect(client/click_client, params)
	var/list/click_params = params2list(params)
	var/click_screen_loc = LAZYACCESS(click_params, SCREEN_LOC)
	if(!click_screen_loc)
		return

	var/list/click_offset = screen_loc_to_offset(click_screen_loc, click_client.view)
	var/atom/movable/screen/chink_click_effect/effect = new
	effect.screen_loc = offset_to_screen_loc(click_offset[1] - 6, click_offset[2] - 6, click_client.view) // I don't even know.
	click_client.screen += effect
	animate(effect, alpha = 0, time = 0.5 SECONDS, flags = ANIMATION_PARALLEL)
	QDEL_IN(effect, 0.6 SECONDS)

/atom/movable/screen/chink_click_effect
	icon = 'icons/hud/lobby/chink.dmi'
	icon_state = "chink"
	plane = LOBBY_MENU_PLANE
	layer = LOBBY_BOTTOM_BUTTON_LAYER
	alpha = 200
	mouse_opacity = MOUSE_OPACITY_TRANSPARENT

///Run sleeping actions after initialize
/atom/movable/screen/lobby/proc/SlowInit()
	return

///Animates moving the button off-screen
/atom/movable/screen/lobby/proc/collapse_button(datum/source)
	SIGNAL_HANDLER
	animate(src, transform = transform.Translate(x = 0, y = -10), time = 0.20 SECONDS, easing = CUBIC_EASING|EASE_IN|EASE_OUT)
	animate(transform = transform.Translate(x = 0, y = collapse_y_move + 10), time = LOBBY_SCREEN_SLIDE_DURATION, easing = CUBIC_EASING|EASE_IN|EASE_OUT)

///Animates moving the button back into place
/atom/movable/screen/lobby/proc/expand_button(datum/source)
	SIGNAL_HANDLER
	animate(src, transform = transform.Translate(x = 0, y = -collapse_y_move - 10), time = LOBBY_SCREEN_SLIDE_DURATION, easing = CUBIC_EASING|EASE_IN|EASE_OUT)
	animate(transform = transform.Translate(x = 0, y = 10), time = 0.35 SECONDS, easing = CUBIC_EASING|EASE_IN|EASE_OUT)

/atom/movable/screen/lobby/chain
	icon = 'icons/hud/lobby/chain.dmi'
	icon_state = "chain"
	layer = LOBBY_BACKGROUND_LAYER
	screen_loc = "WEST:10,TOP:145"
	collapse_y_move = 150
	click_sound = 'sound/lobby/metal_chink_light.ogg'

/atom/movable/screen/lobby/left_chassis
	icon = 'icons/hud/lobby/left_chassis.dmi'
	icon_state = "left_chassis"
	layer = LOBBY_BACKGROUND_LAYER
	screen_loc = "WEST:29,TOP:5"

/atom/movable/screen/lobby/right_chassis
	icon = 'icons/hud/lobby/right_chassis.dmi'
	icon_state = "right_chassis"
	plane = LOBBY_MENU_PLANE
	layer = LOBBY_BACKGROUND_LAYER - 0.1
	screen_loc = "WEST:139,TOP:6"
	var/collapsed = FALSE

/atom/movable/screen/lobby/right_chassis/right_chassis_screen
	icon = 'icons/hud/lobby/right_chassis_screen.dmi'
	icon_state = "right_chassis_screen"
	layer = LOBBY_BELOW_MENU_LAYER
	screen_loc = "WEST:170,TOP:-32"
	maptext_width = 450
	maptext_height = 280
	maptext_x = 20
	maptext_y = 230
	click_sound = 'sound/lobby/glass_chink.ogg'
	var/refresh_timer

/atom/movable/screen/lobby/right_chassis/right_chassis_screen/Initialize(mapload, datum/hud/hud_owner)
	. = ..()
	RegisterSignal(SSdcs, COMSIG_GLOB_PLAYER_READY_TOGGLE, PROC_REF(update_ready_players))
	RegisterSignal(SSticker, COMSIG_TICKER_ROUND_STARTING, PROC_REF(show_actors_list))
	update_display()
	refresh_timer = addtimer(CALLBACK(src, PROC_REF(update_display)), 1 SECONDS, TIMER_LOOP | TIMER_STOPPABLE)

/atom/movable/screen/lobby/right_chassis/right_chassis_screen/Destroy(force)
	if(refresh_timer)
		deltimer(refresh_timer)
	return ..()

/atom/movable/screen/lobby/right_chassis/right_chassis_screen/proc/update_display()
	if(SSticker.current_state >= GAME_STATE_PLAYING)
		render_actors_list()
		return

	render_ready_players()

/atom/movable/screen/lobby/right_chassis/right_chassis_screen/proc/update_ready_players(datum/source)
	SIGNAL_HANDLER
	update_display()

/atom/movable/screen/lobby/right_chassis/right_chassis_screen/proc/show_actors_list(datum/source, round_start_time)
	SIGNAL_HANDLER
	render_actors_list()

/atom/movable/screen/lobby/right_chassis/right_chassis_screen/proc/render_ready_players()
	var/list/readied_names = list()
	for(var/mob/dead/new_player/player as anything in GLOB.new_player_list)
		if(!player.client || !player.client.prefs || player.ready != PLAYER_READY_TO_PLAY)
			continue

		var/player_name = player.client.prefs.read_preference(/datum/preference/text/real_name)
		if(!length(player_name))
			player_name = player.client.key

		var/readied_job = "No high-priority job"
		for(var/job_title in player.client.prefs.job_preferences)
			if(player.client.prefs.job_preferences[job_title] != JP_HIGH)
				continue

			var/datum/job/job
			if(job_title in SSjob.name_occupations)
				job = SSjob.name_occupations[job_title]
			if(job)
				var/list/selected_titles
				var/list/alt_job_selections = player.client.prefs.alt_job_selections
				if(alt_job_selections && (job_title in alt_job_selections))
					selected_titles = alt_job_selections[job_title]
				if(selected_titles && ("title" in selected_titles))
					readied_job = selected_titles["title"]
				else
					readied_job = player.client.prefs.get_job_display_name(job)
			else
				readied_job = job_title
			break

		readied_names += "[html_encode(player_name)] - [html_encode(readied_job)]"

	var/countdown = SSticker.current_state == GAME_STATE_SETTING_UP ? "Starting..." : DisplayTimeText(SSticker.GetTimeLeft())
	var/readied_list = "No players readied"
	if(length(readied_names))
		if(length(readied_names) > 12)
			var/split_index = CEILING(length(readied_names) / 2, 1)
			var/list/left_column = list()
			var/list/right_column = list()
			for(var/index in 1 to length(readied_names))
				if(index <= split_index)
					left_column += readied_names[index]
				else
					right_column += readied_names[index]

			var/left_column_text = left_column.Join("<br>")
			var/right_column_text = right_column.Join("<br>")
			readied_list = "<div style='display: inline-block; vertical-align: top; width: 210px;'>[left_column_text]</div><div style='display: inline-block; vertical-align: top; width: 210px;'>[right_column_text]</div>"
		else
			readied_list = readied_names.Join("<br>")
	maptext = MAPTEXT("<span style='font-size: 8pt; color: #FFFFFF; text-shadow: 1px 1px 1px #000000;'><b>Players online:</b> [GLOB.clients.len]<br><b>Map:</b> [html_encode(SSmapping.config.map_name)]<br><b>Round starts in:</b> [countdown]<br><br><b>Readied players ([length(readied_names)]):</b><br>[readied_list]</span>")

/atom/movable/screen/lobby/right_chassis/right_chassis_screen/proc/render_actors_list()
	var/list/actor_entries = list()
	for(var/actor_id in GLOB.actors_list)
		actor_entries += GLOB.actors_list[actor_id]

	var/actors = length(actor_entries) ? actor_entries.Join() : "No actors recorded"
	var/round_duration = DisplayTimeText(world.time - SSticker.round_start_time)
	maptext = MAPTEXT("<span style='font-size: 8pt; color: #FFFFFF; text-shadow: 1px 1px 1px #000000;'><b>Players online:</b> [GLOB.clients.len]<br><b>Map:</b> [html_encode(SSmapping.config.map_name)]<br><b>Round has been going for:</b> [round_duration]<br><b>Actors listed ([length(actor_entries)]):</b><br>[actors]</span>")

/atom/movable/screen/lobby/right_chassis/right_chassis_screen/toggle_right_chassis(datum/source) // dogshit
	if(collapsed)
		animate(src, transform = matrix(), time = 0.5 SECONDS, easing = CUBIC_EASING|EASE_IN, flags = ANIMATION_PARALLEL)
	else
		animate(src, transform = transform.Translate(x = 450, y = 0), time = 0.4 SECONDS, easing = CUBIC_EASING|EASE_IN, flags = ANIMATION_PARALLEL)
	collapsed = !collapsed

/atom/movable/screen/lobby/right_chassis/Initialize(mapload, datum/hud/hud_owner)
	. = ..()
	RegisterSignal(hud, COMSIG_HUD_RIGHT_CHASSIS_TOGGLED, TYPE_PROC_REF(/atom/movable/screen/lobby/right_chassis, toggle_right_chassis))

/atom/movable/screen/lobby/right_chassis/proc/toggle_right_chassis(datum/source)
	SIGNAL_HANDLER
	if(collapsed)
		animate(src, transform = matrix(), time = 0.5 SECONDS, easing = CUBIC_EASING|EASE_IN, flags = ANIMATION_PARALLEL)
		addtimer(CALLBACK(hud, TYPE_PROC_REF(/datum/hud/new_player, everybody_shakes)), 0.6 SECONDS)
	else
		animate(src, transform = transform.Translate(x = 450, y = 0), time = 0.4 SECONDS, easing = CUBIC_EASING|EASE_IN, flags = ANIMATION_PARALLEL)
	collapsed = !collapsed

/atom/movable/screen/lobby/right_chassis/proc/signal_shake(datum/source)
	SIGNAL_HANDLER
	SEND_SIGNAL(hud, COMSIG_HUD_EVERYBODY_SHAKE)

/atom/movable/screen/lobby/button
	mouse_over_pointer = MOUSE_HAND_POINTER
	///Is the button currently enabled?
	VAR_PROTECTED/enabled = TRUE
	///Is the button currently being hovered over with the mouse?
	var/highlighted = FALSE
	layer = LOBBY_MENU_LAYER
	can_be_looked_at_by_skull = TRUE

	click_sound = 'sound/lobby/button_press.ogg'

/atom/movable/screen/lobby/button/Click(location, control, params)
	if(!usr.client)
		return

	. = ..()

	if(!enabled)
		return

	flick("[base_icon_state]_pressed", src)

	return TRUE

/atom/movable/screen/lobby/button/MouseEntered(location, control, params)
	. = ..()
	if(!enabled)
		return

/atom/movable/screen/lobby/button/MouseEntered(location,control,params)
	if(!usr.client)
		return

	. = ..()
	highlighted = TRUE
	update_appearance(UPDATE_ICON)

/atom/movable/screen/lobby/button/MouseExited()
	if(!usr.client)
		return

	. = ..()
	highlighted = FALSE
	update_appearance(UPDATE_ICON)

/atom/movable/screen/lobby/button/update_icon(updates)
	. = ..()
	if(!enabled)
		icon_state = "[base_icon_state]_disabled"
		return
	else if(highlighted)
		icon_state = "[base_icon_state]_highlighted"
		return
	icon_state = base_icon_state

///Updates the button's status: TRUE to enable interaction with the button, FALSE to disable
/atom/movable/screen/lobby/button/proc/set_button_status(status)
	if(status == enabled)
		return FALSE
	enabled = status
	update_appearance(UPDATE_ICON)
	mouse_over_pointer = enabled ? MOUSE_HAND_POINTER : MOUSE_INACTIVE_POINTER
	return TRUE

/atom/movable/screen/lobby/button/skull
	icon = 'icons/hud/lobby/skull.dmi'
	base_icon_state = "skull"
	icon_state = "skull"
	screen_loc = "WEST:1,TOP:-150"
	collapse_y_move = 150
	var/blip_enabled = TRUE

/atom/movable/screen/lobby/eyes
	icon = 'icons/hud/lobby/eyes.dmi'
	base_icon_state = "eyes"
	icon_state = "eyes"
	layer = LOBBY_SHUTTER_LAYER
	screen_loc = "WEST:1,TOP:-151" // FORGIVE ME, I WAS LAZY
	collapse_y_move = 150

/atom/movable/screen/lobby/button/skull/proc/collapse_menu()
	SEND_SIGNAL(hud, COMSIG_HUD_LOBBY_COLLAPSED)
	playsound(hud.mymob, 'sound/lobby/metal_chain.ogg', 50, TRUE)

/atom/movable/screen/lobby/button/skull/proc/expand_menu()
	SEND_SIGNAL(hud, COMSIG_HUD_LOBBY_EXPANDED)
	playsound(hud.mymob, 'sound/lobby/metal_chain.ogg', 50, TRUE)

/atom/movable/screen/lobby/button/skull/Click(location, control, params)
	. = ..()
	if(!.)
		return

	if(!enabled)
		return

	if(!istype(hud, /datum/hud/new_player))
		return
	var/datum/hud/new_player/our_hud = hud
	//base_icon_state = our_hud.menu_hud_status ? "expand" : "collapse"
	// name = "[our_hud.menu_hud_status ? "Expand" : "Collapse"] Lobby Menu"
	set_button_status(FALSE)

	//animate bottom buttons' movement
	if(our_hud.menu_hud_status)
		collapse_menu()
	else
		expand_menu()
	our_hud.menu_hud_status = !our_hud.menu_hud_status

	//re-enable clicking the button when the shutter animation finishes
	//we use sleep here so it can work during game setup, as addtimer would not work until the game would finish setting up
	sleep(1.1 * LOBBY_SCREEN_SLIDE_DURATION)
	set_button_status(TRUE)

///Prefs menu
/atom/movable/screen/lobby/button/character_setup
	name = "View Character Setup"
	screen_loc = "WEST:57,TOP:-90"
	icon = 'icons/hud/lobby/character_setup.dmi'
	icon_state = "character_setup"
	base_icon_state = "character_setup"
	enabled = FALSE

/atom/movable/screen/lobby/meter_arrow
	name = "Meter arrow"
	screen_loc = "WEST:29,TOP:-22"
	icon = 'icons/hud/lobby/meter_arrow.dmi'
	icon_state = "ticking"
	base_icon_state = "ticking"
	layer = LOBBY_MENU_LAYER
	click_sound = 'sound/lobby/glass_chink.ogg'

/atom/movable/screen/lobby/button/character_setup/Initialize(mapload, datum/hud/hud_owner)
	. = ..()

	if(SSatoms.initialized == INITIALIZATION_INNEW_REGULAR)
		flick("[base_icon_state]_enabled", src)
		set_button_status(TRUE)
	else
		set_button_status(FALSE)
		RegisterSignal(SSatoms, COMSIG_SUBSYSTEM_POST_INITIALIZE, PROC_REF(enable_character_setup))

/atom/movable/screen/lobby/button/character_setup/Click(location, control, params)
	. = ..()
	if(!.)
		return

	hud.mymob.client?.setup_character()

/atom/movable/screen/lobby/button/character_setup/proc/enable_character_setup(datum/source)
	SIGNAL_HANDLER
	flick("[base_icon_state]_enabled", src)
	set_button_status(TRUE)

///Button that appears before the game has started
/atom/movable/screen/lobby/button/ready
	name = "Toggle Readiness"
	screen_loc = "WEST:57,TOP:-150"
	icon = 'icons/hud/lobby/ready_button.dmi'
	icon_state = "not_ready"
	base_icon_state = "not_ready"
	///Whether we are readied up for the round or not
	var/ready = FALSE

/atom/movable/screen/lobby/button/ready/Initialize(mapload, datum/hud/hud_owner)
	. = ..()
	switch(SSticker.current_state)
		if(GAME_STATE_PREGAME, GAME_STATE_STARTUP)
			RegisterSignal(SSticker, COMSIG_TICKER_ENTER_SETTING_UP, PROC_REF(hide_ready_button))
		if(GAME_STATE_SETTING_UP)
			set_button_status(FALSE)
			RegisterSignal(SSticker, COMSIG_TICKER_ERROR_SETTING_UP, PROC_REF(show_ready_button))
		else
			set_button_status(FALSE)

/atom/movable/screen/lobby/button/ready/proc/hide_ready_button(datum/source)
	SIGNAL_HANDLER
	set_button_status(FALSE)
	UnregisterSignal(SSticker, COMSIG_TICKER_ENTER_SETTING_UP)
	RegisterSignal(SSticker, COMSIG_TICKER_ERROR_SETTING_UP, PROC_REF(show_ready_button))

/atom/movable/screen/lobby/button/ready/proc/show_ready_button(datum/source)
	SIGNAL_HANDLER
	set_button_status(TRUE)
	UnregisterSignal(SSticker, COMSIG_TICKER_ERROR_SETTING_UP)
	RegisterSignal(SSticker, COMSIG_TICKER_ENTER_SETTING_UP, PROC_REF(hide_ready_button))

/atom/movable/screen/lobby/button/ready/Click(location, control, params)
	. = ..()
	if(!.)
		return
	var/mob/dead/new_player/new_player = hud.mymob
	ready = !ready
	if(ready)
		new_player.ready = PLAYER_READY_TO_PLAY
		base_icon_state = "ready"
	else
		new_player.ready = PLAYER_NOT_READY
		base_icon_state = "not_ready"
	update_appearance(UPDATE_ICON)
	SEND_SIGNAL(hud, COMSIG_HUD_PLAYER_READY_TOGGLE)
	SEND_GLOBAL_SIGNAL(COMSIG_GLOB_PLAYER_READY_TOGGLE)

///Shown when the game has started
/atom/movable/screen/lobby/button/join
	name = "Join Game"
	screen_loc = "WEST:57,TOP:-150"
	icon = 'icons/hud/lobby/join_button.dmi'
	icon_state = "" //Default to not visible
	base_icon_state = ""
	enabled = null // set in init

/atom/movable/screen/lobby/button/join/Initialize(mapload, datum/hud/hud_owner)
	. = ..()
	switch(SSticker.current_state)
		if(GAME_STATE_PREGAME, GAME_STATE_STARTUP)
			set_button_status(FALSE)
			RegisterSignal(SSticker, COMSIG_TICKER_ENTER_SETTING_UP, PROC_REF(show_join_button))
		if(GAME_STATE_SETTING_UP)
			set_button_status(TRUE)
			RegisterSignal(SSticker, COMSIG_TICKER_ERROR_SETTING_UP, PROC_REF(hide_join_button))
		else
			set_button_status(TRUE)

/atom/movable/screen/lobby/button/join/Click(location, control, params)
	. = ..()
	if(!.)
		return

	if(!SSticker?.IsRoundInProgress())
		to_chat(hud.mymob, span_boldwarning("The round is either not ready, or has already finished..."))
		return

	//Determines Relevent Population Cap
	var/relevant_cap
	var/hard_popcap = CONFIG_GET(number/hard_popcap)
	var/extreme_popcap = CONFIG_GET(number/extreme_popcap)
	if(hard_popcap && extreme_popcap)
		relevant_cap = min(hard_popcap, extreme_popcap)
	else
		relevant_cap = max(hard_popcap, extreme_popcap)

	var/mob/dead/new_player/new_player = hud.mymob

	if(SSticker.queued_players.len || (relevant_cap && living_player_count() >= relevant_cap && !(ckey(new_player.key) in GLOB.admin_datums)))
		to_chat(new_player, span_danger("[CONFIG_GET(string/hard_popcap_message)]"))

		var/queue_position = SSticker.queued_players.Find(new_player)
		if(queue_position == 1)
			to_chat(new_player, span_notice("You are next in line to join the game. You will be notified when a slot opens up."))
		else if(queue_position)
			to_chat(new_player, span_notice("There are [queue_position-1] players in front of you in the queue to join the game."))
		else
			SSticker.queued_players += new_player
			to_chat(new_player, span_notice("You have been added to the queue to join the game. Your position in queue is [SSticker.queued_players.len]."))
		return

	new_player.LateChoices()

/atom/movable/screen/lobby/button/join/proc/show_join_button()
	SIGNAL_HANDLER
	set_button_status(TRUE)

/atom/movable/screen/lobby/button/join/proc/hide_join_button()
	SIGNAL_HANDLER
	set_button_status(FALSE)

/atom/movable/screen/lobby/button/lore
	name = "Lore Primer"
	screen_loc = "WEST:57,TOP:-185"
	icon = 'icons/hud/lobby/lore.dmi'
	icon_state = "lore"
	base_icon_state = "lore"

/atom/movable/screen/lobby/button/lore/Click(location, control, params)
	. = ..()
	if(!.)
		return

	var/datum/preferences/prefs = hud.mymob.client?.prefs
	prefs?.lore_popup(hud.mymob)

/atom/movable/screen/lobby/button/migration
	name = "Migration"
	screen_loc = "WEST:57,TOP:-220"
	icon = 'icons/hud/lobby/migrate.dmi'
	icon_state = "migrate"
	base_icon_state = "migrate"

/atom/movable/screen/lobby/button/migration/Click(location, control, params)
	. = ..()
	if(!.)
		return

	var/datum/migrant_pref/migrant = hud.mymob.client?.prefs.migrant

	migrant.show_ui()

/atom/movable/screen/lobby/button/collapse_right_chassis
	name = "Actors"
	screen_loc = "WEST:57,TOP:-255"
	icon = 'icons/hud/lobby/actors.dmi'
	icon_state = "actors"
	base_icon_state = "actors"

/atom/movable/screen/lobby/button/collapse_right_chassis/Click(location, control, params)
	. = ..()
	if(!.)
		return

	SEND_SIGNAL(hud, COMSIG_HUD_RIGHT_CHASSIS_TOGGLED)

	//hud.mymob.client?.view_actors_manifest()



#undef LOBBY_SCREEN_SLIDE_DURATION
#undef MOVE_AMOUNT
#undef BUTTONS_WEST_OFFSET
