#define ARROW_DAMAGE 33
#define ARROW_PENETRATION 25

/obj/projectile/bullet/reusable/arrow
	name = "arrow"
	desc = "A fletched projectile, with simple plumes and metal tip."
	icon = 'icons/roguetown/weapons/ammo.dmi'
	icon_state = "arrow_proj"
	damage = ARROW_DAMAGE
	damage_type = BRUTE
	ammo_type = /obj/item/ammo_casing/caseless/arrow
	range = 30
	hitsound = 'sound/combat/hits/hi_arrow2.ogg'
	embedchance = 100
	armor_penetration = ARROW_PENETRATION
	woundclass = BCLASS_PIERCE
	flag =  "piercing"
	speed = 0.4
	var/piercing = FALSE
	var/can_inject = TRUE

/obj/projectile/bullet/reusable/arrow/Initialize(mapload, ...)
	. = ..()
	create_reagents(50, NO_REACT)

/obj/projectile/bullet/reusable/arrow/on_hit(atom/target, blocked = FALSE)
	if(can_inject && iscarbon(target))
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

/obj/projectile/bullet/reusable/arrow/stone
	ammo_type = /obj/item/ammo_casing/caseless/arrow/stone
	embedchance = 80
	armor_penetration = 0
	damage = ARROW_DAMAGE-2
	woundclass = BCLASS_STAB

/obj/projectile/bullet/reusable/arrow/pyro
	name = "pyroclastic arrow"
	desc = "An arrow with its tip smeared with a flammable tincture."
	icon_state = "arrowpyro_proj"
	ammo_type = null
	can_inject = FALSE
	range = 15
	hitsound = null
	embedchance = 0
	woundclass = BCLASS_BLUNT
	damage = ARROW_DAMAGE-15
	armor_penetration = ARROW_PENETRATION-15
	var/explode_sound = list('sound/misc/explode/incendiary (1).ogg','sound/misc/explode/incendiary (2).ogg')

/obj/projectile/bullet/reusable/arrow/pyro/on_hit(target)
	. = ..()
	if(ismob(target))
		var/mob/living/M = target
		M.fire_act(6)
	explosion(get_turf(target), -1, flame_range = 2, soundin = explode_sound)

/obj/projectile/bullet/reusable/arrow/vial
	abstract_type = /obj/projectile/bullet/reusable/arrow/vial
	name = "vial arrow"
	desc = "An arrow with its tip replaced by a vial of... something, shatters on impact."
	icon_state = "arrowvial_proj"
	ammo_type = null
	can_inject = FALSE
	embedchance = 0
	woundclass = BCLASS_CUT
	damage = ARROW_DAMAGE-15
	armor_penetration = ARROW_PENETRATION-20
	var/datum/reagent/reagent

/obj/projectile/bullet/reusable/arrow/vial/Initialize(mapload, ...)
	. = ..()
	if(reagent)
		reagents?.add_reagent(reagent, 15)

/obj/projectile/bullet/reusable/arrow/vial/on_hit(target)
	var/target_loc = get_turf(src)
	if(iscarbon(target))
		var/mob/living/carbon/C = target
		target_loc = get_turf(C)
		var/obj/item/bodypart/BP = C.get_bodypart(def_zone)
		BP.add_embedded_object(new /obj/item/natural/glass/shard())
	new /obj/effect/decal/cleanable/debris/glass(target_loc)
	playsound(target_loc, "glassbreak", 30, TRUE, -3)
	chem_splash(target_loc, 2, list(reagents))
	return ..()

/obj/projectile/bullet/reusable/arrow/vial/water
	desc = "An arrow with its tip replaced by a vial of water, shatters on impact."
	reagent = /datum/reagent/water

/obj/projectile/bullet/reusable/arrow/water
	name = "water arrow"
	desc = "An arrow with its tip replaced by a water crystal, creates a splash on impact."
	icon_state = "arrowwater_proj"
	ammo_type = null
	can_inject = FALSE
	woundclass = BCLASS_BLUNT
	damage = ARROW_DAMAGE-8
	armor_penetration = ARROW_PENETRATION-10
	embedchance = 0

/obj/projectile/bullet/reusable/arrow/water/Initialize(mapload, ...)
	. = ..()
	reagents.add_reagent(/datum/reagent/water, 25)

/obj/projectile/bullet/reusable/arrow/water/on_hit(target)
	var/target_loc = get_turf(src)
	if(ismob(target))
		target_loc = get_turf(target)
	chem_splash(target_loc, 3, list(reagents))
	return ..()

/obj/projectile/bullet/reusable/arrow/bone
	ammo_type = /obj/item/ammo_casing/caseless/arrow/bone
	embedchance = 95
	armor_penetration = 15

#undef ARROW_DAMAGE
#undef ARROW_PENETRATION
