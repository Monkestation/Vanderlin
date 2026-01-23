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
