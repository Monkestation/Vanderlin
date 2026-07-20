/datum/language/kobold
	name = "Utterances"
	desc = ""
	icon_state = "beastial"
	spans = list(SPAN_KOBOLD)
	speech_verb = "hisses"
	ask_verb = "growls"
	exclaim_verb = "snarls"
	key = "k"
	space_chance = 100
	sentence_chance = 10
	between_word_sentence_chance = 0
	between_word_space_chance = 0
	additional_syllable_low = -2
	additional_syllable_high = 1
	default_priority = 100

	syllables = list(
        "|+-squeak-+|",
        "|+-hiss-+|",
        "|+-trill-+|",
        "|+-whine-+|",
        "|+-yip-+|",
	    "|+-snarl-+|",
        "|+-growl-+|",
        "|+-grunt-+|"
	)
