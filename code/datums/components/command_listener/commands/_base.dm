/datum/follower_command
	var/command_name = "Unknown Command"
	var/issuer_name = "Unknown"
	var/issuer_job = null
	var/datum/component/command_follower/component

/datum/follower_command/proc/execute(mob/living/carbon/human/automaton, mob/living/issuer)
	return

/datum/follower_command/proc/terminate(mob/living/carbon/human/automaton)
	return

/datum/follower_command/proc/post_setup(mob/living/carbon/human/automaton, mob/living/issuer)
	return TRUE

/datum/follower_command/proc/on_client_login(mob/living/carbon/human/automaton)
	return
