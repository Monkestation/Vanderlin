/datum/test_situation/debug_follower
	start = "debug_follower"

/datum/test_situation/debug_follower/execute_test(obj/abstract/visual_ui_element/scrollable/console_output/output, list/arg_list)
	var/mob/living/starter = output.get_user()
	if(!isliving(starter))
		output.add_line("ERROR: No host to bind to.")
		return

	var/datum/action/cooldown/spell/conjure_summon/familiar/spell = new
	spell.cast(starter)
	qdel(starter)
	var/mob/living/simple_animal/hostile/retaliate/wolf/familiar/pet = locate(/mob/living/simple_animal/hostile/retaliate/wolf/familiar) in get_turf(starter)
	if(!pet)
		output.add_line("ERROR: Failed to find pet.")
		return
	qdel(pet)

	output.add_line("SUCCESS")

	for(var/datum/console_command/listed_command in GLOB.console_commands)
		if(!istype(listed_command, /datum/console_command/debug_ai))
			continue
		listed_command.execute(output)
