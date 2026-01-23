#define CULT_POLL_WAIT 2400

/proc/get_area_name(atom/X, format_text = FALSE)
	var/area/A = isarea(X) ? X : get_area(X)
	if(!A)
		return null
	return format_text ? format_text(A.name) : A.name


//We used to use linear regression to approximate the answer, but Mloc realized this was actually faster.
//And lo and behold, it is, and it's more accurate to boot.
/proc/cheap_hypotenuse(Ax,Ay,Bx,By)
	return sqrt(abs(Ax - Bx)**2 + abs(Ay - By)**2) //A squared + B squared = C squared

/** recursive_organ_check
 * inputs: O (object to start with)
 * outputs:
 * description: A pseudo-recursive loop based off of the recursive mob check, this check looks for any organs held
 *				 within 'O', toggling their frozen flag. This check excludes items held within other safe organ
 *				 storage units, so that only the lowest level of container dictates whether we do or don't decompose
 */
/proc/recursive_organ_check(atom/O)

	var/list/processing_list = list(O)
	var/list/processed_list = list()
	var/index = 1
	var/obj/item/organ/found_organ

	while(index <= length(processing_list))

		var/atom/A = processing_list[index]

		if(istype(A, /obj/item/organ))
			found_organ = A
			found_organ.organ_flags ^= ORGAN_FROZEN

		else if(istype(A, /mob/living/carbon))
			var/mob/living/carbon/Q = A
			for(var/organ in Q.internal_organs)
				found_organ = organ
				found_organ.organ_flags ^= ORGAN_FROZEN

		for(var/atom/B in A)	//objects held within other objects are added to the processing list, unless that object is something that can hold organs safely
			if(!processed_list[B])
				processing_list+= B

		index++
		processed_list[A] = A

	return

// Better recursive loop, technically sort of not actually recursive, enjoy.
//No need for a recursive limit either
/proc/recursive_mob_check(atom/O,client_check=1,sight_check=1,include_radio=1)

	var/list/processing_list = list(O)
	var/list/processed_list = list()
	var/list/found_mobs = list()

	while(processing_list.len)

		var/atom/A = processing_list[1]
		var/passed = 0

		if(ismob(A))
			var/mob/A_tmp = A
			passed=1

			if(client_check && !A_tmp.client)
				passed=0

			if(sight_check && !isInSight(A_tmp, O))
				passed=0

		if(passed)
			found_mobs |= A

		for(var/atom/B in A)
			if(!processed_list[B])
				processing_list |= B

		processing_list.Cut(1, 2)
		processed_list[A] = A

	return found_mobs


/proc/isInSight(atom/A, atom/B)
	var/turf/Aturf = get_turf(A)
	var/turf/Bturf = get_turf(B)

	if(!Aturf || !Bturf)
		return 0

	if(inLineOfSight(Aturf.x,Aturf.y, Bturf.x,Bturf.y,Aturf.z))
		return 1

	else
		return 0


/proc/try_move_adjacent(atom/movable/AM)
	var/turf/T = get_turf(AM)
	for(var/direction in GLOB.cardinals)
		if(AM.Move(get_step(T, direction)))
			break

/proc/get_mob_by_key(key)
	var/ckey = ckey(key)
	for(var/mob/M as anything in GLOB.player_list)
		if(M.ckey == ckey)
			return M
	return null

/proc/considered_alive(datum/mind/M, enforce_human = TRUE)
	if(M && M.current)
		if(enforce_human)
			var/mob/living/carbon/human/H
			if(ishuman(M.current))
				H = M.current
			return M.current.stat != DEAD && !isbrain(M.current) && (!H || H.dna.species.id != "memezombies")
		else if(isliving(M.current))
			return M.current.stat != DEAD
	return FALSE

/proc/considered_afk(datum/mind/M)
	return !M || !M.current || !M.current.client || M.current.client.is_afk()

/proc/ScreenText(obj/O, maptext="", screen_loc="CENTER-7,CENTER-7", maptext_height=480, maptext_width=480)
	if(!isobj(O))
		O = new /atom/movable/screen/text()
	O.maptext = MAPTEXT(maptext)
	O.maptext_height = maptext_height
	O.maptext_width = maptext_width
	O.screen_loc = screen_loc
	return O

/// Removes an image from a client's `.images`. Useful as a callback.
/proc/remove_image_from_client(image/image, client/remove_from)
	remove_from?.images -= image

/// Like remove_image_from_client, but will remove the image from a list of clients
/proc/remove_image_from_clients(image/image_to_remove, list/hide_from)
	for(var/client/remove_from in hide_from)
		remove_from.images -= image_to_remove

/proc/flick_overlay(image/image_to_show, list/show_to, duration)
	if(!show_to || !length(show_to) || !image_to_show)
		return
	for(var/client/add_to in show_to)
		add_to.images += image_to_show
	addtimer(CALLBACK(GLOBAL_PROC, GLOBAL_PROC_REF(remove_image_from_clients), image_to_show, show_to), duration, TIMER_CLIENT_TIME)

/**
 * Helper atom that copies an appearance and exists for a period
*/
/atom/movable/flick_visual

/// Takes the passed in MA/icon_state, mirrors it onto ourselves, and displays that in world for duration seconds
/// Returns the displayed object, you can animate it and all, but you don't own it, we'll delete it after the duration
/atom/proc/flick_overlay_view(mutable_appearance/display, duration)
	if(!display)
		return null

	var/mutable_appearance/passed_appearance = \
		istext(display) \
			? mutable_appearance(icon, display, layer) \
			: display

	// If you don't give it a layer, we assume you want it to layer on top of this atom
	// Because this is vis_contents, we need to set the layer manually (you can just set it as you want on return if this is a problem)
	if(passed_appearance.layer == FLOAT_LAYER)
		passed_appearance.layer = layer + 0.1
	// This is faster then pooling. I promise
	var/atom/movable/flick_visual/visual = new()
	visual.appearance = passed_appearance
	visual.mouse_opacity = MOUSE_OPACITY_TRANSPARENT
	// I hate /area
	var/atom/movable/lies_to_children = src
	lies_to_children.vis_contents += visual
	QDEL_IN_CLIENT_TIME(visual, duration)
	return visual

/area/flick_overlay_view(mutable_appearance/display, duration)
	return

/proc/flick_overlay_view(image/I, atom/target, duration) //wrapper for the above, flicks to everyone who can see the target atom
	var/list/viewing = list()
	for(var/mob/M as anything in viewers(target))
		if(M.client)
			viewing += M.client
	flick_overlay(I, viewing, duration)

/proc/get_active_player_count(alive_check = 0, afk_check = 0, human_check = 0)
	// Get active players who are playing in the round
	var/active_players = 0
	for(var/i = 1; i <= GLOB.player_list.len; i++)
		var/mob/M = GLOB.player_list[i]
		if(M && M.client)
			if(alive_check && M.stat)
				continue
			else if(afk_check && M.client.is_afk())
				continue
			else if(human_check && !ishuman(M))
				continue
			else if(isnewplayer(M)) // exclude people in the lobby
				continue
			else if(isobserver(M)) // Ghosts are fine if they were playing once (didn't start as observers)
				var/mob/dead/observer/O = M
				if(O.started_as_observer) // Exclude people who started as observers
					continue
			active_players++
	return active_players

/proc/showCandidatePollWindow(mob/M, poll_time, Question, list/candidates, ignore_category, time_passed, flashwindow = TRUE)
	set waitfor = 0

//	SEND_SOUND(M, 'sound/misc/roundstart.ogg') //Alerting them to their consideration
	if(flashwindow)
		window_flash(M.client)
	var/options = ignore_category ? list(CHOICE_YES, CHOICE_NO, CHOICE_NEVER) : DEFAULT_INPUT_CHOICES
	switch(browser_alert(M, Question, "Please answer in [DisplayTimeText(poll_time)]!", options))
		if(CHOICE_YES)
			to_chat(M, "<span class='notice'>Choice registered: Yes.</span>")
			if(time_passed + poll_time <= world.time)
				to_chat(M, "<span class='danger'>Sorry, you answered too late to be considered!</span>")
				SEND_SOUND(M, 'sound/blank.ogg')
				candidates -= M
			else
				candidates += M
		if(CHOICE_NO)
			to_chat(M, "<span class='danger'>Choice registered: No.</span>")
			candidates -= M
		if(CHOICE_NEVER)
			var/list/L = GLOB.poll_ignore[ignore_category]
			if(!L)
				GLOB.poll_ignore[ignore_category] = list()
			GLOB.poll_ignore[ignore_category] += M.ckey
			to_chat(M, "<span class='danger'>Choice registered: Never for this round.</span>")
			candidates -= M
		else
			candidates -= M

/proc/pollGhostCandidates(Question, jobbanType, gametypeCheck, be_special_flag = 0, poll_time = 300, ignore_category = null, flashwindow = TRUE, new_players = FALSE)
	var/list/candidates = list()

	for(var/mob/dead/observer/G in GLOB.player_list)
		candidates += G
	if(new_players)
		for(var/mob/dead/new_player/G as anything in GLOB.new_player_list)
			if(!G.client)
				continue
			candidates += G

	return pollCandidates(Question, jobbanType, gametypeCheck, be_special_flag, poll_time, ignore_category, flashwindow, candidates)

/proc/pollCandidates(Question, jobbanType, gametypeCheck, be_special_flag = 0, poll_time = 300, ignore_category = null, flashwindow = TRUE, list/group = null)
	var/time_passed = world.time
	if (!Question)
		Question = "Would you like to be a special role?"
	var/list/result = list()
	for(var/mob/M as anything in group)
		if(!M.key || !M.client || (ignore_category && GLOB.poll_ignore[ignore_category] && (M.ckey in GLOB.poll_ignore[ignore_category])))
			continue
		if(be_special_flag)
			if(!(M.client.prefs) || !(be_special_flag in M.client.prefs.be_special))
				continue
			if(!age_check(M.client))
				continue

		showCandidatePollWindow(M, poll_time, Question, result, ignore_category, time_passed, flashwindow)
	sleep(poll_time)

	//Check all our candidates, to make sure they didn't log off or get deleted during the wait period.
	for(var/mob/M in result)
		if(!M.key || !M.client)
			result -= M

	listclearnulls(result)

	return result

/proc/pollCandidatesForMob(Question, jobbanType, gametypeCheck, be_special_flag = 0, poll_time = 300, mob/M, ignore_category = null, new_players = FALSE)
	var/list/L = pollGhostCandidates(Question, jobbanType, gametypeCheck, be_special_flag, poll_time, ignore_category, new_players = new_players)
	if(!M || QDELETED(M) || !M.loc)
		return list()
	return L

/proc/pollCandidatesForMobs(Question, jobbanType, gametypeCheck, be_special_flag = 0, poll_time = 300, list/mobs, ignore_category = null)
	var/list/L = pollGhostCandidates(Question, jobbanType, gametypeCheck, be_special_flag, poll_time, ignore_category)
	var/i=1
	for(var/atom/A as anything in mobs)
		if(!A || QDELETED(A) || !A.loc)
			mobs.Cut(i,i+1)
		else
			++i
	return L

/proc/makeBody(mob/dead/observer/G_found) // Uses stripped down and bastardized code from respawn character
	if(!G_found || !G_found.key)
		return

	//First we spawn a dude.
	var/mob/living/carbon/human/new_character = new//The mob being spawned.
	SSjob.SendToLateJoin(new_character)

	G_found.client.prefs.safe_transfer_prefs_to(new_character)
	new_character.dna.update_dna_identity()
	new_character.key = G_found.key

	return new_character

/proc/send_to_playing_players(thing) //sends a whatever to all playing players; use instead of to_chat(world, where needed)
	for(var/M in GLOB.player_list)
		if(M && !isnewplayer(M))
			to_chat(M, thing)

/proc/window_flash(client/C, ignorepref = FALSE)
	if(ismob(C))
		var/mob/M = C
		if(M.client)
			C = M.client
	if(!C || (!C.prefs.windowflashing && !ignorepref))
		return

//Recursively checks if an item is inside a given type, even through layers of storage. Returns the atom if it finds it.
/proc/recursive_loc_check(atom/movable/target, type)
	var/atom/A = target
	if(istype(A, type))
		return A

	while(!istype(A.loc, type))
		if(!A.loc)
			return
		A = A.loc

	return A.loc

/proc/GetRedPart(const/hexa)
	return hex2num(copytext(hexa, 2, 4))

/proc/GetGreenPart(const/hexa)
	return hex2num(copytext(hexa, 4, 6))

/proc/GetBluePart(const/hexa)
	return hex2num(copytext(hexa, 6, 8))


// Find a obstruction free turf that's within the range of the center. Can also condition on if it is of a certain area type.
/proc/find_obstruction_free_location(range, atom/center, area/specific_area)
	var/list/turfs = RANGE_TURFS(range, center)
	var/list/possible_loc = list()

	for(var/turf/found_turf in turfs)
		var/area/turf_area = get_area(found_turf)

		// We check if both the turf is a floor, and that it's actually in the area.
		// We also want a location that's clear of any obstructions.
		if (specific_area)
			if (!istype(turf_area, specific_area))
				continue

		if (!is_blocked_turf(found_turf))
			possible_loc.Add(found_turf)

	// Need at least one free location.
	if (possible_loc.len < 1)
		return FALSE

	return pick(possible_loc)

/// Assoc list of ckeys to fake names.
/// Is not cleaned, but that shouldn't be an issue.
GLOBAL_LIST_EMPTY(fake_ckeys)

/// Returns this user's display ckey, used in OOC contexts.
/proc/get_display_ckey(key)
	if(!key || !istext(key))
		return "some invalid"
	var/ckey = ckey(key)
	return ckey

/// Returns if the given client is an admin, REGARDLESS of if they're deadminned or not.
/proc/is_admin(client/client)
	return !isnull(GLOB.admin_datums[client.ckey]) || !isnull(GLOB.deadmins[client.ckey])

/**
 * Checks a given message to see if any of the words are something we want to treat specially, as detailed below.
 *
 * There are 3 cases where a word is something we want to act on
 * 1. Admin pings, like @adminckey. Pings the admin in question, text is not clickable
 * 2. Datum refs, like @0x2001169 or @mob_23. Clicking on the link opens up the VV for that datum
 * 3. Ticket refs, like #3. Displays the status and ahelper in the link, clicking on it brings up the ticket panel for it.
 * Returns a list being used as a tuple. Index ASAY_LINK_NEW_MESSAGE_INDEX contains the new message text (with clickable links and such)
 * while index ASAY_LINK_PINGED_ADMINS_INDEX contains a list of pinged admin clients, if there are any.
 *
 * Arguments:
 * * msg - the message being scanned
 */
/proc/check_asay_links(msg)
	var/list/msglist = splittext(msg, " ") //explode the input msg into a list
	var/list/pinged_admins = list() // if we ping any admins, store them here so we can ping them after
	var/modified = FALSE // did we find anything?

	var/i = 0
	for(var/word in msglist)
		i++
		if(!length(word))
			continue

		switch(word[1])
			if("@")
				var/stripped_word = ckey(copytext(word, 2))

				// first we check if it's a ckey of an admin
				var/client/client_check = GLOB.directory[stripped_word]
				if(client_check?.holder)
					msglist[i] = "<u>[word]</u>"
					pinged_admins[stripped_word] = client_check
					modified = TRUE
					continue

				// then if not, we check if it's a datum ref

				var/word_with_brackets = "\[[stripped_word]\]" // the actual memory address lookups need the bracket wraps
				var/datum/datum_check = locate(word_with_brackets)
				if(!istype(datum_check))
					continue
				msglist[i] = "<u><a href='byond://?_src_=vars;[HrefToken(forceGlobal = TRUE)];Vars=[word_with_brackets]'>[word]</A></u>"
				modified = TRUE

			if("#") // check if we're linking a ticket
				var/possible_ticket_id = text2num(copytext(word, 2))
				if(!possible_ticket_id)
					continue

				var/datum/admin_help/ahelp_check = GLOB.ahelp_tickets?.TicketByID(possible_ticket_id)
				if(!ahelp_check)
					continue

				var/state_word
				switch(ahelp_check.state)
					if(AHELP_ACTIVE)
						state_word = "Active"
					if(AHELP_CLOSED)
						state_word = "Closed"
					if(AHELP_RESOLVED)
						state_word = "Resolved"

				msglist[i]= "<u><A href='byond://?_src_=holder;[HrefToken(forceGlobal = TRUE)];ahelp=[REF(ahelp_check)];ahelp_action=ticket'>[word] ([state_word] | [ahelp_check.initiator_key_name])</A></u>"
				modified = TRUE

	if(modified)
		var/list/return_list = list()
		return_list[ASAY_LINK_NEW_MESSAGE_INDEX] = jointext(msglist, " ") // without tuples, we must make do!
		return_list[ASAY_LINK_PINGED_ADMINS_INDEX] = pinged_admins
		return return_list
