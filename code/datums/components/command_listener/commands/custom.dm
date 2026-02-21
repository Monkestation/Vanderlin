/datum/follower_command/custom
	command_name = "Custom Order"
	var/custom_text = ""

/datum/follower_command/custom/post_setup(mob/living/carbon/human/automaton, mob/living/issuer)
	custom_text = browser_input_text(issuer, "Enter your command for [automaton]:", "Custom Command", max_length = 256)
	if(!custom_text)
		return FALSE
	command_name = custom_text
	return TRUE

/datum/follower_command/custom/execute(mob/living/carbon/human/automaton, mob/living/issuer)
	automaton.say("Executing Order: [custom_text]", forced = TRUE)

/datum/follower_command/custom/terminate(mob/living/carbon/human/automaton)
	return
