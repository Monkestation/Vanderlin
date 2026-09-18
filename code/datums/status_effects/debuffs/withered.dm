/datum/status_effect/debuff/witherd
	id = "withered"
	alert_type = /atom/movable/screen/alert/status_effect/buff/witherd
	duration = 30 SECONDS
	effectedstats = list(STAT_SPEED = -2, STAT_STRENGTH = -2, STAT_CONSTITUTION = -2, STAT_ENDURANCE = -2)

/atom/movable/screen/alert/status_effect/buff/witherd
	name = "Withering"
	desc = "I can feel my physical prowess waning."
	icon_state = "debuff"
	color = "#b884f8" //talk about a coder sprite x2

/datum/status_effect/debuff/witherd/on_apply()
	. = ..()
	to_chat(owner, span_warning("I feel sapped of vitality!"))
	var/mob/living/target = owner
	var/newcolor = rgb(207, 135, 255)
	target.add_atom_colour(newcolor, TEMPORARY_COLOUR_PRIORITY)
	addtimer(CALLBACK(target, TYPE_PROC_REF(/atom, remove_atom_colour), TEMPORARY_COLOUR_PRIORITY, newcolor), 30 SECONDS)

/datum/status_effect/debuff/witherd/on_remove()
	. = ..()
	to_chat(owner, span_warning("I feel my physical prowess returning."))
