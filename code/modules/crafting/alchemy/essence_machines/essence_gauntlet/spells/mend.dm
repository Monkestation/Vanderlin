/datum/action/cooldown/spell/essence/mend
	name = "Minor Mend"
	desc = "Repairs minor damage to simple objects."
	button_icon_state = "mending"
	cast_range = 1
	attunements = list(/datum/attunement/earth)
	point_cost = 3
	essences = list(/datum/thaumaturgical_essence/earth)

	var/repair_percent = 0.08

/datum/action/cooldown/spell/essence/mend/is_valid_target(atom/cast_on)
	. = ..()
	if(!.)
		return FALSE
	if(!istype(cast_on, /obj/item))
		if(owner)
			to_chat(owner, span_warning("I need to target an item!"))
		return FALSE
	var/obj/item/I = cast_on
	if(!I.anvilrepair && !I.sewrepair)
		if(owner)
			to_chat(owner, span_warning("Not even magic can mend this item!"))
		return FALSE
	if(I.get_integrity() >= I.max_integrity * 0.8)
		if(owner)
			to_chat(owner, span_info("[I] appears to be in perfect condition."))
		return FALSE
	return TRUE

/datum/action/cooldown/spell/essence/mend/cast(atom/cast_on)
	. = ..()
	var/mob/living/user = owner
	if(!istype(user))
		return FALSE

	var/obj/item/I = cast_on

	user.visible_message(
		span_warning("[user] begins to concentrate on [I]!"),
		span_notice("I begin to concentrate on [I]..")
	)
	if(do_after(user, 2 SECONDS, I))
		var/initial_damage = user.getBruteLoss() + user.getFireLoss()
		for(var/i = 1, i <= 20, i++)
			if(user.getBruteLoss() + user.getFireLoss() > initial_damage + 10)
				to_chat(user, span_warning("I can't concentrate like this!"))
				return
			if(do_after(user, 1.6 SECONDS, I))
				repair_percent = initial(repair_percent)
				repair_percent *= I.max_integrity

				I.update_integrity(min(I.get_integrity() + repair_percent, I.max_integrity * 0.8))
				user.visible_message(span_info("[I] glows in a faint mending light."))
				playsound(I, 'sound/magic/mending.ogg', 20, TRUE, -2)

				if(I.get_integrity() >= I.max_integrity)
					if(I.obj_broken)
						I.atom_fix()
					break
			else
				break
		return TRUE
	else
		to_chat(user, span_warning("My concentration breaks! I could not repair [I]."))
	return FALSE
