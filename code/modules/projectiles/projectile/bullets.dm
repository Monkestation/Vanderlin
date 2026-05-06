/obj/projectile/bullet
	name = "bullet"
	icon_state = "bullet"
	damage = 60
	pass_flags = PASSTABLE | PASSGRILLE
	damage_type = BRUTE
	nodamage = FALSE
	flag =  "piercing"
	hitsound_wall = "ricochet"
	impact_effect_type = /obj/effect/temp_visual/impact_effect

/obj/projectile/bullet/pellet
	name = "pellet"
	damage = 15
	armor_penetration = 100
	speed = 0.6
	woundclass = BCLASS_SHOT
