/datum/antagonist/skeleton/knight
	name = "Death Knight"
	increase_votepwr = FALSE
	roundend_category = "Vampires"
	antagpanel_category = "Vampire"

/datum/antagonist/skeleton/knight/on_gain()
	. = ..()
	owner.forget_and_be_forgotten()
	for(var/datum/mind/found_mind in get_minds("Vampire Spawn"))
		owner.share_identities(found_mind)
	for(var/datum/mind/found_mind in get_minds("Death Knight"))
		owner.share_identities(found_mind)

/datum/antagonist/skeleton/knight/greet()
	to_chat(owner.current, span_userdanger("I am returned to serve. I will obey, so that I may return to rest."))
	owner.announce_objectives()
	..()

/datum/antagonist/skeleton/knight/roundend_report()
	var/traitorwin = TRUE

	printplayer(owner)

	var/count = 0
	if(objectives.len)//If the traitor had no objectives, don't need to process this.
		for(var/datum/objective/objective in objectives)
			objective.update_explanation_text()
			if(objective.check_completion())
				to_chat(owner, "<B>Goal #[count]</B>: [objective.explanation_text] <span class='greentext'>TRIUMPH!</span>")
			else
				to_chat(owner, "<B>Goal #[count]</B>: [objective.explanation_text] <span class='redtext'>Failure.</span>")
				traitorwin = FALSE
			count += objective.triumph_count
	var/special_role_text = lowertext(name)
	if(traitorwin)
		if(count)
			if(owner)
				owner.adjust_triumphs(count)
		to_chat(world, span_greentext("The [special_role_text] has TRIUMPHED!"))
		if(owner?.current)
			owner.current.playsound_local(get_turf(owner.current), 'sound/misc/triumph.ogg', 100, FALSE, pressure_affected = FALSE)
	else
		to_chat(world, span_redtext("The [special_role_text] has FAILED!"))
		if(owner?.current)
			owner.current.playsound_local(get_turf(owner.current), 'sound/misc/fail.ogg', 100, FALSE, pressure_affected = FALSE)
