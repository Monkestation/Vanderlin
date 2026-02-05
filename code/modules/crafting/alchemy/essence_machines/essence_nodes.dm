GLOBAL_LIST_EMPTY(essence_nodes)

/obj/structure/essence_node
	name = "essence node"
	desc = "A weakened point in the environment that allows access to alchemical essence. It pulses with inner energy."
	icon = 'icons/roguetown/misc/alchemy.dmi'
	icon_state = "node"
	density = FALSE
	alpha = 150
	anchored = TRUE
	max_integrity = 100

	var/datum/thaumaturgical_essence/essence_type
	var/tier = 0 // 0 = common, 1 = rare
	var/max_essence = 100
	var/current_essence = 0
	var/recharge_rate = 1 // Essence per minute
	var/last_recharge = 0

	// Visual states
	base_icon_state = "node"

/obj/structure/essence_node/Initialize(mapload)
	. = ..()
	if(!tier && prob(10))
		tier = 1

	if(!essence_type)
		essence_type = pick_random_essence_type()
	switch(tier)
		if(0)
			max_essence = rand(50, 150)
			recharge_rate = rand(1, 3)
			max_integrity = 100
		if(1)
			max_essence = rand(200, 400)
			recharge_rate = rand(3, 6)
			max_integrity = 200

	current_essence = rand(max_essence * 0.3, max_essence * 0.8)
	last_recharge = world.time
	update_appearance(UPDATE_ICON)
	START_PROCESSING(SSobj, src)
	LAZYADD(GLOB.essence_nodes, src)

/obj/structure/essence_node/Destroy()
	STOP_PROCESSING(SSobj, src)
	LAZYREMOVE(GLOB.essence_nodes, src)
	return ..()

/obj/structure/essence_node/update_overlays()
	. = ..()
	. += emissive_appearance(icon, icon_state, alpha = src.alpha)

/obj/structure/essence_node/update_icon_state()
	. = ..()
	color = initial(essence_type.color)

/obj/structure/essence_node/proc/pick_random_essence_type()
	if(!tier)
		var/static/list/common_essences = list()
		if(!length(common_essences))
			for(var/datum/thaumaturgical_essence/essence as anything in subtypesof(/datum/thaumaturgical_essence))
				if(initial(essence.tier))
					continue
				common_essences |= essence
		return pick(common_essences)
	else
		var/static/list/common_and_rare_essences = list()
		if(!length(common_and_rare_essences))
			for(var/datum/thaumaturgical_essence/essence as anything in subtypesof(/datum/thaumaturgical_essence))
				if(initial(essence.tier) == 2)
					continue
				common_and_rare_essences |= essence
		return pick(common_and_rare_essences)

/obj/structure/essence_node/process()
	if(current_essence < max_essence && world.time >= last_recharge + 1 MINUTES)
		current_essence = min(max_essence, current_essence + recharge_rate)
		last_recharge = world.time

/obj/structure/essence_node/proc/can_harvest()
	return current_essence > 0

/obj/structure/essence_node/proc/harvest_essence(amount)
	var/harvested = min(current_essence, amount)
	current_essence -= harvested
	return harvested

/obj/structure/essence_node/proc/can_be_extracted()
	return TRUE

/obj/structure/essence_node/attackby(obj/item/I, mob/user, list/modifiers)
	if(istype(I, /obj/item/essence_vial))
		var/obj/item/essence_vial/vial = I

		if(!can_harvest())
			to_chat(user, span_warning("The node has no essence to harvest."))
			return

		if(!vial.can_hold_essence())
			to_chat(user, span_warning("The vial is already full."))
			return

		var/harvest_amount = min(current_essence, vial.get_available_space(), rand(5, 10))
		if(harvest_amount <= 0)
			return

		var/harvested = harvest_essence(harvest_amount)

		if(!vial.contained_essence)
			vial.contained_essence = new essence_type.type
			vial.essence_amount = harvested
		else if(vial.contained_essence.type == essence_type.type)
			vial.essence_amount += harvested
		else
			to_chat(user, span_warning("The vial contains a different type of essence."))
			current_essence += harvested // Refund
			return

		vial.update_appearance(UPDATE_OVERLAYS)

		var/datum/thaumaturgical_essence/temp_essence = new essence_type.type
		to_chat(user, span_info("You harvest [harvested] units of [temp_essence.name] from the node."))
		qdel(temp_essence)
		return

	if(istype(I, /obj/item/essence_node_jar))
		var/obj/item/essence_node_jar/jar = I

		if(jar.contained_node)
			to_chat(user, span_warning("The jar already contains a node."))
			return

		if(tier > jar.max_tier)
			to_chat(user, span_warning("This jar cannot contain such a powerful node."))
			return

		if(!can_be_extracted())
			to_chat(user, span_warning("The node cannot be extracted right now."))
			return

		if(!do_after(user, 5 SECONDS, src))
			return

		var/obj/item/essence_node_portable/portable_node = new(src.loc)
		portable_node.essence_type = essence_type
		portable_node.tier = tier
		portable_node.max_essence = max_essence
		portable_node.current_essence = current_essence
		portable_node.recharge_rate = recharge_rate
		portable_node.update_appearance(UPDATE_ICON_STATE)

		portable_node.forceMove(jar)
		jar.contained_node = portable_node
		jar.update_appearance(UPDATE_OVERLAYS)

		var/datum/thaumaturgical_essence/temp = new essence_type.type
		to_chat(user, span_info("You carefully extract the essence node and place it in the [jar]. The [temp.name] node is now safely contained."))
		qdel(temp)

		qdel(src)
		return

	return ..()

/obj/structure/essence_node/examine(mob/user)
	. = ..()
	var/datum/thaumaturgical_essence/temp_essence = new essence_type.type
	if(HAS_TRAIT(user, TRAIT_LEGENDARY_ALCHEMIST))
		. += span_notice("This node generates [temp_essence.name].")
	else
		. += span_notice("This node generates essence smelling of [temp_essence.smells_like].")

	. += span_notice("This node generates [temp_essence.name].")
	. += span_notice("Essence: [current_essence]/[max_essence] units")
	. += span_notice("Tier: [tier] ([tier ? "Rare" : "Common"])")
	. += span_notice("Recharge Rate: [recharge_rate] essence per minute")

	. += span_notice("Can be harvested with vials or extracted with a containment jar.")
	qdel(temp_essence)

/obj/structure/essence_node/rare
	tier = 1
	desc = "A pulsating blister that oozes with concentrated essence. These rare nodes contain immense power."
	icon_state = "node"

/obj/structure/essence_node/fire
	essence_type = /datum/thaumaturgical_essence/fire

/obj/structure/essence_node/water
	essence_type = /datum/thaumaturgical_essence/water

/obj/structure/essence_node/earth
	essence_type = /datum/thaumaturgical_essence/earth

/obj/structure/essence_node/air
	essence_type = /datum/thaumaturgical_essence/air

/obj/structure/essence_node/life
	essence_type = /datum/thaumaturgical_essence/life

/obj/item/essence_node_portable
	name = "essence node"
	desc = "A large amount of essence still wrapped within its environmental shell. It still beats with alchemical energy."
	icon = 'icons/roguetown/misc/alchemy.dmi'
	icon_state = "essence"
	w_class = WEIGHT_CLASS_BULKY

	var/datum/thaumaturgical_essence/essence_type
	var/tier = 0
	var/max_essence = 100
	var/current_essence = 0
	var/recharge_rate = 1
	var/last_recharge = 0

	// Carrying penalties (same as before)
	var/slowdown_penalty = 2
	var/stamina_drain = 5
	var/last_stamina_drain = 0

	base_icon_state = "essence_node_item"

/obj/item/essence_node_portable/Initialize()
	. = ..()
	switch(tier)
		if(0)
			slowdown_penalty = 2
			stamina_drain = 5
		if(1)
			slowdown_penalty = 3
			stamina_drain = 8

	last_recharge = world.time
	last_stamina_drain = world.time
	update_appearance(UPDATE_ICON_STATE)
	START_PROCESSING(SSobj, src)

/obj/item/essence_node_portable/update_icon_state()
	. = ..()
	color = initial(essence_type.color)

/obj/item/essence_node_portable/Destroy()
	STOP_PROCESSING(SSobj, src)
	return ..()

/obj/item/essence_node_portable/process()
	if(current_essence < max_essence && world.time >= last_recharge + 1 MINUTES)
		var/portable_penalty = 0.7
		var/adjusted_recharge = max(1, round(recharge_rate * portable_penalty))
		current_essence = min(max_essence, current_essence + adjusted_recharge)
		last_recharge = world.time
		update_appearance(UPDATE_ICON_STATE)

	var/mob/living/holder = loc
	if(istype(holder) && (src in holder.held_items))
		apply_carrying_penalties(holder)

/obj/item/essence_node_portable/proc/apply_carrying_penalties(mob/living/holder)
	if(!(src in holder.status_effects))
		holder.add_movespeed_modifier("essence_node", multiplicative_slowdown = 2)
	if(world.time >= last_stamina_drain + 1 MINUTES)
		if(holder.stamina)
			holder.stamina = max(0, holder.stamina - stamina_drain)
			if(holder.stamina <= 20)
				to_chat(holder, span_warning("Carrying the essence node is exhausting you!"))
		last_stamina_drain = world.time

/obj/item/essence_node_portable/dropped(mob/user)
	. = ..()
	if(user)
		user.remove_movespeed_modifier("essence_node")

/obj/item/essence_node_portable/pickup(mob/user)
	. = ..()
	to_chat(user, span_warning("The essence node feels heavy and drains your energy as you carry it."))
