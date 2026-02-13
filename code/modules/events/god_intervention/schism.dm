GLOBAL_LIST_EMPTY(tennite_schisms)

/datum/tennite_schism
	var/datum/weakref/challenger_god
	var/datum/weakref/astrata_god
	var/list/supporters_astrata = list()
	var/list/supporters_challenger = list()
	var/list/neutrals = list()
	var/halfway_passed = FALSE

/datum/tennite_schism/New(datum/patron/challenger)
	. = ..()
	challenger_god = WEAKREF(challenger)
	astrata_god = WEAKREF(GLOB.patron_list[/datum/patron/divine/astrata])
	GLOB.tennite_schisms += src

/datum/tennite_schism/Destroy()
	UnregisterSignal(SSdcs, COMSIG_GLOB_JOB_AFTER_SPAWN)
	GLOB.tennite_schisms -= src
	return ..()

/datum/tennite_schism/proc/announce()
	var/datum/patron/challenger = challenger_god.resolve()
	if(!challenger)
		return

	priority_announce("[challenger.name] challenges Astrata's leadership! The outcome of this conflict will be decided in less than 2 daes by a sheer number of their alive supporters. [challenger.name] promises great rewards to the faithful if victorious, while Astrata swears revenge to any who dare to defy her. Choose your side, or stand aside...", "Schism within the Ten", 'sound/magic/marked.ogg')
	for(var/mob/living/carbon/human/H in GLOB.human_list)
		setup_mob(H)

	RegisterSignal(SSdcs, COMSIG_GLOB_JOB_AFTER_SPAWN, PROC_REF(handle_latejoin))

/datum/tennite_schism/proc/handle_latejoin(datum/source, datum/job/job, mob/living/spawned, client/player_client)
	SIGNAL_HANDLER
	if(!istype(spawned, /mob/living/carbon/human))
		return

	var/mob/living/carbon/human/H = spawned
	var/datum/patron/challenger = challenger_god?.resolve()
	if(!challenger || !H)
		return

	bordered_message(H, list(
		span_notice("There is an active schism within the Ten! [challenger.name] has challenged Astrata's leadership!")
	))
	setup_mob(H)

/datum/tennite_schism/proc/setup_mob(mob/living/carbon/human/H)
	if(!istype(H) || H.stat == DEAD || !H.mind)
		return

	var/datum/action/innate/choose_schism_side/choose = new(src)
	choose.Grant(H)

	if(!is_tennite(H))
		bordered_message(H, list(
			span_notice("Even though you are not a Tennite and won't matter in the ultimate resolution of this conflict, you may pretend to be one and use the schism to further your own goals...")
		))

/datum/tennite_schism/proc/process_winner()
	var/datum/patron/challenger = challenger_god.resolve()
	var/datum/patron/astrata = astrata_god.resolve()

	if(!challenger || !astrata)
		return

	var/astrata_count = 0
	var/challenger_count = 0

	for(var/datum/weakref/supporter_ref in supporters_astrata)
		var/mob/living/carbon/human/supporter = supporter_ref.resolve()
		if(supporter && supporter.stat != DEAD && is_tennite(supporter))
			astrata_count++

	for(var/datum/weakref/supporter_ref in supporters_challenger)
		var/mob/living/carbon/human/supporter = supporter_ref.resolve()
		if(supporter && supporter.stat != DEAD && is_tennite(supporter))
			challenger_count++

	if(astrata_count >= challenger_count)
		priority_announce("Astrata's light prevails over the challenge of [challenger.name]! The Sun Queen confirms her status as a true heir of Psydon!", "Astrata is VICTORIOUS!", 'sound/magic/ahh2.ogg')
		adjust_storyteller_influence(ASTRATA, 250)
		adjust_storyteller_influence(challenger.name, -100)

		for(var/datum/weakref/supporter_ref in supporters_astrata)
			var/mob/living/carbon/human/supporter = supporter_ref.resolve()
			if(supporter && supporter.patron == astrata)

				for(var/datum/action/innate/choose_schism_side/choose in supporter.actions)
					if(choose.chose_early)
						to_chat(supporter, span_notice("Astrata's light prevails! Your steadfast devotion is rewarded with many triumphs."))
						supporter.adjust_triumphs(3)
					else
						to_chat(supporter, span_notice("Astrata's light prevails, but your late support goes unrewarded."))
					break
			else if(supporter)
				to_chat(supporter, span_notice("Astrata's light prevails over the challenge of [challenger.name]! The Sun Queen expected no less than your total support."))

		for(var/datum/weakref/supporter_ref in supporters_challenger)
			var/mob/living/carbon/human/supporter = supporter_ref.resolve()
			if(supporter)
				to_chat(supporter, span_userdanger("NEVER DEFY ME AGAIN!"))
				supporter.electrocute_act(5, astrata)
				supporter.add_curse(/datum/curse/astrata)

		cleanup_schism()

	else if(challenger_count > astrata_count)
		priority_announce("[challenger.name]'s challenge succeeds against Astrata's tyranny! The Sun Queen is grudgingly forced to share power with [challenger.name]...", "[challenger.name] RULES!", 'sound/magic/inspire_02.ogg')
		adjust_storyteller_influence(challenger.name, 200)
		adjust_storyteller_influence(ASTRATA, -50)

		for(var/datum/weakref/supporter_ref in supporters_challenger)
			var/mob/living/carbon/human/supporter = supporter_ref.resolve()
			if(supporter && supporter.patron == challenger)
				for(var/datum/action/innate/choose_schism_side/choose in supporter.actions)
					if(choose.chose_early)
						to_chat(supporter, span_notice("[challenger.name]'s challenge succeeds! Your persistent faith is rewarded with triumphs."))
						supporter.adjust_triumphs(2)
					else
						to_chat(supporter, span_notice("[challenger.name] succeeds, but your late support goes unrewarded."))
					break
			else if(supporter)
				for(var/datum/action/innate/choose_schism_side/choose in supporter.actions)
					if(choose.chose_early)
						to_chat(supporter, span_notice("[challenger.name]'s challenge succeeds against Astrata's tyranny! Your support is rewarded with a triumph."))
						supporter.adjust_triumphs(1)
					else
						to_chat(supporter, span_notice("[challenger.name]'s challenge succeeds, but your late support goes unrewarded."))
					break
		for(var/datum/weakref/supporter_ref in supporters_astrata)
			var/mob/living/carbon/human/supporter = supporter_ref.resolve()
			if(supporter)
				to_chat(supporter, span_userdanger("INCOMPETENT IMBECILES!"))
				supporter.electrocute_act(5, astrata)

		if(GLOB.todoverride == null)
			addtimer(CALLBACK(src, PROC_REF(astrata_scorn)), 15 SECONDS)

		addtimer(CALLBACK(src, PROC_REF(select_and_announce_vice_priest), challenger), 30 SECONDS)

/datum/tennite_schism/proc/astrata_scorn()
		priority_announce("You don't deserve my holy light, you ungrateful swines!", "Astrata's Scorn", 'sound/magic/fireball.ogg')
		GLOB.todoverride = "night"
		settod()
		addtimer(CALLBACK(GLOBAL_PROC, GLOBAL_PROC_REF(reset_tod_override)), 20 MINUTES)

/datum/tennite_schism/proc/select_and_announce_vice_priest(datum/patron/challenger)
	var/mob/living/carbon/human/selected_priest = null
	var/was_supporter = FALSE

	// First try to find a challenger supporter who is also clergy
	for(var/datum/weakref/supporter_ref in supporters_challenger)
		var/mob/living/carbon/human/human_mob = supporter_ref.resolve()
		if(human_mob && human_mob.stat != DEAD && human_mob.client && (human_mob.mind?.assigned_role.title in GLOB.church_positions) && human_mob.patron == challenger)
			selected_priest = human_mob
			was_supporter = TRUE
			break

	// If no supporter found, fall back to any clergy member who has the challenger as his patron
	if(!selected_priest)
		for(var/mob/living/carbon/human/human_mob in GLOB.player_list)
			if(human_mob.stat != DEAD && human_mob.client && (human_mob.mind?.assigned_role.title in GLOB.church_positions) && human_mob.patron == challenger)
				selected_priest = human_mob
				break

	// Promote the selected priest if we found one
	if(selected_priest)
		var/male
		if(selected_priest.gender == FEMALE)
			selected_priest.job = "Vice Priestess"
			male = FALSE
		else
			selected_priest.job = "Vice Priest"
			male = TRUE

		var/datum/devotion/C = selected_priest.cleric
		if(C)
			C.passive_devotion_gain = 1
			C.passive_progression_gain = 1
			START_PROCESSING(SSprocessing, C)
		add_verb(selected_priest, /mob/living/carbon/human/proc/devotionreport)
		add_verb(selected_priest, /mob/living/carbon/human/proc/clericpray)
		add_verb(selected_priest, /mob/living/carbon/human/proc/churchexcommunicate)
		add_verb(selected_priest, /mob/living/carbon/human/proc/churchcurse)
		add_verb(selected_priest, /mob/living/carbon/human/proc/churchannouncement)

		priority_announce("[challenger.name] has selected [selected_priest.real_name] as a new [male ? "Vice Priest" : "Vice Priestess"]! Power sharing begins!", "[male ? "Vice Priest" : "Vice Priestess"] rises", 'sound/magic/inspire_02.ogg')

		if(was_supporter)
			to_chat(selected_priest, span_green("[challenger.name] smiles upon you! Your faithful support during the schism has been rewarded with the position of a [male ? "Vice Priest" : "Vice Priestess"]!"))
		else
			to_chat(selected_priest, span_green("Though you did not openly support [challenger.name] during the schism, you have been chosen to serve as a [male ? "Vice Priest" : "Vice Priestess"]!"))

		if(C)
			to_chat(selected_priest, span_notice("You have gained a passive devotion gain and powers to announce, excommunicate or curse!"))

	cleanup_schism()

/datum/tennite_schism/proc/cleanup_schism()
	qdel(src)

/// Announces the current standings in the schism
/datum/tennite_schism/proc/announce_standings()
	var/datum/patron/challenger = challenger_god.resolve()
	var/datum/patron/astrata = astrata_god.resolve()

	if(!challenger || !astrata)
		return

	var/astrata_count = 0
	var/challenger_count = 0

	for(var/datum/weakref/supporter_ref in supporters_astrata)
		var/mob/living/carbon/human/supporter = supporter_ref.resolve()
		if(supporter && supporter.stat != DEAD && is_tennite(supporter))
			astrata_count++

	for(var/datum/weakref/supporter_ref in supporters_challenger)
		var/mob/living/carbon/human/supporter = supporter_ref.resolve()
		if(supporter && supporter.stat != DEAD && is_tennite(supporter))
			challenger_count++

	if(astrata_count >= challenger_count)
		priority_announce("Astrata is leading in the schism! She will have her revenge soon enough...", "Schism Rages On", 'sound/magic/marked.ogg')
	else if(challenger_count > astrata_count)
		priority_announce("[challenger.name] is leading in the schism! Astrata will soon be forced to yield...", "Schism Rages On", 'sound/magic/marked.ogg')

	halfway_passed = TRUE

/datum/tennite_schism/proc/change_side(mob/living/carbon/human/user, new_side)
	supporters_astrata -= WEAKREF(user)
	supporters_challenger -= WEAKREF(user)
	neutrals -= WEAKREF(user)

	switch(new_side)
		if("astrata")
			supporters_astrata += WEAKREF(user)
			to_chat(user, span_notice("You have declared your allegiance to Astrata!"))
		if("challenger")
			supporters_challenger += WEAKREF(user)
			var/datum/patron/challenger = challenger_god.resolve()
			if(challenger)
				to_chat(user, span_notice("You have declared your allegiance to [challenger.name]!"))
		if("neutral")
			neutrals += WEAKREF(user)
			to_chat(user, span_notice("You have declared neutrality in the schism."))

/datum/action/innate/choose_schism_side
	name = "Choose your side"
	button_icon_state = "limb_attach"

	var/chose_early = FALSE
	var/uses_remaining = 2

/datum/action/innate/choose_schism_side/Activate()
	. = ..()
	if(!length(GLOB.tennite_schisms))
		to_chat(owner, span_warning("There is no active schism to participate in."))
		return

	if(uses_remaining <= 0)
		to_chat(owner, span_warning("You've already finalized your allegiance in the schism."))
		return

	var/datum/tennite_schism/current_schism = GLOB.tennite_schisms[1]
	var/datum/patron/challenger = current_schism.challenger_god.resolve()

	var/list/options = list()
	options["Astrata"] = "astrata"
	options["Neutral"] = "neutral"
	if(challenger)
		options["[challenger.name]"] = "challenger"

	var/choice = input(owner, "Choose your allegiance in the schism, you can change your side [uses_remaining] more time\s", "Choose your side") as null|anything in options
	if(!choice || !current_schism)
		return

	var/current_side
	var/datum/weakref/user_ref = WEAKREF(owner)
	if(user_ref in current_schism.supporters_astrata)
		current_side = "astrata"
	else if(user_ref in current_schism.supporters_challenger)
		current_side = "challenger"
	else
		current_side = "neutral"

	if(options[choice] == current_side)
		to_chat(owner, span_notice("You're already supporting this side!"))
		return

	uses_remaining--
	current_schism.change_side(owner, options[choice])

	if(!current_schism.halfway_passed)
		chose_early = TRUE

	if(uses_remaining <= 0)
		to_chat(owner, span_boldnotice("Your allegiance in the schism is now final."))

/datum/round_event_control/schism_within_ten
	name = "Schism within the Ten"
	track = EVENT_TRACK_INTERVENTION
	typepath = /datum/round_event/schism_within_ten
	weight = 2
	max_occurrences = 1
	min_players = 50
	earliest_start = 20 MINUTES
	allowed_storytellers = list(/datum/storyteller/noc, /datum/storyteller/ravox, /datum/storyteller/necra, /datum/storyteller/xylix, /datum/storyteller/pestra, /datum/storyteller/abyssor, /datum/storyteller/dendor, /datum/storyteller/malum)

/datum/round_event_control/schism_within_ten/canSpawnEvent(players_amt, gamemode, fake_check)
	. = ..()
	if(!.)
		return FALSE

	var/alternative_events = FALSE
	for(var/datum/round_event_control/E in SSgamemode.control)
		if(E.track != EVENT_TRACK_INTERVENTION)
			continue
		if(E == src)
			continue
		if(E.canSpawnEvent(players_amt, gamemode, fake_check))
			alternative_events = TRUE
			break

	if(!alternative_events)
		return FALSE

	var/datum/patron/challenger = find_strongest_challenger()
	if(!challenger)
		return FALSE

	return TRUE

/datum/round_event/schism_within_ten/start()
	if(LAZYLEN(GLOB.tennite_schisms) > 0)
		return

	var/datum/patron/strongest_challenger = find_strongest_challenger()
	if(!strongest_challenger)
		return

	// Notify challenger god's followers
	for(var/mob/living/carbon/human/human_mob in GLOB.player_list)
		if(!istype(human_mob) || human_mob.stat == DEAD || !human_mob.client)
			continue

		if(human_mob.patron == strongest_challenger)
			bordered_message(human_mob, list(
				span_notice("You hear a divine calling from your patron - the time has come to challenge Astrata's authority! Prepare for the coming schism!")
			))
			human_mob.playsound_local(human_mob, 'sound/magic/marked.ogg', 100)

	new /datum/tennite_schism(strongest_challenger)
	addtimer(CALLBACK(GLOBAL_PROC, GLOBAL_PROC_REF(announce_schism_start)), 2 MINUTES)
	addtimer(CALLBACK(GLOBAL_PROC, GLOBAL_PROC_REF(announce_schism_standings)), 16 MINUTES)
	addtimer(CALLBACK(GLOBAL_PROC, GLOBAL_PROC_REF(announce_schism_end)), 33 MINUTES)

/// Officially starts the schism with an announcement and ability to choose sides
/proc/announce_schism_start()
	for(var/datum/tennite_schism/schism in GLOB.tennite_schisms)
		schism.announce()

/// Announces current standings in the schism
/proc/announce_schism_standings()
	for(var/datum/tennite_schism/schism in GLOB.tennite_schisms)
		schism.announce_standings()

/// Officially ends the schism and declares the winner of it
/proc/announce_schism_end()
	for(var/datum/tennite_schism/schism in GLOB.tennite_schisms)
		schism.process_winner()

/// Checks if the mob has any divine pantheon god as their patron
/proc/is_tennite(mob/living/carbon/human/human_mob)
	if(!human_mob.patron)
		return FALSE
	return istype(human_mob.patron, /datum/patron/divine)

/// Resets day cycle override to null
/proc/reset_tod_override()
	GLOB.todoverride = null

/// Finds strongest divine pantheon to challenge Astrata
/proc/find_strongest_challenger()
	var/datum/patron/strongest_challenger
	var/highest_influence = 0
	var/astrata_influence = get_storyteller_influence(ASTRATA) || 0

	for(var/type in subtypesof(/datum/patron/divine) - list(/datum/patron/divine/astrata, /datum/patron/divine/eora))
		var/datum/patron/divine/god = GLOB.patron_list[type]
		if(!god)
			continue

		var/has_clergy = FALSE
		for(var/mob/living/carbon/human/H in GLOB.player_list)
			if(H.stat != DEAD && H.client && H.patron == god && (H.mind?.assigned_role.title in GLOB.church_positions))
				has_clergy = TRUE
				break

		if(!has_clergy)
			continue

		var/god_influence = get_storyteller_influence(god.name) || 0
		if(god_influence > highest_influence && god_influence > astrata_influence)
			highest_influence = god_influence
			strongest_challenger = god

	return strongest_challenger
