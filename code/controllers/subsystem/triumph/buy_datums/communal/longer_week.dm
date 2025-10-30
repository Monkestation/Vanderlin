/datum/triumph_buy/communal/preround/longer_week
	name = "Longer Week"
	desc = "Contribute to extend the working week (round) by 2 whole daes (40 mins) at minimum! Automatically refunds if it does not reach its goal before the round starts."
	triumph_buy_id = TRIUMPH_BUY_LONGER_WEEK
	maximum_pool = 70

/datum/triumph_buy/communal/preround/longer_week/on_activate()
	. = ..()
	SSmapping.add_world_trait(/datum/world_trait/longer_week, 0)
	GLOB.round_timer += 40 MINUTES

	to_chat(world, "<br>")
	to_chat(world, span_reallybig("The working week has been extended! Rejoice!"))
	to_chat(world, "<br>")

	for(var/client/C in GLOB.clients)
		if(!C?.mob)
			continue
		C.mob.playsound_local(C.mob, 'sound/magic/timestop.ogg', 100)
