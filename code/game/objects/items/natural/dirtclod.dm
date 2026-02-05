/obj/item/natural/dirtclod
	name = "clod"
	desc = "A handful of sod."
	icon_state = "clod1"
	dropshrink = 0
	throwforce = 0
	w_class = WEIGHT_CLASS_TINY

/obj/item/natural/dirtclod/Initialize()
	. = ..()
	icon_state = "clod[rand(1,2)]"

/obj/item/natural/dirtclod/attackby(obj/item/W, mob/user, list/modifiers)
	if(istype(W, /obj/item/weapon/shovel))
		var/obj/item/weapon/shovel/S = W
		if(!S.heldclod && user.used_intent.type == /datum/intent/shovelscoop)
			playsound(src,'sound/items/dig_shovel.ogg', 100, TRUE)
			src.forceMove(S)
			S.heldclod = src
			W.update_appearance(UPDATE_ICON_STATE)
			return
	return ..()

/obj/item/natural/dirtclod/Moved(oldLoc, dir)
	..()
	if(isturf(loc))
		var/turf/T = loc
		for(var/obj/structure/fluff/clodpile/C in T)
			C.dirtamt = min(C.dirtamt+1, 5)
			qdel(src)
			return
		var/dirtcount = 1
		var/list/dirts = list()
		for(var/obj/item/natural/dirtclod/D in T)
			dirtcount++
			dirts += D
		if(dirtcount >=5)
			for(var/obj/item/I in dirts)
				qdel(I)
			qdel(src)
			new /obj/structure/fluff/clodpile(T)

/obj/item/natural/dirtclod/attack_self(mob/living/user, list/modifiers)
	user.visible_message("<span class='warning'>[user] scatters [src].</span>")
	qdel(src)

/obj/structure/fluff/clodpile
	name = "dirt pile"
	desc = "A collection of dirt, amalgamated into a mighty structure incomparable to any creation made by man or god alike."
	icon = 'icons/roguetown/items/natural.dmi'
	icon_state = "clodpile"
	var/dirtamt = 5
	climbable = FALSE
	density = FALSE
	climb_offset = 10

/obj/structure/fluff/clodpile/Initialize()
	. = ..()
	dir = pick(GLOB.cardinals)

/obj/structure/fluff/clodpile/attackby(obj/item/W, mob/user, list/modifiers)
	if(istype(W, /obj/item/weapon/shovel))
		var/obj/item/weapon/shovel/S = W
		if(user.used_intent.type == /datum/intent/shovelscoop)
			if(!S.heldclod)
				playsound(src,'sound/items/dig_shovel.ogg', 100, TRUE)
				var/obj/item/J = new /obj/item/natural/dirtclod(S)
				S.heldclod = J
				W.update_appearance(UPDATE_ICON_STATE)
				dirtamt--
				if(dirtamt <= 0)
					qdel(src)
				return
			else
				playsound(src,'sound/items/empty_shovel.ogg', 100, TRUE)
				var/obj/item/I = S.heldclod
				S.heldclod = null
				qdel(I)
				W.update_appearance(UPDATE_ICON_STATE)
				dirtamt++
				if(dirtamt > 5)
					dirtamt = 5
				return
	return ..()
