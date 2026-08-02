/obj/effect/decal/cleanable/ritual_rune/arcyne/mana_siphon/cooking
	name = "arcyne cooking sigil"
	desc = "A refined firey rune, it aids in the cooking process..."
	color = "#ffd103"
	invocation = "El'keth un'varja!"
	user_facing = FALSE
	loop_speed = 1 SECONDS
	mana_cost = 0.2

/obj/effect/decal/cleanable/ritual_rune/arcyne/mana_siphon/cooking/trigger_effects()
	for(var/datum/container_craft_operation/craft in GLOB.active_container_crafts)
		var/turf/craft_turf = get_turf(craft.crafter)
		if(craft_turf.Distance3D(loc) > 5)
			continue
		craft.progress += SSprocessing.wait
