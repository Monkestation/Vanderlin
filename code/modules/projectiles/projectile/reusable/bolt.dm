#define BOLT_DAMAGE	44
#define BOLT_PENETRATION 50

/obj/projectile/bullet/reusable/bolt
	name = "bolt"
	desc = "A small and sturdy bolt, with simple plume and metal tip, alongside a groove to load onto a crossbow."
	icon = 'icons/roguetown/weapons/ammo.dmi'
	icon_state = "bolt_proj"
	damage = BOLT_DAMAGE
	damage_type = BRUTE
	ammo_type = /obj/item/ammo_casing/caseless/bolt
	range = 30
	hitsound = 'sound/combat/hits/hi_arrow2.ogg'
	embedchance = 100
	armor_penetration = BOLT_PENETRATION
	woundclass = BCLASS_PIERCE
	flag =  "piercing"
	speed = 0.3
	accuracy = 85 //Crossbows have higher accuracy
	var/piercing = FALSE
	var/can_inject = TRUE

/obj/projectile/bullet/reusable/bolt/Initialize(mapload, ...)
	. = ..()
	create_reagents(50, NO_REACT)

/obj/projectile/bullet/reusable/bolt/on_hit(atom/target, blocked = FALSE)
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
				target.visible_message("<span class='danger'>\The [src] was deflected!</span>", \
									   "<span class='danger'>My armor protected me against \the [src]!</span>")

	..(target, blocked)
	DISABLE_BITFIELD(reagents.flags, NO_REACT)
	reagents.handle_reactions()
	return BULLET_ACT_HIT

/obj/item/ammo_casing/caseless/bolt/vial
	abstract_type = /obj/item/ammo_casing/caseless/bolt/vial
	name = "vial bolt"
	desc = "A bolt with its tip replaced by a vial of... something, shatters on impact."
	icon_state = "bolt_vial"
	max_integrity = 10
	possible_item_intents = list(/datum/intent/hit)
	force = DAMAGE_KNIFE - 2
	var/datum/reagent/reagent

/obj/item/ammo_casing/caseless/bolt/vial/Initialize(mapload, ...)
	. = ..()
	RemoveElement(/datum/element/tipped_item)
	update_appearance(UPDATE_OVERLAYS)

/obj/item/ammo_casing/caseless/bolt/vial/update_overlays()
	. = ..()
	if(reagent)
		var/mutable_appearance/filling = mutable_appearance(icon, "[icon_state]_filling")
		filling.color = initial(reagent.color)
		. += filling

/obj/item/ammo_casing/caseless/bolt/vial/water
	projectile_type = /obj/projectile/bullet/reusable/bolt/vial/water
	reagent = /datum/reagent/water

/obj/projectile/bullet/reusable/bolt/pyro
	name = "pyroclastic bolt"
	desc = "A bolt smeared with a flammable tincture."
	icon_state = "boltpyro_proj"
	range = 15
	ammo_type = null
	can_inject = FALSE
	hitsound = 'sound/blank.ogg'
	embedchance = 0
	woundclass = BCLASS_BLUNT
	damage = BOLT_DAMAGE-20
	armor_penetration = BOLT_PENETRATION-30
	var/explode_sound = list('sound/misc/explode/incendiary (1).ogg','sound/misc/explode/incendiary (2).ogg')

/obj/projectile/bullet/reusable/bolt/pyro/on_hit(target)
	. = ..()
	if(ismob(target))
		var/mob/living/M = target
		M.fire_act(6)
	explosion(get_turf(target), -1, flame_range = 2, soundin = explode_sound)

/obj/projectile/bullet/reusable/bolt/vial
	name = "vial bolt"
	desc = "A bolt with its tip replaced by a vial of... something, shatters on impact."
	icon_state = "boltvial_proj"
	abstract_type = /obj/projectile/bullet/reusable/bolt/vial
	ammo_type = null
	can_inject = FALSE
	embedchance = 0
	woundclass = BCLASS_CUT
	damage = BOLT_DAMAGE-15
	armor_penetration = BOLT_PENETRATION-25
	var/datum/reagent/reagent

/obj/projectile/bullet/reusable/bolt/vial/Initialize(mapload, ...)
	. = ..()
	if(reagent)
		reagents?.add_reagent(reagent, 15)

/obj/projectile/bullet/reusable/bolt/vial/on_hit(target)
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

/obj/projectile/bullet/reusable/bolt/vial/water
	desc = "A bolt with its tip replaced by a vial of water, shatters on impact."
	reagent = /datum/reagent/water

/obj/item/ammo_casing/caseless/bolt/water
	name = "water bolt"
	desc = "A bolt with its tip replaced by a water crystal, creates a splash on impact."
	icon_state = "bolt_water"
	projectile_type = /obj/projectile/bullet/reusable/bolt/water
	max_integrity = 10
	force = DAMAGE_KNIFE - 2

/obj/item/ammo_casing/caseless/bolt/water/Initialize(mapload, ...)
	. = ..()
	RemoveElement(/datum/element/tipped_item)

/obj/projectile/bullet/reusable/bolt/water
	name = "water bolt"
	desc = "A bolt with its tip replaced by a water crystal, creates a splash on impact."
	icon_state = "boltwater_proj"
	ammo_type = null
	can_inject = FALSE
	woundclass = BCLASS_BLUNT
	damage = BOLT_DAMAGE-9
	armor_penetration = BOLT_PENETRATION-15
	embedchance = 0

/obj/projectile/bullet/reusable/bolt/water/Initialize(mapload, ...)
	. = ..()
	reagents.add_reagent(/datum/reagent/water, 25)

/obj/projectile/bullet/reusable/bolt/water/on_hit(target)
	var/target_loc = get_turf(src)
	if(ismob(target))
		target_loc = get_turf(target)
	chem_splash(target_loc, 3, list(reagents))
	return ..()

/obj/projectile/bullet/reusable/bolt/holy
	name = "sunderbolt"
	icon_state = "bolthwater_proj"
	damage = 35 //Halved damage, but same penetration.
	ammo_type = /obj/item/ammo_casing/caseless/bolt/holy
	range = 15
	speed = 0.5

#undef BOLT_DAMAGE
#undef BOLT_PENETRATION
