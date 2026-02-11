/datum/job/inquisitor
	title = "Herr Prafekt"
	department_flag = INQUISITION
	faction = "Station"
	total_positions = 1
	spawn_positions = 1
	job_flags = (JOB_ANNOUNCE_ARRIVAL | JOB_SHOW_IN_CREDITS | JOB_EQUIP_RANK | JOB_NEW_PLAYER_JOINABLE)
	allowed_sexes = list(MALE, FEMALE)
	allowed_races = list(\
		SPEC_ID_HUMEN,\
		SPEC_ID_DWARF,\
	)
	//You MUST have a Psydonite character to start. Just so people don't get japed into Oops Suddenly Psydon!
	allowed_patrons = list(/datum/patron/psydon) // you have to keep the official church stance, no way an extremist psydonite could become inquisitor
	tutorial = "This is the week. All your lessons have led to this moment. Your students follow you with eager steps and breathless anticipation. You’re to observe their hunt, and see if they can banish the evils haunting Psydonia, and rise up to become true inquisitors. A guide to them, a monster to others. You are the thing that goes bump in the night."
	cmode_music = 'sound/music/cmode/church/CombatInquisitor.ogg'
	selection_color = JCOLOR_INQUISITION
	allowed_ages = list(AGE_MIDDLEAGED, AGE_OLD)
	spells = list(/datum/action/cooldown/spell/undirected/list_target/convert_role/adept)
	outfit = /datum/outfit/inquisitor
	display_order = JDO_PURITAN
	advclass_cat_rolls = list(CTAG_PURITAN = 20)
	give_bank_account = 30
	bypass_lastclass = TRUE
	antag_role = /datum/antagonist/purishep

	mind_traits = list(
		TRAIT_KNOW_INQUISITION_DOORS
	)
	languages = list(/datum/language/oldpsydonic)
	spells = list(
		/datum/action/cooldown/spell/undirected/call_bird/inquisitor
	)

	exp_type = list(EXP_TYPE_INQUISITION)
	exp_types_granted = list(EXP_TYPE_INQUISITION, EXP_TYPE_COMBAT, EXP_TYPE_LEADERSHIP)
	exp_requirements = list(
		EXP_TYPE_INQUISITION = 900
	)

/datum/outfit/inquisitor
	abstract_type = /datum/outfit/inquisitor
	name = "Inquisitor"

/datum/job/inquisitor/after_spawn(mob/living/carbon/human/spawned, client/player_client)
	. = ..()

	add_verb(spawned, /mob/living/carbon/human/proc/faith_test)
	add_verb(spawned, /mob/living/carbon/human/proc/torture_victim)
	add_verb(spawned, /mob/living/carbon/human/proc/view_inquisition)

	spawned.hud_used?.shutdown_bloodpool()
	spawned.hud_used?.initialize_bloodpool()
	spawned.hud_used?.bloodpool.set_fill_color("#dcdddb")
	spawned.hud_used?.bloodpool?.name = "Psydon's Grace: [spawned.bloodpool]"
	spawned.hud_used?.bloodpool?.desc = "Devotion: [spawned.bloodpool]/[spawned.maxbloodpool]"
	spawned.maxbloodpool = 1000

	var/prev_real_name = spawned.real_name
	var/prev_name = spawned.name
	var/honorary = "Herr Prafekt"
	if(spawned.pronouns == SHE_HER)
		honorary = "Frau Prafekt"
	spawned.real_name = "[honorary] [prev_real_name]"
	spawned.name = "[honorary] [prev_name]"

	var/datum/species/species = spawned.dna?.species
	if(!species)
		return
	species.native_language = "Old Psydonic"
	species.accent_language = species.get_accent(species.native_language)

////Classic Inquisitor with a much more underground twist. Use listening devices, sneak into places to gather evidence, track down suspicious individuals. Has relatively the same utility stats as Confessor, but fulfills a different niche in terms of their combative job as the head honcho.

///The dirty, violent side of the Inquisition. Meant for confrontational, conflict-driven situations as opposed to simply sneaking around and asking questions. Templar with none of the miracles, but with all the muscles and more.

/mob/living/carbon/human/proc/torture_victim()
	set name = "Extract Confession"
	set category = "RoleUnique.Inquisition"

	var/obj/item/grabbing/I = get_active_held_item()
	var/mob/living/carbon/human/H
	if(!istype(I) || !ishuman(I.grabbed))
		return
	H = I.grabbed
	if(H == src)
		to_chat(src, span_warning("I won't torture myself!"))
		return
	if(!HAS_TRAIT(H, TRAIT_RESTRAINED) && !H.buckled)
		to_chat(src, span_warning("[H] needs to be restrained or buckled first!"))
		return
	if(H.stat == DEAD)
		to_chat(src, span_warning("[H] is dead already..."))
		return

	// Anti-spam check
	if(HAS_TRAIT(H, TRAIT_RECENTLY_TORTURED))
		to_chat(src, span_warning("[H] needs time to recover before being tortured again!"))
		return

	var/painpercent = (H.get_complex_pain() / (H.STAEND * 12)) * 100
	if(painpercent < 100)
		to_chat(src, span_warning("Not ready to speak yet."))
		return
	if(!do_after(src, 4 SECONDS, H))
		return
	if(!HAS_TRAIT(H, TRAIT_RESTRAINED) && !H.buckled)
		to_chat(src, span_warning("[H] needs to be restrained or buckled first!"))
		return
	if(H.stat == DEAD)
		to_chat(src, span_warning("[H] is dead already..."))
		return
	if(H.add_stress(/datum/stress_event/tortured))
		SEND_SIGNAL(src, COMSIG_TORTURE_PERFORMED, H)

		// Add torture cooldown
		ADD_TRAIT(H, TRAIT_RECENTLY_TORTURED, TRAIT_GENERIC)
		addtimer(TRAIT_CALLBACK_REMOVE(H, TRAIT_RECENTLY_TORTURED, TRAIT_GENERIC), 3 MINUTES)

		var/static/list/torture_lines = list(
			"CONFESS YOUR WRONGDOINGS!",
			"TELL ME YOUR SECRETS!",
			"SPEAK THE TRUTH!",
			"YOU WILL SPEAK!",
			"TELL ME!",
			"THE PAIN HAS ONLY BEGUN, CONFESS!",
		)
		say(pick(torture_lines), spans = list("torture"))
		H.emote("painscream")
		H.confession_time("antag", src)

/mob/living/carbon/human/proc/faith_test()
	set name = "Test Faith"
	set category = "RoleUnique.Inquisition"

	var/obj/item/grabbing/I = get_active_held_item()
	var/mob/living/carbon/human/H
	if(!istype(I) || !ishuman(I.grabbed))
		return
	H = I.grabbed
	if(H == src)
		to_chat(src, span_warning("I won't torture myself!"))
		return
	if(!HAS_TRAIT(H, TRAIT_RESTRAINED) && !H.buckled)
		to_chat(src, span_warning("[H] needs to be restrained or buckled first!"))
		return
	if(H.stat == DEAD)
		to_chat(src, span_warning("[H] is dead already..."))
		return

	// Anti-spam check
	if(HAS_TRAIT(H, TRAIT_RECENTLY_TORTURED))
		to_chat(src, span_warning("[H] needs time to recover before being tortured again!"))
		return

	var/painpercent = (H.get_complex_pain() / (H.STAEND * 12)) * 100
	if(painpercent < 100)
		to_chat(src, span_warning("Not ready to speak yet."))
		return
	if(!do_after(src, 4 SECONDS, H))
		return
	if(!HAS_TRAIT(H, TRAIT_RESTRAINED) && !H.buckled)
		to_chat(src, span_warning("[H] needs to be restrained or buckled first!"))
		return
	if(H.stat == DEAD)
		to_chat(src, span_warning("[H] is dead already..."))
		return
	if(H.add_stress(/datum/stress_event/tortured))
		SEND_SIGNAL(src, COMSIG_TORTURE_PERFORMED, H)

		// Add torture cooldown
		ADD_TRAIT(H, TRAIT_RECENTLY_TORTURED, TRAIT_GENERIC)
		addtimer(TRAIT_CALLBACK_REMOVE(H, TRAIT_RECENTLY_TORTURED, TRAIT_GENERIC), 30 SECONDS)

		var/static/list/faith_lines = list(
			"DO YOU DENY PSYDON AND THE TEN?",
			"WHO IS YOUR GOD?",
			"ARE YOU FAITHFUL?",
			"TO WHICH SHEPHERD DO YOU FLOCK TO?",
		)
		say(pick(faith_lines), spans = list("torture"))
		H.emote("painscream")
		H.confession_time("patron", src)

/mob/living/carbon/human/proc/confession_time(confession_type = "antag", mob/living/carbon/human/user)
	var/timerid = addtimer(CALLBACK(src, PROC_REF(confess_sins), confession_type, FALSE, user), 10 SECONDS, TIMER_STOPPABLE)
	var/static/list/options = list("RESIST!!", "CONFESS!!")
	var/responsey = browser_input_list(src, "Resist torture?", "TEST OF PAIN", options)

	if(SStimer.timer_id_dict[timerid])
		deltimer(timerid)
	else
		to_chat(src, span_warning("Too late..."))
		return
	if(responsey == "RESIST!!")
		confess_sins(confession_type, resist=TRUE, interrogator=user)
	else
		confess_sins(confession_type, resist=FALSE, interrogator=user)

/mob/living/carbon/human/proc/confess_sins(confession_type = "antag", resist, mob/living/carbon/human/interrogator, torture=TRUE, obj/item/paper/inqslip/confession/confession_paper, false_result)
	if(stat == DEAD)
		return
	var/static/list/innocent_lines = list(
		"I DON'T KNOW!",
		"STOP THIS MADNESS!!",
		"I DON'T DESERVE THIS!",
		"THE PAIN!",
		"I HAVE NOTHING TO SAY...!",
		"WHY ME?!",
		"I'M INNOCENT!",
		"I AM NO SINNER!",
	)
	var/resist_chance = 0
	var/false_confession_chance = 0
	var/is_innocent = TRUE

	if(resist)
		to_chat(src, span_boldwarning("I attempt to resist the torture!"))
		resist_chance = (STAINT + STAEND) + 10
		if(istype(buckled, /obj/structure/fluff/walldeco/chains))
			resist_chance -= 15
		if(confession_type == "antag")
			resist_chance += 25

	// Check if they're actually guilty
	if(confession_type == "antag")
		for(var/datum/antagonist/antag in mind?.antag_datums)
			if(length(antag.confess_lines))
				is_innocent = FALSE
				break
	else if(confession_type == "patron")
		if(ispath(false_result, /datum/patron))
			is_innocent = FALSE
		else if(length(patron?.confess_lines))
			is_innocent = FALSE

	// Calculate false confession chance for innocents under torture
	if(is_innocent && !resist)
		false_confession_chance = 100 - (STAINT + STAEND) // Low willpower = higher chance to falsely confess
		false_confession_chance = CLAMP(false_confession_chance, 20, 80) // Between 20-80%

	if(HAS_TRAIT(src, TRAIT_TORTURED))
		false_confession_chance = 0
		resist_chance = 0

	if(!prob(resist_chance))
		var/list/confessions = list()
		var/datum/antag_type = null
		var/is_false_confession = FALSE

		switch(confession_type)
			if("antag")
				if(!false_result)
					for(var/datum/antagonist/antag in mind?.antag_datums)
						if(!length(antag.confess_lines))
							continue
						confessions += antag.confess_lines
						antag_type = antag.type
						break

					// If innocent and failed to resist, chance of false confession
					if(!length(confessions) && prob(false_confession_chance))
						is_false_confession = TRUE
						// Pick a random antag type to falsely confess to
						var/static/list/false_antag_types = list(
							/datum/antagonist/bandit,
							/datum/antagonist/maniac,
							/datum/antagonist/zizocultist
						)
						antag_type = pick(false_antag_types)
						confessions += list("I... I AM GUILTY!", "YES! I CONFESS!", "I DID IT!")

			if("patron")
				if(ispath(false_result, /datum/patron))
					var/datum/patron/fake_patron = new false_result()
					if(length(fake_patron.confess_lines))
						confessions += fake_patron.confess_lines
						antag_type = fake_patron.type
				else
					if(length(patron?.confess_lines))
						confessions += patron.confess_lines
						antag_type = patron.type

					// If innocent and failed to resist, chance of false confession
					if(!length(confessions) && prob(false_confession_chance))
						is_false_confession = TRUE
						var/static/list/false_patron_types = list(
							/datum/patron/inhumen/matthios,
							/datum/patron/inhumen/zizo,
							/datum/patron/inhumen/graggar
						)
						antag_type = pick(false_patron_types)
						confessions += list("I WORSHIP THE FORBIDDEN!", "I FOLLOW THE DARK PATH!", "I AM A HERETIC!")

		// Apply stress penalties for torturing innocents/faithful
		if(torture && interrogator && confession_type == "patron")
			var/datum/patron/interrogator_patron = interrogator.patron
			var/datum/patron/victim_patron = patron
			switch(interrogator_patron.associated_faith.type)
				if(/datum/faith/psydon)
					if(ispath(victim_patron.type, /datum/patron/divine) && victim_patron.type != /datum/patron/divine/necra)
						interrogator.add_stress(/datum/stress_event/torture_small_penalty)
					else if(victim_patron.type == /datum/patron/godless/naivety)
						interrogator.add_stress(/datum/stress_event/torture_small_penalty)
					else if(istype(victim_patron, /datum/patron/psydon))
						interrogator.add_stress(/datum/stress_event/torture_large_penalty)

		if(length(confessions))
			if(torture)
				say(pick(confessions), spans = list("torture"), forced = TRUE)
			else
				say(pick(confessions), forced = TRUE)

			var/obj/item/paper/inqslip/confession/held_confession
			if(istype(confession_paper))
				held_confession = confession_paper
			else if(interrogator?.is_holding_item_of_type(/obj/item/paper/inqslip/confession))
				held_confession = interrogator.is_holding_item_of_type(/obj/item/paper/inqslip/confession)

			if(held_confession && !held_confession.signed)
				// Mark if this is a false confession
				if(is_false_confession)
					held_confession.false_confession = TRUE
					to_chat(interrogator, span_danger("Something seems off about this confession..."))

				switch(antag_type)
					if(/datum/antagonist/bandit)
						held_confession.bad_type = "AN OUTLAW OF THE THIEF-LORD"
						held_confession.antag = initial(antag_type:name)
					if(/datum/patron/inhumen/matthios)
						held_confession.bad_type = "A FOLLOWER OF THE THIEF-LORD"
						held_confession.antag = "worshiper of " + initial(antag_type:name)
					if(/datum/antagonist/maniac)
						held_confession.bad_type = "A MANIAC DELUDED BY MADNESS"
						held_confession.antag = initial(antag_type:name)
					if(/datum/antagonist/assassin)
						held_confession.bad_type = "A DEATH CULTIST"
						held_confession.antag = initial(antag_type:name)
					if(/datum/antagonist/zizocultist)
						held_confession.bad_type = "A SERVANT OF THE FORBIDDEN ONE"
						held_confession.antag = initial(antag_type:name)
					if(/datum/antagonist/zizocultist/leader)
						held_confession.bad_type = "A SERVANT OF THE FORBIDDEN ONE"
						held_confession.antag = initial(antag_type:name)
					if(/datum/patron/inhumen/zizo)
						held_confession.bad_type = "A FOLLOWER OF THE FORBIDDEN ONE"
						held_confession.antag = "worshiper of " + initial(antag_type:name)
					if(/datum/antagonist/werewolf)
						var/datum/antagonist/werewolf/werewolf_antag = mind.has_antag_datum(/datum/antagonist/werewolf, TRUE)
						if(werewolf_antag.transformed)
							return
						held_confession.bad_type = "A BEARER OF DENDOR'S CURSE"
						held_confession.antag = initial(antag_type:name)
					if(/datum/antagonist/werewolf/lesser)
						var/datum/antagonist/werewolf/werewolf_antag = mind.has_antag_datum(/datum/antagonist/werewolf, TRUE)
						if(werewolf_antag.transformed)
							return
						held_confession.bad_type = "A BEARER OF DENDOR'S CURSE"
						held_confession.antag = initial(antag_type:name)
					if(/datum/antagonist/vampire)
						held_confession.bad_type = "A SCION OF KAINE"
						held_confession.antag = initial(antag_type:name)
					if(/datum/antagonist/vampire/lord)
						held_confession.bad_type = "THE BLOOD-LORD OF VANDERLIN"
						held_confession.antag = initial(antag_type:name)
					if(/datum/antagonist/vampire/lords_spawn)
						held_confession.bad_type = "AN UNDERLING OF THE BLOOD-LORD"
						held_confession.antag = initial(antag_type:name)
					if(/datum/patron/inhumen/graggar)
						held_confession.bad_type = "A FOLLOWER OF THE DARK SUN"
						held_confession.antag = "worshiper of " + initial(antag_type:name)
					if(/datum/patron/godless/godless)
						held_confession.bad_type = "A DAMNED ANTI-THEIST"
						held_confession.antag = "worshiper of nothing"
					if(/datum/patron/godless/autotheist)
						held_confession.bad_type = "A DELUSIONAL SELF-PROCLAIMED GOD"
						held_confession.antag = "worshiper of nothing"
					if(/datum/patron/godless/defiant)
						held_confession.bad_type = "A DAMNED CHAINBREAKER"
						held_confession.antag = "worshiper of nothing"
					if(/datum/patron/godless/dystheist)
						held_confession.bad_type = "A SPURNER OF THE DIVINE"
						held_confession.antag = "worshiper of nothing"
					if(/datum/patron/godless/naivety)
						held_confession.bad_type = "A IGNORANT FOOL"
						held_confession.antag = "worshiper of nothing"
					if(/datum/patron/godless/rashan)
						held_confession.bad_type = "A FOLLOWER OF A FALSE GOD"
						held_confession.antag = "worshiper of the false god, Rashan-Kahl"
					if(/datum/patron/godless/galadros)
						held_confession.bad_type = "A WORSHIPPER OF THE DRACONIC"
						held_confession.antag = "worshiper of the false god, Galadros"
					if(/datum/patron/inhumen/baotha)
						held_confession.bad_type = "A FOLLOWER OF THE REMORSELESS RUINER"
						held_confession.antag = "worshiper of " + initial(antag_type:name)
					else
						return

				if(HAS_TRAIT_FROM(src, TRAIT_CONFESSED_FOR, held_confession.bad_type))
					say("I have confessed!", forced = TRUE)
					return
				ADD_TRAIT(src, TRAIT_HAS_CONFESSED, TRAIT_GENERIC)
				ADD_TRAIT(src, TRAIT_CONFESSED_FOR, held_confession.bad_type)
			return
		else
			if(torture)
				say(pick(innocent_lines), spans = list("torture"), forced = TRUE)
			else
				say(pick(innocent_lines), forced = TRUE)
			return
	to_chat(src, span_good("I resist the torture!"))
	say(pick(innocent_lines), spans = list("torture"), forced = TRUE)
	return

/datum/job/advclass/puritan
	exp_types_granted = list(EXP_TYPE_INQUISITION, EXP_TYPE_COMBAT, EXP_TYPE_LEADERSHIP)
