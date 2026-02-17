GLOBAL_LIST_INIT(roleplay_readme, world.file2list("strings/rt/Lore_Primer.txt"))

/mob/dead/new_player
	flags_1 = NONE
	invisibility = INVISIBILITY_ABSTRACT
	density = FALSE
	stat = DEAD
	hud_possible = list()

	var/ready = FALSE
	/// Referenced when you want to delete the new_player later on in the code.
	var/spawning = FALSE
	/// Used to make sure someone doesn't get spammed with messages if they're ineligible for roles
	var/ineligible_for_roles = FALSE

	/// Cached character data for multi-ready slots
	var/list/multi_ready_characters = list()
	/// Current character index being used
	var/multi_ready_index = 1

	var/multi_ready_assigned_slot = 0

	hud_type = /datum/hud/new_player

/mob/dead/new_player/Initialize()
	if(length(GLOB.newplayer_start))
		forceMove(pick(GLOB.newplayer_start))
	else
		forceMove(locate(1,1,1))

	. = ..()

	GLOB.new_player_list += src

/mob/dead/new_player/Destroy()
	GLOB.new_player_list -= src
	return ..()

///Say verb
/mob/dead/new_player/say_verb(message as text)
	set name = "Say"
	set category = "IC.Speech"
	set hidden = 1

	if(message)
		if(client)
			if(GLOB.ooc_allowed)
				client.ooc(message)
			else
				client.lobbyooc(message)

/mob/dead/new_player/prepare_huds()
	return


/// Called when player readies up - caches all selected character data
/mob/dead/new_player/proc/cache_multi_ready_characters()
	multi_ready_characters = list()
	multi_ready_index = 1

	if(!client?.prefs?.multi_char_ready || !length(client.prefs.multi_ready_slots))
		return

	var/original_slot = client.prefs.default_slot

	for(var/slot in client.prefs.multi_ready_slots)
		client.prefs.load_character(slot)
		var/list/char_data = list(
			"slot" = slot,
			"real_name" = client.prefs.real_name,
			"gender" = client.prefs.gender,
			"age" = client.prefs.age,
			"pref_species" = client.prefs.pref_species,
			"selected_patron" = client.prefs.selected_patron,
			"job_preferences" = client.prefs.job_preferences?.Copy(),
			"features" = client.prefs.features?.Copy(),
			"quirks" = client.prefs.quirks?.Copy(),
			"quirk_customizations" = client.prefs.quirk_customizations?.Copy(),
			"skin_tone" = client.prefs.skin_tone,
			"eye_color" = client.prefs.eye_color,
			"underwear" = client.prefs.underwear,
			"undershirt" = client.prefs.undershirt,
			"socks" = client.prefs.socks,
			"pronouns" = client.prefs.pronouns,
			"voice_type" = client.prefs.voice_type,
			"voice_color" = client.prefs.voice_color,
			"domhand" = client.prefs.domhand,
			"flavortext" = client.prefs.flavortext,
			"headshot_link" = client.prefs.headshot_link,
		)
		multi_ready_characters += list(char_data)

	client.prefs.load_character(original_slot)

/// Applies cached character data at given index to preferences
/mob/dead/new_player/proc/apply_multi_ready_character(index)
	if(!length(multi_ready_characters) || index > length(multi_ready_characters))
		return FALSE

	var/list/char_data = multi_ready_characters[index]
	if(!char_data)
		return FALSE

	var/datum/preferences/P = client.prefs
	P.real_name = char_data["real_name"]
	P.gender = char_data["gender"]
	P.age = char_data["age"]
	P.pref_species = char_data["pref_species"]
	P.selected_patron = char_data["selected_patron"]
	P.job_preferences = char_data["job_preferences"]
	P.features = char_data["features"]
	P.quirks = char_data["quirks"]
	P.quirk_customizations = char_data["quirk_customizations"]
	P.skin_tone = char_data["skin_tone"]
	P.eye_color = char_data["eye_color"]
	P.underwear = char_data["underwear"]
	P.undershirt = char_data["undershirt"]
	P.socks = char_data["socks"]
	P.pronouns = char_data["pronouns"]
	P.voice_type = char_data["voice_type"]
	P.voice_color = char_data["voice_color"]
	P.domhand = char_data["domhand"]
	P.flavortext = char_data["flavortext"]
	P.headshot_link = char_data["headshot_link"]

	P.default_slot = char_data["slot"]
	multi_ready_index = index
	return TRUE

/mob/dead/new_player/Topic(href, href_list[])
	if(src != usr)
		return 0

	if(!client)
		return 0

	//Determines Relevent Population Cap
	var/relevant_cap
	var/hpc = CONFIG_GET(number/hard_popcap)
	var/epc = CONFIG_GET(number/extreme_popcap)
	if(hpc && epc)
		relevant_cap = min(hpc, epc)
	else
		relevant_cap = max(hpc, epc)

	if(href_list["show_preferences"])
		client.prefs.show_choices(src, 4)
		return 1

	if(href_list["show_options"])
		client.prefs.show_choices(src, 1)
		return 1

	if(href_list["show_keybinds"])
		client.prefs.show_choices(src, 3)
		return 1

	if(href_list["ready"])
		var/tready = text2num(href_list["ready"])
		//Avoid updating ready if we're after PREGAME (they should use latejoin instead)
		//This is likely not an actual issue but I don't have time to prove that this
		//no longer is required
		if(tready == PLAYER_NOT_READY)
			if(SSticker.job_change_locked)
				return
		if(SSticker.current_state <= GAME_STATE_PREGAME)
			if(ready != tready)
				ready = tready

	if(href_list["refresh"])
		winshow(src, "stonekeep_prefwin", FALSE)
		src << browse(null, "window=preferences_browser")

	if(client && client.prefs.is_active_migrant())
		to_chat(usr, span_boldwarning("You are in the migrant queue."))
		return

	if(href_list["late_join"])
		if(!SSticker?.IsRoundInProgress())
			to_chat(usr, "<span class='boldwarning'>The game is starting. You cannot join yet.</span>")
			return

		if(href_list["late_join"] == "override")
			LateChoices()
			return



		var/timetojoin = 5 MINUTES
#ifdef ALLOWPLAY
		timetojoin = 1 SECONDS
#endif
#ifdef TESTSERVER
		timetojoin = 0
#endif
		if(SSticker.round_start_time)
			if(world.time < SSticker.round_start_time + timetojoin)
				var/ttime = round((SSticker.round_start_time + timetojoin - world.time) / 10)
				var/list/choicez = list("Not yet.", "You cannot join yet.", "It won't work yet.", "Please be patient.", "Try again later.", "Late-joining is not yet possible.")
				to_chat(usr, "<span class='warning'>[pick(choicez)] ([ttime]).</span>")
				return

		LateChoices()

	if(href_list["SelectedJob"])
		if(!SSticker?.IsRoundInProgress())
			to_chat(usr, "<span class='danger'>The round is either not ready, or has already finished...</span>")
			return

		if(!GLOB.enter_allowed)
			to_chat(usr, "<span class='notice'>There is a lock on entering the game!</span>")
			return

		if(SSticker.queued_players.len && !(ckey(key) in GLOB.admin_datums))
			if((living_player_count() >= relevant_cap) || (src != SSticker.queued_players[1]))
				to_chat(usr, "<span class='warning'>Server is full.</span>")
				return

		if(client && client.prefs.is_active_migrant())
			to_chat(usr, span_boldwarning("You are in the migrant queue."))
			return

		AttemptLateSpawn(href_list["SelectedJob"])
		return

	if(!ready && href_list["preference"])
		if(client)
			client.prefs.process_link(src, href_list)

	if(href_list["showpoll"])
		handle_player_polling()
		return

	if(href_list["viewpoll"])
		var/datum/poll_question/poll = locate(href_list["viewpoll"]) in GLOB.polls
		poll_player(poll)

	if(href_list["votepollref"])
		var/datum/poll_question/poll = locate(href_list["votepollref"]) in GLOB.polls
		vote_on_poll_handler(poll, href_list)

//When you cop out of the round (NB: this HAS A SLEEP FOR PLAYER INPUT IN IT)
/mob/dead/new_player/proc/make_me_an_observer()
	if(QDELETED(src) || !src.client)
		ready = PLAYER_NOT_READY
		return FALSE

	var/this_is_like_playing_right = alert(src,"Are you sure you wish to observe? You will not be able to play this round!","Player Setup","Yes","No")

	if(QDELETED(src) || !src.client || this_is_like_playing_right != "Yes")
		ready = PLAYER_NOT_READY
		src << browse(null, "window=playersetup") //closes the player setup window
		return FALSE

	var/mob/dead/observer/observer = new()
	spawning = TRUE

	observer.started_as_observer = TRUE
	close_spawn_windows()
	var/obj/effect/landmark/observer_start/O = locate(/obj/effect/landmark/observer_start) in GLOB.landmarks_list
	to_chat(src, "<span class='notice'>Now teleporting.</span>")
	if (O)
		observer.forceMove(O.loc)
	else
		to_chat(src, "<span class='notice'>Teleporting failed. Ahelp an admin please</span>")
		stack_trace("There's no freaking observer landmark available on this map or you're making observers before the map is initialised")
	observer.key = key
	observer.client = client
	observer.set_ghost_appearance()
	if(observer.client && observer.client.prefs)
		observer.real_name = observer.client.prefs.real_name
		observer.name = observer.real_name
	observer.stop_sound_channel(CHANNEL_LOBBYMUSIC)
	QDEL_NULL(mind)
	qdel(src)
	return TRUE

/proc/get_job_unavailable_error_message(retval, jobtitle)
	switch(retval)
		if(JOB_AVAILABLE)
			return "[jobtitle] is available."
		if(JOB_UNAVAILABLE_GENERIC)
			return "[jobtitle] is unavailable."
		if(JOB_UNAVAILABLE_BANNED)
			return "You are currently banned from [jobtitle]."
		if(JOB_UNAVAILABLE_RACE_BANNED)
			return "You are currently banned from playing that species."
		if(JOB_UNAVAILABLE_PLAYTIME)
			return "You do not have enough playtime for [jobtitle]."
		if(JOB_UNAVAILABLE_SLOTFULL)
			return "[jobtitle] is already filled to capacity."
		if(JOB_UNAVAILABLE_AGE)
			return "[jobtitle] is not for those of your age."
		if(JOB_UNAVAILABLE_RACE)
			return "[jobtitle] is not meant for your kind."
		if(JOB_UNAVAILABLE_SEX)
			return "[jobtitle] is not meant for your sex."
		if(JOB_UNAVAILABLE_DEITY)
			return "[jobtitle] requires more faith."
		if(JOB_UNAVAILABLE_QUALITY)
			return "[jobtitle] requires higher player quality."
		if(JOB_UNAVAILABLE_DONATOR)
			return "You need to be a donator to have play as [jobtitle]."
		if(JOB_UNAVAILABLE_ACCOUNTAGE)
			return "Your account is not old enough for [jobtitle]."
		if(JOB_UNAVAILABLE_LASTCLASS)
			return "You have played [jobtitle] recently."
		if(JOB_UNAVAILABLE_JOB_COOLDOWN)
			if(usr.ckey in GLOB.job_respawn_delays)
				var/next_respawn_time = GLOB.job_respawn_delays[usr.ckey]
				var/remaining_time = round((next_respawn_time - world.time) / 10)
				return "You must wait [remaining_time] seconds before playing as an [jobtitle] again."
	return "Error: Unknown job availability."

//used for latejoining
/mob/dead/new_player/proc/IsJobUnavailable(rank, latejoin = FALSE)
	if(QDELETED(src))
		return JOB_UNAVAILABLE_GENERIC

	var/datum/job/job = SSjob.GetJob(rank)
	var/datum/preferences/player_prefs = client.prefs
	//TODO: This fucking sucks.

	if(is_skeleton_knight_job(job)) //has to be first because it's a subtype of skeleton
		if(has_world_trait(/datum/world_trait/death_knight))
			return JOB_AVAILABLE
		else
			return JOB_UNAVAILABLE_GENERIC

	if(is_skeleton_job(job))
		if(has_world_trait(/datum/world_trait/skeleton_siege))
			return JOB_AVAILABLE
		else
			return JOB_UNAVAILABLE_GENERIC

	if(is_goblin_job(job))
		if(has_world_trait(/datum/world_trait/goblin_siege))
			return JOB_AVAILABLE
		else
			return JOB_UNAVAILABLE_GENERIC

	if(is_rousman_job(job))
		if(has_world_trait(/datum/world_trait/rousman_siege))
			return JOB_AVAILABLE
		else
			return JOB_UNAVAILABLE_GENERIC

	if(!(job.job_flags & JOB_NEW_PLAYER_JOINABLE))
		return JOB_UNAVAILABLE_GENERIC
	// Check if the player is on cooldown for the hiv+ role
	if((job.same_job_respawn_delay) && (ckey in GLOB.job_respawn_delays))
		if(world.time < GLOB.job_respawn_delays[ckey])
			return JOB_UNAVAILABLE_JOB_COOLDOWN

	if((job.current_positions >= job.total_positions) && job.total_positions != -1)
		return JOB_UNAVAILABLE_SLOTFULL

	if(is_banned_from(ckey, rank))
		return JOB_UNAVAILABLE_BANNED

	if(CONFIG_GET(flag/usewhitelist))
		if(job.whitelist_req && (!client.whitelisted()))
			return JOB_UNAVAILABLE_GENERIC

	if(is_role_banned(client.ckey, job.title))
		return JOB_UNAVAILABLE_BANNED

	if(is_race_banned(client.ckey, player_prefs.pref_species.id))
		return JOB_UNAVAILABLE_RACE_BANNED

	if(job.banned_leprosy && is_misc_banned(client.ckey, BAN_MISC_LEPROSY))
		return JOB_UNAVAILABLE_BANNED

	if(job.banned_lunatic && is_misc_banned(client.ckey, BAN_MISC_LUNATIC))
		return JOB_UNAVAILABLE_BANNED

	if(!job.player_old_enough(client))
		return JOB_UNAVAILABLE_ACCOUNTAGE

	if(job.required_playtime_remaining(client))
		return JOB_UNAVAILABLE_PLAYTIME

	if(latejoin && !job.special_check_latejoin(client))
		return JOB_UNAVAILABLE_GENERIC

	if(!client.has_triumph_buy(TRIUMPH_BUY_RACE_ALL) && !job.prefs_species_check(player_prefs))
		return JOB_UNAVAILABLE_RACE

	if(length(job.allowed_sexes) && !(player_prefs.gender in job.allowed_sexes))
		return JOB_UNAVAILABLE_SEX

	if(length(job.allowed_ages) && !(player_prefs.age in job.allowed_ages))
		return JOB_UNAVAILABLE_AGE

	if((player_prefs.lastclass == job.title) && !job.bypass_lastclass)
		return JOB_UNAVAILABLE_LASTCLASS

	return JOB_AVAILABLE

/mob/dead/new_player/proc/AttemptLateSpawn(rank)
	var/error = IsJobUnavailable(rank)
	if(error != JOB_AVAILABLE)
		alert(src, get_job_unavailable_error_message(error, rank))
		return FALSE

	if(SSticker.late_join_disabled)
		alert(src, "Something went bad.")
		return FALSE
	if(!client.prefs.allowed_respawn())
		to_chat(src, span_boldwarning("You cannot respawn."))
		return FALSE

	//Remove the player from the join queue if he was in one and reset the timer
	SSticker.queued_players -= src
	SSticker.queue_delay = 4

	var/datum/job/job = SSjob.GetJob(rank)

	SSjob.AssignRole(src, job, 1)

	mind.late_joiner = TRUE

	var/atom/destination = mind.assigned_role.get_latejoin_spawn_point()
	if(!destination)
		CRASH("Failed to find a latejoin spawn point.")
	islatejoin = TRUE
	var/mob/living/character = create_character(destination)
	character.islatejoin = TRUE
	if(!character)
		CRASH("Failed to create a character for latejoin.")
	transfer_character()

	SSjob.EquipRank(character, job, character.client)
	SSticker.minds += character.mind
	var/mob/living/carbon/human/humanc
	if(ishuman(character))
		humanc = character	//Let's retypecast the var to be human,

	if(humanc)
		var/fakekey = get_display_ckey(character.ckey)
		GLOB.character_list[character.mobid] = "[fakekey] was [character.real_name] ([job.title])<BR>"
		GLOB.character_ckey_list[character.real_name] = character.ckey
		log_character("[character.ckey] ([fakekey]) - [character.real_name] - [job.title]")

	GLOB.joined_player_list += character.ckey
	GLOB.respawncounts[character.ckey] += 1

	if(humanc)
		try_apply_character_post_equipment(humanc)

	log_manifest(character.mind.key,character.mind,character,latejoin = TRUE)


/mob/dead/new_player/proc/LateChoices()
	var/list/dat = list("<div class='notice' style='font-style: normal; font-size: 14px; margin-bottom: 2px; padding-bottom: 0px'>Round Duration: [DisplayTimeText(world.time - SSticker.round_start_time, 1)]</div>")
	for(var/datum/job/prioritized_job in SSjob.prioritized_jobs)
		if(prioritized_job.current_positions >= prioritized_job.total_positions)
			SSjob.prioritized_jobs -= prioritized_job
	dat += "<table><tr><td valign='top'>"
	var/column_counter = 0

	var/static/list/omegalist = list(
		GLOB.noble_positions,
		GLOB.garrison_positions,
		GLOB.church_positions,
		GLOB.peasant_positions,
		GLOB.apprentices_positions,
		GLOB.serf_positions,
		GLOB.company_positions,
		GLOB.youngfolk_positions,
		GLOB.allmig_positions,
		GLOB.inquisition_positions,
	)

	for(var/list/category in omegalist)
		if(!SSjob.name_occupations[category[1]])
			continue

		var/list/available_jobs = list()
		for(var/job in category)
			var/datum/job/job_datum = SSjob.name_occupations[job]
			if(!job_datum)
				continue
			// Make sure hiv+ jobs always appear on list, even if unavailable
			var/is_job_available = (IsJobUnavailable(job_datum.title, TRUE) == JOB_AVAILABLE)
			if(job_datum.always_show_on_latechoices)
				is_job_available = TRUE
			if(is_job_available)
				available_jobs += job

		if (length(available_jobs))
			var/cat_color = SSjob.name_occupations[category[1]].selection_color //use the color of the first job in the category (the department head) as the category color
			var/cat_name = ""
			switch (SSjob.name_occupations[category[1]].department_flag)
				if (NOBLEMEN)
					cat_name = "Nobles"
				if (GARRISON)
					cat_name = "Garrison"
				if (SERFS)
					cat_name = "Yeomanry"
				if (CHURCHMEN)
					cat_name = "Churchmen"
				if (COMPANY)
					cat_name = "Company"
				if (PEASANTS)
					cat_name = "Peasantry"
				if (APPRENTICES)
					cat_name = "Apprentices"
				if (YOUNGFOLK)
					cat_name = "Young Folk"
				if (OUTSIDERS)
					cat_name = "Outsiders"
				if (INQUISITION)
					cat_name = "Inquisition"

			dat += "<fieldset style='width: 185px; border: 2px solid [cat_color]; display: inline'>"
			dat += "<legend align='center' style='font-weight: bold; color: [cat_color]'>[cat_name]</legend>"
			//TODO: This also fucking sucks.
			if(has_world_trait(/datum/world_trait/skeleton_siege))
				dat += "<a class='job command' href='byond://?src=[REF(src)];SelectedJob=Skeleton'>BECOME AN EVIL SKELETON</a>"
				dat += "</fieldset><br>"
				column_counter++
				if(column_counter > 0 && (column_counter % 3 == 0))
					dat += "</td><td valign='top'>"
			if(has_world_trait(/datum/world_trait/goblin_siege))
				dat += "<a class='job command' href='byond://?src=[REF(src)];SelectedJob=Goblin'>BECOME A GOBLIN</a>"
				dat += "</fieldset><br>"
				column_counter++
				if(column_counter > 0 && (column_counter % 3 == 0))
					dat += "</td><td valign='top'>"
			if(has_world_trait(/datum/world_trait/rousman_siege))
				dat += "<a class='job command' href='byond://?src=[REF(src)];SelectedJob=Rousman'>BECOME A ROUSMAN</a>"
				dat += "</fieldset><br>"
				column_counter++
				if(column_counter > 0 && (column_counter % 3 == 0))
					dat += "</td><td valign='top'>"
			if(has_world_trait(/datum/world_trait/death_knight))
				dat += "<a class='job command' href='byond://?src=[REF(src)];SelectedJob=Death Knight'>JOIN THE VAMPIRE LORD AS A DEATH KNIGHT</a>"
				dat += "</fieldset><br>"
				column_counter++
				if(column_counter > 0 && (column_counter % 3 == 0))
					dat += "</td><td valign='top'>"

			if(has_world_trait(/datum/world_trait/skeleton_siege) || has_world_trait(/datum/world_trait/death_knight) || has_world_trait(/datum/world_trait/rousman_siege) || has_world_trait(/datum/world_trait/goblin_siege))
				break
			for(var/job in available_jobs)
				var/datum/job/job_datum = SSjob.name_occupations[job]
				if(job_datum)
					if(job_datum.scales && job_datum.enabled)
						var/new_slots = job_datum.get_total_positions()
						if(new_slots > job_datum.spawn_positions)
							job_datum.set_spawn_and_total_positions(get_total_town_members())
					var/command_bold = ""
					if(job in GLOB.noble_positions)
						command_bold = " command"
					var/used_name = job_datum.title
					if(client.prefs.gender == FEMALE && job_datum.f_title)
						used_name = job_datum.f_title
					if(job_datum in SSjob.prioritized_jobs)
						dat += "<a class='job[command_bold]' href='byond://?src=[REF(src)];SelectedJob=[job_datum.title]'><span class='priority'>[used_name] ([job_datum.current_positions])</span></a>"
					else
						dat += "<a class='job[command_bold]' href='byond://?src=[REF(src)];SelectedJob=[job_datum.title]'>[used_name] ([job_datum.current_positions])</a>"

			dat += "</fieldset><br>"
			column_counter++
			if(column_counter > 0 && (column_counter % 4 == 0))
				dat += "</td><td valign='top'>"
	dat += "</td></tr></table></center>"
	dat += "</div></div>"
	var/datum/browser/popup = new(src, "latechoices", "Choose Class", 720, 580)
	popup.add_stylesheet("playeroptions", 'html/browser/playeroptions.css')
	popup.set_content(jointext(dat, ""))
	popup.open(FALSE) // 0 is passed to open so that it doesn't use the onclose() proc

/mob/proc/after_creation()
	return

/mob/living/carbon/human/after_creation()
	if(dna?.species)
		dna.species.after_creation(src)
	roll_mob_stats()

/mob/dead/new_player/Move()
	return 0

// Used to make sure that a player has a valid job preference setup, used to knock players out of eligibility for anything if their prefs don't make sense.
// A "valid job preference setup" in this situation means at least having one job set to low, or not having "return to lobby" enabled
// Prevents "antag rolling" by setting antag prefs on, all jobs to never, and "return to lobby if preferences not availible"
// Doing so would previously allow you to roll for antag, then send you back to lobby if you didn't get an antag role
// This also does some admin notification and logging as well, as well as some extra logic to make sure things don't go wrong
/mob/dead/new_player/proc/check_preferences()
	if(!client)
		return FALSE //Not sure how this would get run without the mob having a client, but let's just be safe.
	if(client.prefs.joblessrole != RETURNTOLOBBY)
		return TRUE
	// If they have antags enabled, they're potentially doing this on purpose instead of by accident. Notify admins if so.
	var/has_antags = FALSE
	if(client.prefs.be_special.len > 0)
		has_antags = TRUE
	if(client.prefs.job_preferences.len == 0)
		if(!ineligible_for_roles)
			to_chat(src, "<span class='danger'>I need to pick a class to join as.</span>")
		ineligible_for_roles = TRUE
		ready = PLAYER_NOT_READY
		if(has_antags)
			log_admin("[src.ckey] just got booted back to lobby with no jobs, but antags enabled.")
			message_admins("[src.ckey] just got booted back to lobby with no jobs enabled, but antag rolling enabled. Likely antag rolling abuse.")

		return FALSE //This is the only case someone should actually be completely blocked from antag rolling as well
	return TRUE
