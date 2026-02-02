/datum/console_command/execute
	command_key = "execute"
	required_args = 2

/datum/console_command/execute/help_information(obj/abstract/visual_ui_element/scrollable/console_output/output)
	output.add_line("execute {SIGNAL} {PROC} - will trigger set proc when the signal is received on the mob")
	output.add_line("  variables can be set as named by going {VAR}={VALUE}")

/datum/console_command/execute/execute(obj/abstract/visual_ui_element/scrollable/console_output/output, list/arg_list)
	. = ..()
	var/signal = arg_list[1]
	arg_list -= signal
	var/mob/current = output.parent.get_user()
	var/datum/marked_datum = current.client.holder?.marked_datum
	if(!marked_datum)
		output.add_line("ERROR: No marked datum")
		return
	output.parent:setup_execute(signal, marked_datum, arg_list)
