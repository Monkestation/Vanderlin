
/*
* I think this is placed here because its
* used to tell people what their income is
* in a non fantasy tone. This is used here
* and in the drugmachine.dm.
*/
/proc/send_ooc_note(msg, name, job)
	var/list/names_to = list()
	if(name)
		names_to += name
	if(job)
		var/list/L = list()
		if(islist(job))
			L = job
		else
			L += job
		for(var/J in L)
			for(var/mob/living/carbon/human/X in GLOB.human_list)
				if(X.job == J)
					names_to |= X.real_name
	if(names_to.len)
		for(var/mob/living/carbon/human/X in GLOB.human_list)
			if(X.real_name in names_to)
				if(!X.stat)
					to_chat(X, "<span class='info'>[msg]</span>")

/*
* The Treasury system is the ocean
* in which the steward sails.
*/
SUBSYSTEM_DEF(treasury)
	name = "Treasury"
	wait = 1
	init_order = INIT_ORDER_TREASURY
	priority = FIRE_PRIORITY_WATER_LEVEL
	var/tax_value = 0.1
	var/queens_tax = 0.15
	var/treasury_value = 0
	var/list/bank_accounts = list()
	var/list/untaxed_deposits = list()
	var/list/noble_incomes = list()
	var/list/stockpile_datums = list()
	var/multiple_item_penalty = 0.7
	var/interest_rate = 0.15
	var/next_treasury_check = 0
	var/list/log_entries = list()
	var/list/vault_accounting = list() //used for the vault count, cleared every fire()

/datum/controller/subsystem/treasury/Initialize()
	//Randomizes the roundstart amount of money and the queens tax.
	treasury_value = rand(800,1200)
	force_set_round_statistic(STATS_STARTING_TREASURY, treasury_value)
	queens_tax = pick(0.09, 0.15, 0.21, 0.30)

	//For the merchants import and export.
	for(var/path in subtypesof(/datum/stock/bounty))
		var/datum/D = new path
		stockpile_datums += D
	for(var/path in subtypesof(/datum/stock/stockpile))
		var/datum/D = new path
		if(istype(D, /datum/stock/stockpile/custom))
			continue
		stockpile_datums += D
	for(var/path in subtypesof(/datum/stock/import))
		var/datum/D = new path
		stockpile_datums += D
	return ..()

/datum/controller/subsystem/treasury/fire(resumed = 0)
	if(world.time > next_treasury_check)
		//I dont know why the treasury check is randomized
		next_treasury_check = world.time + rand(8 MINUTES, 12 MINUTES)
		if(SSticker.current_state == GAME_STATE_PLAYING)
			//Stock price updated based on demand variable.
			for(var/datum/stock/X in stockpile_datums)
				if(!X.stable_price && !X.transport_item)
					if(X.demand < initial(X.demand))
						X.demand += rand(5,15)
					if(X.demand > initial(X.demand))
						X.demand -= rand(5,15)

		//Checks all items in the vault.
		var/amt_to_generate = CalcVaultIncome()

		/*
		* This is the final calculations of how
		* much passive income the kingdom makes.
		* exsample: 4 items worth 100 mammon
		* individually will produce (productprice*0.25)
		* before the total suffers from the queens tax
		* which ranges from 9% to 30%. Some rounds
		* will just be harder for the Steward than others.
		*/
		amt_to_generate = amt_to_generate - (amt_to_generate * queens_tax)
		amt_to_generate = round(amt_to_generate)
		give_money_treasury(amt_to_generate, "Wealth Horde")
		force_set_round_statistic(STATS_REGULAR_VAULT_INCOME, amt_to_generate)
		record_round_statistic(STATS_VAULT_TOTAL_REVENUE, amt_to_generate)
		for(var/mob/living/carbon/human/X in GLOB.human_list)
			if(!X.mind)
				continue
			if(is_lord_job(X.mind.assigned_role) || is_consort_job(X.mind.assigned_role) || is_steward_job(X.mind.assigned_role))
				send_ooc_note("Income from wealth horde: +[amt_to_generate]", name = X.real_name)
				return

/*
* Calculates Passive income based
* on the items that are placed within
* the vault. Resets vault tracking of duplicate items
*/
/datum/controller/subsystem/treasury/proc/CalcVaultIncome()
	vault_accounting = list()
	var/area/A = GLOB.areas_by_type[/area/rogue/indoors/town/vault]
	var/passive_income = 0
	for(var/obj/I in A)
		if(!isturf(I.loc))
			continue
		if(isitem(I))
			passive_income += add_to_vault(I)
		else if(istype(I, /obj/structure/closet))
			for(var/obj/item/item in I.contents)
				passive_income += add_to_vault(item)

	return passive_income

/datum/controller/subsystem/treasury/proc/add_to_vault(obj/item/item)
	var/list/objects_to_search = list(item)
	var/datum/component/storage/storage = item.GetComponent(/datum/component/storage)
	if(storage)
		objects_to_search |= storage.contents()
	var/total_value = 0
	for(var/atom/movable/movable_atom in objects_to_search)
		if(is_type_in_typecache(movable_atom, GLOB.ITEM_DOES_NOT_GENERATE_VAULT_RENT))
			continue
		if(movable_atom.get_real_price() <= 0)
			continue
		//Passive income is 15% of the items worth.
		var/item_value = movable_atom.get_real_price() * interest_rate
		vault_accounting[movable_atom.type] += 1
		if(vault_accounting[movable_atom.type] > 1)
			item_value *= (multiple_item_penalty ** (vault_accounting[movable_atom.type]-1))
		total_value += item_value
	return total_value

/*
* These procs are all called directly from
* things outside of the system.
*/
/datum/controller/subsystem/treasury/proc/create_bank_account(name, initial_deposit)
	if(!name)
		return
	if(name in bank_accounts)
		return
	bank_accounts += name
	if(initial_deposit)
		bank_accounts[name] = initial_deposit
	else
		bank_accounts[name] = 0
	return TRUE

//increments the treasury directly (tax collection)
/datum/controller/subsystem/treasury/proc/give_money_treasury(amt, source, silent = FALSE)
	if(!amt)
		return
	treasury_value += amt
	if(silent)
		return
	if(source)
		log_to_steward("+[amt] to treasury ([source])")
	else
		log_to_steward("+[amt] to treasury")

//pays to account (if it exists) from treasury (payroll). Not taxed
/datum/controller/subsystem/treasury/proc/give_money_account(amt, target, source)
	if(!amt)
		return
	if(!target)
		return
	amt = floor(amt)
	var/target_name = target
	if(istype(target,/mob/living/carbon/human))
		var/mob/living/carbon/human/H = target
		target_name = H.real_name
	var/found_account
	for(var/X in bank_accounts)
		if(X == target)
			if(amt > 0)
				bank_accounts[X] += amt  // Add funds into the player's account
			else
				// Check if the amount to be fined exceeds the player's account balance
				amt = min(max(amt, -1 * bank_accounts[X]), 0)  // amt should be a negative number
				bank_accounts[X] -= abs(amt)  // Deduct the fine amount from the player's account
			found_account = TRUE
			break
	if(!found_account)
		return FALSE

	if (amt > 0)
		// Player received money
		if(source)
			send_ooc_note("<b>MEISTER:</b> Your account has received [amt] mammon. ([source])", name = target_name)
			log_to_steward("+[amt] from treasury to [target_name] ([source])")
		else
			send_ooc_note("<b>MEISTER:</b> Your account has received [amt] mammon.", name = target_name)
			log_to_steward("+[amt] from treasury to [target_name]")
	else if (amt < 0)
		// Player was fined
		if(source)
			send_ooc_note("<b>MEISTER:</b> Your account was fined [abs(amt)] mammon. ([source])", name = target_name)
			log_to_steward("[abs(amt)] was fined from [target_name] ([source])")
		else
			send_ooc_note("<b>MEISTER:</b> Your account was fined [abs(amt)] mammon.", name = target_name)
			log_to_steward("[abs(amt)] was fined from [target_name]")

	return TRUE

///Deposits money into a character's bank account. Taxes are deducted from the deposit and added to the treasury.
///@param amt: The amount of money to deposit.
///@param character: The character making the deposit.
///@return a list(original deposit, taxed amount) if the money was successfully deposited, FALSE otherwise.
/datum/controller/subsystem/treasury/proc/generate_money_account(amt, mob/living/carbon/human/character)
	if(!amt)
		return FALSE
	if(!character)
		return FALSE

	var/taxed_amount = 0
	var/original_amt = amt
	treasury_value += amt

	if(character in bank_accounts)
		if(HAS_TRAIT(character, TRAIT_NOBLE))
			bank_accounts[character] += amt
		else
			if(!untaxed_deposits[character])
				untaxed_deposits[character] = 0

			var/previous_untaxed = untaxed_deposits[character]
			untaxed_deposits[character] += amt

			var/taxable_amount = untaxed_deposits[character]
			var/potential_tax = round(taxable_amount * tax_value)

			if(potential_tax >= 1)
				taxed_amount = potential_tax
				var/taxed_portion = round(taxed_amount / tax_value)
				var/net_from_this_deposit = (taxable_amount - taxed_amount) - previous_untaxed
				bank_accounts[character] += net_from_this_deposit
				untaxed_deposits[character] = taxable_amount - taxed_portion
			else
				bank_accounts[character] += amt
	else
		return FALSE

	log_to_steward("+[original_amt] deposited by [character.real_name] of which taxed [taxed_amount]")

	return list(original_amt, taxed_amount)

/datum/controller/subsystem/treasury/proc/withdraw_money_account(amt, target)
	if(!amt)
		return
	var/target_name = target
	if(istype(target_name,/mob/living/carbon/human))
		var/mob/living/carbon/human/H = target_name
		target_name = H.real_name
	var/found_account
	for(var/X in bank_accounts)
		if(X == target)
			if(bank_accounts[X] < amt)  // Check if the withdrawal amount exceeds the player's account balance
				send_ooc_note("<b>MEISTER:</b> Error: Insufficient funds in the account to complete the withdrawal.", name = target_name)
				return  // Return without processing the transaction
			if(treasury_value < amt)  // Check if the amount exceeds the treasury balance
				send_ooc_note("<b>MEISTER:</b> Error: Insufficient funds in the treasury to complete the transaction.", name = target_name)
				return  // Return early if the treasury balance is insufficient
			bank_accounts[X] -= amt
			treasury_value -= amt
			found_account = TRUE
			break
	if(!found_account)
		return
	log_to_steward("-[amt] withdrawn by [target_name]")
	return TRUE

/datum/controller/subsystem/treasury/proc/log_to_steward(log)
	log_entries += log
	return

/datum/controller/subsystem/treasury/proc/distribute_estate_incomes()
	for(var/mob/living/welfare_dependant in noble_incomes)
		var/how_much = noble_incomes[welfare_dependant]
		record_round_statistic(STATS_NOBLE_INCOME_TOTAL, how_much)
		give_money_treasury(how_much, silent = TRUE)
		give_money_account(how_much, welfare_dependant, "Vanderlin Noble Estate")
