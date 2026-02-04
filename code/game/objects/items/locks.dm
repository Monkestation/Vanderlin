/obj/item/customlock //custom lock unfinished
	name = "unfinished lock"
	desc = "A lock without its pins set. Endless possibilities..."
	icon = 'icons/roguetown/items/keys.dmi'
	icon_state = "lock"
	w_class = WEIGHT_CLASS_SMALL
	dropshrink = 0.75
	can_unlock = FALSE // :D

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

/obj/item/customlock/attackby(obj/item/I, mob/user, list/modifiers)
	if(istype(I, /obj/item/weapon/hammer))
		var/input = input(user, "What would you like to set the lock ID to?", "", 0) as num
		input = abs(input)
		if(!input)
			return
		to_chat(user, span_notice("You set the lock ID to [input]."))
		lockids = list("[input]")
		return
	if(!check_access(I))
		to_chat(user, span_warning("[I] jams in [src]!"))
		return
	to_chat(user, span_notice("[I] twists cleanly in [src]."))

/obj/item/customlock/attackby_secondary(obj/item/I, mob/user, list/modifiers)
	. = ..()
	if(. == SECONDARY_ATTACK_CANCEL_ATTACK_CHAIN)
		return
	. = SECONDARY_ATTACK_CANCEL_ATTACK_CHAIN
	if(istype(I, /obj/item/weapon/hammer))
		if(!length(lockids))
			to_chat(user, span_notice("[src] is not ready, its pins are not set!"))
			return
		var/obj/item/customlock/finished/F = new (get_turf(src))
		F.lockids = lockids
		to_chat(user, span_notice("You finish [F]."))
		var/old_loc = loc
		qdel(src)
		if(user == old_loc)
			user.put_in_hands(F)
		return
	if(!copy_access(I))
		to_chat(user, span_warning("I cannot base the pins on [I]!"))
		return
	to_chat(user, span_notice("I set the pins based on [I]."))

//finished lock
/obj/item/customlock/finished
	name = "lock"
	desc = "A customized iron lock that is used by keys. A name can be etched in with a hammer."
	var/holdname = ""

/obj/item/customlock/finished/attackby(obj/item/I, mob/user, list/modifiers)
	if(!istype(I, /obj/item/weapon/hammer))
		..()
	holdname = browser_input_text(user, "What would you like to name this?", "", max_length = MAX_CHARTER_LEN)
	if(holdname)
		to_chat(user, span_notice("You label the [name] with [holdname]."))

/obj/item/customlock/finished/attackby_secondary(obj/item/I, mob/user, list/modifiers)
	return // Keep crashing until we fix this

/obj/item/customlock/finished/attack_atom(atom/attacked_atom, mob/living/user)
	if(!isobj(attacked_atom))
		return ..()

	var/obj/O = attacked_atom
	. = TRUE
	if(!O.can_add_lock)
		to_chat(user, span_warning("There is no place for a lock on [O]."))
		return
	if(O.lock)
		to_chat(user, span_warning("[O] already has a lock."))
		return
	if(holdname)
		O.name = holdname
	O.lock = new /datum/lock/key(O, lockids)
	to_chat(user, span_notice("I fit [src] to [O]."))
	qdel(src)
