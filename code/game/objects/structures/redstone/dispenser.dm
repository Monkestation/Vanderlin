
/obj/structure/redstone/dispenser
	name = "redstone dispenser"
	desc = "Dispenses items when powered."
	icon_state = "dispenser"
	redstone_role = REDSTONE_ROLE_OUTPUT
	var/dispensing = FALSE
	var/last_power = 0
	can_connect_wires = TRUE

/obj/structure/redstone/dispenser/Initialize()
	. = ..()
	AddComponent(/datum/component/storage/concrete/grid/bin)

/obj/structure/redstone/dispenser/on_power_changed()
	// Trigger on rising edge only
	if(power_level > 0 && last_power == 0 && !dispensing)
		dispense_item()
	last_power = power_level

/obj/structure/redstone/dispenser/proc/dispense_item()
	if(dispensing || !length(contents))
		return
	dispensing = TRUE

	var/obj/item/dispensed = contents[rand(1, length(contents))]
	var/turf/target_turf = get_step(src, dir)

	if(istype(dispensed, /obj/item/reagent_containers))
		handle_reagent_container(dispensed, target_turf)
	else
		SEND_SIGNAL(src, COMSIG_TRY_STORAGE_TAKE, dispensed, get_turf(src), TRUE)
		var/turf/throw_target = get_step(target_turf, dir)
		dispensed.throw_at(throw_target, 3, 1)

	spawn(2)
		dispensing = FALSE

/obj/structure/redstone/dispenser/proc/handle_reagent_container(obj/item/reagent_containers/container, turf/target_turf)
	if(!container.reagents)
		return
	if(container.reagents.total_volume > 0)
		var/list/reactant_list = list(container.reagents)
		chem_splash(target_turf, 1, reactant_list, 0)
		container.reagents.clear_reagents()
	else
		pickup_liquid(container, target_turf)

/obj/structure/redstone/dispenser/proc/pickup_liquid(obj/item/reagent_containers/container, turf/target_turf)
	if(!container.reagents || !target_turf.liquids?.liquid_group)
		return
	var/datum/liquid_group/pool = target_turf.liquids.liquid_group
	if(pool.total_reagent_volume <= 0)
		return
	var/pickup = min(pool.total_reagent_volume, container.reagents.maximum_volume - container.reagents.total_volume)
	if(pickup > 0)
		pool.transfer_to_atom(null, pickup, container)


/obj/structure/redstone/dispenser/AltClick(mob/user, list/modifiers)
	if(!Adjacent(user))
		return
	dir = turn(dir, 90)
	to_chat(user, "<span class='notice'>You rotate the [name].</span>")
