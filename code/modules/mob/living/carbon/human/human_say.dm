/mob/living/carbon/human/say_mod(input, list/message_mods = list())
	verb_say = dna.species.say_mod
	if(slurring)
		return "slurs"
	else
		. = ..()

/mob/living/carbon/human/GetVoice()
	if(GetSpecialVoice())
		return GetSpecialVoice()
	return real_name

/mob/living/carbon/human/IsVocal()
	// how do species that don't breathe talk? magic, that's what.
	if(!HAS_TRAIT_FROM(src, TRAIT_NOBREATH, SPECIES_TRAIT) && !getorganslot(ORGAN_SLOT_LUNGS))
		return FALSE
	if(mind)
		return !mind.miming
	return TRUE

/mob/living/carbon/human/proc/SetSpecialVoice(new_voice)
	if(new_voice)
		special_voice = new_voice
	return

/mob/living/carbon/human/proc/UnsetSpecialVoice()
	special_voice = ""
	return

/mob/living/carbon/human/proc/GetSpecialVoice()
	return special_voice

/mob/living/carbon/human/get_alt_name()
	if(name != GetVoice())
		// This isn't accurate purposely
		var/appendage = "Figure"
		switch(client?.prefs.voice_type)
			if(VOICE_TYPE_FEM)
				appendage = "Woman"
			if(VOICE_TYPE_MASC)
				appendage = "Man"
		return "Unknown [appendage]"

/mob/living/carbon/human/proc/forcesay(list/append) //this proc is at the bottom of the file because quote fuckery makes notepad++ cri
	if(stat == CONSCIOUS)
		if(client)
			var/virgin = 1	//has the text been modified yet?
			var/temp = winget(client, "input", "text")
			if(findtextEx(temp, "Say \"", 1, 7) && length(temp) > 5)	//"case sensitive means

				temp = replacetext(temp, ";", "")	//general radio

				if(findtext(trim_left(temp), ":", 6, 7))	//dept radio
					temp = copytext(trim_left(temp), 8)
					virgin = 0

				if(virgin)
					temp = copytext(trim_left(temp), 6)	//normal speech
					virgin = 0

				while(findtext(trim_left(temp), ":", 1, 2))	//dept radio again (necessary)
					temp = copytext(trim_left(temp), 3)

				if(findtext(temp, "*", 1, 2))	//emotes
					return

				var/trimmed = trim_left(temp)
				if(length(trimmed))
					if(append)
						temp += pick(append)

					say(temp)
				winset(client, "input", "text=[null]")

/mob/living/carbon/human/send_speech(message, message_range = 6, obj/source = src, bubble_type = bubble_icon, list/spans, datum/language/message_language=null, list/message_mods = list(), original_message)
	. = ..()
	if(!message_mods[WHISPER_MODE])
		send_voice(message)

/mob/living/carbon/human/proc/send_voice(message, skip_thingy)
	if(!length(message))
		return
	if(dna.species)
		dna.species.send_voice(src)

/datum/species/proc/send_voice(mob/living/carbon/human/H)
	playsound(get_turf(H), 'sound/misc/talk.ogg', 100, FALSE, -1)
