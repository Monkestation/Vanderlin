// weird proc, but this is so Replace() doesn't use the same sound for the whole message
/proc/make_tongueless_noise(char)
	// we know char will always be alphanumeric so we can do a faster check than is_uppercase_character
	// you can take my premature optimization from my cold dead hands
	return text2ascii(char) <= 90 ? pick("AA", "OO", "'") : pick("aa", "oo", "'")

/mob/living/carbon/proc/handle_tongueless_speech(mob/living/carbon/speaker, list/speech_args)
	var/message = speech_args[SPEECH_MESSAGE]
	var/datum/language/lang = speech_args[SPEECH_LANGUAGE]

	if(lang && (lang.flags & SIGNLANG))
		return

	// velar stop (k, g), dental stop (t, d), postalveolar nasal (n)
	// and close vowels (e) are forbidden. technically u and o should be
	// forbidden as well, but that wasn't done here for some reason
	var/static/regex/needs_tongue = new(@"[gdntke]+", "gi")
	if(message[1] != "*")
		message = needs_tongue.Replace(message, GLOBAL_PROC_REF(make_tongueless_noise))
		speech_args[SPEECH_MESSAGE] = message

/mob/living/carbon/could_speak_in_language(datum/language/dt)
	var/obj/item/organ/tongue/T = getorganslot(ORGAN_SLOT_TONGUE)
	if(T)
		. = T.could_speak_in_language(dt)
	else
		. = !(initial(dt.flags) & TONGUE_REQUIRED)
