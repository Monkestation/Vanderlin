/obj/item/customlock //custom lock unfinished
	name = "unfinished lock"
	desc = "A lock without its pins set. Endless possibilities..."
	icon = 'icons/roguetown/items/keys.dmi'
	icon_state = "lock"
	w_class = WEIGHT_CLASS_SMALL
	dropshrink = 0.75
	can_unlock = FALSE // :D
	item_weight = 200 GRAMS

/obj/item/customlock/examine()
	. = ..()
	if(get_access())
		. += span_info("It has been etched with [access2string()].")
		return
	. += span_info("Its pins can be set with a hammer or copied from an existing lock or key.")

/obj/item/customlock/proc/check_access(obj/item/I)
	var/access
	if(istype(I, /obj/item/key/custom))
		var/obj/item/key/custom/k = I
		if(k.access2add)
			access = k.access2add
		else
			access = k.get_access()
	else
		access = I.get_access()
	if(!access)
		return FALSE
	for(var/id as anything in lockids)
		if(id in access)
			return TRUE
	return FALSE

/obj/item/customlock/item_interaction(mob/living/user, obj/item/tool, list/modifiers)
	if(user.cmode)
		return NONE

	if(istype(tool, /obj/item/weapon/hammer))
		var/input = input(user, "What would you like to set the lock ID to?", "", 0) as num
		input = abs(input)
		if(!input)
			return ITEM_INTERACT_BLOCKING

		to_chat(user, span_notice("You set the lock ID to [input]."))
		lockids = list("[input]")
		return ITEM_INTERACT_SUCCESS

	if(!check_access(tool))
		to_chat(user, span_warning("[tool] jams in [src]!"))
		return ITEM_INTERACT_SUCCESS

	to_chat(user, span_notice("[tool] twists cleanly in [src]."))
	return ITEM_INTERACT_SUCCESS

/obj/item/customlock/item_interaction_secondary(mob/living/user, obj/item/tool, list/modifiers)
	if(istype(tool, /obj/item/weapon/hammer))
		if(!length(lockids))
			to_chat(user, span_notice("[src] is not ready, its pins are not set!"))
			return ITEM_INTERACT_BLOCKING
		var/obj/item/customlock/finished/F = new (get_turf(src))
		F.lockids = lockids
		to_chat(user, span_notice("You finish [F]."))
		var/old_loc = loc
		qdel(src)
		if(user == old_loc)
			user.put_in_hands(F)
		return ITEM_INTERACT_SUCCESS

	if(!copy_access(tool))
		to_chat(user, span_warning("I cannot base the pins on [tool]!"))
		return ITEM_INTERACT_BLOCKING

	to_chat(user, span_notice("I set the pins based on [tool]."))
	return ITEM_INTERACT_SUCCESS

//finished lock
/obj/item/customlock/finished
	name = "lock"
	desc = "A customized iron lock that is used by keys. A name can be etched in with a hammer."
	var/holdname = ""

/obj/item/customlock/finished/item_interaction(mob/living/user, obj/item/tool, list/modifiers)
	if(!istype(tool, /obj/item/weapon/hammer))
		return NONE

	holdname = browser_input_text(user, "What would you like to name this?", "", max_length = MAX_CHARTER_LEN)

	if(holdname)
		to_chat(user, span_notice("You label the [name] with [holdname]."))

	return ITEM_INTERACT_SUCCESS

/obj/item/customlock/finished/item_interaction_secondary(mob/living/user, obj/item/tool, list/modifiers)
	return NONE

/obj/item/customlock/finished/interact_with_atom(atom/interacting_with, mob/living/user, list/modifiers)
	if(!isobj(interacting_with))
		return NONE

	var/obj/O = interacting_with

	if(!O.can_add_lock)
		to_chat(user, span_warning("There is no place for a lock on [O]."))
		return ITEM_INTERACT_BLOCKING

	if(O.lock)
		to_chat(user, span_warning("[O] already has a lock."))
		return ITEM_INTERACT_BLOCKING

	if(holdname)
		O.name = holdname

	O.lock = new /datum/lock/key(O, lockids)
	to_chat(user, span_notice("I fit [src] to [O]."))
	qdel(src)

	return ITEM_INTERACT_SUCCESS
