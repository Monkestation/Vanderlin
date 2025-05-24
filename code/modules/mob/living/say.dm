GLOBAL_LIST_INIT(department_radio_prefixes, list(":", "."))

GLOBAL_LIST_INIT(department_radio_keys, list(
	// Location
	MODE_KEY_R_HAND = MODE_R_HAND,
	MODE_KEY_L_HAND = MODE_L_HAND,
	MODE_KEY_INTERCOM = MODE_INTERCOM,

	// Department
	MODE_KEY_DEPARTMENT = MODE_DEPARTMENT,
	RADIO_KEY_COMMAND = RADIO_CHANNEL_COMMAND,
	RADIO_KEY_SCIENCE = RADIO_CHANNEL_SCIENCE,
	RADIO_KEY_MEDICAL = RADIO_CHANNEL_MEDICAL,
	RADIO_KEY_ENGINEERING = RADIO_CHANNEL_ENGINEERING,
	RADIO_KEY_SECURITY = RADIO_CHANNEL_SECURITY,
	RADIO_KEY_SUPPLY = RADIO_CHANNEL_SUPPLY,
	RADIO_KEY_SERVICE = RADIO_CHANNEL_SERVICE,

	// Faction
	RADIO_KEY_SYNDICATE = RADIO_CHANNEL_SYNDICATE,
	RADIO_KEY_CENTCOM = RADIO_CHANNEL_CENTCOM,

	// Admin
	MODE_KEY_ADMIN = MODE_ADMIN,
	MODE_KEY_DEADMIN = MODE_DEADMIN,

	// Misc
	RADIO_KEY_AI_PRIVATE = RADIO_CHANNEL_AI_PRIVATE, // AI Upload channel
	MODE_KEY_VOCALCORDS = MODE_VOCALCORDS,		// vocal cords, used by Voice of God


	//kinda localization -- rastaf0
	//same keys as above, but on russian keyboard layout. This file uses cp1251 as encoding.
	// Location
	"ê" = MODE_R_HAND,
	"ä" = MODE_L_HAND,
	"ø" = MODE_INTERCOM,

	// Department
	"ð" = MODE_DEPARTMENT,
	"ñ" = RADIO_CHANNEL_COMMAND,
	"ò" = RADIO_CHANNEL_SCIENCE,
	"ü" = RADIO_CHANNEL_MEDICAL,
	"ó" = RADIO_CHANNEL_ENGINEERING,
	"û" = RADIO_CHANNEL_SECURITY,
	"ã" = RADIO_CHANNEL_SUPPLY,
	"ì" = RADIO_CHANNEL_SERVICE,

	// Faction
	"å" = RADIO_CHANNEL_SYNDICATE,
	"í" = RADIO_CHANNEL_CENTCOM,

	// Admin
	"ç" = MODE_ADMIN,
	"â" = MODE_ADMIN,

	// Misc
	"ù" = RADIO_CHANNEL_AI_PRIVATE,
	"÷" = MODE_VOCALCORDS
))

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
			GLOB.vanderlin_round_stats[STATS_SLURS_SPOKEN]++

/mob/living/carbon/check_slur(text)
	if(!LAZYLEN(GLOB.slurs_all))
		return
	for(var/slur as anything in GLOB.slurs_all)
		if(findtext(text, slur))
			record_featured_object_stat(FEATURED_STATS_SLURS, capitalize(slur))
			GLOB.vanderlin_round_stats[STATS_SLURS_SPOKEN]++
			if(!LAZYLEN(GLOB.slur_groups) || !dna?.species)
				continue
			if(is_string_in_list(slur, GLOB.slur_groups["Generic"]))
				continue
			if(is_string_in_list(slur, GLOB.slur_groups[dna.species.name]))
				continue
			record_featured_stat(FEATURED_STATS_SPECIESISTS, src)

/mob/living/say(message, bubble_type,list/spans = list(), sanitize = TRUE, datum/language/language = null, ignore_spam = FALSE, forced = null)
	var/static/list/crit_allowed_modes = list(MODE_WHISPER = TRUE, MODE_CHANGELING = TRUE, MODE_ALIEN = TRUE)
	var/static/list/unconscious_allowed_modes = list(MODE_CHANGELING = TRUE, MODE_ALIEN = TRUE)
	var/talk_key = get_key(message)

	var/static/list/one_character_prefix = list(MODE_HEADSET = TRUE, MODE_ROBOT = TRUE, MODE_WHISPER = TRUE, MODE_SING = TRUE)

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

	var/datum/saymode/saymode = SSradio.saymodes[talk_key]
	var/message_mode = get_message_mode(message)
	var/original_message = message
	var/in_critical = InCritical()

	if(one_character_prefix[message_mode])
		message = copytext(message, 2)
	else if(message_mode || saymode)
		message = copytext(message, 3)
	if(findtext(message, " ", 1, 2))
		message = copytext(message, 2)

	if(message_mode == MODE_ADMIN)
		if(client)
			client.cmd_admin_say(message)
		return

	if(message_mode == MODE_DEADMIN)
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

	if(in_critical)
		if(!(crit_allowed_modes[message_mode]))
			return
	else if(stat == UNCONSCIOUS)
		if(!(unconscious_allowed_modes[message_mode]))
			return

	// language comma detection.
	var/datum/language/message_language = get_message_language(message)
	if(message_language)
		// No, you cannot speak in xenocommon just because you know the key
		if(can_speak_in_language(message_language))
			language = message_language
		message = copytext(message, 3)

		// Trim the space if they said ",0 I LOVE LANGUAGES"
		if(findtext(message, " ", 1, 2))
			message = copytext(message, 2)

	if(!language)
		language = get_default_language()

	// Detection of language needs to be before inherent channels, because
	// AIs use inherent channels for the holopad. Most inherent channels
	// ignore the language argument however.

	if(saymode && !saymode.handle_message(src, message, language))
		return

	if(!can_speak_vocal(message))
//		visible_message("<b>[src]</b> makes a muffled noise.")
		to_chat(src, "<span class='warning'>I can't talk.</span>")
		return

	var/message_range = 7

	var/succumbed = FALSE

	var/fullcrit = InFullCritical()
	if((InCritical() && !fullcrit) || message_mode == MODE_WHISPER)
		message_range = 1
		message_mode = MODE_WHISPER
		src.log_talk("whispered: [message]", LOG_WHISPER)
		if(fullcrit)
			var/health_diff = round(-HEALTH_THRESHOLD_DEAD + health)
			// If we cut our message short, abruptly end it with a-..
			var/message_len = length(message)
			message = copytext(message, 1, health_diff) + "[message_len > health_diff ? "-.." : "..."]"
			message = Ellipsis(message, 10, 1)
			last_words = message
			message_mode = MODE_WHISPER_CRIT
			succumbed = TRUE
	else
		src.log_talk("said: [message]", LOG_SAY, forced_by=forced)

	message = treat_message(message) // unfortunately we still need this
	var/sigreturn = SEND_SIGNAL(src, COMSIG_MOB_SAY, args)
	if (sigreturn & COMPONENT_UPPERCASE_SPEECH)
		message = uppertext(message)
	if(!message)
		return

	if(client)
		record_featured_stat(FEATURED_STATS_SPEAKERS, src)
		INVOKE_ASYNC(src, PROC_REF(check_slur), message)
	if(findtext(message, "Abyssor"))
		GLOB.vanderlin_round_stats[STATS_ABYSSOR_REMEMBERED]++

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

	if(message_mode == MODE_SING)
		var/randomnote = pick("\u2669", "\u266A", "\u266B")
		message = "[randomnote] [message] [randomnote]"
		spans |= SPAN_SINGING

	var/radio_return = radio(message, message_mode, spans, language)
	if(radio_return & ITALICS)
		spans |= SPAN_ITALICS
	if(radio_return & REDUCE_RANGE)
		message_range = 1
	if(radio_return & NOPASS)
		return 1

	send_speech(message, message_range, src, bubble_type, spans, language, message_mode, original_message)

	if(succumbed)
		succumb(1)
		to_chat(src, compose_message(src, language, message, , spans, message_mode))

	return 1

/datum/species/proc/get_span_language(datum/language/message_language)
	if(!message_language)
		return
	return message_language.spans

// Whether the mob can see runechat from the speaker, assuming he will see his message on the text box
/mob/proc/can_see_runechat(atom/movable/speaker)
	if(!client || !client.prefs)
		return FALSE
	if(!client.prefs.chat_on_map)
		return FALSE
	if(stat >= UNCONSCIOUS)
		return FALSE
	if(!ismob(speaker) && !client.prefs.see_chat_non_mob)
		return FALSE
	return TRUE

/mob/living/Hear(message, atom/movable/speaker, datum/language/message_language, raw_message, radio_freq, list/spans, message_mode)
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
		create_chat_message(speaker, message_language, raw_message, spans, message_mode)
	// Recompose message for AI hrefs, language incomprehension.
	message = compose_message(speaker, message_language, raw_message, radio_freq, spans, message_mode)
	// voice muffling
	if(stat == UNCONSCIOUS)
		message = "<I>... You can almost hear something ...</I>"
	else
		if(isliving(speaker))
			var/mob/living/living_speaker = speaker
			if(living_speaker != src && living_speaker.client && src.can_hear()) //src.client already checked above
				log_message("heard [key_name(living_speaker)] say: [raw_message]", LOG_SAY, "#0978b8", FALSE)
	show_message(message, MSG_AUDIBLE, deaf_message, deaf_type)
	return message

/mob/living/send_speech(message, message_range = 6, obj/source = src, bubble_type = bubble_icon, list/spans, datum/language/message_language=null, message_mode, original_message)
	var/static/list/eavesdropping_modes = list(MODE_WHISPER = TRUE, MODE_WHISPER_CRIT = TRUE)
	var/eavesdrop_range = 0
	var/Zs_too = FALSE
	var/Zs_all = FALSE
	var/Zs_yell = FALSE
	var/listener_has_ceiling	= TRUE
	var/speaker_has_ceiling		= TRUE

	var/turf/speaker_turf = get_turf(src)
	var/turf/speaker_ceiling = get_step_multiz(speaker_turf, UP)
	if(speaker_ceiling)
		if(istransparentturf(speaker_ceiling))
			speaker_has_ceiling = FALSE
	if(eavesdropping_modes[message_mode])
		eavesdrop_range = EAVESDROP_EXTRA_RANGE
	if(message_mode != MODE_WHISPER)
		Zs_too = TRUE
		if(say_test(message) == "2")	//CIT CHANGE - ditto
			message_range += 5
			Zs_yell = TRUE
		if(say_test(message) == "3")	//Big "!!" shout
			message_range += 10
			Zs_all = TRUE
	var/list/listening = get_hearers_in_view(message_range+eavesdrop_range, source)
	var/list/the_dead = list()
//	var/list/yellareas	//CIT CHANGE - adds the ability for yelling to penetrate walls and echo throughout areas
	for(var/_M in GLOB.player_list)
		var/mob/M = _M
//		if(M.stat != DEAD) //not dead, not important
//			if(yellareas)	//CIT CHANGE - see above. makes yelling penetrate walls
//				var/area/A = get_area(M)	//CIT CHANGE - ditto
//				if(istype(A) && A.ambientsounds != SPACE && (A in yellareas))	//CIT CHANGE - ditto
//					listening |= M	//CIT CHANGE - ditto
//			continue
		if(!client) //client is so that ghosts don't have to listen to mice
			continue
		if(!M)
			continue
		if(!M.client)
			continue
		if(get_dist(M, src) > message_range) //they're out of range of normal hearing
			if(M.client.prefs)
				if(eavesdropping_modes[message_mode] && !(M.client.prefs.chat_toggles & CHAT_GHOSTWHISPER)) //they're whispering and we have hearing whispers at any range off
					continue
				if(!(M.client.prefs.chat_toggles & CHAT_GHOSTEARS)) //they're talking normally and we have hearing at any range off
					continue
		if(!is_in_zweb(src.z,M.z) && !(M.client.prefs.chat_toggles & CHAT_GHOSTEARS))
			continue
		listening |= M
		the_dead[M] = TRUE

	var/eavesdropping
	var/eavesrendered
	if(eavesdrop_range)
		eavesdropping = stars(message)
		eavesrendered = compose_message(src, message_language, eavesdropping, , spans, message_mode)

	var/rendered = compose_message(src, message_language, message, , spans, message_mode)
	for(var/_AM in listening)
		var/atom/movable/AM = _AM
		var/turf/listener_turf = get_turf(AM)
		var/turf/listener_ceiling = get_step_multiz(listener_turf, UP)
		if(listener_ceiling)
			listener_has_ceiling = TRUE
			if(istransparentturf(listener_ceiling))
				listener_has_ceiling = FALSE
		if((!Zs_too && !isobserver(AM)) || message_mode == MODE_WHISPER)
			if(AM.z != src.z)
				continue
		if(Zs_too && AM.z != src.z && !Zs_all)
			if(!Zs_yell)
				if(listener_turf.z < speaker_turf.z && listener_has_ceiling)	//Listener is below the speaker and has a ceiling above them
					continue
				if(listener_turf.z > speaker_turf.z && speaker_has_ceiling)		//Listener is above the speaker and the speaker has a ceiling above
					continue
				if(listener_has_ceiling && speaker_has_ceiling)	//Both have a ceiling, on different z-levels -- no hearing at all
					continue
			else
				if(abs((listener_turf.z - speaker_turf.z)) >= 2)	//We're yelling with only one "!", and the listener is 2 or more z levels above or below us.
					continue
			var/listener_obstructed = TRUE
			var/speaker_obstructed = TRUE
			if(src != AM && !Zs_yell)	//We always hear ourselves. Zs_yell will allow a "!" shout to bypass walls one z level up or below.
				if(!speaker_has_ceiling && isliving(AM))
					var/mob/living/M = AM
					for(var/mob/living/MH in viewers(world.view, speaker_ceiling))
						if(M == MH && MH.z == speaker_ceiling?.z)
							speaker_obstructed = FALSE

				if(!listener_has_ceiling)
					for(var/mob/living/ML in viewers(world.view, listener_ceiling))
						if(ML == src && ML.z == listener_ceiling?.z)
							listener_obstructed = FALSE
				if(listener_obstructed && speaker_obstructed)
					continue
		if(eavesdrop_range && get_dist(source, AM) > message_range && !(the_dead[AM]))
			AM.Hear(eavesrendered, src, message_language, eavesdropping, , spans, message_mode, original_message)
		else
			AM.Hear(rendered, src, message_language, message, , spans, message_mode, original_message)
	SEND_GLOBAL_SIGNAL(COMSIG_GLOB_LIVING_SAY_SPECIAL, src, message)

	//speech bubble
	var/list/speech_bubble_recipients = list()
	for(var/mob/M in listening)
		if(M.client?.prefs)
			if(M.client && !M.client.prefs.chat_on_map)
				speech_bubble_recipients.Add(M.client)
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
	if(HAS_TRAIT(src, TRAIT_MUTE))
		return FALSE

	if(is_muzzled())
		return FALSE

	if(!IsVocal())
		return FALSE

	return TRUE

/mob/living/proc/get_key(message)
	var/key = copytext(message, 1, 2)
	if(key in GLOB.department_radio_prefixes)
		return lowertext(copytext(message, 2, 3))

/mob/living/proc/get_message_language(message)
	if(copytext(message, 1, 2) == ",")
		var/key = copytext(message, 2, 3)
		for(var/ld in GLOB.all_languages)
			var/datum/language/LD = ld
			if(initial(LD.key) == key)
				return LD
	return null

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

/mob/living/proc/radio(message, message_mode, list/spans, language)
	switch(message_mode)
		if(MODE_WHISPER)
			return ITALICS
		if(MODE_R_HAND)
			for(var/obj/item/r_hand in get_held_items_for_side(RIGHT_HANDS, all = TRUE))
				if (r_hand)
					return r_hand.talk_into(src, message, , spans, language)
				return ITALICS | REDUCE_RANGE
		if(MODE_L_HAND)
			for(var/obj/item/l_hand in get_held_items_for_side(LEFT_HANDS, all = TRUE))
				if (l_hand)
					return l_hand.talk_into(src, message, , spans, language)
				return ITALICS | REDUCE_RANGE

		if(MODE_BINARY)
			return ITALICS | REDUCE_RANGE //Does not return 0 since this is only reached by humans, not borgs or AIs.

	return 0

/mob/living/say_mod(input, message_mode)
	if(message_mode == MODE_WHISPER)
		. = "whispers"
	else if(message_mode == MODE_WHISPER_CRIT)
		. = "whispers in [p_their()] last breath"
	else if(stuttering)
		. = "stammers"
	else if(derpspeech)
		. = "gibbers"
	else if(message_mode == MODE_SING)
		. = "sings"
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
