/datum/anvil_challenge
	var/start_time
	var/completed = FALSE
	var/mob/user
	var/background = "background_default"
	var/list/anvil_presses = list()
	var/list/note_pixels_moved = list()
	var/atom/movable/screen/anvil_hud/anvil_hud
	var/datum/anvil_recipe/selected_recipe
	var/obj/machinery/anvil/host_anvil
	var/difficulty = 1
	var/success = 100
	var/off_time = 0
	var/notes_left = 0
	var/total_notes = 0
	var/failed_notes = 0
	var/debug = FALSE
	var/average_ping = 0
	var/had_context = FALSE

/datum/anvil_challenge/New(obj/machinery/anvil/anvil, datum/anvil_recipe/end_product_recipe, mob/user, difficulty_modifier)
	host_anvil = anvil
	src.user = user
	selected_recipe = end_product_recipe

	var/user_skill = user.get_skill_level(end_product_recipe.appro_skill)
	if(user_skill < end_product_recipe.craftdiff)
		difficulty_modifier *= 2

	difficulty = difficulty_modifier
	notes_left = max(5, round(difficulty_modifier * 2))
	total_notes = notes_left

	if(isdwarf(user) && difficulty > 1)
		difficulty--

	generate_anvil_beats(TRUE)

	if(QDELETED(user.client) || user.incapacitated())
		return FALSE
	. = TRUE
	anvil_hud = new
	anvil_hud.prepare_minigame(src, anvil_presses)
	RegisterSignal(user.client, COMSIG_CLIENT_CLICK_DIRTY, PROC_REF(check_click))
	had_context = user.client.show_popup_menus
	user.client.show_popup_menus = FALSE

	START_PROCESSING(SSanvil, src)

/datum/anvil_challenge/Destroy(force)
	if(anvil_hud)
		user?.client?.screen -= anvil_hud
		QDEL_NULL(anvil_hud)
	user = null
	selected_recipe = null
	host_anvil = null
	return ..()

/datum/anvil_challenge/proc/generate_anvil_beats(init = FALSE)
	var/list/new_notes = list()

	var/last_note_time = REALTIMEOFDAY + 1 SECONDS
	for(var/i = 1 to min(rand(1,5), notes_left))
		notes_left--
		var/atom/movable/screen/hud_note/hud_note = new(null, null, src)
		var/time = rand(5, 10)
		if(difficulty >= 6)
			time /= round((difficulty - 4) * 0.5)
		hud_note.generate_click_type(difficulty)
		hud_note.pixel_x += 138
		anvil_presses += hud_note
		anvil_presses[hud_note] = last_note_time + time

		if(debug)
			hud_note.maptext = "[last_note_time + time] - 170"
		last_note_time += time

		animate(hud_note, last_note_time - REALTIMEOFDAY, pixel_x = hud_note.pixel_x - 170)
		animate(alpha=0, time = 0.4 SECONDS)

		note_pixels_moved += hud_note
		note_pixels_moved[hud_note] = 0
		new_notes |= hud_note

	if(!init)
		anvil_hud.add_notes(new_notes)

/datum/anvil_challenge/proc/check_click(datum/source, atom/target, atom/location, control, params, mob/user)
	if(!length(anvil_presses))
		return
	var/atom/movable/screen/hud_note/choice = anvil_presses[1]
	if(user.client)
		average_ping = user.client.avgping * 0.01

	var/upper_range = anvil_presses[choice] + 0.2 SECONDS + average_ping
	var/lower_range = anvil_presses[choice] - 0.2 SECONDS - average_ping

	var/list/modifiers = params2list(params)

	var/list/click_list = list()
	if(LAZYACCESS(modifiers, RIGHT_CLICK))
		click_list |= RIGHT_CLICK
	if(LAZYACCESS(modifiers, LEFT_CLICK))
		click_list |= LEFT_CLICK
	if(LAZYACCESS(modifiers, ALT_CLICKED))
		click_list |= ALT_CLICKED
	if(LAZYACCESS(modifiers, CTRL_CLICKED))
		click_list |= CTRL_CLICKED

	var/good_hit = TRUE
	if(!choice.check_click(click_list))
		failed_notes++
		good_hit = FALSE
	else
		if((REALTIMEOFDAY > lower_range) && (REALTIMEOFDAY < upper_range))
			anvil_presses -= anvil_presses[choice]
			user.balloon_alert(user, "Great Hit!")
			playsound(host_anvil, pick('sound/items/bsmith1.ogg','sound/items/bsmith2.ogg','sound/items/bsmith3.ogg','sound/items/bsmith4.ogg'), 100, FALSE)

			// for(var/mob/player as anything in GLOB.player_list)
			// 	if(!is_in_zweb(player.z, host_anvil.z))
			// 		continue
			// 	var/turf/player_turf = get_turf(player)
			// 	var/far_smith_sound = sound(pick('sound/items/smithdist1.ogg','sound/items/smithdist2.ogg','sound/items/smithdist3.ogg'))
			// 	if(player_turf)
			// 		var/dist = get_dist(player_turf, host_anvil.loc)
			// 		if(dist < 7)
			// 			continue
			// 		player.playsound_local(player_turf, null, 100, 1, get_rand_frequency(), falloff_exponent = 5, S = far_smith_sound)


		else
			if(REALTIMEOFDAY > anvil_presses[choice] + 0.2 SECONDS + average_ping)
				off_time += REALTIMEOFDAY - (anvil_presses[choice] + 0.2 SECONDS + average_ping)
				failed_notes++
				good_hit = FALSE
			else if(REALTIMEOFDAY < anvil_presses[choice] - 0.2 SECONDS - average_ping)
				off_time += (anvil_presses[choice] + 0.2 SECONDS + average_ping) - REALTIMEOFDAY
				failed_notes++
				good_hit = FALSE

	anvil_presses -= choice
	note_pixels_moved -= choice
	anvil_hud.pop_note(choice, good_hit)
	if(!length(anvil_presses))
		if(!notes_left)
			end_minigame()
		else
			generate_anvil_beats()
	return TRUE

/datum/anvil_challenge/process(seconds_per_tick)
	if(!user.Adjacent(host_anvil))
		end_minigame(FALSE)
		return
	for(var/note in anvil_presses)
		if(anvil_presses[note] + 0.6 SECONDS > REALTIMEOFDAY)
			continue
		anvil_presses -= note
		anvil_hud.delete_note(note)
		failed_notes++
		if(!length(anvil_presses))
			if(!notes_left)
				end_minigame()
			else
				generate_anvil_beats()

/datum/anvil_challenge/proc/end_minigame(completed = TRUE)
	UnregisterSignal(user.client, COMSIG_CLIENT_CLICK_DIRTY)
	user.client.show_popup_menus = had_context
	STOP_PROCESSING(SSanvil, src)
	anvil_presses = null
	note_pixels_moved = null

	anvil_hud.end_minigame()
	user.client?.screen -= anvil_hud
	QDEL_NULL(anvil_hud)
	host_anvil.smithing = FALSE

	if(completed)
		var/smithlevel = user.get_skill_level(selected_recipe.appro_skill)
		if(host_anvil.always_perfect)
			failed_notes = 0
			off_time = 0
			success = 100

		// Calculate quality score based on performance
		success = max(smithlevel * 5, round(success - ((100 * (failed_notes / total_notes)) + 1 * (off_time * 2)) +((smithlevel * 5) - 15)))

		host_anvil.process_minigame_result(success, user, (failed_notes == total_notes))

	host_anvil = null

/atom/movable/screen/anvil_hud
	icon = 'icons/hud/anvil_hud.dmi'
	screen_loc = "CENTER:8,CENTER+2:2"
	name = "anvil minigame"
	appearance_flags = APPEARANCE_UI|KEEP_TOGETHER
	alpha = 230
	var/list/cached_notes = list()

/atom/movable/screen/anvil_hud/proc/prepare_minigame(datum/anvil_challenge/challenge, list/notes)
	icon_state = challenge.background
	add_overlay("frame")
	add_notes(notes)
	challenge.user.client.screen += src

/atom/movable/screen/anvil_hud/proc/end_minigame()
	QDEL_LIST(cached_notes)

/atom/movable/screen/anvil_hud/proc/add_notes(list/notes)
	for(var/atom/movable/screen/hud_note/note as anything in notes)
		cached_notes += note
		vis_contents += note

/atom/movable/screen/anvil_hud/proc/pop_note(atom/movable/screen/hud_note/note, good_hit)
	addtimer(CALLBACK(src, PROC_REF(delete_note), note), 0.4 SECONDS)
	if(good_hit)
		flick("hit_state", note)
		note.alpha = 255
	animate(note, alpha = 0, time = 0.4 SECONDS)

/atom/movable/screen/anvil_hud/proc/delete_note(atom/movable/screen/hud_note/note)
	vis_contents -= note
	cached_notes -= note
	qdel(note)

/atom/movable/screen/hud_note
	icon = 'icons/hud/anvil_hud.dmi'
	icon_state = "note"
	vis_flags = VIS_INHERIT_ID
	var/list/click_requirements = list()
	var/timer

/atom/movable/screen/hud_note/proc/generate_click_type(difficulty)
	difficulty = min(6, difficulty)

	switch(rand(1,difficulty))
		if(1)
			click_requirements = list(LEFT_CLICK)
			icon_state = "note"
		if(2)
			click_requirements = list(RIGHT_CLICK)
			icon_state = "note-right"
		if(3)
			click_requirements = list(LEFT_CLICK, ALT_CLICKED)
			icon_state = "note-alt"
		if(4)
			click_requirements = list(RIGHT_CLICK, ALT_CLICKED)
			icon_state = "note-right-alt"
		if(5)
			click_requirements = list(LEFT_CLICK, CTRL_CLICKED)
			icon_state = "note-ctrl"
		if(6)
			click_requirements = list(RIGHT_CLICK, CTRL_CLICKED)
			icon_state = "note-right-ctrl"

/atom/movable/screen/hud_note/proc/check_click(list/click_modifiers)
	var/list/copied_checks = click_requirements
	if(length(click_modifiers) != length(copied_checks))
		return FALSE
	for(var/item in copied_checks)
		if(item in click_modifiers)
			copied_checks -= item
		if(!length(copied_checks))
			return TRUE
	return FALSE
