/proc/random_human_blood_type()
	var/static/list/human_blood_type_weights = list(
		/datum/blood_type/human = 10, //bloodtypes aren't real
	)

	return pickweight(human_blood_type_weights)

/proc/random_eye_color()
	switch(pick(20;"brown",20;"hazel",20;"grey",15;"blue",15;"green",1;"amber",1;"albino"))
		if("brown")
			return "630"
		if("hazel")
			return "542"
		if("grey")
			return pick("666","777","888","999","aaa","bbb","ccc")
		if("blue")
			return "36c"
		if("green")
			return "060"
		if("amber")
			return "fc0"
		if("albino")
			return pick("c","d","e","f") + pick("0","1","2","3","4","5","6","7","8","9") + pick("0","1","2","3","4","5","6","7","8","9")
		else
			return "000"

/proc/random_underwear(gender)
	if(!GLOB.underwear_list.len)
		init_sprite_accessory_subtypes(/datum/sprite_accessory/underwear, GLOB.underwear_list, GLOB.underwear_m, GLOB.underwear_f)
	switch(gender)
		if(MALE)
			return pick(GLOB.underwear_m)
		if(FEMALE)
			return pick(GLOB.underwear_f)
		else
			return pick(GLOB.underwear_list)

/proc/random_undershirt(gender)
	if(!GLOB.undershirt_list.len)
		init_sprite_accessory_subtypes(/datum/sprite_accessory/undershirt, GLOB.undershirt_list, GLOB.undershirt_m, GLOB.undershirt_f)
	switch(gender)
		if(MALE)
			return pick(GLOB.undershirt_m)
		if(FEMALE)
			return pick(GLOB.undershirt_f)
		else
			return pick(GLOB.undershirt_list)

/// TO BE DELETED, INTEGRATE INTO SPECIES DATUM
/proc/random_features()
	return MANDATORY_FEATURE_LIST

/proc/random_unique_name(gender, attempts_to_find_unique_name=10)
	for(var/i in 1 to attempts_to_find_unique_name)
		if(gender==FEMALE)
			. = capitalize(pick(GLOB.first_names_female)) + " " + capitalize(pick(GLOB.last_names))
		else
			. = capitalize(pick(GLOB.first_names_male)) + " " + capitalize(pick(GLOB.last_names))

		if(!findname(.))
			break


GLOBAL_LIST_INIT(skin_tones, sortList(
	list(
		"Ice Cap" = SKIN_COLOR_ICECAP, // - (Pale)
		"Arctic" = SKIN_COLOR_ARCTIC, // - (White 1)
		"Tundra" = SKIN_COLOR_TUNDRA, // - (White 2)
		"Continental" = SKIN_COLOR_CONTINENTAL, // - (White 3)
		"Temperate" = SKIN_COLOR_TEMPERATE, // - (White 4)
		"Coastal" = SKIN_COLOR_COASTAL, // - (Latin)
		"Subtropical" = SKIN_COLOR_SUBTROPICAL, // - (Mediterranean)
		"Tropical Dry" = SKIN_COLOR_TROPICALDRY, // - (Mediterranean 2)
		"Tropical Wet" = SKIN_COLOR_TROPICALWET, // - (Latin 2)
		"Desert" = SKIN_COLOR_DESERT, //  - (Middle-east 1)
		"Oasis" = SKIN_COLOR_OASIS, // - (Middle-east 2)
		"Steppe" = SKIN_COLOR_CRIMSONLANDS, // - (Black)
		"Volcanic" = SKIN_COLOR_VOLCANIC, // - Melanesian
		"Island" = SKIN_COLOR_ISLAND, // - Polynesian
		"Taiga" = SKIN_COLOR_TAIGA, // - Native American 1
		"Swamp" = SKIN_COLOR_SWAMP, // - Native American 2
	)))

/proc/random_skin_tone()
	return GLOB.skin_tones[pick(GLOB.skin_tones)]

GLOBAL_LIST_INIT(haircolor, sortList(
	list(
		"blond - pale" = "9d8d6e",
		"blond - dirty" = "88754f",
		"blond - drywheat" = "d5ba7b",
		"blond - strawberry" = "c69b71",

		"brown - mud" = "362e25",
		"brown - oats" = "584a3b",
		"brown - grain" = "58433b",
		"brown - soil" = "48322a",
		"brown - bark" = "2d1300",

		"black - oil" = "181a1d",
		"black - cave" = "201616",
		"black - rogue" = "2b201b",
		"black - midnight" = "1d1b2b",

		"red - berry" = "b23434",
		"red - wine" = "82534c",
		"red - sunset" = "82462b",
		"red - blood" = "822b2b",
		"red - maroon" = "612929",

		"orange - rust" = "bc5e35"
	)))

/proc/random_haircolor()
	return GLOB.haircolor[pick(GLOB.haircolor)]

GLOBAL_LIST_INIT(oldhc, sortList(
	list(
		"pale - golden" = "f0eab6",
		"pale - dust" = "ded0af",
		"gray - decay" = "6a6a6a",
		"gray - silvered" = "687371",
		"gray - elderly" = "9e9e9e",
		"gray - ashen" = "404040",
		"white - ancient" = "c9c9c9",
		"white - mythic" = "f4f4f4"
	)))

//some additional checks as a callback for for do_afters that want to break on losing health or on the mob taking action
/mob/proc/break_do_after_checks(list/checked_health, check_clicks)
	if(check_clicks && next_move > world.time)
		return FALSE
	return TRUE

//pass a list in the format list("health" = mob's health var) to check health during this
/mob/living/break_do_after_checks(list/checked_health, check_clicks)
	if(islist(checked_health))
		if(health < checked_health["health"])
			return FALSE
		checked_health["health"] = health
	return ..()

/**
 * Timed action involving one mob user. Target is optional. \
 * Checks that `user` does not move, change hands, get stunned, etc. for the
 * given `delay`. Returns `TRUE` on success or `FALSE` on failure.
 *
 * @param {mob} user - The mob performing the action. \
 * @param {number} delay - The time in deciseconds. Use the SECONDS define for readability. `1 SECONDS` is 10 deciseconds. \
 * @param {atom} target - The target of the action. This is where the progressbar will display. \
 * @param {flag} timed_action_flags - Flags to control the behavior of the timed action. \
 * @param {boolean} progress - Whether to display a progress bar / cogbar. \
 * @param {datum/callback} extra_checks - Additional checks to perform before the action is executed. \
 *
 * @param {string} interaction_key - The assoc key under which the do_after is capped, with max_interact_count being the cap. Interaction key will default to target if not set. \
 * @param {number} max_interact_count - The maximum amount of interactions allowed. \
 * @param {boolean} hidden - By default, any action 1 second or longer shows a cog over the user while it is in progress. If hidden is set to TRUE, the cog will not be shown.
 * @param {boolean} display_over_user - By default, the progress bar is displayed over the target if it is defined. If set to TRUE, the bar will be displayed over the user instead
 */
/proc/do_after(mob/user, delay, atom/target = null, timed_action_flags = NONE, progress = TRUE, datum/callback/extra_checks, interaction_key, max_interact_count = 1, hidden = FALSE, display_over_user = FALSE)
	if(!user)
		return FALSE
	if(!isnum(delay))
		CRASH("do_after was passed a non-number delay: [delay || "null"].")

	/* V: */
	if(!(timed_action_flags & IGNORE_USER_DOING) && user.doing())
		return FALSE
	/* :V */

	if(!interaction_key)
		interaction_key = target || "doafter_unspecified" /* V */
	if(interaction_key) //Do we have a interaction_key now?
		var/current_interaction_count = LAZYACCESS(user.do_afters, interaction_key) || 0
		if(current_interaction_count >= max_interact_count) //We are at our peak
			return FALSE
		LAZYSET(user.do_afters, interaction_key, current_interaction_count + 1)

	var/atom/user_loc = user.loc
	var/atom/target_loc = target?.loc
	var/user_dir = user.dir /* V */

	var/holding = user.get_active_held_item()

	if(!(timed_action_flags & IGNORE_SLOWDOWNS))
		delay *= user.do_after_coefficent()

	var/datum/progressbar/progbar
	var/datum/cogbar/cog

	if(progress)
		if(user.client)
			progbar = new(user, delay, display_over_user ? user : target || user)
		if(!hidden && delay >= 1 SECONDS)
			cog = new(user)

	SEND_SIGNAL(user, COMSIG_DO_AFTER_BEGAN)

	var/endtime = world.time + delay
	var/starttime = world.time
	. = TRUE
	while(world.time < endtime)
		stoplag(1)

		if(!QDELETED(progbar))
			progbar.update(world.time - starttime)

		if(QDELETED(user) \
			|| (!(timed_action_flags & IGNORE_USER_LOC_CHANGE) && user.loc != user_loc) \
			|| (!(timed_action_flags & IGNORE_HELD_ITEM) && user.get_active_held_item() != holding) \
			|| (!(timed_action_flags & IGNORE_INCAPACITATED) && HAS_TRAIT(user, TRAIT_INCAPACITATED)) \
			/* V: */ \
			|| (!DOING_INTERACTION(user, interaction_key)) \
			|| (!(timed_action_flags & IGNORE_USER_DIR_CHANGE) && user.dir != user_dir) \
			/* :V */ \
			|| (extra_checks && !extra_checks.Invoke()))
			. = FALSE
			break

		if(target && (user != target) && \
			(QDELETED(target) \
			|| (!(timed_action_flags & IGNORE_TARGET_LOC_CHANGE) && target.loc != target_loc)))
			. = FALSE
			break

	if(!QDELETED(progbar))
		progbar.end_progress()

	if(!QDELETED(cog))
		cog.remove(TRUE) /* V */

	if(interaction_key)
		user.stop_doing(interaction_key)

	SEND_SIGNAL(user, COMSIG_DO_AFTER_ENDED)

/mob/proc/do_after_coefficent() // This gets added to the delay on a do_after, default 1
	. = 1
	return

/// Returns the total amount of do_afters this mob is taking part in
/mob/proc/do_after_count()
	var/count = 0
	for(var/key in do_afters)
		count += do_afters[key]
	return count

/* V: */
/// Returns TRUE if the mob is in a do_after.
/mob/proc/doing()
	for(var/key in do_afters)
		if(do_afters[key] > 0)
			return TRUE

/// Clears out all do_afters with a specified interaction key
/mob/proc/stop_doing(interaction_key)
	if(!interaction_key)
		return

	var/reduced_interaction_count = (LAZYACCESS(do_afters, interaction_key) || 0) - 1
	if(reduced_interaction_count > 0) // Not done yet!
		LAZYSET(do_afters, interaction_key, reduced_interaction_count)
		return
	// all out, let's clear er out fully
	LAZYREMOVE(do_afters, interaction_key)

/// Stops all do_afters
/mob/proc/stop_all_doing()
	for(var/interaction_key in do_afters)
		LAZYREMOVE(do_afters, interaction_key)

/* :V */

/proc/is_species(mob/living/carbon/human/checked, species_datum)
	. = FALSE
	if(!istype(checked))
		return
	if(istype(checked.dna?.species, species_datum))
		. = TRUE

/proc/spawn_atom_to_turf(spawn_type, target, amount, admin_spawn=FALSE, list/extra_args)
	var/turf/T = get_turf(target)
	if(!T)
		CRASH("attempt to spawn atom type: [spawn_type] in nullspace")

	var/list/new_args = list(T)
	if(extra_args)
		new_args += extra_args
	var/atom/X
	for(var/j in 1 to amount)
		X = new spawn_type(arglist(new_args))
		if (admin_spawn)
			X.flags_1 |= ADMIN_SPAWNED_1
	return X //return the last mob spawned

/proc/spawn_and_random_walk(spawn_type, target, amount, walk_chance=100, max_walk=3, always_max_walk=FALSE, admin_spawn=FALSE)
	var/turf/T = get_turf(target)
	var/step_count = 0
	if(!T)
		CRASH("attempt to spawn atom type: [spawn_type] in nullspace")

	var/list/spawned_mobs = new(amount)

	for(var/j in 1 to amount)
		var/atom/movable/X

		if (istype(spawn_type, /list))
			var/mob_type = pick(spawn_type)
			X = new mob_type(T)
		else
			X = new spawn_type(T)

		if (admin_spawn)
			X.flags_1 |= ADMIN_SPAWNED_1

		spawned_mobs[j] = X

		if(always_max_walk || prob(walk_chance))
			if(always_max_walk)
				step_count = max_walk
			else
				step_count = rand(1, max_walk)

			for(var/i in 1 to step_count)
				step(X, pick(NORTH, SOUTH, EAST, WEST))

	return spawned_mobs

// Displays a message in deadchat, sent by source. Source is not linkified, message is, to avoid stuff like character names to be linkified.
// Automatically gives the class deadsay to the whole message (message + source)
/proc/deadchat_broadcast(message, source=null, mob/follow_target=null, turf/turf_target=null, speaker_key=null, message_type=DEADCHAT_REGULAR)
	message = "<span class='deadsay'>[source]<span class='linkify'>[message]</span></span>"
	for(var/mob/M in GLOB.player_list)
		var/datum/preferences/prefs
		if(M.client.prefs)
			prefs = M.client.prefs
		else
			prefs = new

		var/override = FALSE
		if(M.client.holder && (prefs.chat_toggles & CHAT_DEAD))
			override = TRUE
		if(HAS_TRAIT(M, TRAIT_SIXTHSENSE))
			override = TRUE
		if(isnewplayer(M) && !override)
			continue
		if(M.stat != DEAD && !override)
			continue
		if(speaker_key && (speaker_key in prefs.ignoring))
			continue

		switch(message_type)
			if(DEADCHAT_DEATHRATTLE)
				if(prefs.toggles & DISABLE_DEATHRATTLE)
					continue
			if(DEADCHAT_ARRIVALRATTLE)
				if(prefs.toggles & DISABLE_ARRIVALRATTLE)
					continue

		if(isobserver(M))
			var/rendered_message = message

			if(follow_target)
//				var/F
//				if(turf_target)
//					F = FOLLOW_OR_TURF_LINK(M, follow_target, turf_target)
//				else
//					F = FOLLOW_LINK(M, follow_target)
//				rendered_message = "[F] [message]"
				rendered_message = "[message]"
			else if(turf_target)
//				var/turf_link = TURF_LINK(M, turf_target)
//				rendered_message = "[turf_link] [message]"
				rendered_message = "[message]"

			to_chat(M, rendered_message)
		else
			to_chat(M, message)

//Used in chemical_mob_spawn. Generates a random mob based on a given gold_core_spawnable value.
/proc/create_random_mob(spawn_location, mob_class = HOSTILE_SPAWN)
	var/static/list/mob_spawn_meancritters = list() // list of possible hostile mobs
	var/static/list/mob_spawn_nicecritters = list() // and possible friendly mobs

	if(mob_spawn_meancritters.len <= 0 || mob_spawn_nicecritters.len <= 0)
		for(var/mob/living/simple_animal/SA as anything in typesof(/mob/living/simple_animal))
			switch(initial(SA.gold_core_spawnable))
				if(HOSTILE_SPAWN)
					mob_spawn_meancritters += SA
				if(FRIENDLY_SPAWN)
					mob_spawn_nicecritters += SA

	var/chosen
	if(mob_class == FRIENDLY_SPAWN)
		chosen = pick(mob_spawn_nicecritters)
	else
		chosen = pick(mob_spawn_meancritters)
	var/mob/living/simple_animal/C = new chosen(spawn_location)
	return C

/proc/dance_rotate(atom/movable/AM, datum/callback/callperrotate, set_original_dir=FALSE)
	set waitfor = FALSE
	var/originaldir = AM.dir
	for(var/i in list(NORTH,SOUTH,EAST,WEST,EAST,SOUTH,NORTH,SOUTH,EAST,WEST,EAST,SOUTH))
		if(!AM)
			return
		AM.setDir(i)
		callperrotate?.Invoke()
		sleep(1)
	if(set_original_dir)
		AM.setDir(originaldir)

/**
 * Gets the mind from a variable, whether it be a mob, or a mind itself.
 * Also works on brains - it will try to fetch the brainmob's mind.
 * If [include_last] is true, then it will also return last_mind for carbons if there isn't a current mind.
 */
/proc/get_mind(target, include_last = FALSE) as /datum/mind
	RETURN_TYPE(/datum/mind)
	if(istype(target, /datum/mind))
		return target
	else if(ismob(target))
		var/mob/mob_target = target
		if(!QDELETED(mob_target.mind))
			return mob_target.mind
		if(include_last && iscarbon(mob_target))
			var/mob/living/carbon/carbon_target = mob_target
			if(!QDELETED(carbon_target.last_mind))
				return carbon_target.last_mind
	else if(istype(target, /obj/item/organ/brain))
		var/obj/item/organ/brain/brain = target
		if(!QDELETED(brain.brainmob?.mind))
			return brain.brainmob.mind
