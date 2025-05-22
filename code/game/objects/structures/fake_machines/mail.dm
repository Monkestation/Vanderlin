

/obj/structure/fake_machine/mail
	name = "HERMES"
	desc = "The left side has a slot for incoming letters, the right for sending them." // left hand to get incoming mail, right to send
	icon = 'icons/roguetown/misc/machines.dmi'
	icon_state = "mail"
	density = FALSE
	blade_dulling = DULLING_BASH
	pixel_y = 32
	var/coin_loaded = FALSE
	var/ournum
	var/mailtag
	var/obfuscated = FALSE

/obj/structure/fake_machine/mail/attack_hand(mob/user)
	if(SSroguemachine.hermailermaster && ishuman(user))
		var/obj/item/roguemachine/mastermail/M = SSroguemachine.hermailermaster
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
		if(!addl_mail && is_inquisitor_job(user.mind.assigned_role)) // If the user did not get any mail and is an Inquisitor, open the shop.
			show_inquisitor_shop(user)
			return

/obj/structure/fake_machine/mail/attack_right(mob/user)
	. = ..()
	if(.)
		return
	user.changeNext_move(CLICK_CD_MELEE)
	if(!coin_loaded)
		to_chat(user, "<span class='warning'>The machine doesn't respond. It needs a coin.</span>")
		return
	var/send2place = input(user, "Where to? (Person or #number)", "VANDERLIN", null)
	if(!send2place)
		return
	var/sentfrom = input(user, "Who is this letter from?", "VANDERLIN", null)
	if(!sentfrom)
		sentfrom = "Anonymous"
	var/t = stripped_multiline_input("Write Your Letter", "VANDERLIN", no_trim=TRUE)
	if(t)
		if(length(t) > 2000)
			to_chat(user, "<span class='warning'>Too long. Try again.</span>")
			return
	if(!coin_loaded)
		return
	if(!Adjacent(user))
		return
	var/obj/item/paper/P = new
	P.info += t
	P.mailer = sentfrom
	P.mailedto = send2place
	P.update_icon()
	if(findtext(send2place, "#"))
		var/box2find = text2num(copytext(send2place, findtext(send2place, "#")+1))
		var/found = FALSE
		for(var/obj/structure/fake_machine/mail/X in SSroguemachine.hermailers)
			if(X.ournum == box2find)
				found = TRUE
				P.mailer = sentfrom
				P.mailedto = send2place
				P.update_icon()
				P.forceMove(X.loc)
				X.say("New mail!")
				playsound(X, 'sound/misc/mail.ogg', 100, FALSE, -1)
				break
		if(found)
			visible_message("<span class='warning'>[user] sends something.</span>")
			playsound(loc, 'sound/misc/disposalflush.ogg', 100, FALSE, -1)
			SStreasury.give_money_treasury(coin_loaded, "Mail Income")
			coin_loaded = FALSE
			update_icon()
			return
		else
			to_chat(user, "<span class='warning'>Failed to send it. Bad number?</span>")
	else
		if(!send2place)
			return
		if(SSroguemachine.hermailermaster)
			var/obj/item/roguemachine/mastermail/X = SSroguemachine.hermailermaster
			P.mailer = sentfrom
			P.mailedto = send2place
			P.update_icon()
			P.forceMove(X.loc)
			var/datum/component/storage/STR = X.GetComponent(/datum/component/storage)
			STR.handle_item_insertion(P, prevent_warning=TRUE)
			X.new_mail=TRUE
			X.update_icon()
			send_ooc_note("New letter from <b>[sentfrom].</b>", name = send2place)
		else
			to_chat(user, "<span class='warning'>The master of mails has perished?</span>")
			return
		visible_message("<span class='warning'>[user] sends something.</span>")
		playsound(loc, 'sound/misc/disposalflush.ogg', 100, FALSE, -1)
		SStreasury.give_money_treasury(coin_loaded, "Mail")
		coin_loaded = FALSE
		update_icon()

/obj/structure/fake_machine/mail/attackby(obj/item/P, mob/user, params)
	if(istype(P, /obj/item/merctoken))
		if(!ishuman(user))
			to_chat(user, span_warning("I do not know what this is, and I do not particularly care."))

		var/mob/living/carbon/human/H = user
		if(is_merchant_job(H.mind.assigned_role) || is_gaffer_job(H.mind.assigned_role))
			to_chat(H, span_warning("This is of no use to me - I may give this to a mercenary so they may send it themselves."))
			return
		if(!is_mercenary_job(H.mind.assigned_role))
			to_chat(H, span_warning("I can't make use of this - I do not belong to the Guild."))
			return
		if(H.tokenclaimed)
			to_chat(H, span_warning("I have already received my commendation. There's always next month to look forward to."))
			return
		var/obj/item/merctoken/C = P
		if(!C.signee)
			to_chat(H, span_warning("I cannot send an unsigned token."))
			return
		qdel(C)
		visible_message(span_warning("[H] sends something."))
		playsound(loc, 'sound/misc/disposalflush.ogg', 100, FALSE, -1)

		sleep(2 SECONDS) //should be a callback...

		say("THANK YOU FOR YOUR SERVITUDE.")
		playsound(loc, 'sound/misc/mercsuccess.ogg', 100, FALSE, -1)
		playsound(src.loc, 'sound/misc/hiss.ogg', 100, FALSE, -1)
		to_chat(H, span_warning("A trinket comes tumbling down from the machine. Proof of your distinction."))
		H.adjust_triumphs(3)
		H.tokenclaimed = TRUE
		var/turf/drop_location = drop_location()
		switch(H.merctype)
			if(0)
				new /obj/item/clothing/neck/shalal(drop_location)
			if(1)
				new /obj/item/clothing/neck/mercmedal/zybatine(drop_location)
			if(2)
				new /obj/item/clothing/neck/mercmedal/grenzelhoft(drop_location)
			if(3)
				new /obj/item/clothing/neck/mercmedal/underdweller(drop_location)
			if(4)
				new /obj/item/clothing/neck/mercmedal/blackoak(drop_location)
			if(5)
				new /obj/item/clothing/neck/mercmedal/steppesman(drop_location)
			if(6)
				new /obj/item/clothing/neck/mercmedal/boltslinger(drop_location)
			if(7)
				new /obj/item/clothing/neck/mercmedal/anthrax(drop_location)

	if(istype(P, /obj/item/paper/confession))
		if(is_inquisitor_job(user.mind.assigned_role) || is_adept_job(user.mind.assigned_role)) // Only Inquisitors and Adepts can sumbit confessions.
			process_confession(user, P)
			return
	if(istype(P, /obj/item/paper))
		if(P.w_class >= WEIGHT_CLASS_BULKY)
			return
		if(alert(user, "Send Mail?",,"YES","NO") == "YES")
			var/send2place = input(user, "Where to? (Person or #number)", "VANDERLIN", null)
			var/sentfrom = input(user, "Who is this from?", "VANDERLIN", null)
			if(!sentfrom)
				sentfrom = "Anonymous"
			if(findtext(send2place, "#"))
				var/box2find = text2num(copytext(send2place, findtext(send2place, "#")+1))
				var/found = FALSE
				for(var/obj/structure/fake_machine/mail/X in SSroguemachine.hermailers)
					if(X.ournum == box2find)
						found = TRUE
						P.mailer = sentfrom
						P.mailedto = send2place
						P.update_icon()
						P.forceMove(X.loc)
						X.say("New mail!")
						playsound(X, 'sound/misc/mail.ogg', 100, FALSE, -1)
						playsound(src.loc, 'sound/misc/hiss.ogg', 100, FALSE, -1)
						break
				if(found)
					visible_message("<span class='warning'>[user] sends something.</span>")
					playsound(loc, 'sound/misc/disposalflush.ogg', 100, FALSE, -1)
					return
				else
					to_chat(user, "<span class='warning'>Cannot send it. Bad number?</span>")
			else
				if(!send2place)
					return
				var/findmaster
				if(SSroguemachine.hermailermaster)
					var/obj/item/roguemachine/mastermail/X = SSroguemachine.hermailermaster
					findmaster = TRUE
					P.mailer = sentfrom
					P.mailedto = send2place
					P.update_icon()
					P.forceMove(X.loc)
					var/datum/component/storage/STR = X.GetComponent(/datum/component/storage)
					STR.handle_item_insertion(P, prevent_warning=TRUE)
					X.new_mail=TRUE
					X.update_icon()
					playsound(src.loc, 'sound/misc/hiss.ogg', 100, FALSE, -1)
				if(!findmaster)
					to_chat(user, "<span class='warning'>The master of mails has perished?</span>")
				else
					visible_message("<span class='warning'>[user] sends something.</span>")
					playsound(loc, 'sound/misc/disposalflush.ogg', 100, FALSE, -1)
					send_ooc_note("<span class='boldnotice'>New letter from <b>[sentfrom].</b></span>", name = send2place)
					return
	if(istype(P, /obj/item/coin))
		if(coin_loaded)
			return
		var/obj/item/coin/C = P
		if(C.quantity > 1)
			return
		coin_loaded = C.get_real_price()
		qdel(C)
		playsound(src, 'sound/misc/coininsert.ogg', 100, FALSE, -1)
		update_icon()
		return
	..()

/obj/structure/fake_machine/mail/Initialize()
	. = ..()
	SSroguemachine.hermailers += src
	ournum = SSroguemachine.hermailers.len
	name = "[name] #[ournum]"
	update_icon()

/obj/structure/fake_machine/mail/Destroy()
	set_light(0)
	SSroguemachine.hermailers -= src
	return ..()

/obj/structure/fake_machine/mail/r
	pixel_y = 0
	pixel_x = 32

/obj/structure/fake_machine/mail/l
	pixel_y = 0
	pixel_x = -32

/obj/structure/fake_machine/mail/update_icon()
	cut_overlays()
	if(coin_loaded)
		add_overlay(mutable_appearance(icon, "mail-f"))
		set_light(1, 1, 1, l_color =  "#ff0d0d")
	else
		add_overlay(mutable_appearance(icon, "mail-s"))
		set_light(1, 1, 1, l_color =  "#1b7bf1")

/obj/structure/fake_machine/mail/examine(mob/user)
	. = ..()
	. += "<a href='byond://?src=[REF(src)];directory=1'>Directory:</a> [mailtag]"

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

/obj/item/roguemachine/mastermail
	name = "MASTER OF MAILS"
	icon = 'icons/roguetown/misc/machines.dmi'
	icon_state = "mailspecial"
	pixel_y = 32
	max_integrity = 0
	density = FALSE
	blade_dulling = DULLING_BASH
	anchored = TRUE
	w_class = WEIGHT_CLASS_GIGANTIC
	var/new_mail

/obj/item/roguemachine/mastermail/update_icon()
	cut_overlays()
	if(new_mail)
		icon_state = "mailspecial-get"
	else
		icon_state = "mailspecial"
	set_light(1, 1, 1, l_color = "#ff0d0d")

/obj/item/roguemachine/mastermail/ComponentInitialize()
	. = ..()
	AddComponent(/datum/component/storage/concrete/grid/mailmaster)

/obj/item/roguemachine/mastermail/attack_hand(mob/user)
	var/datum/component/storage/CP = GetComponent(/datum/component/storage)
	if(CP)
		if(new_mail)
			new_mail = FALSE
			update_icon()
		CP.rmb_show(user)
		return TRUE

/obj/item/roguemachine/mastermail/Initialize()
	. = ..()
	SSroguemachine.hermailermaster = src
	update_icon()

/obj/item/roguemachine/mastermail/attackby(obj/item/P, mob/user, params)
	if(istype(P, /obj/item/paper))
		var/obj/item/paper/PA = P
		if(!PA.mailer && !PA.mailedto && PA.cached_mailer && PA.cached_mailedto)
			PA.mailer = PA.cached_mailer
			PA.mailedto = PA.cached_mailedto
			PA.cached_mailer = null
			PA.cached_mailedto = null
			PA.update_icon()
			to_chat(user, "<span class='warning'>I carefully re-seal the letter and place it back in the machine, no one will know.</span>")
		P.forceMove(loc)
		var/datum/component/storage/STR = GetComponent(/datum/component/storage)
		STR.handle_item_insertion(P, prevent_warning=TRUE)
	..()

/obj/item/roguemachine/mastermail/Destroy()
	set_light(0)
	SSroguemachine.hermailers -= src
	var/datum/component/storage/STR = GetComponent(/datum/component/storage)
	if(STR)
		var/list/things = STR.contents()
		for(var/obj/item/I in things)
			STR.remove_from_storage(I, get_turf(src))
	return ..()

/obj/structure/fake_machine/mail/proc/process_confession(mob/living/carbon/human/user, P)
	var/obj/item/paper/confession/C = P
	if(C.signed)
		if(C.signed == user.real_name) // If the Inquisitor is the one who signed the confession, they can't use it.
			return
		if(GLOB.confessors)
			var/no
			if(", [C.signed]" in GLOB.confessors)
				no = TRUE
			if("[C.signed]" in GLOB.confessors)
				no = TRUE
			if(!no)
				if(GLOB.confessors.len)
					GLOB.confessors += ", [C.signed] - a [C.antag]"
				else
					GLOB.confessors += "[C.signed] - a [C.antag]"
		qdel(C)
		visible_message("<span class='warning'>[user] sends something.</span>")
		playsound(loc, 'sound/magic/forgotten_bell.ogg', 80, FALSE, -1)
		playsound(loc, 'sound/misc/disposalflush.ogg', 100, FALSE, -1)
		for(var/mob/living/carbon/human/I in GLOB.human_list) // Find all the living Inquisitors and Adepts and give them a triumph for the confession.
			if(I.mind && (is_inquisitor_job(I.mind.assigned_role) || is_adept_job(I.mind.assigned_role)) && !(I.stat == DEAD))
				if(is_inquisitor_job(I.mind.assigned_role))
					I.confession_points += 5 // Increase the Inquisitor's confession count.
					to_chat(I, "<span class='warning'>-I have gained more favors.</span>")
				to_chat(I, "<span class='warning'>A sense of grim satisfaction fills your heart. One confession down, a million remain.</span>")
				I.adjust_triumphs(1)

/obj/structure/fake_machine/mail/proc/show_inquisitor_shop(mob/living/carbon/human/user)
	var/list/options = list()

	// Ensure the user is an Inquisitor
	if(!user.mind || !is_inquisitor_job(user.mind.assigned_role))
		to_chat(user, "<span class='warning'>You do not have access to the confession system.</span>")
		return

	// Ensure purchase_history is initialized
	if(!user.purchase_history)
		user.purchase_history = list()

	// Define the available items, their costs, and max purchases
	var/list/items = list(
		// Weapons
		"Puffer Pistol- 4 Lead Balls- Powder Flask  (8)" = list(
			list(type = /obj/item/gun/ballistic/revolver/grenadelauncher/pistol, count = 1),
			list(type = /obj/item/storage/belt/pouch/bullets, count = 1),
			list(type = /obj/item/reagent_containers/glass/bottle/aflask, count = 1),
			cost = 8,
			max_purchases = 1
		),
		"Four Spare Lead Balls (5)" = list(
			list(type = /obj/item/ammo_casing/caseless/bullet, count = 4),
			cost = 5,
			max_purchases = 1
		),
		"Psydonian Longsword (8)" = list(
			list(type = /obj/item/weapon/sword/long/psydon, count = 1),
			cost = 8,
			max_purchases = 2
		),
		"Psydonian Greatsword (8)" = list(
			list(type = /obj/item/weapon/sword/long/greatsword/psydon, count = 1),
			cost = 8,
			max_purchases = 1
		),
		"Psydonian Spear (8)" = list(
			list(type = /obj/item/weapon/polearm/spear/psydon, count = 1),
			cost = 8,
			max_purchases = 1
		),
		"Psydonian Halberd (8)" = list(
			list(type = /obj/item/weapon/polearm/halberd/psydon, count = 1),
			cost = 8,
			max_purchases = 1
		),
		"Psydonian Grand Mace (8)" = list(
			list(type = /obj/item/weapon/mace/goden/psydon, count = 1),
			cost = 8,
			max_purchases = 1
		),
		"Psydonian Axe (3)" = list(
			list(type = /obj/item/weapon/axe/psydon, count = 1),
			cost = 3,
			max_purchases = 3
		),
		"Tossblade Belt (Silver) (4)" = list(
			list(type = /obj/item/storage/belt/leather/knifebelt/black/psydon, count = 1),
			cost = 4,
			max_purchases = 1
		),
		"Psydonian Dagger (3)" = list(
			list(type = /obj/item/weapon/knife/dagger/psydon, count = 1),
			cost = 3,
			max_purchases = 3
		),
		"Spare Powder Flask (2)" = list(
			list(type = /obj/item/reagent_containers/glass/bottle/aflask, count = 1),
			cost = 2,
			max_purchases = 1
		),
		"Battle Bomb (3)" = list(
			list(type = /obj/item/bomb, count = 1),
			cost = 3,
			max_purchases = 2
		),
		"Spiked Mace (2)" = list(
			list(type = /obj/item/weapon/mace/spiked, count = 1),
			cost = 2,
			max_purchases = 3
		),
		// Tools
		"Surgery Bag (3)" = list(
			list(type = /obj/item/storage/backpack/satchel/surgbag, count = 1),
			cost = 3,
			max_purchases = 1
		),
		"Three Lockpicks On A Ring (2)" = list(
			list(type = /obj/item/lockpickring/mundane, count = 1),
			cost = 2,
			max_purchases = 5
		),
		"Head Sack (1)" = list(
			list(type = /obj/item/clothing/head/sack, count = 1),
			cost = 1,
			max_purchases = 5
		),
		"Bag of Silver Coins (3)" = list(
			list(type = /obj/item/storage/belt/pouch/coins/rich, count = 1),
			cost = 3,
			max_purchases = 3
		),
		"Vial Of Strong Poison (5)" = list(
			list(type = /obj/item/reagent_containers/glass/bottle/vial/strongpoison, count = 1),
			cost = 5,
			max_purchases = 1
		),
		"Vial Of Antidote (2)" = list(
			list(type = /obj/item/reagent_containers/glass/bottle/vial/antidote, count = 1),
			cost = 2,
			max_purchases = 1
		),
		// Clothing
		"Silver Psycross (2)" = list(
			list(type = /obj/item/clothing/neck/psycross/silver, count = 1),
			cost = 2,
			max_purchases = 4
		),
		"Valorian Cloak (2)" = list(
			list(type = /obj/item/clothing/cloak/cape/inquisitor, count = 1),
			cost = 2,
			max_purchases = 1
		),
		"Inquisitorial Hat (2)" = list(
			list(type = /obj/item/clothing/head/leather/inqhat, count = 1),
			cost = 2,
			max_purchases = 1
		),
		"Crimson Spectacles (1)" = list(
			list(type = /obj/item/clothing/face/spectacles/inqglasses, count = 1),
			cost = 1,
			max_purchases = 1
		),
		"Inquisitorial Duster (3)" = list(
			list(type = /obj/item/clothing/armor/medium/scale/inqcoat, count = 1),
			cost = 3,
			max_purchases = 1
		),
		"Plate Vambraces (2)" = list(
			list(type = /obj/item/clothing/wrists/bracers, count = 1),
			cost = 2,
			max_purchases = 4
		),
		"Chain Gauntlets (3)" = list(
			list(type = /obj/item/clothing/gloves/chain, count = 2),
			cost = 3,
			max_purchases = 4
		),
	)

	// Populate the options for the shop interface
	for(var/name in items)
		var/item_data = items[name]
		var/item_cost = item_data["cost"]
		var/max_purchases = item_data["max_purchases"]
		var/purchase_count = user.purchase_history[name] || 0

		// If the item has been purchased the maximum number of times, disable it
		if(purchase_count >= max_purchases)
			options[name] = "[name] - SOLD OUT"
		else
			options[name] = "[name] - [item_cost] confession(s)"

	// Ask the user to select an item
	var/selection = input(user, "Select an item to request", "I have [user.confession_points] favors left...") as null | anything in options
	if(!selection)
		return

	// Retrieve the selected item details
	var/item_data = items[selection]
	var/item_cost = item_data["cost"]
	var/max_purchases = item_data["max_purchases"]
	var/purchase_count = user.purchase_history[selection] || 0

	// Check if we are still next to the mailer.
	if(!Adjacent(user))
		return

	// Check if the item is sold out
	if(purchase_count >= max_purchases)
		to_chat(user, "<span class='warning'>This item is sold out.</span>")
		return

	// Get the current confession points from the user
	var/current_points = user.confession_points || 0
	if(current_points < item_cost)
		to_chat(user, "<span class='warning'>You do not have enough favors.</span>")
		return

	// Deduct the points and give the items
	user.confession_points -= item_cost
	user.purchase_history[selection] = purchase_count + 1

	// Loop through the sub-list to generate multiple items
	for(var/item in item_data)
		if(islist(item)) // Ensure this is an item list and not the cost/max_purchase entry
			var/item_type = item["type"]
			var/item_count = item["count"]
			if(item_type && item_count) // Ensure the item list has both type and count defined
				for(var/i = 1 to item_count)
					var/obj/item/I = new item_type(get_turf(user)) // Create the item at the user's location
					if(!user.put_in_hands(I)) // Try to put the item in the user's hands
						I.forceMove(get_turf(user)) // If not, drop it at the user's location

	visible_message("<span class='warning'>The mailbox spits out its contents.</span>")
	say("HERE IS THE REQUESTED ITEM. WE HOPE IT SERVES YOU WELL.",language = /datum/language/oldpsydonic)
	playsound(src, 'sound/misc/machinelong.ogg', 100, FALSE, -1)
	return
