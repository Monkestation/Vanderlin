// 'basic' language; spoken by default.
/datum/language/common
	name = "Imperial"
	desc = ""
	icon_state = "imperial"
	speech_verb = "says"
	whisper_verb = "whispers"
	exclaim_verb = "yells"
	ask_verb = "asks"
	key = "i"
	flags = LANGUAGE_HIDE_ICON_IF_UNDERSTOOD
	default_priority = 100
	space_chance = 20
	sentence_chance = 0
	between_word_sentence_chance = 10
	between_word_space_chance = 75
	additional_syllable_low = 0
	additional_syllable_high = 0

	syllables = list(
		"ant",
		"ati",
		"atu",
		"bus",
		"con",
		"com",
		"ent",
		"era",
		"ere",
		"eri",
		"est",
		"iam",
		"ibu",
		"ili",
		"iss",
		"ita",
		"itu",
		"ium",
		"ius",
		"nte",
		"nti",
		"oru",
		"per",
		"pro",
		"qua",
		"que",
		"qui",
		"quo",
		"rat",
		"rum",
		"sse",
		"tat",
		"ter",
		"tis",
		"tum",
		"tur",
		"tus",
		"unt",
		"ae",
		"am",
		"an",
		"ar",
		"at",
		"ci",
		"co",
		"de",
		"di",
		"em",
		"en",
		"er",
		"es",
		"et",
		"ia",
		"in",
		"is",
		"it",
		"iu",
		"li",
		"ne",
		"ni",
		"nt",
		"on",
		"or",
		"os",
		"pe",
		"qu",
		"ra",
		"re",
		"ri",
		"ru",
		"se",
		"si",
		"st",
		"ta",
		"te",
		"ti",
		"tu",
		"ue",
		"ui",
		"um",
		"ur",
		"us",
	)
