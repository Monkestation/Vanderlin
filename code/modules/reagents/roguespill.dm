/obj/item/storage/equipped(mob/user, slot)
	. = ..()
	for(var/obj/item/reagent_containers/I in contents)
		if(I.reagents && I.spillable)
			RegisterSignal(user, COMSIG_MOVABLE_MOVED, PROC_REF(check_spill), override = TRUE)
			break

/obj/item/storage/proc/check_spill()
	var/mob/living/L = loc
	if(istype(L))
		for(var/obj/item/reagent_containers/I in contents)
			if(I.reagents && I.spillable)
				I.reagents.remove_all(3)

/obj/item/storage/dropped(mob/user)
	. = ..()
	if(user)
		UnregisterSignal(user, COMSIG_MOVABLE_MOVED)

/obj/item/reagent_containers/on_enter_storage(datum/storage/atom_storage)
	. = ..()
	if(!atom_storage || !spillable)
		return

	if(!isitem(atom_storage.real_location))
		return

	var/mob/living/storage_loc = atom_storage.real_location.loc

	if(!istype(storage_loc))
		return

	atom_storage.real_location.RegisterSignal(storage_loc, COMSIG_MOVABLE_MOVED, TYPE_PROC_REF(/obj/item/storage, check_spill), override = TRUE)
