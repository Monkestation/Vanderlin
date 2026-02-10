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
	var/mode = SYRINGE_DRAW
	var/busy = FALSE		// needed for delayed drawing of blood

/obj/item/reagent_containers/syringe/Initialize()
	. = ..()
	AddElement(/datum/element/update_icon_updates_onmob)
	if(list_reagents) //syringe starts in inject mode if its already got something inside
		mode = SYRINGE_INJECT
		update_appearance(UPDATE_OVERLAYS)

/obj/item/reagent_containers/syringe/pickup(mob/user)
	..()
	update_appearance(UPDATE_OVERLAYS)

/obj/item/reagent_containers/syringe/dropped(mob/user)
	..()
	update_appearance(UPDATE_OVERLAYS)

/obj/item/reagent_containers/syringe/attack_self(mob/user)
	mode = !mode
	update_appearance(UPDATE_OVERLAYS)

//ATTACK HAND IGNORING PARENT RETURN VALUE
/obj/item/reagent_containers/syringe/attack_hand()
	. = ..()
	update_appearance(UPDATE_OVERLAYS)

/obj/item/reagent_containers/syringe/attack_paw(mob/user)
	return attack_hand(user)

/obj/item/reagent_containers/syringe/attackby(obj/item/I, mob/user, params)
	return

/obj/item/reagent_containers/syringe/afterattack(atom/target, mob/user , proximity, list/modifiers)
	. = ..()
	if(busy)
		return
	if(!proximity)
		return
	if(!target.reagents)
		return

	var/mob/living/L
	if(isliving(target))
		L = target
		if(!L.can_inject(user, 1))
			return

	switch(mode)
		if(SYRINGE_DRAW)

			if(reagents.total_volume >= reagents.maximum_volume)
				to_chat(user, span_notice("\The [src] is full."))
				return

			if(L) //living mob
				var/drawn_amount = reagents.maximum_volume - reagents.total_volume
				if(target != user)
					target.visible_message(span_danger("[user] tries to draw blood from [target]!"), \
									span_userdanger("[user] is trying to draw blood from me!"))
					busy = TRUE
					if(!do_after(user, 4 SECONDS, target, extra_checks=CALLBACK(L, TYPE_PROC_REF(/mob/living, can_inject), user, TRUE)))
						busy = FALSE
						return
					if(reagents.total_volume >= reagents.maximum_volume)
						return
				busy = FALSE
				if(L.transfer_blood_to(src, drawn_amount))
					user.visible_message(span_notice("[user] draws blood from [L]."))
				else
					to_chat(user, span_warning("I am unable to draw any blood from [L]!"))

			else //if not mob
				if(!target.reagents.total_volume)
					to_chat(user, span_warning("[target] is empty!"))
					return

				if(!target.is_drawable(user))
					to_chat(user, span_warning("I cannot directly remove reagents from [target]!"))
					return

				var/trans = target.reagents.trans_to(src, amount_per_transfer_from_this, transfered_by = user)

				to_chat(user, span_notice("I fill \the [src] with [UNIT_FORM_STRING(trans)] from [target]. It now contains [UNIT_FORM_STRING(reagents.total_volume)]."))
			if(reagents.total_volume >= reagents.maximum_volume)
				mode = SYRINGE_INJECT
				update_appearance(UPDATE_OVERLAYS)

		if(SYRINGE_INJECT)
			// Always log attemped injections for admins
			var/contained = reagents.log_list()
			log_combat(user, target, "attempted to inject", src, addition = "which had [contained]")

			if(!reagents.total_volume)
				to_chat(user, span_warning("[src] is empty!"))
				return

			if(!L && !target.is_injectable(user)) //only checks on non-living mobs, due to how can_inject() handles
				to_chat(user, span_warning("I cannot directly fill [target]!"))
				return

			if(target.reagents.total_volume >= target.reagents.maximum_volume)
				to_chat(user, span_notice("[target] is full."))
				return

			if(L) //living mob
				if(!L.can_inject(user, TRUE))
					return
				if(L != user)
					L.visible_message(span_danger("[user] is trying to inject [L]!"), \
											span_userdanger("[user] is trying to inject me!"))
					if(!do_after(user, 4 SECONDS, L, extra_checks = CALLBACK(L, TYPE_PROC_REF(/mob/living, can_inject), user, TRUE)))
						return
					if(!reagents.total_volume)
						return
					if(L.reagents.total_volume >= L.reagents.maximum_volume)
						return
					L.visible_message(span_danger("[user] injects [L] with the \the [src]!"), \
									span_userdanger("[user] injects me!"))

				if(L != user)
					log_combat(user, L, "injected", src, addition = "which had [contained]")
				else
					L.log_message("injected themselves ([contained]) with [src.name]", LOG_ATTACK, color="orange")
			reagents.trans_to(target, amount_per_transfer_from_this, transfered_by = user, method = INJECT)
			to_chat(user, span_notice("I inject [UNIT_FORM_STRING(amount_per_transfer_from_this)] into [target]. \The [src] now contains [UNIT_FORM_STRING(reagents.total_volume)]."))
			if(!reagents.total_volume && mode == SYRINGE_INJECT)
				mode = SYRINGE_DRAW
				update_appearance(UPDATE_OVERLAYS)

/obj/item/reagent_containers/syringe/update_overlays()
	. = ..()
	if(!ismob(loc))
		return
	var/injoverlay
	switch(mode)
		if(SYRINGE_DRAW)
			injoverlay = "draw"
		if(SYRINGE_INJECT)
			injoverlay = "inject"
	. += injoverlay
