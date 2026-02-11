//Speech verbs.


/mob/verb/say_verb(message as text)
	set name = "Say"
	set category = "IC.Speech"
	set hidden = 1

	if(!message)
		message = input(usr, "", "say") as text|null
	// If they don't type anything just drop the message.
	set_typing_indicator(FALSE)
	if(!length(message))
		return
	if(GLOB.say_disabled)	//This is here to try to identify lag problems
		to_chat(usr, "<span class='danger'>Speech is currently admin-disabled.</span>")
		return
	if(message)
		set_typing_indicator(FALSE)
		say(message)

///Whisper verb
/mob/verb/whisper_verb(message as text)
	set name = "Whisper"
	set category = "IC.Speech"
	set hidden = 1

	if(GLOB.say_disabled)	//This is here to try to identify lag problems
		to_chat(usr, "<span class='danger'>Speech is currently admin-disabled.</span>")
		return
	whisper(message)

///whisper a message
/mob/proc/whisper(message, bubble_type, list/spans = list(), sanitize = TRUE, datum/language/language = null, ignore_spam = FALSE, forced = null)
	say(message, bubble_type, spans, sanitize, language, ignore_spam, forced) //only living mobs actually whisper, everything else just talks

///The me emote verb
/mob/verb/me_verb(message as text)
	set name = "Me"
	set category = "IC.Speech"
	set hidden = 1

	#ifdef USES_PQ
	if(client)
		if(get_playerquality(client.ckey) <= -20)
			to_chat(usr, "<span class='warning'>I can't use custom emotes. (LOW PQ)</span>")
			return
		#endif
	if(!message)
		message = input(usr, "", "me") as text|null
	// If they don't type anything just drop the message.
	set_typing_indicator(FALSE)
	if(!length(message))
		return
	if(GLOB.say_disabled)	//This is here to try to identify lag problems
		to_chat(usr, "<span class='danger'>Speech is currently admin-disabled.</span>")
		return
	message = trim(copytext_char(sanitize(message), 1, MAX_MESSAGE_LEN))
	message = parsemarkdown_basic(message, limited = TRUE, barebones = TRUE)
	usr.emote("me",1,message,TRUE, custom_me = TRUE)

///The big me emote verb
/mob/verb/me_big_verb()
	set name = "Me(Big)"
	set category = "IC.Speech"
	set hidden = TRUE

	#ifdef USES_PQ
	if(client)
		if(get_playerquality(client.ckey) <= -20)
			to_chat(usr, "<span class='warning'>I can't use custom emotes. (LOW PQ)</span>")
			return
		#endif
	var/message = input(usr, "", "me") as message|null
	// If they don't type anything just drop the message.
	set_typing_indicator(FALSE)
	if(!length(message))
		return
	if(GLOB.say_disabled)	//This is here to try to identify lag problems
		to_chat(usr, "<span class='danger'>Speech is currently admin-disabled.</span>")
		return
	message = trim(copytext_char(html_encode(message), 1, MAX_MESSAGE_BIGME))
	message = parsemarkdown_basic(message, limited = TRUE, barebones = TRUE)
	usr.emote("me", 1, message, TRUE, custom_me = TRUE)

///Speak as a dead person (ghost etc)
/mob/proc/say_dead(message)
	return
/*
	var/name = real_name
	var/alt_name = ""

	if(GLOB.say_disabled)	//This is here to try to identify lag problems
		to_chat(usr, "<span class='danger'>Speech is currently admin-disabled.</span>")
		return

	var/jb = is_banned_from(ckey, "Deadchat")
	if(QDELETED(src))
		return

	if(jb)
		to_chat(src, "<span class='danger'>I have been banned from deadchat.</span>")
		return



	if (src.client)
		if(src.client.prefs.muted & MUTE_DEADCHAT)
			to_chat(src, "<span class='danger'>I cannot talk in deadchat (muted).</span>")
			return

		if(src.client.handle_spam_prevention(message,MUTE_DEADCHAT))
			return

	var/mob/dead/observer/O = src
	if(isobserver(src) && O.deadchat_name)
		name = "[O.deadchat_name]"
	else
		if(mind && mind.name)
			name = "[mind.name]"
		else
			name = real_name
		if(name != real_name)
			alt_name = " (died as [real_name])"

	var/spanned = say_quote(message)
	var/source = "<span class='game'><span class='prefix'>DEAD:</span> <span class='name'>[name]</span>[alt_name]"
	var/rendered = " <span class='message'>[emoji_parse(spanned)]</span></span>"
	log_talk(message, LOG_SAY, tag="DEAD")
	if(SEND_SIGNAL(src, COMSIG_MOB_DEADSAY, message) & MOB_DEADSAY_SIGNAL_INTERCEPT)
		return
	deadchat_broadcast(rendered, source, follow_target = src, speaker_key = key)
*/

///Check if this message is an emote
/mob/proc/check_emote(message, forced)
	if(copytext(message, 1, 2) == "*")
		emote(copytext_char(message, 2), intentional = !forced, custom_me = TRUE)
		return 1

/mob/proc/check_whisper(message, forced)
	if(copytext(message, 1, 2) == "+")
		var/text = copytext(message, 2)
		var/boldcheck = findtext_char(text, "+")	//Check for a *second* + in the text, implying the message is meant to have something formatted as bold (+text+)
		whisper(copytext_char(message, boldcheck ? 1 : 2),sanitize = FALSE)//already sani'd
		return 1
/* commenting out subtler
/mob/proc/check_subtler(message, forced)
	if(copytext_char(message, 1, 2) == "@")
		emote("subtle", message = copytext_char(message, 2), intentional = !forced)
		return 1
*/
///Check if the mob has a hivemind channel
/mob/proc/hivecheck()
	return 0

///Check if the mob has a ling hivemind
/mob/proc/lingcheck()
	return LINGHIVE_NONE

///The amount of items we are looking for in the message
#define MESSAGE_MODS_LENGTH 6
/**
 * Extracts and cleans message of any extenstions at the begining of the message
 * Inserts the info into the passed list, returns the cleaned message
 *
 * Result can be
 * * SAY_MODE (Things like aliens, channels that aren't channels)
 * * MODE_WHISPER (Quiet speech)
 * * MODE_SING (Singing)
 * * MODE_HEADSET (Common radio channel)
 * * RADIO_EXTENSION the extension we're using (lots of values here)
 * * RADIO_KEY the radio key we're using, to make some things easier later (lots of values here)
 * * LANGUAGE_EXTENSION the language we're trying to use (lots of values here)
 */
/mob/proc/get_message_mods(message, list/mods)
	for(var/I in 1 to MESSAGE_MODS_LENGTH)
		var/key = message[1]
		var/chop_to = 2 //By default we just take off the first char
		if(key == "#" && !mods[WHISPER_MODE])
			mods[WHISPER_MODE] = MODE_WHISPER
		else if(key == "%" && !mods[MODE_SING])
			mods[MODE_SING] = TRUE
		else if(key == ";" && !mods[MODE_HEADSET])
			mods[MODE_HEADSET] = TRUE
		else if((key in GLOB.department_radio_prefixes) && length(message) > length(key) + 1 && !mods[RADIO_EXTENSION])
			mods[RADIO_KEY] = lowertext(message[1 + length(key)])
			mods[RADIO_EXTENSION] = GLOB.department_radio_keys[mods[RADIO_KEY]]
			chop_to = length(key) + 2
		else if(key == "," && !mods[LANGUAGE_EXTENSION])
			for(var/datum/language/LD as anything in GLOB.all_languages)
				if(initial(LD.key) == lowertext(message[1 + length(message[1])]))
					if(!can_speak_in_language(LD))
						return message
					mods[LANGUAGE_EXTENSION] = LD
					chop_to = length(key) + length(initial(LD.key)) + 1
			if(!mods[LANGUAGE_EXTENSION])
				return message
		else
			return message
		message = trim_left(copytext_char(message, chop_to))
		if(!message)
			return
	return message

#undef MESSAGE_MODS_LENGTH
