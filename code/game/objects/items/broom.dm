/obj/item/broom
	name = "broom"
	desc = "A broom, made from a bundle of twigs."
	icon = 'icons/roguetown/weapons/tools.dmi'
	icon_state = "broom"
	possible_item_intents = list(/datum/intent/use)
	gripped_intents = list(/datum/intent/use, /datum/intent/mace/strike/wood)
	force = 2
	force_wielded = 4
	throwforce = 1
	firefuel = 10 MINUTES
	resistance_flags = FLAMMABLE
	slot_flags = ITEM_SLOT_BACK
	smeltresult = /obj/item/ash

/obj/item/broom/Initialize()
	. = ..()
	AddComponent(/datum/component/walking_stick)

/obj/item/broom/getonmobprop(tag)
	. = ..()
	if(tag)
		switch(tag)
			if("gen")
				return list("shrink" = 0.6,"sx" = -6,"sy" = -1,"nx" = 8,"ny" = 0,"wx" = -4,"wy" = 0,"ex" = 2,"ey" = 1,"northabove" = 0,"southabove" = 1,"eastabove" = 1,"westabove" = 0,"nturn" = -38,"sturn" = 37,"wturn" = 32,"eturn" = -23,"nflip" = 0,"sflip" = 8,"wflip" = 8,"eflip" = 0)
			if("wielded")
				return list("shrink" = 0.6,"sx" = 4,"sy" = -2,"nx" = -3,"ny" = -2,"wx" = -5,"wy" = -1,"ex" = 3,"ey" = -2,"northabove" = 0,"southabove" = 1,"eastabove" = 1,"westabove" = 0,"nturn" = 7,"sturn" = -7,"wturn" = 16,"eturn" = -22,"nflip" = 8,"sflip" = 0,"wflip" = 8,"eflip" = 0)
			if("onback")
				return list("shrink" = 0.5,"sx" = -1,"sy" = 2,"nx" = 0,"ny" = 2,"wx" = 2,"wy" = 1,"ex" = 0,"ey" = 1,"nturn" = 0,"sturn" = 0,"wturn" = 70,"eturn" = 15,"nflip" = 1,"sflip" = 1,"wflip" = 1,"eflip" = 1,"northabove" = 1,"southabove" = 0,"eastabove" = 0,"westabove" = 0)

/obj/item/broom/attack_obj(obj/O, mob/living/user)
	if(do_after(user, 3 SECONDS, O))
		if(istype(O, /obj/effect/decal/cleanable/dirt))
			user.visible_message("<span class='notice'>[user] sweeps \the [O.name].</span>", "<span class='notice'>I sweep \the [O.name].</span>")
			playsound(user, "clothwipe", 100, TRUE)
			qdel(O)
		if(istype(O, /obj/effect/decal/cleanable/blood))
			add_blood_DNA(O.return_blood_DNA())
			return

/obj/item/broom/attack_turf(turf/T, mob/living/user)
	if(do_after(user, 3 SECONDS, T))
		if(istype(T, /turf/open/water))
			..()
		for(var/obj/effect/decal/cleanable/dirt/C in T)
			user.visible_message("<span class='notice'>[user] sweeps \the [T.name].</span>", "<span class='notice'>I sweep \the [T.name].</span>")
			playsound(user, "clothwipe", 100, TRUE)
			qdel(C)
		for(var/obj/effect/decal/cleanable/blood/O in T)
			add_blood_DNA(O.return_blood_DNA())
			return
