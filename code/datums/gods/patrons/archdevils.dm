/datum/patron/archdevil
	abstract_type = /datum/patron/archdevil
	associated_faith = /datum/faith/archdevil
	drawbacks = "No 'god' can offer miraculous assistance."
	added_languages = list(/datum/language/hellspeak)

/datum/patron/archdevil/can_pray(mob/living/follower)
	// Redefined this entire proc just to tell you:
	// Yes, the godless can pray. This is intentional.
	// Maybe they pray to themselves?
	return TRUE

/datum/patron/archdevil/hear_prayer(mob/living/follower, message)
	if(!follower || !message)
		return FALSE
	var/prayer = SANITIZE_HEAR_MESSAGE(message)

	if(length(profane_words))
		for(var/profanity in profane_words)
			if(findtext(prayer, profanity))
				punish_prayer(follower)
				return FALSE

	if(length(prayer) <= 15)
		to_chat(follower, span_danger("My prayer was kinda short..."))
		return FALSE
	return TRUE

/datum/patron/archdevil/abraxas
	name = ABRAXAS
	domain = "King of the Hells and Archdevil of Wisdom."
	desc = "Abraxas led the attack against Psydon. He is the mastermind, the strategist of the depths. Claimed Baotha to be his own spawn, though her public rejection left populations globally confused. It is only a matter of time before he strikes the surface once more."
	flaws = "Arrogance, Hunger for Power"
	worshippers = "Depraved Researchers, Corrupted Aasimar"
	sins = "Failure, Bad Planning"
	boons = "Access to roles with blood magic. Keen sight and hearing to develop your strategy."
	added_traits = list(TRAIT_DEVILS_REJECTION, TRAIT_DEVIL_MARKED_ABRAXAS)

	confess_lines = list(
		"THE DARK KING RULES!",
		"NOC WILL HIDE NO WISDOM FROM ME!",
		"HE KILLED THE FATHER, HE WILL KILL THE CHILDREN!"
	)

/datum/patron/archdevil/abaddon
	name = ABADDON
	domain = "Archdevil of destruction."
	desc = "Said to consume the spirits of all without souls. It is he where connotations of devils with hellfire and brimstone spawn. Abaddon's influence leads to wanton death and devastation, wherever it may fester. He leaves nothing standing in his wake."
	flaws = "Unrestrained Destruction"
	worshippers = "Nihilists, Apocalyptists, Vandalists, Pyromaniacs."
	sins = "Extinguishing Fire, Building Structures, Empathy"
	boons = "Access to roles with blood magic. Able to touch hot objects."
	added_traits = list(TRAIT_DEVILS_REJECTION, TRAIT_DEVIL_MARKED_ABADDON)
	added_verbs = list(/mob/living/carbon/human/proc/hellspark)

	confess_lines = list(
		"EVERYTHING WILL BURN!",
		"THE CATACLYSM IS COMING!",
		"HELLFIRE WILL CONSUME THE UNWORTHY!"
	)

/datum/patron/archdevil/mephistopheles
	name = MEPHISTOPHELES
	domain = "Archdevil of darkness and trickery."
	desc = "A shapeshifting fiend whose deals always go South. He struck Psydon with his tainted blade, leaving the festering wound which led to The Creator's fall. Mephistopheles twisted the first vampires, Psydon's cursed, into the blood-sucking monsters known today."
	flaws = "Manipulative, Untrustworthy, Unpredictable"
	worshippers = "Vampires, Blood Mages, The Gullible."
	sins = "Self-Sacrifice, Charity"
	boons = "Access to roles with blood magic. Resistance to Blood Curse. Blood magic is cheaper to cast."
	added_traits = list(TRAIT_DEVILS_REJECTION, TRAIT_DEVIL_MARKED_MEPHISTOPHELES)

	confess_lines = list(
		"THE SHADOWS WILL CLAIM YOU!",
		"HIS DARK POWERS ARE MINE!",
		"HE WILL GRANT ME UNDEATH!"
	)

/datum/patron/archdevil/leviathan
	name = LEVIATHAN
	domain = "Archdevil of the Void and Madness, the great eel of shadow."
	desc = "It is unclear where her body ends or starts, and any who dare gaze through the navy depths of the hells' seas of ink, and onto her swirling masses are driven insane. Sailors lost at sea swear they hear her voice singing alongside Abyssor's own, reciting tales of the very oceans turning to blood and swallowing them whole into an endless maw."
	flaws = "Unstable, Delusional, Erratic"
	worshippers = "The Insane, The Deranged, Lost Mariners."
	sins = "Sanity, Logic, Free Will."
	boons = "Access to roles with blood magic. Breathe in the void of Leviathan's depths. Sense stress and insanity."
	added_traits = list(TRAIT_DEVILS_REJECTION, TRAIT_DEVIL_MARKED_LEVIATHAN, TRAIT_NODROWN)

	confess_lines = list(
		"HER COILS WILL PROTECT ME!",
		"SHE IS ENDLESS!",
		"CAN YOU HEAR HER SING?"
	)

/mob/living/carbon/human/proc/hellspark()
	set name = "Conjure Spark"
	set category = "RoleUnique.Devil"
	if(incapacitated(IGNORE_GRAB) || stat >= UNCONSCIOUS)
		to_chat(usr, span_warning("You cannot do this in your current state."))
		return

	var/main_hand = get_active_held_item()
	var/off_hand = get_inactive_held_item()

	if(istype(main_hand, /obj/item/flint/abaddon_hand))
		to_chat(usr, SPAN_GOD_ARCHDEVILS("I will no longer spark hellfire."))
		qdel(main_hand)
		return
	if(istype(off_hand, /obj/item/flint/abaddon_hand))
		to_chat(usr, SPAN_GOD_ARCHDEVILS("I will no longer spark hellfire."))
		qdel(off_hand)
		return

	to_chat(usr, SPAN_GOD_ARCHDEVILS("I prepare to conjure a spark of hellfire."))
	var/obj/item/flint/abaddon_hand/spark = new(src)
	put_in_hands(spark, del_on_fail = TRUE)
