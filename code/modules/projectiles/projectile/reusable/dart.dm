/obj/projectile/bullet/reusable/dart
	name = "dart"
	desc = "A thorn fashioned into a primitive dart."
	icon = 'icons/roguetown/weapons/ammo.dmi'
	icon_state = "dart_proj"
	ammo_type = /obj/item/ammo_casing/caseless/dart
	range = 6
	hitsound = 'sound/combat/hits/hi_arrow2.ogg'
	embedchance = 100
	woundclass = BCLASS_STAB
	damage = 20
	speed = 0.3
	accuracy = 50
	var/piercing = FALSE

/obj/projectile/bullet/reusable/dart/Initialize(mapload, ...)
	. = ..()
	create_reagents(50, NO_REACT)

/obj/projectile/bullet/reusable/dart/on_hit(atom/target, blocked = FALSE)
	if(iscarbon(target))
		var/mob/living/carbon/M = target
		var/armor = M.run_armor_check(def_zone, flag, "", "",armor_penetration, damage)
		var/armor_real_check = max(0, armor - damage)
		if(armor_real_check == 0)
			if(M.can_inject(null, FALSE, def_zone, piercing)) // Pass the hit zone to see if it can inject by whether it hit the head or the body.
				..()
				reagents.reaction(M, INJECT)
				reagents.trans_to(M, reagents.total_volume)
				return BULLET_ACT_HIT
			else
				blocked = 100
				target.visible_message(	span_danger("\The [src] was deflected!"), span_danger("My armor protected me against \the [src]!"))

	..(target, blocked)
	DISABLE_BITFIELD(reagents.flags, NO_REACT)
	reagents.handle_reactions()
	return BULLET_ACT_HIT

/obj/projectile/bullet/reusable/dart/poison
	name = "poison dart"
	desc = "A dart with its tip coated in a weak poison."
	icon_state = "dartpoison_proj"
	ammo_type = /obj/item/ammo_casing/caseless/dart/poison
