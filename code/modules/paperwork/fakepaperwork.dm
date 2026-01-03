//N/A write for this shit.
//N/A most of these need checks for reading, even if they don't understand it, it should at least point out they can't

GLOBAL_LIST_EMPTY(Beucratic_triumps)

/obj/item/gold_prick
	name = "GOLDEN PRICK"
	desc = ""
	icon_state = "gold_prick"
	icon = 'icons/roguetown/items/misc.dmi'
	w_class = WEIGHT_CLASS_TINY
	slot_flags = ITEM_SLOT_MOUTH //putting pricks in your mouth might be fun for a bit, just don't go on that second date.
	dropshrink = 0.8
	var/datum/weakref/blood

/obj/item/gold_prick/update_icon_state()
	. = ..()
	if(blood)
		icon_state = "gold_prick_b"
		return
	icon_state = "gold_prick"

/obj/item/gold_prick/attack_self(mob/living/user)
	if(is_gaffer_assistant_job(user.mind.assigned_role))
		to_chat(user, span_warning("No matter how much effort I put into it, I just can't break skin. The tip is too dull!"))
		return
	user.flash_fullscreen("redflash3")
	playsound(user, 'sound/combat/hits/bladed/genstab (1).ogg', 100, FALSE, -1)
	visible_message(span_warning("[user] draws blood with the [src]"))
	if(HAS_TRAIT(user, TRAIT_NOBLE) && !HAS_TRAIT(user, TRAIT_NOPAIN))
		user.emote("painscream")
		to_chat(user, span_warning("THAT BURNS!!"))
	blood = WEAKREF(user)
	update_appearance(UPDATE_ICON_STATE)
	addtimer(CALLBACK(src, PROC_REF(clear_blood)), 1 MINUTES)

/obj/item/gold_prick/attack_hand_secondary(mob/user, params)
	. = ..()
	if(.)
		return
	if(!blood)
		return
	user.changeNext_move(CLICK_CD_MELEE)
	blood = null
	if(HAS_TRAIT(user, TRAIT_BURDEN))
		to_chat(user, span_warning("I pinch the end of the prick and trace my fingers up along it's length, until the only blood left is on my fingers. It dissipates with a quiet gurgle, it was never blood."))
		playsound(src, 'sound/magic/enter_blood.ogg', 30, FALSE, ignore_walls = FALSE)
		user.add_stress(/datum/stress_event/ring_madness)
		update_appearance(UPDATE_ICON_STATE)
		return
	to_chat(user, span_warning("I wipe off the [src]"))
	update_appearance(UPDATE_ICON_STATE)

/obj/item/gold_prick/examine(mob/user)
	. = ..()
	if(HAS_TRAIT(user, TRAIT_BURDEN))
		. += "An odious gimmick. Carves red Herrings, then dares to bleed."
	else if(is_gaffer_assistant_job(user.mind.assigned_role))
		. += "A golden needle designed after a bog beast, it was supposed to be a gift for a 'noble' once, but it died before it reached them."
	else if(HAS_TRAIT(user, TRAIT_NOBLE))
		. += "A dazzling piece, I can see my reflection on it, I look... ashamed?"
	else
		. += "A golden prick for drawing blood and signing parchment."
	if(HAS_TRAIT(user, TRAIT_SEEPRICES))
		. += "<span class='info'>value: Worthless.</span>"

/obj/item/gold_prick/proc/clear_blood()
	if(blood)
		blood = null
		update_appearance(UPDATE_ICON_STATE)

/obj/item/gold_prick/Destroy()
	if(blood)
		blood = null
	. = ..()

/obj/item/merctoken
	name = "mercenary token"
	desc = "A small, palm-fitting bound scroll - a minuature writ of commendation for a mercenary under MGE."
	icon_state = "merctoken"
	icon = 'icons/roguetown/items/misc.dmi'
	w_class = WEIGHT_CLASS_TINY
	dropshrink = 0.5
	firefuel = 30 SECONDS
	sellprice = 2
	throwforce = 0
	slot_flags = ITEM_SLOT_HIP|ITEM_SLOT_MOUTH
	var/signee = null
	var/signeejob = null

/obj/item/merctoken/examine(mob/user)
	. = ..()
	if(!signee)
		. += span_info("Present to a Guild representative for signing.")
	else
		. += span_info("SIGNEE: [signee], [signeejob] of Vanderlin.")

/obj/item/merctoken/attackby(obj/item/P, mob/living/carbon/human/user, params)
	if(istype(P, /obj/item/natural/thorn) || istype(P, /obj/item/natural/feather))
		if(!user.can_read(src))
			to_chat(user, span_warning("Even a reader would find these verba incomprehensible."))
			return
		if(signee)
			to_chat(user, span_warning("This token has already been signed."))
			return
		if(!is_gaffer_job(user.mind.assigned_role))
			if(is_mercenary_job(user.mind.assigned_role))
				to_chat(user, span_warning("I can not sign my own commendation."))
			else
				to_chat(user, span_warning("This is incomprehensible."))
			return
		else
			signee = user.real_name
			signeejob = user.mind.assigned_role.get_informed_title(user)
			visible_message(span_warning("[user] writes [user.p_their()] name on [src]."))
			playsound(src, 'sound/items/write.ogg', 100, FALSE)

/obj/item/paper/merc_contract
	name = "Hamartia"
	icon_state = "contractunsigned"
	var/signed = FALSE
	var/datum/weakref/signedmerc
	COOLDOWN_DECLARE(recallcool)

/obj/item/paper/merc_contract/update_icon_state()
	. = ..()
	if(mailer)
		icon_state = "paper_prep"
		throw_range = 7
		return
	throw_range = initial(throw_range)
	if(signed)
		icon_state = "contractsigned"
		return
	icon_state = "contractunsigned"

/obj/item/paper/merc_contract/update_name()
	if(signedmerc)
		var/mob/signedmercref = signedmerc.resolve()
		name = "[signedmercref.real_name]'s [initial(name)]"
		return ..()

/obj/item/paper/merc_contract/attackby(obj/item/P, mob/living/user, params)
	if(istype(P, /obj/item/flashlight/flare/torch))
		if(HAS_TRAIT(user, TRAIT_BURDEN))
			var/obj/item/flashlight/flare/torch/T = P
			if(T.on && user.used_intent.type != INTENT_HARM  && signedmerc)
				bloodvodoo()
				return
	if(istype(P, /obj/item/candle))
		if(HAS_TRAIT(user, TRAIT_BURDEN))
			var/obj/item/candle/C = P
			if(C.lit && user.used_intent.type != INTENT_HARM  && signedmerc)
				bloodvodoo()
				return
	if(istype(P, /obj/item/natural/thorn) || istype(P, /obj/item/natural/feather))
		if(HAS_TRAIT(user, TRAIT_BURDEN))
			if(signed)
				to_chat(user, span_warning("This contract has already been ratified."))
				return
			playsound(src, 'sound/items/write.ogg', 50, FALSE, ignore_walls = FALSE)
			visible_message("[user] ratifies the contract")
			signed = TRUE
			if(signedmerc)
				var/mob/merc = signedmerc.resolve()
				ADD_TRAIT(merc, TRAIT_MERCGUILD, type)
			update_appearance(UPDATE_ICON_STATE | UPDATE_NAME)
			return

		if(signedmerc)
			to_chat(user, span_warning("This contract has already been signed."))
			return
		if(!user.can_read(src))
			to_chat(user, span_warning("I don't know what I'm agreeing too..."))
		playsound(src, 'sound/items/write.ogg', 50, FALSE, ignore_walls = FALSE)
		visible_message("[user] signs the contract")
		signedmerc = WEAKREF(user)
		if(signed)
			var/mob/merc = signedmerc.resolve()
			ADD_TRAIT(merc, TRAIT_MERCGUILD, type)


/obj/item/paper/merc_contract/examine(mob/user)
	. = ..()
	if(!HAS_TRAIT(user, TRAIT_BURDEN))
		. += "A noticably oily parchment. written on it is an oddly worded contract telling that the signee works for the Mercenary Guild"
		return
	if(!signedmerc)
		. += "A lesser pact with the Guild's patron, but what is the condition?"
		user.add_stress(/datum/stress_event/ring_madness)
		return
	var/mob/merc = signedmerc.resolve()
	if(merc.stat == DEAD)
		var/loldied = pick("Dirty", "Cold", "Scabby", "Stiff", "Limp", "Rotted", "Mutilated", "Pallid", "Withered")
		. += "I see the parchment swell and shrink with the same rhythm as my breathing, it is [loldied]"
		return
	else
		. += "I see the parchment swell and shrink with the same rhythm as my breathing, it is warm"

/obj/item/paper/merc_contract/read(mob/user)
	if(!user.client || !user.hud_used)
		return
	if(!user.hud_used.reads)
		return
	if(!user.can_read(src))
		to_chat(user, span_warning("Even if I could read, I don't think I would care to."))
		return
	if(!in_range(user, src) && !isobserver(user))
		return "<span class='warning'>I'm too far away to read it.</span>"
	to_chat(user, span_info("Skimming through the script, you don't feel obliged to read it in full. But the gist is that you will work for the guild and get benefits of membership, if there is any."))
	if(signedmerc)
		var/mob/signedmercref = signedmerc.resolve()
		to_chat(user, span_info("[signedmercref.real_name] seems to have signed this already"))
	return
	/*
	if(HAS_TRAIT(user, TRAIT_BURDEN))
		var/merc = "_________"
		if(signedmerc)
			var/mob/mercref = signedmerc.resolve()
			merc = mercref.real_name
		info += "THIS AGREEMENT IS MADE AND ENTERED INTO AS OF THE DATE OF LAST SIGNATURE BELOW, BY AND BETWEEN [merc] (HEREAFTER REFERRED TO AS OUR CHAMPION), \
			AND THE MERCENARY GUILD (HEREAFTER REFERRED TO AS THE SOVEREIGN BROTHERHOOD OF GLORY AND WEALTH)<BR>WITNESSETH:<BR>WHEREAS, OUR CHAMPION IS A NATURAL BORN HUMEN OR HUMENOID, POSSESSING SKILLS OF; PHYSICAL STRENGTH, NIMBLE DEXTERITY, UNBREAKING CONSITUTION AND OR EXCELING IN FIELDS OF PHYSICALLY DEMANDING LABOUR.  UPON WHICH HE/SHE/PREFERRED-IDENTITY-PROVIDE  CAN AID THE SOVEREIGN BROTHERHOOD OF GLORY AND WEALTH, \
			WHO SEEKS TO CONTRIBUTE IN THE SOVEREIGN BROTHERHOOD OF GLORY AND WEALTH.<BR>WHEREAS, THE SOVEREIGN BROTHERHOOD OF GLORY AND WEALTH AGREES TO UNCONDITIONALLY PROVIDE PAYMENT, AND BENEFITS, WORTHY AND ACCEPTABLE TO OUR CHAMPION, \
			IN EXCHANGE FOR CONTINIOUS COOPERATION.<BR>NOW THEREFORE IN CONSIDERATION OF THE MUTUAL COVENANTS HEREIN CONTAINED, AND OTHER GOOD AND VALUABLE CONSIDERATION, THE PARTIES HERETO MUTUALLY AGREE AS FOLLOWS:\
			<BR>IN EXCHANGE FOR PALTRY PAYMENTS AND BENEFITS, OUR CHAMPION AGREES TO KEEP THEIR WORK EXCLUSIVELY PROVIDED AND CHOSEN BY THE SOVEREIGN BROTHERHOOD OF GLORY AND WEALTH REPRESENTETIVE (REFERRED TO AS WHELP DESPITE LACK OF MENTION HEREAFTER), \
			FOR THE REMAINDER OF HIS OR HER OR PREFERRED-IDENTITY-PROVIDE CURRENT LIFE.  PROVIDED OUR CHAMPION REMAIN IN DESIRE TO WORK FOR  THE SOVEREIGN BROTHERHOOD OF GLORY AND WEALTH AND WITHOUT THE LAWFUL  EVISCERATION OF THE AGREEMENT STRUCK HEREIN THIS PARCHMENT.<BR> \
			<BR>SIGNED,<BR><i>[merc]</i>" //this conracts sucks, it doesn't even fit the time period but god I am not in the mood to write a contract, call this a place holder
	if(is_gaffer_assistant_job(user.mind.assigned_role))
		info += ""
	else
		info += ""
	user.hud_used.reads.icon_state = "scroll"
	user.hud_used.reads.show()
	var/dat = {"<!DOCTYPE HTML PUBLIC \"-//W3C//DTD HTML 4.01 Transitional//EN\" \"http://www.w3.org/TR/html4/loose.dtd\">
				<html><head><style type=\"text/css\">
				body { background-image:url('book.png');background-repeat: repeat; }</style>
				</head><body scroll=yes>"}
	dat += "[info]<br>"
	dat += "<a href='byond://?src=[REF(src)];close=1' style='position:absolute;right:50px'>Close</a>"
	dat += "</body></html>"
	user << browse(dat, "window=reading;size=460x300;can_close=0;can_minimize=0;can_maximize=0;can_resize=0;titlebar=0")
	onclose(user, "reading", src)
	*/


/obj/item/paper/merc_contract/Destroy()
	if(signedmerc)
		var/mob/merc = signedmerc.resolve()
		signedmerc = null
		REMOVE_TRAIT(merc, TRAIT_MERCGUILD, type)
		if(isliving(merc))
			var/mob/living/livingmerc = merc
			to_chat(livingmerc, span_warning("in a blink, it was as if the world's joy was dimmed. The songs of birds, The sounds of children playing, they grew distant, hard to notice. As if the monotony of life muffled the song of wonder... or maybe, I just became unemployed."))
			livingmerc.apply_status_effect(/datum/status_effect/debuff/unemployed)
	. = ..()

/obj/item/paper/merc_contract/proc/bloodvodoo(mob/user)
	var/fuckitupterry = browser_alert(user, "The fire is inches away from the parchment", "THE PACT", list("Absolve Contract", "Recall Champion"))
	if(!fuckitupterry)
		to_chat(user, span_danger("No, no I couldn't..."))
		return
	if(fuckitupterry == "Absolve Contract")
		to_chat(user, "without even being claimed by the fire, the contract crumbles to ash.")
		var/ash = new /obj/item/fertilizer/ash
		if(user.is_holding(src) || Adjacent(src))
			user.put_in_active_hand(ash)
		qdel(src)
		return
	if(fuckitupterry == "Recall Champion")
		var/mob/merc = signedmerc.resolve()
		if(!COOLDOWN_FINISHED(src, recallcool))
			to_chat(user, span_danger("I--I must give them some time!"))
			return
		if(!isliving(merc) || merc.stat == UNCONSCIOUS)
			to_chat(user, "They are in no state for this...")
			return
		if(!merc.client && !merc.ckey)
			to_chat(user, "Something is missing?")
			return
		var/checkit = pick("Suddenly, in the distance, I hear quiet whistling. Directionless, yet beckoning me elsewhere. I know where it goes, lead me. lead me to the guild...", "I feel a cold wind wash over me. Like draining water, it feels like it has a purpose. I know where it leads, back. Back to the guild.", "In a moment, I develop a fascination with roads, ones I've walked through, ones I will never walk. The branching paths, like the branches of a tree, ever expanding, a deep vein uncompressed. I explore these roads within my mind, and it always leads me back. All roads lead back to the guild.")
		to_chat(merc, span_boldwarning("[checkit]")) //not too obvious
		//playsoound_local(signedmerc, '')
		//N/A sound here would be neat
		COOLDOWN_START(src, recallcool, 10 MINUTES)

/obj/item/paper/merc_contract/pre_attack(atom/A, mob/living/user, params)
	if(isitem(A))
		var/obj/item/O = A
		if(istype(O, /obj/item/flashlight/flare/torch))
			if(HAS_TRAIT(user, TRAIT_BURDEN))
				var/obj/item/flashlight/flare/torch/T = O
				if(T.on && user.used_intent.type != INTENT_HARM && signedmerc)
					bloodvodoo()
					return
		if(istype(O, /obj/item/candle))
			if(HAS_TRAIT(user, TRAIT_BURDEN))
				var/obj/item/candle/C = O
				if(C.lit && user.used_intent.type != INTENT_HARM && signedmerc)
					bloodvodoo()
					return
		return TRUE
	return ..()

/obj/item/paper/merc_contract/worker
	name = "Deuteragonist"


/obj/item/paper/merc_contract/worker/read(mob/user)
	if(!user.client || !user.hud_used)
		return
	if(!user.hud_used.reads)
		return
	if(!user.can_read(src))
		to_chat(user, span_warning("Even if I could read, I don't think I would care to."))
		return
	if(!in_range(user, src) && !isobserver(user))
		return "<span class='warning'>I'm too far away to read it.</span>"
	to_chat(user, span_info("Skimming through the script, you don't feel obliged to read it in full. But the gist is that you will work for the guild and get benefits of membership, if there is any."))
	if(signedmerc)
		var/mob/signedmercref = signedmerc.resolve()
		to_chat(user, span_info("[signedmercref.real_name] seems to have signed this already"))
	/*
	if(HAS_TRAIT(user, TRAIT_BURDEN))
		var/merc = "_________"
		if(signedmerc)
			var/mob/mercref = signedmerc.resolve()
			merc = mercref.real_name
		info += "THIS AGREEMENT IS MADE AND ENTERED INTO AS OF THE DATE OF LAST SIGNATURE BELOW, BY AND BETWEEN [merc] (HEREAFTER REFERRED TO AS OUR BENEFICIARY), \
			AND THE MERCENARY GUILD (HEREAFTER REFERRED TO AS THE SOVEREIGN BROTHERHOOD OF GLORY AND WEALTH)<BR>WITNESSETH:<BR>WHEREAS, OUR BENEFICIARY IS A NATURAL BORN HUMEN OR HUMENOID, POSSESSING SKILLS UPON WHICH HE/SHE/PREFERRED-IDENTITY-PROVIDE  CAN AID THE SOVEREIGN BROTHERHOOD OF GLORY AND WEALTH, \
			WHO SEEKS TO CONTRIBUTE IN THE SOVEREIGN BROTHERHOOD OF GLORY AND WEALTH.<BR>WHEREAS, THE SOVEREIGN BROTHERHOOD OF GLORY AND WEALTH AGREES TO UNCONDITIONALLY PROVIDE PAYMENT, AND BENEFITS, WORTHY AND ACCEPTABLE TO OUR BENEFICIARY, \
			IN EXCHANGE FOR CONTINIOUS COOPERATION.<BR>NOW THEREFORE IN CONSIDERATION OF THE MUTUAL COVENANTS HEREIN CONTAINED, AND OTHER GOOD AND VALUABLE CONSIDERATION, THE PARTIES HERETO MUTUALLY AGREE AS FOLLOWS:\
			<BR>IN EXCHANGE FOR PALTRY PAYMENTS AND BENEFITS, OUR BENEFICIARY AGREES TO KEEP THEIR WORK EXCLUSIVELY IN BENEFIT TO THE SOVEREIGN BROTHERHOOD OF GLORY AND WEALTH REPRESENTETIVE (REFERRED TO AS WHELP DESPITE LACK OF MENTION HEREAFTER), \
			FOR THE REMAINDER OF HIS OR HER OR PREFERRED-IDENTITY-PROVIDE CURRENT LIFE.  PROVIDED OUR BENEFICIARY REMAIN IN DESIRE TO WORK FOR  THE SOVEREIGN BROTHERHOOD OF GLORY AND WEALTH AND WITHOUT THE LAWFUL  EVISCERATION OF THE AGREEMENT STRUCK HEREIN THIS PARCHMENT.<BR> \
			<BR>SIGNED,<BR><i>[merc]</i>" //still sucks. refer to above
	if(is_gaffer_assistant_job(user.mind.assigned_role))
		info += ""
	else
		info += ""
	user.hud_used.reads.icon_state = "scroll"
	user.hud_used.reads.show()
	var/dat = {"<!DOCTYPE HTML PUBLIC \"-//W3C//DTD HTML 4.01 Transitional//EN\" \"http://www.w3.org/TR/html4/loose.dtd\">
				<html><head><style type=\"text/css\">
				body { background-image:url('book.png');background-repeat: repeat; }</style>
				</head><body scroll=yes>"}
	dat += "[info]<br>"
	dat += "<a href='byond://?src=[REF(src)];close=1' style='position:absolute;right:50px'>Close</a>"
	dat += "</body></html>"
	user << browse(dat, "window=reading;size=460x300;can_close=0;can_minimize=0;can_maximize=0;can_resize=0;titlebar=0")
	onclose(user, "reading", src)
	*/

/obj/item/paper/merc_work_onetime //this whole shpeal is unintuitive on purpose, we are laying the groundwork for people not paying their debt and having their assets siezed
	name = "Kairos" //the actual UI for this sucking isn't part of it though
	desc = "An oddly worded contract. Allows hiring mercenaries for a specific objective."
	icon_state = "contractunsigned"
	var/signed = FALSE
	var/jobsdone = FALSE
	var/thejob = null
	var/payment = null
	var/datum/weakref/jobber
	var/datum/weakref/jobed

/obj/item/paper/merc_work_onetime/read(mob/user)
	if(!user.client || !user.hud_used)
		return
	if(!user.hud_used.reads)
		return
	if(!user.can_read(src))
		to_chat(user, span_warning("Even if I could read, I don't think I would care to."))
		return
	if(!in_range(user, src) && !isobserver(user))
		return "<span class='warning'>I'm too far away to read it.</span>"
	to_chat(user, span_info("Skimming through the script, you don't feel obliged to read it in full. But the gist is that you are hiring or hired to perform a job, and will be paid the agreed amount"))
	if(signed)
		to_chat(user, span_info("It seems to be ratified by the Gaffer"))
	if(jobsdone)
		to_chat(user, span_info("The specified job seems to be fulfilled"))
	if(thejob)
		to_chat(user, span_info("The job seems to be to [thejob]"))
	if(payment)
		to_chat(user, span_info("The payment seems to be [payment]"))
	if(jobber)
		var/mob/jobberref = jobber.resolve()
		to_chat(user, span_info("[jobberref.real_name] seems to employer"))
	if(jobed)
		var/mob/jobedref = jobed.resolve()
		to_chat(user, span_info("[jobedref.real_name] seems to employee"))
	return
	/*
	if(HAS_TRAIT(user, TRAIT_BURDEN))
		info += ""
	if(is_gaffer_assistant_job(user.mind.assigned_role))
		info += ""
	else
		info += ""
	user.hud_used.reads.icon_state = "scroll"
	user.hud_used.reads.show()
	var/dat = {"<!DOCTYPE HTML PUBLIC \"-//W3C//DTD HTML 4.01 Transitional//EN\" \"http://www.w3.org/TR/html4/loose.dtd\">
				<html><head><style type=\"text/css\">
				body { background-image:url('book.png');background-repeat: repeat; }</style>
				</head><body scroll=yes>"}
	dat += "[info]<br>"
	dat += "<a href='byond://?src=[REF(src)];close=1' style='position:absolute;right:50px'>Close</a>"
	dat += "</body></html>"
	user << browse(dat, "window=reading;size=460x300;can_close=0;can_minimize=0;can_maximize=0;can_resize=0;titlebar=0")
	onclose(user, "reading", src)
	*/

/obj/item/paper/merc_work_onetime/update_icon_state()
	. = ..()
	if(mailer)
		icon_state = "paper_prep"
		throw_range = 7
		return
	throw_range = initial(throw_range)
	if(signed)
		icon_state = "contractsigned"
		return
	icon_state = "contractunsigned"

/obj/item/paper/merc_work_onetime/attackby(obj/item/P, mob/living/user, params)
	. = ..()
	if(istype(P, /obj/item/natural/thorn) || istype(P, /obj/item/natural/feather))
		var/awfulpaperworking = browser_input_list(user, "What are you filling out?", src, list("Payment", "Employer signature", "Employee signature", "Job details", "Formalize Contract", "Job completion signature"))
		if(!awfulpaperworking)
			return
		if(!user.is_holding(src) || !Adjacent(src))
			return
		switch(awfulpaperworking)
			if("payment")
				if(payment)
					to_chat(user, span_warning("This section has already been filled."))
					return
				var/discheck = input(user, "How much are you willing to part with?") as null|num
				if(!discheck)
					return
				if(user.is_holding(src) || Adjacent(src))
					payment = discheck
			if("Employer Signature")
				if(jobber)
					to_chat(user, span_warning("This section has already been filled."))
					return
				jobber = WEAKREF(user)
			if("Employee signature")
				if(!HAS_TRAIT(user, TRAIT_MERCGUILD))
					to_chat(user, span_warning("I don't even work for the guild!"))
					return
				if(jobed)
					to_chat(user, span_warning("This section has already been filled."))
					return
				jobed = WEAKREF(user)
			if("Job details")
				if(thejob)
					to_chat(user, span_warning("This section has already been filled."))
					return
				var/discheck2 = input(user, "What am I paying them for?")
				if(!discheck2)
					return
				if(user.is_holding(src) || Adjacent(src))
					thejob = discheck2
			if("Formalize Contract")
				if(!HAS_TRAIT(user, TRAIT_BURDEN) && !is_gaffer_assistant_job(user.mind.assigned_role))
					to_chat(user, span_warning("This needs the signature of the Guild Master..."))
					return
				if(signed)
					to_chat(user, span_warning("This section has already been filled."))
					return
				signed = TRUE
			if("Job completion signature")
				if(jobsdone)
					to_chat(user, span_warning("This section has already been filled."))
					return
				if(!(thejob || jobed || signed || jobber || payment))
					to_chat(user, span_warning("This contract isn't even filled."))
					return
				var/mob/jobberref = jobber.resolve()
				if(user != jobberref || !(HAS_TRAIT(user, TRAIT_BURDEN) && is_gaffer_assistant_job(user.mind.assigned_role))) //will there ever be an issue with this and the changelings, I don't know
					to_chat(user, span_warning("This isn't mine to sign off"))
					return
				jobsdone = TRUE
		playsound(src, 'sound/items/write.ogg', 50, FALSE, ignore_walls = FALSE)
		visible_message("[user] writes on the contract")
		update_appearance(UPDATE_ICON_STATE)

/obj/item/paper/merc_work_onetime/Destroy()
	if(jobber)
		jobber = null
	if(jobed)
		jobed = null
	. = ..()

/obj/item/paper/merc_work_conti
	name = "Trochaic"
	desc = "An oddly worded contract. Allows hiring mercenaries for a specific objective that will continue for specified amount of time."
	icon_state = "contractunsigned"
	var/signed = FALSE
	var/thejob = null
	var/payment = null
	var/worktime = null
	var/daycount = null
	var/datum/weakref/jobber = null
	var/datum/weakref/jobed = null

/obj/item/paper/merc_work_conti/read(mob/user)
	if(!user.client || !user.hud_used)
		return
	if(!user.hud_used.reads)
		return
	if(!user.can_read(src))
		to_chat(user, span_warning("Even if I could read, I don't think I would care to."))
		return
	if(!in_range(user, src) && !isobserver(user))
		return "<span class='warning'>I'm too far away to read it.</span>"
	to_chat(user, span_info("Skimming through the script, you don't feel obliged to read it in full. But the gist is that you are hiring or hired to perform a job, and will be paid the agreed amount for a set of daes"))
	if(signed)
		to_chat(user, span_info("It seems to be ratified by the Gaffer"))
	if(thejob)
		to_chat(user, span_info("The job seems to be to [thejob]"))
	if(payment)
		to_chat(user, span_info("The payment seems to be [payment]"))
	if(worktime)
		to_chat(user, span_info("The job seems to pay for [worktime] daes"))
	if(jobber)
		var/mob/jobberref = jobber.resolve()
		to_chat(user, span_info("[jobberref.real_name] seems be the employer"))
	if(jobed)
		var/mob/jobedref = jobed.resolve()
		to_chat(user, span_info("[jobedref.real_name] seems to employee"))
	return
	/*
	if(HAS_TRAIT(user, TRAIT_BURDEN))
		info += ""
	if(is_gaffer_assistant_job(user.mind.assigned_role))
		info += ""
	else
		info += ""
	user.hud_used.reads.icon_state = "scroll"
	user.hud_used.reads.show()
	var/dat = {"<!DOCTYPE HTML PUBLIC \"-//W3C//DTD HTML 4.01 Transitional//EN\" \"http://www.w3.org/TR/html4/loose.dtd\">
				<html><head><style type=\"text/css\">
				body { background-image:url('book.png');background-repeat: repeat; }</style>
				</head><body scroll=yes>"}
	dat += "[info]<br>"
	dat += "<a href='byond://?src=[REF(src)];close=1' style='position:absolute;right:50px'>Close</a>"
	dat += "</body></html>"
	user << browse(dat, "window=reading;size=460x300;can_close=0;can_minimize=0;can_maximize=0;can_resize=0;titlebar=0")
	onclose(user, "reading", src)
	*/

/obj/item/paper/merc_work_conti/update_icon_state()
	. = ..()
	if(mailer)
		icon_state = "paper_prep"
		throw_range = 7
		return
	name = initial(name)
	throw_range = initial(throw_range)
	if(signed)
		icon_state = "contractsigned"
		return
	icon_state = "contractunsigned"

/obj/item/paper/merc_work_conti/attackby(obj/item/P, mob/living/user, params)
	if(istype(P, /obj/item/natural/thorn) || istype(P, /obj/item/natural/feather))
		var/awfulpaperworking = browser_input_list(user, "What are you filling out?", src, list("Payment", "Employer signature", "Employee signature", "Job details", "Work duration", "Formalize Contract"))
		if(!awfulpaperworking)
			return
		if(!user.is_holding(src) || !Adjacent(src))
			return
		switch(awfulpaperworking)
			if("payment")
				if(payment)
					to_chat(user, span_warning("This section has already been filled."))
					return
				var/discheck = input(user, span_warning("How much are you willing to part with?")) as null|num
				if(!discheck)
					return
				if(user.is_holding(src) || Adjacent(src))
					payment = discheck
			if("Employer Signature")
				if(jobber)
					to_chat(user, span_warning("This section has already been filled."))
					return
				jobber = WEAKREF(user)
			if("Employee signature")
				if(!HAS_TRAIT(user, TRAIT_MERCGUILD))
					to_chat(user, span_warning("I don't even work for the guild!"))
					return
				if(jobed)
					to_chat(user, span_warning("This section has already been filled."))
					return
				jobed = WEAKREF(user)
			if("Job details")
				if(thejob)
					to_chat(user, span_warning("This section has already been filled."))
					return
				var/discheck2 = input(user, span_warning("What am I paying them for?"))
				if(!discheck2)
					return
				if(user.is_holding(src) || Adjacent(src))
					thejob = discheck2
			if("Work duration")
				if(worktime)
					to_chat(user, span_warning("This section has already been filled."))
					return
				var/discheck3 = input(user, span_warning("How long must they work?")) as null|num
				if(!discheck3)
					return
				if(user.is_holding(src) || Adjacent(src))
					worktime = discheck3
					daycount = GLOB.dayspassed
			if("Formalize Contract")
				if(!HAS_TRAIT(user, TRAIT_BURDEN) && !is_gaffer_assistant_job(user.mind.assigned_role))
					to_chat(user, span_warning("This needs the signature of the Guild Master..."))
					return
				if(signed)
					to_chat(user, span_warning("This section has already been filled."))
					return
				signed = TRUE
		playsound(src, 'sound/items/write.ogg', 50, FALSE, ignore_walls = FALSE)
		visible_message("[user] writes on the contract")
		update_appearance(UPDATE_ICON_STATE)

/obj/item/paper/merc_work_conti/Destroy()
	if(jobber)
		jobber = null
	if(jobed)
		jobed = null
	. = ..()

/*/obj/item/merc_asset_steal //not sure about this one yet
	name = ""
	desc = ""
	icon_state = "contractunsigned"
	var/signed = FALSE
	var/stewardsigned = FALSE
*/

/obj/item/paper/merc_autograph
	name = "Platitude"
	desc = "An autograph from a mercenary, though, I don't think they came up with the quote themselves..."
	icon_state = "contractunsigned" //N/A this one should have a unique sprite
	var/datum/weakref/signed
	var/datum/weakref/adressedto
	var/coolness = 5

/*
/obj/item/paper/merc_autograph/Initialize()
	switch(rand(1,2))
		if(1) //Lady Lazarus. maybe a little little inappropriate here, but I've always liked that poem.
			/*
			info += "</center>I have done it again.<BR>"
			info += "</center>One year in every ten.<BR>"
			info += "</center>I manage it——<BR>"
			info += "</center>A sort of walking miracle, my skin,<BR>"
			info += "</center>Covered in Black Jade<BR>"
			info += "</center>My right foot<BR>"
			info += "</center>Leaves track laid.<BR>"
			*/
			info += "</center>My face a featureless, fine<BR>"
			info += "</center>Thick Sallade.<BR>"
			info += "</center>Peel off the hide<BR>"
			info += "</center>O my enemy.<BR>"
			info += "</center>Do I terrify?<BR>"
		if(2) //Ozymandias, kinda hard to pull off without being able to do the "my name is [blank]" sadly
			info += "</center>My name you know well,<BR>" //and you know, Ozymandias is really short
			info += "</center>I am the King of Champions!<BR>"
			info += "</center>Look on my form, ye Mighty,<BR>"
			info += "</center>and despair!<BR>"
	. = ..()
*/

/obj/item/paper/merc_autograph/read(mob/user)
	if(!user.client || !user.hud_used)
		return
	if(!user.hud_used.reads)
		return
	if(!user.can_read(src))
		to_chat(user, span_warning("Even if I could read, I don't think I would care to."))
		return
	if(!in_range(user, src) && !isobserver(user))
		return "<span class='warning'>I'm too far away to read it.</span>"
	to_chat(user, span_info("It is an autograph featuring a cheesy line."))
	if(signed)
		var/mob/signedref = signed.resolve()
		to_chat(user, span_info("This is signed by [signedref.real_name]"))
	if(adressedto)
		var/mob/adressedtoref  = adressedto.resolve()
		if(adressedtoref == user)
			if(!HAS_TRAIT(adressedtoref, TRAIT_MERCGUILD))
				if(coolness > 0)
					user.add_stress(/datum/stress_event/autograph_fangirl_1)
					coolness--
		to_chat(user, span_info("This autograph is addressed to [adressedtoref.real_name]"))
	return
	/*
	var/merc = "_________"
	if(signed)
		var/mob/mercref = signed.resolve()
		merc = mercref.real_name
	info += "Signature: [merc]" //"signature" is a bit lame.
	user.hud_used.reads.icon_state = "scroll"
	user.hud_used.reads.show()
	var/dat = {"<!DOCTYPE HTML PUBLIC \"-//W3C//DTD HTML 4.01 Transitional//EN\" \"http://www.w3.org/TR/html4/loose.dtd\">
				<html><head><style type=\"text/css\">
				body { background-image:url('book.png');background-repeat: repeat; }</style>
				</head><body scroll=yes>"}
	dat += "[info]<br>"
	dat += "<a href='byond://?src=[REF(src)];close=1' style='position:absolute;right:50px'>Close</a>"
	dat += "</body></html>"
	user << browse(dat, "window=reading;size=460x300;can_close=0;can_minimize=0;can_maximize=0;can_resize=0;titlebar=0")
	onclose(user, "reading", src)
	*/

/obj/item/paper/merc_autograph/update_icon_state()
	. = ..()
	if(mailer)
		icon_state = "paper_prep"
		throw_range = 7
		return
	throw_range = initial(throw_range)
	if(signed)
		icon_state = "contractsigned"
		return
	icon_state = "contractunsigned"

/obj/item/paper/merc_autograph/update_name()
	if(signed)
		var/mob/signedmercref = signed.resolve()
		name = "[signedmercref.real_name]'s [initial(name)]"
		return
	return ..()

/obj/item/paper/merc_autograph/attackby(obj/item/P, mob/living/user, params)
	if(istype(P, /obj/item/natural/thorn) || istype(P, /obj/item/natural/feather))
		if(HAS_TRAIT(user, TRAIT_MERCGUILD))
			if(signed)
				to_chat(user, span_warning("This is already signed"))
				return
			var/list/things = list()
			for(var/mob/living/carbon/human/special in oview(7, user) - user) //can't give autographs to random mobs, this will surely be changed
				if(!special.get_face_name(null))
					continue
				things += special
			if(!length(things))
				user.balloon_alert(user, "There is no one to sign this for...")
				return
			var/atom/fan = browser_input_list(user, "Who here should I address this to?", "SIGN THE PLATITUDE", sortList(things))
			if(QDELETED(src) || QDELETED(user) || QDELETED(fan))
				return
			playsound(src, 'sound/items/write.ogg', 50, FALSE, ignore_walls = FALSE)
			visible_message("[user] signs the [src]")
			signed = WEAKREF(user)
			adressedto = WEAKREF(fan)
			update_appearance(UPDATE_ICON_STATE | UPDATE_NAME)
			return
		/*
		if(!adressedto)
			playsound(src, 'sound/items/write.ogg', 50, FALSE, ignore_walls = FALSE)
			visible_message("[user] writes on the [src]")
			adressedto = WEAKREF(user)
			update_appearance(UPDATE_ICON_STATE | UPDATE_NAME)
			return
		to_chat(user, span_warning("This is already signed"))
		return
		*/
		//var/renown = GLOB.mob_renown_list[user.mobid]
		////N/A canned until port. the mercenary check should be fine enough, its 1 point of happiness it can't be that bad
		//if(renown <= 3)
			//to_chat(user, span_warning("I'm uhh...not famous enough for this type of thing."))
			//return

/obj/item/paper/merc_autograph/Destroy()
	if(signed)
		signed = null
	if(adressedto)
		adressedto = null
	. = ..()


/*
/obj/item/paper/merc_autograph/examine(mob/user)
	. = ..()
	if(!signed)
		return
	if(user.is_holding(src))
		if(user == adressedto)
			user.add_stress(/datum/stress_event/autograph_fangirl_1)
		//var/Erenown = GLOB.mob_renown_list[signed.mobid]
		//if(Erenown <= 4)
			//user.add_stress(/datum/stressevent/autograph_fangirl_1)
			//return
		//if(Erenown <= 6)
			//user.add_stress(/datum/stressevent/autograph_fangirl_2)
			//return
		//if(Erenown >= 7)
			//user.add_stress(/datum/stressevent/autograph_fangirl_3)
			//return
*/

/obj/item/paper/merc_will //don't look now, but this whole thing is a ploy to make adventurers and mercs keep their money in the banks so they actually contribute to capital
	name = "Antonomasia"
	desc = "An oddly worded contract. Allows for mercenaries to pass on their wealth after they pass. Needs the signature of the steward to be legitimate."
	icon_state = "contractunsigned"
	var/datum/weakref/soontodie
	var/datum/weakref/inheretorial
	var/datum/weakref/yuptheydied
	var/stewardsigned = FALSE

/obj/item/paper/merc_will/read(mob/user)
	if(!user.client || !user.hud_used)
		return
	if(!user.hud_used.reads)
		return
	if(!user.can_read(src))
		to_chat(user, span_warning("Even if I could read, I don't think I would care to."))
		return
	if(!in_range(user, src) && !isobserver(user))
		return "<span class='warning'>I'm too far away to read it.</span>"
	to_chat(user, span_info("Skimming through the script, you don't feel obliged to read it in full. But the gist is that it allows someone to pass on the wealth in their account to someone else."))
	if(soontodie)
		var/mob/soontodieref = soontodie.resolve()
		to_chat(user, span_info("This will seems to be in [soontodieref.real_name]s name"))
	if(inheretorial)
		var/mob/inheretorialref = inheretorial.resolve()
		to_chat(user, span_info("[inheretorialref.real_name] seems to be the one to inheret."))
	if(yuptheydied)
		to_chat(user, span_info("Seems like they are confirmed dead."))
	if(stewardsigned)
		to_chat(user, span_info("The steward seems to have signed off on this."))
	return
	/*
	if(HAS_TRAIT(user, TRAIT_BURDEN))
		info += ""
	if(is_gaffer_assistant_job(user.mind.assigned_role))
		info += ""
	else
		info += ""
	user.hud_used.reads.icon_state = "scroll"
	user.hud_used.reads.show()
	var/dat = {"<!DOCTYPE HTML PUBLIC \"-//W3C//DTD HTML 4.01 Transitional//EN\" \"http://www.w3.org/TR/html4/loose.dtd\">
				<html><head><style type=\"text/css\">
				body { background-image:url('book.png');background-repeat: repeat; }</style>
				</head><body scroll=yes>"}
	dat += "[info]<br>"
	dat += "<a href='byond://?src=[REF(src)];close=1' style='position:absolute;right:50px'>Close</a>"
	dat += "</body></html>"
	user << browse(dat, "window=reading;size=460x300;can_close=0;can_minimize=0;can_maximize=0;can_resize=0;titlebar=0")
	onclose(user, "reading", src)
	*/

/obj/item/paper/merc_will/update_icon_state()
	. = ..()
	if(mailer)
		icon_state = "paper_prep"
		throw_range = 7
		return
	throw_range = initial(throw_range)
	if(yuptheydied)
		icon_state = "contractsigned"
		return
	icon_state = "contractunsigned"

/obj/item/paper/merc_will/update_name()
	if(soontodie)
		var/mob/signedmercref = soontodie.resolve()
		name = "[signedmercref.real_name]'s [initial(name)]"
		return
	return ..()

/obj/item/paper/merc_will/attackby(obj/item/P, mob/living/carbon/human/user, params)
	if(istype(P, /obj/item/natural/thorn) || istype(P, /obj/item/natural/feather))
		if(HAS_TRAIT(user, TRAIT_BURDEN) || is_gaffer_assistant_job(user.mind.assigned_role))
			if(!soontodie || !inheretorial)
				to_chat(user, span_warning("This will isn't complete."))
				return
			if(yuptheydied)
				to_chat(user, span_warning("This is already signed."))
				return
			var/aretheydead = browser_alert(user, "Has the mercenary passed, is it time to pay the grievers?", "CONFIRM DEATH", list("They rest now", "They Walk"))
			if(aretheydead == "They walk")
				return
			if(aretheydead == "They rest now" && (user.is_holding(src) || user.Adjacent(src)))
				playsound(src, 'sound/items/write.ogg', 50, FALSE, ignore_walls = FALSE)
				var/mob/soontodieref = soontodie.resolve()
				visible_message("[user] confirms [soontodieref.real_name]'s death.")
				yuptheydied = WEAKREF(user)
				update_appearance(UPDATE_ICON_STATE)
				return
		if(is_steward_job(user.mind.assigned_role))
			if(!stewardsigned)
				to_chat(user, span_warning("nothing else to write here."))
				return
			playsound(src, 'sound/items/write.ogg', 50, FALSE, ignore_walls = FALSE)
			visible_message("[user] ratifies the papers") //ratify doesnt work here
			stewardsigned = TRUE
			return
		if(HAS_TRAIT(user, TRAIT_MERCGUILD))
			if(soontodie && inheretorial)
				to_chat(user, span_warning("nothing else to write here."))
				return
			var/list/bozo = user.mind.known_people
			var/selection = input(user, "Who shall have my wealth once I pass?", "CHOOSE YOUR INHERITOR") as null | anything in bozo
			if(!selection)
				return
			if(!user.is_holding(src) || !Adjacent(src))
				return
			playsound(src, 'sound/items/write.ogg', 50, FALSE, ignore_walls = FALSE)
			visible_message("[user] finishes their final statement")
			inheretorial = WEAKREF(selection)
			soontodie = WEAKREF(user)
			update_appearance(UPDATE_NAME)
			return
		to_chat(user, span_warning("I can't do anything with this."))

/obj/item/paper/merc_will/Destroy()
	if(soontodie)
		soontodie = null
	if(inheretorial)
		inheretorial = null
	if(yuptheydied)
		yuptheydied = null
	. = ..()

/obj/item/paper/merc_will/adven_will
	name = "Sardonic"
	desc = "An oddly worded contract. Allows for adventurers to pass on their wealth after they pass. Needs the signature of the steward to be legitimate, and gets taxed by the crown."

/obj/item/paper/merc_will/adven_will/read(mob/user)
	if(!user.client || !user.hud_used)
		return
	if(!user.hud_used.reads)
		return
	if(!user.can_read(src))
		to_chat(user, span_warning("Even if I could read, I don't think I would care to."))
		return
	if(!in_range(user, src) && !isobserver(user))
		return "<span class='warning'>I'm too far away to read it.</span>"
	to_chat(user, span_info("Skimming through the script, you don't feel obliged to read it in full. But the gist is that it allows someone to pass on the wealth in their account to someone else."))
	if(soontodie)
		var/mob/soontodieref = soontodie.resolve()
		to_chat(user, span_info("This will seems to be in [soontodieref.real_name]s name"))
	if(inheretorial)
		var/mob/inheretorialref = inheretorial.resolve()
		to_chat(user, span_info("[inheretorialref.real_name] seems to be the one to inheret."))
	if(yuptheydied)
		to_chat(user, span_info("Seems like they are confirmed dead."))
	if(stewardsigned)
		to_chat(user, span_info("The steward seems to have signed off on this."))
	return
	/*
	if(HAS_TRAIT(user, TRAIT_BURDEN))
		info += ""
	if(is_gaffer_assistant_job(user.mind.assigned_role))
		info += ""
	else
		info += ""
	user.hud_used.reads.icon_state = "scroll"
	user.hud_used.reads.show()
	var/dat = {"<!DOCTYPE HTML PUBLIC \"-//W3C//DTD HTML 4.01 Transitional//EN\" \"http://www.w3.org/TR/html4/loose.dtd\">
				<html><head><style type=\"text/css\">
				body { background-image:url('book.png');background-repeat: repeat; }</style>
				</head><body scroll=yes>"}
	dat += "[info]<br>"
	dat += "<a href='byond://?src=[REF(src)];close=1' style='position:absolute;right:50px'>Close</a>"
	dat += "</body></html>"
	user << browse(dat, "window=reading;size=460x300;can_close=0;can_minimize=0;can_maximize=0;can_resize=0;titlebar=0")
	onclose(user, "reading", src)
	*/

/obj/item/paper/merc_will/adven_will/attackby(obj/item/P, mob/living/carbon/human/user, params)
	if(istype(P, /obj/item/natural/thorn) || istype(P, /obj/item/natural/feather))
		if(HAS_TRAIT(user, TRAIT_BURDEN) || is_gaffer_assistant_job(user.mind.assigned_role))
			if(!soontodie || !inheretorial)
				to_chat(user, span_warning("This will isn't complete."))
				return
			if(yuptheydied)
				to_chat(user, span_warning("This is already signed."))
				return
			var/aretheydead = browser_alert(user, "Has the Free spirit passed, is it time to pay the grievers?", "CONFIRM DEATH", list("They rest now", "They Walk"))
			if(aretheydead == "They walk")
				return
			if(aretheydead == "They rest now" && (user.is_holding(src) || user.Adjacent(src)))
				playsound(src, 'sound/items/write.ogg', 50, FALSE, ignore_walls = FALSE)
				var/mob/soontodieref = soontodie.resolve()
				visible_message("[user] confirms [soontodieref.real_name]'s death.")
				yuptheydied = WEAKREF(user)
				update_appearance(UPDATE_ICON_STATE)
				return
		if(is_steward_job(user.mind.assigned_role))
			if(!stewardsigned)
				to_chat(user, span_warning("nothing else to write here."))
				return
			playsound(src, 'sound/items/write.ogg', 50, FALSE, ignore_walls = FALSE)
			visible_message("[user] ratifies the papers") //ratify doesnt work here
			stewardsigned = TRUE
			return
		if(soontodie && inheretorial)
			to_chat(user, span_warning("nothing else to write here."))
			return
		var/list/bozo = user.mind.known_people
		var/selection = input(user, "Who shall have my wealth once I pass?", "CHOOSE YOUR INHERITOR") as null | anything in bozo
		if(!selection)
			return
		if(!user.is_holding(src) || !Adjacent(src))
			return
		playsound(src, 'sound/items/write.ogg', 50, FALSE, ignore_walls = FALSE)
		visible_message("[user] finishes their final statement")
		inheretorial = WEAKREF(selection)
		soontodie = WEAKREF(user)
		update_appearance(UPDATE_NAME)
		return


/obj/item/paper/political_PM
	name = ""
	desc = ""
	icon_state = "contractunsigned"
	var/datum/weakref/gaffsigned
	var/datum/weakref/signed
	var/datum/job/jobthatcansign = null
	var/triumph_award

/obj/item/paper/political_PM/update_icon_state()
	. = ..()
	if(mailer)
		icon_state = "paper_prep"
		throw_range = 7
		return
	throw_range = initial(throw_range)
	if(signed)
		icon_state = "contractsigned"
		return
	icon_state = "contractunsigned"

/obj/item/paper/political_PM/attackby(obj/item/P, mob/living/carbon/human/user, params)
	if(istype(P, /obj/item/natural/thorn) || istype(P, /obj/item/natural/feather))
		if(HAS_TRAIT(user, TRAIT_BURDEN))
			if(gaffsigned)
				to_chat(user, span_warning("This is already signed"))
				return
			playsound(src, 'sound/items/write.ogg', 50, FALSE, ignore_walls = FALSE)
			visible_message("[user] signs the contract")
			gaffsigned = WEAKREF(user)
			if(signed)
				addtimer(CALLBACK(src, PROC_REF(contract_effect)), 12 SECONDS)
				src.name = initial(name)
				if(triumph_award)
					var/mob/gaffsignedref = gaffsigned.resolve()
					for(var/claimed in GLOB.Beucratic_triumps[gaffsignedref.ckey])
						if(claimed != src.name)
							GLOB.Beucratic_triumps[gaffsignedref.ckey] += src.name
							gaffsignedref.adjust_triumphs(triumph_award)
				return
			return
		if(istype(user.mind.assigned_role, jobthatcansign))
			if(signed)
				to_chat(user, span_warning("This is already signed"))
				return
			playsound(src, 'sound/items/write.ogg', 50, FALSE, ignore_walls = FALSE)
			visible_message("[user] signs the contract")
			signed = WEAKREF(user)
			update_appearance(UPDATE_ICON_STATE)
			if(gaffsigned)
				addtimer(CALLBACK(src, PROC_REF(contract_effect)), 12 SECONDS)
				src.name = initial(name)
				if(triumph_award)
					var/mob/gaffsignedref = gaffsigned.resolve()
					for(var/claimed in GLOB.Beucratic_triumps[gaffsignedref.ckey])
						if(claimed != src.name)
							GLOB.Beucratic_triumps[gaffsignedref.ckey] += src.name
							gaffsignedref.adjust_triumphs(triumph_award)
				return
			return
		to_chat(user, span_warning("I can't do anything with this."))

/obj/item/paper/political_PM/proc/contract_effect()
	return

/obj/item/paper/political_PM/Initialize()
	. = ..()
	RegisterSignal(SSdcs, COMSIG_GAFFER_RING_DESTROYED, PROC_REF(ringdied))

/obj/item/paper/political_PM/proc/ringdied(datum/source)
	SIGNAL_HANDLER
	var/obj/ash = new /obj/item/fertilizer/ash
	ash.forceMove(get_turf(src))
	qdel(src)
	return

/obj/item/paper/political_PM/Destroy()
	if(gaffsigned)
		gaffsigned = null
	if(signed)
		signed = null
	. = ..()

/obj/item/paper/political_PM/guild_tax_exempt
	name = "Apologue"
	desc = "An oddly worded contract. Prevents the members of the guild from being taxed while using MEISTERs after being signed by the steward."
	icon_state = "contractunsigned"
	jobthatcansign = /datum/job/steward
	triumph_award = 1

/obj/item/paper/political_PM/guild_tax_exempt/Destroy()
	if(signed)
		if(SStreasury.mercnotax == TRUE)
			SStreasury.mercnotax = FALSE
	. = ..()

/obj/item/paper/political_PM/guild_tax_exempt/contract_effect()
	if(signed)
		if(SStreasury.mercnotax == FALSE)
			SStreasury.mercnotax = TRUE

/obj/item/paper/political_PM/guild_tax_exempt/read(mob/user)
	if(!user.client || !user.hud_used)
		return
	if(!user.hud_used.reads)
		return
	if(!user.can_read(src))
		to_chat(user, span_warning("Even if I could read, I don't think I would care to."))
		return
	to_chat(user, span_info("Skimming through the script, you don't feel obliged to read it in full. But the gist is that it stops members of the guild from being taxed while using MEISTERs"))
	if(gaffsigned)
		to_chat(user, span_info("The gaffer has signed off on this."))
	if(signed)
		var/mob/signedref = signed.resolve()
		to_chat(user, span_info("[signedref.real_name] seems to signed off on this."))
	return
	/*
	if(!in_range(user, src) && !isobserver(user))
		return "<span class='warning'>I'm too far away to read it.</span>"
	if(HAS_TRAIT(user, TRAIT_BURDEN))
		info += ""
	if(is_gaffer_assistant_job(user.mind.assigned_role))
		info += ""
	else
		info += ""
	user.hud_used.reads.icon_state = "scroll"
	user.hud_used.reads.show()
	var/dat = {"<!DOCTYPE HTML PUBLIC \"-//W3C//DTD HTML 4.01 Transitional//EN\" \"http://www.w3.org/TR/html4/loose.dtd\">
				<html><head><style type=\"text/css\">
				body { background-image:url('book.png');background-repeat: repeat; }</style>
				</head><body scroll=yes>"}
	dat += "[info]<br>"
	dat += "<a href='byond://?src=[REF(src)];close=1' style='position:absolute;right:50px'>Close</a>"
	dat += "</body></html>"
	user << browse(dat, "window=reading;size=460x300;can_close=0;can_minimize=0;can_maximize=0;can_resize=0;titlebar=0")
	onclose(user, "reading", src)
	*/

/*
/obj/item/paper/political_PM/merc_parade
	name = ""
	desc = ""
	icon_state = "contractunsigned"
	jobthatcansign = /datum/job/captain

/obj/item/paper/political_PM/merc_parade/read(mob/user)
	if(!user.client || !user.hud_used)
		return
	if(!user.hud_used.reads)
		return
	if(!user.can_read(src))
		to_chat(user, span_warning("Even if I could read, I don't think I would care to."))
		return
	if(!in_range(user, src) && !isobserver(user))
		return "<span class='warning'>I'm too far away to read it.</span>"
	info += ""
	user.hud_used.reads.icon_state = "scroll"
	user.hud_used.reads.show()
	var/dat = {"<!DOCTYPE HTML PUBLIC \"-//W3C//DTD HTML 4.01 Transitional//EN\" \"http://www.w3.org/TR/html4/loose.dtd\">
				<html><head><style type=\"text/css\">
				body { background-image:url('book.png');background-repeat: repeat; }</style>
				</head><body scroll=yes>"}
	dat += "[info]<br>"
	dat += "<a href='byond://?src=[REF(src)];close=1' style='position:absolute;right:50px'>Close</a>"
	dat += "</body></html>"
	user << browse(dat, "window=reading;size=460x300;can_close=0;can_minimize=0;can_maximize=0;can_resize=0;titlebar=0")
	onclose(user, "reading", src)
*/

/obj/item/paper/political_PM/herovoucher
	name = "Anagnorisis"
	desc = "An oddly worded contract. Entitles coming adventurers and mercenaries to monetary vouchers paid from the vault after being signed by the steward."
	info = ""
	icon_state = "contractunsigned"
	jobthatcansign = /datum/job/steward
	var/price

/obj/item/paper/political_PM/herovoucher/attackby(obj/item/P, mob/living/carbon/human/user, params)
	if(istype(P, /obj/item/natural/thorn) || istype(P, /obj/item/natural/feather))
		if(HAS_TRAIT(user, TRAIT_BURDEN))
			if(gaffsigned)
				to_chat(user, span_warning("This is already signed"))
				return
			playsound(src, 'sound/items/write.ogg', 50, FALSE, ignore_walls = FALSE)
			visible_message("[user] signs the contract")
			gaffsigned = WEAKREF(user)
			return
		if(istype(user.mind.assigned_role, jobthatcansign))
			if(signed && price)
				to_chat(user, span_warning("This is already signed"))
				return
			if(!price)
				var/discheck = input(user, "How much are you willing to part with?") as null|num
				if(!discheck)
					return
				if(user.is_holding(src) || Adjacent(src))
					price = discheck
					playsound(src, 'sound/items/write.ogg', 50, FALSE, ignore_walls = FALSE)
					visible_message("[user] signs the contract")
					return
				return
			playsound(src, 'sound/items/write.ogg', 50, FALSE, ignore_walls = FALSE)
			visible_message("[user] signs the contract")
			signed = WEAKREF(user)
			update_appearance(UPDATE_ICON_STATE)
			return
		to_chat(user, span_warning("I can't do anything with this."))

/obj/item/paper/political_PM/herovoucher/read(mob/user)
	if(!user.client || !user.hud_used)
		return
	if(!user.hud_used.reads)
		return
	if(!user.can_read(src))
		to_chat(user, span_warning("Even if I could read, I don't think I would care to."))
		return
	if(!in_range(user, src) && !isobserver(user))
		return "<span class='warning'>I'm too far away to read it.</span>"
	to_chat(user, span_info("Skimming through the script, you don't feel obliged to read it in full. But the gist is that all adventurers and mercenaries will be entitled to a sum of mammons agreed on the contract"))
	if(gaffsigned)
		to_chat(user, span_info("The gaffer has signed off on this."))
	if(signed)
		var/mob/signedref = signed.resolve()
		to_chat(user, span_info("[signedref.real_name] seems to signed off on this."))
	if(price)
		to_chat(user, span_info("The agreed sum seems to be [price]"))
	return
	/*
	user.hud_used.reads.icon_state = "scroll"
	user.hud_used.reads.show()
	var/dat = {"<!DOCTYPE HTML PUBLIC \"-//W3C//DTD HTML 4.01 Transitional//EN\" \"http://www.w3.org/TR/html4/loose.dtd\">
				<html><head><style type=\"text/css\">
				body { background-image:url('book.png');background-repeat: repeat; }</style>
				</head><body scroll=yes>"}
	dat += "[info]<br>"
	dat += "<a href='byond://?src=[REF(src)];close=1' style='position:absolute;right:50px'>Close</a>"
	dat += "</body></html>"
	user << browse(dat, "window=reading;size=460x300;can_close=0;can_minimize=0;can_maximize=0;can_resize=0;titlebar=0")
	onclose(user, "reading", src)
	*/

/obj/item/paper/political_PM/herovoucher/attack_hand_secondary(mob/user, params)
	. = ..()
	if(.)
		return
	if(!signed || !gaffsigned || !price)
		return
	SStreasury.herovoucher = price
	var/obj/stewardvoucher = new /obj/item/paper/vouchersteward
	var/obj/item/paper/vouchergaffer/gaffvoucher = new /obj/item/paper/vouchergaffer
	gaffvoucher.vouchersteward = stewardvoucher
	stewardvoucher.forceMove(get_turf(user))
	gaffvoucher.forceMove(get_turf(user))
	qdel(src)

/obj/item/paper/vouchergaffer
	name = "Anagnorisis (Haut)"
	desc = "An oddly worded contract. Entitles coming adventurers and mercenaries to monetary vouchers paid from the vault after being signed by the steward."
	info = ""
	icon_state = "merctoken"
	icon = 'icons/roguetown/items/misc.dmi'
	w_class = WEIGHT_CLASS_TINY
	var/vouchersteward = null

/obj/item/paper/vouchergaffer/read(mob/user, ignore_distance)
	. = ..()
	if(!user.client || !user.hud_used)
		return
	if(!user.hud_used.reads)
		return
	if(!user.can_read(src))
		to_chat(user, span_warning("Even if I could read, I don't think I would care to."))
		return
	if(!in_range(user, src) && !isobserver(user))
		return "<span class='warning'>I'm too far away to read it.</span>"
	to_chat(user, span_info("Skimming through the script, you don't feel obliged to read it in full. But the gist is that all adventurers and mercenaries will be entitled to a sum of mammons agreed on the contract."))
	if(!vouchersteward)
		to_chat(user, span_info("The deal seems to have been called off"))
	else
		to_chat(user, span_info("The deal still seems on"))
	return
	/*
	if(HAS_TRAIT(user, TRAIT_BURDEN) || is_gaffer_assistant_job(user.mind.assigned_role))
		if(!vouchersteward)
			. += "deals off"
	user.hud_used.reads.icon_state = "scroll"
	user.hud_used.reads.show()
	var/dat = {"<!DOCTYPE HTML PUBLIC \"-//W3C//DTD HTML 4.01 Transitional//EN\" \"http://www.w3.org/TR/html4/loose.dtd\">
				<html><head><style type=\"text/css\">
				body { background-image:url('book.png');background-repeat: repeat; }</style>
				</head><body scroll=yes>"}
	dat += "[info]<br>"
	dat += "<a href='byond://?src=[REF(src)];close=1' style='position:absolute;right:50px'>Close</a>"
	dat += "</body></html>"
	user << browse(dat, "window=reading;size=460x300;can_close=0;can_minimize=0;can_maximize=0;can_resize=0;titlebar=0")
	onclose(user, "reading", src)
	*/


/obj/item/paper/vouchersteward
	name = "Anagnorisis (Fond)"
	desc = "An oddly worded contract. Entitles coming adventurers and mercenaries to monetary vouchers paid from the vault after being signed by the steward."
	info = ""
	icon_state = "merctoken"
	icon = 'icons/roguetown/items/misc.dmi'

/obj/item/paper/vouchersteward/read(mob/user, ignore_distance)
	. = ..()
	if(!user.client || !user.hud_used)
		return
	if(!user.hud_used.reads)
		return
	if(!user.can_read(src))
		to_chat(user, span_warning("Even if I could read, I don't think I would care to."))
		return
	if(!in_range(user, src) && !isobserver(user))
		return "<span class='warning'>I'm too far away to read it.</span>"
	to_chat(user, span_info("Skimming through the script, you don't feel obliged to read it in full. But the gist is that all adventurers and mercenaries will be entitled to a sum of mammons agreed on the contract for as long as this parchment stands."))
	/*
	user.hud_used.reads.icon_state = "scroll"
	user.hud_used.reads.show()
	var/dat = {"<!DOCTYPE HTML PUBLIC \"-//W3C//DTD HTML 4.01 Transitional//EN\" \"http://www.w3.org/TR/html4/loose.dtd\">
				<html><head><style type=\"text/css\">
				body { background-image:url('book.png');background-repeat: repeat; }</style>
				</head><body scroll=yes>"}
	dat += "[info]<br>"
	dat += "<a href='byond://?src=[REF(src)];close=1' style='position:absolute;right:50px'>Close</a>"
	dat += "</body></html>"
	user << browse(dat, "window=reading;size=460x300;can_close=0;can_minimize=0;can_maximize=0;can_resize=0;titlebar=0")
	onclose(user, "reading", src)
	*/

/obj/item/paper/vouchersteward/Destroy()
	. = ..()
	if(SStreasury.herovoucher)
		SStreasury.herovoucher = null

/obj/item/paper/voucher
	name = "Voucher"
	desc = "A small voucher, entitles the owner to a sum of mammons when claimed from a MEISTER."
	info = ""
	icon_state = "merctoken"
	icon = 'icons/roguetown/items/misc.dmi'

/obj/item/paper/political_PM/bloodseal
	COOLDOWN_DECLARE(punish)

/obj/item/paper/political_PM/bloodseal/attackby(obj/item/P, mob/living/carbon/human/user, params)
	if(istype(P, /obj/item/flashlight/flare/torch))
		if(HAS_TRAIT(user, TRAIT_BURDEN))
			var/obj/item/flashlight/flare/torch/T = P
			if(T.on && user.used_intent.type != INTENT_HARM  && signed)
				bloodvodoo()
				return
	if(istype(P, /obj/item/candle))
		if(HAS_TRAIT(user, TRAIT_BURDEN))
			var/obj/item/candle/C = PANTS_LAYER
			if(C.lit && user.used_intent.type != INTENT_HARM  && signed)
				bloodvodoo()
				return

	if(istype(P, /obj/item/natural/thorn) || istype(P, /obj/item/natural/feather))
		if(!HAS_TRAIT(user, TRAIT_BURDEN))
			to_chat(user, span_warning("I can't do anything with this."))
			return
		if(gaffsigned)
			to_chat(user, span_warning("This is already signed"))
			return
		playsound(src, 'sound/items/write.ogg', 50, FALSE, ignore_walls = FALSE)
		visible_message("[user] signs the contract")
		gaffsigned = WEAKREF(user)
		if(signed)
			addtimer(CALLBACK(src, PROC_REF(contract_effect)), 12 SECONDS)
			src.name = initial(name)
			if(triumph_award)
				var/mob/gaffsignedref = gaffsigned.resolve()
				for(var/claimed in GLOB.Beucratic_triumps[gaffsignedref.ckey])
					if(claimed != src.name)
						GLOB.Beucratic_triumps[gaffsignedref.ckey] += src.name
						gaffsignedref.adjust_triumphs(triumph_award)
			return
		return
	if(istype(P, /obj/item/gold_prick))
		var/obj/item/gold_prick/G = P
		if(!istype(user.mind.assigned_role, jobthatcansign))
			to_chat(user, span_warning("I can't do anything with this."))
			return
		if(!G.blood)
			to_chat(user, span_warning("The prick is dry."))
			return
		if(signed)
			to_chat(user, span_warning("This is already signed"))
			return
		var/mob/refblood = G.blood.resolve()
		if(refblood != user)
			to_chat(user, span_warning("Nothing I write seems to stain the parchment."))
			return
		playsound(src, 'sound/items/write.ogg', 50, FALSE, ignore_walls = FALSE)
		visible_message("[user] signs the contract")
		signed = WEAKREF(user)
		update_appearance(UPDATE_ICON_STATE)
		if(gaffsigned)
			addtimer(CALLBACK(src, PROC_REF(contract_effect)), 12 SECONDS)
			src.name = initial(name)
			if(triumph_award)
				var/mob/gaffsignedref = gaffsigned.resolve()
				for(var/claimed in GLOB.Beucratic_triumps[gaffsignedref.ckey])
					if(claimed != src.name)
						GLOB.Beucratic_triumps[gaffsignedref.ckey] += src.name
						gaffsignedref.adjust_triumphs(triumph_award)

/obj/item/paper/political_PM/bloodseal/pre_attack(atom/A, mob/living/user, params)
	if(isitem(A))
		var/obj/item/O = A
		if(istype(O, /obj/item/flashlight/flare/torch))
			if(HAS_TRAIT(user, TRAIT_BURDEN))
				var/obj/item/flashlight/flare/torch/T = O
				if(T.on && user.used_intent.type != INTENT_HARM && signed)
					bloodvodoo()
					return
		if(istype(O, /obj/item/candle))
			if(HAS_TRAIT(user, TRAIT_BURDEN))
				var/obj/item/candle/C = O
				if(C.lit && user.used_intent.type != INTENT_HARM && signed)
					bloodvodoo()
					return
		return TRUE
	return ..()

/obj/item/paper/political_PM/bloodseal/proc/bloodvodoo(mob/user)
	var/fuckitupterry = browser_alert(user, "The fire is inches away from the parchment", "THE PACT", list("Absolve Contract", "Intimidate Whelp")) //"Mark for death"
	if(!fuckitupterry)
		to_chat(user, span_danger("No, no I couldn't..."))
		return
	if(fuckitupterry == "Absolve Contract")
		to_chat(user, "without even being claimed by the fire, the contract crumbles to ash.")
		var/ash = new /obj/item/fertilizer/ash
		if(user.is_holding(src) || Adjacent(src))
			user.put_in_active_hand(ash)
		qdel(src)
		return
	if(fuckitupterry == "Intimidate Whelp")
		if(!COOLDOWN_FINISHED(src, punish))
			to_chat(user, span_danger("I--I must give them some time!"))
			return
		var/mob/signedref = signed.resolve()
		if(!isliving(signed) || signedref.stat == UNCONSCIOUS)
			to_chat(user, "They are in no state for this...")
			return
		if(!signedref.client && !signedref.ckey)
			to_chat(user, "Something is missing?")
			return
		START_PROCESSING(SSfastprocess, src)
		addtimer(CALLBACK(src, PROC_REF(restore_order)), 12 SECONDS)
		COOLDOWN_START(src, punish, 15 MINUTES)
	//if("Mark for death")
		//return

/obj/item/paper/political_PM/bloodseal/process()
	. = ..()
	var/mob/signedref = signed.resolve()
	if(!signedref.client)
		STOP_PROCESSING(SSfastprocess, src)
		return
	if(!isliving(signed))
		STOP_PROCESSING(SSfastprocess, src)
		return
	if(!signedref.client && !signedref.ckey)
		STOP_PROCESSING(SSfastprocess, src)
		return
	if(prob(40))
		var/text = pick("OATHBREAKER!!", "FOR SHAME!!", "WHERE IS YOUR HONOR?!!", "THE CREED IS BOUND BY BLOOD!!")
		var/screen_location = "WEST+[rand(2,13)], SOUTH+[rand(1,12)]"
		var/text_align = pick("left", "right", "center")
		//text = pick_list_replacements()
		show_blurb(signedref, duration = 3 SECONDS, message = text, fade_time = 3 SECONDS, screen_position = screen_location, text_alignment = text_align, text_color = "red", outline_color = "black")

/obj/item/paper/political_PM/bloodseal/proc/restore_order()
	STOP_PROCESSING(SSfastprocess, src)
	var/mob/signedref = signed.resolve()
	if(!signedref.client)
		return
	if(!isliving(signed))
		return
	if(!signedref.client && !signedref.ckey)
		return
	var/mob/living/okay = signedref
	if(HAS_TRAIT(okay, TRAIT_SLEEPIMMUNE))
		to_chat(okay, span_danger("The voices fade, a dreamless nightmare has visited me."))
		okay.apply_status_effect(/datum/status_effect/debuff/paperwork_dread)
		return
	okay.emote("faint")
	okay.Sleeping(12 SECONDS)
	var/time //court of the dragon, the king in yellow
	var/static/list/cotd = list(
		span_danger("A dazzling light stole my vision... The people faded away, the floor, the vast sky vanished."),
		span_danger("I raised my seared eyes to the fathomless glare, and I saw the black stars hanging in the heavens."),
		span_danger("And now, far away, over leagues of tossing cloud-waves, I saw the Guild's patron masked with noxious ray, It which knew by name."),
		span_danger("And now I heard It's voice, rising, swelling, thundering through the flaring light, and as I fell, the radiance increasing, increasing, poured over me in waves of flame."),
		span_danger("and I heard It whisper a terrible harangue, convinved before its start..."),
		span_danger("I came to in an insouciant manner, as indefferent as one would after waking from restful sleep. I have no memory of what I dreampt, but it was unpleasant."),
		)
	for(var/word in cotd)
		time = time + 2
		addtimer(CALLBACK(src, PROC_REF(restore_order_say), okay, word), time)
	okay.apply_status_effect(/datum/status_effect/debuff/paperwork_dread)

/obj/item/paper/political_PM/bloodseal/proc/restore_order_say(mob/living/H, worb)
	if(!worb)
		return
	to_chat(H, worb)

/obj/item/paper/political_PM/bloodseal/exemptfromlaw
	name = "Polemic"
	desc = "An oddly worded contract. Claims the members of the guild come from too far away to properly adjust to the law of the crown, and must be exempt from prosecution."
	jobthatcansign = /datum/job/lord
	triumph_award = 2

/obj/item/paper/political_PM/bloodseal/exemptfromlaw/contract_effect()
	for(var/obj/structure/fake_machine/scomm/X as anything in SSroguemachine.scomm_machines)
		X.merctakeover = TRUE
		if(prob(15))
			addtimer(CALLBACK(X, TYPE_PROC_REF(/obj/structure/fake_machine/scomm, getmerced)), 12 SECONDS)


/obj/item/paper/political_PM/bloodseal/exemptfromlaw/Destroy()
	if(signed)
		for(var/obj/structure/fake_machine/scomm/X as anything in SSroguemachine.scomm_machines)
			if(X.merctakeover == TRUE)
				X.merctakeover = FALSE
	. = ..()

/obj/item/paper/political_PM/bloodseal/exemptfromlaw/read(mob/user)
	if(!user.client || !user.hud_used)
		return
	if(!user.hud_used.reads)
		return
	if(!user.can_read(src))
		to_chat(user, span_warning("Even if I could read, I don't think I would care to."))
		return
	if(!in_range(user, src) && !isobserver(user))
		return "<span class='warning'>I'm too far away to read it.</span>"
	to_chat(user, span_info("Skimming through the script, you don't feel obliged to read it in full. But the gist is that all members of the mercenary guild is protected from being prosecuted by the law of the crown."))
	if(gaffsigned)
		to_chat(user, span_info("The gaffer has signed off on this."))
	if(signed)
		var/mob/signedref = signed.resolve()
		to_chat(user, span_info("[signedref.real_name] seems to signed off on this."))
	return
	/*
	info += ""
	user.hud_used.reads.icon_state = "scroll"
	user.hud_used.reads.show()
	var/dat = {"<!DOCTYPE HTML PUBLIC \"-//W3C//DTD HTML 4.01 Transitional//EN\" \"http://www.w3.org/TR/html4/loose.dtd\">
				<html><head><style type=\"text/css\">
				body { background-image:url('book.png');background-repeat: repeat; }</style>
				</head><body scroll=yes>"}
	dat += "[info]<br>"
	dat += "<a href='byond://?src=[REF(src)];close=1' style='position:absolute;right:50px'>Close</a>"
	dat += "</body></html>"
	user << browse(dat, "window=reading;size=460x300;can_close=0;can_minimize=0;can_maximize=0;can_resize=0;titlebar=0")
	onclose(user, "reading", src)
	*/

/obj/item/paper/political_PM/bloodseal/exempt_from_cruelty
	name = "Equivocation"
	desc = "An oddly worded contract. Claims the members of the guild are too much of a minority to have their religious affairs judged by the church mass fairly, and asks that the church permit the guild handle such affairs in private."
	jobthatcansign = /datum/job/priest
	triumph_award = 2

/obj/item/paper/political_PM/bloodseal/exempt_from_cruelty/contract_effect()
	if(prob(80))
		for(var/obj/structure/fluff/statue/astrata/statue as anything in GLOB.astrata_statues)
			statue.do_break()

/obj/item/paper/political_PM/bloodseal/exempt_from_cruelty/Destroy()
	for(var/obj/structure/fluff/statue/astrata/statue as anything in GLOB.astrata_statues)
		if(statue.breaking)
			statue.do_break()
	. = ..()


/obj/item/paper/political_PM/bloodseal/exempt_from_cruelty/read(mob/user)
	if(!user.client || !user.hud_used)
		return
	if(!user.hud_used.reads)
		return
	if(!user.can_read(src))
		to_chat(user, span_warning("Even if I could read, I don't think I would care to."))
		return
	if(!in_range(user, src) && !isobserver(user))
		return "<span class='warning'>I'm too far away to read it.</span>"
	to_chat(user, span_info("Skimming through the script, you don't feel obliged to read it in full. But the gist is that all members of the mercenary guild is protected from any and all supression and cruelty of the church."))
	if(gaffsigned)
		to_chat(user, span_info("The gaffer has signed off on this."))
	if(signed)
		var/mob/signedref = signed.resolve()
		to_chat(user, span_info("[signedref.real_name] seems to signed off on this."))
	/*
	info += ""
	user.hud_used.reads.icon_state = "scroll"
	user.hud_used.reads.show()
	var/dat = {"<!DOCTYPE HTML PUBLIC \"-//W3C//DTD HTML 4.01 Transitional//EN\" \"http://www.w3.org/TR/html4/loose.dtd\">
				<html><head><style type=\"text/css\">
				body { background-image:url('book.png');background-repeat: repeat; }</style>
				</head><body scroll=yes>"}
	dat += "[info]<br>"
	dat += "<a href='byond://?src=[REF(src)];close=1' style='position:absolute;right:50px'>Close</a>"
	dat += "</body></html>"
	user << browse(dat, "window=reading;size=460x300;can_close=0;can_minimize=0;can_maximize=0;can_resize=0;titlebar=0")
	onclose(user, "reading", src)
	*/

/obj/item/paper/merchant_merger
	name = "Peripeteia"
	desc = "An oddly worded contract. It outlines the neccesity of the merchant's guild being absorbed by the mercenary guild to prioritize trade welfare."
	icon_state = "contractunsigned"
	var/gaffsigned = FALSE
	var/used = FALSE
	var/datum/weakref/merchant
	var/datum/weakref/tiedobject

/obj/item/paper/merchant_merger/update_icon_state()
	. = ..()
	if(mailer)
		icon_state = "paper_prep"
		throw_range = 7
		return
	throw_range = initial(throw_range)
	if(merchant)
		icon_state = "contractsigned"
		return
	icon_state = "contractunsigned"

/obj/item/paper/merchant_merger/attackby(obj/item/P, mob/living/carbon/human/user, params)
	if(istype(P, /obj/item/natural/thorn) || istype(P, /obj/item/natural/feather))
		if(HAS_TRAIT(user, TRAIT_BURDEN))
			if(gaffsigned)
				to_chat(user, span_warning("This is already signed"))
				return
			playsound(src, 'sound/items/write.ogg', 50, FALSE, ignore_walls = FALSE)
			visible_message("[user] signs the contract")
			gaffsigned = TRUE
			if(merchant)
				var/mob/merchantref = merchant.resolve()
				ADD_TRAIT(merchantref, TRAIT_MERCGUILD, type)
			return
		if(is_merchant_job(user.mind.assigned_role))
			if(merchant)
				to_chat(user, span_warning("This is already signed"))
				return
			playsound(src, 'sound/items/write.ogg', 50, FALSE, ignore_walls = FALSE)
			visible_message("[user] signs the contract")
			merchant = WEAKREF(user)
			if(gaffsigned)
				ADD_TRAIT(user, TRAIT_MERCGUILD, type)
			update_appearance(UPDATE_ICON_STATE)
			return
		to_chat(user, span_warning("I can't do anything with this."))

/obj/item/paper/merchant_merger/Destroy()
	if(merchant)
		merchant = null
	if(used)
		if(SSroguemachine.falseheadeater)
			SSroguemachine.falseheadeater.infestation_death()
	if(tiedobject)
		var/obj/item/headeater_spawn/tiedobjectref = tiedobject.resolve()
		tiedobjectref.tiedpaper = null
		tiedobject = null
	. = ..()

/obj/item/paper/inn_partnership
	name = "Encomium"
	desc = "An oddly worded contract. It outlines the importance of the management and hospitality of the inn, and offers a partnership between the guild."
	icon_state = "contractunsigned"
	var/gaffsigned = FALSE
	var/used = FALSE
	var/datum/weakref/inkeep
	var/datum/weakref/tiedobject

/obj/item/paper/inn_partnership/update_icon_state()
	. = ..()
	if(mailer)
		icon_state = "paper_prep"
		throw_range = 7
		return
	throw_range = initial(throw_range)
	if(inkeep)
		icon_state = "contractsigned"
		return
	icon_state = "contractunsigned"

/obj/item/paper/inn_partnership/attackby(obj/item/P, mob/living/carbon/human/user, params)
	if(istype(P, /obj/item/natural/thorn) || istype(P, /obj/item/natural/feather))
		if(HAS_TRAIT(user, TRAIT_BURDEN))
			if(gaffsigned)
				to_chat(user, span_warning("This is already signed"))
				return
			playsound(src, 'sound/items/write.ogg', 50, FALSE, ignore_walls = FALSE)
			visible_message("[user] signs the contract")
			gaffsigned = TRUE
			if(inkeep)
				var/mob/innkeepref = inkeep.resolve()
				ADD_TRAIT(innkeepref, TRAIT_MERCGUILD, type)
			return
		if(is_innkeep_job(user.mind.assigned_role))
			if(inkeep)
				to_chat(user, span_warning("This is already signed"))
				return
			playsound(src, 'sound/items/write.ogg', 50, FALSE, ignore_walls = FALSE)
			visible_message("[user] signs the contract")
			inkeep = WEAKREF(user)
			if(gaffsigned)
				ADD_TRAIT(user, TRAIT_MERCGUILD, type)
			update_appearance(UPDATE_ICON_STATE)
			return
		to_chat(user, span_warning("I can't do anything with this."))


/obj/item/paper/inn_partnership/Destroy()
	if(inkeep)
		inkeep = null
	if(used)
		if(SSroguemachine.inn_hailer)
			SSroguemachine.inn_hailer.infestation_death()
		if(SSroguemachine.inn_hailer_b)
			SSroguemachine.inn_hailer_b.infestation_death()
	if(tiedobject)
		var/obj/item/hailer_core/tiedobjectref = tiedobject.resolve()
		tiedobjectref.tiedpaper = null
		tiedobject = null
	. = ..()


/obj/item/paper/merchantprotectionpact  //N/A I'm sorry chef this is especially fucking ass
	name = "Homonym"
	desc = "An Arduous contract. Concerns the details of work conduct between the merchant and mercenary guild."
	icon_state = "contractunsigned"
	var/datum/weakref/gaffsigned
	var/datum/weakref/merchsigned
	var/paymentclause
	var/bellclause = FALSE
	var/guaranteeclause
	//var/percentageclause
	var/miscclause

/obj/item/paper/merchantprotectionpact/update_icon_state()
	. = ..()
	if(mailer)
		icon_state = "paper_prep"
		throw_range = 7
		return
	throw_range = initial(throw_range)
	if(merchsigned)
		icon_state = "contractsigned"
		return
	icon_state = "contractunsigned"

/obj/item/paper/merchantprotectionpact/attackby(obj/item/P, mob/living/carbon/human/user, params)
	if(istype(P, /obj/item/natural/thorn) || istype(P, /obj/item/natural/feather))
		if(paymentclause && bellclause && guaranteeclause)
			to_chat(user, span_warning("This is already signed"))
			return
		var/awfulpaperworking = browser_input_list(user, "What are you filling out?", src, list("Payment Clause", "Bell Clause", "Contract Duration Safety", "Miscellaneous Clause"))
		if(!awfulpaperworking)
			return
		if(!user.is_holding(src) || !Adjacent(src))
			return
		switch(awfulpaperworking)
			if("Payment Clause")
				if(paymentclause)
					to_chat(user, span_warning("This section has already been filled."))
					return
				var/discheck = input(user, "How much is the merchant's guild willing to part with?") as null|num
				if(!discheck)
					return
				if(user.is_holding(src) || Adjacent(src))
					paymentclause = discheck
			if("Bell Clause")
				if(bellclause)
					to_chat(user, span_warning("This section has already been signed."))
					return
				bellclause = TRUE
			if("Contract Duration Safety")
				if(guaranteeclause)
					to_chat(user, span_warning("This section has already been filled."))
					return
				var/discheck1 = input(user, "How long must the contract be honored?") as null|num
				if(!discheck1)
					return
				if(user.is_holding(src) || Adjacent(src))
					guaranteeclause = discheck1
			if("Miscellaneous Clause")
				var/discheck2 = input(user, "What else is there to add?")
				if(!discheck2)
					return
				if(user.is_holding(src) || Adjacent(src))
					guaranteeclause += discheck2
		playsound(src, 'sound/items/write.ogg', 50, FALSE, ignore_walls = FALSE)
		visible_message("[user] signs the contract")
		return
	if(istype(P, /obj/item/gold_prick))
		var/obj/item/gold_prick/prick = P
		var/mob/refblood = prick.blood.resolve()
		if(refblood != user)
			to_chat(user, span_warning("I can't do anything with this.")) //N/A
			return
		if(HAS_TRAIT(user, TRAIT_BURDEN))
			if(gaffsigned)
				to_chat(user, span_warning("This is already signed"))
				return
			playsound(src, 'sound/items/write.ogg', 50, FALSE, ignore_walls = FALSE)
			visible_message("[user] signs the contract")
			gaffsigned = WEAKREF(user)
			return
		if(is_merchant_job(user.mind.assigned_role))
			if(merchsigned)
				to_chat(user, span_warning("This is already signed"))
				return
			playsound(src, 'sound/items/write.ogg', 50, FALSE, ignore_walls = FALSE)
			visible_message("[user] signs the contract")
			merchsigned = WEAKREF(user)
			update_appearance(UPDATE_ICON_STATE)
			return
		to_chat(user, span_warning("I can't do anything with this."))

/obj/item/paper/merchantprotectionpact/read(mob/user, ignore_distance)
	. = ..()
	if(!user.client || !user.hud_used)
		return
	if(!user.hud_used.reads)
		return
	if(!user.can_read(src))
		to_chat(user, span_warning("Even if I could read, I don't think I would care to."))
		return
	if(!in_range(user, src) && !isobserver(user))
		return "<span class='warning'>I'm too far away to read it.</span>"
	to_chat(user, span_info("Skimming through the script, you don't feel obliged to read it in full. But the gist is that the mercenary is obligated to provide protection to the merchants guild."))
	if(gaffsigned)
		to_chat(user, span_info("The gaffer has signed off on this."))
	if(merchsigned)
		to_chat(user, span_info("The merchant seems to have signed off on this."))
	if(paymentclause)
		to_chat(user, span_info("The merchant seems to have agreed to pay the mercenary guild [paymentclause] mammons per dae."))
	if(bellclause)
		to_chat(user, span_info("The merchant seems to allow the members of the mercenary guild to use the dock bell, within reason."))
	if(guaranteeclause)
		to_chat(user, span_info("This contract seems impossible to back off on for [guaranteeclause] daes."))
	if(miscclause)
		to_chat(user, span_info("The guilds agree to, '[miscclause]'"))
	return
	/*
	if(paymentclause)
		info += "babababab [paymentclause]"
	if(bellclause)
		info += "babababab"
	if(guaranteeclause)
		info += "babababababba [guaranteeclause]"
	if(miscclause)
		info += "bababababba [miscclause]"
	info += "bababababab"
	user.hud_used.reads.icon_state = "scroll"
	user.hud_used.reads.show()
	var/dat = {"<!DOCTYPE HTML PUBLIC \"-//W3C//DTD HTML 4.01 Transitional//EN\" \"http://www.w3.org/TR/html4/loose.dtd\">
				<html><head><style type=\"text/css\">
				body { background-image:url('book.png');background-repeat: repeat; }</style>
				</head><body scroll=yes>"}
	dat += "[info]<br>"
	dat += "<a href='byond://?src=[REF(src)];close=1' style='position:absolute;right:50px'>Close</a>"
	dat += "</body></html>"
	user << browse(dat, "window=reading;size=460x300;can_close=0;can_minimize=0;can_maximize=0;can_resize=0;titlebar=0")
	onclose(user, "reading", src)
	*/

/obj/item/paper/merchantprotectionpact/attack_hand_secondary(mob/user, params) //N/A THIS FUCKING SUCKS!!!
	. = ..()
	if(.)
		return
	if(!merchsigned || !gaffsigned)
		return
	var/obj/item/paper/merchantprotectionpact_merchpart/M = new /obj/item/paper/merchantprotectionpact_merchpart
	var/obj/item/paper/merchantprotectionpact_gaffpart/G = new /obj/item/paper/merchantprotectionpact_gaffpart
	M.gaffpart = WEAKREF(G)
	M.gaff = gaffsigned
	M.merch = merchsigned
	G.gaff = gaffsigned
	G.merch = merchsigned
	G.merchpart = WEAKREF(M)
	if(guaranteeclause)
		M.guarantee = guaranteeclause
		M.lastguarantee = GLOB.dayspassed
		M.resistance_flags = INDESTRUCTIBLE | LAVA_PROOF | FIRE_PROOF | UNACIDABLE | ACID_PROOF | FREEZE_PROOF
		G.guarantee = guaranteeclause
		G.lastguarantee = GLOB.dayspassed
		G.resistance_flags = INDESTRUCTIBLE | LAVA_PROOF | FIRE_PROOF | UNACIDABLE | ACID_PROOF | FREEZE_PROOF
	if(bellclause)
		for(var/obj/structure/dock_bell/bells in GLOB.dock_bells)
			if(bells)
				bells.mercenaryclaus = TRUE
				G.bell = TRUE
	if(paymentclause)
		G.pay = paymentclause
		G.lastpay = GLOB.dayspassed
	if(miscclause)
		G.misc = miscclause
	qdel(src)

/obj/item/paper/merchantprotectionpact/Destroy()
	if(gaffsigned)
		gaffsigned = null
	if(merchsigned)
		merchsigned = null
	. = ..()

/obj/item/paper/merchantprotectionpact_merchpart
	name = "Homonym (Fond)"
	desc = "An Arduous contract. Concerns the details of work conduct between the merchant and mercenary guild."
	icon_state = "contractsigned"
	var/datum/weakref/gaff
	var/datum/weakref/merch
	var/datum/weakref/gaffpart
	var/guarantee
	var/lastguarantee

/obj/item/paper/merchantprotectionpact_merchpart/read(mob/user, ignore_distance)
	. = ..()
	if(!user.client || !user.hud_used)
		return
	if(!user.hud_used.reads)
		return
	if(!user.can_read(src))
		to_chat(user, span_warning("Even if I could read, I don't think I would care to."))
		return
	if(!in_range(user, src) && !isobserver(user))
		return "<span class='warning'>I'm too far away to read it.</span>"
	to_chat(user, span_info("Skimming through the script, you don't feel obliged to read it in full. But the gist is that the mercenary is obligated to provide protection to the merchants guild."))
	if(gaff)
		to_chat(user, span_info("The gaffer has signed off on this."))
	if(merch)
		to_chat(user, span_info("The merchant seems to have signed off on this."))
	if(gaffpart)
		to_chat(user, span_info("The contract seems to be in effect."))
	if(guarantee)
		to_chat(user, span_info("This contract seems impossible to back off on for [guarantee] daes."))
	return
	/*
	if(!gaffpart)
		info += "deals off"
	if(guarantee)
		info += "babababab [guarantee]"
	user.hud_used.reads.icon_state = "scroll"
	user.hud_used.reads.show()
	var/dat = {"<!DOCTYPE HTML PUBLIC \"-//W3C//DTD HTML 4.01 Transitional//EN\" \"http://www.w3.org/TR/html4/loose.dtd\">
				<html><head><style type=\"text/css\">
				body { background-image:url('book.png');background-repeat: repeat; }</style>
				</head><body scroll=yes>"}
	dat += "[info]<br>"
	dat += "<a href='byond://?src=[REF(src)];close=1' style='position:absolute;right:50px'>Close</a>"
	dat += "</body></html>"
	user << browse(dat, "window=reading;size=460x300;can_close=0;can_minimize=0;can_maximize=0;can_resize=0;titlebar=0")
	onclose(user, "reading", src)
	*/

/obj/item/paper/merchantprotectionpact_merchpart/attackby(obj/item/P, mob/living/user, params)
	if(istype(P, /obj/item/natural/thorn) || istype(P, /obj/item/natural/feather))
		if(!guarantee)
			return
		if(lastguarantee == GLOB.dayspassed)
			return
		playsound(src, 'sound/items/write.ogg', 50, FALSE, ignore_walls = FALSE)
		visible_message("[user] ticks off [src]")
		lastguarantee = GLOB.dayspassed
		guarantee -= 1
		if(guarantee <= 0)
			guarantee = null
			lastguarantee = null
			resistance_flags = null
			if(gaffpart)
				var/obj/item/paper/merchantprotectionpact_gaffpart/gaffpartref = gaffpart.resolve()
				gaffpartref.guarantee = null
				gaffpartref.lastguarantee = null
				gaffpartref.resistance_flags = null

/obj/item/paper/merchantprotectionpact_merchpart/Destroy()
	if(gaff)
		gaff = null
	if(gaffpart)
		var/obj/item/paper/merchantprotectionpact_gaffpart/gaffpartref = gaffpart.resolve()
		gaffpartref.merchpart = null
		if(gaffpartref.bell == TRUE)
			for(var/obj/structure/dock_bell/bells as anything in GLOB.dock_bells)
				if(bells)
					bells.mercenaryclaus = FALSE
					gaffpartref.bell = FALSE
		gaffpart = null
	if(merch)
		merch = null
	. = ..()

/obj/item/paper/merchantprotectionpact_gaffpart
	name = "Homonym (Haut)"
	desc = "An Arduous contract. Concerns the details of work conduct between the merchant and mercenary guild."
	icon_state = "contractsigned"
	var/datum/weakref/gaff
	var/datum/weakref/merch
	var/datum/weakref/merchpart
	var/pay
	var/lastpay
	var/bell = FALSE
	var/guarantee
	var/lastguarantee
	var/misc

/obj/item/paper/merchantprotectionpact_gaffpart/read(mob/user, ignore_distance)
	. = ..()
	if(!user.client || !user.hud_used)
		return
	if(!user.hud_used.reads)
		return
	if(!user.can_read(src))
		to_chat(user, span_warning("Even if I could read, I don't think I would care to."))
		return
	if(!in_range(user, src) && !isobserver(user))
		return "<span class='warning'>I'm too far away to read it.</span>"
	to_chat(user, span_info("Skimming through the script, you don't feel obliged to read it in full. But the gist is that the mercenary is obligated to provide protection to the merchants guild."))
	if(gaff)
		to_chat(user, span_info("The gaffer has signed off on this."))
	if(merch)
		to_chat(user, span_info("The merchant seems to have signed off on this."))
	if(merchpart)
		to_chat(user, span_info("The contract seems to be in effect."))
	if(pay)
		to_chat(user, span_info("The merchant seems to have agreed to pay the mercenary guild [pay] mammons per dae."))
	if(bell)
		to_chat(user, span_info("The merchant seems to allow the members of the mercenary guild to use the dock bell, within reason."))
	if(guarantee)
		to_chat(user, span_info("This contract seems impossible to back off on for [guarantee] daes."))
	if(misc)
		to_chat(user, span_info("The guilds agree to, '[misc]'"))
	return
	/*
	if(!merchpart)
		info += "deals off"
	if(pay)
		info += "bababab [pay]"
	if(bell)
		info += "bababab"
	if(guarantee)
		info += "babababab [guarantee]"
	if(misc)
		info += "bababab [misc]"
	user.hud_used.reads.icon_state = "scroll"
	user.hud_used.reads.show()
	var/dat = {"<!DOCTYPE HTML PUBLIC \"-//W3C//DTD HTML 4.01 Transitional//EN\" \"http://www.w3.org/TR/html4/loose.dtd\">
				<html><head><style type=\"text/css\">
				body { background-image:url('book.png');background-repeat: repeat; }</style>
				</head><body scroll=yes>"}
	dat += "[info]<br>"
	dat += "<a href='byond://?src=[REF(src)];close=1' style='position:absolute;right:50px'>Close</a>"
	dat += "</body></html>"
	user << browse(dat, "window=reading;size=460x300;can_close=0;can_minimize=0;can_maximize=0;can_resize=0;titlebar=0")
	onclose(user, "reading", src)
	*/

/obj/item/paper/merchantprotectionpact_gaffpart/Destroy()
	if(gaff)
		gaff = null
	if(merch)
		merch = null
	if(merchpart)
		var/obj/item/paper/merchantprotectionpact_merchpart/merchpartref = merchpart.resolve()
		merchpartref.gaffpart = null
		if(bell)
			for(var/obj/structure/dock_bell/bells as anything in GLOB.dock_bells)
				if(bells)
					bells.mercenaryclaus = FALSE
					src.bell = FALSE
		merchpart = null
	return ..()

/obj/item/paper/merchantprotectionpact_gaffpart/attackby(obj/item/P, mob/living/user, params)
	if(istype(P, /obj/item/natural/thorn) || istype(P, /obj/item/natural/feather))
		if(!guarantee)
			return
		if(lastguarantee == GLOB.dayspassed)
			return
		playsound(src, 'sound/items/write.ogg', 50, FALSE, ignore_walls = FALSE)
		visible_message("[user] ticks off [src]")
		lastguarantee = GLOB.dayspassed
		guarantee -= 1
		if(guarantee <= 0)
			guarantee = null
			lastguarantee = null
			resistance_flags = null
			if(merchpart)
				var/obj/item/paper/merchantprotectionpact_merchpart/merchpartref = merchpart.resolve()
				merchpartref.guarantee = null
				merchpartref.lastguarantee = null
				merchpartref.resistance_flags = null

/*
/obj/item/tournament //need to do some logistics with this first.
	name = ""
	desc = ""
	icon_state = "contractunsigned"

*/


//canned until the delver ranking is imported
/*
/obj/item/renown1
	name = "Official Decree of Mercenary Renown and Valor Recognition"
	desc = ""
	icon_state = "contractunsigned"

/obj/item/renown2
	name = "The Scroll of Valor and Mercenary's Esteemed Recognition"
	desc = ""
	icon_state = "contractunsigned"

/obj/item/renown3
	name = "The Record of Heroic Achievements and Mercenary's Esteem"
	desc = ""
	icon_state = "contractunsigned"
*/



/obj/item/headeater_spawn
	name = "HEADEATER SPAWN"
	icon_state = "headeater_spawn"
	icon = 'icons/roguetown/items/misc.dmi'
	desc = "Slithering mass of loose teeth and dark red flesh, it pulsates randomly."
	//lefthand_file = ''
	//righthand_file = ''
	w_class = WEIGHT_CLASS_TINY
	dropshrink = 0.7
	drop_sound = 'sound/surgery/organ1.ogg'
	resistance_flags = INDESTRUCTIBLE | LAVA_PROOF | FIRE_PROOF | UNACIDABLE | ACID_PROOF | FREEZE_PROOF
	var/datum/weakref/tiedpaper

/obj/item/headeater_spawn/pickup(mob/user)
	if(!is_gaffer_assistant_job(user.mind.assigned_role) && !HAS_TRAIT(user, TRAIT_BURDEN))
		to_chat(user, span_danger("WHAT IS THIS PUTRID THING?!!"))
		user.add_stress(/datum/stress_event/touched_headeater_spawn)
	. = ..()

/obj/item/headeater_spawn/attack_self(mob/living/user)
	if(!tiedpaper)
		to_chat(user, span_red("It does not seem to be alive."))
		return
	var/alert = alert(user, "Do I want to use this?", "WRITHING THING", "Yes", "No")
	if(alert == "No")
		return
	var/turf/place = get_step(get_turf(user), user.dir)
	new /obj/structure/fake_machine/falseheadeater(place)
	playsound(place, 'sound/combat/gib (2).ogg')
	to_chat(user, span_notice("The writhing flesh compresses itself into a different shape..."))
	qdel(src)

/*
/obj/item/headeater_spawn/examine(mob/user)
	. += "<span class='info'></span>"
*/

/obj/item/headeater_spawn/Destroy()
	if(tiedpaper)
		tiedpaper = null
	. = ..()

/obj/item/hailer_core
	name = "HAILER CARTILAGE"
	icon_state = "cartridge"
	icon = 'icons/roguetown/items/surgery.dmi'
	desc = "Squishy, clay like mass of meat, it pulsates randomly."
	//lefthand_file = ''
	//righthand_file = ''
	w_class = WEIGHT_CLASS_TINY
	dropshrink = 0.4
	drop_sound = 'sound/surgery/organ1.ogg'
	resistance_flags = INDESTRUCTIBLE | LAVA_PROOF | FIRE_PROOF | UNACIDABLE | ACID_PROOF | FREEZE_PROOF
	var/usage = 2
	var/datum/weakref/tiedpaper

/obj/item/hailer_core/attack_self(mob/living/user)
	if(!tiedpaper)
		to_chat(user, span_red("Doesn't seem to be working."))
		return
	var/alert = alert(user, "Do I want to use this?", "HAILER CORE", "Yes", "No")
	if(alert == "No")
		return
	var/turf/place = get_step(get_turf(user), user.dir)
	if(usage == 2)
		new /obj/structure/fake_machine/hailer/inn_hailer(place)
	else
		new /obj/structure/fake_machine/hailerboard/inn_hailer_board(place)
	playsound(place, 'sound/combat/gib (2).ogg')
	to_chat(user, span_notice("The writhing flesh compresses itself into a different shape..."))
	usage--
	if(usage <= 0)
		qdel(src)

/obj/item/hailer_core/Destroy()
	if(tiedpaper)
		tiedpaper = null
	. = ..()

/*-----------------------------------------------------------------\
|  MERCHANT ZONE PAST THIS POINT. PSYDON SAVE ALL YEE WHO PASS     |
\-----------------------------------------------------------------*/

/*
/obj/item/paper/merchant_contract //base
/obj/item/paper/merchant_contract/private_worker // hire miners, woodcutters, fishers. etc to work only for the merchant guild
/obj/item/paper/merchant_contract/private_mine // make it illegal to work in the mines without the guilds approval. own the ore market and by proxy the makers guild..
/obj/item/paper/merchant_contract/purchase_farm_land //purchase all the farm lands, pay the soilsons dimes to work their own land. own the food market and by proxy, the inn
/obj/item/paper/merchant_contract/fish_conservation_act //make it illegal to fish in the town borders, same idea as above..
/obj/item/paper/merchant_contract/ethical_herb_gathering_act //say it is inhumane the grow herbs inside town borders with requirements that are unreachable, hire people to get herbs outside and sell it in bulk. own the potion industry
/obj/item/paper/merchant_contract/town_inheretance_site //make bog and the woods into an inheretence site that you get to upkeep, own the wood and...I dunno what the bog offers?
*/
