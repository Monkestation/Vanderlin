/obj/structure/toilet
	name = "toilet"
	desc = ""
	icon = 'icons/roguetown/misc/structure.dmi'
	icon_state = "toilet"
	density = FALSE
	anchored = TRUE
	//var/buildstacktype
	//var/buildstackamount = 1

/obj/structure/toilet/Initialize()
	. = ..()
	AddComponent(/datum/component/storage/concrete/toilet)

/obj/structure/toilet/attack_hand(mob/living/user)
	. = ..()
	if(.)
		return

	var/datum/component/storage/STR = GetComponent(/datum/component/storage/concrete/toilet)
	var/list/things = STR.contents()
	if(!length(things))
		to_chat(user, span_notice("The toilet is empty."))
		return
	var/obj/item/I = pick(things)
	STR.remove_from_storage(I, get_turf(user))
	user.put_in_hands(I)
	to_chat(user, span_notice("I find [I] in the toilet."))

/* /obj/structure/toilet/deconstruct()
	if(!(flags_1 & NODECONSTRUCT_1))
		if(buildstacktype)
			new buildstacktype(loc,buildstackamount)
	..() */

/// Toilet that spawns containing a random amount of what you'd expect
/obj/structure/toilet/filled
	var/spawn_list = list(
		/obj/item/natural/poo = 90,
		/obj/item/coin/copper = 7,
		/obj/item/coin/silver = 2,
		/obj/item/coin/gold = 1
		)

/obj/structure/toilet/filled/Initialize()
	. = ..()
	var/numitems = rand(0,5)
	if(numitems)
		for(var/i in 1 to numitems)
			var/obj/item/pickeditem = pickweight(spawn_list)
			var/obj/item/spawnitem = new pickeditem(get_turf(src))
			if(!SEND_SIGNAL(src, COMSIG_TRY_STORAGE_INSERT, spawnitem))
				qdel(spawnitem)
