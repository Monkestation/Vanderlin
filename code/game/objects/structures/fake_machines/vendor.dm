/obj/structure/fake_machine/vendor
	name = "PEDDLER"
	desc = "The stomach of this thing can be stuffed with fun things for you to buy."
	icon = 'icons/roguetown/misc/machines.dmi'
	icon_state = "streetvendor1"
	density = TRUE
	blade_dulling = DULLING_BASH
	integrity_failure = 0.1
	anchored = TRUE
	layer = BELOW_OBJ_LAYER
	rattle_sound = 'sound/misc/machineno.ogg'
	unlock_sound = 'sound/misc/beep.ogg'
	lock_sound = 'sound/misc/beep.ogg'
	lock = /datum/lock/key/vendor
	var/list/held_items = list()
	var/budget = 0
	var/wgain = 0
	/// Max amount of items we can sell
	var/max_merchandise = 15
	/// Overlay used when theres items inside and we are locked
	var/filled_overlay = "vendor-gen"
	/// Light color used when theres items inside and we are locked
	var/lighting_color = "#cf7214"
	/// Tracking the hawking
	var/next_hawk = 0

/obj/structure/fake_machine/vendor/Initialize()
	. = ..()
	update_appearance(UPDATE_ICON_STATE)
	START_PROCESSING(SSroguemachine, src)

/obj/structure/fake_machine/vendor/Destroy(force)
	STOP_PROCESSING(SSroguemachine, src)
	return ..()

/obj/structure/fake_machine/vendor/on_lock_add()
	update_appearance(UPDATE_ICON_STATE)

/obj/structure/fake_machine/vendor/on_lock(mob/living/user, silent)
	. = ..()
	update_appearance(UPDATE_ICON)

/obj/structure/fake_machine/vendor/on_unlock(mob/living/user, silent)
	. = ..()
	update_appearance(UPDATE_ICON)

/obj/structure/fake_machine/vendor/atom_break(damage_flag)
	. = ..()
	for(var/obj/item/I as anything in held_items)
		I.forceMove(loc)
		held_items -= I
	budget2change(budget)
	update_appearance(UPDATE_ICON)

/obj/structure/fake_machine/vendor/atom_fix()
	. = ..()
	update_appearance(UPDATE_ICON)

/obj/structure/fake_machine/vendor/Destroy()
	for(var/obj/item/I as anything in held_items)
		I.forceMove(loc)
		held_items -= I
	budget2change(budget)
	return ..()

/obj/structure/fake_machine/vendor/update_icon_state()
	. = ..()
	var/state = locked() && !obj_broken
	icon_state = "streetvendor[state]"

/obj/structure/fake_machine/vendor/update_overlays()
	. = ..()
	if(!length(held_items) || !locked() || obj_broken)
		set_light(0)
		return
	set_light(1, 1, 1, l_color = lighting_color)
	. += mutable_appearance(icon, filled_overlay)

/obj/structure/fake_machine/vendor/attackby(obj/item/I, mob/user, list/modifiers)
	if(istype(I, /obj/item/coin))
		if(!lock_check())
			to_chat(user, span_notice("There is no lock on \the [src]! It is not ready to sell!"))
			return
		var/money = I.get_real_price()
		budget += money
		qdel(I)
		to_chat(user, span_info("I put [money] mammon in \the [src]."))
		playsound(src, 'sound/misc/machinevomit.ogg', 100, TRUE, -1)
		attack_hand(user)
		return
	return ..()

/obj/structure/fake_machine/vendor/attackby_secondary(obj/item/weapon, mob/user, list/modifiers)
	. = ..()
	if(. == SECONDARY_ATTACK_CANCEL_ATTACK_CHAIN)
		return
	if(user.cmode)
		return
	if(!lock_check())
		to_chat(user, span_notice("There is no lock on \the [src]! I won't be able to sell this!"))
		return SECONDARY_ATTACK_CANCEL_ATTACK_CHAIN
	add_merchandise(weapon, user)
	return SECONDARY_ATTACK_CANCEL_ATTACK_CHAIN

/obj/structure/fake_machine/vendor/proc/add_merchandise(obj/item/I, mob/user)
	if(QDELETED(I) || !isitem(I))
		return
	if(locked())
		to_chat(user, span_info("I cannot put [I] in \the [src] while it's locked."))
		return
	if(I.w_class > WEIGHT_CLASS_BULKY)
		to_chat(user, span_info("[I] is too big for \the [src]!"))
		return
	if(length(held_items) > max_merchandise)
		to_chat(user, span_info("\The [src] is full!"))
		return
	held_items[I] = list()
	held_items[I]["NAME"] = I.name
	held_items[I]["PRICE"] = 0
	I.forceMove(src)
	playsound(src, 'sound/misc/machinevomit.ogg', 100, TRUE, -1)
	update_appearance(UPDATE_ICON)

/obj/structure/fake_machine/vendor/Topic(href, href_list)
	. = ..()
	if(href_list["buy"])
		var/obj/item/O = locate(href_list["buy"]) in held_items
		if(!O || !istype(O))
			return
		if(!usr.can_perform_action(src, NEED_DEXTERITY|FORBID_TELEKINESIS_REACH) || !locked())
			return
		if(ishuman(usr))
			if(held_items[O]["PRICE"])
				if(budget >= held_items[O]["PRICE"])
					budget -= held_items[O]["PRICE"]
					wgain += held_items[O]["PRICE"]
				else
					say("NO MONEY NO HONEY!")
					return
			record_round_statistic(STATS_PEDDLER_REVENUE, held_items[O]["PRICE"])
			held_items -= O
			if(!usr.put_in_hands(O))
				O.forceMove(get_turf(src))
			update_appearance(UPDATE_OVERLAYS)
	if(href_list["retrieve"])
		var/obj/item/O = locate(href_list["retrieve"]) in held_items
		if(!O || !istype(O))
			return
		if(!usr.can_perform_action(src, NEED_DEXTERITY|FORBID_TELEKINESIS_REACH) || locked())
			return
		if(ishuman(usr))
			held_items -= O
			if(!usr.put_in_hands(O))
				O.forceMove(get_turf(src))
			update_appearance(UPDATE_OVERLAYS)
	if(href_list["change"])
		if(!usr.can_perform_action(src, NEED_DEXTERITY|FORBID_TELEKINESIS_REACH) || !locked())
			return
		if(ishuman(usr))
			if(budget > 0)
				budget2change(budget, usr)
				budget = 0
	if(href_list["withdrawgain"])
		if(!usr.can_perform_action(src, NEED_DEXTERITY|FORBID_TELEKINESIS_REACH) || locked())
			return
		if(ishuman(usr))
			if(wgain > 0)
				budget2change(wgain, usr)
				wgain = 0
	if(href_list["setname"])
		var/obj/item/O = locate(href_list["setname"]) in held_items
		if(!O || !istype(O))
			return
		if(!usr.can_perform_action(src, NEED_DEXTERITY|FORBID_TELEKINESIS_REACH) || locked())
			return
		if(ishuman(usr))
			var/prename
			if(held_items[O]["NAME"])
				prename = held_items[O]["NAME"]
			var/newname = browser_input_text(usr, "SET A NEW NAME FOR THIS PRODUCT", src, prename, max_length = MAX_NAME_LEN)
			if(newname)
				held_items[O]["NAME"] = newname
	if(href_list["setprice"])
		var/obj/item/O = locate(href_list["setprice"]) in held_items
		if(!O || !istype(O))
			return
		if(!usr.can_perform_action(src, NEED_DEXTERITY|FORBID_TELEKINESIS_REACH) || locked())
			return
		if(ishuman(usr))
			var/preprice
			if(held_items[O]["PRICE"])
				preprice = held_items[O]["PRICE"]
			var/newprice = input(usr, "SET A NEW PRICE FOR THIS PRODUCT", src, preprice) as null|num
			if(newprice)
				if(findtext(num2text(newprice), "."))
					return attack_hand(usr)
				held_items[O]["PRICE"] = newprice
	return attack_hand(usr)

/obj/structure/fake_machine/vendor/attack_hand(mob/living/user)
	. = ..()
	if(.)
		return
	user.changeNext_move(CLICK_CD_MELEE)
	playsound(src, 'sound/misc/beep.ogg', 100, FALSE, -1)
	var/canread = user.can_read(src, TRUE)
	var/contents
	if(canread)
		contents = "<center>THE PEDDLER, THIRD ITERATION<BR>"
		if(locked())
			contents += "<a href='byond://?src=[REF(src)];change=1'>Stored Mammon:</a> [budget]<BR>"
		else
			contents += "<a href='byond://?src=[REF(src)];withdrawgain=1'>Stored Profits:</a> [wgain]<BR>"
	else
		contents = "<center>[stars("THE PEDDLER, THIRD ITERATION")]<BR>"
		if(locked())
			contents += "<a href='byond://?src=[REF(src)];change=1'>[stars("Stored Mammon:")]</a> [budget]<BR>"
		else
			contents += "<a href='byond://?src=[REF(src)];withdrawgain=1'>[stars("Stored Profits:")]</a> [wgain]<BR>"

	contents += "</center>"

	for(var/I in held_items)
		var/price = held_items[I]["PRICE"]
		var/namer = held_items[I]["NAME"]
		if(!price)
			price = "0"
		if(!namer)
			held_items[I]["NAME"] = "thing"
			namer = "thing"
		if(locked())
			if(canread)
				contents += "[icon2html(I, user)] [namer] - [price] <a href='byond://?src=[REF(src)];buy=[REF(I)]'>BUY</a>"
			else
				contents += "[icon2html(I, user)] [stars(namer)] - [price] <a href='byond://?src=[REF(src)];buy=[REF(I)]'>[stars("BUY")]</a>"
		else
			if(canread)
				contents += "[icon2html(I, user)] <a href='byond://?src=[REF(src)];setname=[REF(I)]'>[namer]</a> - <a href='byond://?src=[REF(src)];setprice=[REF(I)]'>[price]</a> <a href='byond://?src=[REF(src)];retrieve=[REF(I)]'>TAKE</a>"
			else
				contents += "[icon2html(I, user)] <a href='byond://?src=[REF(src)];setname=[REF(I)]'>[stars(namer)]</a> - <a href='byond://?src=[REF(src)];setprice=[REF(I)]'>[price]</a> <a href='byond://?src=[REF(src)];retrieve=[REF(I)]'>[stars("TAKE")]</a>"
		contents += "<BR>"

	var/datum/browser/popup = new(user, "VENDORTHING", "", 370, 400)
	popup.set_content(contents)
	popup.open()

/obj/structure/fake_machine/vendor/process()
	if(obj_broken)
		return
	if(world.time > next_hawk)
		next_hawk = world.time + rand(1 MINUTES, 2 MINUTES)
		if(length(held_items))
			var/item = pick(held_items)
			var/sale = LAZYACCESSASSOC(held_items, item, "NAME")
			var/price = LAZYACCESSASSOC(held_items, item, "PRICE")
			say("[sale] for sale! [price] mammons!")

/obj/structure/fake_machine/vendor/nolock
	lock = null
	can_add_lock = TRUE

/obj/structure/fake_machine/vendor/inn
	lockids = list(ACCESS_INN)

/obj/structure/fake_machine/vendor/inn/Initialize()
	. = ..()
	var/obj/I = new /obj/item/key/medroomi(src)
	held_items[I] = list()
	held_items[I]["NAME"] = I.name
	held_items[I]["PRICE"] = 20

/obj/structure/fake_machine/vendor/voyage
	lockids = list(ACCESS_INN)

/obj/structure/fake_machine/vendor/voyage/Initialize()
	. = ..()
	for(var/X in list(/obj/item/key/roomi, /obj/item/key/roomii, /obj/item/key/roomiii))
		var/obj/I = new X(src)
		held_items[I] = list()
		held_items[I]["NAME"] = I.name
		held_items[I]["PRICE"] = 20
	for(var/X in list(/obj/item/key/luxroomi))
		var/obj/I = new X(src)
		held_items[I] = list()
		held_items[I]["NAME"] = I.name
		held_items[I]["PRICE"] = 60

/obj/structure/fake_machine/vendor/steward
	lockids = list(ACCESS_STEWARD)
	light_color = "#1b7bf1"
	filled_overlay = "vendor-merch"

/obj/structure/fake_machine/vendor/steward/Initialize()
	. = ..()
	for(var/X in list(/obj/item/key/shops/shop4))
		var/obj/I = new X(src)
		held_items[I] = list()
		held_items[I]["NAME"] = I.name
		held_items[I]["PRICE"] = 20
	for(var/X in list(/obj/item/key/houses/house1, /obj/item/key/houses/house2, /obj/item/key/houses/house3)) ///why was house 1 not here?
		var/obj/I = new X(src)
		held_items[I] = list()
		held_items[I]["NAME"] = I.name
		held_items[I]["PRICE"] = 100
	var/obj/I = new /obj/item/key/houses/house7(src) ///house 7 doesn't exist on Vanderlin. need to make map specific peddlers if we want to continue doing this.
	held_items[I] = list()
	held_items[I]["NAME"] = I.name
	held_items[I]["PRICE"] = 120

/obj/structure/fake_machine/vendor/apothecary
	name = "DRUG PEDDLER"
	lockids = list(ACCESS_APOTHECARY)
	lighting_color = "#8f06b5"
	filled_overlay = "vendor-drug"

/obj/structure/fake_machine/vendor/blacksmith
	lockids = list(ACCESS_SMITH)

/obj/structure/fake_machine/vendor/inn
	name = "INNKEEP"
	lockids = list(ACCESS_INN)

/obj/structure/fake_machine/vendor/voyage
	name = "SHIPMATE"
	lockids = list(ACCESS_INN)

/obj/structure/fake_machine/vendor/butcher
	name = "BUTCHER"
	lockids = list(ACCESS_BUTCHER)
	lighting_color = "#8d1818"
	filled_overlay = "vendor-butcher"

/obj/structure/fake_machine/vendor/soilson
	name = "FARMHAND"
	lockids = list(ACCESS_FARM)
	lighting_color = "#707a24"
	filled_overlay = "vendor-farm"

/obj/structure/fake_machine/vendor/merchant
	name = "SHOPHAND"
	lockids = list(ACCESS_MERCHANT)
	lighting_color = "#1b7bf1"
	filled_overlay = "vendor-merch"

/obj/structure/fake_machine/vendor/centcom
	name = "LANDLORD"
	desc = "Give this thing money, and you will immediately buy a neat property in the capital."
	icon_state = "streetvendor1"
	var/list/cachey = list()

/obj/structure/fake_machine/vendor/centcom/attack_hand(mob/living/user)
	return

/obj/structure/fake_machine/vendor/centcom/attackby(obj/item/P, mob/user, list/modifiers)
	if(istype(P, /obj/item/coin))
		if(!cachey[user])
			cachey[user] = list()
		cachey[user]["moneydonate"] += P.get_real_price()
		qdel(P)
		playsound(src, 'sound/misc/machinevomit.ogg', 100, TRUE, -1)

		if(cachey[user]["moneydonate"] > 99)
			if(!cachey[user]["trisawarded"])
				cachey[user]["trisawarded"] = 1
				user.adjust_triumphs(1)
				say("[user] has purchased a prole dwelling.")
				playsound(src, 'sound/misc/machinetalk.ogg', 100, FALSE, -1)
		if(cachey[user]["moneydonate"] > 499)
			if(cachey[user]["trisawarded"] < 2)
				cachey[user]["trisawarded"] = 2
				user.adjust_triumphs(1)
				say("[user] has been upgraded to a space in a serf apartment.")
				playsound(src, pick('sound/misc/machinetalk.ogg'), 100, FALSE, -1)
		if(cachey[user]["moneydonate"] > 999)
			if(cachey[user]["trisawarded"] < 3)
				cachey[user]["trisawarded"] = 3
				user.adjust_triumphs(1)
				say("[user] HAS BEEN UPGRADED TO A NOBLE BEDCHAMBER!")
				playsound(src, 'sound/misc/machinelong.ogg', 100, FALSE, -1)
