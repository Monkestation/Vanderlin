#define METAL_REPAIR	(1<<0)
#define CLOTH_REPAIR	(1<<1)

/obj/item/repair_kit
	name = "repair kit"
	desc = "An specialized container that can be loaded with materials to provide reliable field repairs."
	icon = 'icons/roguetown/items/misc.dmi'
	icon_state = "armorkit_empty"
	grid_width = 64
	grid_height = 32
	dropshrink = 0.7

	var/repairable_integrity = 0
	var/maximum_capacity = 0
	var/refill_amount = 100
	var/repair_type
	var/half_icon_state = ""

/obj/item/repair_kit/Initialize(mapload)
	. = ..()
	update_appearance(UPDATE_ICON_STATE)

/obj/item/repair_kit/examine(mob/user)
	. = ..()
	if(!repair_type)
		return
	. += span_bold("[src] has [PERCENT(repairable_integrity/maximum_capacity)]% of its capacity remaining.")

/obj/item/repair_kit/update_icon_state()
	. = ..()
	if(!repairable_integrity)
		icon_state = "armorkit_empty"
	else if(half_icon_state && repairable_integrity < maximum_capacity / 2)
		icon_state = half_icon_state
	else
		icon_state = initial(icon_state)

/obj/item/repair_kit/atom_destruction(damage_flag)
	var/turf/current_turf = get_turf(src)
	if(repair_type & CLOTH_REPAIR)
		switch(rand(1, 5))
			if(1 to 2)
				new /obj/item/natural/cloth(current_turf)
			if(3 to 4)
				new /obj/item/natural/hide/cured(current_turf)
			if(5)
				new /obj/item/natural/fibers(current_turf)
	if(repair_type & METAL_REPAIR)
		switch(rand(1, 2))
			if(1)
				new /obj/item/ingot/iron(current_turf)
			if(2)
				new /obj/item/ingot/steel_slag(current_turf)
	. = ..()

/obj/item/repair_kit/item_interaction(mob/living/user, obj/item/tool, list/modifiers)
	return attempt_refill(user, tool)

/obj/item/repair_kit/proc/attempt_refill(mob/living/user, obj/item/tool)
	if(repairable_integrity >= maximum_capacity)
		return NONE
	var/list/valid_types = list()
	if(repair_type & CLOTH_REPAIR)
		valid_types |= list(/obj/item/natural/cloth, /obj/item/natural/hide/cured)
	if(repair_type & METAL_REPAIR)
		valid_types |= list(/obj/item/ingot/iron, /obj/item/ingot/steel, /obj/item/ingot/steel_slag)
	valid_types = typecacheof(valid_types)
	if(is_type_in_typecache(tool, valid_types))
		repairable_integrity = min(maximum_capacity, repairable_integrity + refill_amount)
		to_chat(user, span_notice("I refill [src] with [tool] to [PERCENT(repairable_integrity / maximum_capacity)]% capacity."))
		qdel(tool)
		update_appearance(UPDATE_ICON_STATE)
		return ITEM_INTERACT_SUCCESS

/obj/item/repair_kit/interact_with_atom(atom/interacting_with, mob/living/user, list/modifiers)
	if(istype(interacting_with, /obj/machinery/anvil))
		var/obj/machinery/anvil/anvil = interacting_with
		if(anvil.working_material)
			interacting_with = anvil.working_material
	if(!isitem(interacting_with))
		return ..()
	INVOKE_ASYNC(src, PROC_REF(attempt_repair), interacting_with, user)
	return TRUE

/obj/item/repair_kit/proc/attempt_repair(atom/attacked_atom, mob/living/user, silent = FALSE)
	var/obj/item/attacked_item = attacked_atom
	if(!repairable_integrity)
		to_chat(user, span_warning("[src] is fully depleted and out of material!"))
		return
	if(!attacked_item.uses_integrity || attacked_item.get_integrity() >= attacked_item.max_integrity)
		to_chat(user, span_warning("[attacked_item] can't be repaired."))
		return
	var/valid_check = FALSE
	if(!valid_check && (repair_type & METAL_REPAIR) && attacked_item.anvilrepair)
		valid_check = TRUE
	if(!valid_check && (repair_type & CLOTH_REPAIR) && attacked_item.sewrepair)
		valid_check = TRUE
	if(!valid_check)
		to_chat(user, span_warning("[src] can't be used to repair [attacked_item]!"))
		return
	if(!isturf(attacked_item.loc))
		to_chat(user, span_warning("I should put [attacked_item] down first."))
		return

	if(repair_type & METAL_REPAIR)
		playsound(attacked_item,'sound/items/bsmith3.ogg', 100, TRUE, -2)
	else
		playsound(attacked_item, 'sound/foley/sewflesh.ogg', 50, TRUE, -2)
	if(!do_after(user, 2 SECONDS, target = attacked_atom))
		return

	attacked_item.repair_damage(repairable_integrity/10) //10%
	repairable_integrity = max(repairable_integrity - 10, 0) //can restore 700% for good cloth kits, and 300% for bad cloth, 400% for bad metal,  1000% for good metal kit.
	update_appearance(UPDATE_ICON_STATE)

	if(!silent)
		user.visible_message(span_info("[user] repairs [attacked_item] with [src]."))
	var/experience_gained = max(GET_MOB_ATTRIBUTE_VALUE(user, STAT_INTELLIGENCE), 1) * 0.1
	if(repair_type & METAL_REPAIR)
		user.add_sleep_experience(attacked_item.anvilrepair, experience_gained * user.get_learning_boon(attacked_item.anvilrepair))
	else
		user.add_sleep_experience(attacked_item.sewrepair, experience_gained * user.get_learning_boon(attacked_item.sewrepair))
	if(repairable_integrity && attacked_item.get_integrity() < attacked_item.max_integrity)
		INVOKE_ASYNC(src, PROC_REF(attempt_repair), attacked_item, user, TRUE)

/obj/item/repair_kit/cloth
	name = "sewing kit"
	icon_state = "sewingkit"
	desc = "A set of sewing materials that includes reinforced fabric lines, leather patches, and sheets of cloth for repairing clothing."
	repairable_integrity = 600
	maximum_capacity = 600
	repair_type = CLOTH_REPAIR
	half_icon_state = "custarsewingkit"

/obj/item/repair_kit/cloth/half
	repairable_integrity = 300

/obj/item/repair_kit/cloth/empty
	repairable_integrity = 0

/obj/item/repair_kit/metal
	name = "metal repair kit"
	icon_state = "armorkit"
	desc = "A collection of armor plates, polishing wax, and spare metal scraps. Everything you need to perform field repairs on metal equipment."
	repairable_integrity = 600
	maximum_capacity = 600
	repair_type = METAL_REPAIR
	half_icon_state = "custararmorkit"

/obj/item/repair_kit/metal/half
	repairable_integrity = 300

/obj/item/repair_kit/metal/empty
	repairable_integrity = 0

#undef METAL_REPAIR
#undef CLOTH_REPAIR
