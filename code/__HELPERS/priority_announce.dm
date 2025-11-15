/**
 * Make a big red text announcement to
 *
 * Formatted like:
 *
 * " Message from sender "
 *
 * " Title "
 *
 * " Text "
 *
 * Arguments
 * * text - required, the text to announce
 * * title - optional, the title of the announcement.
 * * sound - optional, the sound played accompanying the announcement
 * * type - optional, the type of the announcement, for some "preset" announcement templates. "Priority", "Captain", "Syndicate Captain"
 * * sender_override - optional, modifies the sender of the announcement
 * * players - a list of all players to send the message to. defaults to all players (not including new players)
 * * encode_title - if TRUE, the title will be HTML encoded
 * * encode_text - if TRUE, the text will be HTML encoded
 */
/proc/priority_announce(text, title = "", sound, type, sender_override, list/mob/players, encode_title = TRUE, encode_text = TRUE)
	if(!text)
		return

	if(encode_title && title && length(title) > 0)
		title = html_encode(title)
	if(encode_text)
		text = html_encode(text)
		if(!length(text))
			return

	var/announcement = "<br><div class='alert_holder'>"

	if(title && length(title) > 0)
		announcement += "<h1 class='alert'><center><u>[title]</u></h1></center>"
	announcement += "<center>[span_alert(text)]</center><br></div>"

	if(!players)
		players = GLOB.player_list

	var/sound_to_play = sound(sound)
	for(var/mob/target in players)
		if(!isnewplayer(target) && target.can_hear())
			to_chat(target, announcement)
			if((target.client.prefs.toggles & SOUND_ANNOUNCEMENTS) && sound_to_play)
				target.playsound_local(target, sound_to_play, 100)

/proc/minor_announce(message, title = "", alert, html_encode = TRUE, list/mob/players)
	if(!message)
		return

	if(html_encode)
		title = html_encode(title)
		message = html_encode(message)

	if(!players)
		players = GLOB.player_list

	for(var/mob/target in players)
		if(!isnewplayer(target) && target.can_hear())
			to_chat(target, "[span_minorannounce("<font color = purple>[title]</font color><BR>[message]")]<BR>")
			if(target.client.prefs.toggles & SOUND_ANNOUNCEMENTS)
				target.playsound_local(target, 'sound/misc/alert.ogg', 100)

/proc/bordered_message(mob/target, list/messages)
	var/html = "<br><div class='alert_holder'>"
	for(var/msg in messages)
		html += "[msg]<br>"
	html += "</div><br>"
	to_chat(target, html)
