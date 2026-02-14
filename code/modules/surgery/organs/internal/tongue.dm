/obj/item/organ/tongue
	name = "tongue"
	desc = ""
	icon_state = "tongue"
	zone = BODY_ZONE_PRECISE_MOUTH
	slot = ORGAN_SLOT_TONGUE
	attack_verb = list("licked", "slobbered", "slapped", "frenched", "tongued")
	var/list/languages_possible
	var/say_mod = null
	var/taste_sensitivity = 15 // lower is more sensitive.
	var/modifies_speech = FALSE
	var/static/list/languages_possible_base = typecacheof(list(
		/datum/language/common,
		/datum/language/dwarvish,
		/datum/language/elvish,
		/datum/language/oldpsydonic,
		/datum/language/zalad,
		/datum/language/celestial,
		/datum/language/hellspeak,
		/datum/language/beast,
		/datum/language/thievescant,
		/datum/language/orcish,
		/datum/language/deepspeak,
		/datum/language/undead,
		/datum/language/halfling
	))

/obj/item/organ/tongue/Initialize(mapload)
	. = ..()
	languages_possible = languages_possible_base

/obj/item/organ/tongue/proc/handle_speech(datum/source, list/speech_args)

/obj/item/organ/tongue/Insert(mob/living/carbon/M, special = FALSE, drop_if_replaced = TRUE)
	. = ..()
	if(say_mod && M.dna && M.dna.species)
		M.dna.species.say_mod = say_mod
	if (modifies_speech)
		RegisterSignal(M, COMSIG_MOB_SAY, PROC_REF(handle_speech))
	M.UnregisterSignal(M, COMSIG_MOB_SAY)
	for(var/datum/wound/facial/tongue/tongue_wound in M.get_wounds())
		qdel(tongue_wound)

/obj/item/organ/tongue/Remove(mob/living/carbon/M, special = FALSE, drop_if_replaced = TRUE)
	. = ..()
	if(say_mod && M.dna && M.dna.species)
		M.dna.species.say_mod = initial(M.dna.species.say_mod)
	UnregisterSignal(M, COMSIG_MOB_SAY, PROC_REF(handle_speech))
	M.RegisterSignal(M, COMSIG_MOB_SAY, TYPE_PROC_REF(/mob/living/carbon, handle_tongueless_speech))

/obj/item/organ/tongue/could_speak_in_language(datum/language/dt)
	return is_type_in_typecache(dt, languages_possible)

/obj/item/organ/tongue/fish
	name = "basihyal tongue"
	desc = ""
	icon_state = "tonguefish"
	taste_sensitivity = 20
	modifies_speech = TRUE

/obj/item/organ/tongue/fish/handle_speech(datum/source, list/speech_args)
	var/static/regex/fishtongue_sibilants = regex(@"([sz])", "gi")
	var/message = speech_args[SPEECH_MESSAGE]
	if(!message)
		return

	var/datum/language/lang = speech_args[SPEECH_LANGUAGE]
	if(lang && ispath(lang, /datum/language/deepspeak))
		return

	if(message[1] != "*")
		message = fishtongue_sibilants.Replace(message, "$1$1$1") // triple the letter
	speech_args[SPEECH_MESSAGE] = message

/obj/item/organ/tongue/fly
	name = "proboscis"
	desc = ""
	icon_state = "tonguefly"
	say_mod = "buzzes"
	taste_sensitivity = 25 // you eat vomit, this is a mercy
	modifies_speech = TRUE

/obj/item/organ/tongue/fly/handle_speech(datum/source, list/speech_args)
	var/static/regex/fly_buzz = new("z+", "g")
	var/static/regex/fly_buZZ = new("Z+", "g")
	var/message = speech_args[SPEECH_MESSAGE]
	if(message[1] != "*")
		message = fly_buzz.Replace(message, "zzz")
		message = fly_buZZ.Replace(message, "ZZZ")
	speech_args[SPEECH_MESSAGE] = message

/obj/item/organ/tongue/zombie
	name = "rotting tongue"
	desc = ""
	icon_state = "tonguezombie"
	say_mod = "moans"
	modifies_speech = TRUE
	taste_sensitivity = 32

/obj/item/organ/tongue/zombie/handle_speech(datum/source, list/speech_args)
	var/list/message_list = splittext(speech_args[SPEECH_MESSAGE], " ")
	var/maxchanges = max(round(message_list.len / 1.5), 2)

	for(var/i = rand(maxchanges / 2, maxchanges), i > 0, i--)
		var/insertpos = rand(1, message_list.len - 1)
		var/inserttext = message_list[insertpos]

		if(!(copytext(inserttext, length(inserttext) - 2) == "..."))
			message_list[insertpos] = inserttext + "..."

		if(prob(20) && message_list.len > 3)
			message_list.Insert(insertpos, "[pick("BRAINS", "Brains", "Braaaiinnnsss", "BRAAAIIINNSSS")]...")

	speech_args[SPEECH_MESSAGE] = jointext(message_list, " ")

/obj/item/organ/tongue/bone
	name = "bone \"tongue\""
	desc = ""
	icon_state = "tonguebone"
	say_mod = "rattles"
	attack_verb = list("bitten", "chattered", "chomped", "enamelled", "boned")
	taste_sensitivity = 101 // skeletons cannot taste anything
	modifies_speech = TRUE
	var/chattering = FALSE
	var/phomeme_type = "sans"
	var/list/phomeme_types = list("sans", "papyrus")

/obj/item/organ/tongue/bone/Initialize()
	. = ..()
	phomeme_type = pick(phomeme_types)

/obj/item/organ/tongue/bone/handle_speech(datum/source, list/speech_args)
	if (chattering)
		chatter(speech_args[SPEECH_MESSAGE], phomeme_type, source)
	switch(phomeme_type)
		if("sans")
			speech_args[SPEECH_SPANS] |= SPAN_SANS
		if("papyrus")
			speech_args[SPEECH_SPANS] |= SPAN_PAPYRUS

/obj/item/organ/tongue/bone/plasmaman
	name = "plasma bone \"tongue\""
	desc = ""
	icon_state = "tongueplasma"
	modifies_speech = FALSE

/obj/item/organ/tongue/robot
	name = "robotic voicebox"
	desc = ""
	status = ORGAN_ROBOTIC
	icon_state = "tonguerobot"
	say_mod = "states"
	attack_verb = list("beeped", "booped")
	modifies_speech = TRUE
	taste_sensitivity = 25 // not as good as an organic tongue

/obj/item/organ/tongue/robot/can_speak_in_language(datum/language/dt)
	return TRUE // THE MAGIC OF ELECTRONICS

/obj/item/organ/tongue/robot/handle_speech(datum/source, list/speech_args)
	speech_args[SPEECH_SPANS] |= SPAN_ROBOT

/obj/item/organ/tongue/snail
	name = "snailtongue"
	modifies_speech = TRUE

/obj/item/organ/tongue/snail/handle_speech(datum/source, list/speech_args)
	var/message = speech_args[SPEECH_MESSAGE]
	var/static/regex/stretch_regex = regex(@"(\l)", "g") // every letter, case-insensitive, return match in group 1
	stretch_regex.Replace(message, "$1$1$1") // triple every letter
	speech_args[SPEECH_MESSAGE] = stretch_regex.Replace(message, "$1$1$1") // triple every letter
