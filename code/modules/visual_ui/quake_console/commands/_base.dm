GLOBAL_LIST_INIT(console_commands, init_possible_commands())

/proc/init_possible_commands()
	var/list/commands = list()
	for(var/datum/console_command/command as anything in subtypesof(/datum/console_command))
		commands |= new command
	return commands

/datum/console_command
	var/command_key
	var/required_args = 0
	var/notify_admins = TRUE

/datum/console_command/proc/get_secondary_args(mob/user)
	return list()

/datum/console_command/proc/get_tertiary_args(secondary_arg)
	return list()

/datum/console_command/proc/help_information(obj/abstract/visual_ui_element/scrollable/console_output/output)
	return

/datum/console_command/proc/can_execute(mob/anchor, list/arg_list, obj/abstract/visual_ui_element/scrollable/console_output/output, fake = FALSE)
	if(!anchor.client.holder)
		if(!fake)
			output.add_line("ERROR: Missing Permissions")
		return FALSE
	if(required_args && !fake)
		if(length(arg_list) < required_args)
			output.add_line("ERROR: Invalid Syntax Format requires [required_args] arguements [length(arg_list)] received.")
			return FALSE
	return TRUE

/datum/console_command/proc/execute(obj/abstract/visual_ui_element/scrollable/console_output/output, list/arg_list)
	return TRUE
