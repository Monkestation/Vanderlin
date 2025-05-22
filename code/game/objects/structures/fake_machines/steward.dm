#define TAB_MAIN 1
#define TAB_BANK 2
#define TAB_STOCK 3
#define TAB_IMPORT 4
#define TAB_BOUNTIES 5
#define TAB_LOG 6

/obj/structure/fake_machine/steward
	name = "MASTER OF NERVES"
	desc = ""
	icon = 'icons/roguetown/misc/machines.dmi'
	icon_state = "steward_machine"
	density = TRUE
	blade_dulling = DULLING_BASH
	max_integrity = 0
	anchored = TRUE
	layer = BELOW_OBJ_LAYER

	rattle_sound = 'sound/misc/machineno.ogg'
	unlock_sound = 'sound/misc/beep.ogg'
	lock_sound = 'sound/misc/beep.ogg'
	lock = /datum/lock/key/nerve

	var/current_tab = TAB_MAIN
	var/compact = FALSE

/obj/structure/fake_machine/steward/attackby(obj/item/I, mob/user, params)
	if(istype(I, /obj/item/coin))
		SStreasury.give_money_treasury(I.get_real_price(), "NERVE MASTER deposit")
		qdel(I)
		playsound(src, 'sound/misc/coininsert.ogg', 100, FALSE, -1)
		return
	return ..()

/obj/structure/fake_machine/steward/Topic(href, href_list)
	. = ..()
	if(!usr.canUseTopic(src, BE_CLOSE) || locked())
		return
	if(href_list["switchtab"])
		current_tab = text2num(href_list["switchtab"])
	if(href_list["import"])
		var/datum/stock/D = locate(href_list["import"]) in SStreasury.stockpile_datums
		if(!D)
			return
		if(SStreasury.treasury_value < D.get_import_price())
			say("Insufficient mammon.")
			return
		var/amt = D.get_import_price()
		SStreasury.treasury_value -= amt
		SStreasury.log_to_steward("-[amt] imported [D.name]")
		if(amt >= 100)
			scom_announce("[SSmapping.config.map_name] imports [D.name] for [amt] mammon.")
		else
			say("[SSmapping.config.map_name] imports [D.name] for [amt] mammon.")
		D.raise_demand()
		addtimer(CALLBACK(src, PROC_REF(do_import), D.type), 10 SECONDS)
	if(href_list["export"])
		var/datum/stock/D = locate(href_list["export"]) in SStreasury.stockpile_datums
		if(!D)
			return
		if(D.held_items < D.importexport_amt)
			say("Insufficient stock.")
			return
		var/amt = D.get_export_price()
		D.held_items -= D.importexport_amt
		SStreasury.treasury_value += amt
		SStreasury.log_to_steward("+[amt] exported [D.name]")
		if(amt >= 100)
			scom_announce("[SSmapping.config.map_name] exports [D.name] for [amt] mammon.")
		else
			say("[SSmapping.config.map_name] exports [D.name] for [amt] mammon.")
		D.lower_demand()
	if(href_list["togglewithdraw"])
		var/datum/stock/D = locate(href_list["togglewithdraw"]) in SStreasury.stockpile_datums
		if(!D)
			return
		D.withdraw_disabled = !D.withdraw_disabled
	if(href_list["setosamount"])
		var/datum/stock/stockpile/D = locate(href_list["setosamount"]) in SStreasury.stockpile_datums
		if(!D)
			return
		if(!D.percent_bounty)
			var/newamount = input(usr, "Set a new oversupply amount for [D.name]", src, D.oversupply_amount) as null|num
			if(!usr.canUseTopic(src, BE_CLOSE) || locked())
				return
			if(!isnum(newamount))
				return
			if(findtext(num2text(newamount), "."))
				return
			newamount = max(newamount, 0)
			D.oversupply_amount = newamount
	if(href_list["setosbounty"])
		var/datum/stock/stockpile/D = locate(href_list["setosbounty"]) in SStreasury.stockpile_datums
		if(!D)
			return
		if(!D.percent_bounty)
			var/newtax = input(usr, "Set a new oversupply price for [D.name]", src, D.oversupply_payout) as null|num
			if(!usr.canUseTopic(src, BE_CLOSE) || locked())
				return
			if(!isnum(newtax))
				return
			if(findtext(num2text(newtax), "."))
				return
			newtax = CLAMP(newtax, 0, 999)
			D.oversupply_payout = newtax
	if(href_list["setbounty"])
		var/datum/stock/D = locate(href_list["setbounty"]) in SStreasury.stockpile_datums
		if(!D)
			return
		if(!D.percent_bounty)
			var/newtax = input(usr, "Set a new price for [D.name]", src, D.payout_price) as null|num
			if(!usr.canUseTopic(src, BE_CLOSE) || locked())
				return
			if(!isnum(newtax))
				return
			if(findtext(num2text(newtax), "."))
				return
			newtax = CLAMP(newtax, 0, 999)
			scom_announce("The bounty for [D.name] has been set to [newtax].")
			D.payout_price = newtax
		else
			var/newtax = input(usr, "Set a new percent for [D.name]", src, D.payout_price) as null|num
			if(newtax)
				if(!usr.canUseTopic(src, BE_CLOSE) || locked())
					return
				if(findtext(num2text(newtax), "."))
					return
				newtax = CLAMP(newtax, 1, 99)
				if(newtax > D.payout_price)
					scom_announce("The bounty for [D.name] was increased.")
				D.payout_price = newtax
	if(href_list["setprice"])
		var/datum/stock/D = locate(href_list["setprice"]) in SStreasury.stockpile_datums
		if(!D)
			return
		if(!D.percent_bounty)
			var/newtax = input(usr, "Set a new price to withdraw [D.name]", src, D.withdraw_price) as null|num
			if(newtax)
				if(!usr.canUseTopic(src, BE_CLOSE) || locked())
					return
				if(findtext(num2text(newtax), "."))
					return
				newtax = CLAMP(newtax, 0, 999)
				D.withdraw_price = newtax
	if(href_list["givemoney"])
		var/X = locate(href_list["givemoney"])
		if(!X)
			return
		for(var/mob/living/A in SStreasury.bank_accounts)
			if(A == X)
				var/newtax = input(usr, "How much to give [X]", src) as null|num
				if(!usr.canUseTopic(src, BE_CLOSE) || locked())
					return
				if(findtext(num2text(newtax), "."))
					return
				if(!newtax)
					return
				if(newtax < 1)
					return
				SStreasury.give_money_account(newtax, A)
				break
	if(href_list["fineaccount"])
		var/X = locate(href_list["fineaccount"])
		if(!X)
			return
		for(var/mob/living/A in SStreasury.bank_accounts)
			if(A == X)
				var/newtax = input(usr, "How much to fine [X]", src) as null|num
				if(!usr.canUseTopic(src, BE_CLOSE) || locked())
					return
				if(findtext(num2text(newtax), "."))
					return
				if(!newtax)
					return
				if(newtax < 1)
					return
				SStreasury.give_money_account(-newtax, A)
				break
	if(href_list["payroll"])
		var/list/L = list(GLOB.noble_positions) + list(GLOB.garrison_positions) + list(GLOB.church_positions) + list(GLOB.serf_positions) + list(GLOB.company_positions) + list(GLOB.peasant_positions) + list(GLOB.youngfolk_positions) + list(GLOB.apprentices_positions)
		var/list/jobs = list()
		for(var/list/category in L)
			for(var/A in category)
				jobs += A
		var/job_to_pay = input(usr, "Select a job", src) as null|anything in jobs
		if(!job_to_pay)
			return
		if(!usr.canUseTopic(src, BE_CLOSE) || locked())
			return
		var/amount_to_pay = input(usr, "How much to pay every [job_to_pay]", src) as null|num
		if(!amount_to_pay)
			return
		if(amount_to_pay<1)
			return
		if(!usr.canUseTopic(src, BE_CLOSE) || locked())
			return
		if(findtext(num2text(amount_to_pay), "."))
			return
		for(var/mob/living/carbon/human/H in GLOB.human_list)
			if(H.job == job_to_pay)
				SStreasury.give_money_account(amount_to_pay, H)
	if(href_list["compact"])
		compact = !compact
	return attack_hand(usr)

/obj/structure/fake_machine/steward/proc/do_import(datum/stock/D,number)
	if(!D)
		return
	D = new D
	if(number > D.importexport_amt)
		return
	if(!number)
		number = 1
	var/area/A = GLOB.areas_by_type[/area/rogue/indoors/town/warehouse]
	if(!A)
		return
	var/obj/item/I = new D.item_type()
	var/list/turfs = list()
	for(var/turf/T in A)
		turfs += T
	var/turf/T = pick(turfs)
	I.forceMove(T)
	playsound(T, 'sound/misc/hiss.ogg', 100, FALSE, -1)
	number += 1
	addtimer(CALLBACK(src, PROC_REF(do_import), D.type, number), 3 SECONDS)

/obj/structure/fake_machine/steward/attack_hand(mob/living/user)
	. = ..()
	if(.)
		return
	if(locked())
		to_chat(user, "<span class='warning'>It's locked. Of course.</span>")
		return
	user.changeNext_move(CLICK_CD_MELEE)
	playsound(loc, 'sound/misc/keyboard_enter.ogg', 100, FALSE, -1)
	var/canread = user.can_read(src, TRUE)
	SSassets.transport.send_assets(user?.client, list("try4_border.png", "try5.png", "slop_menustyle2.css"))
	var/contents
	contents += {"
	<!DOCTYPE html>
	<html lang='en'>
	<head>
		<meta charset='UTF-8'>
		<meta http-equiv='X-UA-Compatible' content='IE=edge,chrome=1'/>
		<meta http-equiv='Content-Type' content='text/html; charset=UTF-8'/>
		<style>
			@import url('https://fonts.googleapis.com/css2?family=Tangerine:wght@400;700&display=swap');
			@import url('https://fonts.googleapis.com/css2?family=UnifrakturMaguntia&display=swap');
			@import url('https://fonts.googleapis.com/css2?family=Charm:wght@700&display=swap');
			body {
				background-color: rgb(31, 20, 24);
				background:
					url('[SSassets.transport.get_asset_url("try4_border.png")]'),
					url('[SSassets.transport.get_asset_url("try5.png")]');
				background-repeat: no-repeat;
				background-attachment: fixed;
				background-size: 100% 100%;
			}
		</style>
		<link rel='stylesheet' type='text/css' href='[SSassets.transport.get_asset_url("slop_menustyle2.css")]'>
	</head> "}

	switch(current_tab)
		if(TAB_MAIN)
			contents += "<center>MASTER OF NERVES<BR>"
			contents += "--------------<BR>"
			contents += "<a href='byond://?src=\ref[src];switchtab=[TAB_BANK]'>\[Bank\]</a><BR>"
			contents += "<a href='byond://?src=\ref[src];switchtab=[TAB_STOCK]'>\[Stockpile\]</a><BR>"
			contents += "<a href='byond://?src=\ref[src];switchtab=[TAB_IMPORT]'>\[Import\]</a><BR>"
			contents += "<a href='byond://?src=\ref[src];switchtab=[TAB_BOUNTIES]'>\[Bounties\]</a><BR>"
			contents += "<a href='byond://?src=\ref[src];switchtab=[TAB_LOG]'>\[Log\]</a><BR>"
			contents += "</center>"
		if(TAB_BANK)
			contents += "<a href='byond://?src=\ref[src];switchtab=[TAB_MAIN]'>\[Return\]</a>"
			contents += " <a href='byond://?src=\ref[src];compact=1'>\[Compact: [compact? "ENABLED" : "DISABLED"]\]</a><BR>"
			contents += "<center>Bank<BR>"
			contents += "--------------<BR>"
			contents += "Treasury: [SStreasury.treasury_value]m</center><BR>"
			contents += "<a href='byond://?src=\ref[src];payroll=1'>\[Pay by Class\]</a><BR><BR>"
			if(compact)
				for(var/mob/living/carbon/human/A in SStreasury.bank_accounts)
					if(ishuman(A))
						var/mob/living/carbon/human/tmp = A
						contents += "[tmp.real_name] ([tmp.get_role_title()]) - [SStreasury.bank_accounts[A]]m"
					else
						contents += "[A.real_name] - [SStreasury.bank_accounts[A]]m "
					contents += " / <a href='byond://?src=\ref[src];givemoney=\ref[A]'>\[PAY\]</a> <a href='byond://?src=\ref[src];fineaccount=\ref[A]'>\[FINE\]</a><BR><BR>"
			else
				for(var/mob/living/A in SStreasury.bank_accounts)
					if(ishuman(A))
						var/mob/living/carbon/human/tmp = A
						contents += "[tmp.real_name] ([tmp.get_role_title()]) - [SStreasury.bank_accounts[A]]m<BR>"
					else
						contents += "[A.real_name] - [SStreasury.bank_accounts[A]]m<BR>"
					contents += "<a href='byond://?src=\ref[src];givemoney=\ref[A]'>\[Give Money\]</a> <a href='byond://?src=\ref[src];fineaccount=\ref[A]'>\[Fine Account\]</a><BR><BR>"
		if(TAB_STOCK)
			contents += "<a href='byond://?src=\ref[src];switchtab=[TAB_MAIN]'>\[Return\]</a>"
			contents += " <a href='byond://?src=\ref[src];compact=1'>\[Compact: [compact? "ENABLED" : "DISABLED"]\]</a><BR>"
			contents += "<center>Stockpile<BR>"
			contents += "--------------<BR>"
			if(compact)
				contents += "Treasury: [SStreasury.treasury_value]m"
				contents += " / Lord's Tax: [SStreasury.tax_value*100]%"
				contents += " / Guild's Tax: [SStreasury.queens_tax*100]%</center><BR>"
				for(var/datum/stock/stockpile/A in SStreasury.stockpile_datums)
					contents += "<b>[A.name]:</b>"
					contents += " AMT: [A.held_items]"
					contents += " | PAYOUT: <a href='byond://?src=\ref[src];setbounty=\ref[A]'>[A.payout_price]m</a>"
					contents += " /  WITHDRAW: <a href='byond://?src=\ref[src];setprice=\ref[A]'>[A.withdraw_price]m</a>"
					if(A.importexport_amt)
						contents += " <a href='byond://?src=\ref[src];import=\ref[A]'>\[IMP [A.importexport_amt] ([A.get_import_price()])\]</a> <a href='byond://?src=\ref[src];export=\ref[A]'>\[EXP [A.importexport_amt] ([A.get_export_price()])\]</a> <BR>"
			else
				contents += "Treasury: [SStreasury.treasury_value]m<BR>"
				contents += "Lord's Tax: [SStreasury.tax_value*100]%<BR>"
				contents += "Guild's Tax: [SStreasury.queens_tax*100]%</center><BR>"
				for(var/datum/stock/stockpile/A in SStreasury.stockpile_datums)
					contents += "[A.name]<BR>"
					contents += "[A.desc]<BR>"
					contents += "Stockpiled Amount: [A.held_items]<BR>"
					contents += "Oversupply Amount: <a href='byond://?src=\ref[src];setosamount=\ref[A]'>[A.oversupply_amount]</a><BR>"
					contents += "Bounty Price: <a href='byond://?src=\ref[src];setbounty=\ref[A]'>[A.payout_price]</a><BR>"
					contents += "Oversupply Price: <a href='byond://?src=\ref[src];setosbounty=\ref[A]'>[A.oversupply_payout]</a><BR>"
					contents += "Withdraw Price: <a href='byond://?src=\ref[src];setprice=\ref[A]'>[A.withdraw_price]</a><BR>"
					contents += "Demand: [A.demand2word()]<BR>"
					if(A.importexport_amt)
						contents += "<a href='byond://?src=\ref[src];import=\ref[A]'>\[Import [A.importexport_amt] ([A.get_import_price()])\]</a> <a href='byond://?src=\ref[src];export=\ref[A]'>\[Export [A.importexport_amt] ([A.get_export_price()])\]</a> <BR>"
					contents += "<a href='byond://?src=\ref[src];togglewithdraw=\ref[A]'>\[[A.withdraw_disabled ? "Enable" : "Disable"] Withdrawing\]</a><BR><BR>"
		if(TAB_IMPORT)
			contents += "<a href='byond://?src=\ref[src];switchtab=[TAB_MAIN]'>\[Return\]</a>"
			contents += " <a href='byond://?src=\ref[src];compact=1'>\[Compact: [compact? "ENABLED" : "DISABLED"]\]</a><BR>"
			contents += "<center>Imports<BR>"
			contents += "--------------<BR>"
			if(compact)
				contents += "Treasury: [SStreasury.treasury_value]m"
				contents += " / Lord Tax: [SStreasury.tax_value*100]%"
				contents += " / Guild Tax: [SStreasury.queens_tax*100]%</center><BR>"
				for(var/datum/stock/import/A in SStreasury.stockpile_datums)
					contents += "<b>[A.name]:</b>"
					contents += " <a href='byond://?src=\ref[src];import=\ref[A]'>\[Import [A.importexport_amt] ([A.get_import_price()])\]</a><BR><BR>"
			else
				contents += "Treasury: [SStreasury.treasury_value]m<BR>"
				contents += "Lord's Tax: [SStreasury.tax_value*100]%<BR>"
				contents += "Guild's Tax: [SStreasury.queens_tax*100]%</center><BR>"
				for(var/datum/stock/import/A in SStreasury.stockpile_datums)
					contents += "[A.name]<BR>"
					contents += "[A.desc]<BR>"
					if(!A.stable_price)
						contents += "Demand: [A.demand2word()]<BR>"
					contents += "<a href='byond://?src=\ref[src];import=\ref[A]'>\[Import [A.importexport_amt] ([A.get_import_price()])\]</a><BR><BR>"
		if(TAB_BOUNTIES)
			contents += "<a href='byond://?src=\ref[src];switchtab=[TAB_MAIN]'>\[Return\]</a><BR>"
			contents += "<center>Bounties<BR>"
			contents += "--------------<BR>"
			contents += "Treasury: [SStreasury.treasury_value]m<BR>"
			contents += "Lord's Tax: [SStreasury.tax_value*100]%</center><BR>"
			for(var/datum/stock/bounty/A in SStreasury.stockpile_datums)
				contents += "[A.name]<BR>"
				contents += "[A.desc]<BR>"
				contents += "Total Collected: [A.held_items]<BR>"
				if(A.percent_bounty)
					contents += "Bounty Price: <a href='byond://?src=\ref[src];setbounty=\ref[A]'>[A.payout_price]%</a><BR><BR>"
				else
					contents += "Bounty Price: <a href='byond://?src=\ref[src];setbounty=\ref[A]'>[A.payout_price]</a><BR><BR>"
		if(TAB_LOG)
			contents += "<a href='byond://?src=\ref[src];switchtab=[TAB_MAIN]'>\[Return\]</a><BR>"
			contents += "<center>Log<BR>"
			contents += "--------------</center><BR><BR>"
			for(var/i = SStreasury.log_entries.len to 1 step -1)
				contents += "<span class='info'>[SStreasury.log_entries[i]]</span><BR>"

	contents += {"
		</head>
	</html>
	"}
	if(!canread)
		contents = stars(contents)
	var/datum/browser/popup = new(user, "VENDORTHING", "", 370, 400)
	popup.set_content(contents)
	popup.set_window_options(can_minimize = FALSE, can_maximize = FALSE)
	popup.open()

#undef TAB_MAIN
#undef TAB_BANK
#undef TAB_STOCK
#undef TAB_IMPORT
#undef TAB_BOUNTIES
#undef TAB_LOG
