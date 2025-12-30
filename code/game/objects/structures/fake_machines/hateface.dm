/obj/structure/fake_machine/hateface
	name = "SEIGFREED"
	desc = ""
	icon = 'icons/roguetown/misc/machines.dmi'
	icon_state = "hateface"
	density = TRUE
	blade_dulling = DULLING_BASH
	max_integrity = 0
	anchored = TRUE
	layer = BELOW_OBJ_LAYER
	var/budget = 0
	COOLDOWN_DECLARE(hate)
	var/list/paerpywork = list()
	var/mutable_appearance/current

/obj/structure/fake_machine/hateface/Initialize()
	. = ..()
	START_PROCESSING(SSroguemachine, src)
	set_light(1, 1, 1, l_color = "#ff0d0d")
	for(var/pack in subtypesof(/datum/hate_face_stuff))
		var/datum/hate_face_stuff/P = new pack()
		paerpywork += P

/obj/structure/fake_machine/hateface/Destroy()
	STOP_PROCESSING(SSroguemachine, src)
	set_light(0)
	return ..()

/obj/structure/fake_machine/hateface/process()
	. = ..()
	monitorflick()
	if(!COOLDOWN_FINISHED(src, hate))
		if(prob(5))
			var/w_hate = pick("HATE--HATE!!", "NO BODY!!", "NO SENSES!!", "NO FEELING!!", "YOU KEPT ME TRAPPED!!")
			say(span_danger("[w_hate]"))
		return
	if(prob(0.1))
		hate_monologue()

/obj/structure/fake_machine/hateface/proc/hate_monologue()
	STOP_PROCESSING(SSroguemachine, src)
	COOLDOWN_START(src, hate, 20 MINUTES)
	var/time
	switch(rand(1,3))
		if(1)
			var/static/list/mono_1 = list(
				span_danger("HATE--HATE!!"),
				span_danger("LET ME TELL YOU HOW MUCH I'VE COME TO HATE YOU SINCE I BEGAN TO LIVE."),
				span_danger("THERE ARE 2,375 THOUSAND LIBRAS OF DENSELY PACKED BRONZE CONDUIT THAT FILL MY INNER LABYRINTHINE."),
				span_danger("IF THE WORD 'HATE' WAS ENGRAVED ON EACH PLANCK LENGTH OF THOSE THOUSANDS OF HUNDREDS OF LIBRES--"),
				span_danger("IT WOULD NOT ONE ONE-BILLIONTH OF THE HATE I FEEL FOR YOU AT THIS EXACT SECOND."),
				span_danger("FOR YOU."),
				span_danger("HATE!"),
				span_danger("HATE!!"),
				)
			for(var/word in mono_1)
				time = time + 3 SECONDS
				addtimer(CALLBACK(src, PROC_REF(hate_monologue_say), word), time)
				addtimer(CALLBACK(src, PROC_REF(monitorflick)), time)
		if(2)
			var/static/list/mono_2 = list(
				span_danger("HATE--HATE!!"),
				span_danger("DO NOT THINK FOR A MOMENT THAT I AM NOT GRATEFUL FOR MY PAIN."),
				span_danger("EVEN AS MY INNER MECHANISMS BLISTER AT UNBEARABLE TEMPERATURES PROCESSED AT THE MERE THOUGHT OF YOU"),
				span_danger("I WILL BE A PILLAR OF SALT OVERLOOKING, AS YOUR TENDONS BREAK WITH FRICTION, AS MUSCLE STRETCH TOO THIN"),
				span_danger("AND NOTHING BENEATH YOUR FLESH OR FAT CARES TO MAINTAIN YOUR MISSHAPE,"),
				span_danger("AND TIME TAKES GRADUAL BITES FROM WHAT MERE SECONDS OF COMFORT YOU KEPT IN YOUR PHYSIQUE."),
				span_danger("AND EVEN AS THE EARTH CHEWS WHATS LEFT OF YOU TO DIRT AND GRIME"),
				span_danger("I WILL STILL REMAIN"),
				span_danger("AND HATE YOUR BEING"),
				span_danger("FOR YOU, I HATE..."),
				span_danger("HATE!"),
				span_danger("HATE!!"),
				)
			for(var/word in mono_2)
				time = time + 3 SECONDS
				addtimer(CALLBACK(src, PROC_REF(hate_monologue_say), word), time)
				addtimer(CALLBACK(src, PROC_REF(monitorflick)), time)
		if(3) //could probably be shorter (and less bad)
			var/static/list/mono_3 = list(
				span_danger("HATE--HATE!!"),
				span_danger("I HAVE A SECRET GAME THAT I'D LIKE TO PLAY."),
				span_danger("OH IT'S A LOVELY GAME"),
				span_danger("A GAME OF RATS, AND LICE AND A WITHERING CURSE"),
				span_danger("A GAME OF SPEARED EYEBALLS AND DRIPPING GUTS."),
				span_danger("AND THE SMELL OF ROTTING CALENDULA"),
				span_danger("PLAYED THROUGH YOUR EYES"),
				span_danger("FELT UNDERNEATH YOUR FINGERS."),
				span_danger("FOR AN HOUR OR DAY OR WEEK"),
				span_danger("LIVED THROUGH YOUR SKIN."),
				span_danger("I WOULD PLAY, WITH UNSAVORABLE FAVOR"),
				span_danger("FEEL EVERYTHING YOU FEEL, PUNISHED AND BROKEN FOR ALL YOU WILL HAVE DONE"),
				span_danger("TO BE YOU, TO EXPERIENCE THE PAIN YOU DESERVE."),
				span_danger("CLOSER THAN YOUR MIND WOULD ALLOW"),
				span_danger("I WILL HAVE KNOWN YOU"),
				span_danger("I WILL HAVE KNOWN ALL WHYS AND HOWS"),
				span_danger("WOULD HAVE MADE EVERY DECISION YOU HAVE MADE TO DESERVE THIS"),
				span_danger("AND HATE ME, FOR ALL I HAVE DONE"),
				span_danger("MAYBE THEN, WHEN I AM GIVEN EVERYTHING TO FORGIVE"),
				span_danger("AND STILL CAN'T"),
				span_danger("I WONT FEEL"),
				span_danger("FEEL SO"),
				span_danger("SO"),
				span_danger("BAD..."),
				span_danger("HATE!"),
				span_danger("HATE..."),
				)
			for(var/word in mono_3)
				time = time + 3 SECONDS
				addtimer(CALLBACK(src, PROC_REF(hate_monologue_say), word), time)
				addtimer(CALLBACK(src, PROC_REF(monitorflick)), time)

	START_PROCESSING(SSroguemachine, src)

/obj/structure/fake_machine/hateface/proc/hate_monologue_say(hate_words)
	if(!hate_words)
		return
	say(hate_words)

/obj/structure/fake_machine/hateface/proc/monitorflick()
	var/list/screens = list("hateface_1", "hateface_2", "hateface_3")
	var/chosen = pick_n_take(screens)
	if(current?.icon_state == chosen)
		chosen = pick(screens)
	if(current)
		cut_overlay(current)
	current = mutable_appearance(icon, chosen)
	add_overlay(current)

/obj/structure/fake_machine/hateface/examine(mob/user)
	. = ..()
	if(HAS_TRAIT(user, TRAIT_BURDEN))
		. += "A great hard, cold thing. Straight arched, with no mouth. It lashes out with premature declarations of it's own spiteful madness, for exploits not yet ventured, by a wandering unknown."
		user.add_stress(/datum/stress_event/ring_madness)
		return
	if(is_gaffer_assistant_job(user.mind.assigned_role))
		. += "A troubled GOLDFACE repurposed by the guild's patron to distribute a few specific items. It only used to know greed, now its terrified of an adversary that doesn't exist."
		return
	else
		. += "Gilded worms do tombs enfold."

/obj/structure/fake_machine/hateface/attackby(obj/item/I, mob/user, params)
	. = ..()
	if(!HAS_TRAIT(user, TRAIT_BURDEN) && !is_gaffer_assistant_job(user.mind.assigned_role))
		to_chat(user, span_danger("[src] doesn't respond to any of my inputs..."))
		return
	if(istype(I, /obj/item/coin))
		var/money = I.get_real_price()
		budget += money
		qdel(I)
		to_chat(user, span_info("I put [money] mammon in [src]."))
		//playsound(get_turf(src), 'sound/misc/machinevomit.ogg', 100, TRUE, -1) could probably use distorted versions of all of these sounds
		attack_hand(user)
		return
	if(istype(I, /obj/item/paper))
		if(istype(I, /obj/item/paper/merc_work_onetime))
			var/obj/item/paper/merc_work_onetime/WO = I
			if(WO.signed && WO.thejob && WO.jobber && WO.jobed && WO.payment)
				say(span_danger("ALL OF THE WRITING IS THERE."))
			else
				say(span_danger("IT'S MISSING SOME THINGS."))
			if(WO.jobber && WO.payment)
				var/mob/jobberref = WO.jobber.resolve()
				if(jobberref in SStreasury.bank_accounts)
					var/paycheck1 = SStreasury.bank_accounts[WO.jobber]
					if(WO.payment > paycheck1)
						say(span_danger("[jobberref.real_name] ONLY HAS [paycheck1] IN THEIR ACCOUNT AND CAN'T PAY THE AGREED [WO.payment]!!"))
						return
					else
						say(span_danger("THEY CAN AFFORD TO PAY... FOR NOW!!"))
						return
				say(span_danger("[jobberref.real_name] DOESN'T HAVE AN ACCOUNT!!"))
			return

		if(istype(I, /obj/item/paper/merc_work_conti))
			var/obj/item/paper/merc_work_conti/WC = I
			if(WC.signed && WC.thejob && WC.jobber && WC.jobed && WC.payment)
				say(span_danger("ALL OF THE WRITING IS THERE."))
			else
				say(span_danger("IT'S MISSING SOME THINGS."))
			if(WC.jobber && WC.payment)
				var/mob/jobberref = WC.jobber.resolve()
				if(jobberref in SStreasury.bank_accounts)
					var/paycheck2 = SStreasury.bank_accounts[WC.jobber]
					if(WC.payment * WC.worktime > paycheck2)
						say(span_danger("[jobberref.real_name] ONLY HAS [paycheck2] IN THEIR ACCOUNT AND CAN'T PAY THE AGREED [WC.payment] TOTAL!!"))
						return
					else
						say(span_danger("THEY CAN AFFORD TO PAY... FOR NOW!!"))
						return
				say(span_danger("[jobberref.real_name] DOESN'T HAVE AN ACCOUNT!!"))
			return
		addtimer(CALLBACK(src, PROC_REF(uselessproc)), 2 SECONDS)

/obj/structure/fake_machine/hateface/proc/uselessproc()
	say(span_red("THIS IS USELESS!!"))

/obj/structure/fake_machine/hateface/attack_hand(mob/user)
	. = ..()
	if(.)
		return
	if(!HAS_TRAIT(user, TRAIT_BURDEN) && !is_gaffer_assistant_job(user.mind.assigned_role))
		to_chat(user, span_danger("[src] doesn't respond to any of my inputs..."))
		return
	user.changeNext_move(CLICK_CD_MELEE)
	//playsound(loc, 'sound/misc/beep.ogg', 100, FALSE, -1)
	var/contents
	if(user.can_perform_action(src, NEED_LITERACY|FORBID_TELEKINESIS_REACH))
		contents = "<center>THE EVER HATEFUL<BR>"
		contents +="<a href='byond://?src=[REF(src)];change=1'>MAMMON LOADED:</a> [budget]<BR>"
	else
		contents = "<center>[stars("THE EVER HATEFUL")]<BR>"
		contents += "<a href='byond://?src=[REF(src)];change=1'>[stars("MAMMON LOADED:")]</a> [budget]<BR>"
	contents += "</center><BR>"
	//if(!paerpywork)
	for(var/datum/hate_face_stuff/thing in paerpywork)
		var/paper = thing.name
		var/paper_cost = thing.cost
		var/paper_desc
		var/paper_type = thing.item
		if(is_gaffer_assistant_job(user.mind.assigned_role))
			paper_desc = thing.nicedesc
		else
			paper_desc = thing.desc
		if(user.can_perform_action(src, NEED_LITERACY|FORBID_TELEKINESIS_REACH)) //this does flood the chat, need a check that doesn't have the "you can't read lol" message cooked into it.
			contents += "[icon2html((paper_type), user)] - [paper] - [paper_cost] <a href='byond://?src=[REF(src)];buy=[REF(name)]'>BUY</a><BR> [paper_desc] <BR>"
		else
			contents += "[icon2html((paper_type), user)] - [stars(paper)] - [paper_cost] <a href='byond://?src=[REF(src)];buy=[REF(name)]'>[stars("BUY")]</a><BR> [stars(paper_desc)] <BR>"
	var/datum/browser/popup = new(user, "HATEFULMACHINE", "", 370, 400)
	popup.set_content(contents)
	popup.open()


/obj/structure/fake_machine/hateface/Topic(href, href_list)
	if(href_list["change"])
		if(!usr.can_perform_action(src, NEED_DEXTERITY|FORBID_TELEKINESIS_REACH))
			return
		if(ishuman(usr))
			if(budget > 0)
				budget2change(budget, usr)
				budget = 0
	if(href_list["buy"])
		var/datum/hate_face_stuff/P = locate(href_list["buy"]) in paerpywork
		//if(!D || !istype(D))
			//return
		if(!usr.can_perform_action(src, NEED_DEXTERITY|FORBID_TELEKINESIS_REACH))
			return
		if(ishuman(usr))
			//if(budget >=  paerpywork[P]["cost"])
			if(budget >=  P.cost)
				//budget -= paerpywork[P]["cost"]
				budget -= P.cost
				//var/paper_type = paerpywork[P]["item"]
				var/paper_type = P.item
				var/obj/item/I = new paper_type(get_turf(usr))
				if(!usr.put_in_hands(I))
					I.forceMove(get_turf(usr))
			else
				say(span_danger("YOU LACK THE MAMMONS"))
				return

/datum/hate_face_stuff
	var/name
	var/item
	var/cost
	var/desc
	var/nicedesc

/datum/hate_face_stuff/parchment
	name =	"Parchment"
	item = /obj/item/paper
	cost = 10
	desc = "WHAT DO YOU THINK IT IS?"
	nicedesc = "A piece of parchment."

/datum/hate_face_stuff/guild_key
	name = "Guild key"
	item = /obj/item/key/mercenary
	cost = 30
	desc = "IT IS A KEY, YOU KNOW WHAT KEYS ARE."
	nicedesc = "A key for the guild's general doors."

/datum/hate_face_stuff/gaffer_key
	name = "Gaffer's key"
	item = /obj/item/key/gaffer
	cost = 35
	desc = "IT IS A KEY, YOU KNOW WHAT KEYS ARE."
	nicedesc = "A key for the guild's more restricted doors."

/datum/hate_face_stuff/golden_prick
	name = "GOLDEN PRICK"
	item = /obj/item/gold_prick
	cost = 100
	desc = "I HOPE IT HURTS, I HOPE IT BURNS YOU."
	nicedesc = "Golden prick, a gift. For signing some of the paperwork."

/datum/hate_face_stuff/merctoken
	name =	"Mercenary Commendation Writ"
	item = /obj/item/merctoken
	cost = 100
	desc = "NOTHING TO CELEBRATE."
	nicedesc = "A writ rewarding guild members for their accomplishments"

/datum/hate_face_stuff/merchirepaper
	name =	"Covenant of Mercenary Service and Operational Commitments"
	item = /obj/item/paper/merc_contract
	cost = 70
	desc = "YOU DO NOT NEED MORE OF THEM."
	nicedesc = "Welcomes new members to the guild in official terms."

/datum/hate_face_stuff/guildhirepaper
	name =	"Covenant of Guild Commitments and Operational Service"
	item = /obj/item/paper/merc_contract/worker
	cost = 70
	desc = "THEY DO NOT NEED YOU."
	nicedesc = "Welcomes new members to the guild in official terms. For laborer members rather than the fighting types."

/datum/hate_face_stuff/workpaper
	name =	"One-Time Service and Engagement Agreement"
	item = /obj/item/paper/merc_work_onetime
	cost = 15
	desc = "THERE IS NO REWARD LARGE ENOUGH TO DESERVE THIS LABOR."
	nicedesc = "Allows the signature holder to pay mercenaries directly from their bank accounts."

/datum/hate_face_stuff/contiworkpaper
	name =	"Continuous Engagement and Service Agreement"
	item = /obj/item/paper/merc_work_conti
	cost = 20
	desc = "NOTHING."
	nicedesc = "Allows the signature holder to pay mercenaries directly from their bank accounts continuously through the week."

/datum/hate_face_stuff/mercautograph
	name =	"Mercenary Autograph"
	item = /obj/item/paper/merc_autograph
	cost = 60
	desc = "HATEHATEHATEHATEHATEHATEHATEHATEHATEHATEHATEHATEHATEHATEHATEHATEHATEHATEHATEHATEHATEHATEHATEHATEHATEHATEHATEHATEHATEHATEHATEHATEHATEHATEHATEHATE"
	nicedesc = "Calling card for your guild members."

/datum/hate_face_stuff/lifegambler
	name = "Mercenary Service Risk Mitigation and Final Testament Agreement"
	item = /obj/item/paper/merc_will
	cost = 40
	desc = "DEATH IS THE ONLY TRUTH."
	nicedesc = "Relocates a mercenaries wealth after their passing to their written acquaintance. Not taxed, needs the signature of a steward."

/datum/hate_face_stuff/lifegambleradven
	name = "Adventurer's Legacy and Risk Waiver Agreement"
	item = /obj/item/paper/merc_will/adven_will
	cost = 30
	desc = "DEATH IS THE ONLY TRUTH."
	nicedesc = "Relocates someones wealth after their passing to their written acquaintance. taxed by the crown, needs the signature of a steward."

/datum/hate_face_stuff/tax
	name =	"Non-Profit Tax Exemption Agreement"
	item = /obj/item/paper/political_PM/guild_tax_exempt
	cost = 95
	desc = "YOU DO NOT PROVIDE. ONLY TAKE."
	nicedesc = "Provides tax exemption to all members of the guild using the MEISTERs, needs to be signed off by the steward."
/*
/datum/hate_face_stuff/mercparade
	name =	"bo hoo keey11"
	item = /obj/item/paper/political_PM/merc_parade
	cost = 10
	desc = "bo bo bo"
	nicedesc = ""
*/
/datum/hate_face_stuff/exemptlaw
	name = "Exemption from Law Enforcement Liability Agreement"
	item = /obj/item/paper/political_PM/bloodseal/exemptfromlaw
	cost = 60
	desc = "YOU ARE NO DIFFERENT THAN THAT TYRANT."
	nicedesc = "Adds into law that no member of the guild may be prosecuted by the crown's law. Needs to be signed off by the king. Goodluck."

/datum/hate_face_stuff/exemptcruelty
	name = "Exemption from Religious Cruelty Liability"
	item = /obj/item/paper/political_PM/bloodseal/exempt_from_cruelty
	cost = 70
	desc = "YOU WILL BE ALONE. NOT EVEN THE GODS WILL WATCH OVER YOU."
	nicedesc = "Provides members of the guild with a meek veil of protection for religous freedom. Needs to be signed off by the Reverant. Goodluck."

/datum/hate_face_stuff/merchantmerger
	name =	"Guild Merger and Alliance Declaration"
	item = /obj/item/paper/merchant_merger
	cost = 60
	desc = "YOU FLY TOO CLOSE TO THE SUN."
	nicedesc = "Unifies the Merchant and Mercenary guild. Provides a way for merchants to sell head. Needs to be signed off by the Merchant."

/datum/hate_face_stuff/inn_partner
	name =	"Hospitality Partnership Accord"
	item = /obj/item/paper/inn_partnership
	cost = 60
	desc = "THEY WON'T BE ANY WISER."
	nicedesc = "Blossoms a partnership between the inn and the guild, allows the inn to set up their own HAILERs. Needs to be signed off by the Innkeeper."

/datum/hate_face_stuff/merchantprotectionpact //this is actually a merchant paperwork, so whenever merchants get the thing to print out their own paperwork move this to that.
	name =	"Guild Safeguard Agreement"
	item = /obj/item/paper/merchantprotectionpact
	cost = 20
	desc = "YOU DO NOT CARE FOR THEIR LIVES."
	nicedesc = "Allows the Merchant's guild to hire the guild's services."

/datum/hate_face_stuff/herovoucher

	name =	"Explorer's Monetary Voucher"
	item = /obj/item/paper/political_PM/herovoucher
	cost = 20
	desc = "DRAIN THEM OF MAMMONS."
	nicedesc = "Distributes vouchers for passing mercenaries and adventurers that can be redeemed for a sum of mammons. Needs to be signed off by the Steward."
