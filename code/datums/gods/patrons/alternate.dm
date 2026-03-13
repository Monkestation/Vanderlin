/datum/patron/alternate
	abstract_type = /datum/patron/alternate
	associated_faith = /datum/faith/alternate

/datum/patron/alternate/wurm
	name = "The Wurm"
	desc = "A Belief of Pestra contorted. You live for the Wurm and you will die for it."
	domain = "\"Mineralogy\", Flesh Searing, Chimeric Enhancement"
	flaws = "Blind Faith, Self-Harm, Cruelty"
	worshippers = "The Desperate, The Lost, Fanatics"
	sins = "Betrayal of Duty, Hesitance, Trusting Outsiders"
	boons = "Two \"blessed\" chimeric organs"

	confess_lines = list(
		"THE CYCLE WILL GO ON!",
		"THE WURM WILL GUIDE MY PATH!",
		"MY SCARS ARE MY PROOF!",
		"THE POOLS WILL ERODE ALL!",
	)

	allowed_races = list(SPEC_ID_DWARF_SUBTERRAN)

/datum/patron/alternate/great_hunt
	name = "The Great Hunt (Proven)"
	desc = "In the cold reaches of Ossland, they worship the four aspects of the Great Hunt: \
	Graggar as The Hunter, revered for the relation between predator and prey; \
	Necra as The Skull, revered for the death that awaits every living being; \
	Dendor as The Woods, revered for the wilds they live in and the beasts they hunt; \
	Abyssor as The Traveler, revered for the safe passage of travelers and the unflinching weather that scours the north."
	domain = "The Hunt, Travelers, Nature"
	flaws = "Intense, Morbid"
	worshippers = "Hunters, the Northmen"
	sins = "Wasting any of your kills, Smashing skullmets, Exploiting nature"
	boons = ""

	confess_lines = list(
		"I WILL BE REBORN!",
		"TO HUNT IS TO TAKE YOUR PLACE IN THE CYCLE!",
		"WE ALL DIE SOMEDAY!",
		"LET ME BE HUNTED, NOT SLAUGHTERED LIKE THIS!"
	)

/datum/patron/alternate/great_hunt/preference_accessible(datum/preferences/prefs)
	return FALSE

/datum/patron/alternate/great_hunt/unproven
	name = "The Great Hunt (Unproven)"
	boons = "None. You have not proven worthy yet."

/datum/patron/alternate/great_hunt/unproven/preference_accessible(datum/preferences/prefs)
	return TRUE
