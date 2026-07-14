/datum/console_command/time
	command_key = "time"
	required_args = 2


/datum/console_command/time/get_secondary_args()
	return list("set", "add", "remove")

/datum/console_command/time/get_tertiary_args(secondary_arg)
	if(secondary_arg == "set")
		return list("day", "night", "dawn", "dusk")
	return list()

/datum/console_command/time/help_information(obj/abstract/visual_ui_element/scrollable/console_output/output)
	output.add_line("time {set|add|remove} {amount} - will modify the time of day in deciseconds")
	output.add_line(" accepts: dawn, dusk, night, day")


/datum/console_command/time/execute(obj/abstract/visual_ui_element/scrollable/console_output/output, list/arg_list)
	var/time_change = arg_list[1]
	var/time_type = arg_list[2]

	// Handle special time keywords
	var/time_value = 0
	if(time_change == "set" && !text2num(time_type))
		switch(LOWER_TEXT(time_type))
			if("dawn")
				time_value = SSnightshift.nightshift_dawn_start
			if("dusk")
				time_value = SSnightshift.nightshift_dusk_start
			if("night")
				time_value = SSnightshift.nightshift_start_time
			if("day")
				time_value = SSnightshift.nightshift_day_start
			else
				output.add_line("ERROR: Invalid time type. Use: dawn, dusk, night, day or a number.")
				return
	else
		time_value = text2num(time_type)
		if(isnull(time_value))
			output.add_line("ERROR: Bad Syntax, [time_change] with [time_type], requires number or valid time keyword.")
			return

	// Apply the time change
	switch(time_change)
		if("set")
			SSticker.gametime_offset = time_value - ((world.time - SSticker.round_start_time) * SSticker.station_time_rate_multiplier)
			output.add_line("Time set to [time_value/36000] hours ([time_value] deciseconds)")

		if("remove")
			SSticker.gametime_offset -= time_value
			output.add_line("Removed [time_value/36000] hours ([time_value] deciseconds) from [SSmapping.config.map_name]'s time")

		if("add")
			SSticker.gametime_offset += time_value
			output.add_line("Added [time_value/36000] hours ([time_value] deciseconds) to [SSmapping.config.map_name]'s time")

		else
			output.add_line("ERROR: Invalid operation. Use: set, add, or remove")
			return

	// Get the new time for feedback
	var/new_time = station_time()
	var/hours = round(new_time / 36000)
	var/minutes = round((new_time % 36000) / 600)
	output.add_line("[SSmapping.config.map_name]'s time is now [hours]:[minutes < 10 ? "0[minutes]" : minutes]")
