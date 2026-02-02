/datum/triumph_buy/communal/preround/orphanage_renovation
	name = "Orphanage Renovation"
	desc = "Contribute to renovate the local orphanage and give orphans a better start in life. Automatically refunds if it does not reach its goal before the round starts."
	triumph_buy_id = TRIUMPH_BUY_ORPHANAGE_RENOVATION
	maximum_pool = 40

/datum/triumph_buy/communal/preround/orphanage_renovation/on_activate()
	. = ..()
	SSmapping.add_world_trait(/datum/world_trait/orphanage_renovated, 0)

	bordered_message(world, list(
		span_reallybig("The Orphanage has been renovated! Eora smiles upon you all!"),
	))

	for(var/client/C in GLOB.clients)
		if(!C?.mob)
			continue
		C.mob.playsound_local(C.mob, 'sound/vo/female/gen/giggle (1).ogg', 100)
