/mob/dead/observer/check_emote(message, forced)
	return emote(copytext(message, length(message[1]) + 1), intentional = !forced, force_silence = TRUE)

//Modified version of get_message_mods, removes the trimming, the only thing we care about here is admin channels
/mob/dead/observer/get_message_mods(message, list/mods)
	var/key = message[1]
	if((key in GLOB.department_radio_prefixes) && length(message) > length(key) + 1 && !mods[RADIO_EXTENSION])
		mods[RADIO_KEY] = lowertext(message[1 + length(key)])
		mods[RADIO_EXTENSION] = GLOB.department_radio_keys[mods[RADIO_KEY]]
	return message

/mob/dead/observer/say(message, bubble_type, list/spans = list(), sanitize = TRUE, datum/language/language = null, ignore_spam = FALSE, forced = null)
	message = trim(copytext(sanitize(message), 1, MAX_MESSAGE_LEN))
	if(!message)
		return

	var/list/message_mods = list()
	message = get_message_mods(message, message_mods)
	if(client && (message_mods[RADIO_EXTENSION] == MODE_ADMIN || message_mods[RADIO_EXTENSION] == MODE_DEADMIN))
		message = trim_left(copytext_char(message, length(message_mods[RADIO_KEY]) + 2))
		if(message_mods[RADIO_EXTENSION] == MODE_ADMIN)
			client.cmd_admin_say(message)
		else if(message_mods[RADIO_EXTENSION] == MODE_DEADMIN)
			client.dsay(message)
		return

	if(check_emote(message, forced))
		return

	. = say_dead(message)

/mob/dead/observer/rogue/arcaneeye/say(message, bubble_type, list/spans = list(), sanitize = TRUE, datum/language/language = null, ignore_spam = FALSE, forced = null)
	return

/mob/dead/observer/rogue/arcaneeye/say_dead(message)
	return

/mob/dead/observer/screye/say(message, bubble_type, list/spans = list(), sanitize = TRUE, datum/language/language = null, ignore_spam = FALSE, forced = null)
	return

/mob/dead/observer/screye/say_dead(message)
	return

/mob/dead/observer/profane/say(message, bubble_type, list/spans = list(), sanitize = TRUE, datum/language/language = null, ignore_spam = FALSE, forced = null)
	if (!message)
		return

	if (client)
		if(client.prefs.muted & MUTE_IC)
			to_chat(src, "<span class='boldwarning'>I cannot send IC messages (muted).</span>")
			return
		if (!(ignore_spam || forced) && src.client.handle_spam_prevention(message,MUTE_IC))
			return

	message = capitalize(trim(copytext(sanitize(message), 1, MAX_MESSAGE_LEN)))
	var/rendered = "<span class='say'><span class='name'>[name]</span> <span class='message'>[say_quote(message)]</span></span>"

	visible_message(message = rendered, self_message = FALSE, blind_message = rendered, vision_distance = 0)

/mob/dead/observer/Hear(message, atom/movable/speaker, message_language, raw_message, radio_freq, list/spans, list/message_mods = list(), original_message)
	. = ..()
	var/atom/movable/to_follow = speaker
	var/link = FOLLOW_LINK(src, to_follow)
	if(client?.prefs)
		if(!(client?.prefs.toggles_maptext & DISABLE_RUNECHAT) && (client.prefs.see_chat_non_mob || ismob(speaker)))
			create_chat_message(speaker, message_language, raw_message, spans)
	// Recompose the message, because it's scrambled by default
	message = compose_message(speaker, message_language, raw_message, radio_freq, spans, message_mods)
	if(IsAdminGhost(src))
		to_chat(src, "[link] [message]")
	else
		to_chat(src, "[message]")
