/datum/console_command/tester
	command_key = "test"
	notify_admins = FALSE
	var/static/list/testing_vars


/datum/console_command/tester/help_information(obj/abstract/visual_ui_element/scrollable/console_output/output)
	output.add_line("test {TEST} - Executes the specified test and its actions in game.")

/datum/console_command/tester/get_secondary_args(mob/user)
	if(!length(testing_vars))
		generate_testing_datums()
	return testing_vars

/datum/console_command/tester/get_tertiary_args(secondary_arg)
	. = ..()
	if(!length(testing_vars))
		generate_testing_datums()
	var/datum/test_situation/sitaution = testing_vars[secondary_arg]
	return sitaution.arguements()


/datum/console_command/tester/execute(obj/abstract/visual_ui_element/scrollable/console_output/output, list/arg_list)
	if(!length(testing_vars))
		generate_testing_datums()
	var/test = arg_list[1]
	arg_list -= test
	if(!(test in testing_vars))
		output.add_line("ERROR: Invalid test.")
		return
	var/datum/test_situation/sitaution = testing_vars[test]
	sitaution.execute_test(output, arg_list)


/datum/console_command/tester/proc/generate_testing_datums()
	testing_vars = list()
	for(var/datum/test_situation/test as anything  in subtypesof(/datum/test_situation))
		if(IS_ABSTRACT(test))
			continue
		var/datum/test_situation/testing = new test
		testing_vars[testing.start] = testing
