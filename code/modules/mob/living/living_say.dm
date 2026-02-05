/mob/living/proc/Ellipsis(original_msg, chance = 50, keep_words)
	if(chance <= 0)
		return "..."
	if(chance >= 100)
		return original_msg

	var/list/words = splittext(original_msg," ")
	var/list/new_words = list()

	var/new_msg = ""

	for(var/w in words)
		if(prob(chance))
			new_words += "..."
			if(!keep_words)
				continue
		new_words += w

	new_msg = jointext(new_words," ")

	return new_msg

/mob/living/proc/check_slur(text)
	if(!LAZYLEN(GLOB.slurs_all))
		return
	for(var/slur as anything in GLOB.slurs_all)
		if(findtext(text, slur))
			record_featured_object_stat(FEATURED_STATS_SLURS, capitalize(slur))
			record_round_statistic(STATS_SLURS_SPOKEN)

/mob/living/carbon/check_slur(text)
	if(!LAZYLEN(GLOB.slurs_all))
		return
	for(var/slur as anything in GLOB.slurs_all)
		if(findtext(text, slur))
			record_featured_object_stat(FEATURED_STATS_SLURS, capitalize(slur))
			record_round_statistic(STATS_SLURS_SPOKEN)
			if(!LAZYLEN(GLOB.slur_groups) || !dna?.species)
				continue
			if(is_string_in_list(slur, GLOB.slur_groups["Generic"]))
				continue
			if(is_string_in_list(slur, GLOB.slur_groups[dna.species.name]))
				continue
			record_featured_stat(FEATURED_STATS_SPECIESISTS, src)

/mob/living/say(message, bubble_type, list/spans = list(), sanitize = TRUE, datum/language/language = null, ignore_spam = FALSE, forced = null)
	var/static/list/crit_allowed_modes = list(WHISPER_MODE = TRUE, MODE_CHANGELING = TRUE, MODE_ALIEN = TRUE)
	var/static/list/unconscious_allowed_modes = list(MODE_CHANGELING = TRUE, MODE_ALIEN = TRUE)

	var/ic_blocked = FALSE
	if(client && !forced && CHAT_FILTER_CHECK(message))
		//The filter doesn't act on the sanitized message, but the raw message.
		ic_blocked = TRUE

	if(sanitize)
		message = trim(copytext(sanitize(message), 1, MAX_MESSAGE_LEN))
	if(!message || message == "")
		return

	if(ic_blocked)
		//The filter warning message shows the sanitized message though.
		to_chat(src, "<span class='warning'>That message contained a word prohibited in IC chat! Consider reviewing the server rules.\n<span replaceRegex='show_filtered_ic_chat'>\"[message]\"</span></span>")
		SSblackbox.record_feedback("tally", "ic_blocked_words", 1, lowertext(config.ic_filter_regex.match))
		return

	var/list/message_mods = list()
	var/original_message = message
	message = get_message_mods(message, message_mods)
	var/datum/saymode/saymode = SSradio.saymodes[message_mods[RADIO_KEY]]
	var/in_critical = InCritical()

	if(message_mods[RADIO_EXTENSION] == MODE_ADMIN)
		if(client)
			client.cmd_admin_say(message)
		return

	if(message_mods[RADIO_EXTENSION] == MODE_DEADMIN)
		if(client)
			client.dsay(message)
		return

	if(stat == DEAD)
		say_dead(original_message)
		return

	if(check_emote(original_message, forced) || !can_speak_basic(original_message, ignore_spam, forced))
		return

	if(check_whisper(original_message, forced) || !can_speak_basic(original_message, ignore_spam, forced))
		return

	if(in_critical) // There are cheaper ways to do this, but they're less flexible, and this isn't ran all that often
		var/end = TRUE
		for(var/index in message_mods)
			if(crit_allowed_modes[index])
				end = FALSE
				break
		if(end)
			return
	else if(stat == UNCONSCIOUS)
		var/end = TRUE
		for(var/index in message_mods)
			if(unconscious_allowed_modes[index])
				end = FALSE
				break
		if(end)
			return

	language = message_mods[LANGUAGE_EXTENSION] || get_default_language()

	if(!can_speak_vocal(message))
		to_chat(src, "<span class='warning'>I can't talk.</span>")
		return

	var/message_range = 7

	var/succumbed = FALSE

	var/fullcrit = InFullCritical()
	if((InCritical() && !fullcrit) || message_mods[WHISPER_MODE] == MODE_WHISPER)
		message_range = 1
		message_mods[WHISPER_MODE] = MODE_WHISPER
		src.log_talk("whispered: [message]", LOG_WHISPER)
		if(fullcrit)
			var/health_diff = round(-HEALTH_THRESHOLD_DEAD + health)
			// If we cut our message short, abruptly end it with a-..
			var/message_len = length(message)
			message = copytext(message, 1, health_diff) + "[message_len > health_diff ? "-.." : "..."]"
			message = Ellipsis(message, 10, 1)
			last_words = message
			message_mods[WHISPER_MODE] = MODE_WHISPER_CRIT
			succumbed = TRUE
	else
		src.log_talk("said: [message]", LOG_SAY, forced_by=forced)

	message = treat_message(message) // unfortunately we still need this
	var/sigreturn = SEND_SIGNAL(src, COMSIG_MOB_SAY, args)
	if (sigreturn & COMPONENT_UPPERCASE_SPEECH)
		message = uppertext(message)
	if((sigreturn & COMPONENT_SPEECH_CANCEL) && !forced)
		return
	if(!message)
		return

	if(client)
		last_words = message
		record_featured_stat(FEATURED_STATS_SPEAKERS, src)
		if(findtext(message, "abyssor"))
			record_round_statistic(STATS_ABYSSOR_REMEMBERED)
		INVOKE_ASYNC(src, PROC_REF(check_slur), message)

	spans |= speech_span

	if(language)
		var/datum/language/L = GLOB.language_datum_instances[language]
		if(ishuman(src))
			var/mob/living/carbon/human/H = src
			if(H.dna?.species)
				var/list/stuff = H.dna.species.get_span_language(L)
				if(stuff)
					spans |= stuff
		else
			spans |= L.spans

	if(message_mods[MODE_SING])
		var/randomnote = pick("\u2669", "\u266A", "\u266B", "\u266C")
		message = "[randomnote] [message] [randomnote]"
		spans |= SPAN_SINGING

	//This is before anything that sends say a radio message, and after all important message type modifications, so you can scumb in alien chat or something
	if(saymode && !saymode.handle_message(src, message, language))
		return
	var/radio_message = message
	if(message_mods[WHISPER_MODE])
		// radios don't pick up whispers very well
		radio_message = stars(radio_message)
		spans |= SPAN_ITALICS
	var/radio_return = radio(message, message_mods, spans, language)
	if(radio_return & ITALICS)
		spans |= SPAN_ITALICS
	if(radio_return & REDUCE_RANGE)
		message_range = 1
		if(!message_mods[WHISPER_MODE])
			message_mods[WHISPER_MODE] = MODE_WHISPER
	if(radio_return & NOPASS)
		return TRUE

	var/datum/language/speaker_language = GLOB.language_datum_instances[language]
	if(speaker_language?.flags & SIGNLANG)
		send_speech_sign(message, message_range, src, bubble_type, spans, language, message_mods, original_message)
	else
		send_speech(message, message_range, src, bubble_type, spans, language, message_mods, original_message)

	if(succumbed)
		succumb(TRUE)
		to_chat(src, compose_message(src, language, message, null, spans, message_mods))

	return TRUE

/datum/species/proc/get_span_language(datum/language/message_language)
	if(!message_language)
		return
	return message_language.spans

// Whether the mob can see runechat from the speaker, assuming he will see his message on the text box
/mob/proc/can_see_runechat(atom/movable/speaker)
	if(!client || !client.prefs)
		return FALSE
	if(client.prefs.toggles_maptext & DISABLE_RUNECHAT)
		return FALSE
	if(stat >= UNCONSCIOUS)
		return FALSE
	if(!ismob(speaker) && !client.prefs.see_chat_non_mob)
		return FALSE
	return TRUE

/mob/living/Hear(message, atom/movable/speaker, datum/language/message_language, raw_message, radio_freq, list/spans, list/message_mods = list(), original_message)
	. = ..()
	if(!client)
		return
	var/deaf_message
	var/deaf_type
	if(speaker != src)
		if(!radio_freq) //These checks have to be seperate, else people talking on the radio will make "You can't hear yourself!" appear when hearing people over the radio while deaf.
			deaf_message = "<span class='name'>[speaker]</span> [speaker.verb_say] something but you cannot hear [speaker.p_them()]."
			deaf_type = 1
	else
		deaf_message = "<span class='notice'>I can't hear myself!</span>"
		deaf_type = 2 // Since you should be able to hear myself without looking

	// Create map text prior to modifying message for goonchat
	if(can_see_runechat(speaker) && can_hear())
		create_chat_message(speaker, message_language, raw_message, spans)
	// Recompose message for AI hrefs, language incomprehension.
	message = compose_message(speaker, message_language, raw_message, radio_freq, spans, message_mods)
	// voice muffling
	if(stat == UNCONSCIOUS)
		message = "<I>... You can almost hear something ...</I>"
	else if(isliving(speaker))
		var/mob/living/living_speaker = speaker
		if(living_speaker != src && living_speaker.client && src.can_hear()) //src.client already checked above
			log_message("heard [key_name(living_speaker)] say: [raw_message]", LOG_SAY, "#0978b8", FALSE)

	show_message(message, MSG_AUDIBLE, deaf_message, deaf_type)
	return message

// These are only on living for now
/// Travel only on the source Z level
#define Z_MODE_NONE 1
/// Travel a Z above and a Z below but only if there is no ceiling
#define Z_MODE_ONE_CEILING 2
/// Travel a Z above and a Z below ignoring ceilings
#define Z_MODE_ONE 3
/// Travel to all Z levels in the group
#define Z_MODE_ALL 4

/mob/living/send_speech(message, message_range = 6, obj/source = src, bubble_type = bubble_icon, list/spans, datum/language/message_language, list/message_mods = list(), original_message)
	var/speaker_has_ceiling = TRUE
	var/turf/speaker_turf = get_turf(src)
	var/turf/speaker_ceiling = get_step_multiz(speaker_turf, UP)
	if(!speaker_ceiling || istransparentturf(speaker_ceiling))
		speaker_has_ceiling = FALSE

	var/eavesdrop_range = 0
	if(message_mods[WHISPER_MODE]) // If we're whispering
		eavesdrop_range = EAVESDROP_EXTRA_RANGE

	var/z_message_type = Z_MODE_NONE
	if(!eavesdrop_range)
		z_message_type = Z_MODE_ONE_CEILING
		if(say_test(message) == "2") // ! shout
			message_range += 5
			z_message_type = Z_MODE_ONE
		else if(say_test(message) == "3") // Big "!!" shout
			message_range += 10
			z_message_type = Z_MODE_ALL

	var/list/listening
	if(z_message_type == Z_MODE_NONE)
		listening = get_hearers_in_view(message_range + eavesdrop_range, source)
	else
		// !! yelling is handled in the loop below
		// This may be too expensive with how many messages get sent in a round
		listening = get_hearers_in_view_z_range(message_range, source)

	var/list/the_dead = list()

	if(client) //client is so that ghosts don't have to listen to mice
		for(var/mob/player_mob as anything in GLOB.player_list)
			if(QDELETED(player_mob)) // Some times nulls and deleteds stay in this list. This is a workaround to prevent ic chat breaking for everyone when they do.
				continue // Remove if underlying cause (likely byond issue) is fixed. See TG PR #49004.
			// If yelling !! check all alive players if they are in range and in the same Z level group
			if(player_mob.stat != DEAD)
				if(z_message_type != Z_MODE_ALL)
					continue
				if(get_dist(player_mob, src) > message_range)
					continue
				if(!is_in_zweb(player_mob.z, source.z))
					continue
				listening |= player_mob
				continue
			// Else if dead check prefs
			if(!is_in_zweb(player_mob.z, source.z) || get_dist(player_mob, src) > message_range) //they're out of range of normal hearing
				if(player_mob.client.prefs)
					if(eavesdrop_range && !(player_mob.client.prefs.chat_toggles & CHAT_GHOSTWHISPER)) //they're whispering and we have hearing whispers at any range off
						continue
					if(!(player_mob.client.prefs.chat_toggles & CHAT_GHOSTEARS)) //they're talking normally and we have hearing at any range off
						continue
				the_dead[player_mob] = TRUE
				listening |= player_mob

	var/eavesdropping
	var/eavesrendered
	if(eavesdrop_range)
		eavesdropping = stars(message)
		eavesrendered = compose_message(src, message_language, eavesdropping, null, spans, message_mods)

	var/rendered = compose_message(src, message_language, message, null, spans, message_mods)

	for(var/atom/movable/hearing_movable as anything in listening)
		if(!hearing_movable)
			stack_trace("somehow there's a null returned from get_hearers_in_view() in send_speech!")
			continue

		var/ignore_z = FALSE
		if(isobserver(hearing_movable) || (locate(hearing_movable) in important_recursive_contents?[RECURSIVE_CONTENTS_HEARING_SENSITIVE]))
			ignore_z = TRUE

		var/keenears_range_bonus = 0
		if(HAS_TRAIT(hearing_movable, TRAIT_KEENEARS))
			keenears_range_bonus = 5

		if(!ignore_z && z_message_type == Z_MODE_ONE_CEILING && hearing_movable.z != z)
			var/listener_has_ceiling = TRUE
			var/turf/listener_turf = get_turf(hearing_movable)
			var/turf/listener_ceiling = GET_TURF_ABOVE(listener_turf) // optimize, this is inside a loop
			if(!listener_ceiling || istransparentturf(listener_ceiling))
				listener_has_ceiling = FALSE
			if(listener_turf.z < speaker_turf.z && listener_has_ceiling) //Listener is below the speaker and has a ceiling above them
				continue
			if(listener_turf.z > speaker_turf.z && speaker_has_ceiling) //Listener is above the speaker and the speaker has a ceiling above
				continue
			if(listener_has_ceiling && speaker_has_ceiling)	//Both have a ceiling, on different z-levels -- no hearing at all
				continue

		if(eavesdrop_range && get_dist(source, hearing_movable) > message_range + keenears_range_bonus && !(the_dead[hearing_movable]))
			hearing_movable.Hear(eavesrendered, src, message_language, eavesdropping, null, spans, message_mods, original_message)
		else
			hearing_movable.Hear(rendered, src, message_language, message, null, spans, message_mods, original_message)

	SEND_GLOBAL_SIGNAL(COMSIG_GLOB_LIVING_SAY_SPECIAL, src, message)

	//speech bubble
	var/list/speech_bubble_recipients = list()
	for(var/mob/M in listening)
		if(M.client && M.client.prefs.toggles_maptext & DISABLE_RUNECHAT)
			speech_bubble_recipients |= M.client

	if(length(speech_bubble_recipients))
		var/image/I = image('icons/mob/talk.dmi', src, "[bubble_type][say_test(message)]", FLY_LAYER)
		I.appearance_flags = APPEARANCE_UI_IGNORE_ALPHA
		INVOKE_ASYNC(GLOBAL_PROC, GLOBAL_PROC_REF(flick_overlay), I, speech_bubble_recipients, 30)

#undef Z_MODE_NONE
#undef Z_MODE_ONE_CEILING
#undef Z_MODE_ONE
#undef Z_MODE_ALL

/mob/living/proc/send_speech_sign(message, message_range = 6, obj/source = src, bubble_type = bubble_icon, list/spans, datum/language/message_language, list/message_mods = list(), original_message)
	var/eavesdrop_range = 0
	if(message_mods[WHISPER_MODE]) // If we're whispering
		eavesdrop_range = EAVESDROP_EXTRA_RANGE

	var/list/listening = get_hearers_in_view(message_range + eavesdrop_range, source)

	if(client) //client is so that ghosts don't have to listen to mice
		for(var/mob/player_mob as anything in GLOB.player_list)
			if(QDELETED(player_mob)) // Some times nulls and deleteds stay in this list. This is a workaround to prevent ic chat breaking for everyone when they do.
				continue // Remove if underlying cause (likely byond issue) is fixed. See TG PR #49004.
			// If yelling !! check all alive players if they are in range and in the same Z level group
			if(player_mob.stat != DEAD)
				continue
			if(player_mob.z != z || get_dist(player_mob, src) > message_range) //they're out of range of normal hearing
				if(player_mob.client.prefs)
					if(eavesdrop_range && !(player_mob.client.prefs.chat_toggles & CHAT_GHOSTWHISPER)) //they're whispering and we have hearing whispers at any range off
						continue
					if(!(player_mob.client.prefs.chat_toggles & CHAT_GHOSTEARS)) //they're talking normally and we have hearing at any range off
						continue
			listening |= player_mob

	var/rendered = compose_message(src, message_language, message, null, spans, message_mods)

	var/list/understanders = list() //those who aren't understanders will be shown an emote instead
	for(var/atom/movable/hearing_movable as anything in listening)
		if(!(hearing_movable.has_language(message_language) || hearing_movable.check_language_hear(message_language)))
			continue

		understanders += hearing_movable

		hearing_movable.Hear(rendered, src, message_language, message, null, spans, message_mods, original_message)

	SEND_GLOBAL_SIGNAL(COMSIG_GLOB_LIVING_SAY_SPECIAL, src, message)

	//time for emoting!!
	var/datum/language/speaker_language = GLOB.language_datum_instances[message_language]
	var/sign_verb = safepick(speaker_language.signlang_verb)
	if(!sign_verb)
		sign_verb = "signs"
	var/chatmsg = "<b>[src]</b> " + sign_verb + "."
	visible_message(chatmsg, runechat_message = sign_verb, ignored_mobs = understanders)

	//speech bubble
	var/list/speech_bubble_recipients = list()
	for(var/mob/M in understanders)
		if(M.client && M.client.prefs.toggles_maptext & DISABLE_RUNECHAT)
			speech_bubble_recipients |= M.client

	if(length(speech_bubble_recipients))
		var/image/I = image('icons/mob/talk.dmi', src, "[bubble_type][say_test(message)]", FLY_LAYER)
		I.appearance_flags = APPEARANCE_UI_IGNORE_ALPHA
		INVOKE_ASYNC(GLOBAL_PROC, GLOBAL_PROC_REF(flick_overlay), I, speech_bubble_recipients, 30)

/mob/proc/binarycheck()
	return FALSE

/mob/living/can_speak(message) //For use outside of Say()
	if(can_speak_basic(message) && can_speak_vocal(message))
		return TRUE
	return FALSE

/mob/living/proc/can_speak_basic(message, ignore_spam = FALSE, forced = FALSE) //Check BEFORE handling of xeno and ling channels
	if(client)
		if(client.prefs.muted & MUTE_IC)
			to_chat(src, "<span class='danger'>I cannot speak in IC (muted).</span>")
			return FALSE
		if(!(ignore_spam || forced) && client.handle_spam_prevention(message,MUTE_IC))
			return FALSE

	return TRUE

/mob/living/proc/can_speak_vocal(message) //Check AFTER handling of xeno and ling channels
	if(HAS_TRAIT(src, TRAIT_MUTE) || HAS_TRAIT(src, TRAIT_BAGGED))
		return FALSE

	if(is_muzzled())
		return FALSE

	if(!IsVocal())
		return FALSE

	return TRUE

/mob/living/proc/treat_message(message)
	if(HAS_TRAIT(src, TRAIT_ZOMBIE_SPEECH))
		message = "[repeat_string(rand(1, 3), "U")][repeat_string(rand(1, 6), "H")]..."
	else if(HAS_TRAIT(src, TRAIT_GARGLE_SPEECH))
		message = vocal_cord_torn(message)

	if(HAS_TRAIT(src, TRAIT_UNINTELLIGIBLE_SPEECH))
		message = unintelligize(message)

	if(derpspeech)
		message = derpspeech(message, stuttering)

	if(stuttering)
		message = stutter(message)

	if(slurring)
		message = slur(message)

	if(cultslurring)
		message = cultslur(message)

	message = capitalize(message)

	return message

/mob/living/proc/radio(message, list/message_mods = list(), list/spans, language)
	switch(message_mods[RADIO_EXTENSION])
		if(MODE_R_HAND)
			for(var/obj/item/r_hand in get_held_items_for_side(RIGHT_HANDS, all = TRUE))
				if (r_hand)
					return r_hand.talk_into(src, message, null, spans, language, message_mods)
				return ITALICS | REDUCE_RANGE
		if(MODE_L_HAND)
			for(var/obj/item/l_hand in get_held_items_for_side(LEFT_HANDS, all = TRUE))
				if (l_hand)
					return l_hand.talk_into(src, message, null, spans, language, message_mods)
				return ITALICS | REDUCE_RANGE

		if(MODE_BINARY)
			return ITALICS | REDUCE_RANGE //Does not return 0 since this is only reached by humans, not borgs or AIs.

	return 0

/mob/living/say_mod(input, list/message_mods = list())
	if(message_mods[WHISPER_MODE] == MODE_WHISPER)
		. = "whispers"
	else if(message_mods[WHISPER_MODE] == MODE_WHISPER_CRIT)
		. = "whispers in [p_their()] last breath"
	else if(message_mods[MODE_SING])
		. = "sings"
	else if(stuttering)
		. = "stammers"
	else if(derpspeech)
		. = "gibbers"
	else
		. = ..()

/mob/living/whisper(message, bubble_type, list/spans = list(), sanitize = TRUE, datum/language/language = null, ignore_spam = FALSE, forced = null)
	say("#[message]", bubble_type, spans, sanitize, language, ignore_spam, forced)

/mob/living/get_language_holder(shadow=TRUE)
	if(mind && shadow)
		// Mind language holders shadow mob holders.
		. = mind.get_language_holder()
		if(.)
			return .

	. = ..()
