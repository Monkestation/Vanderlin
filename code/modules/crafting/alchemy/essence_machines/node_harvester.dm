
/obj/machinery/essence/harvester
	name        = "essence harvester"
	desc        = "A mechanical solution to large-scale essence extraction. Install an essence node to begin leeching alchemical energy from the land."
	icon        = 'icons/roguetown/misc/splitter.dmi'
	icon_state  = "splitter"
	network_priority = 1

	var/obj/structure/essence_node/installed_node
	/// Units harvested from the node per process tick
	var/harvest_rate = 2
	/// Multiplier applied to the node's natural recharge rate
	var/efficiency_bonus = 1.5

/obj/machinery/essence/harvester/Initialize()
	. = ..()
	storage.max_total = 500
	storage.max_types = 10
	START_PROCESSING(SSobj, src)

/obj/machinery/essence/harvester/Destroy()
	STOP_PROCESSING(SSobj, src)
	if(installed_node)
		installed_node.forceMove(get_turf(src))
		installed_node = null
	return ..()

/obj/machinery/essence/harvester/build_allowed_types()
	return list()

/obj/machinery/essence/harvester/process()
	// 1. Recharge the installed node
	if(installed_node)
		if(installed_node.current_essence < installed_node.max_essence \
		   && world.time >= installed_node.last_recharge + 1 MINUTES)
			var/recharge = round(installed_node.recharge_rate * efficiency_bonus)
			installed_node.current_essence = min(
				installed_node.max_essence,
				installed_node.current_essence + recharge)
			installed_node.last_recharge = world.time
			installed_node.update_appearance(UPDATE_ICON)

		// 2. Harvest from node into local storage
		if(installed_node.current_essence > 0)
			var/harvested = min(installed_node.current_essence, harvest_rate)
			var/added = storage.add(installed_node.essence_type.type, harvested)
			if(added > 0)
				installed_node.current_essence -= added
				installed_node.update_appearance(UPDATE_ICON)
				new /obj/effect/temp_visual/harvest_glow(get_turf(src))

	// 3. Push what we have out through outbound links
	push_to_linked(storage)

/obj/machinery/essence/harvester/get_mechanics_examine(mob/user)
	. = ..()
	. += span_notice("Harvest rate: [harvest_rate] units/tick")
	. += span_notice("Node recharge bonus: +[round((efficiency_bonus - 1) * 100)]%")
	if(installed_node)
		var/datum/thaumaturgical_essence/tmp = new installed_node.essence_type.type
		var/label = HAS_TRAIT(user, TRAIT_LEGENDARY_ALCHEMIST) \
			? tmp.name : "essence smelling of [tmp.smells_like]"
		. += span_notice("Node: [label] — Tier [installed_node.tier]")
		. += span_notice("Node charge: [installed_node.current_essence]/[installed_node.max_essence]")
		. += span_notice("Effective recharge: [round(installed_node.recharge_rate * efficiency_bonus)] units/min")
		qdel(tmp)
	else
		. += span_warning("No node installed. Use a node jar to insert one.")

/obj/machinery/essence/harvester/attack_hand(mob/living/user)
	var/choice = input(user, "Harvester Control", "Essence Harvester") \
		in list("Help", "View Status", "Cancel")
	switch(choice)
		if("Help")
			to_chat(user, span_info("Use a node jar on the harvester to install or remove a node."))
		if("View Status")
			for(var/line in get_mechanics_examine(user))
				to_chat(user, line)

/obj/machinery/essence/harvester/attackby(obj/item/I, mob/user, list/modifiers)
	if(istype(I, /obj/item/essence_node_jar))
		handle_node_jar(I, user)
		return
	return ..()

/obj/machinery/essence/harvester/proc/handle_node_jar(obj/item/essence_node_jar/jar, mob/user)
	if(jar.contained_node)
		if(installed_node)
			to_chat(user, span_warning("A node is already installed."))
			return
		if(!do_after(user, 3 SECONDS))
			return
		var/obj/item/essence_node_portable/node = jar.contained_node
		jar.contained_node = null
		jar.update_appearance(UPDATE_OVERLAYS)
		installed_node = node
		node.forceMove(src)
		STOP_PROCESSING(SSobj, node)
		var/datum/thaumaturgical_essence/tmp = new node.essence_type.type
		to_chat(user, span_info("You install the node. It will extract [tmp.name]."))
		qdel(tmp)
		update_appearance(UPDATE_OVERLAYS)
	else
		if(!installed_node)
			to_chat(user, span_warning("No node to remove."))
			return
		if(!do_after(user, 3 SECONDS))
			return
		jar.contained_node = installed_node
		jar.update_appearance(UPDATE_OVERLAYS)
		installed_node.forceMove(jar)
		STOP_PROCESSING(SSobj, installed_node)
		installed_node = null
		to_chat(user, span_info("You remove the node into the jar."))
		update_appearance(UPDATE_OVERLAYS)

/obj/machinery/essence/harvester/update_overlays()
	. = ..()
	if(!installed_node)
		return
	var/mutable_appearance/node_ma = mutable_appearance(
		installed_node.icon, installed_node.icon_state,
		layer = src.layer + 0.1, color = installed_node.color)
	node_ma.pixel_y = 12
	. += node_ma
	var/mutable_appearance/emit = emissive_appearance(
		installed_node.icon, installed_node.icon_state, alpha = node_ma.alpha)
	emit.pixel_y = 12
	. += emit

/obj/effect/temp_visual/harvest_glow
	icon = 'icons/effects/effects.dmi'
	icon_state = "electricity"
	duration = 2 SECONDS
