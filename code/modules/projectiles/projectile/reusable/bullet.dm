#define BULLET_DAMAGE 80
#define BULLET_PENETRATION 100

/obj/projectile/bullet/reusable/bullet
	name = "lead ball"
	desc = "A round lead shot, simple and spherical."
	damage = BULLET_DAMAGE
	damage_type = BRUTE
	icon = 'icons/roguetown/weapons/ammo.dmi'
	icon_state = "musketball_proj"
	ammo_type = /obj/item/ammo_casing/caseless/bullet
	range = 15
	jitter = 5
	eyeblur = 3
	hitsound = 'sound/combat/hits/hi_bolt (2).ogg'
	embedchance = 100
	woundclass = BCLASS_SHOT
	impact_effect_type = /obj/effect/temp_visual/impact_effect
	flag =  "piercing"
	armor_penetration = BULLET_PENETRATION
	speed = 0.3
	accuracy = 50 //Lower accuracy than an arrow.
	dismemberment = 0 //Can't dismember

/obj/projectile/bullet/reusable/bullet/on_hit(atom/target)
	. = ..()
	if(!ismob(target) || !firer)
		return

	var/mob/living/target_mob = target

	var/atom/throw_target = get_edge_target_turf(firer, get_dir(firer, target_mob))
	target_mob.safe_throw_at(throw_target, 1, 4)
	target_mob.Knockdown(SHOVE_KNOCKDOWN_SOLID)

	if(get_dist(firer, target_mob) > 3)
		return

	if(!iscarbon(target_mob))
		return

	var/mob/living/carbon/C = target_mob
	var/obj/item/bodypart/BP = C.get_bodypart(def_zone)
	if(BP)
		var/fracture_type = /datum/wound/fracture
		switch(BP.body_zone)
			if(BODY_ZONE_HEAD)
				fracture_type = /datum/wound/fracture/head
			if(BODY_ZONE_CHEST)
				fracture_type = /datum/wound/fracture/chest
		BP.add_wound(fracture_type)

/obj/projectile/bullet/fragment
	name = "smaller lead ball"
	desc = "Haha. You're not able to see this!"
	damage = 25
	damage_type = BRUTE
	woundclass = BCLASS_SHOT
	range = 30
	jitter = 5
	eyeblur = 3
	stun = 1
	icon = 'icons/roguetown/weapons/ammo.dmi'
	icon_state = "musketball_proj"
	ammo_type = /obj/item/ammo_casing/caseless/cball/grapeshot
	impact_effect_type = /obj/effect/temp_visual/impact_effect
	flag =  "piercing"
	armor_penetration = BULLET_PENETRATION
	speed = 0.5

/obj/projectile/bullet/reusable/cannonball
	name = "large lead ball"
	desc = "A round lead ball. Complex and still spherical."
	icon = 'icons/roguetown/weapons/ammo.dmi'
	icon_state = "cannonball"
	damage = 9999
	damage_type = BRUTE
	ammo_type = /obj/item/ammo_casing/caseless/cball
	range = 50
	jitter = 5
	stun = 1
	hitsound = 'sound/combat/hits/hi_bolt (2).ogg'
	embedchance = 0
	dismemberment = 500
	spread = 0
	woundclass = BCLASS_SMASH
	impact_effect_type = /obj/effect/temp_visual/impact_effect
	flag =  "piercing"
	hitscan = FALSE
	armor_penetration = BULLET_PENETRATION
	speed = 2
	resistance_flags = EVERYTHING_PROOF

/obj/projectile/bullet/reusable/cannonball/on_hit(atom/target, blocked = FALSE)
	var/turf/explosion_place = get_turf(target)
	if(isindestructiblewall(target))
		explosion_place = get_step(target, get_dir(target, fired_from))
	. = ..()
	if(iscarbon(target))
		var/mob/living/carbon/M = target
		M.gib()
	explosion(explosion_place, devastation_range = 2, heavy_impact_range = 4, light_impact_range = 12, flame_range = 7, smoke = TRUE, soundin = pick('sound/misc/explode/bottlebomb (1).ogg','sound/misc/explode/bottlebomb (2).ogg'))

#undef BULLET_DAMAGE
#undef BULLET_PENETRATION
