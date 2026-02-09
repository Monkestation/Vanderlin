GLOBAL_LIST_EMPTY(letters_sent)

/obj/structure/fake_machine/mail
	name = "HERMES"
	desc = "Carrier zads have fallen severely out of fashion ever since the advent of this hydropneumatic mail system."
	icon = 'icons/roguetown/misc/machines.dmi'
	icon_state = "mail"
	density = FALSE
	blade_dulling = DULLING_BASH
	SET_BASE_PIXEL(0, 32)
	var/coin_loaded = FALSE
	var/inqcoins = 0
	var/inqonly = FALSE // Has the Inquisitor locked Marque-spending for lessers?
	var/keycontrol = "puritan"
	var/cat_current = "1"
	var/list/all_category = list(
		"RELIQUARY",
		"SUPPLIES",
		"ARTICLES",
		"EQUIPMENT",
		"WARDROBE"
	)
	var/list/category = list(
		"SUPPLIES",
		"ARTICLES",
		"EQUIPMENT",
		"WARDROBE"
	)
	var/list/inq_category = list("RELIQUARY")
	var/ournum
	var/mailtag
	var/obfuscated = FALSE

/obj/structure/fake_machine/mail/Initialize()
	. = ..()
	SSroguemachine.hermailers += src
	ournum = SSroguemachine.hermailers.len
	name = "[name] #[ournum]"
	update_appearance()

/obj/structure/fake_machine/mail/Destroy()
	set_light(0)
	SSroguemachine.hermailers -= src
	return ..()

/obj/structure/fake_machine/mail/attack_hand(mob/user)
	if(SSroguemachine.hermailermaster && ishuman(user))
		var/obj/item/fake_machine/mastermail/M = SSroguemachine.hermailermaster
		var/mob/living/carbon/human/H = user
		var/addl_mail = FALSE
		for(var/obj/item/I in M.contents)
			if(I.mailedto == H.real_name)
				if(!addl_mail)
					I.forceMove(src.loc)
					user.put_in_hands(I)
					addl_mail = TRUE
				else
					say("You have additional mail available.")
					break
	if(!ishuman(user))
		return
	if(HAS_TRAIT(user, TRAIT_INQUISITION))
		if(!coin_loaded && !inqcoins)
			to_chat(user, span_notice("It needs a Marque."))
			return
		user.changeNext_move(CLICK_CD_MELEE)
		display_marquette(usr)

/obj/structure/fake_machine/mail/examine(mob/user)
	. = ..()
	. += span_info("Load a coin inside, then right click to send a letter.")
	. += span_info("Left click with a paper to send a prewritten letter for free.")
	if(HAS_TRAIT(user, TRAIT_INQUISITION))
		. += span_info("<br>The Oratorium's reliquary can be accessed via a secret compartment fitted within the HERMES. Load a Marque to access it.")

		. += span_info("You can send arrival slips, accusation slips, fully loaded INDEXERs or confessions here.")
		. += span_info("Properly sign them. Include an INDEXER where needed. Stamp them for two additional Marques.")

/obj/structure/fake_machine/mail/attack_hand_secondary(mob/user, list/modifiers)
	. = ..()
	if(. == SECONDARY_ATTACK_CANCEL_ATTACK_CHAIN)
		return
	user.changeNext_move(6)
	if(!coin_loaded)
		to_chat(user, span_warning("The machine doesn't respond. It needs a coin."))
		return
	if(inqcoins)
		to_chat(user, span_warning("The machine doesn't respond."))
		return
	var/send2place = browser_input_text(user, "Where to? (Person or #number)")
	if(!send2place)
		return
	var/sentfrom = browser_input_text(user, "Who is this letter from?")
	if(!sentfrom)
		sentfrom = "Anonymous"
	var/t = stripped_multiline_input("Write Your Letter", "VANDERLIN", no_trim=TRUE)
	if(t)
		if(length(t) > 2000)
			to_chat(user, span_warning("Too long. Try again."))
			return
	if(!coin_loaded)
		return
	if(!Adjacent(user))
		return
	var/obj/item/paper/P = new
	P.info += t
	P.mailer = sentfrom
	P.mailedto = send2place
	P.update_appearance()
	if(findtext(send2place, "#"))
		var/box2find = text2num(copytext(send2place, findtext(send2place, "#")+1))
		var/found = FALSE
		for(var/obj/structure/fake_machine/mail/X in SSroguemachine.hermailers)
			if(X.ournum == box2find)
				found = TRUE
				P.mailer = sentfrom
				P.mailedto = send2place
				P.update_appearance()
				P.forceMove(X.loc)
				X.say("New mail!")
				playsound(X, 'sound/misc/mail.ogg', 100, FALSE, -1)
				break
		if(found)
			if(P.info)
				var/stripped_info = remove_color_tags(P.info)
				GLOB.letters_sent |= stripped_info

			visible_message(span_warning("[user] sends something."))
			playsound(src, 'sound/misc/disposalflush.ogg', 100, FALSE, -1)
			SStreasury.give_money_treasury(coin_loaded, "Mail Income")
			coin_loaded = FALSE
			update_appearance()
			return
		else
			to_chat(user, span_warning("Failed to send it. Bad number?"))
	else
		if(!send2place)
			return
		if(SSroguemachine.hermailermaster)
			var/obj/item/fake_machine/mastermail/X = SSroguemachine.hermailermaster
			P.mailer = sentfrom
			P.mailedto = send2place
			P.update_appearance()
			P.forceMove(X.loc)
			var/datum/component/storage/STR = X.GetComponent(/datum/component/storage)
			STR.handle_item_insertion(P, prevent_warning=TRUE)
			X.new_mail=TRUE
			X.update_appearance()
			send_ooc_note("New letter from <b>[sentfrom].</b>", name = send2place)
			for(var/mob/living/carbon/human/H in GLOB.human_list)
				if(H.real_name == send2place)
					H.playsound_local(H, 'sound/misc/mail.ogg', 100, FALSE, -1)
		else
			to_chat(user, span_warning("The master of mails has perished?"))
			return
		if(P.info)
			var/stripped_info = remove_color_tags(P.info)
			GLOB.letters_sent |= stripped_info
		visible_message(span_warning("[user] sends something."))
		playsound(src, 'sound/misc/disposalflush.ogg', 100, FALSE, -1)
		SStreasury.give_money_treasury(coin_loaded, "Mail")
		coin_loaded = FALSE
		update_appearance(UPDATE_OVERLAYS)

/obj/structure/fake_machine/mail/attackby(obj/item/P, mob/user, list/modifiers)
	if(istype(P, /obj/item/merctoken))
		return handle_merctoken(P, user)

	// Inquisition Key Handling
	if(HAS_TRAIT(user, TRAIT_INQUISITION))
		if(istype(P, /obj/item/key))
			return handle_inquisition_key(P, user)
		if(istype(P, /obj/item/storage/keyring))
			return handle_keyring(P, user)

	// Inquisition Items (must have TRAIT_INQUISITION or TRAIT_PURITAN)
	if(HAS_TRAIT(user, TRAIT_INQUISITION) || HAS_TRAIT(user, TRAIT_PURITAN))
		if(istype(P, /obj/item/inqarticles/bmirror))
			return handle_broken_mirror(P, user)
		if(istype(P, /obj/item/paper/inqslip/confession))
			return handle_confession(P, user)
		if(istype(P, /obj/item/inqarticles/indexer))
			return handle_indexer(P, user)
		if(istype(P, /obj/item/paper/inqslip/arrival))
			return handle_arrival_slip(P, user)
		if(istype(P, /obj/item/paper/inqslip/accusation))
			return handle_accusation(P, user)

	// Regular Mail
	if(istype(P, /obj/item/paper))
		return handle_paper_mail(P, user)

	// Coin Handling
	if(istype(P, /obj/item/coin/inqcoin))
		return handle_inq_coin(P, user)
	if(istype(P, /obj/item/coin))
		return handle_regular_coin(P, user)

	return ..()

/obj/structure/fake_machine/mail/proc/handle_merctoken(obj/item/merctoken/token, mob/user)
	if(!ishuman(user))
		to_chat(user, span_warning("I do not know what this is, and I do not particularly care."))
		return

	var/mob/living/carbon/human/H = user

	// Check job restrictions
	if(is_merchant_job(H.mind.assigned_role) || is_gaffer_job(H.mind.assigned_role))
		to_chat(H, span_warning("This is of no use to me - I may give this to a mercenary so they may send it themselves."))
		return

	if(!is_mercenary_job(H.mind.assigned_role))
		to_chat(H, span_warning("I can't make use of this - I do not belong to the Guild."))
		return

	if(H.tokenclaimed)
		to_chat(H, span_warning("I have already received my commendation. There's always next month to look forward to."))
		return

	if(!token.signee)
		to_chat(H, span_warning("I cannot send an unsigned token."))
		return

	// Process the token
	qdel(token)
	visible_message(span_warning("[H] sends something."))
	playsound(src, 'sound/misc/disposalflush.ogg', 100, FALSE, -1)

	sleep(2 SECONDS)

	say("THANK YOU FOR YOUR SERVITUDE.")
	playsound(src, 'sound/misc/mercsuccess.ogg', 100, FALSE, -1)
	playsound(src, 'sound/misc/hiss.ogg', 100, FALSE, -1)
	to_chat(H, span_warning("A trinket comes tumbling down from the machine. Proof of your distinction."))

	H.adjust_triumphs(3)
	H.tokenclaimed = TRUE

	// Award appropriate medal
	var/turf/drop_location = drop_location()
	switch(H.merctype)
		if(0) new /obj/item/clothing/neck/shalal(drop_location)
		if(1) new /obj/item/clothing/neck/mercmedal/zaladin(drop_location)
		if(2) new /obj/item/clothing/neck/mercmedal/grenzelhoft(drop_location)
		if(3) new /obj/item/clothing/neck/mercmedal/underdweller(drop_location)
		if(4) new /obj/item/clothing/neck/mercmedal/blackoak(drop_location)
		if(5) new /obj/item/clothing/neck/mercmedal/steppesman(drop_location)
		if(6) new /obj/item/clothing/neck/mercmedal/boltslinger(drop_location)
		if(7) new /obj/item/clothing/neck/mercmedal/anthrax(drop_location)
		if(8) new /obj/item/clothing/neck/mercmedal/duelist(drop_location)
		if(9) new /obj/item/clothing/neck/mercmedal(drop_location)
		if(10) new /obj/item/clothing/neck/mercmedal/abyssal(drop_location)
		if(11) new /obj/item/clothing/neck/mercmedal/goldfeather(drop_location)

/obj/structure/fake_machine/mail/proc/handle_inquisition_key(obj/item/key/K, mob/user)
	if(keycontrol in K.lockids)
		playsound(src, 'sound/misc/beep.ogg', 100, FALSE, -1)
		for(var/obj/structure/fake_machine/mail/hermes in SSroguemachine.hermailers)
			hermes.inqlock()
		to_chat(user, span_warning("I [inqonly ? "enable" : "disable"] the Puritan's Lock."))
		display_marquette(user)
		return TRUE

	to_chat(user, span_warning("Wrong key."))
	return TRUE

/obj/structure/fake_machine/mail/proc/handle_keyring(obj/item/storage/keyring/K, mob/user)
	if(!K.contents.len)
		return

	for(var/obj/item/key/key in K.contents)
		if(keycontrol in key.lockids)
			playsound(src, 'sound/misc/beep.ogg', 100, FALSE, -1)
			for(var/obj/structure/fake_machine/mail/hermes in SSroguemachine.hermailers)
				hermes.inqlock()
			to_chat(user, span_warning("I [inqonly ? "enable" : "disable"] the Puritan's Lock."))
			display_marquette(user)
			return TRUE

/obj/structure/fake_machine/mail/proc/handle_broken_mirror(obj/item/inqarticles/bmirror/mirror, mob/user)
	if(mirror.broken && !mirror.bloody)
		visible_message(span_warning("[user] sends something."))
		budget2change(2, user, "MARQUE")
		qdel(mirror)
		GLOB.vanderlin_round_stats[STATS_MARQUES_MADE] += 2
		playsound(src, 'sound/misc/otavanlament.ogg', 100, FALSE, -1)
		playsound(src, 'sound/misc/disposalflush.ogg', 100, FALSE, -1)
	else
		if(!mirror.broken)
			to_chat(user, span_warning("It isn't broken."))
		else if(mirror.bloody)
			to_chat(user, span_warning("Clean it first."))

/obj/structure/fake_machine/mail/proc/handle_confession(obj/item/paper/inqslip/confession/confession, mob/living/carbon/human/user)
	if(!confession.signee || !confession.signed)
		return

	var/is_duplicate = FALSE
	var/is_accused = FALSE
	var/is_indexed = FALSE
	var/is_selfreport = FALSE
	var/is_correct = !confession.false_confession

	// Check if confessor is inquisition member
	if(HAS_TRAIT(confession.signee, TRAIT_INQUISITION))
		is_selfreport = TRUE

	// Check if confessor is actually guilty
	if(HAS_TRAIT(confession.signee, TRAIT_CABAL))
		is_correct = TRUE

	if(confession.signee.name in GLOB.excommunicated_players)
		is_correct = TRUE

	// Check paired indexer
	if(confession.paired)
		if(HAS_TRAIT(confession.paired.subject, TRAIT_INQUISITION))
			is_selfreport = TRUE
			is_indexed = TRUE

		if(confession.paired.subject && confession.paired.full && GLOB.indexed && !is_selfreport)
			if(check_global_list(GLOB.indexed, confession.signee))
				is_indexed = TRUE
			else
				add_to_global_list(GLOB.indexed, confession.signee)

	// Check if already accused
	if(GLOB.accused && !is_selfreport)
		is_accused = check_global_list(GLOB.accused, confession.signee)

	// Check if already confessed
	if(GLOB.confessors && !is_selfreport)
		is_duplicate = check_global_list(GLOB.confessors, confession.signee)
		if(!is_duplicate)
			add_to_global_list(GLOB.confessors, confession.signee)

	// Handle rejections
	if(is_duplicate || is_selfreport)
		cleanup_confession(confession, user)

		if(is_duplicate)
			to_chat(user, span_notice("They've already confessed."))
		else if(is_selfreport)
			to_chat(user, span_notice("Why was that confession signed by an inquisition member? What?"))
			if(is_indexed)
				visible_message(span_warning("[user] receives something."))
				var/obj/item/inqarticles/indexer/replacement = new /obj/item/inqarticles/indexer/
				user.put_in_hands(replacement)
		return

	// Calculate marque value
	var/marque_value = confession.marquevalue
	if(confession.false_confession)
		var/mob/living/carbon/human/human = confession.signee
		if(human)
			human.inquisition_position.merits -= 4
		to_chat(user, span_notice("To lie to the church is a sin my son, do not do it again."))

	else if(confession.paired && !is_indexed && !is_correct)
		marque_value = 2
		GLOB.vanderlin_round_stats[STATS_MARQUES_MADE] += 2
		budget2change(marque_value, user, "MARQUE")
	else if(is_correct)
		if(confession.paired && !is_indexed)
			marque_value += 2
		if(is_accused)
			marque_value -= 4

		GLOB.vanderlin_round_stats[STATS_MARQUES_MADE] += marque_value
		user.inquisition_position.merits += CEILING(marque_value * 0.5, 1)
		budget2change(marque_value, user, "MARQUE")

	// Accept confession
	cleanup_confession(confession, user)
	playsound(src, 'sound/misc/otavanlament.ogg', 100, FALSE, -1)

/obj/structure/fake_machine/mail/proc/cleanup_confession(obj/item/paper/inqslip/confession/confession, mob/user)
	if(confession.paired)
		qdel(confession.paired)
	qdel(confession)
	visible_message(span_warning("[user] sends something."))
	playsound(src, 'sound/misc/disposalflush.ogg', 100, FALSE, -1)


/obj/structure/fake_machine/mail/proc/handle_indexer(obj/item/inqarticles/indexer/indexer, mob/living/carbon/human/user)
	var/mob/living/subject = indexer.subject?.resolve()
	// Handle cursed blood samples
	if(indexer.cursedblood)
		var/is_duplicate = FALSE

		if(GLOB.cursedsamples)
			if(subject)
				is_duplicate = check_global_list(GLOB.cursedsamples, subject.mind)
				if(!is_duplicate)
					add_to_global_list(GLOB.cursedsamples, subject.mind)

		if(is_duplicate)
			qdel(indexer)
			visible_message(span_warning("[user] sends something."))
			playsound(src, 'sound/misc/disposalflush.ogg', 100, FALSE, -1)
			visible_message(span_warning("[user] receives something."))
			to_chat(user, span_notice("We've already collected a sample of their accursed blood."))
			var/obj/item/inqarticles/indexer/replacement = new /obj/item/inqarticles/indexer(get_turf(user))
			user.put_in_hands(replacement)
		else
			var/marque_value = indexer.cursedblood * 2 + 2
			budget2change(marque_value, user, "MARQUE")
			GLOB.vanderlin_round_stats[STATS_MARQUES_MADE] += marque_value
			qdel(indexer)
			visible_message(span_warning("[user] sends something."))
			playsound(src, 'sound/misc/otavanlament.ogg', 100, FALSE, -1)
			playsound(src, 'sound/misc/disposalflush.ogg', 100, FALSE, -1)
		return

	// Handle regular indexing
	if(subject && indexer.full)
		var/is_duplicate = FALSE
		var/is_selfreport = FALSE

		if(HAS_TRAIT(subject, TRAIT_INQUISITION))
			is_selfreport = TRUE

		if(GLOB.indexed && !is_selfreport)
			is_duplicate = check_global_list(GLOB.indexed, subject)
			if(!is_duplicate)
				add_to_global_list(GLOB.indexed, subject)

		if(is_duplicate || is_selfreport)
			qdel(indexer)
			visible_message(span_warning("[user] sends something."))
			playsound(src, 'sound/misc/disposalflush.ogg', 100, FALSE, -1)
			visible_message(span_warning("[user] receives something."))

			if(is_selfreport)
				to_chat(user, span_notice("Why did that INDEXER contain Inquisitional blood? What am I doing?"))
			else
				to_chat(user, span_notice("It appears we already had them INDEXED. I've been issued a replacement."))

			var/obj/item/inqarticles/indexer/replacement = new /obj/item/inqarticles/indexer(get_turf(user))
			user.put_in_hands(replacement)
		else
			budget2change(2, user, "MARQUE")
			GLOB.vanderlin_round_stats[STATS_MARQUES_MADE] += 2
			user.inquisition_position.merits += 1
			qdel(indexer)
			visible_message(span_warning("[user] sends something."))
			playsound(src, 'sound/misc/otavasent.ogg', 100, FALSE, -1)
			playsound(src, 'sound/misc/disposalflush.ogg', 100, FALSE, -1)

/obj/structure/fake_machine/mail/proc/handle_arrival_slip(obj/item/paper/inqslip/arrival/slip, mob/user)
	if(!slip.signee || !slip.signed)
		return

	message_admins("INQ ARRIVAL: [user.real_name] ([user.ckey]) has just arrived as a [user.job], earning [slip.marquevalue] Marques.")
	log_game("INQ ARRIVAL: [user.real_name] ([user.ckey]) has just arrived as a [user.job], earning [slip.marquevalue] Marques.")

	budget2change(slip.marquevalue, user, "MARQUE")
	GLOB.vanderlin_round_stats[STATS_MARQUES_MADE] += slip.marquevalue
	qdel(slip)

	visible_message(span_warning("[user] sends something."))
	playsound(src, 'sound/misc/otavasent.ogg', 100, FALSE, -1)
	playsound(src, 'sound/misc/disposalflush.ogg', 100, FALSE, -1)

/obj/structure/fake_machine/mail/proc/handle_accusation(obj/item/paper/inqslip/accusation/accusation, mob/living/carbon/human/user)
	if(!accusation.paired)
		to_chat(user, span_warning("[accusation] is missing an INDEXER."))
		return

	if(!accusation.signee || !accusation.paired.full || !accusation.paired.subject)
		if(!accusation.paired.full)
			to_chat(user, span_warning("[accusation.paired] needs to be full of the accused's blood."))
		else
			to_chat(user, span_warning("[accusation] is missing a signature."))
		return

	var/is_duplicate = FALSE
	var/is_confessed = FALSE
	var/is_indexed = FALSE
	var/is_correct = FALSE
	var/is_selfreport = FALSE

	// Check if subject is inquisition member
	if(HAS_TRAIT(accusation.paired.subject, TRAIT_INQUISITION))
		is_selfreport = TRUE

	// Check if subject is cabal member
	if(HAS_TRAIT(accusation.paired.subject, TRAIT_CABAL))
		is_correct = TRUE

	var/mob/living/subject = accusation.paired.subject?.resolve()

	// Check antagonist types
	for(var/datum/antagonist/antag in subject?.mind?.antag_datums)
		switch(antag.type)
			if(/datum/antagonist/bandit, /datum/antagonist/maniac, /datum/antagonist/assassin,
			   /datum/antagonist/zizocultist, /datum/antagonist/zizocultist/leader,
			   /datum/antagonist/werewolf, /datum/antagonist/werewolf/lesser,
			   /datum/antagonist/vampire, /datum/antagonist/vampire/lord, /datum/antagonist/vampire/lords_spawn)
				is_correct = TRUE
				break

	// Check patron types
	if(subject?.patron)
		switch(subject?.patron.type)
			if(/datum/patron/inhumen/matthios, /datum/patron/inhumen/zizo, /datum/patron/inhumen/graggar,
			   /datum/patron/inhumen/baotha, /datum/patron/godless/godless, /datum/patron/godless/autotheist,
			   /datum/patron/godless/defiant, /datum/patron/godless/dystheist, /datum/patron/godless/rashan,
			   /datum/patron/godless/galadros)
				is_correct = TRUE

	// Check excommunication
	if(subject?.name in GLOB.excommunicated_players)
		is_correct = TRUE

	// Check if already indexed
	if(GLOB.indexed && !is_selfreport)
		is_indexed = check_global_list(GLOB.indexed, accusation.paired.subject)
		if(!is_indexed)
			add_to_global_list(GLOB.indexed, accusation.paired.subject)

	// Check if already accused
	if(GLOB.accused && !is_selfreport)
		is_duplicate = check_global_list(GLOB.accused, accusation.paired.subject)
		if(!is_duplicate)
			add_to_global_list(GLOB.accused, accusation.paired.subject)

	// Check if already confessed
	if(GLOB.confessors && !is_selfreport)
		if(check_global_list(GLOB.confessors, accusation.paired.subject))
			is_duplicate = TRUE
			is_confessed = TRUE

	// Handle rejections
	if(is_duplicate || is_selfreport)
		QDEL_NULL(accusation.paired) // do this before the paper so it isn't cleared
		QDEL_NULL(accusation)
		visible_message(span_warning("[user] sends something."))
		playsound(src, 'sound/misc/disposalflush.ogg', 100, FALSE, -1)

		if(is_confessed)
			to_chat(user, span_notice("They've confessed."))
		else if(is_selfreport)
			to_chat(user, span_notice("Why are we accusing our own? What have we come to?"))
			var/obj/item/inqarticles/indexer/replacement = new /obj/item/inqarticles/indexer(get_turf(user))
			user.put_in_hands(replacement)
		else
			to_chat(user, span_notice("They've already been accused."))
		return

	// Calculate marque value
	if(is_correct)
		var/marque_value = accusation.marquevalue
		if(!is_indexed)
			marque_value += 2

		budget2change(marque_value, user, "MARQUE")
		GLOB.vanderlin_round_stats[STATS_MARQUES_MADE] += marque_value
		user.inquisition_position.merits += CEILING(marque_value * 0.5, 1)

	qdel(accusation.paired)
	qdel(accusation)
	visible_message(span_warning("[user] sends something."))
	playsound(src, 'sound/misc/otavanlament.ogg', 100, FALSE, -1)
	playsound(src, 'sound/misc/disposalflush.ogg', 100, FALSE, -1)

/obj/structure/fake_machine/mail/proc/handle_paper_mail(obj/item/paper/paper, mob/user)
	if(inqcoins)
		to_chat(user, span_warning("The machine doesn't respond."))
		return

	if(alert(user, "Send Mail?",,"YES","NO") != "YES")
		return

	var/send_to = browser_input_text(user, "Where to? (Person or #number)", "Vanderlin", null)
	if(!send_to)
		return

	var/sent_from = browser_input_text(user, "Who is this from?", "Vanderlin", null)
	if(!sent_from)
		sent_from = "Anonymous"

	// Handle box number sending
	if(findtext(send_to, "#"))
		var/box_num = text2num(copytext(send_to, findtext(send_to, "#")+1))
		var/found = FALSE

		for(var/obj/structure/fake_machine/mail/mailbox in SSroguemachine.hermailers)
			if(mailbox.ournum == box_num)
				found = TRUE
				paper.mailer = sent_from
				paper.mailedto = send_to
				paper.update_appearance()
				paper.forceMove(mailbox.loc)
				mailbox.say("New mail!")
				playsound(mailbox, 'sound/misc/mail.ogg', 100, FALSE, -1)
				break

		if(found)
			if(paper.info)
				GLOB.letters_sent |= remove_color_tags(paper.info)
			visible_message(span_warning("[user] sends something."))
			playsound(src, 'sound/misc/disposalflush.ogg', 100, FALSE, -1)
		else
			to_chat(user, span_warning("Cannot send it. Bad number?"))
		return

	// Handle person name sending
	if(!SSroguemachine.hermailermaster)
		to_chat(user, span_warning("The master of mails has perished?"))
		return

	var/obj/item/fake_machine/mastermail/master = SSroguemachine.hermailermaster
	paper.mailer = sent_from
	paper.mailedto = send_to
	paper.update_appearance()
	paper.forceMove(master.loc)

	var/datum/component/storage/STR = master.GetComponent(/datum/component/storage)
	STR.handle_item_insertion(paper, prevent_warning=TRUE)
	master.new_mail = TRUE
	master.update_appearance()
	playsound(src, 'sound/misc/mail.ogg', 100, FALSE, -1)

	if(paper.info)
		GLOB.letters_sent |= remove_color_tags(paper.info)

	visible_message(span_warning("[user] sends something."))
	playsound(src, 'sound/misc/disposalflush.ogg', 100, FALSE, -1)
	send_ooc_note("New letter from <b>[sent_from].</b>", name = send_to)

	for(var/mob/living/carbon/human/H in GLOB.human_list)
		if(H.real_name == send_to)
			H.playsound_local(H, 'sound/misc/mail.ogg', 100, FALSE, -1)

/obj/structure/fake_machine/mail/proc/handle_inq_coin(obj/item/coin/inqcoin/coin, mob/user)
	if(!HAS_TRAIT(user, TRAIT_INQUISITION))
		return

	if(coin_loaded && !inqcoins)
		return

	coin_loaded = TRUE
	inqcoins += coin.quantity
	update_appearance()
	qdel(coin)
	playsound(src, 'sound/misc/coininsert.ogg', 100, FALSE, -1)
	display_marquette(user)

/obj/structure/fake_machine/mail/proc/handle_regular_coin(obj/item/coin/coin, mob/user)
	if(coin_loaded)
		return

	if(coin.quantity > 1)
		return

	coin_loaded = coin.get_real_price()
	qdel(coin)
	playsound(src, 'sound/misc/coininsert.ogg', 100, FALSE, -1)
	update_appearance()


/obj/structure/fake_machine/mail/proc/check_global_list(list/global_list, subject) //! shitter proc
	if(", [subject]" in global_list)
		return TRUE
	if("[subject]" in global_list)
		return TRUE
	return FALSE

/obj/structure/fake_machine/mail/proc/add_to_global_list(list/global_list, subject) //! shitter proc
	if(length(global_list))
		global_list += ", [subject]"
	else
		global_list += "[subject]"

/obj/structure/fake_machine/mail/r
	SET_BASE_PIXEL(32, 0)

/obj/structure/fake_machine/mail/l
	SET_BASE_PIXEL(-32, 0)

/obj/structure/fake_machine/mail/update_overlays()
	. = ..()
	cut_overlays()
	if(coin_loaded)
		if(inqcoins > 0)
			. += mutable_appearance(icon, "mail-i")
			set_light(1, 1, 1, l_color = "#ffffff")
		else
			. += mutable_appearance(icon, "mail-f")
			set_light(1, 1, 1, l_color = "#1b7bf1")
	else
		. += mutable_appearance(icon, "mail-s")
		set_light(1, 1, 1, l_color = "#ff0d0d")

/obj/structure/fake_machine/mail/examine(mob/user)
	. = ..()
	. += "<a href='?src=[REF(src)];directory=1'>Directory:</a> [mailtag]"

/obj/structure/fake_machine/mail/Topic(href, href_list)
	..()

	if(!usr)
		return

	if(href_list["directory"])
		view_directory(usr)

/obj/structure/fake_machine/mail/proc/view_directory(mob/user)
	var/dat
	for(var/obj/structure/fake_machine/mail/X in SSroguemachine.hermailers)
		if(X.obfuscated)
			continue
		if(X.mailtag)
			dat += "#[X.ournum] [X.mailtag]<br>"
		else
			dat += "#[X.ournum] [capitalize(get_area_name(X))]<br>"

	var/datum/browser/popup = new(user, "hermes_directory", "<center>HERMES DIRECTORY</center>", 387, 420)
	popup.set_content(dat)
	popup.open(FALSE)

/obj/item/fake_machine/mastermail
	name = "MASTER OF MAILS"
	icon = 'icons/roguetown/misc/machines.dmi'
	icon_state = "mailspecial"
	SET_BASE_PIXEL(0, 32)
	max_integrity = 0
	density = FALSE
	blade_dulling = DULLING_BASH
	anchored = TRUE
	w_class = WEIGHT_CLASS_GIGANTIC
	var/new_mail

/obj/item/fake_machine/mastermail/update_icon_state()
	. = ..()
	if(new_mail)
		icon_state = "mailspecial-get"
	else
		icon_state = "mailspecial"
	set_light(1, 1, 1, l_color = "#ff0d0d")

/obj/item/fake_machine/mastermail/attack_hand(mob/user)
	var/datum/component/storage/CP = GetComponent(/datum/component/storage)
	if(CP)
		if(new_mail)
			new_mail = FALSE
			update_appearance()
		return TRUE

/obj/item/fake_machine/mastermail/Initialize()
	. = ..()
	AddComponent(/datum/component/storage/concrete/grid/mailmaster)
	SSroguemachine.hermailermaster = src
	update_appearance()

/obj/item/fake_machine/mastermail/attackby(obj/item/P, mob/user, list/modifiers)
	if(istype(P, /obj/item/paper))
		var/obj/item/paper/PA = P
		if(!PA.mailer && !PA.mailedto && PA.cached_mailer && PA.cached_mailedto)
			PA.mailer = PA.cached_mailer
			PA.mailedto = PA.cached_mailedto
			PA.cached_mailer = null
			PA.cached_mailedto = null
			PA.update_appearance()
			to_chat(user, span_warning("I carefully re-seal the letter and place it back in the machine, no one will know."))
		P.forceMove(loc)
		var/datum/component/storage/STR = GetComponent(/datum/component/storage)
		STR.handle_item_insertion(P, prevent_warning=TRUE)
	..()

/obj/item/fake_machine/mastermail/Destroy()
	set_light(0)
	SSroguemachine.hermailers -= src
	SSroguemachine.hermailermaster = null
	return ..()

/obj/structure/fake_machine/mail/proc/any_additional_mail(obj/item/fake_machine/mastermail/M, name)
	for(var/obj/item/I in M.contents)
		if(I.mailedto == name)
			return TRUE
	return FALSE


/*
	INQUISITION INTERACTIONS - START
*/

/obj/structure/fake_machine/mail/proc/inqlock()
	inqonly = !inqonly

/obj/structure/fake_machine/mail/proc/decreaseremaining(datum/inqports/PA)
	PA.remaining -= 1
	PA.name = "[initial(PA.name)] ([PA.remaining]/[PA.maximum]) - [PA.marquescost]"
	if(!PA.remaining)
		PA.name = "[initial(PA.name)] (OUT OF STOCK) - [PA.marquescost]"
	return

/obj/structure/fake_machine/mail/proc/display_marquette(mob/user)
	var/contents
	contents = "<center>  THE ORATORIUM'S RELIQUARY  <BR>"
	contents += "ERADICATE HERESY, SO THAT PSYDONIA MAY ENDURE <BR>"
	if(HAS_TRAIT(user, TRAIT_PURITAN))
		contents += "  <a href='?src=[REF(src)];locktoggle=1]'> PURITAN'S LOCK: [inqonly ? "YES":"NO"]</a>  <BR>"
	else
		contents += "  PURITAN'S LOCK: [inqonly ? "YES":"NO"]  <BR>"
	contents += "<a href='?src=[REF(src)];eject=1'>MARQUES LOADED: [inqcoins]</a><BR>"

	if(cat_current == "1")
		contents += "<BR> <table style='width: 100%' line-height: 40px;'>"
/*		if(HAS_TRAIT(user, TRAIT_PURITAN))
			for(var/i = 1, i <= inq_category.len, i++)
				contents += "<tr>"
				contents += "<td style='width: 100%; text-align: center;'>\
					<a href='?src=[REF(src)];changecat=[inq_category[i]]'>[inq_category[i]]</a>\
					</td>"
				contents += "</tr>"*/
		for(var/i = 1, i <= category.len, i++)
			contents += "<tr>"
			contents += "<td style='width: 100%; text-align: center;'>\
				<a href='?src=[REF(src)];changecat=[category[i]]'>[category[i]]</a>\
				</td>"
			contents += "</tr>"
		contents += "</table>"
	else
		contents += "<center>[cat_current]<BR></center>"
		contents += "<center><a href='?src=[REF(src)];changecat=1'>\[RETURN\]</a><BR><BR></center>"
		contents += "<center>"
		var/list/items = list()
		for(var/datum/inqports/PA as anything in GLOB.inqsupplies)
			if(all_category[PA.category] == cat_current && PA.name)
				items += GLOB.inqsupplies[PA]
				if(PA.name == "Seizing Garrote" && !HAS_TRAIT(user, TRAIT_BLACKBAGGER))
					items -= GLOB.inqsupplies[PA]
		for(var/datum/inqports/PA as anything in sortNames(items, order=0))
			var/name = uppertext(PA.name)
			if(inqonly && !HAS_TRAIT(user, TRAIT_PURITAN) || (PA.maximum && !PA.remaining) || inqcoins < PA.marquescost)
				contents += "[name]<BR>"
			else
				contents += "<a href='?src=[REF(src)];buy=[PA.type]'>[name]</a><BR>"
		contents += "</center>"
	var/datum/browser/popup = new(user, "VENDORTHING", "", 500, 600)
	popup.set_content(contents)
	if(inqcoins == 0)
		popup.close()
		return
	else
		popup.open()

/obj/structure/fake_machine/mail/Topic(href, href_list)
	..()
	if(href_list["eject"])
		if(inqcoins <= 0)
			return
		coin_loaded = FALSE
		update_appearance()
		budget2change(inqcoins, usr, "MARQUE")
		inqcoins = 0

	if(href_list["changecat"])
		cat_current = href_list["changecat"]

	if(href_list["locktoggle"])
		playsound(src, 'sound/misc/beep.ogg', 100, FALSE, -1)
		for(var/obj/structure/fake_machine/mail/everyhermes in SSroguemachine.hermailers)
			everyhermes.inqlock()

	if(href_list["buy"])
		var/list/spawnable = list()
		for(var/turf/turf as anything in get_adjacent_open_turfs(get_turf(src)))
			if(turf.is_blocked_turf(TRUE, src))
				continue
			spawnable += turf

		if(!length(spawnable))
			return

		var/path = text2path(href_list["buy"])
		var/datum/inqports/PA = GLOB.inqsupplies[path]

		inqcoins -= PA.marquescost
		if(PA.maximum)
			decreaseremaining(PA)
		visible_message(span_warning("[usr] sends something."))
		if(!inqcoins)
			coin_loaded = FALSE
			update_appearance()
		playsound(src, 'sound/misc/disposalflush.ogg', 100, FALSE, -1)

		var/obj/bought = new PA.item_type(pick(spawnable))
		if(isitem(bought))
			usr.put_in_hands(bought, FALSE)

	return display_marquette(usr)

/*
	INQUISITION INTERACTIONS - END
*/
