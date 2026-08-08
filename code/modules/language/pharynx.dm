/datum/language/pharynx
	name = "Pharynx"
	desc = "A language developped by medicators to be spoken by physicians worldwide. Legible even when you're suffering from fractures or ruptured arteries."
	icon_state = "gibbering"
	speech_verb = "spits"
	ask_verb = "asks"
	exclaim_verb = "belches"
	key = "j"
	space_chance = 80
	sentence_chance = 5
	between_word_sentence_chance = 0
	between_word_space_chance = 100
	additional_syllable_low = -3
	additional_syllable_high = 1
	default_priority = 80
	default_priority = 80
	mutual_understanding = list( // can understand some orcish with this, the reverse is not true.
		datum/language/orcish = 33,
		)

	syllables = list(
		"AA", "AN", "AH", "AW",
		"BE", "ΔA",	"ΔE", "EE",	"EΛ",
		"EH", "ET", "SE", "HE",
		"UH", "TE",	"KE", "ΛE",
		"OE", "Ω", "OH",
		"ST", "ΛI", "SÉ", "WA",
		"ME", "EN",	"EK",
		"ET", "GE", "PO",
		"UN", "UΛ",	"HA",
		"ΠU", "AΞ", "AT",
		"ON", "NG",	"ZE",
		"HEE", "YW","BUH",
		"AAN", "AWA", "AHÉ", "AΛS",	"ANΔ",
		"AFT", "ΔEN", "ΔEH", "ENOH",
		"GEN", "ΠAH", "HAA", "HET",	"ΠEΔ",
		"ING", "KEH", "ΛΛE", "ΛIH",	"MAA",
		"MEN", "MET", "NΔE", "NEN",	"NGE",
		"NIE", "ONΔ", "ΩH", "HΔE",	"HEN",
		"SCH", "SUN", "TEN", "TEH",	"UIT",
		"BAN", "EEN", "IME", "ΞSE",
		"VUN", "YEF", "NΔE",
		"HUT", "ING", "FHA", "ΔAA",
		"ΔAT", "IET", "STU", "HUN",
		"ΔUN", "MUT", "UHA", "ΛUH",
		"MAS", "UΛS", "WAS",
		"UCH", "EFH", "MEN", "HAS",
		"UNΔ", "ΔUH", "VIHA", "VYEN",
	)
