#define TRIUMPH_KEY_SEASON "triumph_wipe_season"
#define TRIUMPH_KEY_AMOUNT "triumph_count"
#define TRIUMPH_KEY_SEASONAL_BUYS "seasonal_triumph_buys"

#define TRIUMPH_SEASON_NUM "current_season_name"
#define TRIUMPH_SEASON_NAME "current_wipe_season"

/*
	A fun fact is that it is important to note triumph procs all used key, whilas player quality likes to use ckey
	It doesn't help that the params to insert a json key in both are just key to go with byond clients having a ckey and key

	As to how it currently saves, loads, and decides what decides to get wiped. Here is the following information:

	When client joins -
		We get their triumphs from their saved file
		If the version number is below the current wipe season we put them back to 0
		It is then cached into a global list attached to their ckey

	Was running into issues saving this all at server reboot
	Thusly triumphs all jus save into individual files everytime its ran into
	triumph_adjust()

	Simple enough
*/

// To note any triumph files that try to be loaded in at a lower number than current wipe season get wiped.
// Also we have to handle this here cause the triumphs ss might get loaded too late to handle clients joining fast enough
GLOBAL_VAR_INIT(triumph_wipe_season, get_triumph_season())

/proc/get_triumph_season()
	var/json_file = file("data/triumph_wipe_season.json")

	var/current_wipe_season = 1

	if(!fexists(json_file))
		WRITE_FILE(json_file, json_encode(list(TRIUMPH_SEASON_NAME = current_wipe_season), JSON_PRETTY_PRINT))
		return current_wipe_season

	var/list/json = json_decode(file2text(json_file))
	return json[TRIUMPH_SEASON_NUM]

GLOBAL_VAR_INIT(triumph_wipe_name, get_triumph_season_name())

/proc/get_triumph_season_name()
	var/json_file = file("data/triumph_wipe_season.json")

	if(!fexists(json_file))
		return

	var/list/json = json_decode(file2text(json_file))
	return json[TRIUMPH_SEASON_NAME]

/// List of triumph buy id to typepath
GLOBAL_LIST_INIT(triumph_buys_by_id, init_triumph_buys_by_id())

/proc/init_triumph_buys_by_id()
	var/list/buys = list()
	for(var/datum/triumph_buy/buy as anything in subtypesof(/datum/triumph_buy))
		if(IS_ABSTRACT(buy))
			continue
		buys[buy::triumph_buy_id] = buy
	return buys

SUBSYSTEM_DEF(triumphs)
	name = "Triumphs"
	flags = SS_NO_FIRE
	init_order = INIT_ORDER_TRIUMPHS
	lazy_load = FALSE

	/// List of top ten for display in browser page on button click
	var/list/triumph_leaderboard = list()
	/// A cache for triumphs. Basically when client first hops in for the session we will cram their ckey in and retrieve from file
	/// When the server session is about to end we will write it all in.
	var/list/triumph_amount_cache = list()
	/// Similiar to the triumph amount cache, but stores triumph buys the ckey has bought
	var/list/triumph_buy_owners = list()
	/// Pending clients for seasonal triumph checks pre-init
	var/list/pending_clients_seasonal = list()
	/// Cache of ckeys that have already activated save file seasonal buys this round
	var/list/activated_seasonal_ckeys = list()

/*
	TRIUMPH BUY MENU THINGS
*/

	/// Whether triumph buys are enabled
	var/triumph_buys_enabled = TRUE
	/// Init list to hold triumph buy menus for the session (aka menu data) (Assc list "ckey" = datum)
	var/list/active_triumph_menus = list()
	/// Display limit per page in a non communal category on the user menu
	var/page_display_limit = 14
	/// Display limit per page in a communal category on the user menu
	var/communal_display_limit = 4
	// This represents the triumph buy organization on the main SS for triumphs, each key is a category name.
	// And then the list will have a number in a string that leads to a list of datums
	var/list/list/list/central_state_data = list( // this is updated to be a list of lists in subsystem Initialize
		TRIUMPH_CAT_CHARACTER = 0,
		TRIUMPH_CAT_CHALLENGES = 0,
		TRIUMPH_CAT_STORYTELLER = 0,
		TRIUMPH_CAT_MISC = 0,
		TRIUMPH_CAT_COMMUNAL = 0,
		TRIUMPH_CAT_SEASONAL = 0,
		TRIUMPH_CAT_ACTIVE_DATUMS = 0,
	)

/*
	TRIUMPH BUY DATUM THINGS
*/

	/// This is basically the total list of triumph buy datums on init
	var/list/triumph_buy_datums = list()
	// This is a list of all active datums
	var/list/active_triumph_buy_queue = list()
	/// This tracks the remaining stock for limited triumph buys
	var/list/triumph_buy_stocks = list()
	/// Tracks contributions to communal triumph buys - format: list(type = list(ckey = amount))
	var/list/communal_contributions = list()
	/// Tracks pool totals for communal buys - format: list(type = amount)
	var/list/communal_pools = list()

/datum/controller/subsystem/triumphs/Initialize()
	. = ..()

	prep_the_triumphs_leaderboard()

	for(var/client/client as anything in pending_clients_seasonal)
		if(QDELETED(client))
			continue
		activate_seasonal_buys(client)

	pending_clients_seasonal = null

	for(var/cur_path in subtypesof(/datum/triumph_buy))
		var/datum/triumph_buy/cur_datum = new cur_path
		if(isnull(cur_datum.triumph_buy_id))
			continue
		triumph_buy_datums += cur_datum
		central_state_data[cur_datum.category] += 1

	for(var/datum/triumph_buy/cur_datum in triumph_buy_datums)
		if(cur_datum.limited)
			triumph_buy_stocks[cur_datum.type] = cur_datum.stock

	// Figure out how many lists we are about to make to represent the pages
	for(var/catty_key in central_state_data)
		var/current_limit = (catty_key == TRIUMPH_CAT_COMMUNAL) ? communal_display_limit : page_display_limit
		var/page_count = ceil(central_state_data[catty_key]/current_limit)
		central_state_data[catty_key] = list()

		// Now fill in the lists starting at index "1"
		for(var/page_numba in 1 to page_count)
			central_state_data[catty_key]["[page_numba]"] = list()

			for(var/datum/triumph_buy/current_triumph_buy_datum as anything in triumph_buy_datums)
				if(current_triumph_buy_datum.category == catty_key)
					central_state_data[catty_key]["[page_numba]"] += current_triumph_buy_datum
				if(length(central_state_data[catty_key]["[page_numba]"]) == current_limit)
					break

/// WRITE_FILE wrapper to avoid mistakes with deleting old
/datum/controller/subsystem/triumphs/proc/write_save(file, list/data)
	if(fexists(file))
		fdel(file)

	WRITE_FILE(file, json_encode(data, JSON_PRETTY_PRINT))

/// This occurs when you try to buy a triumph condition and sets it up
/datum/controller/subsystem/triumphs/proc/attempt_to_buy_triumph_condition(client/C, datum/triumph_buy/ref_datum)
	if(ref_datum.disabled)
		to_chat(C, span_warning("This Triumph Buy has been disabled by administrators!"))
		return FALSE

	if(ref_datum.limited && triumph_buy_stocks[ref_datum.type] <= 0)
		to_chat(C, span_warning("The item is out of stock!"))
		return FALSE

	if(get_triumphs(C.ckey) < ref_datum.triumph_cost)
		to_chat(C, span_warning("You don't have enough triumphs to buy this item!"))
		return FALSE

	if(!ref_datum.allow_multiple_buys && C.has_triumph_buy(ref_datum.triumph_buy_id))
		to_chat(C, span_warning("You already have this item!"))
		return FALSE

	if(C.has_triumph_buy(ref_datum.triumph_buy_id, TRUE))
		to_chat(C, span_warning("You already have this item and it was not activated yet!"))
		return FALSE

	C.adjust_triumphs(ref_datum.triumph_cost * -1, counted = FALSE, silent = TRUE)

	if(ref_datum.limited)
		triumph_buy_stocks[ref_datum.type]--

	var/datum/triumph_buy/triumph_buy = new ref_datum.type

	triumph_buy.ckey_of_buyer = C.ckey

	if(!triumph_buy_owners[C.ckey])
		triumph_buy_owners[C.ckey] = list()

	triumph_buy_owners[C.ckey] += triumph_buy

	active_triumph_buy_queue += triumph_buy

	to_chat(C, span_notice("You have bought [triumph_buy.name] for [ref_datum.triumph_cost] triumph\s."))

	if(triumph_buy.conflicts_with.len)
		for(var/cur_check_path in triumph_buy.conflicts_with)
			for(var/datum/triumph_buy/active_datum in active_triumph_buy_queue)
				if(ispath(cur_check_path, active_datum.type))
					attempt_to_unbuy_triumph_condition(C, active_datum, reason = "CONFLICTS")

	triumph_buy.on_buy(C)
	call_menu_refresh()
	return TRUE

/// This occurs when you try to unbuy a triumph condition and removes it, also used for refunding due to conflicts
/datum/controller/subsystem/triumphs/proc/attempt_to_unbuy_triumph_condition(client/C, datum/triumph_buy/triumph_buy, reason = "\improper MANUAL REFUND", force = FALSE)
	var/previous_owner_ckey = triumph_buy.ckey_of_buyer
	if(previous_owner_ckey != C?.ckey)
		if(C)
			to_chat(C, span_warning("You can't refund someone else's triumph buy!"))
		return FALSE

	if(!force && !triumph_buy.can_be_refunded)
		if(C)
			to_chat(C, span_warning("You can't refund this triumph buy!"))
		return FALSE

	if(!force && triumph_buy.activated)
		if(C)
			to_chat(C, span_warning("You can't refund a triumph buy that was already activated!"))
		return FALSE

	var/refund_amount = triumph_buy.triumph_cost
	if(C?.ckey)
		C.adjust_triumphs(refund_amount, counted = FALSE, silent = TRUE, override_bonus = TRUE)
		to_chat(C, span_redtext("You were refunded [refund_amount] triumph\s due to \a [reason]."))
	else if(previous_owner_ckey)
		triumph_adjust(refund_amount, previous_owner_ckey)

	if(triumph_buy.limited)
		triumph_buy_stocks[triumph_buy.type]++

	if(triumph_buy_owners[triumph_buy.ckey_of_buyer])
		triumph_buy_owners[triumph_buy.ckey_of_buyer] -= triumph_buy

	triumph_buy.on_removal()
	active_triumph_buy_queue -= triumph_buy
	return TRUE

// Same deal as the role class stuff, we are only really just caching this to update displays as people buy stuff.
// So we have to be careful to not leave it in when unneeded otherwise we will have to keep track of which menus are actually open.
/datum/controller/subsystem/triumphs/proc/startup_triumphs_menu(client/C)
	if(!C || !triumph_buys_enabled)
		return
	var/datum/triumph_buy_menu/triumph_buy = active_triumph_menus[C.ckey]
	if(triumph_buy)
		triumph_buy.linked_client = C
		triumph_buy.triumph_menu_startup_slop()
		return
	var/datum/triumph_buy_menu/BIGBOY = new()
	BIGBOY.linked_client = C
	active_triumph_menus[C.ckey] = BIGBOY
	BIGBOY.triumph_menu_startup_slop()

/// This tells all alive triumph datums to re_update their visuals, shitty but ya
/datum/controller/subsystem/triumphs/proc/call_menu_refresh()
	for(var/MENS in active_triumph_menus)
		var/datum/triumph_buy_menu/triumph_buy = active_triumph_menus[MENS]
		if(!triumph_buy) // Insure we actually have something yes?
			active_triumph_menus.Remove(MENS)
			continue

		if(!triumph_buy.linked_client) // We have something and it has no client
			active_triumph_menus.Remove(MENS)
			qdel(triumph_buy)
			continue

		triumph_buy.show_menu()

/datum/controller/subsystem/triumphs/proc/refresh_communal_menus()
	for(var/ckey in active_triumph_menus)
		var/datum/triumph_buy_menu/menu = active_triumph_menus[ckey]
		if(menu && menu.current_category == TRIUMPH_CAT_COMMUNAL)
			menu.show_menu()

/// We cleanup the datum thats just holding the stuff for displaying the menu.
/datum/controller/subsystem/triumphs/proc/remove_triumph_buy_menu(client/C)
	if(C && active_triumph_menus[C.ckey])
		var/datum/triumph_buy_menu/triumph_buy = active_triumph_menus[C.ckey]
		C << browse(null, "window=triumph_buy_window")
		active_triumph_menus.Remove(C.ckey)
		qdel(triumph_buy)

/// Called from the place its slopped in in SSticker, this will occur right after the gamemode starts ideally, aka roundstart.
/datum/controller/subsystem/triumphs/proc/fire_on_PostSetup()
	call_menu_refresh()

/// We save everything when its time for reboot
/datum/controller/subsystem/triumphs/proc/end_triumph_saving_time()
	to_chat(world, "<span class='boldannounce'> Recording VICTORIES to the WORLD END MACHINE. </span>")

	var/leaderboard_file = file("data/triumph_leaderboards/triumphs_leaderboard_season_[GLOB.triumph_wipe_season].json")

	write_save(leaderboard_file, triumph_leaderboard)

/// Get triumph count from player save
/datum/controller/subsystem/triumphs/proc/get_triumphs(target_ckey)
	if(!target_ckey)
		return 0

	if(target_ckey in triumph_amount_cache)
		return floor(triumph_amount_cache[target_ckey])

	triumph_amount_cache[target_ckey] = 0

	var/target_file = file("data/player_saves/[target_ckey[1]]/[target_ckey]/triumphs.json")

	if(!fexists(target_file))
		reset_or_create_data(target_ckey)
		return 0

	var/list/existing_data = json_decode(file2text(target_file))
	if(GLOB.triumph_wipe_season != existing_data[TRIUMPH_KEY_SEASON])
		write_save(target_file, list(TRIUMPH_KEY_SEASON = GLOB.triumph_wipe_season))
		return 0

	triumph_amount_cache[target_ckey] = existing_data[TRIUMPH_KEY_AMOUNT]
	return floor(triumph_amount_cache[target_ckey])

/// Write triumphs to player save
/datum/controller/subsystem/triumphs/proc/write_player_triumphs(target_ckey, amount)
	if(!target_ckey)
		return

	var/target_file = file("data/player_saves/[target_ckey[1]]/[target_ckey]/triumphs.json")

	if(!fexists(target_file))
		reset_or_create_data(target_ckey)

	var/list/existing_data = json_decode(file2text(target_file))

	existing_data[TRIUMPH_KEY_AMOUNT] = amount

	write_save(target_file, existing_data)

/datum/controller/subsystem/triumphs/proc/triumph_adjust(amt, target_ckey)
	if(!target_ckey)
		return

	var/cur_client_triumph_count = get_triumphs(target_ckey)

	triumph_amount_cache[target_ckey] = cur_client_triumph_count + amt

	write_player_triumphs(target_ckey, triumph_amount_cache[target_ckey])

	log_game("TRIUMPHS: [target_ckey] received [amt] triumph\s. They have a total of [triumph_amount_cache[target_ckey]] triumph\s now. Checked with cache.")

/// Returns a list of triumph buy types
/datum/controller/subsystem/triumphs/proc/get_seasonal_triumph_buys(target_ckey)
	if(!target_ckey)
		return

	var/target_file = file("data/player_saves/[target_ckey[1]]/[target_ckey]/triumphs.json")

	if(!fexists(target_file))
		reset_or_create_data(target_ckey)
		return

	var/list/data = json_decode(file2text(target_file))

	var/list/buy_ids = data[TRIUMPH_KEY_SEASONAL_BUYS]

	if(!length(buy_ids))
		return

	var/list/returned_types = list()

	for(var/id in buy_ids)
		var/datum/triumph_buy/seasonal/triumph_type = GLOB.triumph_buys_by_id[id]

		if(!triumph_type || check_seasonal_expiry(triumph_type, buy_ids[id]))
			remove_seasonal_triumph_buy(target_ckey, id)
			continue

		returned_types += triumph_type

	return returned_types

/// Check timestamps to see if we expired
/datum/controller/subsystem/triumphs/proc/check_seasonal_expiry(datum/triumph_buy/seasonal/triumph_type, loaded_timestamp)
	var/current_timestamp = seasonal_time_stamp()
	var/current_time_num = text2num(splittext(current_timestamp, ":")[1])
	var/current_season = GLOB.triumph_wipe_season

	var/loaded_time_num = text2num(splittext(loaded_timestamp, ":")[1])
	var/loaded_season = text2num(splittext(loaded_timestamp, ":")[2])

	if((current_season - loaded_season) >= triumph_type::seasons_max)
		if(loaded_time_num >= current_time_num)
			return TRUE

	return FALSE

/// Timestamp of the date with no spacing
/// text2num will give a direct result in size comparison to check if its expired
/datum/controller/subsystem/triumphs/proc/seasonal_time_stamp(include_season = TRUE)
	return "[time2text(world.timeofday, "YYMMDD")]:[GLOB.triumph_wipe_season]"

/// Add a seasonal buy via id, it will be retrived and activated for this ckey on client init
/datum/controller/subsystem/triumphs/proc/add_seasonal_triumph_buy(target_ckey, triumph_buy_id)
	if(!target_ckey || !triumph_buy_id)
		return

	var/target_file = file("data/player_saves/[target_ckey[1]]/[target_ckey]/triumphs.json")

	if(!fexists(target_file))
		reset_or_create_data(target_ckey)

	var/list/data = json_decode(file2text(target_file))

	if(!LAZYACCESS(data, TRIUMPH_KEY_SEASONAL_BUYS))
		data[TRIUMPH_KEY_SEASONAL_BUYS] = list()

	data[TRIUMPH_KEY_SEASONAL_BUYS][triumph_buy_id] = seasonal_time_stamp()

	write_save(target_file, data)

/// Remove a seasonal buy via id
/datum/controller/subsystem/triumphs/proc/remove_seasonal_triumph_buy(target_ckey, triumph_buy_id)
	if(!target_ckey || !triumph_buy_id)
		return

	var/target_file = file("data/player_saves/[target_ckey[1]]/[target_ckey]/triumphs.json")

	if(!fexists(target_file))
		reset_or_create_data(target_ckey)
		return

	var/list/data = json_decode(file2text(target_file))
	if(!LAZYACCESS(data, TRIUMPH_KEY_SEASONAL_BUYS))
		return

	data[TRIUMPH_KEY_SEASONAL_BUYS] -= triumph_buy_id

	write_save(target_file, data)

/// Activate seasonal buys by reading the save file
/datum/controller/subsystem/triumphs/proc/activate_seasonal_buys(client/client)
	if(!client?.ckey)
		return

	var/ckey_index = client.ckey

	if(activated_seasonal_ckeys[ckey_index])
		return

	var/list/triumph_types = get_seasonal_triumph_buys(ckey_index)

	if(!length(triumph_types))
		return

	for(var/triumph_type in triumph_types)
		var/datum/triumph_buy/seasonal/new_buy = new triumph_type()

		new_buy.ckey_of_buyer = ckey_index

		// Do not activate or on_buy seasonal triumph buy after initial purchase

		new_buy.on_reloaded()

		LAZYADDASSOCLIST(triumph_buy_owners, ckey_index, new_buy)

		LAZYSET(activated_seasonal_ckeys, ckey_index, TRUE)

/// Wipe the triumphs of one person
/datum/controller/subsystem/triumphs/proc/wipe_target_triumphs(target_ckey)
	if(target_ckey in triumph_amount_cache)
		triumph_amount_cache[target_ckey] = 0

	write_player_triumphs(target_ckey, 0)

	log_game("TRIUMPHS: [target_ckey] was wiped of all triumphs!")

/// Wipe the entire list and adjust the season up by 1 too so anyone behind gets wiped if they rejoin later
/datum/controller/subsystem/triumphs/proc/start_new_season(new_season_name)
	GLOB.triumph_wipe_season += 1
	GLOB.triumph_wipe_name = new_season_name

	triumph_amount_cache = list()
	triumph_leaderboard = list()

	for(var/client/client as anything in GLOB.clients)
		var/client_key = client.ckey
		if(client_key)
			wipe_target_triumphs(client_key)

	var/list/data = list(
		TRIUMPH_SEASON_NUM = GLOB.triumph_wipe_season,
		TRIUMPH_SEASON_NAME = new_season_name,
	)

	write_save(file("data/triumph_wipe_season.json"), data)

/// Inititalise fields for a ckey or reset them to defaults
/datum/controller/subsystem/triumphs/proc/reset_or_create_data(target_ckey)
	if(!target_ckey)
		return

	triumph_amount_cache[target_ckey] = 0

	var/target_file = file("data/player_saves/[target_ckey[1]]/[target_ckey]/triumphs.json")

	var/list/data = list(
		TRIUMPH_KEY_SEASON = GLOB.triumph_wipe_season,
		TRIUMPH_KEY_AMOUNT = 0,
		TRIUMPH_KEY_SEASONAL_BUYS = list(),
	)

	write_save(target_file, data)

/datum/controller/subsystem/triumphs/proc/reset_triumphs(target_ckey)
	if(!target_ckey)
		return

	if(target_ckey in triumph_amount_cache)
		triumph_amount_cache[target_ckey] = 0

	var/target_file = file("data/player_saves/[target_ckey[1]]/[target_ckey]/triumphs.json")
	if(!fexists(target_file))
		reset_or_create_data(target_ckey)
		return

	var/list/data = json_decode(file2text(target_file))
	data[TRIUMPH_KEY_AMOUNT] = 0

	write_save(target_file, data)

/*
	TRIUMPH LEADERBOARD
*/

/// Displays leaderboard browser popup
/datum/controller/subsystem/triumphs/proc/show_triumph_leaderboard(client/C)
	var/season_name = GLOB.triumph_wipe_name ? GLOB.triumph_wipe_name : GLOB.triumph_wipe_season
	var/webpage = "<div style='text-align:center'>Current Season: [season_name]</div>"
	webpage += "<hr>"

	if(length(triumph_leaderboard))
		var/position_number = 0

		for(var/key in triumph_leaderboard)
			var/check_ckey = ckey(key)
			if(!isnull(GLOB.admin_datums[check_ckey]) || !isnull(GLOB.deadmins[check_ckey]) || !isnull(GLOB.protected_admins[check_ckey]) || check_ckey == "mechadaleearnhardt")
				continue

			position_number++
			webpage += "[position_number]. [key] - [FLOOR(triumph_leaderboard[key], 1)]<br>"
			if(position_number >= 20)
				break
	else
		webpage += "The hall of triumphs is empty"

	var/datum/browser/popup = new(C, "triumph_leaderboard", "CHAMPIONS OF PSYDONIA", 300, 570)
	popup.set_content(webpage)
	popup.open(FALSE)

/// Prepare the leaderboard by getting it and sorting it
/datum/controller/subsystem/triumphs/proc/prep_the_triumphs_leaderboard()
	var/json_file = file("data/triumph_leaderboards/triumphs_leaderboard_season_[GLOB.triumph_wipe_season].json")
	if(!fexists(json_file))
		return

	triumph_leaderboard = json_decode(file2text(json_file))

	sort_leaderboard()

/datum/controller/subsystem/triumphs/proc/adjust_leaderboard(user_key)
	var/triumph_total = triumph_amount_cache[ckey(user_key)]

	if(triumph_leaderboard[user_key] || triumph_leaderboard[ckey(user_key)])
		triumph_leaderboard.Remove(user_key)
		triumph_leaderboard.Remove(ckey(user_key))

	triumph_leaderboard[user_key] = triumph_total
	sort_leaderboard()

/// Sort the leaderboard so the highest are on top
/datum/controller/subsystem/triumphs/proc/sort_leaderboard()
	if(length(triumph_leaderboard) <= 1)
		return

	var/list/sorted_list = list()
	for(var/cache_key in triumph_leaderboard)
		for(var/sorted_key in sorted_list)
			var/their_triumphs = sorted_list[sorted_key]
			var/our_triumphs = triumph_leaderboard[cache_key]
			if(our_triumphs >= their_triumphs)
				sorted_list.Insert(sorted_list.Find(sorted_key), cache_key)
				sorted_list[cache_key] = triumph_leaderboard[cache_key]
				break

		if(!sorted_list.Find(cache_key))
			sorted_list[cache_key] = triumph_leaderboard[cache_key]

	triumph_leaderboard = sorted_list

/// Called when an admin disables a Triumph Buy. Refunds all current owners of that Triumph Buy and deactive it.
/datum/controller/subsystem/triumphs/proc/refund_from_admin_toggle(datum/triumph_buy/TB)
	if(!TB)
		return

	var/list/to_refund = list()
	// Collect all buys belonging to this Triumph type
	for(var/ckey in triumph_buy_owners)
		var/list/player_buys = triumph_buy_owners[ckey]
		if(!islist(player_buys))
			continue
		for(var/datum/triumph_buy/owned in player_buys)
			if(owned.type == TB.type)
				to_refund += owned

	// Process refunds
	for(var/datum/triumph_buy/owned in to_refund)
		var/client/C = GLOB.directory[owned.ckey_of_buyer] // check if player is online
		attempt_to_unbuy_triumph_condition(C, owned, "ADMIN DISABLE", TRUE)

#undef TRIUMPH_KEY_SEASON
#undef TRIUMPH_KEY_AMOUNT
#undef TRIUMPH_KEY_SEASONAL_BUYS
#undef TRIUMPH_SEASON_NUM
#undef TRIUMPH_SEASON_NAME
