
/datum/antagonist/prisoner
	name = JOB_PRISONER
	antagpanel_category = JOB_PRISONER
	roundend_category = "Prisoners"
	show_name_in_check_antagonists = TRUE
	increase_votepwr = FALSE
	isgoodguy = TRUE
	antag_flags = FLAG_FAKE_ANTAG

/datum/antagonist/prisoner/on_gain()
	if(!(locate(/datum/objective/escape) in objectives))
		var/datum/objective/escape/prisoner/escape_objective = new
		escape_objective.owner = owner
		objectives += escape_objective
		return
//	ADD_TRAIT(owner.current, TRAIT_ANTAG, TRAIT_GENERIC)
	return ..()

/datum/antagonist/prisoner/on_removal()
	return ..()


/datum/antagonist/prisoner/greet()
	owner.announce_objectives()
	..()

/datum/antagonist/prisoner/roundend_report()
	var/traitorwin = TRUE

	var/count = 0
	if(objectives.len)//If the traitor had no objectives, don't need to process this.
		for(var/datum/objective/objective in objectives)
			objective.update_explanation_text()
			if(!objective.check_completion())
				traitorwin = FALSE
			count++

	if(!count)
		count = 1

	if(traitorwin)
		owner.adjust_triumphs(count)
		to_chat(owner.current, "<span class='greentext'>I've ESCAPED THAT AWFUL CELL! THE WORLD IS MINE!</span>")
		if(owner.current)
			owner.current.playsound_local(get_turf(owner.current), 'sound/misc/triumph.ogg', 100, FALSE, pressure_affected = FALSE)
	else
		if(considered_alive(owner))
			to_chat(owner.current, "<span class='redtext'>I'LL NEVER ESCAPE!!</span>")
		else
			to_chat(owner.current, "<span class='redtext'>I've escaped... in DEATH!</span>")
		if(owner.current)
			owner.current.playsound_local(get_turf(owner.current), 'sound/misc/fail.ogg', 100, FALSE, pressure_affected = FALSE)

