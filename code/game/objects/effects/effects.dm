
//objects in /obj/effect should never be things that are attackable, use obj/structure instead.
//Effects are mostly temporary visual effects like sparks, smoke, as well as decals, etc...
/obj/effect
	icon = 'icons/effects/effects.dmi'
	resistance_flags = INDESTRUCTIBLE | LAVA_PROOF | FIRE_PROOF | UNACIDABLE | ACID_PROOF | FREEZE_PROOF
	move_resist = INFINITY
	obj_flags = NONE
	anchored = TRUE
	density = FALSE
	uses_integrity = FALSE

/obj/effect/attack_generic(mob/user, damage_amount, damage_type, damage_flag, sound_effect, armor_penetration)
	return

/obj/effect/take_damage(damage_amount, damage_type = BRUTE, damage_flag = 0, sound_effect = 1, attack_dir)
	return

/obj/effect/fire_act(added, maxstacks)
	return

/obj/effect/acid_act()
	return

/obj/effect/ex_act(severity, target)
	if(target == src)
		qdel(src)
	else
		switch(severity)
			if(1)
				qdel(src)
			if(2)
				if(prob(60))
					qdel(src)
			if(3)
				if(prob(25))
					qdel(src)


/obj/effect/ConveyorMove()
	return

/obj/effect/abstract/ex_act(severity, target)
	return

/obj/effect/abstract/faux_density
	name = ""
	desc = ""
	mouse_opacity = MOUSE_OPACITY_TRANSPARENT
	density = TRUE
