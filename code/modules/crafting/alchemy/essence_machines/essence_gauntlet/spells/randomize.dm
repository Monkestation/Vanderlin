/datum/action/cooldown/spell/essence/randomize
	name = "Randomize"
	desc = "Causes minor random effects in the area."
	button_icon_state = "randomize"
	cast_range = 2
	point_cost = 3
	attunements = list(/datum/attunement/fire)

/datum/action/cooldown/spell/essence/randomize/cast(atom/cast_on)
	. = ..()
	var/turf/target_turf = get_turf(cast_on)
	if(!target_turf)
		return FALSE
	owner.visible_message(span_notice("[owner] causes unpredictable magical effects."))

	switch(rand(1, 4))
		if(1)
			for(var/mob/living/M in range(1, target_turf))
				M.adjust_stamina(rand(-10, 10))
		if(2)
			new /obj/effect/temp_visual/cult/sparks(target_turf)
		if(3)
			playsound(target_turf, pick('sound/magic/fireball.ogg'), 30, TRUE)
		if(4)
			target_turf.visible_message(span_notice("The air shimmers with chaotic energy."))
