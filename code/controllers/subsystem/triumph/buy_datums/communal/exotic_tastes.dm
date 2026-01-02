/datum/triumph_buy/communal/preround/exotic_tastes
	name = "Exotic Tastes"
	desc = "Contribute to randomize everyone's culinary desires for this round. Automatically refunds if it does not reach its goal before the round starts."
	triumph_buy_id = TRIUMPH_BUY_EXOTIC_TASTES
	maximum_pool = 50

/datum/triumph_buy/communal/preround/exotic_tastes/on_activate()
	. = ..()
	SSmapping.add_world_trait(/datum/world_trait/exotic_tastes, 0)

	bordered_message(world, list(
		span_reallybig("Baotha has blessed everyone with exotic tastes! Everyone's culinary desires will be randomized!"),
	))

	for(var/client/C in GLOB.clients)
		if(!C?.mob)
			continue
		C.mob.playsound_local(C.mob, 'sound/misc/gods/baotha_omen.ogg', 100)
