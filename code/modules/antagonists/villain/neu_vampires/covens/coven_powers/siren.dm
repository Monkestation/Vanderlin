/datum/coven/siren
	name = "Siren Blessing"
	desc = "Typically found in vampires who frequent the seas of Enigma, they've developed the ability to adapt much like sirens."
	icon_state = "melpominee"
	power_type = /datum/coven_power/siren

/datum/coven_power/siren
	name = "Siren power name"
	desc = "Siren power description"


//THE MISSING VOICE
/datum/coven_power/siren/the_missing_voice
	name = "The Missing Voice"
	desc = "Throw your voice to any place you can see."

	level = 1
	check_flags = COVEN_CHECK_CONSCIOUS | COVEN_CHECK_CAPABLE | COVEN_CHECK_SPEAK
	target_type = TARGET_OBJ | TARGET_LIVING
	range = 7

	cooldown_length = 5 SECONDS

/datum/coven_power/siren/the_missing_voice/activate(atom/movable/target)
	. = ..()
	var/new_say = input(owner, "What will [target] say?") as null|text
	if(!new_say)
		return

	//prevent forceful emoting and whatnot
	new_say = trim(copytext_char(sanitize(new_say), 1, MAX_MESSAGE_LEN))
	if (findtext(new_say, "*"))
		to_chat(owner, span_danger("You can't force others to perform emotes!"))
		return

	if (CHAT_FILTER_CHECK(new_say))
		to_chat(owner, span_warning("That message contained a word prohibited in IC chat! Consider reviewing the server rules.\n<span replaceRegex='show_filtered_ic_chat'>\"[new_say]\"</span>"))
		SSblackbox.record_feedback("tally", "ic_blocked_words", 1, lowertext(config.ic_filter_regex.match))
		return

	target.say(message = new_say, forced = "melpominee 1")

	if (!isliving(target))
		return
	var/mob/living/L = target
	//viewers are able to detect if a person's words aren't their own
	var/base_difficulty = 10
	var/difficulty_malus = 0
	var/masked = !is_human_part_visible(L, HIDEFACE)
	if (masked || L.typing_indicator)
		base_difficulty += 4

	for (var/mob/living/hearer in (oviewers(7, target) - owner))
		if (!hearer.client)
			continue
		difficulty_malus = 0
		if (get_dist(hearer, target) > 3)
			difficulty_malus += 2
		if (hearer.stat_roll(STAT_PERCEPTION, 20 -( base_difficulty + difficulty_malus)))
			if (masked)
				to_chat(hearer, span_warning("[target]'s jaw isn't moving to match [target.p_their()] words."))
			else
				to_chat(hearer, span_warning("[target]'s lips aren't moving to match [target.p_their()] words."))

//PHANTOM SPEAKER
/datum/coven_power/siren/phantom_speaker
	name = "Phantom Speaker"
	desc = "Project your voice to anyone you've met, speaking to them from afar."

	level = 2
	check_flags = COVEN_CHECK_CONSCIOUS | COVEN_CHECK_SPEAK

	cooldown_length = 5 SECONDS

/datum/coven_power/siren/phantom_speaker/activate()
	. = ..()
	var/mob/living/target = input(owner, "Who will you project your voice to?") as null|mob in (GLOB.player_list - owner)
	if(!target)
		return

	var/input_message = input(owner, "What message will you project to them?") as null|text
	if (!input_message)
		return

	//sanitisation!
	input_message = trim(copytext_char(sanitize(input_message), 1, MAX_MESSAGE_LEN))
	if(CHAT_FILTER_CHECK(input_message))
		to_chat(owner, span_warning("That message contained a word prohibited in IC chat! Consider reviewing the server rules.\n<span replaceRegex='show_filtered_ic_chat'>\"[input_message]\"</span>"))
		SSblackbox.record_feedback("tally", "ic_blocked_words", 1, lowertext(config.ic_filter_regex.match))
		return

	var/language = owner.get_random_understood_language()
	var/message = owner.compose_message(owner, language, input_message, , list())
	to_chat(target, "<span class='purple'><i>You hear someone's voice in your head...</i></span>")
	target.Hear(message, target, language, input_message, , , )
	to_chat(owner, span_notice("You project your voice to [target]'s ears."))

//MADRIGAL
/datum/coven_power/siren/madrigal
	name = "Madrigal"
	desc = "Sing a siren song, calling all nearby to you."

	level = 3
	check_flags = COVEN_CHECK_CONSCIOUS | COVEN_CHECK_CAPABLE | COVEN_CHECK_IMMOBILE | COVEN_CHECK_SPEAK

	cooldown_length = 5 SECONDS
	duration_length = 2 SECONDS
	duration_override = TRUE
	violates_masquerade = TRUE

/datum/coven_power/siren/madrigal/activate()
	. = ..()
	for(var/mob/living/carbon/human/listener in oviewers(7, owner))
		listener.create_walk_to(2 SECONDS, owner)

		listener.remove_overlay(MUTATIONS_LAYER)
		var/mutable_appearance/song_overlay = mutable_appearance('icons/effects/clan.dmi', "song", -MUTATIONS_LAYER)
		listener.overlays_standing[MUTATIONS_LAYER] = song_overlay
		listener.apply_overlay(MUTATIONS_LAYER)

		addtimer(CALLBACK(src, PROC_REF(deactivate), listener), 2 SECONDS)

/mob/living/carbon/human/proc/create_walk_to(duration, mob/living/walk_to)
	ADD_TRAIT(src, TRAIT_MOVEMENT_BLOCKED, VAMPIRE_TRAIT)
	walk_to_target = walk_to
	walk_to_duration = duration
	walk_to_steps_taken = 0
	walk_to_last_pos = get_turf(src)
	walk_to_cached_path = null

	// Start the walking process
	walk_to_caster()

/mob/living/carbon/human/proc/walk_to_caster()
	if(!walk_to_target || walk_to_steps_taken >= walk_to_duration)
		remove_walk_to_trait()
		return

	if(!CheckFrenzyMove())
		var/turf/current_pos = get_turf(src)
		var/turf/target_pos = get_turf(walk_to_target)

		// Only regenerate path if we've moved to a different position or don't have a cached path
		if(!walk_to_cached_path || walk_to_last_pos != current_pos)
			walk_to_cached_path = get_path_to(src, target_pos, TYPE_PROC_REF(/turf, Heuristic_cardinal_3d), 33, 250, 1)
			walk_to_last_pos = current_pos

		var/moved = FALSE

		if(length(walk_to_cached_path))
			walk(src, 0) // Stop any existing walk
			set_glide_size(DELAY_TO_GLIDE_SIZE(total_multiplicative_slowdown()))
			step_to(src, walk_to_cached_path[1], 0)
			face_atom(walk_to_target)

			walk_to_cached_path.Cut(1, 2)
			moved = TRUE
		else
			walk_towards(src, walk_to_target, 0, total_multiplicative_slowdown())
			moved = TRUE

		if(moved)
			walk_to_steps_taken++

	addtimer(CALLBACK(src, PROC_REF(walk_to_caster)), total_multiplicative_slowdown())

/mob/living/carbon/human/proc/remove_walk_to_trait()
	REMOVE_TRAIT(src, TRAIT_MOVEMENT_BLOCKED, VAMPIRE_TRAIT)
	walk(src, 0) // Stop any walking
	walk_to_target = null
	walk_to_duration = 0
	walk_to_steps_taken = 0
	walk_to_last_pos = null
	walk_to_cached_path = null

/datum/coven_power/siren/madrigal/deactivate(mob/living/carbon/human/target)
	. = ..()
	target.remove_overlay(MUTATIONS_LAYER)

//SIREN'S BECKONING
/datum/coven_power/siren/sirens_beckoning
	name = "Siren's Beckoning"
	desc = "Sing an unearthly song to stun those around you."

	level = 4
	check_flags = COVEN_CHECK_CONSCIOUS | COVEN_CHECK_CAPABLE | COVEN_CHECK_IMMOBILE | COVEN_CHECK_SPEAK

	duration_length = 2 SECONDS
	cooldown_length = 7.5 SECONDS
	duration_override = TRUE
	violates_masquerade = TRUE

/datum/coven_power/siren/sirens_beckoning/activate()
	. = ..()
	for(var/mob/living/carbon/human/listener in oviewers(7, owner))
		listener.Stun(2 SECONDS)

		listener.remove_overlay(MUTATIONS_LAYER)
		var/mutable_appearance/song_overlay = mutable_appearance('icons/effects/clan.dmi', "song", -MUTATIONS_LAYER)
		listener.overlays_standing[MUTATIONS_LAYER] = song_overlay
		listener.apply_overlay(MUTATIONS_LAYER)

		addtimer(CALLBACK(src, PROC_REF(deactivate), listener), 2 SECONDS)

/datum/coven_power/siren/sirens_beckoning/deactivate(mob/living/carbon/human/target)
	. = ..()
	target.remove_overlay(MUTATIONS_LAYER)

//SHATTERING CRESCENDO
/datum/coven_power/siren/shattering_crescendo
	name = "Shattering Crescendo"
	desc = "Scream at an unnatural pitch, shattering the bodies of your enemies."

	level = 5
	check_flags = COVEN_CHECK_CONSCIOUS | COVEN_CHECK_CAPABLE | COVEN_CHECK_IMMOBILE | COVEN_CHECK_SPEAK

	duration_length = 2 SECONDS
	cooldown_length = 7.5 SECONDS
	duration_override = TRUE
	violates_masquerade = TRUE

/datum/coven_power/siren/shattering_crescendo/activate()
	. = ..()
	for(var/mob/living/carbon/human/listener in oviewers(7, owner))
		listener.Stun(2 SECONDS)
		listener.apply_damage(50, BRUTE, BODY_ZONE_HEAD)

		listener.remove_overlay(MUTATIONS_LAYER)
		var/mutable_appearance/song_overlay = mutable_appearance('icons/effects/clan.dmi', "song", -MUTATIONS_LAYER)
		listener.overlays_standing[MUTATIONS_LAYER] = song_overlay
		listener.apply_overlay(MUTATIONS_LAYER)

		addtimer(CALLBACK(src, PROC_REF(deactivate), listener), 2 SECONDS)

/datum/coven_power/siren/shattering_crescendo/deactivate(mob/living/carbon/human/target)
	. = ..()
	target.remove_overlay(MUTATIONS_LAYER)
