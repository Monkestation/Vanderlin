/client/proc/toggle_specific_triumph_buy()
	set category = "GameMaster.Triumphs"
	set name = "Toggle a Specific Triumph Buy"
	if(!check_rights(R_ADMIN))
		return FALSE

	var/list/choices = list()
	for(var/datum/triumph_buy/TB as anything in SStriumphs.triumph_buy_datums)
		var/status = TB.disabled ? "Disabled" : "Enabled"
		choices["[TB.name] ([status])"] = TB

	if(!length(choices))
		to_chat(src, span_warning("No Triumph Buys found in SStriumphs!"))
		return

	var/choice = browser_input_list(src, "Select a Triumph Buy to toggle.", "Toggle Triumph Buy", choices)
	if(!choice)
		return

	var/datum/triumph_buy/TB = locate(choices[choice]) in SStriumphs.triumph_buy_datums
	if(!TB)
		return

	TB.disabled = !TB.disabled
	if(TB.disabled)
		SStriumphs.refund_from_admin_toggle(TB)

	log_admin("[key_name(src)] toggled Triumph Buy '[TB.name]' to [TB.disabled ? "Disabled" : "Enabled"].")
	message_admins("[key_name_admin(src)] toggled Triumph Buy '[TB.name]' to [TB.disabled ? "Disabled" : "Enabled"].")
	SSblackbox.record_feedback("tally", "admin_verb_triumph_buy_toggle_specific", 1, "[TB.name]")
