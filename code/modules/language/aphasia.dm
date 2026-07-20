/datum/language/aphasia
	name = "Gibbering"
	desc = ""
	icon_state = "gibbering"
	speech_verb = "garbles"
	ask_verb = "mumbles"
	whisper_verb = "mutters"
	exclaim_verb = "screams incoherently"
	flags = LANGUAGE_HIDE_ICON_IF_NOT_UNDERSTOOD
	key = "16"

	space_chance = 0
	sentence_chance = 0
	between_word_sentence_chance = 10
	between_word_space_chance = 75
	additional_syllable_low = 0
	additional_syllable_high = 0
	default_priority = 10

	syllables = list(
		"m",
		"n",
		"gh",
		"h",
		"l",
		"s",
		"r",
		"a",
		"e",
		"i",
		"o",
		"u",
	)
