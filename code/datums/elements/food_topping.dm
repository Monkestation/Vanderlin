/**
 * Lets an item be applied onto snacks as a topping.
 * TODO: Something for reagents? IDK how I'd do that tbh
 */
/datum/element/food_topping
	element_flags = ELEMENT_BESPOKE
	argument_hash_start_idx = 2
	var/overlay_state
	var/overlay_icon
	var/datum/ingredient_buff_modifier/modifier
	var/reagent_transfer
	var/topping_name


/datum/element/food_topping/Attach(datum/target, overlay_state, modifier_type, reagent_transfer = 5, overlay_icon = 'icons/obj/food/topping_overlays.dmi', topping_name)
	. = ..()
	if(!isitem(target) || !overlay_state)
		return ELEMENT_INCOMPATIBLE
	src.overlay_state = overlay_state
	src.overlay_icon = overlay_icon
	src.reagent_transfer = reagent_transfer
	src.topping_name = topping_name
	if(modifier_type && !modifier)
		modifier = new modifier_type()
	RegisterSignal(target, COMSIG_ITEM_INTERACTING_WITH_ATOM, PROC_REF(on_interact))
	RegisterSignal(target, COMSIG_ATOM_EXAMINE, PROC_REF(on_examine))

/datum/element/food_topping/Detach(datum/source)
	UnregisterSignal(source, COMSIG_ITEM_INTERACTING_WITH_ATOM)
	UnregisterSignal(source, COMSIG_ATOM_EXAMINE)
	return ..()

/datum/element/food_topping/proc/on_examine(datum/source, mob/user, list/examine_list)
	SIGNAL_HANDLER
	examine_list += span_notice("Can be used as a topping on finished foods.")


/datum/element/food_topping/proc/on_interact(obj/item/source, mob/living/user, atom/interacting_with, list/modifiers)
	SIGNAL_HANDLER

	if(!istype(interacting_with, /obj/item/reagent_containers/food/snacks))
		return NONE
	var/obj/item/reagent_containers/food/snacks/dish = interacting_with
	if(dish.given_ingredient_buff)
		return NONE

	if(overlay_state in dish.applied_toppings)
		to_chat(user, span_warning("[dish] already has [source] on it."))
		return ITEM_INTERACT_BLOCKING
	if(!source.reagents?.total_volume)
		to_chat(user, span_warning("[source] is empty!"))
		return ITEM_INTERACT_BLOCKING

	var/free_space = dish.reagents.maximum_volume - dish.reagents.total_volume
	if(free_space <= 0)
		to_chat(user, span_warning("[dish] is stacked so high that [source] just drips off!"))
		return ITEM_INTERACT_BLOCKING

	// null reagent_transfer = use everything
	var/amount = min(isnull(reagent_transfer) ? source.reagents.total_volume : reagent_transfer, source.reagents.total_volume, free_space)
	source.reagents.trans_to(dish, amount, transfered_by = user)

	if(modifier)
		modifier.apply_to_dish(dish)

	dish.applied_toppings += overlay_state
	dish.topping_names += (topping_name || source.name)
	dish.update_topping_name()

	var/mutable_appearance/topping_overlay = mutable_appearance(overlay_icon, overlay_state)
	var/half_icon = world.icon_size / 2
	var/click_x = text2num(LAZYACCESS(modifiers, ICON_X))
	var/click_y = text2num(LAZYACCESS(modifiers, ICON_Y))
	if(!isnull(click_x) && !isnull(click_y))
		topping_overlay.pixel_x = clamp(click_x - half_icon, -half_icon, half_icon)
		topping_overlay.pixel_y = clamp(click_y - half_icon, -half_icon, half_icon)
	dish.add_overlay(topping_overlay)
	to_chat(user, span_notice("You apply [source] to [dish]."))
	qdel(source)
	return ITEM_INTERACT_SUCCESS
