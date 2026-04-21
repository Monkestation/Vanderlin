/datum/follower_command/custom
	command_name = "Custom Order"
	var/custom_text = ""

/datum/follower_command/custom/post_setup(mob/living/carbon/human/automaton, mob/living/issuer)
	custom_text = tgui_input_text(issuer, "Enter your command for [automaton]:", "Custom Command", max_length = 256)
	if(QDELETED(automaton) || QDELETED(issuer))
		return
	if(!custom_text)
		return
	if(!issuer.say(custom_text))
		return
	if(!(automaton in get_hearers_in_view(DEFAULT_MESSAGE_RANGE, issuer)))
		return
	command_name = custom_text
	return TRUE

/datum/follower_command/custom/execute(mob/living/carbon/human/automaton, mob/living/issuer)
	playsound(automaton, 'sound/vo/automaton/executingorders.ogg', 70)
	automaton.say("EXECUTING ORDERS", forced = TRUE)

/datum/follower_command/custom/terminate(mob/living/carbon/human/automaton)
	return
