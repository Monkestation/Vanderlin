#define LOBBY_SCREEN_SLIDE_DURATION 1.25 SECONDS
#define MOVE_AMOUNT 400

/datum/hud/new_player
	///Whether the menu is currently on the client's screen or not
	var/menu_hud_status = TRUE
	var/list/shown_station_trait_buttons

/datum/hud/new_player/New(mob/owner)

	scannies = new /atom/movable/screen/scannies(null, src)
	static_inventory += scannies
	if(owner.client?.prefs?.crt == TRUE)
		scannies.alpha = 70

	if (!owner?.client)
		return

	var/list/buttons = subtypesof(/atom/movable/screen/lobby)
	for (var/atom/movable/screen/lobby/lobbyscreen as anything in buttons)
		if (!initial(lobbyscreen.always_available))
			continue
		lobbyscreen = new lobbyscreen(null, src)
		static_inventory += lobbyscreen
		if (!lobbyscreen.always_shown)
			lobbyscreen.RegisterSignal(src, COMSIG_HUD_LOBBY_COLLAPSED, TYPE_PROC_REF(/atom/movable/screen/lobby, collapse_button))
			lobbyscreen.RegisterSignal(src, COMSIG_HUD_LOBBY_EXPANDED, TYPE_PROC_REF(/atom/movable/screen/lobby, expand_button))

	. = ..()

//copypaste begin

INITIALIZE_IMMEDIATE(/atom/movable/screen/lobby)

/atom/movable/screen/lobby
	plane = LOBBY_MENU_PLANE
	layer = LOBBY_MENU_LAYER
	screen_loc = "TOP,CENTER"
	/// Whether this HUD element can be hidden from the client's "screen" (moved off-screen) or not
	var/always_shown = FALSE
	/// If true we will create this button every time the HUD is generated
	var/always_available = TRUE
	alpha = 210

///Run sleeping actions after initialize
/atom/movable/screen/lobby/proc/SlowInit()
	return

///Animates moving the button off-screen
/atom/movable/screen/lobby/proc/collapse_button()
	SIGNAL_HANDLER
	animate(src, transform = transform.Translate(x = 0, y = MOVE_AMOUNT), time = LOBBY_SCREEN_SLIDE_DURATION, easing = CUBIC_EASING|EASE_IN|EASE_OUT)

///Animates moving the button back into place
/atom/movable/screen/lobby/proc/expand_button()
	SIGNAL_HANDLER
	animate(src, transform = matrix(), time = LOBBY_SCREEN_SLIDE_DURATION, easing = CUBIC_EASING|EASE_IN|EASE_OUT)

/atom/movable/screen/lobby/background
	icon = 'icons/hud/lobby/background.dmi'
	icon_state = "background"
	plane = LOBBY_MENU_PLANE
	layer = LOBBY_BACKGROUND_LAYER
	screen_loc = "WEST:10,TOP:10"
	alpha = 150

/atom/movable/screen/lobby/button
	mouse_over_pointer = MOUSE_HAND_POINTER
	///Is the button currently enabled?
	VAR_PROTECTED/enabled = TRUE
	///Is the button currently being hovered over with the mouse?
	var/highlighted = FALSE
	///Should this button play the select sound?
	var/select_sound_play = TRUE
	layer = LOBBY_MENU_LAYER

/atom/movable/screen/lobby/button/Click(location, control, params)
	if(!usr.client)
		return

	. = ..()

	if(!enabled)
		return

	flick("[base_icon_state]_pressed", src)
	if(select_sound_play)
		hud.mymob.playsound_local(soundin = 'sound/menu/button_press.ogg', vol = 50, vary = TRUE)
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

///Prefs menu
/atom/movable/screen/lobby/button/character_setup
	name = "View Character Setup"
	screen_loc = "WEST:19,TOP:-10"
	icon = 'icons/hud/lobby/character_sheet.dmi'
	icon_state = "character_sheet_disabled"
	base_icon_state = "character_sheet"
	enabled = FALSE

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

/atom/movable/screen/lobby/button/character_setup/proc/enable_character_setup()
	SIGNAL_HANDLER
	flick("[base_icon_state]_enabled", src)
	set_button_status(TRUE)

///Button that appears before the game has started
/atom/movable/screen/lobby/button/ready
	name = "Toggle Readiness"
	screen_loc = "WEST:20,TOP:-68"
	icon = 'icons/hud/lobby/ready.dmi'
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

/atom/movable/screen/lobby/button/ready/proc/hide_ready_button()
	SIGNAL_HANDLER
	set_button_status(FALSE)
	UnregisterSignal(SSticker, COMSIG_TICKER_ENTER_SETTING_UP)
	RegisterSignal(SSticker, COMSIG_TICKER_ERROR_SETTING_UP, PROC_REF(show_ready_button))

/atom/movable/screen/lobby/button/ready/proc/show_ready_button()
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

///Shown when the game has started
/atom/movable/screen/lobby/button/join
	name = "Join Game"
	screen_loc = "WEST:20,TOP:-68"
	icon = 'icons/hud/lobby/join_game.dmi'
	icon_state = "" //Default to not visible
	base_icon_state = "join_game"
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
	screen_loc = "WEST:20,TOP:-101"
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
	screen_loc = "WEST:20,TOP:-134"
	icon = 'icons/hud/lobby/migration.dmi'
	icon_state = "migration"
	base_icon_state = "migration"

/atom/movable/screen/lobby/button/migration/Click(location, control, params)
	. = ..()
	if(!.)
		return

	var/datum/migrant_pref/migrant = hud.mymob.client?.prefs.migrant

	migrant.show_ui()

/atom/movable/screen/lobby/button/actors
	name = "Actors"
	screen_loc = "WEST:20,TOP:-167"
	icon = 'icons/hud/lobby/actors.dmi'
	icon_state = "actors"
	base_icon_state = "actors"

/atom/movable/screen/lobby/button/actors/Click(location, control, params)
	. = ..()
	if(!.)
		return

	hud.mymob.client?.view_actors_manifest()

/atom/movable/screen/lobby/button/collapse
	name = "Collapse Lobby Menu"
	icon = 'icons/hud/lobby/collapse_expand.dmi'
	icon_state = "collapse"
	base_icon_state = "collapse"
	layer = LOBBY_BELOW_MENU_LAYER
	screen_loc = "WEST:10,TOP:-390"
	always_shown = TRUE

	var/blip_enabled = TRUE

/atom/movable/screen/lobby/button/collapse/proc/collapse_menu()
	SEND_SIGNAL(hud, COMSIG_HUD_LOBBY_COLLAPSED)
	//wait for the shutter to come down
	collapse_button()

/atom/movable/screen/lobby/button/collapse/proc/expand_menu()
	SEND_SIGNAL(hud, COMSIG_HUD_LOBBY_EXPANDED)
	expand_button()

/atom/movable/screen/lobby/button/collapse/Click(location, control, params)
	. = ..()
	if(!.)
		return

	if(!enabled)
		return

	if(!istype(hud, /datum/hud/new_player))
		return
	var/datum/hud/new_player/our_hud = hud
	base_icon_state = our_hud.menu_hud_status ? "expand" : "collapse"
	name = "[our_hud.menu_hud_status ? "Expand" : "Collapse"] Lobby Menu"
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

#undef LOBBY_SCREEN_SLIDE_DURATION
#undef MOVE_AMOUNT
