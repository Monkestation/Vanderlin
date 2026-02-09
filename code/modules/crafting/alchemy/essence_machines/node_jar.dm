/obj/item/essence_node_jar
	name = "essence node containment jar"
	desc = "A specially crafted container designed to safely extract and transport essence nodes. The jar neutralizes most of the node's burden while carried."
	icon = 'icons/roguetown/misc/alchemy.dmi'
	icon_state = "node_jar"
	w_class = WEIGHT_CLASS_NORMAL

	var/obj/item/essence_node_portable/contained_node
	var/max_tier = 0

	var/jar_slowdown = 0.5 // Much less than carrying raw node
	var/jar_stamina_drain = 1 // Minimal drain
	var/last_drain = 0

/obj/item/essence_node_jar/Initialize()
	. = ..()
	last_drain = world.time
	update_appearance(UPDATE_OVERLAYS)
	START_PROCESSING(SSobj, src)

/obj/item/essence_node_jar/Destroy()
	STOP_PROCESSING(SSobj, src)
	return ..()

/obj/item/essence_node_jar/process()
	if(contained_node)
		var/mob/living/holder = loc
		if(istype(holder) && (src in holder.held_items))
			apply_jar_penalties(holder)

/obj/item/essence_node_jar/proc/apply_jar_penalties(mob/living/holder)
	if(world.time >= last_drain + 2 MINUTES) // Less frequent drain
		if(holder.stamina)
			var/drain_amount = jar_stamina_drain * (contained_node.tier + 1)
			holder.stamina = max(0, holder.stamina - drain_amount)
			if(contained_node.tier >= 1 && holder.stamina <= 30)
				to_chat(holder, span_notice("The contained essence node creates a slight burden."))
		last_drain = world.time

/obj/item/essence_node_jar/update_overlays()
	. = ..()
	if(!contained_node)
		return
	var/datum/thaumaturgical_essence/essence = contained_node.essence_type
	. += mutable_appearance(
		contained_node.icon,
		contained_node.icon_state,
		layer = src.layer - 0.1,
		color = initial(essence.color),
	)
	. += emissive_appearance(contained_node.icon, contained_node.icon_state, alpha = contained_node.alpha)

/obj/item/essence_node_jar/afterattack(atom/target, mob/user, proximity_flag, list/modifiers)
	if(!proximity_flag)
		. = ..()
		return

	if(!contained_node)
		return

	var/turf/deploy_turf = get_turf(target)
	if(!deploy_turf)
		return

	//to prevent the node getting put back insidethe harvester
	if(locate(/obj/machinery/essence/harvester) in deploy_turf)
		return

	if(deploy_turf.density)
		to_chat(user, span_warning("You cannot deploy the node here - the ground is not suitable."))
		return

	if(locate(/obj/structure/essence_node) in deploy_turf)
		to_chat(user, span_warning("There's already an essence node here."))
		return

	if(!do_after(user, 3 SECONDS, deploy_turf))
		return

	var/obj/structure/essence_node/deployed_node = new(deploy_turf)
	deployed_node.essence_type = contained_node.essence_type
	deployed_node.tier = contained_node.tier
	deployed_node.max_essence = contained_node.max_essence
	deployed_node.current_essence = contained_node.current_essence
	deployed_node.recharge_rate = contained_node.recharge_rate
	deployed_node.update_appearance(UPDATE_ICON)

	var/datum/thaumaturgical_essence/temp = new contained_node.essence_type.type
	to_chat(user, span_info("You carefully deploy the [contained_node.name] from the jar. The [temp.name] node is now active."))
	qdel(temp)

	qdel(contained_node)
	contained_node = null
	update_appearance(UPDATE_OVERLAYS)

/obj/item/essence_node_jar/examine(mob/user)
	. = ..()
	. += span_notice("Maximum node tier: [max_tier]")
	. += span_notice("Use on essence node structures to extract them for transport.")
	. += span_notice("Attack a turf to deploy contained nodes there.")

	if(contained_node)
		var/datum/thaumaturgical_essence/temp = new contained_node.essence_type.type
		. += span_info("Contains: [contained_node.name] ([temp.name], Tier [contained_node.tier])")
		. += span_info("Node essence: [contained_node.current_essence]/[contained_node.max_essence] units")
		. += span_notice("The contained node still creates a slight burden when carried.")
		qdel(temp)
	else
		. += span_notice("Empty. Use with an essence node structure to extract and contain it.")

/obj/item/essence_node_jar/advanced
	name = "advanced essence node containment jar"
	desc = "A masterwork containment vessel capable of safely transporting even the most powerful essence nodes. Advanced stabilization reduces carrying burden significantly."
	icon_state = "node_jar"
	max_tier = 1
	jar_slowdown = 0.2
	jar_stamina_drain = 0.5
