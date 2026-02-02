/obj/effect/landmark/ship_marker
	name = "ship area marker"
	desc = "Marks the bottom-left corner of a ship area. Click to dock/undock."
	icon = 'icons/effects/effects.dmi'
	icon_state = "x2"
	alpha = 128

	var/ship_size = 100
	var/datum/ship_data/registered_ship
	var/target_island_id = "" // Unique ID of island to dock to

/obj/effect/landmark/ship_marker/Initialize(mapload)
	. = ..()
	registered_ship = SSterrain_generation.register_ship(loc, ship_size)

/obj/effect/landmark/ship_marker/proc/mirage_link()
	var/mob/user = usr
	if(!registered_ship)
		return

	if(registered_ship.docked_island)
		SSterrain_generation.undock_ship(registered_ship)
	else
		var/datum/island_data/island

		if(target_island_id)
			island = SSterrain_generation.get_island_by_id(target_island_id)
		else
			var/list/available_islands = SSterrain_generation.get_all_islands()
			if(!available_islands.len)
				to_chat(user, span_warning("No islands available!"))
				return

			var/list/island_choices = list()
			for(var/datum/island_data/isl in available_islands)
				island_choices[isl.island_name] = isl

			var/choice = input(user, "Select island to dock to:", "Dock Ship") as null|anything in island_choices
			if(!choice)
				return

			island = island_choices[choice]

		if(!island)
			to_chat(user, span_warning("Island not found!"))
			return

		if(SSterrain_generation.dock_ship_to_island(registered_ship, island))
			to_chat(user, span_notice("Ship docked to [island.island_name]! You can now see the island."))
		else
			to_chat(user, span_warning("Failed to dock ship."))

/obj/effect/landmark/ship_marker/Destroy()
	if(registered_ship)
		SSterrain_generation.undock_ship(registered_ship)
	. = ..()
