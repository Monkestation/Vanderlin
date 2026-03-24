/obj/machinery/loom
	icon = 'icons/roguetown/misc/structure.dmi'
	name = "loom"
	desc = "A wooden frame with taut threads ready to weave fabric."
	icon_state = "loom"
	max_integrity = 200
	density = TRUE

	var/storedfiber = 0
	var/maxfiber = 50

/obj/machinery/loom/item_interaction(mob/living/user, obj/item/tool, list/modifiers)
	if(istype(tool, /obj/item/natural/bundle/fibers))
		var/obj/item/natural/bundle/fibers/W = tool
		if(storedfiber + W.amount > maxfiber)
			W.amount = (W.amount - (maxfiber - storedfiber))
			to_chat(user, "You string some fiber onto [src].")
			storedfiber = maxfiber
			if(W.amount == 1)
				new /obj/item/natural/fibers(get_turf(user))
				qdel(W)
		else
			storedfiber = storedfiber + W.amount
			to_chat(user, "You string some fiber onto [src].")
			qdel(W)

		return ITEM_INTERACT_SUCCESS

	if(istype(tool, /obj/item/natural/fibers))
		var/obj/item/natural/fibers/W = tool
		if(storedfiber < maxfiber)
			storedfiber++
			to_chat(user, "You string a fiber onto [src].")
			qdel(W)
		else
			to_chat(user, "You can't add any more fiber.")

		return ITEM_INTERACT_SUCCESS

/obj/machinery/loom/attack_hand_secondary(mob/user, list/modifiers)
	. = ..()
	if(. == SECONDARY_ATTACK_CANCEL_ATTACK_CHAIN)
		return
	var/mob/living/L = user
	if(isliving(user) && L.stat == CONSCIOUS && !user.get_active_held_item())
		if(storedfiber > 0)
			to_chat(user, "You remove a strand from [src].")
			storedfiber--
			var/obj/item/natural/fibers/F = new (loc)
			L.put_in_hands(F)
		else
			to_chat(user, "There's nothing to take from [src].")

		return SECONDARY_ATTACK_CANCEL_ATTACK_CHAIN

/obj/machinery/loom/attack_hand(mob/user, list/modifiers)
	var/mob/living/weaver = user
	var/weavetime = 2 SECONDS //time to weave a cloth, duh
	var/skilltimemod = 0.2 SECONDS //how much each level of skill lowers the time to weave
	var/skill = GET_MOB_SKILL_VALUE_OLD(weaver, /datum/attribute/skill/misc/sewing)
	if(isliving(user) && weaver.stat == CONSCIOUS)
		if(storedfiber < 2)
			to_chat(user, "You don't have enough fiber to do this.")
		else
			to_chat(user, "You start weaving some cloth...")
			while(storedfiber > 1)
				if(!do_after(weaver, (weavetime - (skilltimemod*skill)), src) || storedfiber < 2)
					break
				storedfiber -= 2
				new /obj/item/natural/cloth(get_turf(src))
				weaver.mind.add_sleep_experience(/datum/attribute/skill/misc/sewing, (GET_MOB_ATTRIBUTE_VALUE(weaver, STAT_INTELLIGENCE)*0.5))//you get less exp from using the loom

/obj/machinery/loom/examine(mob/user)
	to_chat(user, span_notice("There are [storedfiber] strands of fiber strung on [src]."))
	. = ..()
