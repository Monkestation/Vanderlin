/datum/patron/archdevil
	abstract_type = /datum/patron/archdevil
	associated_faith = /datum/faith/archdevil
	drawbacks = "No 'god' can offer miraculous assistance."

/datum/patron/archdevil/can_pray(mob/living/follower)
	// Redefined this entire proc just to tell you:
	// Yes, the godless can pray. This is intentional.
	// Maybe they pray to themselves?
	return TRUE

/datum/patron/archdevil/hear_prayer(mob/living/follower, message)
	return FALSE

/datum/patron/archdevil/abraxas
	name = "Abraxas"
	domain = "King of the Hells and Archdevil of Wisdom."
	desc = "Abraxas led the attack against Psydon. He is the mastermind, the strategist of the depths. Claimed Baotha to be his own spawn, though her public rejection left populations globally confused. It is only a matter of time before he strikes the surface once more."
	flaws = "Arrogance, Hunger for Power"
	worshippers = "Depraved Researchers, Corrupted Aasimar"
	sins = "Failure, Bad Planning"
	boons = "Keen sight to develop your strategy."
	added_traits = list(TRAIT_DEVILS_REJECTION, TRAIT_DEVIL_MARKED_ABRAXAS, TRAIT_KEENEYES)

	confess_lines = list(
		"THE DARK KING RULES!",
		"NOC WILL HIDE NO WISDOM FROM ME!",
		"HE KILLED THE FATHER, HE WILL KILL THE CHILDREN!"
	)

/datum/patron/archdevil/abaddon
	name = "Abaddon"
	domain = "Archdevil of destruction."
	desc = "Said to consume the spirits of all without souls. It is he where connotations of devils with hellfire and brimstone spawn. Abaddon's influence leads to wanton death and devastation, wherever it may fester. He leaves nothing standing in his wake."
	flaws = "Unrestrained Destruction"
	worshippers = "Nihilists, Apocalyptists, Vandalists, Pyromaniacs."
	sins = "Extinguishing Fire, Building Structures, Empathy"
	boons = "Able to touch hot objects."
	added_traits = list(TRAIT_DEVILS_REJECTION, TRAIT_DEVIL_MARKED_ABADDON, TRAIT_RESISTHEAT)

	confess_lines = list(
		"EVERYTHING WILL BURN!",
		"THE CATACLYSM IS COMING!",
		"HELLFIRE WILL CONSUME THE UNWORTHY!"
	)

/datum/patron/archdevil/mephistopheles
	name = "Mephistopheles"
	domain = "Archdevil of darkness and trickery."
	desc = "A shapeshifting fiend whose deals always go South. He struck Psydon with his tainted blade, leaving the festering wound which led to The Creator's fall. Mephistopheles twisted the first vampires, Psydon's cursed, into the blood-sucking monsters known today."
	flaws = "Manipulative, Untrustworthy, Unpredictable"
	worshippers = "Vampires, Blood Mages, The Gullible."
	sins = "Self-Sacrifice, Charity"
	boons = "Darkness hides your limits. Resistance to Blood Curse. Access to roles with blood magic."
	added_traits = list(TRAIT_DEVILS_REJECTION, TRAIT_DEVIL_MARKED_MEPHISTOPHELES, TRAIT_DECEIVING_MEEKNESS)

	confess_lines = list(
		"THE SHADOWS WILL CLAIM YOU!",
		"HIS DARK POWERS ARE MINE!",
		"HE WILL GRANT ME UNDEATH!"
	)

/datum/patron/archdevil/leviathan
	name = "Leviathan"
	domain = "Archdevil of the Void and Madness, the great eel of shadow."
	desc = "It is unclear where her body ends or starts, and any who dare gaze through the navy depths of the hells' seas of ink, and onto her swirling masses are driven insane. Sailors lost at sea swear they hear her voice singing alongside Abyssor's own, reciting tales of the very oceans turning to blood and swallowing them whole into an endless maw."
	flaws = "Unstable, Delusional, Erratic"
	worshippers = "The Insane, The Deranged, Lost Mariners."
	sins = "Sanity, Logic, Free Will."
	boons = "Breathe in the void of Leviathan's depths."
	added_traits = list(TRAIT_DEVILS_REJECTION, TRAIT_DEVIL_MARKED_LEVIATHAN, TRAIT_NODROWN)

	confess_lines = list(
		"HER COILS WILL PROTECT ME!",
		"SHE IS ENDLESS!",
		"CAN YOU HEAR HER SING?"
	)
