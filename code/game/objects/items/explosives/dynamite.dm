/obj/projectile/bullet/gel
	name = "Searing gel"
	desc = "How can you see this?"
	damage = 45
	damage_type = BURN
	woundclass = BCLASS_SHOT
	range = 3
	impact_effect_type = /obj/effect/temp_visual/impact_effect
	flag =  "piercing"
	speed = 1
	reduce_crit_chance = 1
	var/explode_sound = list('sound/misc/explode/incendiary (1).ogg','sound/misc/explode/incendiary (2).ogg')

/obj/projectile/bullet/gel/on_hit(target)
	. = ..()
	if(ismob(target))
		var/mob/living/M = target
		M.fire_act(10)
	explosion(get_turf(target), -1, flame_range = 5, soundin = explode_sound)

/obj/item/explosive/dynamite
	name = "Blasting gel"
	desc = "Blasting gel, a rare and hard to make explosive, which has been contained in a grenade shell. The shrapnel slots on the canister have been filled with hardening gel, meant to send light weight explosive everywhere in sight. It is oozing out of the cap and seems unstable..."
	icon_state = "dynamite"
	icon = 'icons/obj/bombs.dmi'
	w_class = WEIGHT_CLASS_NORMAL
	throwforce = 0
	slot_flags = ITEM_SLOT_HIP
	grid_height = 64
	grid_width = 32
	impact_explode = TRUE

	prob2fail = 1

	ex_dev = 4
	ex_heavy = 5
	ex_light = 6
	ex_flame = 10
	ex_smoke = 3

	shrapnel_type = /obj/projectile/bullet/gel
	shrapnel_radius = 3
	det_time = 4 SECONDS
