/datum/patron/psydon
	name = "Psydon"
	display_name = "Orthodox Psydonite"
	domain = "God of Humenity, Dreams and Creation"
	desc = "Deceased, slain by Necra in His final moments. She ripped His body apart to create The Ten... we must put Him back together again. Psydon lives. He will return."
	flaws = "Grudge-Holding, Judgemental, Self-Sacrificing"
	worshippers = "Grenzelhofters, Inquisitors, Heroes"
	sins = "Apostasy, Demon Worship, Betraying thy Father"
	boons = "None. His power is divided."
	associated_faith = /datum/faith/psydon
	added_traits = list(TRAIT_PSYDONIAN_GRIT, TRAIT_PSYDONITE)
	confess_lines = list(
		"THERE IS ONLY ONE GOD!",
		"THE SUCCESSORS HALT HIS RETURN!",
		"PSYDON LYVES!",
	)
	profane_words = list()
	devotion_holder = /datum/devotion/psydon

/datum/patron/psydon/can_pray(mob/living/carbon/human/follower)
	//We just kind of assume the follower is a human here
	if(
		istype(follower.wear_wrists, /obj/item/clothing/neck/psycross) || istype(follower.wear_neck, /obj/item/clothing/neck/psycross) || istype(follower.get_active_held_item(), /obj/item/clothing/neck/psycross)
		)
		return TRUE

	to_chat(follower, span_danger("I can not talk to Him... I need His cross!"))
	return FALSE

/datum/patron/psydon/progressive
	display_name = "Progressive Psydonite"
	desc = "Necra divided His body in an act of mercy to create The Ten, and since they are inheritors of His will, it's as if He's still here, right?"
	flaws = "Fatalistic, Sentimental, Acquiescent"
	worshippers = "Idealistic Dreamers, Optimists, Diplomats"
	confess_lines = list(
		"PSYDON AND THE TEN ARE THE RIGHTFUL GODS!",
		"THE SUCCESSORS ARE HIS MANIFESTATIONS!",
		"THROUGH THE TEN PSYDON LIVES!",
	)
