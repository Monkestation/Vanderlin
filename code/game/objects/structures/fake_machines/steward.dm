/datum/stock/stockpile/custom
	abstract_type = /datum/stock/stockpile/custom
	held_items = 0
	payout_price = 5
	withdraw_price = 5
	withdraw_disabled = FALSE
	demand = 0
	transport_item = FALSE
	export_price = 5
	importexport_amt = 5
	import_only = FALSE
	stable_price = FALSE
	percent_bounty = FALSE
	stockpile_id = STOCK_GENERIC
	var/created_by = "" // Who created this stock
	var/creation_time = 0

/datum/stock/stockpile/custom/New(item_path, creator_name)
	if(item_path)
		item_type = item_path
		var/obj/item/sample = new item_path()
		name = sample.name
		desc = "Custom stock for [sample.name]. Created by [creator_name]."
		created_by = creator_name
		creation_time = world.time
		qdel(sample)
	. = ..()

/obj/structure/fake_machine/steward
	name = "MASTER OF NERVES"
	desc = ""
	icon = 'icons/roguetown/misc/machines.dmi'
	icon_state = "steward_machine"
	density = TRUE
	blade_dulling = DULLING_BASH
	anchored = TRUE
	layer = BELOW_OBJ_LAYER

	rattle_sound = 'sound/misc/machineno.ogg'
	unlock_sound = 'sound/misc/beep.ogg'
	lock_sound = 'sound/misc/beep.ogg'
	lock = /datum/lock/key/nerve

/obj/structure/fake_machine/steward/attackby(obj/item/I, mob/user, list/modifiers)
	if(istype(I, /obj/item/coin))
		record_round_statistic(STATS_MAMMONS_DEPOSITED, I.get_real_price())
		SStreasury.give_money_treasury(I.get_real_price(), "NERVE MASTER deposit")
		qdel(I)
		playsound(src, 'sound/misc/coininsert.ogg', 100, FALSE, -1)
		return
	return ..()

/obj/structure/fake_machine/steward/attack_hand(mob/living/user)
	. = ..()
	if(.)
		return
	if(locked())
		to_chat(user, "<span class='warning'>It's locked. Of course.</span>")
		return
	user.changeNext_move(CLICK_CD_MELEE)
	playsound(src, 'sound/misc/keyboard_enter.ogg', 100, FALSE, -1)
	ui_interact(user)

/obj/structure/fake_machine/steward/ui_state(mob/user)
	return GLOB.physical_state

/obj/structure/fake_machine/steward/ui_status(mob/user, datum/ui_state/state)
	if(locked())
		return UI_CLOSE
	if(!user.can_perform_action(src, NEED_DEXTERITY|FORBID_TELEKINESIS_REACH))
		return UI_CLOSE
	return ..()

/obj/structure/fake_machine/steward/ui_interact(mob/user, datum/tgui/ui)
	ui = SStgui.try_update_ui(user, src, ui)
	if(!ui)
		ui = new(user, src, "Steward")
		ui.open()

/obj/structure/fake_machine/steward/ui_data(mob/user)
	var/list/data = list()

	data["treasury"] = SStreasury.treasury_value
	data["lordTax"] = SStreasury.tax_value * 100
	data["queensTax"] = SStreasury.queens_tax * 100

	// Wages, grouped by category for the UI
	var/list/wages = list()
	for(var/datum/job/J in SSjob.joinable_occupations)
		var/list/entry = list()
		entry["title"] = J.title
		entry["category"] = get_job_category(J.title)
		entry["wage"] = SStreasury.job_wages[J.title] || 0
		wages += list(entry)
	data["wages"] = wages

	// Bank accounts
	var/list/accounts = list()
	for(var/mob/living/A in SStreasury.bank_accounts)
		var/list/entry = list()
		entry["ref"] = REF(A)
		entry["name"] = A.real_name
		entry["balance"] = SStreasury.bank_accounts[A]
		entry["title"] = ""
		if(ishuman(A))
			var/mob/living/carbon/human/H = A
			entry["title"] = H.get_role_title(steward_check = TRUE)
		accounts += list(entry)
	data["accounts"] = accounts

	// Regular stockpiles (excludes import/bounty/custom subtypes)
	var/list/stockpiles = list()
	for(var/datum/stock/stockpile/A in SStreasury.stockpile_datums)
		if(istype(A, /datum/stock/stockpile/custom))
			continue
		stockpiles += list(stock_to_list(A))
	data["stockpiles"] = stockpiles

	// Imports
	var/list/imports = list()
	for(var/datum/stock/import/A in SStreasury.stockpile_datums)
		imports += list(stock_to_list(A))
	data["imports"] = imports

	// Bounties
	var/list/bounties = list()
	for(var/datum/stock/bounty/A in SStreasury.stockpile_datums)
		bounties += list(stock_to_list(A))
	data["bounties"] = bounties

	// Custom stocks
	var/list/customs = list()
	for(var/datum/stock/stockpile/custom/A in SStreasury.stockpile_datums)
		var/list/entry = stock_to_list(A)
		entry["createdBy"] = A.created_by
		customs += list(entry)
	data["customStocks"] = customs

	// This user's inventory, for the "create custom stock" picker
	var/list/user_items = get_user_items(user)
	var/list/available_items = list()
	for(var/nm in user_items)
		available_items += list(list("name" = nm, "path" = user_items[nm]))
	data["availableItems"] = available_items

	// Jobs
	var/list/jobs = list()
	for(var/mob/living/carbon/human/A in SStreasury.bank_accounts)
		var/list/entry = list()
		entry["ref"] = REF(A)
		entry["name"] = A.real_name
		entry["title"] = A.get_role_title(steward_check = TRUE)
		entry["isLord"] = (A.job == /datum/job/lord::title)
		jobs += list(entry)
	data["jobs"] = jobs
	data["assignableJobs"] = get_assignable_jobs()
	data["payableJobs"] = get_payable_jobs()

	// Log
	var/list/log_entries = list()
	for(var/i = SStreasury.log_entries.len to 1 step -1)
		log_entries += SStreasury.log_entries[i]
	data["log"] = log_entries

	return data

/obj/structure/fake_machine/steward/proc/stock_to_list(datum/stock/stockpile/A)
	var/list/entry = list()
	entry["ref"] = REF(A)
	entry["name"] = A.name
	entry["desc"] = A.desc
	entry["held"] = A.get_held_count()
	entry["payoutPrice"] = A.payout_price
	entry["withdrawPrice"] = A.withdraw_price
	entry["withdrawDisabled"] = A.withdraw_disabled
	entry["percentBounty"] = A.percent_bounty
	entry["demand"] = A.demand2word()
	entry["oversupplyAmount"] = A.oversupply_amount
	entry["oversupplyPayout"] = A.oversupply_payout
	entry["importExportAmt"] = A.importexport_amt
	entry["stablePrice"] = A.stable_price
	if(A.importexport_amt)
		entry["importPrice"] = A.get_import_price()
		entry["exportPrice"] = A.get_export_price()
	return entry

/obj/structure/fake_machine/steward/proc/get_assignable_jobs()
	var/list/jobs = list()
	jobs += GLOB.noble_positions
	jobs += GLOB.garrison_positions
	jobs += GLOB.serf_positions
	jobs += GLOB.company_positions
	jobs += GLOB.peasant_positions
	jobs += GLOB.apprentices_positions
	jobs += GLOB.youngfolk_positions
	jobs += GLOB.allmig_positions
	jobs -= list(
		/datum/job/lord::title,
		/datum/job/innkeep_son::title,
		/datum/job/bandit::title,
	)
	return jobs

/obj/structure/fake_machine/steward/proc/get_payable_jobs()
	var/list/jobs = list()
	var/list/categories = list(
		GLOB.noble_positions,
		GLOB.garrison_positions,
		GLOB.church_positions,
		GLOB.serf_positions,
		GLOB.company_positions,
		GLOB.peasant_positions,
		GLOB.youngfolk_positions,
		GLOB.apprentices_positions,
		GLOB.inquisition_positions,
	)
	for(var/list/category in categories)
		for(var/j in category)
			jobs += j
	return jobs

/// Parses a numeric param, rejecting decimals. Returns null on anything invalid.
/obj/structure/fake_machine/steward/proc/parse_int_param(list/params, key)
	if(isnull(params[key]))
		return null
	var/value = text2num(params[key])
	if(!isnum(value))
		return null
	if(findtext(num2text(value), "."))
		return null
	return value

/obj/structure/fake_machine/steward/ui_act(action, list/params, datum/tgui/ui, datum/ui_state/state)
	. = ..()
	if(.)
		return

	switch(action)
		if("set_tax")
			var/newtax = parse_int_param(params, "value")
			if(isnull(newtax))
				return
			newtax = CLAMP(newtax, 1, 99)
			SStreasury.tax_value = newtax / 100
			SStreasury.untaxed_deposits = list()
			scom_announce("The new tax in [SSmapping.config?.map_name] shall be [newtax] percent.")
			. = TRUE

		if("set_wage")
			var/job_title = params["job"]
			if(!job_title)
				return
			var/amt = parse_int_param(params, "value")
			if(isnull(amt) || amt < 0)
				return
			SStreasury.set_job_wage(job_title, amt)
			. = TRUE

		if("import")
			var/datum/stock/D = locate(params["ref"]) in SStreasury.stockpile_datums
			if(!D)
				return
			if(SStreasury.treasury_value < D.get_import_price())
				say("Insufficient mammon.")
				return
			var/amt = D.get_import_price()
			SStreasury.treasury_value -= amt
			SStreasury.log_to_steward("-[amt] imported [D.name]")
			record_round_statistic(STATS_STOCKPILE_IMPORTS_VALUE, amt)
			if(amt >= 100)
				scom_announce("[SSmapping.config.map_name] imports [D.name] for [amt] mammon.")
			else
				say("[SSmapping.config.map_name] imports [D.name] for [amt] mammon.")
			D.raise_demand()
			addtimer(CALLBACK(src, PROC_REF(do_import), D.type), 10 SECONDS)
			. = TRUE

		if("export")
			var/datum/stock/stockpile/D = locate(params["ref"]) in SStreasury.stockpile_datums
			if(!D)
				return
			if(D.get_held_count() < D.importexport_amt)
				say("Insufficient stock.")
				return

			var/items_exported = 0
			for(var/i = 1 to D.importexport_amt)
				var/obj/item/exported_item = D.withdraw_item()
				if(!exported_item)
					break
				items_exported++
				qdel(exported_item)

			if(items_exported == 0)
				say("Could not retrieve items from stockpile for export.")
				return

			var/total_value = D.get_export_price() * (items_exported / D.importexport_amt)
			SStreasury.treasury_value += total_value
			SStreasury.log_to_steward("+[total_value] exported [items_exported] [D.name]")
			record_round_statistic(STATS_STOCKPILE_EXPORTS_VALUE, total_value)

			if(total_value >= 100)
				scom_announce("[SSmapping.config.map_name] exports [items_exported] [D.name] for [total_value] mammon.")
			else
				say("[SSmapping.config.map_name] exports [items_exported] [D.name] for [total_value] mammon.")

			D.lower_demand()
			. = TRUE

		if("toggle_withdraw")
			var/datum/stock/D = locate(params["ref"]) in SStreasury.stockpile_datums
			if(!D)
				return
			D.withdraw_disabled = !D.withdraw_disabled
			. = TRUE

		if("set_oversupply_amount")
			var/datum/stock/stockpile/D = locate(params["ref"]) in SStreasury.stockpile_datums
			if(!D || D.percent_bounty)
				return
			var/newamount = parse_int_param(params, "value")
			if(isnull(newamount))
				return
			D.oversupply_amount = max(newamount, 0)
			. = TRUE

		if("set_oversupply_payout")
			var/datum/stock/stockpile/D = locate(params["ref"]) in SStreasury.stockpile_datums
			if(!D || D.percent_bounty)
				return
			var/newamount = parse_int_param(params, "value")
			if(isnull(newamount))
				return
			D.oversupply_payout = CLAMP(newamount, 0, 999)
			. = TRUE

		if("set_bounty")
			var/datum/stock/D = locate(params["ref"]) in SStreasury.stockpile_datums
			if(!D)
				return
			var/newtax = parse_int_param(params, "value")
			if(isnull(newtax))
				return
			if(!D.percent_bounty)
				newtax = CLAMP(newtax, 0, 999)
				scom_announce("The bounty for [D.name] has been set to [newtax].")
				D.payout_price = newtax
			else
				newtax = CLAMP(newtax, 1, 99)
				if(newtax > D.payout_price)
					scom_announce("The bounty for [D.name] was increased.")
				D.payout_price = newtax
			. = TRUE

		if("set_withdraw_price")
			var/datum/stock/D = locate(params["ref"]) in SStreasury.stockpile_datums
			if(!D || D.percent_bounty)
				return
			var/newtax = parse_int_param(params, "value")
			if(isnull(newtax))
				return
			D.withdraw_price = CLAMP(newtax, 0, 999)
			. = TRUE

		if("give_money")
			var/mob/living/X = locate(params["ref"]) in SStreasury.bank_accounts
			if(!X)
				return
			var/amt = parse_int_param(params, "value")
			if(isnull(amt) || amt < 1)
				return
			record_round_statistic(STATS_DIRECT_TREASURY_TRANSFERS, amt)
			SStreasury.give_money_account(amt, X)
			. = TRUE

		if("fine_account")
			var/mob/living/X = locate(params["ref"]) in SStreasury.bank_accounts
			if(!X)
				return
			var/amt = parse_int_param(params, "value")
			if(isnull(amt) || amt < 1)
				return
			record_round_statistic(STATS_FINES_INCOME, amt)
			add_abstract_elastic_data(ELASCAT_ECONOMY, ELASDATA_FINE_INCOME, amt)
			SStreasury.give_money_account(-amt, X)
			. = TRUE

		if("change_job")
			var/mob/living/X = locate(params["ref"]) in SStreasury.bank_accounts
			if(!X)
				return
			if(X.job == /datum/job/lord::title)
				to_chat(usr, "<span class='warning'>The MASTER OF NERVES does not permit reassigning the current Monarch.</span>")
				return
			var/new_pos = params["job"]
			if(!(new_pos in get_assignable_jobs()))
				return
			X.job = new_pos
			X.mind?.set_assigned_role(new_pos)
			if(ishuman(X))
				var/mob/living/carbon/human/human = X
				if(!HAS_TRAIT(human, TRAIT_RECRUITED) && HAS_TRAIT(human, TRAIT_FOREIGNER))
					ADD_TRAIT(human, TRAIT_RECRUITED, TRAIT_GENERIC)
			if(X.mind?.assigned_role)
				new_pos = X.mind.assigned_role.get_informed_title(X)
				X.mind.assigned_role.assign_honorary_titles(X)
			. = TRUE
			if(!SScommunications.can_announce(usr))
				return
			scom_announce("[X.real_name] has been assigned the title of [new_pos].")

		if("payroll")
			var/job_to_pay = params["job"]
			if(!(job_to_pay in get_payable_jobs()))
				return
			var/amount_to_pay = parse_int_param(params, "amount")
			if(isnull(amount_to_pay) || amount_to_pay < 1)
				return
			var/datum/job/job_pay = SSjob.GetJob(job_to_pay)
			if(!job_pay)
				return
			for(var/mob/living/carbon/human/H in GLOB.human_list)
				var/datum/job/job_check = H.mind?.assigned_role?.parent_job ? H.mind.assigned_role.parent_job : H.mind?.assigned_role
				if(job_check && job_check.type == job_pay.type)
					record_round_statistic(STATS_WAGES_PAID, amount_to_pay)
					add_abstract_elastic_data(ELASCAT_ECONOMY, ELASDATA_WAGES_PAID, amount_to_pay)
					SStreasury.give_money_account(amount_to_pay, H)
			. = TRUE

		if("create_custom")
			var/item_path = text2path(params["path"])
			if(!item_path)
				return
			var/list/user_items = get_user_items(usr)
			var/found_name
			for(var/nm in user_items)
				if(user_items[nm] == item_path)
					found_name = nm
					break
			if(!found_name)
				say("No items found in your inventory to create stock for.")
				return
			for(var/datum/stock/existing in SStreasury.stockpile_datums)
				if(existing.item_type == item_path)
					say("Stock already exists for this item type.")
					return
			var/datum/stock/stockpile/custom/new_stock = new /datum/stock/stockpile/custom(item_path, usr.real_name)
			SStreasury.stockpile_datums += new_stock
			say("Custom stock created for [found_name].")
			scom_announce("New custom stock created for [found_name] by [usr.real_name].")
			. = TRUE

		if("delete_custom")
			var/datum/stock/stockpile/custom/D = locate(params["ref"]) in SStreasury.stockpile_datums
			if(!D || !istype(D, /datum/stock/stockpile/custom))
				return
			SStreasury.stockpile_datums -= D
			say("Custom stock for [D.name] has been deleted.")
			qdel(D)
			. = TRUE

/obj/structure/fake_machine/steward/proc/do_import(datum/stock/D, number)
	if(!D)
		return
	D = new D
	if(number > D.importexport_amt)
		return
	if(!number)
		number = 1
	var/area/A = GLOB.areas_by_type[/area/indoors/town/warehouse]
	if(!A)
		return
	var/obj/item/I = new D.item_type()
	var/list/turfs = list()
	for(var/turf/T in A.get_turfs_from_all_zlevels())
		turfs += T
	var/turf/T = pick(turfs)
	I.forceMove(T)
	playsound(T, 'sound/misc/hiss.ogg', 100, FALSE, -1)
	number += 1
	addtimer(CALLBACK(src, PROC_REF(do_import), D.type, number), 3 SECONDS)

/obj/structure/fake_machine/steward/proc/get_user_items(mob/user)
	var/list/available_items = list()
	var/list/seen_types = list()

	for(var/obj/item/I in user.contents)
		if(I.type in seen_types)
			continue
		seen_types += I.type
		available_items[I.name] = I.type

	if(user.get_active_held_item())
		var/obj/item/held = user.get_active_held_item()
		if(!(held.type in seen_types))
			available_items[held.name] = held.type

	if(user.get_inactive_held_item())
		var/obj/item/held = user.get_inactive_held_item()
		if(!(held.type in seen_types))
			available_items[held.name] = held.type

	return available_items
