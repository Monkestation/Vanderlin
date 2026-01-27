/obj/item/storage
	abstract_type = /obj/item/storage
	name = "storage"
	w_class = WEIGHT_CLASS_NORMAL
	var/rummage_if_nodrop = TRUE
	/// Storage datum type to use
	var/storage_type = null
	/// If right click takes a random item from the bag
	var/right_click_remove = FALSE

/obj/item/storage/Initialize(mapload, ...)
	. = ..()

	create_storage(type = storage_type)

	populate_contents()

/obj/item/storage/attack_hand_secondary(mob/user, params)
	. = ..()
	if(. == SECONDARY_ATTACK_CANCEL_ATTACK_CHAIN)
		return
	if(!right_click_remove || !length(contents))
		return
	var/obj/item/random = pick(contents)
	atom_storage.remove_single(user, random)
	user.put_in_hands(random)
	return SECONDARY_ATTACK_CANCEL_ATTACK_CHAIN

/obj/item/storage/get_dumping_location()
	return src

/obj/item/storage/AllowDrop()
	return FALSE

/obj/item/storage/contents_explosion(severity, target)
	for(var/atom/A in contents)
		A.ex_act(severity, target)
		CHECK_TICK

/obj/item/storage/canStrip(mob/who)
	. = ..()
	if(!. && rummage_if_nodrop)
		return TRUE

/obj/item/storage/doStrip(mob/who)
	if(HAS_TRAIT(src, TRAIT_NODROP) && rummage_if_nodrop)
		atom_storage.remove_all()
		return TRUE
	return ..()

//Cyberboss says: "USE THIS TO FILL IT, NOT INITIALIZE OR NEW"
/**
 * Populate contents of this storage item.
 *
 * Create items with a loc of src (new thing(src)) to have it put inside atom storage.
 *
 * We use this so we can control its timing and provide something that doesn't clash with inheritance.
 *
 * It also allows for logic like prob().
 */
/obj/item/storage/proc/populate_contents()
	return
