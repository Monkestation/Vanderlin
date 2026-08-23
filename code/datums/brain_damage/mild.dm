//Mild traumas are the most common; they are generally minor annoyances.
//They can be cured with mannitol and patience, although brain surgery still works.
//Most of the old brain damage effects have been transferred to the dumbness trauma.

/datum/brain_trauma/mild

/datum/brain_trauma/mild/stuttering
	name = "Stuttering"
	desc = ""
	scan_desc = ""
	gain_text = span_warning("Speaking clearly is getting harder.")
	lose_text = span_notice("I feel in control of my speech.")

/datum/brain_trauma/mild/stuttering/on_life()
	owner.stuttering = min(owner.stuttering + 5, 25)
	..()

/datum/brain_trauma/mild/stuttering/on_lose()
	owner.stuttering = 0
	..()

/datum/brain_trauma/mild/dumbness
	name = "Dumbness"
	desc = ""
	scan_desc = ""
	gain_text = span_warning("I feel dumber.")
	lose_text = span_notice("I feel smart again.")

/datum/brain_trauma/mild/dumbness/on_gain()
	ADD_TRAIT(owner, TRAIT_DUMB, TRAUMA_TRAIT)
	..()

/datum/brain_trauma/mild/dumbness/on_life()
	owner.derpspeech = min(owner.derpspeech + 5, 25)
	if(prob(3))
		owner.emote("drool")
	// else if(owner.stat == CONSCIOUS && prob(3))
	// 	owner.say(pick_list_replacements(BRAIN_DAMAGE_FILE, "brain_damage"), forced = "brain damage")
	..()

/datum/brain_trauma/mild/dumbness/on_lose()
	REMOVE_TRAIT(owner, TRAIT_DUMB, TRAUMA_TRAIT)
	owner.derpspeech = 0
	..()

/datum/brain_trauma/mild/speech_impediment
	name = "Speech Impediment"
	desc = ""
	scan_desc = ""
	gain_text = span_danger("I can't seem to form any coherent thoughts!")
	lose_text = span_danger("My mind feels more clear.")

/datum/brain_trauma/mild/speech_impediment/on_gain()
	ADD_TRAIT(owner, TRAIT_UNINTELLIGIBLE_SPEECH, TRAUMA_TRAIT)
	..()

/datum/brain_trauma/mild/speech_impediment/on_lose()
	REMOVE_TRAIT(owner, TRAIT_UNINTELLIGIBLE_SPEECH, TRAUMA_TRAIT)
	..()

/datum/brain_trauma/mild/concussion
	name = "Concussion"
	desc = ""
	scan_desc = ""
	gain_text = span_warning("My head hurts!")
	lose_text = span_notice("The pressure inside my head starts fading.")

/datum/brain_trauma/mild/concussion/on_life()
	if(prob(5))
		switch(rand(1,11))
			if(1)
				owner.vomit()
			if(2,3)
				owner.adjust_dizzy(10 SECONDS)
			if(4,5)
				owner.adjust_confusion(10 SECONDS)
				owner.set_eye_blur_if_lower(20 SECONDS)
			if(6 to 9)
				owner.slurring += 30
			if(10)
				to_chat(owner, span_notice("I forget for a moment what you were doing."))
				owner.Stun(20)
			if(11)
				to_chat(owner, span_warning("I faint."))
				owner.Unconscious(80)

	..()

/datum/brain_trauma/mild/muscle_weakness
	name = "Muscle Weakness"
	desc = ""
	scan_desc = ""
	gain_text = span_warning("My muscles feel oddly faint.")
	lose_text = span_notice("I feel in control of my muscles again.")

/datum/brain_trauma/mild/muscle_weakness/on_life()
	var/fall_chance = 1
	if(owner.m_intent == MOVE_INTENT_RUN)
		fall_chance += 2
	if(prob(fall_chance) && (owner.body_position != LYING_DOWN))
		to_chat(owner, span_warning("My leg gives out!"))
		owner.Paralyze(35)

	else if(owner.get_active_held_item())
		var/drop_chance = 1
		var/obj/item/I = owner.get_active_held_item()
		drop_chance += I.w_class
		if(prob(drop_chance) && owner.dropItemToGround(I))
			to_chat(owner, span_warning("I drop [I]!"))

	else if(prob(3))
		to_chat(owner, span_warning("I feel a sudden weakness in my muscles!"))
	..()

/datum/brain_trauma/mild/muscle_spasms
	name = "Muscle Spasms"
	desc = ""
	scan_desc = ""
	gain_text = span_warning("My muscles feel oddly faint.")
	lose_text = span_notice("I feel in control of my muscles again.")

/datum/brain_trauma/mild/muscle_spasms/on_gain()
	owner.apply_status_effect(STATUS_EFFECT_SPASMS)
	..()

/datum/brain_trauma/mild/muscle_spasms/on_lose()
	owner.remove_status_effect(STATUS_EFFECT_SPASMS)
	..()

/datum/brain_trauma/mild/nervous_cough
	name = "Nervous Cough"
	desc = ""
	scan_desc = ""
	gain_text = span_warning("My throat itches incessantly...")
	lose_text = span_notice("My throat stops itching.")

/datum/brain_trauma/mild/nervous_cough/on_life()
	if(prob(6) && !HAS_TRAIT(owner, TRAIT_SOOTHED_THROAT))
		owner.emote("cough", forced = TRUE)
		if(prob(12))
			to_chat(owner, span_warning("[pick("You have a coughing fit!", "You can't stop coughing!")]"))
			owner.Immobilize(20)
			addtimer(CALLBACK(owner, TYPE_PROC_REF(/mob, emote), "cough"), 6)
			addtimer(CALLBACK(owner, TYPE_PROC_REF(/mob, emote), "cough"), 12)
			addtimer(CALLBACK(owner, TYPE_PROC_REF(/mob, emote), "cough"), 18)
	..()

/datum/brain_trauma/mild/expressive_aphasia
	name = "Expressive Aphasia"
	desc = ""
	scan_desc = ""
	gain_text = span_warning("I lose my grasp on complex words.")
	lose_text = span_notice("I feel my vocabulary returning to normal again.")

	var/static/list/common_words = file2list("strings/1000_most_common.txt")

/datum/brain_trauma/mild/expressive_aphasia/handle_speech(datum/source, list/speech_args)
	var/message = speech_args[SPEECH_MESSAGE]
	if(message)
		var/list/message_split = splittext(message, " ")
		var/list/new_message = list()

		for(var/word in message_split)
			var/suffix = copytext(word,-1)

			// Check if we have a suffix and break it out of the word
			if(suffix in list("." , "," , ";" , "!" , ":" , "?"))
				word = copytext(word,1,-1)
			else
				suffix = ""

			word = html_decode(word)

			if(LOWER_TEXT(word) in common_words)
				new_message += word + suffix
			else
				if(prob(30) && message_split.len > 2)
					new_message += pick("uh","erm")
					break
				else
					var/list/charlist = string2charlist(word) // Stupid shit code
					shuffle_inplace(charlist)
					charlist.len = round(charlist.len * 0.5,1)
					new_message += html_encode(jointext(charlist,"")) + suffix

		message = jointext(new_message, " ")

	speech_args[SPEECH_MESSAGE] = trim(message)

/datum/brain_trauma/mild/mind_echo
	name = "Mind Echo"
	desc = ""
	scan_desc = ""
	gain_text = span_warning("I feel a faint echo of my thoughts...")
	lose_text = span_notice("The faint echo fades away.")
	var/list/hear_dejavu = list()
	var/list/speak_dejavu = list()

/datum/brain_trauma/mild/mind_echo/handle_hearing(datum/source, list/hearing_args)
	if(owner == hearing_args[HEARING_SPEAKER])
		return
	if(hear_dejavu.len >= 5)
		if(prob(25))
			var/deja_vu = pick_n_take(hear_dejavu)
			var/static/regex/quoted_spoken_message = regex("\".+\"", "gi")
			hearing_args[HEARING_MESSAGE] = quoted_spoken_message.Replace(hearing_args[HEARING_MESSAGE], "\"[deja_vu]\"") //Quotes included to avoid cases where someone says part of their name
			return
	if(hear_dejavu.len >= 15)
		if(prob(50))
			popleft(hear_dejavu) //Remove the oldest
			hear_dejavu += hearing_args[HEARING_RAW_MESSAGE]
	else
		hear_dejavu += hearing_args[HEARING_RAW_MESSAGE]

/datum/brain_trauma/mild/mind_echo/handle_speech(datum/source, list/speech_args)
	if(speak_dejavu.len >= 5)
		if(prob(25))
			var/deja_vu = pick_n_take(speak_dejavu)
			speech_args[SPEECH_MESSAGE] = deja_vu
			return
	if(speak_dejavu.len >= 15)
		if(prob(50))
			popleft(speak_dejavu) //Remove the oldest
			speak_dejavu += speech_args[SPEECH_MESSAGE]
	else
		speak_dejavu += speech_args[SPEECH_MESSAGE]
