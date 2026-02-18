/obj/item/natural/chaff
	name = "chaff"
	desc = "Grain that has not yet been made suitable for grinding and baking."
	icon = 'icons/roguetown/items/produce.dmi'
	icon_state = "chaff1"
	var/foodextracted = null
	var/canthresh = TRUE

/obj/item/natural/chaff/attack_hand_secondary(mob/user, list/modifiers)
	. = ..()
	if(. == SECONDARY_ATTACK_CANCEL_ATTACK_CHAIN)
		return
	if(foodextracted)
		to_chat(user, span_warning("I start to shuck [src]..."))
		if(do_after(user, 4 SECONDS, src))
			user.visible_message(span_notice("[user] shucks [src]."), \
								span_notice("I shuck [src]."))
			var/obj/item/G = new foodextracted(get_turf(src))
			G.set_quality(recipe_quality)
			user.put_in_active_hand(G)
			new /obj/item/natural/fibers(get_turf(src))
			qdel(src)
		return SECONDARY_ATTACK_CANCEL_ATTACK_CHAIN

/obj/item/natural/chaff/proc/thresh()
	if(foodextracted && canthresh)
		var/obj/item/extracted = new foodextracted(loc)
		extracted.set_quality(recipe_quality)
		new /obj/item/natural/fibers(loc)
		qdel(src)

/obj/item/natural/chaff/attackby(obj/item/I, mob/living/user, list/modifiers)
	if(istype(I, /obj/item/weapon/pitchfork))
		if(user.used_intent.type == DUMP_INTENT)
			var/obj/item/weapon/pitchfork/W = I
			if(HAS_TRAIT(I, TRAIT_WIELDED))
				if(isturf(loc))
					var/stuff = 0
					for(var/obj/item/natural/chaff/R in loc)
						if(W.forked.len <= 19)
							R.forceMove(W)
							W.forked += R
							stuff++
					if(stuff)
						to_chat(user, span_notice("I pick up the stalks with the pitchfork."))
						W.icon_state = "[initial(W.icon_state)]stuff"
					else
						to_chat(user, span_warning("I'm carrying enough with the pitchfork."))
					return

	if(istype(I, /obj/item/weapon/mace/woodclub))//reused some commented out code
		var/statboost = user.STASTR*3 + (user?.get_skill_level(/datum/skill/labor/farming, TRUE)*5) //a person with no skill and 10 strength will thresh about a third of the stalks on average
		var/threshchance = clamp(statboost, 20, 100)
		for(var/obj/item/natural/chaff/C in get_turf(src))
			if(C == src)//so it doesnt delete itself and stop the loop
				continue
			if(prob(threshchance))
				C.thresh()
		user.visible_message(span_notice("[user] threshes the stalks!"), \
							span_notice("I thresh the stalks."))
		user.changeNext_move(CLICK_CD_MELEE)
		playsound(src,"plantcross", 100, FALSE)
		playsound(src,"smashlimb", 50, FALSE)
		src.thresh()
		return
	..()

/obj/item/natural/chaff/wheat
	icon_state = "wheatchaff"
	name = "wheat stalks"
	foodextracted = /obj/item/reagent_containers/food/snacks/produce/grain/wheat
	dropshrink = 0.8

/obj/item/natural/chaff/oat
	name = "oat stalks"
	icon_state = "oatchaff"
	foodextracted = /obj/item/reagent_containers/food/snacks/produce/grain/oat
/*
/obj/item/natural/chaff/rice
	name = "rice stalks"
	icon_state = "ricechaff"
	foodextracted = /obj/item/reagent_containers/food/snacks/produce/rice
*/
