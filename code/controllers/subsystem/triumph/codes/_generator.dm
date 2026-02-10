#define CODE_STORAGE_PATH "data/generated_codes.json"
#define CODE_METADATA_PATH "data/code_metadata.json"

GLOBAL_LIST_INIT(stored_codes, list())
GLOBAL_LIST_INIT(code_metadata, list()) // Stores expiry times, use counts, and redeemer tracking
GLOBAL_LIST_INIT(redeemed_codes, list())


/client/proc/generate_codes()
	set category = "GameMaster.Codes"
	set name = "Generate Code"

	generate_redemption_code()

/client/proc/generate_bulk_codes()
	set category = "GameMaster.Codes"
	set name = "Generate Bulk Codes"

	generate_bulk_redemption_code()

/client/proc/generate_custom_code()
	set category = "GameMaster.Codes"
	set name = "Generate Custom Code"

	generate_custom_redemption_code()

/proc/generate_custom_redemption_code()
	if(!check_rights(R_FUN))
		return

	var/custom_code = input(usr, "Enter your custom code (e.g., 2025MONKE)", "Custom Code") as text|null
	if(!custom_code)
		return

	custom_code = uppertext(trim(custom_code))

	if(length(custom_code) < 3 || length(custom_code) > 50)
		to_chat(usr, span_warning("Code must be between 3 and 50 characters long."))
		return

	// Check if code already exists
	reload_global_stored_codes()
	if(GLOB.stored_codes["[custom_code]"])
		to_chat(usr, span_warning("This code already exists!"))
		return

	var/restrictions = browser_input_list(usr, "Add restrictions to this code?", "Code Restrictions", list("None", "Time Limited", "Use Limited", "Both"))

	var/expiry_time = null
	var/max_uses = null

	if(restrictions == "Time Limited" || restrictions == "Both")
		var/hours = input(usr, "How many hours should this code be valid for?", "Expiry Time") as num|null
		if(hours < 0)
			hours = 0
		if(hours)
			expiry_time = world.time + (hours * 36000)

	if(restrictions == "Use Limited" || restrictions == "Both")
		max_uses = input(usr, "Maximum number of redemptions allowed?", "Use Limit") as num|null

	var/amount = input(usr, "Please enter an amount of triumphs to give", "Triumph Amount") as num|null
	if(!amount)
		return

	// Save the custom code
	var/json_file = file(CODE_STORAGE_PATH)
	var/list/collated_data = list()

	if(fexists(json_file))
		var/list/old_data = json_decode(file2text(json_file))
		collated_data += old_data

	collated_data["[custom_code]"] = amount

	var/payload = json_encode(collated_data)
	fdel(json_file)
	WRITE_FILE(json_file, payload)

	save_code_metadata(custom_code, expiry_time, max_uses)
	reload_global_stored_codes()

	var/restrictions_text = get_restrictions_text(expiry_time, max_uses)
	log_game("[key_name(usr)] generated a custom redemption code '[custom_code]' worth [amount] triumphs[restrictions_text].")
	message_admins("[ADMIN_LOOKUP(usr)] generated a custom redemption code '[custom_code]' worth [amount] triumphs[restrictions_text].")
	to_chat(usr, span_big("Your custom code has been created: [custom_code]"))

/proc/generate_redemption_code()
	if(!check_rights(R_FUN))
		return

	var/restrictions = browser_input_list(usr, "Add restrictions to this code?", "Code Restrictions", list("None", "Time Limited", "Use Limited", "Both"))

	var/expiry_time = null
	var/max_uses = null

	if(restrictions == "Time Limited" || restrictions == "Both")
		var/hours = input(usr, "How many hours should this code be valid for?", "Expiry Time")  as num|null
		if(hours < 0)
			hours = 0
		if(hours)
			expiry_time = world.time + (hours * 36000)

	if(restrictions == "Use Limited" || restrictions == "Both")
		max_uses = input(usr, "Maximum number of redemptions allowed?", "Use Limit") as num|null

	generate_triumph_code_tgui(FALSE, expiry_time, max_uses)

/proc/generate_triumph_code_tgui(no_logs = FALSE, expiry_time = null, max_uses = null)
	if(!check_rights(R_FUN))
		return
	var/amount = input(usr, "Please enter an amount of triumphs to give", "Triumph Amount") as num|null
	if(!amount)
		return
	return generate_triumph_code(amount, no_logs, expiry_time, max_uses)

/proc/save_code_metadata(code, expiry_time = null, max_uses = null)
	if(!expiry_time && !max_uses)
		return

	var/json_file = file(CODE_METADATA_PATH)
	var/list/collated_data = list()

	if(fexists(json_file))
		var/list/old_data = json_decode(file2text(json_file))
		collated_data += old_data

	var/list/metadata = list()
	if(expiry_time)
		metadata["expiry"] = expiry_time
	if(max_uses)
		metadata["max_uses"] = max_uses
		metadata["current_uses"] = 0

	metadata["redeemed_by"] = list()

	collated_data["[code]"] = metadata

	var/payload = json_encode(collated_data)
	fdel(json_file)
	WRITE_FILE(json_file, payload)
	reload_code_metadata()

/proc/reload_code_metadata()
	GLOB.code_metadata = list()
	var/json_file = file(CODE_METADATA_PATH)

	if(!fexists(json_file))
		return
	GLOB.code_metadata = json_decode(file2text(json_file))

/proc/generate_triumph_code(amount, no_logs = FALSE, expiry_time = null, max_uses = null)
	if(!amount)
		return
	var/string = generate_code_string()

	var/json_file = file(CODE_STORAGE_PATH)

	var/list/collated_data = list()
	if(fexists(json_file))
		var/list/old_data = json_decode(file2text(json_file))
		collated_data += old_data

	collated_data["[string]"] = amount

	var/payload = json_encode(collated_data)
	fdel(json_file)
	WRITE_FILE(json_file, payload)

	save_code_metadata(string, expiry_time, max_uses)
	reload_global_stored_codes()

	if(!no_logs)
		var/restrictions_text = get_restrictions_text(expiry_time, max_uses)
		log_game("[key_name(usr)] generated a new redemption code worth [amount] triumphs[restrictions_text].")
		message_admins("[ADMIN_LOOKUP(usr)] generated a new redemption code worth [amount] triumphs[restrictions_text].")
		to_chat(usr, span_big("Your generated code is: [string]"))
	return string

/proc/get_restrictions_text(expiry_time, max_uses)
	var/text = ""
	if(expiry_time)
		var/hours_remaining = round((expiry_time - world.time) / 36000, 0.1)
		text += " (expires in [hours_remaining] hours)"
	if(max_uses)
		text += " (max [max_uses] uses)"
	return text

/proc/generate_code_string()
	var/list/sections = list()
	for(var/num in 1 to 5)
		sections += random_string(5, GLOB.hex_characters)

	var/string = sections.Join("-")
	return string

/proc/reload_global_stored_codes()
	GLOB.stored_codes = list()
	var/json_file = file(CODE_STORAGE_PATH)

	if(!fexists(json_file))
		return
	GLOB.stored_codes = json_decode(file2text(json_file))

	reload_code_metadata()

/proc/generate_bulk_redemption_code()
	if(!check_rights(R_FUN))
		return

	var/amount = input(usr, "Choose number of codes to generate", "Number") as num|null
	if(!amount || amount < 0)
		return

	var/restrictions = browser_input_list(usr, "Add restrictions to these codes?", "Code Restrictions", list("None", "Time Limited", "Use Limited", "Both"))

	var/expiry_time = null
	var/max_uses = null

	if(restrictions == "Time Limited" || restrictions == "Both")
		var/hours = input(usr, "How many hours should these codes be valid for?", "Expiry Time")
		if(hours < 0)
			hours = 0
		if(hours)
			expiry_time = world.time + (hours * 36000)

	if(restrictions == "Use Limited" || restrictions == "Both")
		max_uses = input(usr, "Maximum number of redemptions per code?", "Use Limit") as num|null
		if(max_uses <= 0)
			max_uses = 1

	reload_global_stored_codes()
	var/list/generated_codes = list()
	for(var/num in 1 to amount)
		generated_codes += generate_triumph_code_tgui(TRUE, expiry_time, max_uses)

	var/restrictions_text = get_restrictions_text(expiry_time, max_uses)
	log_game("[key_name(usr)] generated [amount] new triumph redemption codes[restrictions_text].")
	message_admins("[ADMIN_LOOKUP(usr)] generated [amount] new triumph redemption codes[restrictions_text].")
	var/connected_keys = generated_codes.Join(" ,")
	to_chat(usr, span_big("Your generated codes are: [connected_keys]"))
