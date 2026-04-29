/obj/structure/fake_machine/stockpile
	name = "stockpile"
	desc = ""
	icon = 'icons/roguetown/misc/machines.dmi'
	icon_state = "stockpile_vendor"
	density = FALSE
	blade_dulling = DULLING_BASH
	SET_BASE_PIXEL(0, 32)
	var/stockpile_index = 1
	var/datum/withdraw_tab/withdraw_tab = null

/obj/structure/fake_machine/stockpile/Initialize()
	. = ..()
	SSroguemachine.stock_machines += src
	withdraw_tab = new(stockpile_index, src)

/obj/structure/fake_machine/stockpile/Destroy()
	SSroguemachine.stock_machines -= src
	QDEL_NULL(withdraw_tab)
	return ..()

/obj/structure/fake_machine/stockpile/Topic(href, href_list)
	. = ..()
	if(!usr.can_perform_action(src, NEED_DEXTERITY|FORBID_TELEKINESIS_REACH))
		return
	if(href_list["navigate"])
		return attack_hand(usr, href_list["navigate"])

	if(withdraw_tab.perform_action(href, href_list))
		if(href_list["remote"])
			playsound(src, 'sound/misc/disposalflush.ogg', 100, FALSE, -1)
		return attack_hand(usr, "withdraw")

	// If we don't get a valid option, default to returning to the directory
	return attack_hand(usr, "directory")


/obj/structure/fake_machine/stockpile/proc/get_directory_contents()
	var/contents = "<center>TOWN STOCKPILE<BR>"
	contents += "--------------<BR>"

	contents += "<a href='byond://?src=[REF(src)];navigate=withdraw'>EXTRACT</a><BR>"
	contents += "<a href='byond://?src=[REF(src)];navigate=deposit'>FEED</a></center><BR><BR>"

	return contents

/obj/structure/fake_machine/stockpile/proc/get_withdraw_contents()
	return withdraw_tab.get_contents("EXTRACT FROM THE STOCKPILE", TRUE)

/obj/structure/fake_machine/stockpile/proc/get_deposit_contents()
	var/contents = "<center>FEED THE STOCKPILE<BR>"
	contents += "<a href='byond://?src=[REF(src)];navigate=directory'>(back)</a><BR>"
	contents += "----------<BR>"
	contents += "</center>"

	for(var/datum/stock/bounty/R in SStreasury.stockpile_datums)
		contents += "[R.name] - [R.payout_price][R.percent_bounty ? "%" : ""]"
		contents += "<BR>"

	contents += "<BR>"

	for(var/datum/stock/stockpile/R in SStreasury.stockpile_datums)
		var/message = "[R.name] - Payout: [R.get_payout_price()] - Stockpiled: [R.get_held_count()] - Oversupply at: [R.oversupply_amount]"
		if(R.get_held_count() >= R.oversupply_amount)
			message += " - !OVERSUPPLIED!"
		contents += message
		contents += "<BR>"

	return contents

/obj/structure/fake_machine/stockpile/attack_hand(mob/living/user, menu_name)
	. = ..()
	if(.)
		return
	user.changeNext_move(CLICK_CD_MELEE)
	playsound(src, 'sound/misc/keyboard_enter.ogg', 100, FALSE, -1)

	var/contents
	if(menu_name == "withdraw")
		contents = get_withdraw_contents()
	else if(menu_name == "deposit")
		contents = get_deposit_contents()
	else
		contents = get_directory_contents()

	var/datum/browser/popup = new(user, "VENDORTHING", "", 370, 800)
	popup.set_content(contents)
	popup.open()

/obj/structure/fake_machine/stockpile/proc/attemptsell(obj/item/I, mob/H, message = TRUE, sound = TRUE)
	for(var/datum/stock/R in SStreasury.stockpile_datums)
		if(istype(I, /obj/item/natural/bundle))
			var/obj/item/natural/bundle/B = I
			if(B.stacktype == R.item_type)
				var/amt = 0
				if(istype(R, /datum/stock/stockpile))
					for(var/i in 1 to B.amount)
						amt += R.get_payout_price(I)
				else
					amt = R.get_payout_price(I)

				// Move to stockpile instead of deleting
				if(R.add_item_to_stockpile(B))
					if(message == TRUE)
						stock_announce("[B.amount] units of [R.name] has been stockpiled.")
					if(sound == TRUE)
						playsound(src, 'sound/misc/hiss.ogg', 100, FALSE, -1)
					if(!SStreasury.give_money_account(amt, H, "+[amt] from [R.name] bounty") && message == TRUE)
						say("No account found. Submit your fingers to a Meister for inspection.")
					record_round_statistic(STATS_STOCKPILE_EXPANSES, amt)
					return amt
			continue
		else if(I.type == R.item_type)
			if(!R.check_item(I))
				continue
			var/amt = R.get_payout_price(I)
			if(!R.transport_item)
				// Move to stockpile instead of deleting
				if(R.add_item_to_stockpile(I))
					if(message == TRUE)
						stock_announce("[R.name] has been stockpiled.")
					if(sound == TRUE)
						playsound(src, 'sound/misc/hiss.ogg', 100, FALSE, -1)
				else
					say("Stockpile area not accessible.")
					return
			else
				var/area/A = GLOB.areas_by_type[R.transport_item]
				if(!A && message == TRUE)
					say("Couldn't find where to send the submission.")
					return
				var/list/turfs = list()
				for(var/turf/T in A.get_turfs_from_all_zlevels())
					turfs += T
				var/turf/T = pick(turfs)
				I.forceMove(T)
				if(sound == TRUE)
					playsound(src, 'sound/misc/hiss.ogg', 100, FALSE, -1)
					playsound(src, 'sound/misc/disposalflush.ogg', 100, FALSE, -1)
			if(amt)
				if(!SStreasury.give_money_account(amt, H, "+[amt] from [R.name] bounty") && message == TRUE)
					say("No account found. Submit your fingers to a Meister for inspection.")
				record_round_statistic(STATS_STOCKPILE_EXPANSES, amt)
			return amt

/obj/structure/fake_machine/stockpile/attackby(obj/item/P, mob/user, list/modifiers)
	if(ishuman(user))
		if(user.real_name in GLOB.outlawed_players)
			say("OUTLAW DETECTED! REFUSING SERVICE!")
			return
		if(istype(P, /obj/item/coin))
			withdraw_tab.insert_coins(P)
			return attack_hand(user)
		else
			attemptsell(P, user, TRUE, TRUE)

/obj/structure/fake_machine/stockpile/attack_hand_secondary(mob/user, list/modifiers)
	. = ..()
	if(. == SECONDARY_ATTACK_CANCEL_ATTACK_CHAIN)
		return
	. = SECONDARY_ATTACK_CANCEL_ATTACK_CHAIN
	if(ishuman(user))
		if(user.real_name in GLOB.outlawed_players)
			say("OUTLAW DETECTED! REFUSING SERVICE!")
			return
		var/total_value = 0
		for(var/obj/I in get_turf(src))
			total_value += attemptsell(I, user, FALSE, FALSE)
		playsound(src, 'sound/misc/hiss.ogg', 100, FALSE, -1)
		playsound(src, 'sound/misc/disposalflush.ogg', 100, FALSE, -1)
		if(user in SStreasury.bank_accounts)
			say("Bulk sold for [total_value] mammon...")
		else
			say("No account found. Submit your fingers to a Meister for inspection.")

/datum/withdraw_tab
	var/stockpile_index = -1
	var/budget = 0
	var/compact = FALSE
	var/obj/structure/fake_machine/parent_structure = null

/datum/withdraw_tab/New(stockpile_param, obj/structure/fake_machine/structure_param)
	. = ..()
	stockpile_index = stockpile_param
	parent_structure = structure_param

/datum/withdraw_tab/proc/get_contents(title, show_back)
	var/contents = "<center>[title]<BR>"
	if(show_back)
		contents += "<a href='byond://?src=[REF(parent_structure)];navigate=directory'>(back)</a><BR>"

	contents += "--------------<BR>"
	contents += "<a href='byond://?src=[REF(parent_structure)];change=1'>Stored Mammon: [budget]</a><BR>"
	contents += "<a href='byond://?src=[REF(parent_structure)];compact=1'>Compact Mode: [compact ? "ENABLED" : "DISABLED"]</a></center><BR>"

	if(compact)
		for(var/datum/stock/stockpile/A in SStreasury.stockpile_datums)
			if(!A.withdraw_disabled)
				contents += "<b>[A.name]:</b> <a href='byond://?src=[REF(parent_structure)];withdraw=[REF(A)]'>AMT: [A.get_held_count()] at [A.withdraw_price]m</a><BR>"

			else
				contents += "<b>[A.name]:</b> Withdrawing Disabled..."

	else
		for(var/datum/stock/stockpile/A in SStreasury.stockpile_datums)
			contents += "[A.name]<BR>"
			contents += "[A.desc]<BR>"
			contents += "Stockpiled Amount: [A.get_held_count()]<BR>"
			if(!A.withdraw_disabled)
				contents += "<a href='byond://?src=[REF(parent_structure)];withdraw=[REF(A)]'>\[Withdraw ([A.withdraw_price])\] </a><BR>"
			else
				contents += "Withdrawing Disabled...<BR><BR>"

	return contents

/datum/withdraw_tab/proc/perform_action(href, href_list)
	if(href_list["withdraw"])
		var/datum/stock/D = locate(href_list["withdraw"]) in SStreasury.stockpile_datums

		var/total_price = D.withdraw_price

		if(!D)
			return FALSE
		if(D.withdraw_disabled)
			return FALSE
		if(D.get_held_count() <= 0)
			parent_structure.say("Insufficient stock.")
		else if(total_price > budget)
			parent_structure.say("Insufficient mammon.")
		else
			var/obj/item/I = D.withdraw_item()
			if(!I)
				parent_structure.say("Could not retrieve item from stockpile.")
				return FALSE

			budget -= total_price
			record_round_statistic(STATS_STOCKPILE_REVENUE, total_price)
			SStreasury.give_money_treasury(D.withdraw_price, "stockpile withdraw")

			var/mob/user = usr
			if(!user.put_in_hands(I))
				I.forceMove(get_turf(user))
			playsound(parent_structure, 'sound/misc/hiss.ogg', 100, FALSE, -1)
		return TRUE
	if(href_list["compact"])
		if(!usr.can_perform_action(parent_structure, NEED_DEXTERITY|FORBID_TELEKINESIS_REACH))
			return FALSE
		if(ishuman(usr))
			compact = !compact
		return TRUE
	if(href_list["change"])
		if(!usr.can_perform_action(parent_structure, NEED_DEXTERITY|FORBID_TELEKINESIS_REACH))
			return FALSE
		if(ishuman(usr))
			if(budget > 0)
				parent_structure.budget2change(budget, usr)
				budget = 0
		return TRUE

/datum/withdraw_tab/proc/insert_coins(obj/item/coin/C)
	budget += C.get_real_price()
	qdel(C)
	playsound(parent_structure, 'sound/misc/coininsert.ogg', 100, TRUE, -1)

/proc/stock_announce(message)
	for(var/obj/structure/fake_machine/stockpile/S in SSroguemachine.stock_machines)
		S.say(message, spans = list("info"))
