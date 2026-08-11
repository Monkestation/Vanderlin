/obj/structure/toilet
	name = "toilet"
	desc = ""
	icon = 'icons/roguetown/misc/structure.dmi'
	icon_state = "toilet"
	density = FALSE
	anchored = TRUE

/obj/structure/toilet/Initialize(mapload)
	. = ..()
	create_storage(type = /datum/storage/no_interface/toilet)

/obj/structure/toilet/attack_hand(mob/living/user, list/modifiers)
	. = ..()
	if(.)
		return

	if(!length(atom_storage?.return_inv(recursive = FALSE)))
		to_chat(user, span_notice("The toilet is empty."))
		return

	var/obj/item/I = atom_storage.remove_single_random(user, get_turf(user))
	if(!I)
		return
	user.put_in_hands(I)
	to_chat(user, span_notice("I find [I] in the toilet."))

/// Toilet that spawns containing a random amount of what you'd expect
/obj/structure/toilet/filled
	var/spawn_list = list(
		/obj/item/natural/poo = 90,
		/obj/item/coin/copper = 7,
		/obj/item/coin/silver = 2,
		/obj/item/coin/gold = 1
		)

/obj/structure/toilet/filled/Initialize(mapload)
	. = ..()
	for(var/i in 1 to rand(0, 5))
		var/obj/item/pickeditem = pickweight(spawn_list)
		var/obj/item/spawnitem = new pickeditem(get_turf(src))
		if(!atom_storage?.attempt_insert(spawnitem, override = TRUE))
			qdel(spawnitem)
