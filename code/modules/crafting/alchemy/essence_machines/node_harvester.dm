/obj/machinery/essence/harvester
	name = "essence harvester"
	desc = "A mechanical solution to the problem of trying to harvest essence on a large scale. Allows you to leech alchemical essence where the land is weak."
	icon = 'icons/roguetown/misc/splitter.dmi'
	icon_state = "splitter"
	density = TRUE
	anchored = TRUE

	var/obj/structure/essence_node/installed_node
	var/harvest_rate = 2 // Essence per process cycle
	var/efficiency_bonus = 1.5 // Multiplier for installed node recharge

	var/datum/essence_storage/storage

/obj/machinery/essence/harvester/Initialize()
	. = ..()
	storage = new /datum/essence_storage(src)
	storage.max_total_capacity = 500
	storage.max_essence_types = 10
	START_PROCESSING(SSobj, src)

/obj/machinery/essence/harvester/Destroy()
	STOP_PROCESSING(SSobj, src)
	if(storage)
		qdel(storage)
	if(installed_node)
		installed_node.forceMove(get_turf(src))
	installed_node = null
	return ..()

/obj/machinery/essence/harvester/update_overlays()
	. = ..()
	if(installed_node)
		var/mutable_appearance/node = mutable_appearance(
			installed_node.icon,
			installed_node.icon_state,
			layer = src.layer + 0.1,
			color = installed_node.color,
		)
		node.pixel_y = 12
		. += node

		var/mutable_appearance/node_emissive = emissive_appearance(installed_node.icon, installed_node.icon_state, alpha = node.alpha)
		node_emissive.pixel_y = 12
		. += node_emissive

/obj/machinery/essence/harvester/return_storage()
	return storage

/obj/machinery/essence/harvester/process()
	if(!installed_node)
		return

	if(installed_node.current_essence < installed_node.max_essence && world.time >= installed_node.last_recharge + 1 MINUTES)
		var/boosted_recharge = round(installed_node.recharge_rate * efficiency_bonus)
		installed_node.current_essence = min(installed_node.max_essence, installed_node.current_essence + boosted_recharge)
		installed_node.last_recharge = world.time
		installed_node.update_appearance(UPDATE_ICON)

	if(installed_node.current_essence > 0)
		var/harvest_amount = min(installed_node.current_essence, harvest_rate)
		if(harvest_amount > 0 && storage.add_essence(installed_node.essence_type.type, harvest_amount))
			installed_node.current_essence -= harvest_amount
			installed_node.update_appearance(UPDATE_ICON)
			create_harvest_effect()

	if(!connection_processing || !output_connections.len)
		return
	var/list/prioritized_connections = sort_connections_by_priority(output_connections)
	for(var/datum/essence_connection/connection in prioritized_connections)
		if(!connection.active || !connection.target)
			continue
		var/datum/essence_storage/target_storage = get_target_storage(connection.target)
		if(!target_storage)
			continue
		var/essence_transferred = FALSE
		for(var/essence_type in storage.stored_essences)
			var/available = storage.get_essence_amount(essence_type)
			if(available > 0)
				if(!can_target_accept_essence(connection.target, essence_type))
					continue

				var/to_transfer = min(available, connection.transfer_rate)
				var/transferred = storage.transfer_to(target_storage, essence_type, to_transfer)
				if(transferred > 0)
					create_essence_transfer_effect(connection.target, essence_type, transferred)
					essence_transferred = TRUE
					break // Only transfer one type per cycle per connection

		if(essence_transferred)
			continue



/obj/machinery/essence/harvester/proc/create_harvest_effect()
	new /obj/effect/temp_visual/harvest_glow(get_turf(src))

/obj/machinery/essence/harvester/attackby(obj/item/I, mob/user, list/modifiers)
	if(istype(I, /obj/item/essence_node_jar))
		var/obj/item/essence_node_jar/jar = I
		if(jar.contained_node)
			if(installed_node)
				to_chat(user, span_warning("There's already a node installed."))
				return
			if(do_after(user, 3 SECONDS))
				var/obj/item/essence_node_portable/portable = jar.contained_node
				jar.contained_node = null
				jar.update_appearance(UPDATE_OVERLAYS)

				installed_node = portable
				portable.forceMove(src)
				STOP_PROCESSING(SSobj, portable)

				var/datum/thaumaturgical_essence/temp = new portable.essence_type.type
				to_chat(user, span_info("You install [portable] from the jar into the harvester. It will now automatically extract [temp.name]."))
				qdel(temp)

				update_appearance(UPDATE_OVERLAYS)
		else
			if(installed_node && do_after(user, 3 SECONDS))
				var/obj/item/essence_node_portable/portable = installed_node
				installed_node = null
				jar.contained_node = portable
				jar.update_appearance(UPDATE_OVERLAYS)
				portable.forceMove(jar)
				STOP_PROCESSING(SSobj, portable)

				to_chat(user, span_info("You extract [portable] from the harvester into the jar."))

				update_appearance(UPDATE_OVERLAYS)
			else
				to_chat(user, span_warning("The harvester is empty."))
				return
		return
	return ..()

/obj/machinery/essence/harvester/attack_hand(mob/user, list/modifiers)
	var/choice = input(user, "Harvester Control", "Essence Harvester") in list("Help", "View Node Status", "Cancel")

	switch(choice)
		if("Help")
			to_chat(user, span_info("Use a node jar on the harvester to install the node stored in the jar. \n You can remove nodes from the harvester using an empty jar."))
		if("View Node Status")
			if(installed_node)
				var/datum/thaumaturgical_essence/temp = new installed_node.essence_type.type
				to_chat(user, span_info("Installed Node Tier: Tier [installed_node.tier]"))
				to_chat(user, span_info("Essence Type: [temp.name]"))
				to_chat(user, span_info("Node Essence: [installed_node.current_essence]/[installed_node.max_essence]"))
				to_chat(user, span_info("Base Recharge Rate: [round(installed_node.recharge_rate)] essence/min"))
				to_chat(user, span_info("Actual Recharge Rate: [round(installed_node.recharge_rate * efficiency_bonus)] essence/min"))
				to_chat(user, span_info("Harvest Rate: [harvest_rate] essence/cycle"))
				qdel(temp)
			else
				to_chat(user, span_info("No node has been installed yet."))

/obj/machinery/essence/harvester/examine(mob/user)
	. = ..()
	. += span_notice("Harvest Rate: [harvest_rate] essence per cycle")
	. += span_notice("Node Efficiency Bonus: +[round((efficiency_bonus - 1) * 100)]% recharge rate")
	. += span_notice("Storage: [storage.get_total_stored()]/[storage.max_total_capacity] units")
	if(storage.stored_essences.len > 0)
		for(var/essence_type in storage.stored_essences)
			var/datum/thaumaturgical_essence/essence = new essence_type
			if(HAS_TRAIT(user, TRAIT_LEGENDARY_ALCHEMIST))
				. += span_notice("- [essence.name]: [storage.stored_essences[essence_type]] units")
			else
				. += span_notice("- essence smelling of [essence.smells_like]: [storage.stored_essences[essence_type]] units")
			qdel(essence)


	if(installed_node)
		var/datum/thaumaturgical_essence/temp = new installed_node.essence_type.type
		if(HAS_TRAIT(user, TRAIT_LEGENDARY_ALCHEMIST))
			. += span_notice("Installed Node: [temp.name], Tier [installed_node.tier]")
		else
			. += span_notice("Installed Node: essence smelling of [temp.smells_like], Tier [installed_node.tier]")
		. += span_notice("Node Essence: [installed_node.current_essence]/[installed_node.max_essence]")
		qdel(temp)
	else
		. += span_notice("ERROR: No node found. Use a containment jar to install one.")

// Visual effect for harvesting
/obj/effect/temp_visual/harvest_glow
	icon = 'icons/effects/effects.dmi'
	icon_state = "electricity"
	duration = 2 SECONDS

// Mapgen proc for spawning nodes as items
/proc/spawn_essence_nodes_in_area(area/target_area, node_density = 0.05, allow_rare = FALSE)
	var/list/valid_turfs = list()

	for(var/turf/T in target_area.get_turfs_from_all_zlevels())
		if(T.density)
			continue
		if(locate(/obj/structure/essence_node) in T)
			continue
		valid_turfs += T

	var/nodes_to_spawn = round(valid_turfs.len * node_density)

	for(var/i = 1 to nodes_to_spawn)
		if(!valid_turfs.len)
			break

		var/turf/spawn_turf = pick(valid_turfs)
		valid_turfs -= spawn_turf

		var/node_type = /obj/structure/essence_node

		// Rare nodes only in dungeons
		if(allow_rare && prob(5)) // 5% chance for rare
			node_type = /obj/structure/essence_node/rare

		new node_type(spawn_turf)
