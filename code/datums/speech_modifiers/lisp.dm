//Lisp caused by lack of teeth
/datum/speech_modifier/lisp
	var/lisp_power = 0

/datum/speech_modifier/lisp/add_speech_modifier(mob/living/carbon/new_owner)
	. = ..()
	update_lisp()

/datum/speech_modifier/lisp/handle_speech(datum/source, list/speech_args)
	update_lisp()
	if(QDELETED(src))
		return
	var/message = speech_args[SPEECH_MESSAGE]
	if(message[1] != "*")
		message = prob(lisp_power) ? replacetext(message, "f", "ph") : message
		message = prob(lisp_power) ? replacetext(message, "t", "ph") : message
		message = prob(lisp_power) ? replacetext(message, "s", "sh") : message
		message = prob(lisp_power) ? replacetext(message, "th", "hh") : message
		message = prob(lisp_power) ? replacetext(message, "ck", "gh") : message
		message = prob(lisp_power) ? replacetext(message, "c", "gh") : message
		message = prob(lisp_power) ? replacetext(message, "k", "gh") : message
	speech_args[SPEECH_MESSAGE] = message

/datum/speech_modifier/lisp/proc/update_lisp()
	var/obj/item/bodypart/mouth/jaw = affected_mob?.get_bodypart(BODY_ZONE_PRECISE_MOUTH)
	if(istype(jaw))
		lisp_power = (1 - jaw.get_teeth_amount()/jaw.max_teeth) * 100
	else
		lisp_power = 100
	//Remove if we have teeth (aka stopped being british)
	if(!lisp_power || (jaw.get_teeth_amount() >= jaw.max_teeth))
		remove_speech_modifier()
