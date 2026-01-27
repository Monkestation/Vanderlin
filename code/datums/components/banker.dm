#define BANKER_RADIAL_DEPOSIT "BANKER_RADIAL_DEPOSIT"
#define BANKER_RADIAL_WITHDRAW "BANKER_RADIAL_WITHDRAW"
#define BANKER_RADIAL_BALANCE "BANKER_RADIAL_BALANCE"
#define BANKER_RADIAL_STORAGE "BANKER_RADIAL_STORAGE"
#define BANKER_RADIAL_LOANS "BANKER_RADIAL_LOANS"
#define BANKER_RADIAL_UPGRADES "BANKER_RADIAL_UPGRADES"
#define BANKER_RADIAL_TALK "BANKER_RADIAL_TALK"
#define BANKER_RADIAL_YES "BANKER_RADIAL_YES"
#define BANKER_RADIAL_NO "BANKER_RADIAL_NO"

#define BANKER_OPTION_DEPOSIT "Deposit"
#define BANKER_OPTION_WITHDRAW "Withdraw"
#define BANKER_OPTION_BALANCE "Balance"
#define BANKER_OPTION_STORAGE "Storage"
#define BANKER_OPTION_LOANS "Loans"
#define BANKER_OPTION_UPGRADES "Upgrades"
#define BANKER_OPTION_TALK "Talk"
#define BANKER_OPTION_YES "Yes"
#define BANKER_OPTION_NO "No"

/**
 * # Banker NPC Component
 * Manages persistent coin storage, per-player round storage, loans, and character upgrades
 * Integrates with the save manager system for persistent data storage
 */
/datum/component/banker
	///Contains images of all radial icons
	var/static/list/radial_icons_cache = list()

	///Contains information of the banker
	var/datum/banker_data/banker_data

	///Per-player storage containers for this round (ckey -> storage datum)
	var/list/player_storage_containers = list()

	///Available character upgrades
	var/list/available_upgrades = list()

	///Interest rate for loans (as a percentage, e.g. 10 = 10%)
	var/loan_interest_rate = 10

	///Maximum loan amount
	var/max_loan_amount = 100

/datum/component/banker/Initialize(banker_data_path = null, banker_data = null)
	. = ..()
	if(!isliving(parent))
		return COMPONENT_INCOMPATIBLE

	if(ispath(banker_data_path, /datum/banker_data))
		banker_data = new banker_data_path
	if(isnull(banker_data))
		CRASH("Initialised banker component with no banker data.")

	src.banker_data = banker_data

	radial_icons_cache = list(
		BANKER_RADIAL_DEPOSIT = image(icon = 'icons/hud/radial.dmi', icon_state = "radial_buy"),
		BANKER_RADIAL_WITHDRAW = image(icon = 'icons/hud/radial.dmi', icon_state = "radial_sell"),
		BANKER_RADIAL_BALANCE = image(icon = 'icons/hud/radial.dmi', icon_state = "radial_talk"),
		BANKER_RADIAL_STORAGE = image(icon = 'icons/hud/radial.dmi', icon_state = "radial_storage"),
		BANKER_RADIAL_LOANS = image(icon = 'icons/hud/radial.dmi', icon_state = "radial_lore"),
		BANKER_RADIAL_UPGRADES = image(icon = 'icons/hud/radial.dmi', icon_state = "radial_buying"),
		BANKER_RADIAL_TALK = image(icon = 'icons/hud/radial.dmi', icon_state = "radial_selling"),
		BANKER_RADIAL_YES = image(icon = 'icons/hud/radial.dmi', icon_state = "radial_yes"),
		BANKER_RADIAL_NO = image(icon = 'icons/hud/radial.dmi', icon_state = "radial_no"),
	)

	initialize_upgrades()

/datum/component/banker/RegisterWithParent()
	RegisterSignal(parent, COMSIG_ATOM_ATTACK_HAND, PROC_REF(on_attack_hand))
	RegisterSignal(parent, COMSIG_ATOM_CLICKEDON, PROC_REF(on_source_clicked))

/datum/component/banker/UnregisterFromParent()
	UnregisterSignal(parent, COMSIG_ATOM_ATTACK_HAND)
	// Clean up storage containers
	for(var/ckey in player_storage_containers)
		var/datum/storage/storage_dautm = player_storage_containers[ckey]
		if(storage_dautm)
			qdel(storage_dautm) // Delete the storage object
		player_storage_containers -= src

	player_storage_containers = null

/datum/component/banker/proc/on_source_clicked(atom/source, mob/living/carbon/customer)
	var/dist = get_dist(source, customer)
	if(dist != 2)
		return
	on_attack_hand(source, customer)

///If our banker is alive, and the customer left clicks them with an empty hand without combat mode
/datum/component/banker/proc/on_attack_hand(atom/source, mob/living/carbon/customer)
	SIGNAL_HANDLER
	if(!can_bank(customer) || customer.cmode)
		return

	var/list/bank_options = list()
	bank_options[BANKER_OPTION_DEPOSIT] = radial_icons_cache[BANKER_RADIAL_DEPOSIT]
	bank_options[BANKER_OPTION_WITHDRAW] = radial_icons_cache[BANKER_RADIAL_WITHDRAW]
	bank_options[BANKER_OPTION_BALANCE] = radial_icons_cache[BANKER_RADIAL_BALANCE]
	bank_options[BANKER_OPTION_STORAGE] = radial_icons_cache[BANKER_RADIAL_STORAGE]
	bank_options[BANKER_OPTION_LOANS] = radial_icons_cache[BANKER_RADIAL_LOANS]
	if(length(available_upgrades))
		bank_options[BANKER_OPTION_UPGRADES] = radial_icons_cache[BANKER_RADIAL_UPGRADES]
	if(length(banker_data.say_phrases))
		bank_options[BANKER_OPTION_TALK] = radial_icons_cache[BANKER_RADIAL_TALK]

	var/mob/living/banker = parent
	banker.face_atom(customer)

	INVOKE_ASYNC(src, PROC_REF(open_bank_options), customer, bank_options)

	return COMPONENT_CANCEL_ATTACK_CHAIN

/**
 * Generates a radial of the initial banking options
 * Called via asynch, due to the sleep caused by show_radial_menu
 */
/datum/component/banker/proc/open_bank_options(mob/living/carbon/customer, list/bank_options)
	if(!can_bank(customer))
		return
	var/bank_result = show_radial_menu(customer, parent, bank_options, custom_check = CALLBACK(src, PROC_REF(check_menu), customer), require_near = TRUE, radial_slice_icon = "radial_thaum")
	switch(bank_result)
		if(BANKER_OPTION_DEPOSIT)
			handle_deposit(customer)
		if(BANKER_OPTION_WITHDRAW)
			handle_withdraw(customer)
		if(BANKER_OPTION_BALANCE)
			show_balance(customer)
		if(BANKER_OPTION_STORAGE)
			handle_storage_access(customer)
		if(BANKER_OPTION_LOANS)
			handle_loans(customer)
		if(BANKER_OPTION_UPGRADES)
			handle_upgrades(customer)
		if(BANKER_OPTION_TALK)
			banker_talk(customer)

/**
 * Checks if the customer is ok to use the radial
 */
/datum/component/banker/proc/check_menu(mob/customer)
	if(!istype(customer))
		return FALSE
	if(IS_DEAD_OR_INCAP(customer) || (get_dist(parent, customer) > 2))
		return FALSE
	return TRUE

/**
 * Handle depositing coins into persistent storage only
 */
/datum/component/banker/proc/handle_deposit(mob/customer)
	if(!can_bank(customer))
		return

	var/mob/living/banker = parent

	var/coins_in_hand = get_mammons_in_atom(customer)
	if(coins_in_hand <= 0)
		banker.say("You don't have any coins to deposit.")
		return

	banker.say("You have [coins_in_hand] mammons in your possession. How much would you like to deposit to your persistent vault?")

	var/deposit_amount = input(customer, "Enter amount to deposit (1-[coins_in_hand]):", "Deposit Amount") as num|null
	if(!deposit_amount || deposit_amount <= 0 || !can_bank(customer))
		return

	if(deposit_amount > coins_in_hand)
		banker.say("You don't have that many coins!")
		return

	// Remove coins from customer
	var/actual_removed = remove_mammons_from_atom(customer, deposit_amount)
	if(actual_removed <= 0)
		banker.say("I couldn't process your deposit.")
		return

	deposit_to_persistent_vault(customer, actual_removed)
	banker.say("Deposited [actual_removed] mammons to your persistent vault.")

/**
 * Handle withdrawing coins from persistent storage only
 */
/datum/component/banker/proc/handle_withdraw(mob/customer)
	if(!can_bank(customer))
		return

	var/mob/living/banker = parent
	var/persistent_balance = get_persistent_balance(customer)

	if(persistent_balance <= 0)
		banker.say("You don't have any funds stored in your persistent vault.")
		return

	var/withdraw_amount = input(customer, "Enter amount to withdraw (1-[persistent_balance]):", "Withdrawal Amount") as num|null
	if(!withdraw_amount || withdraw_amount <= 0 || !can_bank(customer))
		return

	if(withdraw_amount > persistent_balance)
		banker.say("You don't have that much in your persistent vault!")
		return

	withdraw_from_persistent_vault(customer, withdraw_amount)
	add_mammons_to_atom(customer, withdraw_amount)
	banker.say("Withdrew [withdraw_amount] mammons from your persistent vault.")

/**
 * Handle access to player's storage container
 */
/datum/component/banker/proc/handle_storage_access(mob/customer)
	if(!can_bank(customer))
		return

	var/mob/living/banker = parent
	var/datum/storage/storage = get_or_create_player_storage(customer)

	if(!storage)
		banker.say("I'm having trouble accessing your storage right now.")
		return

	banker.say("Here's your personal storage for this round.")
	storage.open_storage(customer)

/**
 * Get or create a storage container for a specific player
 */
/datum/component/banker/proc/get_or_create_player_storage(mob/customer)
	var/player_ckey = customer.ckey
	if(!player_ckey)
		return null

	// Check if storage already exists
	if(player_storage_containers[player_ckey])
		var/datum/storage/existing_storage = player_storage_containers[player_ckey]
		if(QDELETED(existing_storage))
			return existing_storage

	// Create new storage container
	var/obj/item/storage/backpack/banking_storage/new_storage = new()
	new_storage.name = "[customer.real_name]'s Banking Storage"
	new_storage.desc = "A secure storage container managed by the bank for [customer.real_name]. Only accessible this round."

	// Set up the storage datum
	var/datum/storage/storage = new_storage.atom_storage
	if(!storage)
		// If no component exists, add one
		storage = new_storage.create_storage(type = /datum/storage/banking)

	player_storage_containers[player_ckey] = storage

	return storage

/**
 * Show current balances (only persistent now)
 */
/datum/component/banker/proc/show_balance(mob/customer)
	if(!can_bank(customer))
		return

	var/persistent_balance = get_persistent_balance(customer)
	var/loan_info = get_loan_info(customer)

	var/list/balance_info = list(
		span_green("=== ACCOUNT SUMMARY ==="),
		span_notice("Persistent Vault: [persistent_balance] mammons"),
		span_notice("Round Storage: Available via Storage option")
	)

	if(loan_info["has_loan"])
		balance_info += span_warning("Outstanding Loan: [loan_info["amount"]] mammons")
		balance_info += span_notice("Interest Rate: [loan_interest_rate]%")

	to_chat(customer, balance_info.Join("\n"))

/**
 * Handle loan system (unchanged)
 */
/datum/component/banker/proc/handle_loans(mob/customer)
	if(!can_bank(customer))
		return

	var/loan_info = get_loan_info(customer)

	var/list/loan_options = list()

	if(loan_info["has_loan"])
		loan_options["Repay Loan ([loan_info["amount"]] mammons)"] = "repay"
		loan_options["Loan Information"] = "info"
	else
		loan_options["Take Out Loan (Max: [max_loan_amount] mammons)"] = "borrow"

	loan_options["Cancel"] = "cancel"

	var/loan_choice = browser_input_list(customer, "Loan Services", "Banking", loan_options)
	if(!loan_choice || loan_choice == "Cancel" || !can_bank(customer))
		return

	switch(loan_options[loan_choice])
		if("borrow")
			handle_loan_request(customer)
		if("repay")
			handle_loan_repayment(customer)
		if("info")
			show_loan_info(customer)

/**
 * Handle character upgrade purchases (modified to use only persistent balance)
 */
/datum/component/banker/proc/handle_upgrades(mob/customer)
	if(!can_bank(customer))
		return

	var/mob/living/banker = parent

	if(!length(available_upgrades))
		banker.say("We don't currently offer any character upgrades.")
		return

	var/list/upgrade_options = list()
	for(var/upgrade_id in available_upgrades)
		var/list/upgrade_data = available_upgrades[upgrade_id]
		var/owned = has_upgrade(customer, upgrade_id)
		var/status = owned ? " (OWNED)" : " ([upgrade_data["cost"]] mammons)"
		upgrade_options["[upgrade_data["name"]][status]"] = upgrade_id

	upgrade_options["Cancel"] = "cancel"

	var/upgrade_choice = browser_input_list(customer, "Available Character Upgrades", "Upgrades", upgrade_options)
	if(!upgrade_choice || upgrade_options[upgrade_choice] == "cancel" || !can_bank(customer))
		return

	var/upgrade_id = upgrade_options[upgrade_choice]
	purchase_upgrade(customer, upgrade_id)

/**
 * Banker conversation
 */
/datum/component/banker/proc/banker_talk(mob/customer)
	if(!can_bank(customer))
		return

	var/mob/living/banker = parent
	if(length(banker_data.say_phrases))
		var/phrase = pick(banker_data.say_phrases)
		banker.say(phrase)

// Storage Management Functions (simplified to persistent only)

/datum/component/banker/proc/deposit_to_persistent_vault(mob/customer, amount)
	var/datum/save_manager/SM = get_save_manager(customer.ckey)
	if(SM)
		SM.increment_data("banking", "persistent_balance", amount, 0)

/datum/component/banker/proc/withdraw_from_persistent_vault(mob/customer, amount)
	var/datum/save_manager/SM = get_save_manager(customer.ckey)
	if(SM)
		var/current_balance = SM.get_data("banking", "persistent_balance", 0)
		SM.set_data("banking", "persistent_balance", max(0, current_balance - amount))

/datum/component/banker/proc/get_persistent_balance(mob/customer)
	var/datum/save_manager/SM = get_save_manager(customer.ckey)
	if(SM)
		return SM.get_data("banking", "persistent_balance", 0)
	return 0

/datum/component/banker/proc/get_loan_info(mob/customer)
	var/datum/save_manager/SM = get_save_manager(customer.ckey)
	if(!SM)
		return list("has_loan" = FALSE, "amount" = 0)

	var/loan_amount = SM.get_data("banking", "loan_amount", 0)
	return list("has_loan" = loan_amount > 0, "amount" = loan_amount)

/datum/component/banker/proc/handle_loan_request(mob/customer)
	var/mob/living/banker = parent

	var/loan_amount = input(customer, "Enter loan amount (1-[max_loan_amount]):", "Loan Request") as num|null
	if(!loan_amount || loan_amount <= 0 || !can_bank(customer))
		return

	banker.say("You're requesting a loan of [loan_amount] mammons at [loan_interest_rate]% interest. Do you accept these terms?")

	var/list/loan_confirm = list(
		BANKER_OPTION_YES = radial_icons_cache[BANKER_RADIAL_YES],
		BANKER_OPTION_NO = radial_icons_cache[BANKER_RADIAL_NO],
	)

	var/confirm = show_radial_menu(customer, parent, loan_confirm, custom_check = CALLBACK(src, PROC_REF(check_menu), customer), require_near = TRUE, radial_slice_icon = "radial_thaum")
	if(confirm != BANKER_OPTION_YES || !can_bank(customer))
		return

	// Grant loan
	var/datum/save_manager/SM = get_save_manager(customer.ckey)
	if(SM)
		var/loan_with_interest = loan_amount + (loan_amount * loan_interest_rate / 100)
		SM.set_data("banking", "loan_amount", loan_with_interest)
		add_mammons_to_atom(customer, loan_amount)
		banker.say("Loan approved! You now owe [loan_with_interest] mammons total.")

/datum/component/banker/proc/handle_loan_repayment(mob/customer)
	var/mob/living/banker = parent
	var/loan_info = get_loan_info(customer)

	if(!loan_info["has_loan"])
		banker.say("You don't have any outstanding loans.")
		return

	var/coins_available = get_mammons_in_atom(customer)
	var/loan_amount = loan_info["amount"]

	if(coins_available < loan_amount)
		banker.say("You need [loan_amount - coins_available] more mammons to fully repay your loan.")
		return

	banker.say("Repaying your loan of [loan_amount] mammons. Confirm?")

	var/list/repay_confirm = list(
		BANKER_OPTION_YES = radial_icons_cache[BANKER_RADIAL_YES],
		BANKER_OPTION_NO = radial_icons_cache[BANKER_RADIAL_NO],
	)

	var/confirm = show_radial_menu(customer, parent, repay_confirm, custom_check = CALLBACK(src, PROC_REF(check_menu), customer), require_near = TRUE, radial_slice_icon = "radial_thaum")
	if(confirm != BANKER_OPTION_YES || !can_bank(customer))
		return

	// Process repayment
	remove_mammons_from_atom(customer, loan_amount)
	var/datum/save_manager/SM = get_save_manager(customer.ckey)
	if(SM)
		SM.set_data("banking", "loan_amount", 0)

	banker.say("Loan fully repaid! Thank you for your business.")

/datum/component/banker/proc/show_loan_info(mob/customer)
	var/loan_info = get_loan_info(customer)
	if(loan_info["has_loan"])
		to_chat(customer, span_warning("Outstanding Loan: [loan_info["amount"]] mammons at [loan_interest_rate]% interest"))
	else
		to_chat(customer, span_notice("No outstanding loans. Maximum loan amount: [max_loan_amount] mammons"))

// Upgrade System Functions (modified to use only persistent balance)

/datum/component/banker/proc/initialize_upgrades()
	available_upgrades = list(
		"health_boost" = list(
			"name" = "Health Boost",
			"description" = "Permanently increases maximum health by 20",
			"cost" = 5000
		),
		"stamina_boost" = list(
			"name" = "Stamina Enhancement",
			"description" = "Permanently increases maximum stamina by 30",
			"cost" = 3000
		),
		"luck_boost" = list(
			"name" = "Lucky Charm",
			"description" = "Increases luck in various random events",
			"cost" = 7500
		),
		"inventory_expansion" = list(
			"name" = "Inventory Expansion",
			"description" = "Adds extra inventory slots",
			"cost" = 4000
		)
	)

/datum/component/banker/proc/has_upgrade(mob/customer, upgrade_id)
	var/datum/save_manager/SM = get_save_manager(customer.ckey)
	if(SM)
		var/upgrades_list = SM.get_data("upgrades", "purchased", list())
		return (upgrade_id in upgrades_list)
	return FALSE

/datum/component/banker/proc/purchase_upgrade(mob/customer, upgrade_id)
	if(!available_upgrades[upgrade_id])
		return FALSE

	var/mob/living/banker = parent
	var/list/upgrade_data = available_upgrades[upgrade_id]

	if(has_upgrade(customer, upgrade_id))
		banker.say("You already own this upgrade!")
		return FALSE

	var/persistent_balance = get_persistent_balance(customer)
	if(persistent_balance < upgrade_data["cost"])
		banker.say("You need [upgrade_data["cost"] - persistent_balance] more mammons in your persistent vault for this upgrade.")
		return FALSE

	banker.say("[upgrade_data["description"]] for [upgrade_data["cost"]] mammons. Purchase?")

	var/list/purchase_confirm = list(
		BANKER_OPTION_YES = radial_icons_cache[BANKER_RADIAL_YES],
		BANKER_OPTION_NO = radial_icons_cache[BANKER_RADIAL_NO],
	)

	var/confirm = show_radial_menu(customer, parent, purchase_confirm, custom_check = CALLBACK(src, PROC_REF(check_menu), customer), require_near = TRUE, radial_slice_icon = "radial_thaum")
	if(confirm != BANKER_OPTION_YES || !can_bank(customer))
		return FALSE

	// Deduct cost from persistent vault only
	withdraw_from_persistent_vault(customer, upgrade_data["cost"])

	// Grant upgrade
	var/datum/save_manager/SM = get_save_manager(customer.ckey)
	if(SM)
		SM.add_to_list("upgrades", "purchased", upgrade_id)
		apply_upgrade_effect(customer, upgrade_id)

	banker.say("Upgrade purchased and applied! Enjoy your [upgrade_data["name"]].")
	return TRUE

/datum/component/banker/proc/apply_upgrade_effect(mob/customer, upgrade_id)
	// This should be customized based on your game's stat system
	switch(upgrade_id)
		if("health_boost")
			// Add 20 max health - adjust based on your health system
			// customer.maxHealth += 20
			to_chat(customer, span_green("You feel healthier! Maximum health increased."))
		if("stamina_boost")
			// Add 30 max stamina - adjust based on your stamina system
			// customer.maxStamina += 30
			to_chat(customer, span_green("You feel more energetic! Maximum stamina increased."))
		if("luck_boost")
			// Set luck flag - implement luck system as needed
			to_chat(customer, span_green("You feel luckier! Fortune smiles upon you."))
		if("inventory_expansion")
			// Add inventory slots - adjust based on your inventory system
			to_chat(customer, span_green("Your pockets feel roomier! Inventory expanded."))

///Returns if the banker is conscious and its combat mode is disabled.
/datum/component/banker/proc/can_bank(mob/customer)
	if(QDELETED(parent))
		return FALSE

	var/mob/living/banker = parent
	if(banker.cmode)
		customer.balloon_alert(customer, "[banker] is in combat!")
		return FALSE

	if(IS_DEAD_OR_INCAP(banker))
		customer.balloon_alert(customer, "[banker] is in indisposed!")
		return FALSE

	return TRUE

// Storage item and component definitions
/obj/item/storage/backpack/banking_storage
	name = "banking storage"
	desc = "A secure storage container managed by the bank."
	w_class = WEIGHT_CLASS_BULKY
	storage_type = /datum/storage/banking

/datum/storage/banking
	screen_max_rows = 5
	screen_max_columns = 4
	allow_quick_gather = TRUE
	allow_quick_empty = TRUE
	collection_mode = COLLECT_EVERYTHING
	insert_preposition = "in"

// Banker data datum (updated phrases)
/datum/banker_data
	var/list/say_phrases = list(
		"Welcome to our banking services!",
		"Your coins are safe in our persistent vault.",
		"Need a loan? We offer competitive rates!",
		"Consider our character upgrade services.",
		"Don't forget about your personal storage locker!",
		"Banking hours are always open for you."
	)

#undef BANKER_RADIAL_DEPOSIT
#undef BANKER_RADIAL_WITHDRAW
#undef BANKER_RADIAL_BALANCE
#undef BANKER_RADIAL_STORAGE
#undef BANKER_RADIAL_LOANS
#undef BANKER_RADIAL_UPGRADES
#undef BANKER_RADIAL_TALK
#undef BANKER_RADIAL_YES
#undef BANKER_RADIAL_NO

#undef BANKER_OPTION_DEPOSIT
#undef BANKER_OPTION_WITHDRAW
#undef BANKER_OPTION_BALANCE
#undef BANKER_OPTION_STORAGE
#undef BANKER_OPTION_LOANS
#undef BANKER_OPTION_UPGRADES
#undef BANKER_OPTION_TALK
#undef BANKER_OPTION_YES
#undef BANKER_OPTION_NO
