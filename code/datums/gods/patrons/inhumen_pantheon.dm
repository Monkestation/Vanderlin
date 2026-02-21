/datum/patron/inhumen
	abstract_type = /datum/patron/inhumen
	associated_faith = /datum/faith/inhumen_pantheon

	confess_lines = list(
		"PSYDON AND HIS CHILDREN ARE THE DEMIURGE!",
		"THE TEN ARE WORTHLESS COWARDS!",
		"THE TEN ARE DECEIVERS!"
	)

/datum/patron/inhumen/can_pray(mob/living/follower)
	for(var/obj/structure/fluff/psycross/cross in view(7, get_turf(follower)))
		if(cross.divine && !cross.obj_broken)
			to_chat(follower, span_danger("That accursed cross won't let me commune with the Forbidden One!"))
			return FALSE

	return TRUE

/* ----------------- */

/datum/patron/inhumen/zizo
	name = ZIZO
	domain = "Ascended Goddess of Forbidden Magic, Domination, and Power"
	desc = "Snow elf who slaughtered her kind in ascension, conquered and remade the Dark Elven empires in her name. She proves that any with will can achieve divinity... though at a cost."
	flaws = "Hubris, Superiority, Fury"
	worshippers = "Dark Elves, Aspirants, Necromancers, Misandrists"
	sins = "Pearl-clutching, Moralism, Wastefulness"
	boons = "You may perform fleshcrafting. Access to roles with magic."
	//added_traits = list(TRAIT_CABAL)	No need for this. They have fleshcrafting now.
	devotion_holder = /datum/devotion/inhumen/zizo
	confess_lines = list(
		"I FOLLOW THE PATH OF ZIZO!",
		"LONG LIVE QUEEN ZIZO!",
		"ZIZO SHOWED ME THE WAY!",
	)
	storyteller = /datum/storyteller/zizo
	added_verbs = list(
		/mob/living/carbon/human/proc/draw_sigil,
		/mob/living/carbon/human/proc/praise,
	)

/datum/patron/inhumen/graggar
	name = GRAGGAR
	domain = "Ascended God, the Dark Sini-Star of Unnatural Beasts, Unsated Consumption, and Unbridled Hatred"
	desc = "Became the first orc upon ascension through his habit of consuming the bodies of those he conquered. His forces continue to ravage the lands in his name. Through him, one may achieve true strength."
	flaws = "Rage, Hatred, Bloodthirst"
	worshippers = "Greenskins, The Revenge-Driven, Sadists, Misogynists"
	sins = "Compassion, Frailty, Servility"
	boons = "You are drawn to the flavour of raw flesh and organs, and may consume without worry."
	added_traits = list(TRAIT_ORGAN_EATER)
	devotion_holder = /datum/devotion/inhumen/graggar
	confess_lines = list(
		"GRAGGAR IS THE BEAST I WORSHIP!",
		"GRAGGAR WILL RAVAGE YOU!",
		"GRAGGAR BRINGS UNHOLY DESTRUCTION!"
	)
	storyteller = /datum/storyteller/graggar

/datum/patron/inhumen/matthios
	name = MATTHIOS
	domain = "God of Thievery, Ill-Gotten Gains, and Highwaymen"
	desc = "Legendary humen bandit whose name was attributed to countless great thefts. It is because of his legacy that nobles clutch their coin purses to their chests in town."
	flaws = "Pride, Greed, Orneriness"
	worshippers = "Outlaws, Noble-Haters, Downtrodden Peasantry"
	sins = "Clumsiness, Stupidity, Humility"
	boons = "You can see the most expensive item someone is carrying."
	added_traits = list(TRAIT_MATTHIOS_EYES)
	devotion_holder = /datum/devotion/inhumen/matthios
	confess_lines = list(
		"MATTHIOS STEALS FROM THE WORTHLESS!",
		"MATTHIOS IS JUSTICE FOR THE COMMON MAN!",
		"MATTHIOS IS MY LORD, I SHALL BE HIS MARTYR!",
	)
	storyteller = /datum/storyteller/matthios

/datum/patron/inhumen/baotha
	name = BAOTHA
	domain = "Goddess of Drugs, Self-Preservation, and Remorseless Joy"	//Bright-dyed hair falls within 'remorseless joy.' Joy for one's self at expense of the setting. Same for her music taste.
	desc = "Ascended, formerly disgraced tiefling queen, notorious for having a mind elsewhere. Drove her kingdom into the ground through her demands and addictions. The first tiefling noble, last tiefling noble, and sole reason there are no more tiefling nobles. As she preaches to her followers, 'Joy at all costs!'"
	flaws = "Manipulation, Self-Destruction, Willingness to Sacrifice Others"
	worshippers = "Addicts, Hedonists, Pink-Haired Harlots"
	sins = "Sobriety, Self-Sacrifice, Faltering Willpower"
	boons = "You will never overdose on drugs."
	added_traits = list(TRAIT_CRACKHEAD)
	devotion_holder = /datum/devotion/inhumen/baotha
	confess_lines = list(
		"LIVE, LAUGH, LOVE! IN BAOTHA'S NAME!",
		"JOY AT ALL COSTS! BAOTHA'S TEACHINGS REIGN!",
		"BAOTHA'S WHISPERS CALM MY MIND!",
	)
	storyteller = /datum/storyteller/baotha

/// Maniac Patron - Their mind is broken by secrets of Zizo/Graggar combined. They quite possibly know the reality of what happens outside the planet. They may think this is all a game. They are clearly insane.
/datum/patron/inhumen/graggar_zizo
	name = "Graggazo"
	domain = "Ascended God who slaughtered her kind in ascension, the Dark Sini-Star of Unnatural Beasts, Forbidden Magic, and Unbridled Hatred."
	desc = "Became the first snow orc upon ascension through his habit of consuming the bodies of those he conquered. His forces continue to ravage the lands in her name. He proves that any with will can achieve divinity... though at a cost. MAKE THIS MAKE SENSE. MY MIND! MY MIND!!"
	flaws = "Nothing, Everything, Nothing"
	worshippers = "Broken Minds, Overshared Secrets, Space-Faring Species Like You, Misanthropes"
	sins = "The Unseen, Secrets, Worthless Pigs"
	boons = "You are drawn to the flavour of other followers of Zizo, and may see them when you consume without worry."
	added_traits = list(TRAIT_ORGAN_EATER, TRAIT_CABAL)
	confess_lines = list(
		"WHERE AM I!",
		"NONE OF THIS IS REAL!",
		"WHO AM I WORSHIPPING?!"
	)

/datum/patron/inhumen/graggar_zizo/preference_accessible(datum/preferences/prefs)
	return FALSE

/datum/patron/inhumen/graggar_zizo/can_pray(mob/living/follower)
	var/datum/antagonist/maniac/dreamer = follower.mind.has_antag_datum(/datum/antagonist/maniac)
	if(dreamer)
		return TRUE
	// if a non-maniac somehow gets this patron,
	// something interesting should happen if they try to pray.
	INVOKE_ASYNC(follower, GLOBAL_PROC_REF(cant_wake_up), follower)  //Something interesting happened.
	message_admins("[ADMIN_LOOKUPFLW(follower)] has been gibbed due to praying as a non-maniac with their patron set to Graggazo. Whoops..")
	return FALSE

/datum/patron/inhumen/graggar_zizo/hear_prayer(mob/living/follower, message)
	var/datum/antagonist/maniac/dreamer = follower.mind.has_antag_datum(/datum/antagonist/maniac)
	if(!dreamer)
		return FALSE
	if(text2num(message) == dreamer.sum_keys)
		INVOKE_ASYNC(dreamer, TYPE_PROC_REF(/datum/antagonist/maniac, wake_up))
		return TRUE
	. = ..()
