/datum/patron/psydon
	name = "Psydon"
	display_name = "Orthodox Psydonite"
	domain = "God of Humenity, Dreams and Creation"
	desc = "Deceased, slain by Necra in His final moments. She ripped His body apart to create The Ten... we must put Him back together again. Psydon lives on, He will return."
	flaws = "Grudge-Holding, Judgemental, Self-Sacrificing"
	worshippers = "Grenzelhoftians, Inquisitors, Heroes"
	sins = "Apostasy, Demon Worship, Betraying thy Father"
	boons = "None. His power is divided."

	associated_faith = /datum/faith/psydon
	prayer_fail = "I can not talk to Him... I need His cross!"
	confess_lines = list(
		"THERE IS ONLY ONE TRUE GOD!",
		"THE SUCCESSORS HALT HIS RETURN!",
		"PSYDON WILL RETURN!",
	)

	associated_objects = alist(
		PATRON_AMULET = list(
			/obj/item/clothing/neck/psycross/silver,
			/obj/item/clothing/neck/psycross
		),
		PATRON_STRUCTURE = list(
			/obj/structure/fluff/psycross
		),
	)

/datum/patron/psydon/extremist
	display_name = "Extremist Psydonite"
	desc = "The Ten are conmen, false prophets, and heathens. The acts of the Tennite church are all tricks to beguile the mind and dissuade you from following the true path of Psydon. My actions prove my faith and His strength. Psydon lives, and you cannot convince me otherwise."
	flaws = "Stubborn, Fanatical, Spiteful"
	worshippers = "Fanatics, Misinformed Fools"
	sins = "Blasphemy, False Prophets, Trickery"
	confess_lines = list(
		"THERE IS ONLY ONE GOD!",
		"YOUR FALSE TEN ARE LIES!",
		"PSYDON LIVES!",
	)


