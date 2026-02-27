

/client/verb/redeem_code()
	set name = "Redeem Code"
	set category = "OOC.Links"
	set desc = "Redeem a code given to you."
	var/code = browser_input_text(usr, "Please enter the code", "Code Redemption")
	if(!code)
		return
	attempt_redeem(code)

/proc/attempt_redeem(code)
	reload_global_stored_codes()

	if(!(code in GLOB.stored_codes))
		browser_alert(usr, "Sorry, this code does not exist or has expired.", "Code Redemption", list("Close"))
		message_admins("[usr.ckey] has attempted to redeem an invalid code.")
		return

	var/user_ckey = usr.ckey

	// Check if code has metadata (time/use restrictions)
	if(code in GLOB.code_metadata)
		var/list/metadata = GLOB.code_metadata[code]

		// Check if user has already redeemed this code
		var/list/redeemed_by = metadata["redeemed_by"]
		if(user_ckey in redeemed_by)
			browser_alert(usr, "You have already redeemed this code.", "Code Redemption", list("Close"))
			return

		// Check expiry
		if(metadata["expiry"] && world.time > metadata["expiry"])
			browser_alert(usr, "Sorry, this code has expired.", "Code Redemption", list("Close"))
			remove_code(code) // Clean up expired code
			return

		// Check use limit
		if(metadata["max_uses"])
			var/current_uses = metadata["current_uses"] || 0
			if(current_uses >= metadata["max_uses"])
				browser_alert(usr, "Sorry, this code has reached its maximum number of redemptions.", "Code Redemption", list("Close"))
				remove_code(code) // Clean up exhausted code
				return

			// Increment use count and add user to redeemed list
			increment_code_usage(code, user_ckey)
		else
			// Time limited only - just track the user
			add_user_to_redeemed_list(code, user_ckey)
	else
		// Old style code - single use only
		if(code in GLOB.redeemed_codes)
			browser_alert(usr, "Sorry the code you've tried to redeem has already been redeemed", "Code Redemption", list("Close"))
			return

	var/triumph_amount = GLOB.stored_codes[code]

	// Award triumphs
	if(isnum(triumph_amount))
		adjust_triumphs(usr.ckey, triumph_amount, TRUE, "Redeemed a Giveaway Code", FALSE, TRUE)
		to_chat(usr, span_boldnotice("You have successfully redeemed a giveaway code for [triumph_amount] triumph\s."))
	else
		browser_alert(usr, "Error: Invalid code data. Please contact an administrator.", "Code Redemption", list("Close"))
		message_admins("ERROR: Code [code] has invalid data: [triumph_amount]")
		return

	message_admins("[usr] has just redeemed the code: [code], for [triumph_amount] triumphs")

	// Only remove code if it's not multi-use or if it's exhausted
	if(!(code in GLOB.code_metadata))
		remove_code(code) // Old style single-use code
	else
		var/list/metadata = GLOB.code_metadata[code]
		if(metadata["max_uses"])
			var/current_uses = metadata["current_uses"] || 0
			if(current_uses >= metadata["max_uses"])
				remove_code(code) // Code exhausted

/proc/add_user_to_redeemed_list(code, user_ckey)
	var/json_file = file(CODE_METADATA_PATH)
	var/list/collated_data = list()

	if(fexists(json_file))
		var/list/old_data = json_decode(file2text(json_file))
		collated_data += old_data

	if(code in collated_data)
		var/list/metadata = collated_data[code]
		var/list/redeemed_by = metadata["redeemed_by"] || list()
		redeemed_by += user_ckey
		metadata["redeemed_by"] = redeemed_by
		collated_data[code] = metadata

		var/payload = json_encode(collated_data)
		fdel(json_file)
		WRITE_FILE(json_file, payload)
		reload_code_metadata()

/proc/increment_code_usage(code, user_ckey)
	var/json_file = file(CODE_METADATA_PATH)
	var/list/collated_data = list()

	if(fexists(json_file))
		var/list/old_data = json_decode(file2text(json_file))
		collated_data += old_data

	if(code in collated_data)
		var/list/metadata = collated_data[code]
		metadata["current_uses"] = (metadata["current_uses"] || 0) + 1

		// Add user to redeemed list
		var/list/redeemed_by = metadata["redeemed_by"] || list()
		redeemed_by += user_ckey
		metadata["redeemed_by"] = redeemed_by

		collated_data[code] = metadata

		var/payload = json_encode(collated_data)
		fdel(json_file)
		WRITE_FILE(json_file, payload)
		reload_code_metadata()

/proc/remove_code(code)
	var/json_file = file(CODE_STORAGE_PATH)
	var/list/collated_data = list()
	if(fexists(json_file))
		var/list/old_data = json_decode(file2text(json_file))
		collated_data += old_data
	collated_data["[code]"] = null
	collated_data -= code
	GLOB.redeemed_codes += code
	var/payload = json_encode(collated_data)
	fdel(json_file)
	WRITE_FILE(json_file, payload)

	// Also remove metadata
	var/metadata_file = file(CODE_METADATA_PATH)
	var/list/metadata_data = list()
	if(fexists(metadata_file))
		var/list/old_metadata = json_decode(file2text(metadata_file))
		metadata_data += old_metadata
	metadata_data["[code]"] = null
	metadata_data -= code
	var/metadata_payload = json_encode(metadata_data)
	fdel(metadata_file)
	WRITE_FILE(metadata_file, metadata_payload)

	reload_global_stored_codes()
