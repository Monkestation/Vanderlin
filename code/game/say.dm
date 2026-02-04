/*
	Miauw's big Say() rewrite.
	This file has the basic atom/movable level speech procs.
	And the base of the send_speech() proc, which is the core of saycode.
*/
/atom/movable/proc/say(message, bubble_type, list/spans = list(), sanitize = TRUE, datum/language/language = null, ignore_spam = FALSE, forced = null)
	if(!can_speak())
		return
	if(message == "" || !message)
		return
	spans |= speech_span
	if(!language)
		language = get_default_language()
	send_speech(message, 7, src, null, spans, message_language = language)

/atom/movable/proc/Hear(message, atom/movable/speaker, datum/language/message_language, raw_message, radio_freq, list/spans, list/message_mods = list(), original_message)
	SEND_SIGNAL(src, COMSIG_MOVABLE_HEAR, args)

/atom/movable/proc/can_speak()
	return TRUE

/atom/movable/proc/send_speech(message, range = 7, obj/source = src, bubble_type, list/spans, datum/language/message_language = null, list/message_mods = list(), original_message)
	var/rendered = compose_message(src, message_language, message, , spans, message_mods)
	for(var/atom/movable/hearing_movable as anything in get_hearers_in_view(range, source))
		if(!hearing_movable) // theoretically this should use as anything because it shouldnt be able to get nulls but there are reports that it does.
			stack_trace("somehow there's a null returned from get_hearers_in_view() in send_speech!")
			continue
		hearing_movable.Hear(rendered, src, message_language, message, , spans, message_mods, original_message)
/atom/movable/proc/compose_message(atom/movable/speaker, datum/language/message_language, raw_message, radio_freq, list/spans, list/message_mods = list(), face_name = FALSE)
	//This proc uses text() because it is faster than appending strings. Thanks BYOND.
	//Basic span
	var/spanpart1 = "<span class='[radio_freq ? "radio" : "say"]'>"
	//Start name span.
	var/spanpart2 = "<span class='name'>"
	//Radio freq/name display
	var/freqpart = radio_freq ? "\[[get_radio_name(radio_freq)]__~~\]~~__ " : ""
	//Speaker name
	var/namepart = "[speaker.GetVoice()]"
	if(speaker.get_alt_name())
		namepart = "[speaker.get_alt_name()]"
	var/colorpart = "<span style='text-shadow:-1px -1px 0 #000,1px -1px 0 #000,-1px 1px 0 #000,1px 1px 0 #000;'>"
	if(ishuman(speaker))
		var/mob/living/carbon/human/H = speaker
		if(face_name)
			namepart = "[H.get_face_name()]" //So "fake" speaking like in hallucinations does not give the speaker away if disguised
		if(H.voice_color)
			colorpart = "<span style='color:#[H.voice_color];text-shadow:-1px -1px 0 #000,1px -1px 0 #000,-1px 1px 0 #000,1px 1px 0 #000;'>"
	if(speaker.voicecolor_override)
		colorpart = "<span style='color:#[speaker.voicecolor_override];text-shadow:-1px -1px 0 #000,1px -1px 0 #000,-1px 1px 0 #000,1px 1px 0 #000;'>"
	//End name span.
	var/endspanpart = "</span></span>"

	//Message - handle deaf trait
	var/messagepart = raw_message
	if(isliving(src) && HAS_TRAIT(src, TRAIT_PARTIAL_DEAF) && speaker != src)
		var/mob/living/listener = src
		var/distance = get_dist(listener, speaker)
		var/is_yelling = ((SPAN_YELL in spans) || message_mods[MODE_SING])

		if(distance > 2 && !is_yelling)
			// Jumble the message for deaf people beyond 2 tiles
			messagepart = jumble_message(raw_message)
		else if(distance > 2 && is_yelling)
			// Yelling can be heard but still somewhat muffled
			messagepart = "[lang_treat(speaker, message_language, raw_message, spans, message_mods)]"
		else
			// Within 2 tiles, can hear normally
			messagepart = "[lang_treat(speaker, message_language, raw_message, spans, message_mods)]"
	else
		messagepart = "[lang_treat(speaker, message_language, raw_message, spans, message_mods)]"

	messagepart = " <span class='message'>[messagepart]</span></span>"

	//Arrow
	var/arrowpart = ""
	if(istype(src,/mob/living))
		var/turf/speakturf = get_turf(speaker)
		var/turf/sourceturf = get_turf(src)
		if(istype(speakturf) && istype(sourceturf) && !(speakturf in get_hear(7, sourceturf)))
			switch(get_dir(src,speaker))
				if(NORTH)
					arrowpart = " ⇑"
				if(SOUTH)
					arrowpart = " ⇓"
				if(EAST)
					arrowpart = " ⇒"
				if(WEST)
					arrowpart = " ⇐"
				if(NORTHWEST)
					arrowpart = " ⇖"
				if(NORTHEAST)
					arrowpart = " ⇗"
				if(SOUTHWEST)
					arrowpart = " ⇙"
				if(SOUTHEAST)
					arrowpart = " ⇘"
			if(speakturf.z > sourceturf.z)
				arrowpart += " ⇈"
			if(speakturf.z < sourceturf.z)
				arrowpart += " ⇊"
			if(!HAS_TRAIT(src, TRAIT_KEENEARS))
				if(istype(speaker, /mob/living))
					var/mob/living/L = speaker
					// This isn't accurate purposely
					var/appendage = "Figure"
					switch(L.client?.prefs.voice_type)
						if(VOICE_TYPE_FEM)
							appendage = "Woman"
						if(VOICE_TYPE_MASC)
							appendage = "Man"
					namepart = "Unknown [appendage]"
				else
					namepart = "Unknown"
			spanpart1 = "<span class='smallyell'>"
	var/languageicon = ""
	var/datum/language/D = GLOB.language_datum_instances[message_language]
	if(istype(D) && D.display_icon(src))
		languageicon = "[D.get_icon()] "
	return "[spanpart1][spanpart2][colorpart][freqpart][languageicon][compose_track_href(speaker, namepart)][namepart][compose_job(speaker, message_language, raw_message, radio_freq)][arrowpart][endspanpart][messagepart]"

/proc/jumble_message(message)
	var/list/words = splittext(message, " ")
	var/list/jumbled_words = list()

	for(var/word in words)
		if(length(word) <= 2)
			jumbled_words += word
			continue

		// Keep first and last letter, jumble the middle
		var/first = copytext(word, 1, 2)
		var/last = copytext(word, length(word), length(word) + 1)
		var/middle = copytext(word, 2, length(word))

		if(length(middle) > 0)
			var/list/middle_chars = splittext(middle, "")
			middle_chars = shuffle(middle_chars)
			middle = jointext(middle_chars, "")

		jumbled_words += "[first][middle][last]"

	return jointext(jumbled_words, " ")

/atom/movable/proc/compose_track_href(atom/movable/speaker, message_langs, raw_message, radio_freq)
	return ""

/atom/movable/proc/compose_job(atom/movable/speaker, message_langs, raw_message, radio_freq)
	return ""

/atom/movable/proc/say_mod(input, list/message_mods = list())
	var/ending = copytext_char(input, -1)
	if(copytext_char(input, -2) == "!!")
		return verb_yell
	else if(message_mods[MODE_SING])
		return verb_sing
	else if(ending == "?")
		return verb_ask
	else if(ending == "!")
		return verb_exclaim
	else
		return verb_say

/atom/movable/proc/say_quote(input, list/spans=list(speech_span), list/message_mods = list())
	if(!input)
		input = "..."

	var/say_mod

	var/mob/living/living_speaker = src
	if(istype(living_speaker) && living_speaker.cmode)
		say_mod = "—"
	else
		say_mod = say_mod(input, message_mods)
		say_mod = "[say_mod]," //acknowledge the comma

	if(copytext(input, length(input) - 1) == "!!")
		spans |= SPAN_YELL

	input = parsemarkdown_basic(input, limited = TRUE, barebones = TRUE)
	/* all inputs should be fully figured out past this point */

	var/processed_input = attach_spans(input, spans)

	var/processed_say_mod = attach_spans(say_mod, spans) // port custom emotes one day?

	return "[processed_say_mod] \"[processed_input]\""

/atom/movable/proc/quoteless_say_quote(input, list/spans = list(speech_span), list/message_mods = list()) //what the fuck.
	input = parsemarkdown_basic(input, limited = TRUE, barebones = TRUE)
	var/pos = findtext(input, "*")
	return pos ? copytext(input, pos + 1) : input

/atom/movable/proc/check_language_hear(language)
	return FALSE

/atom/movable/proc/lang_treat(atom/movable/speaker, datum/language/language, raw_message, list/spans, list/message_mods = list(), no_quote = FALSE)
	var/atom/movable/source = speaker.GetSource() || speaker //is the speaker virtual
	if(has_language(language) || check_language_hear(language))
		return no_quote ? source.quoteless_say_quote(raw_message, spans, message_mods) : source.say_quote(raw_message, spans, message_mods)
	else if(language)
		var/datum/language/D = GLOB.language_datum_instances[language]
		raw_message = D.scramble_sentence(raw_message, get_partially_understood_languages())
		return no_quote ? source.quoteless_say_quote(raw_message, spans, message_mods) : source.say_quote(raw_message, spans, message_mods)
	else
		return "makes a strange sound."

/proc/get_radio_name(freq)
	return freq
/* 	var/returntext = GLOB.reverseradiochannels["[freq]"]
	if(returntext)
		return returntext
	return "[copytext("[freq]", 1, 4)].[copytext("[freq]", 4, 5)]" */

/proc/attach_spans(input, list/spans)
	return "[message_spans_start(spans)][input]</span>"

/proc/message_spans_start(list/spans)
	var/output = "<span class='"
	for(var/S in spans)
		output = "[output][S] "
	output = "[output]'>"
	return output

/proc/say_test(text)
	. = "0"
	var/ending = copytext_char(text, -1)
	if(copytext_char(text, -2) == "!!")
		. = "3"
	else if(ending == "!")
		. = "2"
	else if(ending == "?")
		. = "1"

/atom/movable/proc/GetVoice()
	return "[src]"	//Returns the atom's name, prepended with 'The' if it's not a proper noun

/atom/movable/proc/IsVocal()
	return 1

/atom/movable/proc/get_alt_name()

//HACKY VIRTUALSPEAKER STUFF BEYOND THIS POINT
//these exist mostly to deal with the AIs hrefs and job stuff.

/atom/movable/proc/GetJob() //Get a job, you lazy butte

/atom/movable/proc/GetSource()

/atom/movable/proc/GetRadio()

//VIRTUALSPEAKERS
/atom/movable/virtualspeaker
	var/job
	var/atom/movable/source
	var/obj/item/radio/radio

INITIALIZE_IMMEDIATE(/atom/movable/virtualspeaker)
/atom/movable/virtualspeaker/Initialize(mapload, atom/movable/M, radio)
	. = ..()
	radio = radio
	source = M
	if (istype(M))
		name = M.GetVoice()
		verb_say = M.verb_say
		verb_ask = M.verb_ask
		verb_exclaim = M.verb_exclaim
		verb_yell = M.verb_yell

	// The mob's job identity
	if(ishuman(M))
		// Humans use their job as seen on the crew manifest. This is so the AI
		// can know their job even if they don't carry an ID.
		var/datum/data/record/findjob = find_record("name", name, GLOB.data_core.general)
		if(findjob)
			job = findjob.fields["rank"]
		else
			job = "Unknown"
	else if(iscarbon(M))  // Carbon nonhuman
		job = "No ID"
	else if(isobj(M))  // Cold, emotionless machines
		job = "Machine"
	else  // Unidentifiable mob
		job = "Unknown"

/atom/movable/virtualspeaker/GetJob()
	return job

/atom/movable/virtualspeaker/GetSource()
	return source

