/obj/item/reagent_containers/syringe
	name = "infusion syringe"
	desc = "A metal implement made for the drawing and injecting of various fluids."
	icon = 'icons/obj/medical.dmi'
	icon_state = "syringe"
	amount_per_transfer_from_this = 5
	fill_icon_thresholds = list(0, 1, 5, 10, 15)
	grid_width = 64
	grid_height = 32
	volume = 15
	reagent_flags = TRANSPARENT

/obj/item/reagent_containers/syringe/proc/try_syringe(atom/target, mob/user)
	if(!target.reagents)
		return FALSE

	if(isliving(target))
		var/mob/living/living_target = target
		if(!living_target.can_inject())
			return FALSE

	return TRUE

/obj/item/reagent_containers/syringe/interact_with_atom(atom/target, mob/living/user, list/modifiers)
	if(!target.reagents)
		return NONE

	if(!try_syringe(target, user))
		return ITEM_INTERACT_BLOCKING

	var/contained = reagents.get_reagent_log_string()
	log_combat(user, target, "attempted to inject", src, addition="which had [contained]")

	if(!reagents.total_volume)
		to_chat(user, span_warning("[src] is empty! Right-click to draw."))
		return ITEM_INTERACT_BLOCKING

	if(!isliving(target) && !target.is_injectable(user))
		to_chat(user, span_warning("You cannot directly fill [target]!"))
		return ITEM_INTERACT_BLOCKING

	if(target.reagents.holder_full())
		to_chat(user, span_notice("[target] is full."))
		return ITEM_INTERACT_BLOCKING

	if(isliving(target))
		var/mob/living/living_target = target
		if(living_target != user)
			living_target.visible_message(
				span_danger("[user] is trying to inject [living_target]!"),
				span_userdanger("[user] is trying to inject you!"),
			)
			if(!do_after(user, 4 SECONDS, living_target, extra_checks = CALLBACK(src, PROC_REF(try_syringe), living_target, user)))
				return ITEM_INTERACT_BLOCKING
			if(!reagents.total_volume)
				return ITEM_INTERACT_BLOCKING
			if(living_target.reagents.holder_full())
				return ITEM_INTERACT_BLOCKING
			living_target.visible_message(
				span_danger("[user] injects [living_target] with the syringe!"),
				span_userdanger("[user] injects you with the syringe!"),
			)

		if(living_target == user)
			living_target.log_message("injected themselves ([contained]) with [name]", LOG_ATTACK, color="orange")
		else
			log_combat(user, living_target, "injected", src, addition="which had [contained]")

	if(reagents.trans_to(target, amount_per_transfer_from_this, transfered_by = user, method = INJECT))
		to_chat(user, span_notice("You inject [amount_per_transfer_from_this] units of the solution. The syringe now contains [reagents.total_volume] units."))
		target.update_appearance()
		return ITEM_INTERACT_SUCCESS

/obj/item/reagent_containers/syringe/interact_with_atom_secondary(atom/target, mob/living/user, list/modifiers)
	if(!target.reagents)
		return NONE

	if(!try_syringe(target, user))
		return ITEM_INTERACT_BLOCKING

	if(reagents.holder_full())
		to_chat(user, span_notice("[src] is full."))
		return ITEM_INTERACT_BLOCKING

	if(isliving(target))
		var/mob/living/living_target = target
		var/drawn_amount = reagents.maximum_volume - reagents.total_volume
		if(target != user)
			target.visible_message(
				span_danger("[user] is trying to take a blood sample from [target]!"),
				span_userdanger("[user] is trying to take a blood sample from you!"),
			)
			if(!do_after(user, 4 SECONDS, target, extra_checks = CALLBACK(src, PROC_REF(try_syringe), living_target, user)))
				return ITEM_INTERACT_BLOCKING
			if(reagents.holder_full())
				return ITEM_INTERACT_BLOCKING
		if(living_target.transfer_blood_to(src, drawn_amount))
			user.visible_message(span_notice("[user] takes a blood sample from [living_target]."))
		else
			to_chat(user, span_warning("You are unable to draw any blood from [living_target]!"))
		return ITEM_INTERACT_SUCCESS

	if(!target.reagents.total_volume)
		to_chat(user, span_warning("[target] is empty!"))
		return ITEM_INTERACT_BLOCKING

	if(!target.is_drawable(user))
		to_chat(user, span_warning("You cannot directly remove reagents from [target]!"))
		return ITEM_INTERACT_BLOCKING

	var/trans = target.reagents.trans_to(src, amount_per_transfer_from_this, transfered_by = user) // transfer from, transfer to - who cares?

	to_chat(user, span_notice("You fill [src] with [trans] units of the solution. It now contains [reagents.total_volume] units."))
	target.update_appearance()

	return ITEM_INTERACT_SUCCESS
